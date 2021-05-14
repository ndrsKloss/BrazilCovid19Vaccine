import Combine
import SwiftUI

import CoreLocation

struct VaccineStatusView: View {
  @State private var dataSource: [VaccineViewModel] = []

  private var viewModel: VaccineStatusViewModel
  private var output: VaccineStatusViewModel.Output

  let manager: CLLocationManager = CLLocationManager()

  init(
    viewModel: VaccineStatusViewModel = VaccineStatusViewModel()
  ) {
    self.viewModel = viewModel
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
      .onReceive(output.dataSource) {
        dataSource = $0
      }
  }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    VaccineStatusView()
  }
}
#endif
