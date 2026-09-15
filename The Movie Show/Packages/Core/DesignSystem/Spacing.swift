import CoreGraphics

/// Spacing scale — use these constants instead of magic numbers throughout the app.
enum Spacing {
    static let xxxSmall: CGFloat = 2
    static let xxSmall:  CGFloat = 4
    static let xSmall:   CGFloat = 8
    static let small:    CGFloat = 12
    static let medium:   CGFloat = 16
    static let large:    CGFloat = 24
    static let xLarge:   CGFloat = 32
    static let xxLarge:  CGFloat = 48
    static let xxxLarge: CGFloat = 64
}

/// Corner radius scale
enum CornerRadius {
    static let small:  CGFloat = 4
    static let medium: CGFloat = 8
    static let large:  CGFloat = 12
    static let xLarge: CGFloat = 16
    static let card:   CGFloat = 12
    static let pill:   CGFloat = 100
}

/// Standard movie image dimensions matching TMDB's common poster / backdrop ratios.
enum ImageSize {
    static let posterWidth:  CGFloat = 150
    static let posterHeight: CGFloat = 225   // 2:3 ratio
    static let cardWidth:    CGFloat = 160
    static let cardHeight:   CGFloat = 240
    static let backdropAspectRatio: CGFloat = 16.0 / 9.0
}
