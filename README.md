<div>
  <br/><br/>
  <p align="center">
    <a href="https://bambuser.com" target="_blank" align="center">
        <img src="https://brand.bambuser.net/current/logo/bambuser-black-512.png" width="280">
    </a>
  </p>
  <br/><br/>
</div>

# Live shopping one-to-one iOS SDK

## About

BambuserLiveShoppingOneToOne SDK lets you add the Bambuser Live Video Shopping one to one Agent tool to your iOS application.

## Relese history

See the [release notes][ReleaseNotes] for status and progress.

## Prerequisites

* macOS Big Sur 11.3 or later
* Xcode 13.0 or later
* iOS 14.3 or later

## Use the demo application

Use the Demo application found in `/Demo` for quick testing of the agent tool.

Set desired `region` in `AgentViewController` and your organisations `organisationId`. Set `connectId` to a booked meeting id. 
Build in Xcode and run the demo on a device with iOS 14.3 or newer.

## Installation

Requires Xcode 13.0 or newer.

### Swift Package Manager

File -> Add Packages... and enter the URL below

```https://github.com/bambuser/bambuser-onetoone-sdk-ios```

### CocoaPods

Add ```pod 'BambuserLiveShoppingOnetoOne', :git => 'https://github.com/bambuser/bambuser-onetoone-sdk-ios'``` to your Podfile.

After installing the SDK, you must import `BambuserLiveShoppingOnetoOne` in every file where you want to use it.

### Manually

It is also possible to install it manually. Download the `BambuserLiveShoppingOnetoOne.xcframework` bundle from `/Sources` and then 
just drag and drop the file into the `framework` group in your project in Xcode.

### Documentation

You can download the latest DocC documentation [here][Documentation].

Just extract the downloaded file and double-click the `.doccarchive` file to view the documentation in Xcode. Same guidelines can also be found here in this README.


## Getting started

Read the [GettingStarted] to get started developing your own agent tool app.

[Documentation]: ./Docs/BambuserLiveShoppingOnetoOne.doccarchive.zip
[ReleaseNotes]: ./RELEASE_NOTES.md
[GettingStarted]: ./GettingStarted.md