//
//  APIType.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/24/24.
//

import Foundation

enum APIType {
  case openAI
  
  var host: String {
    switch self {
    case .openAI:
      "api.openai.com"
    }
  }
  
  var path: String {
    switch self {
    case .openAI:
      "/v1/chat/completions"
    }
  }
  
  var header: [String:String] {
    switch self {
    case .openAI:
      [
        "Content-Type":"application/json",
        "Authorization":Bundle.main.openAIAPIKey,
      ]
    }
  }
}
