import Foundation

// Responsibility: Convert to/from JSON, interact w/ Acronym class
class AcronymAPI {

  static func acronymsToDictionary(_ acronyms: [Acronym]) -> [[String: Any]] {
    var acronymsJson: [[String: Any]] = []
    for row in acronyms {
      acronymsJson.append(row.asDictionary())
    }
    return acronymsJson
  }

  static func allAsDictionary() throws -> [[String: Any]] {
    let acronyms = try Acronym.all()
    return acronymsToDictionary(acronyms)
  }

  static func all() throws -> String {
    return try allAsDictionary().jsonEncodedString()
  }

  static func test() throws -> String {
    let acronym = Acronym()
    acronym.short = "AFK"
    acronym.long = "Away From Keyboard"
    try acronym.save { id in
      acronym.id = id as! Int
    }

    return try all()
  }

  static func newAcronym(withShort short: String, long: String) throws -> [String: Any] {
    let acronym = Acronym()
    acronym.short = short
    acronym.long = long
    try acronym.save { id in
      acronym.id = id as! Int
    }
    return acronym.asDictionary()
  }

  static func delete(id: Int) throws {
    // 1
    let acronym = try Acronym.getAcronym(matchingId: id)
    // 2
    try acronym.delete()
  }

}
