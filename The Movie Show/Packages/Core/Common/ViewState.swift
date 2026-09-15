import Foundation

/// Generic screen-state enum.
/// ViewModels expose a single `@Published var state: ViewState<T>` instead of
/// separate isLoading / data / error booleans, enabling exhaustive rendering in views.
enum ViewState<T> {
    case idle
    case loading
    case loaded(T)
    case empty
    case failed(AppError)
}

extension ViewState {
    var isLoading: Bool {
        guard case .loading = self else { return false }
        return true
    }

    var loadedValue: T? {
        guard case .loaded(let value) = self else { return nil }
        return value
    }

    var error: AppError? {
        guard case .failed(let error) = self else { return nil }
        return error
    }

    var isEmpty: Bool {
        guard case .empty = self else { return false }
        return true
    }
}

extension ViewState: Equatable where T: Equatable {
    static func == (lhs: ViewState<T>, rhs: ViewState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case (.loading, .loading): return true
        case (.empty, .empty): return true
        case (.loaded(let l), .loaded(let r)): return l == r
        case (.failed(let l), .failed(let r)): return l == r
        default: return false
        }
    }
}
