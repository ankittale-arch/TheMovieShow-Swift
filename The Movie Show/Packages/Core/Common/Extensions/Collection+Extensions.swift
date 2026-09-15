import Foundation

extension Collection {
    /// Returns `true` when the collection has at least one element.
    var isNotEmpty: Bool { !isEmpty }
}

extension Optional where Wrapped: Collection {
    /// Returns `true` when the optional is `nil` or the wrapped collection is empty.
    var isNilOrEmpty: Bool {
        self?.isEmpty ?? true
    }
}
