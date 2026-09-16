import Testing
import Foundation
@testable import The_Movie_Show

// MARK: - Endpoint URL construction

@Suite("TMDBEndpoint URL Building")
struct EndpointURLTests {

    private let base = URL(string: "https://api.themoviedb.org/3")!

    @Test("Popular endpoint: correct path and page query")
    func popularURL() throws {
        let url = try TMDBEndpoint.popular(page: 2).makeURL(baseURL: base)
        #expect(url.path.contains("/movie/popular"))
        let q = url.query ?? ""
        #expect(q.contains("page=2"))
        #expect(!q.contains("api_key"))   // auth is now in the header, not the URL
    }

    @Test("Search endpoint: query and page parameters present")
    func searchURL() throws {
        let url = try TMDBEndpoint.search(query: "inception", page: 3).makeURL(baseURL: base)
        let q = url.query ?? ""
        #expect(q.contains("query=inception"))
        #expect(q.contains("page=3"))
    }

    @Test("Movie detail endpoint: ID in path")
    func movieDetailURL() throws {
        let url = try TMDBEndpoint.movieDetail(id: 27205).makeURL(baseURL: base)
        #expect(url.path.contains("/movie/27205"))
    }

    @Test("Credits endpoint: movie ID and /credits suffix in path")
    func creditsURL() throws {
        let url = try TMDBEndpoint.credits(movieId: 27205).makeURL(baseURL: base)
        #expect(url.path.contains("/movie/27205/credits"))
    }

    @Test("Videos endpoint: movie ID and /videos suffix in path")
    func videosURL() throws {
        let url = try TMDBEndpoint.videos(movieId: 27205).makeURL(baseURL: base)
        #expect(url.path.contains("/movie/27205/videos"))
    }

    @Test("Top rated and upcoming endpoints include page query")
    func listEndpointsHavePage() throws {
        let topRated = try TMDBEndpoint.topRated(page: 5).makeURL(baseURL: base)
        let upcoming = try TMDBEndpoint.upcoming(page: 1).makeURL(baseURL: base)
        #expect((topRated.query ?? "").contains("page=5"))
        #expect((upcoming.query ?? "").contains("page=1"))
    }

    @Test("All list endpoints default to GET")
    func allEndpointsUseGET() {
        let endpoints: [TMDBEndpoint] = [
            .popular(page: 1), .topRated(page: 1),
            .nowPlaying(page: 1), .upcoming(page: 1),
            .movieDetail(id: 1), .genres
        ]
        for endpoint in endpoints {
            #expect(endpoint.method == .get)
        }
    }

    @Test("Language query item is injected")
    func languageInjected() throws {
        let url = try TMDBEndpoint.popular(page: 1).makeURL(baseURL: base)
        #expect((url.query ?? "").contains("language="))
    }
}

// MARK: - URLError → AppError mapping

@Suite("URLError → AppError Mapping")
struct URLErrorMappingTests {

    @Test(".notConnectedToInternet → .networkUnavailable")
    func notConnectedToInternet() {
        #expect(URLError(.notConnectedToInternet).asAppError == .networkUnavailable)
    }

    @Test(".networkConnectionLost → .networkUnavailable")
    func networkConnectionLost() {
        #expect(URLError(.networkConnectionLost).asAppError == .networkUnavailable)
    }

    @Test(".dataNotAllowed → .networkUnavailable")
    func dataNotAllowed() {
        #expect(URLError(.dataNotAllowed).asAppError == .networkUnavailable)
    }

    @Test(".timedOut → .unknown")
    func timedOut() {
        if case .unknown = URLError(.timedOut).asAppError { }
        else { Issue.record("Expected .unknown for .timedOut") }
    }

    @Test(".cannotFindHost → .unknown")
    func cannotFindHost() {
        if case .unknown = URLError(.cannotFindHost).asAppError { }
        else { Issue.record("Expected .unknown for .cannotFindHost") }
    }
}
