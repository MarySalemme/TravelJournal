import UIKit
import UserNotifications

class PlacesTableViewController: UITableViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return LocationsStorage.shared.locations.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 110
  }
}
