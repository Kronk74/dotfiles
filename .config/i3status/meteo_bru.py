#!/usr/bin/env python3

import json
import urllib.request

# sign in at https://openweathermap.org/api to get an API KEY
APPID = "8e3fdd76b717e961008bbb5d39e76a19"
# get you city ID at http://bulk.openweathermap.org/sample/
CITYID = "2800866"

with urllib.request.urlopen("https://api.openweathermap.org/data/2.5/weather?id=" + CITYID + "&units=metric&appid=" + APPID) as url:
  data = json.loads(url.read().decode())
  str = " " + str(data['main']['temp']) + "°C "
  # https://openweathermap.org/weather-conditions#Weather-Condition-Codes-2
  if int(data['weather'][0]['id']) >= 200 and int(data['weather'][0]['id']) < 300: # Group 2xx: Thunderstorm
    str += "" # yes, it's a thunder poo ;)
  elif int(data['weather'][0]['id']) >= 300 and int(data['weather'][0]['id']) < 500: # Group 3xx: Drizzle
    str += ""
  elif int(data['weather'][0]['id']) >= 500 and int(data['weather'][0]['id']) < 600: # Group 5xx: Rain
    str += ""
  elif int(data['weather'][0]['id']) >= 600 and int(data['weather'][0]['id']) < 700: # Group 6xx: Snow
    str += ""
  elif int(data['weather'][0]['id']) >= 700 and int(data['weather'][0]['id']) < 800: # Group 7xx: Atmosphere
    str += ""
  elif int(data['weather'][0]['id']) == 800: # Group 800: Clear
    str += ""
  elif int(data['weather'][0]['id']) > 800: # Group 80x: Clouds
    str += ""
  print(str, end='')
