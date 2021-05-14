import Combine
import SwiftUI
import WidgetKit

class Provider: TimelineProvider {
  private let locationManager = LocationManager()
  private let repository = VaccineStatusRepository()
  private var disposables = Set<AnyCancellable>()

  func placeholder(in context: Context) -> VaccineEntry {
    VaccineEntry()
  }

  func getSnapshot(in context: Context, completion: @escaping (VaccineEntry) -> ()) {
    getInformationForSnapshot(completion)
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    let currentDate = Date()
    let refreshDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
    getInformationForTimeline(date: refreshDate, completion)
  }

  private func getInformationForSnapshot(_ completion: @escaping (VaccineEntry) -> ()) {
    let _completion = { (entry: VaccineEntry) -> Void in
      completion(entry)
    }
    requestInformation(_completion)
  }

  private func getInformationForTimeline(date: Date, _ completion: @escaping (Timeline<Entry>) -> ()) {
    let _completion = { (entry: VaccineEntry) -> Void in
      let timeline = Timeline(entries: [entry], policy: .after(date))
      completion(timeline)
    }
    requestInformation(_completion)
  }

  private func requestInformation(_ completion: @escaping (VaccineEntry) -> ()) {
    let states = repository.requestInformation()
      .tryMap(parseVaccineSatus)
      .replaceError(with: [])

    let stateString = locationManager.getState()
      .replaceError(with: "TOTAL")

    states.combineLatest(stateString)
      .map(getVaccineEntry)
      .filter { $0 != nil }
      .map { $0! }
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { completion($0) })
      .store(in: &disposables)
  }

  private func getVaccineEntry(states: [State_], stateString: String) -> VaccineEntry? {
    states.first(where: { $0.stateInformation.rawValue == stateString })
      .map { VaccineEntry(state: $0)}
  }
}

@main
struct BrazilCovid19VaccineWidget: Widget {
  let kind: String = "BrazilCovid19VaccineWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      VaccineWidgetView(viewModel: entry)
        .padding(18.0)
    }
    .supportedFamilies([.systemMedium, .systemSmall])
    .configurationDisplayName("Vacinas")
    .description("Acompanhe a progressão da campanha de vacinação.")
  }
}
