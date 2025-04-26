//
//  CoordinatorStack.swift
//  CoordinatorStackDemo
//
//  Created by Yogesh Raj on 26/03/25.
//

import SwiftUI

public struct CoordinatorStack<CoordinatorViews: Coordinatable>: View {
    
    let root: CoordinatorViews
    @State private var coordinator = Coordinator<CoordinatorViews>()
    
    public init(_ root: CoordinatorViews) {
        self.root = root
    }

    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            root
                .navigationDestination(for: CoordinatorViews.self) { $0 }
                .sheet(item: $coordinator.sheet) { $0 }
                .fullScreenCover(item: $coordinator.fullScreenCover) { $0 }
                .showAlert(isShowing: $coordinator.isShowingAlert, details: coordinator.alertDetails)
        }
        .environment(coordinator)
        .interactiveDismissDisabled(false)
        .onAppear {
            // Ensure coordinator root is set properly on first appear
            if coordinator.path.isEmpty {
                coordinator.setRoot(page: root)
            }
        }
        .onChange(of: coordinator.path) { _, newPath in
            handleSwipeBackNavigation(oldPathCount: coordinator.path.count, newPathCount: newPath.count)
        }
    }

    /// Detects swipe back action in NavigationStack
    private func handleSwipeBackNavigation(oldPathCount: Int, newPathCount: Int) {
        if newPathCount < oldPathCount {
            coordinator.pop(type: .link(last: oldPathCount - newPathCount))
        }
    }
}
