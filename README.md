# Trackingplan for iOS SDK

With Trackingplan for iOS you can make sure that your tracking is going as you planned without changing your current analytics stack or code. 

Trackingplan will monitor traffic between your app and data destinations and automatically detect any changes in your analytics implementation and warn you about inconsistencies like hit drops, missing properties, rogue events, and more.

<img src="https://user-images.githubusercontent.com/47759/125635223-8298353f-168f-4e31-a881-bc1cb7b21b7e.png" width="400" />

Trackingplan is currently available for Web, iOS and Android. More clients will come soon.

Please request your ```TrackingplanId``` at <a href='https://www.trackingplan.com'>trackingplan.com</a> or write us directly team@trackingplan.com.


## Install the SDK

The recommended way to install Trackingplan for iOS is using Swift Package Manager because it makes it simple to install and upgrade.

First, add the Trackingplan dependency using Xcode, like so:

In Xcode, go to File -> Swift Packages -> Add Package Dependency...

<img src="https://user-images.githubusercontent.com/47759/125598926-ab3b6af9-cf09-4fac-97f8-b3242c9acf21.png" width="300" />

If you are asked to choose the project, please choose the one you want to add Trackingplan to.

<img src="https://user-images.githubusercontent.com/47759/125629839-f7090646-503e-4cf8-b669-5bfe0f442937.png" width="300" />

In the search box please put ```https://github.com/trackingplan/trackingplan-ios``` and click next.

<img src="https://user-images.githubusercontent.com/47759/125630384-b4544f77-202f-4567-87bb-c3582535099e.png" width="300" />

Choose the `Version` and leave the default selection for the latest version or customize if needed.

<img src="https://user-images.githubusercontent.com/47759/125630747-06b6df35-4cf0-4312-921e-5ddcdf054d0c.png" width="300" />

Click finish and you will see the library added to the Swift Package Dependencies section.

<img src="https://user-images.githubusercontent.com/47759/125632336-631f195c-4fbb-462a-8255-5e2c67f3f6e7.png" width="300" />
<img src="https://user-images.githubusercontent.com/47759/125632486-18754bb0-8476-4784-a06e-e66b83b7217f.png" width="300" />

Then in your application delegate’s - application:didFinishLaunchingWithOptions: method, set up the SDK like so:

```
//
//  AppDelegate.swift
//  ...

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Initialize Trackingplan SDK
        TrackingPlan.initialize(tpId: "#YourTrackingplanId")
        
        return true
}
```

And of course, import the SDK:

```
//
//  AppDelegate.swift
//  ...

import TrackingPlan
```

All set!

## Can I install SDK using Cocoapods?

Yes, we also sopport installation using Cocoapods.

First, add the Trackingplan dependency to your Podfile, like so:

```

pod 'Trackingplan', :git => 'https://github.com/trackingplan/trackingplan-ios.git'

```

Then in your application delegate’s - application:didFinishLaunchingWithOptions: method, set up the SDK like so:

```
//
//  AppDelegate.swift
//  ...

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Initialize Trackingplan SDK
        TrackingPlan.initialize(tpId: "#YourTrackingplanId")
        
        return true
}
```

And of course, import the SDK:

```
//
//  AppDelegate.swift
//  ...

import TrackingPlan
```

All set!

## Need help?
Questions? Problems? Need more info? Contact us, and we can help!

