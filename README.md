<div>
  <br/><br/>
  <p align="center">
    <a href="https://bambuser.com" target="_blank" align="center">
        <img src="https://brand.bambuser.net/current/logo/bambuser-black-512.png" width="280">
    </a>
  </p>
  <br/><br/>
</div>

# Live shopping one-to-one iOS SDK (PREPARATION FOR RELEASE)

## About

BambuserLiveShoppingOneToOne SDK lets you add the Bambuser Live Video Shopping one to one Agent tool to your iOS application.

## Alpha Version

This project is currently in alpha. It is not yet production ready, it is merely meant for evaluation and testing purposes.
Make sure to always use the latest version of the SDK. There is no guaranteed backwards compatibility while in alpha.

See the [release notes][ReleaseNotes] for status and progress.

## Prerequisites

* macOS Big Sur 11.3 or later
* Xcode 13.0 or later
* iOS 15.0 or later

## Use the demo application

Use the Demo application found in `/Demo` for quick testing of the agent tool.

Set desired `region` in `AgentViewController` and your organisations `organisationId`. Set `connectId` to a booked meeting id. 
Build in Xcode and run the demo on a device with iOS 15 or newer.

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

In your applications Info.plist file set a usage description for camera and microphone access:
* Privacy - Camera usage description (NSCameraUsageDescription)
* Privacy - Microphone usage description (NSMicrophoneUsageDescription)


Create a `LiveShoppingAgentView` and add it as a subview in a `UIViewController` or to current active `UIWindow`.
```
let agentView = LiveShoppingAgentView(region: <region>, organisationId: <your organisation id>)
agentView.frame = window.frame
window.addSubview(agentView)
```

Enable maximize mini-player by tap on the `LiveShoppingAgentView`.
```
agentView.tapToMaximize = true
```
Note, it is also possible to maximize a minimized player by calling `agentView.maximizeView()`.

Set up a `EventHandler` for listening to events emmited from the `LiveShoppingAgentView`.
```
agentView.eventHandler = { event in
    print("Event: \(event)")
}
```

Load a booking.
```
agentView.loadBooking(connectId: <your booking id>)
```

### Configuration

Examples on how to configure the appearance of the `LiveShoppingAgentView`

Set the size of the minimized agent tool

`agentView.minimizedSize = CGSize(width: 180, height: 320)`

Set minimized start origin

`agentView.minimizedOrigin = .topRight`

Set the superview where the minimized agent view should live. Default is the agent views own window.

`agentView.minimizedSuperview = self.view.window`


## Handling minmized state

When a ``LiveShoppingAgentView`` is minimized it detaches itself from its current `superview` and is added to its `UIWindow` 
or to ``LiveShoppingAgentView/minimizedSuperview`` if it is set.

Its state is kept in the `MinimizedState` static singleton. It keeps a reference to the current minimized `LiveShoppingAgentView` 
which makes it possible to access (restoring to maximized state, moving upwards in the `UIView` stack, e t c) the minimized `LiveShoppingAgentView` wherever in your application.


### Maximizing

When restoring `LiveShoppingAgentView` to maximized state the `MinimizedState.RestoreAction` registered in `MinimizedState.registerRestoreAction(_:)` will be called.
In that action add the returned `LiveShoppingAgentView` back as a subview in desired `UIView`. If no `MinimizedState.RestoreAction` is set the `LiveShoppingAgentView` will be maximized in its current superview, by default the key `UIWindow`.

Note, if you are using constraints for layout the full sized agent tool. You need to set them again for the returned `LiveShoppingAgentView`.

A good place to register a restore action is in the `UIViewController`s `viewWillAppear` method
```
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    MinimizedState.shared.registerRestoreAction { [weak self] agentView in
        self?.view.addSubview(agentView)
    }
}
```


### Handling modal UIViewControllers

If a UIViewController is presented modaly while `LiveShoppingAgentView` is in minimized state, you need to call `MinimizedState.bringToFront()` if you want the agentView to be floating on top of your UI. A good place to do that is in the presented `UIViewController`s `viewWillAppear` method.

```
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    MinimizedState.shared.bringToFront()
}
```


## SwiftUI

The `LiveShoppingAgent` wraps a `LiveShoppingAgentView` to give a SwiftUI interface of the agent tool. To not 
loose its `LiveShoppingAgentView` instance when a `LiveShoppingAgent` is re-rendered a `LiveShoppingAgentContext` 
keeps track of a `LiveShoppingAgent`s underlying `LiveShoppingAgentView`. It will also make sure it is properly deallocated 
when the `LiveShoppingAgent` disappears.

### Create a View

To create a `LiveShoppingAgent` View:
```
var agentView: some View {
    var agent = LiveShoppingAgent(region: <region>, organisationId: <your organisation id>, connectId: <your booking id>)
    agent.tapToMaximize = true
    return agent
}
```

### Handling minimized state

When the `LiveShoppingAgentView` is minimized it detaches from the `LiveShoppingAgent` SwiftUI `View` and lives in the key `UIWindow`. You need to
update your UI and not render the `LiveShoppingAgent` since it is now just a empty shell.

Inject the shared `LiveShoppingAgentContext` as a `@StateObject` and use the property `LiveShoppingAgentContext.isMinimized` to listen on miminized state changes.

```
@StateObject private var agentContext = LiveShoppingAgentContext.shared

var body: some View {
    // Only render `LiveShoppingAgent` when not in minimized state.
    if agentContext.isMinimized == false {
        agent
    }
}

var agentView: some View {
    // when maximizing again, take the preserved instance from the `LiveShoppingAgentContext`
    if let agent = agentContext.agent { return agent }
    var agent = LiveShoppingAgent(region: <region>, organisationId: <your organisation id>, connectId: <your booking id>)
    agent.tapToMaximize = true
    return agent
}
```


### View modifiers

`MinimizedStateRestoreModifier` to register action to restore a minimized `LiveShoppingAgent` view. 
Can be used for rendering the UI in a similar way as `LiveShoppingAgentContext.isMinimized` state. 
Mostly useful if one wants to navigate to a new `View` on restore.

```
HStack {
    myView
}
.restoreAgentAction { (agent) in
 // Restore back to a view containing the agent instance
}
```

The same can be achieved using the `MinimizedState` singleton in `.onAppear()`

```
HStack {
    myView
}
.onAppear() {
    MinimizedState.shared.registerRestoreAction { (agentView) in
        let agent = LiveShoppingAgent(agent: agentView)
    }
}
```

and the corresponding `MinimizedStateResetRestoreModifier` to reset a restore action when a View disappears

```
HStack {
    myView
}
.resetAgentRestoreAction()
```

The same can be achieved using the `MinimizedState` singleton in `.onDisappear()`

```
HStack {
    myView
}
.onDisAppear() {
    MinimizedState.shared.resetRestoreAction()
}
```


`BringAgentToFrontModifier` to move a minimized agent view to the front in the view stack

```
var body: some View {
    HStack {
        myView
    }
    .bringAgentToFront()
}
```

The same can be achieved using the `MinimizedState` singleton in `.onAppear()`

```
var body: some View {
    HStack {
        myView
    }
    .onAppear() {
        MinimizedState.shared.bringToFront()
    }
}
```

[Documentation]: ./Docs/BambuserLiveShoppingOnetoOne.doccarchive.zip
[ReleaseNotes]: ./RELEASE_NOTES.md
