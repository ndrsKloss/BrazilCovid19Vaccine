import Combine
import SwiftUI

struct VaccineStatusView: View {
  @State private var dataSource: [VaccineViewModel] = []

  private var output: VaccineStatusViewModel.Output
  private var disposables = Set<AnyCancellable>()

  init(
    viewModel: VaccineStatusViewModel = VaccineStatusViewModel()
  ) {
    output = viewModel.transform()
  }

  var body: some View {
    NavigationView {
      list
    }
  }
}

extension VaccineStatusView {
  var list: some View {
    List(dataSource, rowContent: VaccineView.init)
      .onReceive(output.dataSource) { dataSource = $0 }
  }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    VaccineStatusView()
  }
}
#endif
