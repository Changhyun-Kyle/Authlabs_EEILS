//
//  String+.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/25/24.
//

extension String {
  func formatResponse() -> (definition: String, description: String) {
    let components = self.components(separatedBy: "\n")
    var definition: String?
    var description: String?
    
    for component in components {
      if component.hasPrefix("정의:") {
        definition = component.replacingOccurrences(of: "정의: ", with: "")
      } else if component.hasPrefix("설명:") {
        description = component.replacingOccurrences(of: "설명: ", with: "")
      }
    }
    
    guard
      let definition = definition,
      let description = description
    else {
      return ("정의 없음", "설명 없음")
    }
    
    return (definition, description)
  }
}
