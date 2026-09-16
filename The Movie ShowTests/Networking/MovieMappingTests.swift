import Testing
import Foundation
@testable import The_Movie_Show

@Suite("Movie DTO Mapping")
struct MovieMappingTests {

    // MARK: - MovieDTO → Movie

    @Test("All fields map correctly")
    func movieDTOFullMapping() {
        let dto = MovieDTO.fixture()
        let movie = dto.toDomain()

        #expect(movie.id == 27205)
        #expect(movie.title == "Inception")
        #expect(movie.rating == 8.367)
        #expect(movie.voteCount == 35268)
        #expect(movie.genreIds == [28, 878, 12])
        #expect(movie.posterURL != nil)
        #expect(movie.backdropURL != nil)
    }

    @Test("Valid release date parses to non-nil Date")
    func validReleaseDateParsed() {
        let dto = MovieDTO.fixture(releaseDate: "2010-07-15")
        #expect(dto.toDomain().releaseDate != nil)
    }

    @Test("Invalid release date string maps to nil")
    func invalidReleaseDateIsNil() {
        let dto = MovieDTO.fixture(releaseDate: "not-a-date")
        #expect(dto.toDomain().releaseDate == nil)
    }

    @Test("Nil poster path maps to nil posterURL")
    func nilPosterPathIsNil() {
        let dto = MovieDTO.fixture(posterPath: nil)
        #expect(dto.toDomain().posterURL == nil)
    }

    @Test("Poster URL contains correct TMDB image path")
    func posterURLContainsPath() throws {
        let dto = MovieDTO.fixture(posterPath: "/abc.jpg")
        let url = try #require(dto.toDomain().posterURL)
        #expect(url.absoluteString.contains("/abc.jpg"))
        #expect(url.absoluteString.contains("image.tmdb.org"))
    }

    // MARK: - MovieListResponseDTO → [Movie]

    @Test("List response maps all results")
    func listResponseMapsAllResults() {
        let dto = MovieListResponseDTO(
            page: 1,
            results: [MovieDTO.fixture(), MovieDTO.fixture(id: 99)],
            totalPages: 5,
            totalResults: 100
        )
        let movies = dto.toDomain()
        #expect(movies.count == 2)
        #expect(movies[1].id == 99)
    }

    // MARK: - GenreDTO → Genre

    @Test("Genre maps id and name")
    func genreMapping() {
        let genre = GenreDTO(id: 28, name: "Action").toDomain()
        #expect(genre.id == 28)
        #expect(genre.name == "Action")
    }

    // MARK: - CastDTO → CastMember

    @Test("Cast member maps order and character")
    func castMapping() {
        let cast = CastDTO(
            id: 1, name: "Leonardo DiCaprio",
            character: "Dom Cobb", profilePath: "/leo.jpg",
            order: 0, popularity: 50.0
        ).toDomain()
        #expect(cast.name == "Leonardo DiCaprio")
        #expect(cast.character == "Dom Cobb")
        #expect(cast.order == 0)
        #expect(cast.profileURL != nil)
    }

    // MARK: - MovieDetailDTO → MovieDetail

    @Test("Empty tagline maps to nil")
    func emptyTaglineIsNil() {
        let dto = MovieDetailDTO.fixture(tagline: "")
        let detail = dto.toDomain(credits: nil, videos: nil)
        #expect(detail.tagline == nil)
    }

    @Test("Non-empty tagline is preserved")
    func nonEmptyTaglinePreserved() {
        let dto = MovieDetailDTO.fixture(tagline: "Your mind is the scene of the crime.")
        let detail = dto.toDomain(credits: nil, videos: nil)
        #expect(detail.tagline == "Your mind is the scene of the crime.")
    }

    @Test("Official YouTube trailer URL is extracted")
    func trailerURLExtracted() {
        let video = VideoDTO(
            id: "v1", key: "YoHD9XEInc0", name: "Official Trailer",
            site: "YouTube", type: "Trailer", official: true, publishedAt: "2010-05-10"
        )
        let videos = VideoListResponseDTO(id: 27205, results: [video])
        let detail = MovieDetailDTO.fixture().toDomain(credits: nil, videos: videos)
        #expect(detail.trailerURL?.absoluteString.contains("YoHD9XEInc0") == true)
    }

    @Test("Non-official trailer is ignored")
    func nonOfficialTrailerIgnored() {
        let video = VideoDTO(
            id: "v2", key: "somekey", name: "Fan Trailer",
            site: "YouTube", type: "Trailer", official: false, publishedAt: nil
        )
        let videos = VideoListResponseDTO(id: 27205, results: [video])
        let detail = MovieDetailDTO.fixture().toDomain(credits: nil, videos: videos)
        #expect(detail.trailerURL == nil)
    }

    @Test("Cast is sorted by order and capped at 20")
    func castSortedAndCapped() {
        let cast = (0..<25).map { i in
            CastDTO(id: i, name: "Actor \(i)", character: "Char \(i)",
                    profilePath: nil, order: 24 - i, popularity: 1.0)
        }
        let credits = MovieCreditsDTO(id: 1, cast: cast, crew: [])
        let detail = MovieDetailDTO.fixture().toDomain(credits: credits, videos: nil)
        #expect(detail.cast.count == 20)
        #expect(detail.cast.first?.order == 0)
    }
}

// MARK: - Test fixtures

extension MovieDTO {
    static func fixture(
        id: Int = 27205,
        title: String = "Inception",
        posterPath: String? = "/poster.jpg",
        backdropPath: String? = "/backdrop.jpg",
        releaseDate: String? = "2010-07-15"
    ) -> MovieDTO {
        MovieDTO(
            id: id, title: title,
            overview: "A thief who steals corporate secrets.",
            posterPath: posterPath, backdropPath: backdropPath,
            releaseDate: releaseDate, voteAverage: 8.367,
            voteCount: 35268, genreIds: [28, 878, 12],
            popularity: 136.4, adult: false,
            originalLanguage: "en", originalTitle: title
        )
    }
}

extension MovieDetailDTO {
    static func fixture(tagline: String? = "Your mind is the scene of the crime.") -> MovieDetailDTO {
        MovieDetailDTO(
            id: 27205, title: "Inception",
            overview: "A thief who steals corporate secrets.",
            tagline: tagline,
            posterPath: "/poster.jpg", backdropPath: "/backdrop.jpg",
            releaseDate: "2010-07-15", voteAverage: 8.367,
            voteCount: 35268, genres: [GenreDTO(id: 28, name: "Action")],
            runtime: 148, status: "Released",
            originalLanguage: "en", originalTitle: "Inception",
            popularity: 136.4, budget: 160_000_000, revenue: 836_800_000,
            adult: false, homepage: "https://inceptionmovie.warnerbros.com",
            imdbId: "tt1375666",
            productionCompanies: []
        )
    }
}
