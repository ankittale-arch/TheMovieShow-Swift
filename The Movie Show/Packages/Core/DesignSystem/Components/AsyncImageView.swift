import SwiftUI

/// Reusable async image loader with placeholder and failure states.
/// Wraps `AsyncImage` (which uses `URLCache` for in-memory/disk caching) and
/// provides consistent shimmer-placeholder and fallback-icon states across the app.
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
                placeholder
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            case .failure:
                failureView
            @unknown default:
                placeholder
            }
        }
    }

    private var placeholder: some View {
        Rectangle()
            .foregroundStyle(Color.App.shimmer)
            .overlay {
                ProgressView()
                    .tint(Color.App.secondaryText)
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
