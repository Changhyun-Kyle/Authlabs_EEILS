//
//  URLSessionProtocol.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/24/24.
//

import Foundation

protocol URLSessionProtocol {
  func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
