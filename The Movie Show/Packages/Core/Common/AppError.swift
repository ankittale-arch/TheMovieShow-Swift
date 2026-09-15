import Foundation

/// Centralised error type for the entire application.
/// All layers (network, persistence, repositories) map their errors into AppError
/// so ViewModels and UI only ever deal with one error vocabulary.
enum AppError: Error, LocalizedError, Equatable {
    case networkUnavailable
    case requestFailed(statusCode: Int, message: String?)
    case decodingFailed
    case unauthorized
    case notFound
    case unknown(String?)

    var errorDescription: String? {
        switch self {
        case .networkUnavailable:
            return "No internet connection. Please check your network."
        case .requestFailed(let code, let message):
            return message ?? "Request failed with status \(code)."
        case .decodingFailed:
            return "Unable to process the server response."
        case .unauthorized:
            return "Unauthorised. Please check your API key."
        case .notFound:
            return "The requested resource was not found."
        case .unknown(let message):
            return message ?? "An unknown error occurred."
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .networkUnavailable:
            return "Check your Wi-Fi or cellular connection and try again."
        case .unauthorized:
            return "Verify your TMDB API key in the app configuration."
        default:
            return "Please try again."
        }
    }

    static func == (lhs: AppError, rhs: AppError) -> Bool {
        switch (lhs, rhs) {
        case (.networkUnavailable, .networkUnavailable): return true
        case (.decodingFailed, .decodingFailed): return true
        case (.unauthorized, .unauthorized): return true
        case (.notFound, .notFound): return true
        case (.requestFailed(let lCode, _), .requestFailed(let rCode, _)): return lCode == rCode
        case (.unknown(let lMsg), .unknown(let rMsg)): return lMsg == rMsg
        default: return false
        }
    }
}
