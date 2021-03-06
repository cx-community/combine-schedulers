// swift-tools-version:5.1

import PackageDescription

let package = Package(
  name: "combine-schedulers",
  platforms: [
    .iOS(.v10),
    .macOS(.v10_12),
    .tvOS(.v10),
    .watchOS(.v3),
  ],
  products: [
    .library(
      name: "CombineSchedulers",
      targets: ["CombineSchedulers"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/cx-org/CombineX", .upToNextMinor(from: "0.3.0")),
  ],
  targets: [
    .target(
      name: "CombineSchedulers",
      dependencies: [.product(name: "CXShim", package: "CombineX")]),
    .testTarget(
      name: "CombineSchedulersTests",
      dependencies: ["CombineSchedulers"]
    ),
  ]
)

enum CombineImplementation {
  
  case combine
  case combineX
  case openCombine
  
  static var `default`: CombineImplementation {
    #if canImport(Combine)
    return .combine
    #else
    return .combineX
    #endif
  }
  
  init?(_ description: String) {
    let desc = description.lowercased().filter { $0.isLetter }
    switch desc {
    case "combine":     self = .combine
    case "combinex":    self = .combineX
    case "opencombine": self = .openCombine
    default:            return nil
    }
  }
}

extension ProcessInfo {
  
  var combineImplementation: CombineImplementation {
    return environment["CX_COMBINE_IMPLEMENTATION"].flatMap(CombineImplementation.init) ?? .default
  }
  
  var isCI: Bool {
    return (environment["CX_CONTINUOUS_INTEGRATION"] as NSString?)?.boolValue ?? false
  }
}

import Foundation

let info = ProcessInfo.processInfo
if info.combineImplementation == .combine {
  package.platforms = [.macOS("10.15"), .iOS("13.0"), .tvOS("13.0"), .watchOS("6.0")]
}
