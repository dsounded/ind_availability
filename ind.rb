require 'httparty'
require 'date'
require 'json'

TARGET_DATE_TO = Date.new(2022, 8, 1)

def next_month
  m = Date.today.month
  y = Date.today.year
  new_m = m == 12 ? 1 : m + 1
  new_y = m == 12 ? y + 1 : y
  first = Date.new(y, m, 26)
end

PRODUCT_MAP = {
  'DOC' => 'Collection a permit',
  'VAA' => 'Getting a sticker'
}
LOCATION_MAP = {
  'AM' => 'Amsterdam',
  'DH' => 'Den Haag',
  'ZW' => 'Zwolle',
  'DB' => 'Den Bosch'
}

SCHEMA = {
  'DOC' => ['AM'],
  # 'VAA' => ['AM', 'DH', 'ZW', 'DB']
}
WAIT_TIME = 10 # in seconds
LAST_NAME = 'EXAMPLE_NAME'
V_NUMBER = 'EXAMPLE_N'
PHONE = 'EXAMPLE_PHONE'
EMAIL = 'EXAMPLE_EMAIL'

def book(closest, product, location)
  HTTParty.post(
        "https://oap.ind.nl/oap/api/desks/#{location}/appointments/",
        body:
          {
            "appointment": {
              "customers": [
                {
                  "lastName": LAST_NAME,
                  "vNumber": V_NUMBER
                }
              ],
              "date": closest['date'],
              "email": EMAIL,
              "endTime": closest['endTime'],
              "language": "en",
              "phone": PHONE,
              "productKey": product,
              "startTime": closest['startTime']
            },
            "bookableSlot": {
              "booked": false,
              "date": closest['date'],
              "endTime": closest['endTime'],
              "key": closest['key'],
              "parts": 1,
              "startTime": closest['startTime']
            }.to_json
          },
        headers: { 'Content-Type' => 'application/json' }
    )
end

def process(product, location)
  response = HTTParty.get(
    "https://oap.ind.nl/oap/api/desks/#{location}/slots/?productKey=#{product}&persons=1"
  )

  data = JSON.parse(response.body.split("\n").last)['data']

  unless data.empty?
    closest = data.first

    date = Date.parse(closest['date'])

    if date < TARGET_DATE_TO
      `say "There is an appointment for #{PRODUCT_MAP[product]} in #{LOCATION_MAP[location]} for #{date.to_s}"`

      # book(closest, product, location)
      # ^This one doesn't work for some reasone (400 response)
      # if you have a will you can debug it :)
    end
  end
end

loop do
  SCHEMA.each do |product, locations|
    locations.each do |location|
      process(product, location)
    end
  end

  p "Processed... #{Time.now}"
  sleep(WAIT_TIME)
end
