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

