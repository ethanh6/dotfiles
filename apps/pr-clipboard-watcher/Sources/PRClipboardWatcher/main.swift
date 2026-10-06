import AppKit
import Foundation

if CommandLine.arguments.contains("--selftest") {
  SelfTest.run()
}

Watcher().run()
