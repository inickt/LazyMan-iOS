# LazyMan-iOS
A simple app that lets you stream every live and archived NHL and MLB game from any of your iOS devices for free. Based on the original [LazyMan project](https://github.com/StevensNJD4/LazyMan). You can learn more at [/r/LazyMan](https://www.reddit.com/r/LazyMan/) on Reddit. Big thanks to @[StevensNJD4](https://github.com/StevensNJD4/) for making this possible.

## Features
- NHL/MLB game playback
- Quality selection (including auto)
- Subtitles
- Audio selection (radio, language, ballpark)
- Scrubbing (for live and archived games)
- Feed/CDN selection
- AirPlay
- iPad picture in picture support
- Easy date selection

The app is currently in beta. Future releases will make it easier to install Surge 3 and make sure your device is configured correctly.

## Screenshots
<img width="250" src="https://github.com/inickt/LazyMan-iOS/blob/master/screenshots/screenshot1.png"><img width="250" src="https://github.com/inickt/LazyMan-iOS/blob/master/screenshots/screenshot2.png"><img width="250" src="https://github.com/inickt/LazyMan-iOS/blob/master/screenshots/screenshot3.png"><img width="250" src="https://github.com/inickt/LazyMan-iOS/blob/master/screenshots/screenshot4.png"><img width="250" src="https://github.com/inickt/LazyMan-iOS/blob/master/screenshots/screenshot5.png"><img width="250" src="https://github.com/inickt/LazyMan-iOS/blob/master/screenshots/screenshot6.png">

## Requirements
- iOS 11 and above (iOS 9 and 10 should be added in the future)
  - If not jailbroken: [Surge 3](https://itunes.apple.com/us/app/surge-3-web-developer-tool/id1329879957?mt=8) (It’s free, you do NOT need the in app purchase)
  - If jailbroken: [Manual host file changes](https://www.reddit.com/r/LazyMan/wiki/hostsfile)
- A computer with [Cydia Impactor](http://www.cydiaimpactor.com/) (iTunes need to be installed on Windows)


## Installation
### Non-jailbroken
1. Download and install Cydia Impactor. This is a trusted application that is commonly used to load jailbreaks or sideloaded apps. You can read more about it [here](https://www.theiphonewiki.com/wiki/Cydia_Impactor).
2. Download the latest LazyMan for iOS `.ipa` [here](https://github.com/inickt/LazyMan-iOS/releases/latest).
3. Open Cydia Impactor, plug in your device, and drag the .ipa onto the window. Install. You will be prompted to enter your Apple ID and password. This is never saved. If you have two factor authentication on your account, you will have to go [here](https://appleid.apple.com/) and generate an app-specific password to use.
4. Trust the app on your phone in `Settings` -> `General` -> `Profiles & Device Management`.
5. If jailbroken, follow the hosts guide. If not jailbroken, download and install Surge 3. Copy [this link](https://gist.githubusercontent.com/inickt/52ab5d68e57eed4c309a61c2668f8b76/raw/34eaf743be486112b41b76fbd7f8dbb4123150be/LazyMan.conf), and open Surge 3. Click the logo/profile name in the upper left hand corner, and then click `Download Profile` from URL. Paste the URL and click okay. Select the LazyMan profile if it is not already selected. Install the Surge 3 VPN profile by clicking setup in the upper right hand corner of the app. Start Surge 3.

If you do not have a developer account, the app will have to be reinstalled every 7 days.

### Jailbroken
I will make a repo avalible for easy Cydia installation and automatic host changes eventually. Right now follow the non-jailbroken steps, except everything in regards to Surge 3.

### Reinstallation/Upgrades
1. Download the most recent release, if necessary.
2. Drag the `.ipa` onto your device in Cydia Impactor. Install.

## Contribute
LazyMan for iOS is build on Swift 4.1 using Xcode 9.3 and macOS 10.13. The Pods included in the project are already included in the repository, but you can always run `pod update` if you want to update them.

### Exporting the .ipa
To export an `.ipa`, change your build targer to `Generic iOS Device`. Then click `Product` -> `Archive`. Right click the archive in Organizer, and click `Show in Finder`. Right click the archive and select `Show Package Contents`. 

Navigate to `Products` -> `Applications`, right click on `LazyMan-iOS.app`, click `Show Package Contents`, and then delete the `embedded.mobileprovision` file. Go back to the folder with `LazyMan-iOS.app` in it. 

Create a new folder named `Payload`, and drag `LazyMan-iOS.app` to be inside of it. Right click the `Payload` folder, and select `Compress "Payload"`. 

Rename `Payload.zip` to `LazyMan-iOS.ipa`.
