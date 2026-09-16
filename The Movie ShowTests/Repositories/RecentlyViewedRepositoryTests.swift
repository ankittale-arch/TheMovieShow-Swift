import Testing
import SwiftData
import Foundation
@testable import The_Movie_Show

@Suite("RecentlyViewedRepository", .serialized)
struct RecentlyViewedRepositoryTests {

    private let sut: RecentlyViewedRepository

    init() throws {
        let container = try PersistenceContainer.makeInMemory()
        sut = RecentlyViewedRepository(modelContainer: container)
    }

    @Test("Initially empty")
    func initiallyEmpty() async throws {
        let result = try await sut.recentlyViewed()
        #expect(result.isEmpty)
    }

    @Test("Recorded movie appears in history")
    func recordView() async throws {
        try await sut.recordView(of: .fixture())
        let result = try await sut.recentlyViewed()
        #expect(result.count == 1)
        #expect(result[0].id == Movie.fixture().id)
    }

    @Test("Recording same movie again updates viewedAt instead of duplicating")
    func recordDuplicateUpdatesTimestamp() async throws {
        try await sut.recordView(of: .fixture())
        try await sut.recordView(of: .fixture())
        let result = try await sut.recentlyViewed()
        #expect(result.count == 1)
    }

    @Test("Most recently viewed movie appears first")
    func mostRecentFirst() async throws {
        try await sut.recordView(of: .fixture(id: 1, title: "Older"))
        try await sut.recordView(of: .fixture(id: 2, title: "Newer"))
        let result = try await sut.recentlyViewed()
        #expect(result.first?.title == "Newer")
    }

    @Test("clearAll removes all history")
    func clearAll() async throws {
        try await sut.recordView(of: .fixture(id: 1, title: "A"))
        try await sut.recordView(of: .fixture(id: 2, title: "B"))
        try await sut.clearAll()
        let result = try await sut.recentlyViewed()
        #expect(result.isEmpty)
    }
}
