//
//  Request.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/23/24.
//

struct Request: Encodable {
  let model: String
  let messages: [RequestMessage]
  let maxTokens: Int
  
  enum CodingKeys: String, CodingKey {
    case model
    case messages
    case maxTokens = "max_tokens"
  }
}
