import UIKit
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  let center = UNUserNotificationCenter.current()
  let locationManager = CLLocationManager()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    let newColor = UIColor(red: 110/255, green: 47/255, blue: 156/255, alpha: 1)
    UITabBar.appearance().tintColor = newColor
    return true
  }
}

