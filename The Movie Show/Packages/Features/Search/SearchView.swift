import SwiftUI

/// Search screen — placeholder until Phase 6.
struct SearchView: View {
    let coordinator: SearchCoordinator

    var body: some View {
        EmptyStateView(
            title: "Search",
            message: "Debounced movie search coming in Phase 6.",
            systemImageName: "magnifyingglass"
        )
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        SearchView(coordinator: SearchCoordinator())
    }
}
