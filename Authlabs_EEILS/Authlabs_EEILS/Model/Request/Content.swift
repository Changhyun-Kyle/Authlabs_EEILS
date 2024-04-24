//
//  Content.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/23/24.
//

struct Content: Encodable {
  let type: String
  var text: String? = nil
  var imageURL: ImageURL? = nil
  
  enum CodingKeys: String, CodingKey {
    case type
    case text
    case imageURL = "image_url"
  }
}
