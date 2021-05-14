import WidgetKit

final class VaccineEntry: VaccineViewModel, TimelineEntry {
  var date: Date

  init(
    state: State_ = State_(),
    date: Date = Date()
  ) {
    self.date = date
    super.init(state: state)
  }
}
