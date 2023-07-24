//
//  NavigationView.swift
//  MapboxRoutingIssue
//
//  Created by Michael Treacher on 24/7/2023.
//

import SwiftUI
import MapboxNavigation
import MapboxCoreNavigation
import MapboxDirections
import MapboxMaps
import CoreLocation

struct NavigationView: UIViewControllerRepresentable {
  @Environment(\.dismiss) var dismiss

  public let indexedRouteResponse: IndexedRouteResponse
  public let routeOptions: RouteOptions

  public func makeUIViewController(context: Context) -> NavigationViewController {
    let navigationService = MapboxNavigationService(
      indexedRouteResponse: indexedRouteResponse,
      customRoutingProvider: nil,
      credentials: NavigationSettings.shared.directions.credentials
    )

    navigationService.router.reroutesProactively = false
    navigationService.router.refreshesRoute = false

    let navigationOptions = NavigationOptions(navigationService: navigationService)

    let navigationViewController = NavigationViewController(
      for: indexedRouteResponse,
      navigationOptions: navigationOptions
    )

    navigationViewController.showsSpeedLimits = false
    navigationViewController.showsContinuousAlternatives = false
    navigationViewController.modalPresentationStyle = .fullScreen
    navigationViewController.routeLineTracksTraversal = true
    navigationViewController.delegate = context.coordinator

    return navigationViewController
  }

  public func updateUIViewController(_ uiViewController: NavigationViewController, context: Context) {}

  func makeCoordinator() -> Coordinator {
    Coordinator()
  }

  class Coordinator: NSObject, NavigationViewControllerDelegate {
    func navigationViewController(_ navigationViewController: NavigationViewController, shouldRerouteFrom location: CLLocation) -> Bool {
      let routeProgress = navigationViewController.navigationService.routeProgress
      let newRouteOptions = routeProgress.reroutingOptions(from: location)

      Directions.shared.calculate(newRouteOptions) { (_, result) in
        switch result {
        case .failure(let error):
          print(error.localizedDescription)
        case .success(let response):
          guard let routeShape = response.routes?.first?.shape else {
            return
          }

          let matchOptions = NavigationMatchOptions(coordinates: routeShape.coordinates)

          for waypoint in matchOptions.waypoints.dropFirst().dropLast() {
            waypoint.separatesLegs = false
          }

          Directions.shared.calculateRoutes(matching: matchOptions) { (_, result) in
            switch result {
            case .failure(let error):
              print(error.localizedDescription)
            case .success(let response):
              guard !(response.routes?.isEmpty ?? true) else {
                return
              }

              // Convert matchOptions to `RouteOptions`
              let routeOptions = RouteOptions(matchOptions: matchOptions)

              // Set the route
              navigationViewController.navigationService.router.updateRoute(with: .init(routeResponse: response, routeIndex: 0),
                                                                            routeOptions: routeOptions,
                                                                            completion: nil)
            }
          }
        }
      }

      return true
    }

    func navigationViewControllerDidDismiss(_ navigationViewController: NavigationViewController, byCanceling canceled: Bool) {
      navigationViewController.dismiss(animated: true)
    }
  }
}
