import Foundation

extension String {
    var isNotEmpty: Bool { !isEmpty }

    /// Returns `nil` when the string is empty, otherwise returns `self`.
    var nilIfEmpty: String? {
        isEmpty ? nil : self
    }

    /// Truncates to `length` characters, appending `trailing` if truncated.
    func truncated(to length: Int, trailing: String = "…") -> String {
        count > length ? String(prefix(length)) + trailing : self
    }
}
