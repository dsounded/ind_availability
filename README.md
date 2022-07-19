# IND availability

This script allows you to check available (after cancellation)
free appointment slots.

It also has auto booking part but it doesn't work for some
reason (check `book` function).

Requirements:
- MacOS to use `say` function for notification. Can be
replaced with [windows alternatives](https://stackoverflow.com/questions/12877422/how-do-i-get-shell-ruby-to-make-a-noise-make-my-computer-beep-or-play-a-sound-t)
- Ruby, can use default one in MacOS.
- httpparty library

Usage:
- clone this repository (or copy `ind.rb` script)
- in Terminal run: `gem install httpparty`
- set constants to your data:

For availability:
1) `TARGET_DATE_TO`, using 3 arguments, year, month and day respectively
2) `WAIT_TIME` - delay for your requests to IND server, default is 10 seconds
3) `SCHEMA` - type of requests and location you want to observe
Example: for Amsterdam collection permit
```
SCHEMA = {
  'DOC' => ['AM'],
}
```
Let's say you you want to add Den Bosch:
```
SCHEMA = {
  'DOC' => ['AM', 'DB'],
}
```

For sticker:

```
SCHEMA = {
  'DOC' => ['AM'],
  'VAA' => ['AM', 'DH', 'ZW', 'DB']
}
```

Available services: `DOC` (residence permit) and `VAA` (sticker)
Available locations: `AM` (Amsterdam), `DH` (The Hague), `ZW` (Zwolle), `DB` (Den Bosch)

- run the script with `ruby ind.rb`
You will see the output in console after each requests group finished:
`"Processed... 2022-07-19 21:38:00 +0200"`

Once there is a slot you will hear a notification (OS voice),
so increase the sound level :)

If you want to debug `book`, replace the values of constants with your data:

```
LAST_NAME = 'EXAMPLE_NAME'
V_NUMBER = 'EXAMPLE_N'
PHONE = 'EXAMPLE_PHONE'
EMAIL = 'EXAMPLE_EMAIL'
```

GL & HF :)
