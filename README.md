# LazyMan-iOS
A simple app that lets you stream every live and archived NHL and MLB game from any of your iOS devices for free. Based on the original [LazyMan project](https://github.com/StevensNJD4/LazyMan). You can learn more at [/r/LazyMan](https://www.reddit.com/r/LazyMan/) on Reddit. Big thanks to @[StevensNJD4](https://github.com/StevensNJD4/) for making this possible.

## Features
- NHL/MLB game playback
- AirPlay (may need to mirror screen first)
- Chromecast streaming
- Quality selection (including auto)
- Feed/CDN selection
- Audio selection (radio, language, ballpark)
- Subtitles
- Scrubbing (for live and archived games)
- iPad picture in picture support
- Easy date selection
- Favorite team selection

## Screenshots
<img width="250" src="https://github.com/inickt/LazyMan-iOS/blob/master/screenshots/screenshot1.png"><img width="250" src="https://github.com/inickt/LazyMan-iOS/blob/master/screenshots/screenshot2.png"><img width="250" src="https://github.com/inickt/LazyMan-iOS/blob/master/screenshots/screenshot3.png"><img width="250" src="https://github.com/inickt/LazyMan-iOS/blob/master/screenshots/screenshot4.png"><img width="250" src="https://github.com/inickt/LazyMan-iOS/blob/master/screenshots/screenshot5.png"><img width="250" src="https://github.com/inickt/LazyMan-iOS/blob/master/screenshots/screenshot6.png">

## Installation
### Non-jailbroken Installation
**Requirements**
- iOS 9 and above
- A computer with [Cydia Impactor](http://www.cydiaimpactor.com/) (iTunes need to be installed on Windows)

1. Download and install Cydia Impactor. This is a trusted application that is commonly used to load jailbreaks or sideloaded apps. You can read more about it [here](https://www.theiphonewiki.com/wiki/Cydia_Impactor).
2. Download the latest LazyMan for iOS `.ipa` [here](https://github.com/inickt/LazyMan-iOS/releases/latest).
3. Open Cydia Impactor, plug in your device, and drag the .ipa onto the window. Install. You will be prompted to enter your Apple ID and password. This is never saved. If you have two factor authentication on your account, you will have to go [here](https://appleid.apple.com/) and generate an app-specific password to use.
4. Trust the app on your phone in `Settings` -> `General` -> `Profiles & Device Management`.

If you do not have a developer account, **the app will have to be reinstalled every 7 days**.

#### Reinstallation/Upgrades
1. Download the most recent release, if necessary.
2. Drag the `.ipa` onto your device in Cydia Impactor. Install.

### Jailbroken Installation
**Requirements**
- iOS 9 and above
- Should work on all Jailbreaks, however only tested with Cyida

1. Add [https://repo.nickt.dev/](https://repo.nickt.dev/) as a repo in Cydia.

2. Install the LazyMan-iOS package (dev.nickt.lazyman-ios).

And thats it! The app will be installed as a system application, and you can launch it from your home screen. The app will only work while in a jailbroken state, however.

You can opt in to beta releases by adding [https://repo.nickt.dev/beta/](https://repo.nickt.dev/beta/) as a repo in Cydia.

#### Manual Installation
You can download the latest .deb release from [here](https://github.com/inickt/LazyMan-iOS/releases/latest). If you want to manually install use `dpkg -i [deb file]` in a shell on your iOS device.

## Contributing
**Requirements**

LazyMan for iOS is build on Swift 5.1 using Xcode 11.3. Cocoapods is required to install dependencies. dpkg, and [ldid2](https://github.com/xerub/ldid) are required to build a `.deb` for jailbroken devices.

### Setup
1. Clone repo

2. `pod install`

### Building
**Makefile**

Run `make` to produce release builds. An `.ipa` and `.deb` should be produced in the `build` directory.

**Xcode**

If building to a simulator, no changes are needed. If building to a device, first set your development team.
