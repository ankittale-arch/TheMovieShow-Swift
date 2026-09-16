import SwiftUI

/// Reusable async image loader with shimmer placeholder and failure fallback.
struct AsyncImageView: View {
    let url: URL?
    let contentMode: ContentMode

    init(url: URL?, contentMode: ContentMode = .fill) {
        self.url = url
        self.contentMode = contentMode
    }

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ShimmerPlaceholder()
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            case .failure:
                failureView
            @unknown default:
                ShimmerPlaceholder()
            }
        }
    }

    private var failureView: some View {
        Rectangle()
            .foregroundStyle(Color.App.secondaryBackground)
            .overlay {
                Image(systemName: "film")
                    .font(.system(size: 32))
                    .foregroundStyle(Color.App.tertiaryText)
            }
    }
}

// MARK: - Shimmer placeholder

private struct ShimmerPlaceholder: View {
    @State private var isAnimating = false

    var body: some View {
        Rectangle()
            .fill(Color.App.shimmer)
            .overlay(
                GeometryReader { geo in
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [.clear, .white.opacity(0.45), .clear],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * 0.6)
                        .offset(x: isAnimating
                                ? geo.size.width + geo.size.width * 0.6
                                : -geo.size.width * 0.6)
                }
                .clipped()
            )
            .onAppear {
                withAnimation(.linear(duration: 1.4).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
    }
}

#Preview {
    HStack(spacing: Spacing.medium) {
        AsyncImageView(url: nil)
            .frame(width: ImageSize.posterWidth, height: ImageSize.posterHeight)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.card))

        AsyncImageView(url: URL(string: "https://invalid.url/poster.jpg"))
            .frame(width: ImageSize.posterWidth, height: ImageSize.posterHeight)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.card))
    }
    .padding()
}
