# Weather app

### API to get reverse:
https://nominatim.openstreetmap.org/reverse?lat=$latitude&lon=$longitude&format=json

### API to for forecast and searching.
https://api.open-meteo.com/v1/forecast?latitude=${cityLanLon[index]?[0]}&longitude=${cityLanLon[index]?[1]}&current=temperature_2m,weather_code,wind_speed_10m
https://geocoding-api.open-meteo.com/v1/search?name=$cityName&count=10&language=en&format=json

### Features:
- Click in geography button -> search current location + weather at current location
- search weather at a city as you want by putting a name into search bar with some difference information

### Image 1
![Image 1](https://drive.google.com/uc?export=view&id=1yMruLeK_-3wODk8U8J2EbcIS2CWUG2t8)
### Image 2
![Image 2](https://drive.google.com/uc?export=view&id=12lxXYggZrnxMUeo4OWZVhyyv7wi5k_RA)
### Image 3
![Image 3](https://drive.google.com/uc?export=view&id=12vWyIvmIfHND2BssLO2WLfU-VK16T7Mu)
### Image 4
![Image 4](https://drive.google.com/uc?export=view&id=1Srs8pha-8EJWju-m0R_vOgSNCVOutr9x)
### Image 4
![Image 4](https://drive.google.com/uc?export=view&id=1IYgbg2ZBjFpRGJ0NTwBCCUgNxgULMp_G)


# Diary app (For learning authentication and database, in this case with firebase)

#Install
##npm
run npm install firebase (1. to install Firebase SDK, 2. add Firebase package to node_modules 3. update package.json 4. create package-lock.json)
npm install -g firebase-tools
##firebase, configuration
firebase login
flutter create diary_app

dart pub global activate flutterfire_cli
(if at 42, recommended: download homebrew, move it to goinfre)
brew install rbenv ruby-build
rbenv init
rbenv install 3.0.0
rbenv global 3.0.0
gem install xcodeproj --user-install
flutterfire configure --project=diaryapp-56f8c

firebase login
firebase init
flutter pub add firebase_auth

##some new knowledge about code
- Dialog - must interact with that window first, before touch the rest of the app .
- Inkwell ripple effect (a touch animation) -> hover / click -> color in Backgroudn change a bit for easy regconisation
- Navigator.pop(context); - remove the highest layer (remote the current dialog / come back to previous screen)
- Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen())); to change the screen.

## To connect Android with google authentication

keytool -list -v \
-alias androiddebugkey -keystore ~/.android/debug.keystore

if there's no key, do this first to generate the key:
keytool -genkeypair -v -keystore ~/.android/debug.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias androiddebugkey 
In my case, it's in goinfre (./jdk-21.0.5.jdk/Contents/Home/bin/keytool -genkeypair -v -keystore ~/.android/debug.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias androiddebugkey)

go to firebase, activate Google chrome, put google-services.json to android/app (follow instructions, this part of ios and android, i'm not sure cause i haven't checked yet)

## Video to follow:
https://www.youtube.com/watch?v=xvma6IFL21s
https://www.youtube.com/watch?v=Txa3sevHSsY


811446816301-vjpk05hp52ufn6dtr6a8ph8gud8i8sdh.apps.googleusercontent.com
flutter run -d chrome --web-port=50024

com.example.diary_app
https://chatgpt.com/share/67587417-8e10-8008-a1bc-fe7036b54500

## What to do to use this application?
- create an firebase project on firebase, follow documentation, do something with firebase init or login to generate a "firebase_options.dart" file to get keys there and so that your firebase is linked to your google account. And allow github and google there.
- for google authentication register the name, such as http://localhost:50024 at https://console.cloud.google.com/apis/.
- for github: go there to configure it. https://github.com/settings/developers

### Image 1
![Image 1](https://drive.google.com/uc?export=view&id=1HwNpj2gOgtgKHELQEnLqdgxIzGJYyvqR)

### Image 2
![Image 3](https://drive.google.com/uc?export=view&id=1z8Q-bXEVv2x4pf7DjACxNkwt1yk1Tq3P)

### Image 3
![Image 4](https://drive.google.com/uc?export=view&id=1_4k43_8gRwPnlkcAVJIeUdAJ_uo-fl_p)