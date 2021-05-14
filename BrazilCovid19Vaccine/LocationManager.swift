import Combine
import CoreLocation

final class LocationManager: NSObject {
  private let locationManager: CLLocationManager

  let authorizationSuccess = PassthroughSubject<Void, Never>()

  init(
    manager: CLLocationManager = CLLocationManager()
  ) {
    locationManager = manager

    super.init()
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
  }

  func requestWhenInUseAuthorization() {
    locationManager.requestWhenInUseAuthorization()
  }
}

extension LocationManager {
  func getState() -> Future<String, Error> {
    return Future() { [locationManager] promise in
      guard let location = locationManager.location else {
        promise(.failure(LocationManagerError.noLocationFound))
        return
      }

      let geocoder = CLGeocoder()

      geocoder.reverseGeocodeLocation(location) { placemarks, error in
        if let error = error {
          promise(.failure(error))
          return
        }

        guard let placemark = placemarks?[0] else {
          promise(.failure(LocationManagerError.noPlacemarkFound))
          return
        }

        guard let state = placemark.administrativeArea else {
          promise(.failure(LocationManagerError.noStateFound))
          return
        }

        promise(.success(state))
      }
    }
  }
}

enum LocationManagerError: Error {
  case noLocationFound
  case noPlacemarkFound
  case noStateFound
}
