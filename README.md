# iOs-exam

### The structure of the app:

![inline](./img/structure-flow.png)
*Illustration of the navigation flow. Made with [Excalidraw](https://excalidraw.com/).*

------

### How the app gets data:

- The apllication gets it's data from the norwegian [Meteorological Institute public API](https://api.met.no/weatherapi/locationforecast/2.0/documentation). <br />
- It uses version 2 of the compact location forecast.
- URLSession is used to fetch data from the endpoint. 
- FileManager is used to store the response data on the device.

This application stores the JSON response directly to the disk in two sepperate files. <br/>
Each file represent different types of weatherforecasts:

* The specificWeatherForecast.json:
   - Keeps the data for a specific location.
   - This file gets updated each time you set a new pin on the map.
  
* The currentWeatherForcast.json:
  - Keeps the data for your current location.
  - This file gets updated at app launch, or when the CLLocationManager udates your location.
  - Since the forecast from the API is accurate down to 1km, the location accuracy is set to 1km.

Check out this illustration to get an overview:

![inline](./img/app-flow.png)
*Illustration of the data flow. Made with [Excalidraw](https://excalidraw.com/).*

------

### How I've worked to get this done

This application is made with a mixture of deep diggs into stackoverflow, google, <br/> 
and the course material from [Beining & Bogen's](http://www.beiningbogen.no) iOS-programming [repository](https://github.com/BeiningBogen/iOS-Kristiania)
<br/><br/>
I decided to take programatically approach to the assignment, so no storyboard is used. <br/>
This is just a personal preference, and i find it more fun and responsive doing it this way. <br/>
There are probably loads of pros and cons regarding this approach vs using the Interface Builder. <br/>
In my experience it gave me a great understanding of how things works "under the hood". <br/>




### Sources:
 - https://www.youtube.com/watch?v=sqo844saoC4&ab_channel=iOSAcademy
 - https://gist.github.com/saoudrizwan/b7ab1febde724c6f30d8a555ea779140
