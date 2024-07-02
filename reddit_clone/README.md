# Reddit Clone App

A new Flutter project.

### Get your SHA1 OR SHA256 certificate fingerprint by running the following command on your terminal:

keytool -list -v -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore debug Keystore Password: android
<br>I got the command from [here](https://developers.google.com/android/guides/client-auth#using_play_app_signing)

Or,

keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android
<br> Source: [Click here](https://stackoverflow.com/questions/51845559/generate-sha-1-for-flutter-react-native-android-native-app)

To run this application on the web in debug mode run the following command on the terminal:
<br>_flutter run -d chrome --web-renderer html_

### Errors and Solutions:

**Error:**<br>
_PlatformException(sign_in_failed, com.google.android.gms.common.api.ApiException: 10: , null)_<br>

**Solution that worked for me ([Guide](https://github.com/flutter/flutter/issues/56235)):**
<br>_Use the SHA1 Certificate fingerprint instead of SHA256._