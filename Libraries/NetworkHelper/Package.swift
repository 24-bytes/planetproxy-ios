// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "NetworkHelper",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "NetworkHelper",
            targets: ["NetworkHelper"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.7.0")
    ],
    targets: [
        .target(
            name: "NetworkHelper",
            dependencies: ["Alamofire"],
            path: "Sources/NetworkHelper"
        )
    ]
)
