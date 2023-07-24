#  Mapbox Routing Issue

This repository contains the minimum required code to reproduce the issue I'm seeing. What I've observed is that
sometimes when a reroute event occurs it will skip majority of the existing waypoints and complete the route earlier than
expected and not require passing through all waypoints. I'm not sure if this is specific to when you've taken a wrong turn 
and ended up on a path that already exists on the route but this seems to be when it happens the most frequently for me.

## Setup

1. Checking this repository.
2. Add a Configurations file with your mapbox credentials:
  ```
    # Config.xcconfig
    MAPBOX_API_KEY = pk.XXXXXXXXXXXXXXXXX
  ```
3. Add the Config file to your build configurations, for more information see: https://medium.com/swift-india/secure-secrets-in-ios-app-9f66085800b4
