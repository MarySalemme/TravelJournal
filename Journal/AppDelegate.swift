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
    locationManager.distanceFilter = 35
    locationManager.allowsBackgroundLocationUpdates = true
    locationManager.startUpdatingLocation()
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
    
    // Creates notification content
    let content = UNMutableNotificationContent()
    content.title = "New Travel Journal entry 📍"
    content.body = location.description
    content.sound = .default
    
    // Creates a second long trigger and notification request with that trigger
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
    let request = UNNotificationRequest(identifier: location.dateString, content: content, trigger: trigger)
    
    // Schedules the notification by adding request to notification center
    notificationCenter.add(request, withCompletionHandler: nil)
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      guard let location = locations.first else {
        return
      }
      AppDelegate.geoCoder.reverseGeocodeLocation(location) { placemarks, _ in
      if let place = placemarks?.first {
        let description = "Fake visit: \(place)"
        let fakeVisit = MockVisit(
          coordinates: location.coordinate,
          arrivalDate: Date(),
          departureDate: Date())
        self.newVisitReceived(fakeVisit, description: description)
      }
    }
  }
}

/// Mock for CLVisit properties
final class MockVisit: CLVisit {
  private let mockCoordinates: CLLocationCoordinate2D
  private let mockArrivalDate: Date
  private let mockDepartureDate: Date
  
  override var coordinate: CLLocationCoordinate2D {
    return mockCoordinates
  }
  
  override var arrivalDate: Date {
    return mockArrivalDate
  }
  
  override var departureDate: Date {
    return mockDepartureDate
  }
  
  init(coordinates: CLLocationCoordinate2D, arrivalDate: Date, departureDate: Date) {
      mockCoordinates = coordinates
      mockArrivalDate = arrivalDate
      mockDepartureDate = departureDate
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
