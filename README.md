# README #

## Astronomy Pictures of the Day App
This app allows users to see a list of Astronomy Picture of the Day for the last 7 days and information about each picture.

### Requirements:
* Minimum deployment target: iOS 15

### Features:

* Astronomy Pictures List:
    - Displays a list of Astronomy Pictures of the Day for the last 7 days.
    - Each list item includes an image, title, and captured date of the picture.
    
* Picture Details Screen:
    - Detail page displays the selected image along with its description.
    
 ### Approach and Decisions:
* This app is making use of SwiftUI and hence natural choice of architecure is MVVM.
* App is divided into 3 layers,
    - Network Layer (APIService and corresponding modules)
    - Business Logic layer (ViewModels)
    - Presentation layer (SwiftUI views) 
* App is using Swift concurrency (Async/Await) in order to fetch data and images from network.
* Since images used here are heavy, app has a mechanism of caching downloaded images using NSCache. 
* App is making to use of protocols to decouple components also it enables writing unit tests.
   
### Assumptions:
* Sometimes data returned from contains backend contains 'media_type' as 'video'. In that case we are directly showing placeholder image instead of making call to api to load image.
* If due to some reason downloading image fails, we are showing same placeholder image on the cell and details view that is mentioned in above point.
* As per app description we have hardcoded number of days to 7. But in case app fails to get last 7th day, we make call to api with sending today's date as 'start_date' and skip sending 'end_date'. In this case api returns us data for one day(today) only. 
* Since this app is kind of POC, it has really basic UX and does not include any animation or advanced UX features.
    
### Note:
* Even if api used here is free, there is limit on number of times you can call this api via same network. Once limit is reached api will start to fail.
* If internet is not there then app will show generic error to user.
