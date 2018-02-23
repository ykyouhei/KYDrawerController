# KYDrawerController

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Pod Version](http://img.shields.io/cocoapods/v/KYDrawerController.svg?style=flat)](http://cocoadocs.org/docsets/KYDrawerController/)
[![Pod Platform](http://img.shields.io/cocoapods/p/KYDrawerController.svg?style=flat)](http://cocoadocs.org/docsets/KYDrawerController/)
[![Pod License](http://img.shields.io/cocoapods/l/KYDrawerController.svg?style=flat)](https://github.com/ykyohei/KYDrawerController/blob/master/LICENSE)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat)](https://developer.apple.com/swift)
![Swift version](https://img.shields.io/badge/swift-4.0-orange.svg)

`KYDrawerController` is a side drawer navigation container view controller similar to Android.

* Storyboard Support
* AutoLayout Support

![image.png](https://cloud.githubusercontent.com/assets/5757351/7665531/399a88c0-fbf6-11e4-8051-0d05fa4baa38.png "image.png") ![storyboard.png](https://cloud.githubusercontent.com/assets/5757351/7665532/399c740a-fbf6-11e4-9fb9-4913a8f2e446.png "storyboard.png.png")![drawer.gif](https://cloud.githubusercontent.com/assets/5757351/8270983/3e59cfe6-183a-11e5-8a9b-5a1ac1aee2bc.gif "drawer.png")


## Installation

### CocoaPods

`KYDrawerController ` is available on CocoaPods.
Add the following to your `Podfile`:

```ruby
pod 'KYDrawerController'
```

### Manually
Just add the Classes folder to your project.


## Usage
(see sample Xcode project in `/Example`)

### Code

```Swift
import UIKit
import KYDrawerController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let mainViewController   = MainViewController()
        let drawerViewController = DrawerViewController()
        let drawerController     = KYDrawerController()
        drawerController.mainViewController = UINavigationController(
            rootViewController: mainViewController
        )
        drawerController.drawerViewController = drawerViewController
        
        /* Customize
        drawerController.drawerDirection = .Right
        drawerController.drawerWidth     = 200
        */
       
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = drawerController
        window?.makeKeyAndVisible()
        
        return true
    }
```

### Storyboard
 1. Set the `KYDrawerController` to Custom Class of Initial ViewController.
 
 ![usage1.png](https://cloud.githubusercontent.com/assets/5757351/7665220/a9d378a8-fbe8-11e4-8eb3-a66f37bebece.png)
 
 2.  Connects the `KYEmbedDrawerControllerSegue` to DrawerViewController from `KYDrawerController`
 
 ![usage2.png](https://cloud.githubusercontent.com/assets/5757351/7665217/a995f6ae-fbe8-11e4-811a-779814197a55.png "usage2.png")


 3. Connects the `KYEmbedMainControllerSegue` to DrawerViewController from `KYDrawerController`

 ![usage3.png](https://cloud.githubusercontent.com/assets/5757351/7665218/a99a6748-fbe8-11e4-89d3-e599765f0eb6.png "usage3.png")


 4. Set the SegueIdentifiers to inspector of `KYDrawerController`. 

 ![usage4.png](https://cloud.githubusercontent.com/assets/5757351/7665219/a99c790c-fbe8-11e4-84bc-bf03b01e8a14.png "usage4.png")

 
### Open/Close Drawer
```Swift
func setDrawerState(state: DrawerState, animated: Bool)
```


### Delegate
```Swift
optional func drawerController(_ drawerController: KYDrawerController, willChangeState state: KYDrawerController.DrawerState)
optional func drawerController(_ drawerController: KYDrawerController, didChangeState state: KYDrawerController.DrawerState)
```


## Objective-C version

https://github.com/AustinChou/KYDrawerController-ObjC

## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE). 
