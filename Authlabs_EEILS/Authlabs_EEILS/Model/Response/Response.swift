//
//  Response.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/23/24.
//

struct Response: Decodable {
  let id: String
  let object: String
  let created: Int
  let model: String
  let choices: [Choice]
  let usage: Usage
  let systemFingerprint: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case object
    case created
    case model
    case choices
    case usage
    case systemFingerprint = "system_fingerprint"
  }
}
