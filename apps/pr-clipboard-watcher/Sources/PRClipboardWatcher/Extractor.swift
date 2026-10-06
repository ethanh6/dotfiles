import Foundation

private let pullRequestRegex = try! NSRegularExpression(
  pattern: #"^https?://github\.com/[^/\s]+/[^/\s]+/pull/(\d+)([/?#][^\s]*)?$"#
)

private let linearIssueRegex = try! NSRegularExpression(
  pattern: #"^https?://linear\.app/[^/\s]+/issue/([A-Za-z][A-Za-z0-9]*-\d+)([/?#][^\s]*)?$"#
)

/// Returns the ticket reference for a supported URL, or nil for anything else:
/// - GitHub pull request URL -> PR number (e.g. "136633")
/// - Linear issue URL -> issue key (e.g. "SRE-3764")
/// Matches plain URLs as well as sub-pages, query strings, and fragments.
func extractTicketReference(from string: String) -> String? {
  let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
  let range = NSRange(trimmed.startIndex..., in: trimmed)

  for regex in [pullRequestRegex, linearIssueRegex] {
    if let match = regex.firstMatch(in: trimmed, range: range),
       let referenceRange = Range(match.range(at: 1), in: trimmed) {
      return String(trimmed[referenceRange])
    }
  }

  return nil
}
