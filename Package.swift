import PackageDescription

let package = Package(
    name: "PMKCancel",
    dependencies: [
        .Package(url: "https://github.com/mxcl/PromiseKit.git", majorVersion: 6)
    ],
    exclude: [
		"Tests"  // currently SwiftPM is not savvy to having a single test…
    ]
)
