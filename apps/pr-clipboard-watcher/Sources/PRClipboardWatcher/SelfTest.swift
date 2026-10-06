import Foundation

/// Assertion-based self tests, runnable without XCTest (Command Line Tools only).
/// Run with `swift run pr-clipboard-watcher --selftest`; exits non-zero on failure.
enum SelfTest {
  static func run() -> Never {
    var failures = 0

    func expect(_ input: String, _ expected: String?, line: Int = #line) {
      let actual = extractTicketReference(from: input)
      if actual != expected {
        failures += 1
        print("FAIL (line \(line)): \(input) -> \(String(describing: actual)), expected \(String(describing: expected))")
      } else {
        print("PASS: \(input) -> \(String(describing: actual))")
      }
    }

    expect("https://github.com/replit/repl-it-web/pull/136633", "136633")
    expect("https://github.com/replit/repl-it-web/pull/136633/", "136633")
    expect("https://github.com/replit/repl-it-web/pull/136633/files", "136633")
    expect("https://github.com/replit/repl-it-web/pull/136633?w=1", "136633")
    expect("https://github.com/replit/repl-it-web/pull/136633#discussion_r1", "136633")
    expect("  https://github.com/replit/repl-it-web/pull/136633\n", "136633")
    expect("http://github.com/replit/repl-it-web/pull/7", "7")
    expect("https://github.com/replit/repl-it-web/issues/136633", nil)
    expect("https://github.com/replit/repl-it-web", nil)
    expect("https://example.com/replit/repl-it-web/pull/136633", nil)
    expect("not a url", nil)
    expect("https://github.com/replit/repl-it-web/pull/136633 and more text", nil)

    // Linear issues
    expect("https://linear.app/replit/issue/SRE-3764/m47-verify-humain-retirement-and-reconcile-remaining-scope#comment-ef073b38", "SRE-3764")
    expect("https://linear.app/replit/issue/SRE-3764/m47-verify-humain-retirement-and-reconcile-remaining-scope", "SRE-3764")
    expect("https://linear.app/replit/issue/SRE-3764", "SRE-3764")
    expect("https://linear.app/replit/issue/SRE-3764/", "SRE-3764")
    expect("https://linear.app/replit/issue/SRE-3764?view=board", "SRE-3764")
    expect("  https://linear.app/replit/issue/ENG-12/slug\n", "ENG-12")
    expect("https://linear.app/replit/project/some-project-abc123", nil)
    expect("https://linear.app/replit", nil)
    expect("https://notlinear.app/replit/issue/SRE-3764/slug", nil)
    expect("https://linear.app/replit/issue/SRE-3764/slug and more text", nil)

    if failures > 0 {
      print("\(failures) failure(s)")
      exit(1)
    }
    print("All tests passed")
    exit(0)
  }
}
