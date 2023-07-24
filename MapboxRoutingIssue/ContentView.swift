//
//  ContentView.swift
//  MapboxRoutingIssue
//
//  Created by Michael Treacher on 24/7/2023.
//

import SwiftUI
import MapboxDirections
import CoreLocation
import MapboxCoreNavigation
import MapboxNavigation
import MapboxMaps

struct ContentView: View {
  @State private var response: RouteResponse?
  @State private var showNavigation: Bool = false {
    didSet {
      if !showNavigation {
        response = nil
      }
    }
  }

  let locationManager = CLLocationManager()
  let coordinates = [
    CLLocationCoordinate2D(latitude: -37.38673740000001, longitude: 144.9966776),
    CLLocationCoordinate2D(latitude: -37.3906676, longitude: 144.990712),
    CLLocationCoordinate2D(latitude: -37.3951931, longitude: 144.9905971),
    CLLocationCoordinate2D(latitude: -37.3949726, longitude: 145.0022939),
    CLLocationCoordinate2D(latitude: -37.3902517, longitude: 145.0008587),
    CLLocationCoordinate2D(latitude: -37.3872667, longitude: 144.998909)
  ]

  var body: some View {
    VStack {
      Spacer()
      Button("Test Route") {
        Task {
          let waypoints = generateWaypoints(startingLocation: locationManager.location?.coordinate, coordinates: coordinates)
          let routeOptions = NavigationRouteOptions(waypoints: waypoints, profileIdentifier: .automobile)

          routeOptions.includesAlternativeRoutes = false

          self.response = try await Directions.shared.calculate(options: routeOptions)
        }
      }
      Spacer()
    }
    .padding()
    .task {
      locationManager.requestWhenInUseAuthorization()
    }
  }

  func generateWaypoints(startingLocation: CLLocationCoordinate2D? = nil, coordinates: [CLLocationCoordinate2D]) -> [Waypoint] {
    var waypoints: [Waypoint] = []

    for coordinate in coordinates {
      let waypoint = Waypoint(
        coordinate: coordinate
      )
      waypoints.append(waypoint)
    }

    if startingLocation != nil {
      waypoints.insert(Waypoint(coordinate: startingLocation!, name: "Start"), at: 0)
    }

    for waypoint in waypoints.dropFirst().dropLast() {
      waypoint.separatesLegs = false
    }

    return waypoints
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
