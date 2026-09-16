import SwiftUI

struct HomeView: View {
    let viewModel: HomeViewModel

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.featuredMovies.isEmpty {
                LoadingView()
            } else if let error = viewModel.error, viewModel.featuredMovies.isEmpty {
                ErrorView(error: error) {
                    Task { await viewModel.loadAll() }
                }
            } else {
                contentScrollView
            }
        }
        .navigationTitle("The Movie Show")
        .navigationBarTitleDisplayMode(.large)
        .task { await viewModel.loadAll() }
    }

    private var contentScrollView: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: Spacing.large) {
                if !viewModel.featuredMovies.isEmpty {
                    FeaturedBannerCarousel(
                        movies: viewModel.featuredMovies,
                        onTap: viewModel.didTapMovie
                    )
                }

                if !viewModel.genres.isEmpty {
                    GenresRow(genres: viewModel.genres)
                }

                if !viewModel.nowPlayingMovies.isEmpty {
                    HorizontalMovieSection(
                        title: "Now Playing",
                        movies: viewModel.nowPlayingMovies,
                        onTap: viewModel.didTapMovie,
                        onMore: { viewModel.showMore(for: .nowPlaying) }
                    )
                }

                if !viewModel.popularMovies.isEmpty {
                    HorizontalMovieSection(
                        title: "Popular Movies",
                        movies: viewModel.popularMovies,
                        onTap: viewModel.didTapMovie,
                        onMore: { viewModel.showMore(for: .popular) }
                    )
                }

                if !viewModel.topRatedMovies.isEmpty {
                    HorizontalMovieSection(
                        title: "Top Rated",
                        movies: viewModel.topRatedMovies,
                        onTap: viewModel.didTapMovie,
                        onMore: { viewModel.showMore(for: .topRated) }
                    )
                }
            }
            .padding(.bottom, Spacing.xxLarge)
        }
    }
}

// MARK: - Featured Banner Carousel

private struct FeaturedBannerCarousel: View {
    let movies: [Movie]
    let onTap: (Movie) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.small) {
                ForEach(movies) { movie in
                    FeaturedBannerCard(movie: movie)
                        .contentShape(Rectangle())
                        .onTapGesture { onTap(movie) }
                }
            }
            .scrollTargetLayout()
            .padding(.horizontal, Spacing.medium)
        }
        .scrollTargetBehavior(.viewAligned)
    }
}

private struct FeaturedBannerCard: View {
    let movie: Movie

    // Leave ~24pt peek of the next card after horizontal padding
    private var cardWidth: CGFloat {
        UIScreen.main.bounds.width - Spacing.medium * 2 - 24
    }

    var body: some View {
        AsyncImageView(url: movie.backdropURL, contentMode: .fill)
            .frame(width: cardWidth, height: cardWidth * 9 / 16)
            .clipped()
            .overlay(alignment: .bottom) {
                LinearGradient(
                    colors: [.black.opacity(0.8), .clear],
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: 90)
                .overlay(alignment: .bottomLeading) {
                    HStack(alignment: .bottom) {
                        Text(movie.title)
                            .font(.headline)
                            .foregroundStyle(.white)
                            .lineLimit(2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        RatingBadge(rating: movie.rating)
                    }
                    .padding(Spacing.small)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.xLarge))
    }
}

// MARK: - Genres Row

private struct GenresRow: View {
    let genres: [Genre]

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Text("Genres")
                .font(.headline)
                .padding(.horizontal, Spacing.medium)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.xSmall) {
                    ForEach(genres) { genre in
                        Text(genre.name)
                            .font(.subheadline)
                            .padding(.horizontal, Spacing.medium)
                            .padding(.vertical, Spacing.xSmall)
                            .background(Color.secondary.opacity(0.1))
                            .foregroundStyle(.primary)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.secondary.opacity(0.3), lineWidth: 1))
                    }
                }
                .padding(.horizontal, Spacing.medium)
            }
        }
    }
}

// MARK: - Horizontal Movie Section

private struct HorizontalMovieSection: View {
    let title: String
    let movies: [Movie]
    let onTap: (Movie) -> Void
    let onMore: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Button(action: onMore) {
                    HStack(spacing: Spacing.xxxSmall) {
                        Text("more")
                            .font(.subheadline)
                        Image(systemName: "chevron.right")
                            .font(.caption.bold())
                    }
                    .foregroundStyle(Color.accentColor)
                }
            }
            .padding(.horizontal, Spacing.medium)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.small) {
                    ForEach(movies) { movie in
                        SectionPosterCard(movie: movie)
                            .contentShape(Rectangle())
                            .onTapGesture { onTap(movie) }
                    }
                }
                .padding(.horizontal, Spacing.medium)
            }
        }
    }
}

// MARK: - Section Poster Card

private struct SectionPosterCard: View {
    let movie: Movie

    private let cardWidth:  CGFloat = 110
    private let cardHeight: CGFloat = 165   // 2:3 ratio

    var body: some View {
        ZStack(alignment: .topLeading) {
            AsyncImageView(url: movie.posterURL, contentMode: .fill)
                .frame(width: cardWidth, height: cardHeight)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.card))

            RatingBadge(rating: movie.rating)
                .padding(Spacing.xxSmall)
        }
        .frame(width: cardWidth, height: cardHeight)
    }
}

// MARK: - Rating Badge

private struct RatingBadge: View {
    let rating: Double

    var body: some View {
        HStack(spacing: Spacing.xxxSmall) {
            Image(systemName: "star.fill")
                .font(.system(size: 8, weight: .bold))
                .foregroundStyle(Color.App.ratingGold)
            Text(String(format: "%.1f", rating))
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, Spacing.xxSmall)
        .padding(.vertical, Spacing.xxxSmall)
        .background(.black.opacity(0.65))
        .clipShape(Capsule())
    }
}

#Preview {
    NavigationStack {
        HomeView(viewModel: HomeViewModel(
            coordinator: PreviewHomeCoordinator(),
            movieRepository: PreviewMovieRepository()
        ))
    }
}
