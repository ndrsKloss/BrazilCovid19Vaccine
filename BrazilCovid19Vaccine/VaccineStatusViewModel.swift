import Combine
import SwiftUI

import CoreLocation

final class VaccineStatusViewModel: ObservableObject, ViewModelType {
  typealias Input = Void

  struct Output {
    let dataSource: AnyPublisher<[VaccineViewModel], Never>
  }

  private let repository: VaccineRequestable
  private var disposables = Set<AnyCancellable>()

  init(
    vaccineRepository: VaccineRequestable = VaccineStatusRepository(),
    locationManager: LocationManager = LocationManager()
  ) {
    repository = vaccineRepository
    locationManager.requestWhenInUseAuthorization()
  }
  
  func transform(
    _ input: Void = Void()
  ) -> Output {
    let dataSource = repository.requestInformation()
      .tryMap(parseVaccineSatus)
      .replaceError(with: [])
      .map { $0.map(VaccineViewModel.init) }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()

    return Output(
      dataSource: dataSource
    )
  }
}
