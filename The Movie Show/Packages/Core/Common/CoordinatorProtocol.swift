import SwiftUI

/// Base navigation contract shared by all coordinators.
///
/// ViewModels receive a weak reference to a type conforming to a feature-specific
/// sub-protocol (e.g. `HomeCoordinatorProtocol`) rather than the concrete
/// coordinator class. This keeps the dependency direction one-way:
/// View → ViewModel → coordinator protocol (not ViewModel → concrete Coordinator).
@MainActor
protocol CoordinatorProtocol: AnyObject {
    func navigateBack()
    func navigateToRoot()
}

/// Marker protocol applied to all route enums so NavigationStack destinations
/// can be constrained to project-defined types only.
protocol AppRoute: Hashable {}
