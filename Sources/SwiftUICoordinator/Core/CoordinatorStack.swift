//
//  CoordinatorStack.swift
//  CoordinatorStackDemo
//
//  Created by Yogesh Raj on 26/03/25.
//

import SwiftUI

public struct CoordinatorStack<CoordinatorViews: Coordinatable>: View {
    
    let root: CoordinatorViews
    public init(_ root: CoordinatorViews) {
        self.root = root
    }
    
    @State private var coordinator = Coordinator<CoordinatorViews>()
    
    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            root
                .navigationDestination (for: CoordinatorViews.self) { view in
                    view
                        .onDisappear {
                            handleBackNavigation()
                        }
                }
                .sheet(item: $coordinator.sheet) { $0 }
                .fullScreenCover(item: $coordinator.fullScreenCover) { $0 }
                .showAlert(isShowing: $coordinator.isShowingAlert, details: coordinator.alertDetails)
        }
        .environment(coordinator)
        .interactiveDismissDisabled(false)
        .onChange(of: coordinator.path) { _, newPath in
            handleSwipeBackNavigation(oldPathCount: coordinator.path.count, newPathCount: newPath.count)
        }
    }
    
    /// Handles navigation when user taps back button or swipes back
    private func handleBackNavigation() {
        if coordinator.path.isEmpty {
            return
        }
        coordinator.pop(type: .link(last: 1))
    }

    /// Detects swipe back action in NavigationStack
    private func handleSwipeBackNavigation(oldPathCount: Int, newPathCount: Int) {
        if newPathCount < oldPathCount {
            coordinator.pop(type: .link(last: oldPathCount - newPathCount))
        }
    }
}
