//
//  NetworkService.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/24/24.
//

import Foundation

final class NetworkService {
  typealias NetworkResult = Result<Data, NetworkError>
  
  private let session: URLSessionProtocol
  
  init(
    session: URLSessionProtocol = URLSession.shared
  ) {
    self.session = session
  }
  
  func fetchOpenAIResponse<T:Encodable>(
    type: APIType,
    httpMethod: HttpMethod<T>
  ) async throws -> NetworkResult {
    guard let urlRequest = try NetworkURL.makeURLRequest(type: type, httpMethod: httpMethod) else { throw NetworkError.requestFailError }
    let (data, response) = try await self.session.data(for: urlRequest)
    return handleDataTaskCompletion(data: data, response: response)
  }
}

private extension NetworkService {
  func handleDataTaskCompletion(
      data: Data?,
      response: URLResponse?
  ) -> NetworkResult {
      guard
          let httpResponse = response as? HTTPURLResponse
      else {
          return .failure(.invalidResponseError)
      }
      
      return self.handleHTTPResponse(
          data: data,
          httpResponse: httpResponse
      )
  }
  
  func handleHTTPResponse(
      data: Data?,
      httpResponse: HTTPURLResponse
  ) -> NetworkResult {
      guard
          let data = data
      else {
          return .failure(.noDataError)
      }
      switch httpResponse.statusCode {
      case 300..<400:
          return .failure(.redirectionError)
      case 400..<500:
          return .failure(.clientError)
      case 500..<600:
          return .failure(.serverError)
      default:
          return .success(data)
      }
  }
}
