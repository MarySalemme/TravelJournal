import UIKit
import MapKit

class MapViewController: UIViewController {
  @IBOutlet weak var mapView: MKMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.userTrackingMode = .follow
  }
  
  @IBAction func addItemPressed(_ sender: Any) {
    
  }
}
