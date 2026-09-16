import Testing
import SwiftData
import Foundation
@testable import The_Movie_Show

@Suite("BookmarkRepository", .serialized)
struct BookmarkRepositoryTests {

    private let sut: BookmarkRepository

    init() throws {
        let container = try PersistenceContainer.makeInMemory()
        sut = BookmarkRepository(modelContainer: container)
    }

    // MARK: - Add & retrieve

    @Test("Initially no bookmarks exist")
    func initiallyEmpty() async throws {
        let result = try await sut.bookmarks()
        #expect(result.isEmpty)
    }

    @Test("Added bookmark appears in list")
    func addBookmark() async throws {
        try await sut.addBookmark(for: .fixture())
        let result = try await sut.bookmarks()
        #expect(result.count == 1)
        #expect(result[0].id == Movie.fixture().id)
    }

    @Test("Adding same movie twice is idempotent")
    func addDuplicate() async throws {
        try await sut.addBookmark(for: .fixture())
        try await sut.addBookmark(for: .fixture())
        let result = try await sut.bookmarks()
        #expect(result.count == 1)
    }

    @Test("Bookmarks are ordered most-recent first")
    func orderMostRecentFirst() async throws {
        try await sut.addBookmark(for: .fixture(id: 1, title: "First"))
        try await sut.addBookmark(for: .fixture(id: 2, title: "Second"))
        let result = try await sut.bookmarks()
        #expect(result.first?.title == "Second")
    }

    // MARK: - Remove

    @Test("Removed bookmark no longer appears")
    func removeBookmark() async throws {
        try await sut.addBookmark(for: .fixture())
        try await sut.removeBookmark(movieId: Movie.fixture().id)
        let result = try await sut.bookmarks()
        #expect(result.isEmpty)
    }

    @Test("Removing non-existent bookmark does not throw")
    func removeNonExistent() async throws {
        try await sut.removeBookmark(movieId: 99999)
    }

    // MARK: - isBookmarked

    @Test("isBookmarked returns false for non-bookmarked movie")
    func isNotBookmarked() async throws {
        let result = try await sut.isBookmarked(movieId: 42)
        #expect(result == false)
    }

    @Test("isBookmarked returns true after adding")
    func isBookmarked() async throws {
        try await sut.addBookmark(for: .fixture())
        let result = try await sut.isBookmarked(movieId: Movie.fixture().id)
        #expect(result == true)
    }

    @Test("isBookmarked returns false after removing")
    func isBookmarkedAfterRemove() async throws {
        try await sut.addBookmark(for: .fixture())
        try await sut.removeBookmark(movieId: Movie.fixture().id)
        let result = try await sut.isBookmarked(movieId: Movie.fixture().id)
        #expect(result == false)
    }
}
