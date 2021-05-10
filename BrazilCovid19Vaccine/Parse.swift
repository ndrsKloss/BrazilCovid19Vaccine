private let keys = [
  "state",
  "vaccinated",
  "vaccinated_second"
]

func parseVaccineSatus(
  _ string: String
) throws -> [State_] {
  let lines = string.split(separator: "\n")

  guard lines.count > 0 else {
    throw ParseVaccineStatusError.empty
  }

  let indexes = try obtainIndexes(by: lines[0])

  return try parseEntries(
    using: indexes,
    and: lines
  )
}

private func parseEntries(
  using indexes: [Int],
  and lines: [String.SubSequence]
) throws -> [State_] {
  try lines.enumerated()
    .compactMap { index, line -> State_? in
      if index == 0 { return nil }
      let columns = line.split(
        separator: ",",
        omittingEmptySubsequences: false
      )

      let _stateInformation = String(columns[indexes[0]])

      guard let stateInformation = StateInformation.init(rawValue: _stateInformation) else {
        throw ParseVaccineStatusError.noStateInformationFor(value: _stateInformation)
      }

      return State_(
        stateInformation: stateInformation,
        vaccinated: String(columns[indexes[1]]),
        vaccinated2nd: String(columns[indexes[2]])
      )
    }
}

private func obtainIndexes(
  by line: String.SubSequence
) throws -> [Int] {
  var indexes = [Int]()

  let columns = line.split(
    separator: ",",
    omittingEmptySubsequences: false
  )

  for (index, column) in columns.enumerated() {
    for key in keys {
      if key == column {
        indexes.append(index)
      }
    }
  }

  guard indexes.count == keys.count else {
    throw ParseVaccineStatusError.missingOneOrMoreKeys
  }

  return indexes
}

enum ParseVaccineStatusError: Error {
  case empty
  case missingOneOrMoreKeys
  case noStateInformationFor(value: String)
}
