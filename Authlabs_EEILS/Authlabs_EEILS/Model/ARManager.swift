//
//  ARManager.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/24/24.
//

import Foundation

final class ARManager {
  private let arRepository: ARRepository = .init()
  
  func fetchResponse(imageURL: String) async throws -> ResponseMessage {
    let result = try await arRepository.fetchData(imageURL: imageURL)
    switch result {
    case .success(let response):
      let message = response.choices[0].message
      return message
    case .failure(let error):
      throw error
    }
  }
}
