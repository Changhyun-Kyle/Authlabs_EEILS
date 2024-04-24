//
//  RequestMessage.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/23/24.
//

struct RequestMessage: Encodable {
  let role: String = "user"
  let content: [Content]
}
