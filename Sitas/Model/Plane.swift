//
//  Plane.swift
//  Sitas
//
//  Created by steph on 4/29/21.
//

import Foundation

// MARK: - State
enum State: String, Codable {
  case active
  case inactive
  case other

  init(from decoder: Decoder) throws {
    let label = try decoder.singleValueContainer().decode(String.self)
    switch label {
      case "Y": self = .active
      case "N": self = .inactive
      default: self = .other
    }
  }
}

// MARK: - Plane structure
struct Plane: Codable {
  // MARK: - public vars
  var id: String
  let name: String
  let iata: String
  let icao: String
  let callsign: String
  let country: String
  let state: State
  let imageString: String?

  var hasId: Bool {
    return id != ""
  }

  var hasName: Bool {
    return name != ""
  }

  var hasCountry: Bool {
    return country != ""
  }

  var isActive: Bool {
    return state == .active
  }

  private enum CodingKeys: String, CodingKey {
    case id
    case name
    case iata
    case icao
    case callsign
    case country
    case state = "active"
    case imageString = "image"
  }
}
