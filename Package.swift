// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "iOS_SideMenu_Example",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "iOS_SideMenu_Example",
            targets: ["iOS_SideMenu_Example"]),
    ],
    dependencies: [
        // No external dependencies
    ],
    targets: [
        .target(
            name: "iOS_SideMenu_Example",
            dependencies: [],
            path: "SideMenuExample",
            resources: [
                .process("Assets.xcassets"),
                .process("Info.plist")
            ]
        ),
        .testTarget(
            name: "iOS_SideMenu_ExampleTests",
            dependencies: ["iOS_SideMenu_Example"],
            path: "SideMenu_ExTests"
        ),
    ]
)