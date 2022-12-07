## Getting started

In your applications Info.plist file set a usage description for camera and microphone access:
* Privacy - Camera usage description (NSCameraUsageDescription)
* Privacy - Microphone usage description (NSMicrophoneUsageDescription)


Create a `LiveShoppingAgentView` and add it as a subview in a `UIViewController` or to current active `UIWindow`.
```swift
let agentView = LiveShoppingAgentView(region: <region>, organisationId: <your organisation id>)
agentView.frame = window.frame
window.addSubview(agentView)
```

Enable maximize mini-player by tap on the `LiveShoppingAgentView`.
```swift
agentView.tapToMaximize = true
```
Note, it is also possible to maximize a minimized player by calling `agentView.maximizeView()`.

Set up a `EventHandler` for listening to events emmited from the `LiveShoppingAgentView`.
```swift
agentView.eventHandler = { event in
    print("Event: \(event)")
}
```

Load a booking.
```swift
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
```swift
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    MinimizedState.shared.registerRestoreAction { [weak self] agentView in
        self?.view.addSubview(agentView)
    }
}
```


### Handling modal UIViewControllers

If a UIViewController is presented modaly while `LiveShoppingAgentView` is in minimized state, you need to call `MinimizedState.bringToFront()` if you want the agentView to be floating on top of your UI. A good place to do that is in the presented `UIViewController`s `viewWillAppear` method.

```swift
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    MinimizedState.shared.bringToFront()
}
```

#  Handling products

An essential part of the agent tool is the ability to manage products in a call with a client.

The SDK has function calls for adding and removing Products to a call. When a Product is added to a 
call it becomes visible to the client and the opposite when removing it from the call. 

The agent can also add and remove products to the clients cart. Any changes made to the cart 
either by the agent or the client will be notified through emitted events.

## Product

A `Product` has one or more `Variation`s. A `Variation` has a set of `VariationAttributes` that are set up of the available
defined attributes, `AttributeDefinition`, (E.g. size, color, ...) and its options, `AttributeDefinitionOption`, 
(E.g. Small, Medium, ..., Red, Green, ...), for the `Product`. A `Variation` is identified by its sku.

Below example on how to create a `Product` with two(2) `Variation`s.

```swift
let productBag = try Product(
    attributes: [
        try AttributeDefinition(id: "id_Color", name: "Color", options: [
            AttributeDefinitionOption(id: "oid_Black", name: "Black"),
            AttributeDefinitionOption(id: "oid_Cognac", name: "Cognac")
        ])
    ],
    brandName: "Bambuser",
    currency: "SEK",
    description: "This tote encapsulates Flattered’s timeless approach to design. The bag features a classic shape and will never go out of style thanks to its timeless black and cognac hue and gold-colored detailing. Designed in Stockholm and handcrafted in Montesilvano, Italy from fine Italian calf leather. A great bag for all occasions.",
    defaultVariationIndex: 0,
    locale: "en-US",
    name: "Luka Tote Bag",
    sku: "430",
    url: "https://demo.bambuser.shop/product/430/luka-tote-bag/",
    variations: [
        Variation(
            attributes: [
                VariationAttribute(attributeDefinition: colorAttributeBag, option: colorBlack)
            ],
            comparableAttributes: [
                ComparableVariationAttribute(id: "id_Material", name: "Material", option: "Leather"),
                ComparableVariationAttribute(id: "id_Dimensions", name: "Dimension", option: "32x40x19cm")
            ],
            imageUrls: [
                "https://demo.bambuser.shop/wp-content/uploads/2021/03/Luka_black.png"
            ],
            inStock: true,
            name: "Luka Tote Bag",
            price: Price(currency: "SEK", current: 2500),
            rating: Rating(rating: 4.00, maxValue: 5, numberOfRatings: 1),
            sku: "431",
            url: "https://demo.bambuser.shop/product/431/luka-tote-bag/"),
        Variation(
            attributes: [
                VariationAttribute(attributeDefinition: colorAttributeBag, option: colorCognac)
            ],
            comparableAttributes: [
                ComparableVariationAttribute(id: "id_Material", name: "Material", option: "Leather"),
                ComparableVariationAttribute(id: "id_Dimensions", name: "Dimension", option: "32x40x19cm")
            ],
            imageUrls: [
                "https://demo.bambuser.shop/wp-content/uploads/2021/03/Luka_cognac.png"
            ],
            inStock: true,
            name: "Luka Tote Bag",
            price: Price(currency: "SEK", current: 200, original: 350),
            rating: Rating(rating: 4.00, maxValue: 5, numberOfRatings: 1),
            sku: "432",
            url: "https://demo.bambuser.shop/product/432/luka-tote-bag/"),
    ])
