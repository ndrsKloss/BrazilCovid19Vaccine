import Foundation

struct State_ /* Prevent conflict with @State property wrapper */ {
  private let formatter: NumberFormatter = {
    $0.numberStyle = .percent
    $0.maximumFractionDigits = 2
    $0.locale = Locale.current
    return $0
  }(NumberFormatter())

  private let _vaccinated: String
  private let _vaccinated2nd: String

  private var vaccinated: Int {
    Int(_vaccinated) ?? 0
  }

  private var vaccinated2nd: Int {
    Int(_vaccinated2nd) ?? 0
  }

  let stateInformation: StateInformation

  var vaccinatedProportion: Double {
    Double(vaccinated) / Double(stateInformation.population)
  }

  var vaccinated2ndProportion: Double {
    Double(vaccinated2nd) / Double(stateInformation.population)
  }

  var vaccinatedPercentFormated: String {
    formatter.string(from: NSNumber(value: vaccinatedProportion)) ?? ""
  }

  var vaccinated2ndPercentFormated: String {
    formatter.string(from: NSNumber(value: vaccinated2ndProportion)) ?? ""
  }

  init(
    stateInformation: StateInformation = .PLACEHOLDER,
    vaccinated: String = "0",
    vaccinated2nd: String = "0"
  ) {
    self.stateInformation = stateInformation
    _vaccinated = vaccinated
    _vaccinated2nd = vaccinated2nd
  }
}

// www.ibge.gov.br, retrieved on May 7, 2021

enum StateInformation: String {
  case AC, AL, AP, AM, BA, CE, DF, ES, GO, MA, MT, MS, MG, PA, PB, PR, PE, PI, RJ, RN, RS, RO, RR, SC, SP, SE, TO, TOTAL
  case PLACEHOLDER = ""
  
  var population: Int {
    switch self {
    case .AC: return 905071
    case .AL: return 3363147
    case .AP: return 875121
    case .AM: return 4260392
    case .BA: return 1497536
    case .CE: return 9232215
    case .DF: return 3085712
    case .ES: return 4101482
    case .GO: return 7194691
    case .MA: return 7147453
    case .MT: return 3560382
    case .MS: return 2834399
    case .MG: return 21393128
    case .PA: return 8765158
    case .PB: return 4055935
    case .PR: return 11584304
    case .PE: return 9666809
    case .PI: return 3287153
    case .RJ: return 17445734
    case .RN: return 3557335
    case .RS: return 11459296
    case .RO: return 1812291
    case .RR: return 637958
    case .SC: return 7324586
    case .SP: return 46593085
    case .SE: return 2335716
    case .TO: return 1604867
    case .TOTAL: return 213060458
    case .PLACEHOLDER: return 1
    }
  }
}

extension State_: Identifiable {
  var id: String {
    UUID().uuidString
  }
}

extension State_: Equatable {
  static func ==(lhs: State_, rhs: State_) -> Bool {
    return lhs.stateInformation.rawValue == rhs.stateInformation.rawValue &&
      lhs._vaccinated == rhs._vaccinated &&
      lhs._vaccinated2nd == rhs._vaccinated2nd
  }
}

extension State_: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(stateInformation.rawValue)
    hasher.combine(_vaccinated)
    hasher.combine(_vaccinated2nd)
  }
}
