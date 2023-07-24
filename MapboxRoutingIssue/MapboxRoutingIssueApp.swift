//
//  MapboxRoutingIssueApp.swift
//  MapboxRoutingIssue
//
//  Created by Michael Treacher on 24/7/2023.
//

import SwiftUI
import MapboxCoreNavigation

@main
struct MapboxRoutingIssueApp: App {
  init() {
    NavigationSettings.shared.initialize(with: .init(
      alternativeRouteDetectionStrategy: AlternativeRouteDetectionStrategy?.none))
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
