import SwiftUI

struct VaccineView: View {
  /* Not sure how I fell about these @States */
  @State private var _title = ""
  @State private var vacineData = VaccineViewModel.VaccineData(
    vaccineText: "",
    vaccineProportion: 0.0,
    vaccineBarColor: .clear
  )
  @State private var vaccine2ndData = VaccineViewModel.VaccineData(
    vaccineText: "",
    vaccineProportion: 0.0,
    vaccineBarColor: .clear
  )

  let output: VaccineViewModel.Output

  init(
    viewModel: VaccineViewModel
  ) {
    output = viewModel.transform()
  }

  var body: some View {
    VStack(alignment: .leading, content: {
      Spacer()
      title
      Spacer()
      VacineProgressView(vaccineData: vacineData)
        .onReceive(output.vaccineData) { vacineData = $0 }
      Spacer()
      VacineProgressView(vaccineData: vaccine2ndData)
        .onReceive(output.vaccine2ndData) { vaccine2ndData = $0 }
    })
  }
}

extension VaccineView {
  var title: some View {
    Text(_title)
      .font(.title3)
      .fontWeight(.semibold)
      .onReceive(output.title) { _title = $0 }
  }
}

private struct VacineProgressView: View {
  let vaccineData: VaccineViewModel.VaccineData
  var body: some View {
    Text(vaccineData.vaccineText)
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

#if DEBUG
struct VaccineView_Previews: PreviewProvider {
  static let rs = State_(
    stateInformation: .RS,
    vaccinated: "5729648", //50%
    vaccinated2nd: "2864824" //25%
  )

  static let viewModel = VaccineViewModel(state: rs)

  static var previews: some View {
    Group {
      VaccineView(viewModel: viewModel)
        .previewLayout(.sizeThatFits)
        .frame(height: 150.0)
        .padding(10.0)
    }
  }
}
#endif
