## So I heard you want to slice your apk into several apks based on 
## architecture

And I have a shitty hackish but also incredibly simple solution for you. That's a good thing. Yay!

This is a Bash script to slice a single APK into several ones based on architecture. This will create one package for every single architecture supported by Android: armeabi armeabi-v7a mips and x86.

### Before getting started

Requirements? Well, quite a lot. And everything must by on your PATH.

  * *jarsigner*: It's usually included with OpenJDK JDK and other JAVA (including Oracle's JAVA) JDKs.
  * *zipalign*: It's included with Android SDK, inside 4.4W build tools. No, this won't be on your PATH. Look for it into the directory sdk/build-tools/android-4.4W/
  * *aminc*: You will probably have to download this and compile it by yourself. Just grab https://github.com/gregko/aminc/blob/master/AndyManMod/aminc.cpp and compile with "g++ aminc.cpp -o aminc". Maybe you'll have to add the following include to avoid compilation errors: "#include <stdlib.h>".
  * *zip*, *unzip*: You will probably have this already in your system.

### Invocation!

`bash apk-slice-by-arch.sh <originalfile.apk> <keystore> <keyname> <keypass>`

  * *originalfile.apk*: This is your multiarch APK.
  * *keystore*: This is the path to your keystore, so we can sign the new APKs.
  * *keyname*: The keyname within your keystore.
  * *keypass*: I even don't know why you are still reading this. Of course this is the keystore password.

If everything is fine (*eventually* it will), some smaller and quite cuter files will be spanned inside the current folder, named by the original file with the architecture appended at the end.

### Credits!

Oh yeah, this was not my idea. This is heavily based on a Windows (*eugh*) script made by the very same author of *aminc*. You can find it here: http://stackoverflow.com/questions/19268647/gradle-android-build-for-different-processor-architectures

Cheers gregko, thanks for your work, you definitely saved my day.

