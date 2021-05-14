import SwiftUI
import Combine

struct VaccineWidgetView: View {
  @State private var _title = ""
  @State private var vacineData = VaccineViewModel.VaccineData()
  @State private var vaccine2ndData = VaccineViewModel.VaccineData()

  let output: VaccineViewModel.Output

  init(
    viewModel: VaccineViewModel
  ) {
    output = viewModel.transform()
  }

  var body: some View {
    VStack(alignment: .leading, content: {
      title
      Spacer()
      VacineProgressView(vaccineData: vacineData)
        .onReceive(output.vaccineData) { vacineData = $0 }
      VacineProgressView(vaccineData: vaccine2ndData)
        .onReceive(output.vaccine2ndData) { vaccine2ndData = $0 }
    })
  }
}

extension VaccineWidgetView {
  var title: some View {
    Text(_title)
      .font(.system(size: 16.0, weight: .semibold))
      .onReceive(output.title) { _title = $0 }
  }
}

private struct VacineProgressView: View {
  let vaccineData: VaccineViewModel.VaccineData
  var body: some View {
    Text(vaccineData.vaccineText)
      .font(.system(size: 13.0, weight: .bold))
    GeometryReader { metrics in
      Capsule(style: .circular)
        .fill(vaccineData.vaccineBarColor)
        .frame(width: metrics.size.width * CGFloat(vaccineData.vaccineProportion), height: 10.0)
      Capsule(style: .circular)
        .fill(vaccineData.vaccineBarColor.opacity(0.2))
        .frame(width: metrics.size.width, height: 10.0)
    }
  }
}