```

See demo project for more examples.

## Call

### Functions

Product in call management is handled via a Product Variations SKU(identifier). Except when adding a `Product` to a call
then the complete `Product` with all its metadata is added.

All function calls below are also available through `MinimizedState` and `LiveShoppingAgentContext`.

Add product to call:
`LiveShoppingAgentView.addProductToCall(product:completion:)`

Remove a product in call:
`LiveShoppingAgentView.removeProductInCall(sku:completion:)`

Check if a product is in call:
`LiveShoppingAgentView.isProductInCall(sku:completion:)`

Get products in call:
`LiveShoppingAgentView.getProductsInCall(completion:)`

### Events

Product removed from call:
`AgentEvent.productRemovedFromCall(sku:)`


## Cart

### Functions

Product cart management is handled via a Product Variations SKU(identifier).

All function calls below are also available through `MinimizedState` and `LiveShoppingAgentContext`.

Add product to cart:
`LiveShoppingAgentView.addProductToCart(sku:completion:)`

Remove product in cart:
`LiveShoppingAgentView.removeProductInCart(sku:completion:)`

Increment number of product in cart:
`LiveShoppingAgentView.addProductToCart(sku:completion:)`

Decrement number of product in cart:
`LiveShoppingAgentView.decrementProductInCart(sku:completion:)`

Update number of product in cart:
`LiveShoppingAgentView.updateProductInCart(sku:quantity:completion:)`

Check if product is in cart:
`LiveShoppingAgentView.isProductInCart(sku:completion:)`

Get products in cart:
`LiveShoppingAgentView.getProductsInCart(completion:)`

Get products with quantity in cart:
`LiveShoppingAgentView.getCartStatus(completion:)`


### Events

Cart updated(Product quantity has changed):
`AgentEvent.productUpdateInCart(data:)`

Product removed from cart:
`AgentEvent.productRemovedFromCart(sku:)`


## Handling AudioSession

If you intend to play audio / video in parallell with the agent tool you need to configure the Audio session and handle audio session interruptions.

### Configuring AudioSession

Set your applications `AVAudioSession.Category` to `.playback` with `AVAudioSession.CategoryOptions` to `.mixWithOthers` or `.duckOthers`.

```swift
do {
    try AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
    try AVAudioSession.sharedInstance().setActive(true)
} catch {
}
```

### Handling interruption

If your audio / video playback starts prior to the `LiveShoppingAgentView.loadBooking(connectId:)` call it will be interrupted by the
`LiveShoppingAgentView`. You can setup your app to listen on the `AVAudioSession.interruptionNotification` notification and start your audio / video playback again.

```swift
// In your setup
var previewStarted: Bool = false
agentView.eventHandler = { [weak self] event in
    previewStarted = event == .previewStarted
}

let nc = NotificationCenter.default
nc.addObserver(self,
               selector: #selector(handleInterruption),
               name: AVAudioSession.interruptionNotification,
               object: AVAudioSession.sharedInstance())


@objc func handleInterruption(notification: Notification) {
    guard let userInfo = notification.userInfo,
        let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
        let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
    }

    if type == .began {
        if previewStarted {
            // restart audio / video playback again here
            // if the intention is to run in parallell with the agent tool.
        }
    } else if type == .ended {
        // or restart here if you want to continue playback after
        // LiveShoppingAgentView is closed.
    }
}
```


## SwiftUI

The `LiveShoppingAgent` wraps a `LiveShoppingAgentView` to give a SwiftUI interface of the agent tool. To not 
loose its `LiveShoppingAgentView` instance when a `LiveShoppingAgent` is re-rendered a `LiveShoppingAgentContext` 
keeps track of a `LiveShoppingAgent`s underlying `LiveShoppingAgentView`. It will also make sure it is properly deallocated 
when the `LiveShoppingAgent` disappears.

### Create a View

To create a `LiveShoppingAgent` View:
```swift
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

```swift
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

```swift
HStack {
    myView
}
.restoreAgentAction { (agent) in
 // Restore back to a view containing the agent instance
}
```

The same can be achieved using the `MinimizedState` singleton in `.onAppear()`

```swift
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

```swift
HStack {
    myView
}
.resetAgentRestoreAction()
```

The same can be achieved using the `MinimizedState` singleton in `.onDisappear()`

```swift
HStack {
    myView
}
.onDisAppear() {
    MinimizedState.shared.resetRestoreAction()
}
```


`BringAgentToFrontModifier` to move a minimized agent view to the front in the view stack

```swift
var body: some View {
    HStack {
        myView
    }
    .bringAgentToFront()
}
```

The same can be achieved using the `MinimizedState` singleton in `.onAppear()`

```swift
var body: some View {
    HStack {
        myView
    }
    .onAppear() {
        MinimizedState.shared.bringToFront()
    }
}
```

Listen to `AgentEvent`s using the `AgentEventHandlerModifier` modifier

```swift
var body: some View {
    VStack {
        agentView
    }
    .onAgentEvent(eventHandler: { event in
        print("Event: \(event)")
    })
}
```

## Authentication

By default authentication is handled manually when the LiveShoppingAgentView is presented but there is also functionality to sign in the user automatically through SSO.

After the user is authenticated and the JWT-token is available you can follow the following steps:

1. When initiating `LiveShoppingAgentView`, set init parameter `enableSSO` to `true`.

```swift
agentView = LiveShoppingAgentView(
    region: region,
    organisationId: organisationId,
    enableSSO: true
)
```

2. Setting `enableSSO` to true will trigger the headless authentication flow from the SDK. Once the `LiveShoppingAgentView` has been presented it will send event `refreshSsoToken(responseId:)`. This event basically means that the agent tool expects a token, but the current token is nil or expired. Once this event is triggered you should create or refresh a JWT-Token. Once you have a new or refreshed JWT-token you should call `LiveShoppingAgentView` method `refreshSsoToken(ssoToken: String, responseId: String, completion: (error) -> ())`. This will tell the SDK to finish the authentication flow with supplied token.
> ⚠️ The SDK will also call `refreshSsoToken(responseId:)` when the token has expired and it is expected that you respond with a new valid token.


```swift
agentView.eventHandler = { event in
    switch event {
    case .refreshSsoToken(responseId: let responseId):
        yourJWTHandler.refreshToken { refreshedToken in
            agentView.refreshSsoToken(
                ssoToken: refreshedToken,
                responseId: responseId
            )
        }
    default: break
    }
}
```

3. If the token is valid and connected to a Bambuser account the SDK will start with the correct user signed in. If the token is not valid, or if any of the steps is incorrectly implemented, the SDK will send event `unauthorized`.