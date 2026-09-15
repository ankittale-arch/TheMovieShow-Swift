import SwiftUI

extension Font {
    /// App typography scale — wraps Dynamic-Type-aware system fonts.
    /// Using `.system(_:design:weight:)` ensures Dynamic Type scaling works
    /// out of the box at all accessibility sizes.
    enum App {
        static let largeTitle  = Font.system(.largeTitle,  design: .default, weight: .bold)
        static let title       = Font.system(.title,       design: .default, weight: .semibold)
        static let title2      = Font.system(.title2,      design: .default, weight: .semibold)
        static let title3      = Font.system(.title3,      design: .default, weight: .medium)
        static let headline    = Font.headline
        static let body        = Font.body
        static let callout     = Font.callout
        static let subheadline = Font.subheadline
        static let footnote    = Font.footnote
        static let caption     = Font.caption
        static let caption2    = Font.caption2
    }
}
