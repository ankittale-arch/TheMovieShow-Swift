import SwiftUI

/// Home screen — placeholder until Phase 4.
struct HomeView: View {
    let coordinator: HomeCoordinator

    var body: some View {
        EmptyStateView(
            title: "Home",
            message: "Curated movie listings coming in Phase 4.",
            systemImageName: "house.fill"
        )
        .navigationTitle("The Movie Show")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        HomeView(coordinator: HomeCoordinator())
    }
}
