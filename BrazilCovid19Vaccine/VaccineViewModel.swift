import SwiftUI
import Combine

final class VaccineViewModel: ObservableObject, ViewModelType {
  typealias Input = Void

  struct Output {
    let title: Just<String>
    let vaccineData: Just<VaccineData>
    let vaccine2ndData: Just<VaccineData>
  }

  private let state: State_

  init(state: State_) {
    self.state = state
  }

  func transform(
    _ input: Void = Void()
  ) -> Output {
    let title = Just(state.stateInformation.rawValue)

    let vaccineData = VaccineData(
      vaccineText: "1ª dose - \(state.vaccinatedPercentFormated)",
      vaccineProportion: state.vaccinatedProportion,
      vaccineBarColor: colorForPercentage(proportion: state.vaccinatedProportion)
    )

    let vaccine2ndData = VaccineData(
      vaccineText: "2ª dose - \(state.vaccinated2ndPercentFormated)",
      vaccineProportion: state.vaccinated2ndProportion,
      vaccineBarColor: colorForPercentage(proportion: state.vaccinated2ndProportion)
    )

    return Output(
      title: title,
      vaccineData: Just(vaccineData),
      vaccine2ndData: Just(vaccine2ndData)
    )
  }
}

extension VaccineViewModel {
  func colorForPercentage(proportion: Double) -> Color {
    let percentage = proportion * 100
    if percentage <= 20.0 {
      return .red
    } else if percentage > 20.0 && percentage <= 40.0 {
      return .orange
    } else if percentage > 40.0 && percentage <= 60.0 {
      return .yellow
    } else if percentage > 60.0 && percentage <= 80.0 {
      return .blue
    } else {
      return .green
    }
  }
}

extension VaccineViewModel: Identifiable {
  var id: String {
    state.id
  }
}

extension VaccineViewModel: Equatable {
  static func ==(lhs: VaccineViewModel, rhs: VaccineViewModel) -> Bool {
    lhs.state == rhs.state
  }
}

extension VaccineViewModel: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(state)
  }
}

extension VaccineViewModel {
  struct VaccineData {
    let vaccineText: String
    let vaccineProportion: Double
    let vaccineBarColor: Color
  }
}
