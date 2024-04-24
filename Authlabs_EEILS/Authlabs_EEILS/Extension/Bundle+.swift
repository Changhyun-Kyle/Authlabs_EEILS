//
//  Bundle+.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/24/24.
//

import Foundation

extension Bundle {
  var openAIAPIKey: String {
    guard 
      let key = self.object(forInfoDictionaryKey: "openAI_API_KEY") as? String
    else {
      return ""
    }
    return key
  }
}
