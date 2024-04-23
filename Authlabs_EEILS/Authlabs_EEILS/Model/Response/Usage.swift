//
//  Usage.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/23/24.
//

struct Usage: Decodable {
  let promptTokens: Int
  let completionTokens: Int
  let totalTokens: Int
  
  enum CodingKeys: String, CodingKey {
    case promptTokens = "prompt_tokens"
    case completionTokens = "completion_tokens"
    case totalTokens = "total_tokens"
  }
}
