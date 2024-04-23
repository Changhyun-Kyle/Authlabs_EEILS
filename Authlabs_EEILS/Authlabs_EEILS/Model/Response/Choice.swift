//
//  Choice.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/23/24.
//

struct Choice: Decodable {
  let index: Int
  let message: ResponseMessage
  var logprobs: String?
  let finishReason: String
  
  enum CodingKeys: String, CodingKey {
    case index
    case message
    case logprobs
    case finishReason = "finish_reason"
  }
}
