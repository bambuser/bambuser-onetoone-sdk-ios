# Release Notes

This SDK is currently an experimental beta.

It will follow semver only after the first major release. Until then, it may (and most probably will) have breaking changes between minor versions. 
Make sure to always use the latest version of the SDK. There is no guaranteed backwards compatibility while in beta.

## Release 0.3.0

This is the first beta release. The SDK now includes support for SSO.

### ✨ New features

* API for SSO
* A new property `AgentEvent.enableSSO` and a new parameter `enableSSO` in `LiveShoppingAgentView.init` for enabling SSO login.
* A new event `AgentEvent.refreshSsoToken(responseId:)` emitted when SSO token is not set or needs a refresh.
* A new function `LiveShoppingAgentView.refreshSsoToken(ssoToken:, responseId:)` to set new SSO token.
* A new event `AgentEvent.unauthorized` at failed SSO login.

### 🐛 Known issues

* on iOS < 15.0 LiveShoppingAgentView asks for camera and microphone permission every time it is loaded.

## Release 0.2.0

This is the second alpha release. The SDK now support iOS14.3 and includes first version of API for handling products in call and cart.

### ✨ New features

* Support for iOS 14.3.
* API for handling products in call and cart.
* A new event `AgentEvent.callStatusUpdate(status)` and property `callSessionStatus` for call status.
* A new event `AgentEvent.clientLocale(locale:)` and property `clientLocale` for client locale.
* A new event `AgentEvent.previewStarted` when agent camera preview is started.
* SwiftUI: added a `AgentEventHandlerModifier` for listening to `AgentEvent`s.

### 🐛 Known issues

* on iOS < 15.0 LiveShoppingAgentView asks for camera and microphone permission every time it is loaded.

## Release 0.1.0

This is the very first alpha release. It includes the possibility to create a agent tool view, minimize it, drag it in minimized state and maximize it back again to full size. This for both UIKit and SwiftUI.

Demo, documentation and the readme is in constant work in progress and will be improved and extended in coming versions.
