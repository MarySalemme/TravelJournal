import UIKit
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  // Needed for reverse geocoding. It takes some coordinates and returns an address
  static let geoCoder = CLGeocoder()
  let notificationCenter = UNUserNotificationCenter.current()
  let locationManager = CLLocationManager()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    let newColor = UIColor(red: 110/255, green: 47/255, blue: 156/255, alpha: 1)
    UITabBar.appearance().tintColor = newColor
    
    notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
      
    }
    
    locationManager.requestAlwaysAuthorization()
    locationManager.startMonitoringVisits()
    locationManager.delegate = self as CLLocationManagerDelegate
    
    return true
  }
}

extension AppDelegate: CLLocationManagerDelegate {
  /// Callback from `CLLOcationManager` when the new visit is recorded
  func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
    // create location from the coordinates of CLVisit
    let clLocation = CLLocation(latitude: visit.coordinate.latitude, longitude: visit.coordinate.longitude)
    
    AppDelegate.geoCoder.reverseGeocodeLocation(clLocation) { (placemarks, error) in
      if let place = placemarks?.first {
        let description = "\(place)"
        self.newVisitReceived(visit, description: description)
      } else if let error = error {
        assertionFailure(error as! String)
      }
    }
  }
  
  /// Saves the location to disk
  func newVisitReceived(_ visit: CLVisit, description: String) {
    let location = Location(visit: visit, descriptionString: description)
  }
}
