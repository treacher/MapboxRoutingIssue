//
//  Directions+AsyncAwait.swift
//  MapboxRoutingIssue
//
//  Created by Michael Treacher on 24/7/2023.
//

import Foundation
import MapboxCoreNavigation
import MapboxDirections

extension Directions {
  func calculate(options: RouteOptions) async throws -> RouteResponse {
    try await withCheckedThrowingContinuation { continuation in
      _ = calculate(options) { _, result in
        switch result {
        case .success(let response):
          continuation.resume(returning: response)
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
}
