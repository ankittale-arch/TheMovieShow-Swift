import SwiftUI

struct HomeView: View {
    let viewModel: HomeViewModel
    @Environment(\.scenePhase) private var scenePhase

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
                    .transition(.opacity)
            }
        }
        .animation(.easeIn(duration: 0.25), value: viewModel.featuredMovies.isEmpty)
        .navigationTitle("The Movie Show")
        .navigationBarTitleDisplayMode(.large)
        .task { await viewModel.loadAll() }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                Task { await viewModel.refreshIfStale() }
            }
        }
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
                    GenresRow(genres: viewModel.genres, onTap: viewModel.didTapGenre)
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
        .refreshable { await viewModel.loadAll() }
    }
}

// MARK: - Featured Banner Carousel (paging, one-over-another effect)

private struct FeaturedBannerCarousel: View {
    let movies: [Movie]
    let onTap: (Movie) -> Void

    @State private var currentIndex = 0
    @State private var carouselWidth: CGFloat = 0

    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(Array(movies.enumerated()), id: \.offset) { index, movie in
                FeaturedBannerCard(movie: movie)
                    .contentShape(Rectangle())
                    .onTapGesture { onTap(movie) }
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .frame(height: carouselWidth > 0 ? carouselWidth * 9 / 16 : 220)
        .background(
            GeometryReader { proxy in
                Color.clear
                    .onAppear { carouselWidth = proxy.size.width }
                    .onChange(of: proxy.size.width) { _, w in carouselWidth = w }
            }
        )
        // Auto-advance using Swift concurrency — no Combine
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(4))
                guard !movies.isEmpty else { continue }
                withAnimation(.easeInOut(duration: 0.5)) {
                    currentIndex = (currentIndex + 1) % movies.count
                }
            }
        }
    }
}

private struct FeaturedBannerCard: View {
    let movie: Movie

    var body: some View {
        AsyncImageView(url: movie.backdropURL, contentMode: .fill)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .overlay(alignment: .bottom) {
                LinearGradient(
                    colors: [.black.opacity(0.85), .clear],
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: 100)
                .overlay(alignment: .bottomLeading) {
                    HStack(alignment: .bottom) {
                        Text(movie.title)
                            .font(.title3.bold())
                            .foregroundStyle(.white)
                            .lineLimit(2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        RatingBadge(rating: movie.rating)
                    }
                    .padding(Spacing.medium)
                }
            }
    }
}

// MARK: - Genres Row

private struct GenresRow: View {
    let genres: [Genre]
    let onTap: (Genre) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Text("Genres")
                .font(.headline)
                .padding(.horizontal, Spacing.medium)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.xSmall) {
                    ForEach(genres) { genre in
                        Button { onTap(genre) } label: {
                            Text(genre.name)
                                .font(.subheadline)
                                .padding(.horizontal, Spacing.medium)
                                .padding(.vertical, Spacing.xSmall)
                                .background(Color.secondary.opacity(0.1))
                                .foregroundStyle(.primary)
                                .clipShape(Capsule())
                                .overlay(Capsule().stroke(Color.secondary.opacity(0.3), lineWidth: 1))
                        }
                        .buttonStyle(.plain)
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
                .accessibilityLabel("See all \(title) movies")
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
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(movie.title), rated \(String(format: "%.1f", movie.rating)) out of 10")
        .accessibilityAddTraits(.isButton)
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
