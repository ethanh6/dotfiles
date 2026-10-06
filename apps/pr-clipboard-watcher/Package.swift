// swift-tools-version:5.9
import PackageDescription

let package = Package(
  name: "PRClipboardWatcher",
  platforms: [.macOS(.v13)],
  targets: [
    .executableTarget(
      name: "pr-clipboard-watcher",
      path: "Sources/PRClipboardWatcher"
    )
  ]
)
