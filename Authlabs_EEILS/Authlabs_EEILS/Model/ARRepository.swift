//
//  ARRepository.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/24/24.
//

import Foundation

final class ARRepository {
  private let networkService: NetworkService
  
  init(
    networkService: NetworkService = NetworkService()
  ) {
    self.networkService = networkService
  }
  
  func fetchData(imageURL: String) async throws -> Result<Response, NetworkError> {
    let body = self.makeBody(imageURL: imageURL)
    let result = try await networkService.fetchOpenAIResponse(
      type: .openAI,
      httpMethod: .POST(body: body)
    )
    
    switch result {
    case .success(let data):
      return JSONHandler.handleDecodedData(data: data)
    case .failure(let error):
      return .failure(error)
    }
  }
}

private extension ARRepository {
  func makeBody(imageURL: String) -> Request {
    let request = Request(
      messages: [
        RequestMessage(
          content: [
            Content(
              type: "text",
              text: "해당 이미지에 대한 정의, 설명. 정의:, 설명: 포맷으로"
            ),
            Content(
              type: "image_url",
              imageURL: ImageURL(url: "data:image/jpeg;base64,\(imageURL)")
            )
          ]
        )
      ]
    )
    return request
  }

}
