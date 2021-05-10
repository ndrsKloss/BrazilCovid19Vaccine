import Foundation
import Combine

protocol VaccineRequestable {
  func requestInformation() -> AnyPublisher<String, VaccineStatusError>
}

final class VaccineStatusRepository {
  private let session: URLSession
  
  init(session: URLSession = .shared) {
    self.session = session
  }
}

extension VaccineStatusRepository {
  private var components: URLComponents {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "raw.githubusercontent.com"
    components.path = "/wcota/covid19br/master/cases-brazil-total.csv"
    return components
  }
}

extension VaccineStatusRepository: VaccineRequestable {
  func requestInformation() -> AnyPublisher<String, VaccineStatusError> {
    guard let url = components.url else {
      let error = VaccineStatusError.some(description: "Couldn't create URL")
      return Fail(error: error)
        .eraseToAnyPublisher()
    }

    return session.dataTaskPublisher(for: URLRequest(url: url))
      .mapError { .some(description: $0.localizedDescription) }
      .map { String(decoding: $0.data, as: UTF8.self) }
      .eraseToAnyPublisher()
  }
}

enum VaccineStatusError: Error {
  case some(description: String)
}
