//
//  JSONHandler.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/24/24.
//

import Foundation

struct JSONHandler {
  private static let decoder = JSONDecoder()
  private static let encoder = JSONEncoder()
  
  static func handleEncodedData(data: Encodable) throws -> Data {
    do {
      let encodedData = try encoder.encode(data)
      return encodedData
    } catch {
      throw NetworkError.encodingError
    }
  }
  
  static func handleDecodedData<T: Decodable>(data: Data?) -> Result<T, NetworkError> {
    guard
      let data = data
    else {
      return .failure(.noDataError)
    }
    
    do {
      let decodedData = try decoder.decode(T.self, from: data)
      return .success(decodedData)
    } catch {
      return .failure(.decodingError)
    }
  }
}
