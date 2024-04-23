//
//  Content.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/23/24.
//

struct Content: Encodable {
  let type: String
  let text: String?
  let imageURL: ImageURL?
  
  enum CodingKeys: String, CodingKey {
    case type
    case text
    case imageURL = "image_url"
  }
}
