# rich_link_preview
A Rich Link Preview widget written in Dart generating a rich presentation of the given link from social meta tags.


## Getting Started
### Add the following line in your pubspec file
````
rich_link_preview:
````
    
### Get the package by running the command
````
flutter packages get
````

###  Include the widget in your dart file
````
import 'package:rich_link_preview/rich_link_preview.dart';
````
    
## Example Usage:
````
RichLinkPreview(
    link: 'https://ourland.hk/detail/72e1aeaf-360b-4f45-a528-ef1c5e4d803c',
    appendToLink: true,
)
````
![image](https://user-images.githubusercontent.com/35857179/52174596-3b6a9680-27d1-11e9-9c24-aceeecf7709f.png)


````
RichLinkPreview(
    link: 'https://ourland.hk/detail/72e1aeaf-360b-4f45-a528-ef1c5e4d803c'
),
````
![image](https://user-images.githubusercontent.com/35857179/52174604-59d09200-27d1-11e9-853f-a9b07b372573.png)

## Parameters
|Parameter|Type|Description|Example|Required?|Default|
|--|--|--|--|--|--|
|link|String|Link to be previewed|https://ourland.hk/detail/72e1aeaf-360b-4f45-a528-ef1c5e4d803c|N|''|
|height|double|Height of the Rich Link Preview container|150.0|N|100.0|
|borderColor|Color|Color of the container border|Color(0xFF000000)|N|Color(0xFFE0E0E0)|
|backgroundColor|Color|Color of the container background|Color(0xFF000000)|N|Color(0xFFE0E0E0)|
|textColor|Color|Color of the text|Color(0xFFE0E0E0)|N|Color(0xFF000000)|
|appendToLink|bool|append the preview to link|false|N|false|
