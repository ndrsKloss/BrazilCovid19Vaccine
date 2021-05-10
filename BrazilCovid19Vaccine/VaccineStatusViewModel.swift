import Combine
import SwiftUI

final class VaccineStatusViewModel: ObservableObject, ViewModelType {
  typealias Input = Void

  struct Output {
    let dataSource: AnyPublisher<[VaccineViewModel], Never>
  }

  private let repository: VaccineRequestable
  
  init(
    vaccineRepository: VaccineRequestable = VaccineStatusRepository()
  ) {
    repository = vaccineRepository
  }
  
  func transform(
    _ input: Void = Void()
  ) -> Output {
    let dataSource = repository.requestInformation()
      .tryMap(parseVaccineSatus)
      .replaceError(with: [])
      .eraseToAnyPublisher()
      .map { $0.map(VaccineViewModel.init) }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()

    return Output(
      dataSource: dataSource
    )
  }
}
