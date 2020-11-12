# iOs-exam

---
### How the app gets the data:

The apllication gets it's data from the norwegian [Meteorological Institute public API](https://api.met.no/weatherapi/locationforecast/2.0/documentation). <br />
It uses version 2 of the compact location forecast.

URLSession is used to fetch data from the endpoint. 

This application stores the JSON response directly to the disk in two sepperate files. <br/>
Each file represent different types of weatherforecasts:

* The specificWeatherForecast.json:
   - Keeps the data for a specific location.
   - This file gets updated each time you set a new pin on the map.
  
* The currentWeatherForcast.json:
  - Keeps the data for your current location.
  - This file gets updated at app launch, or when the CLLocationManager udates your location.
  - Since the forecast from the API is accurate down to 1km, the location accuracy is set to 1km.
  
The application then goes to the cache and decodes the JSON data. <br/> 
This enables offline forecasts for your current location (if you don't do alot of offline movement), <br/>  
and the last location you checked out on the map.

![inline](./img/app-flow.png)


### Sources:
 - https://www.youtube.com/watch?v=sqo844saoC4&ab_channel=iOSAcademy
 - https://gist.github.com/saoudrizwan/b7ab1febde724c6f30d8a555ea779140
