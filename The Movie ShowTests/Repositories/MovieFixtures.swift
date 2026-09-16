import Foundation
@testable import The_Movie_Show

extension Movie {
    static func fixture(
        id: Int = 27205,
        title: String = "Inception",
        rating: Double = 8.4
    ) -> Movie {
        Movie(
            id: id,
            title: title,
            overview: "A thief who steals corporate secrets through dream-sharing technology.",
            posterURL: URL(string: "https://image.tmdb.org/t/p/w500/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg"),
            backdropURL: nil,
            releaseDate: DateFormatter.tmdb.date(from: "2010-07-15"),
            rating: rating,
            voteCount: 35268,
            genreIds: [28, 878, 12],
            popularity: 136.4
        )
    }
}
