//
//  CoordinatorStack.swift
//  CoordinatorStackDemo
//
//  Created by Yogesh Raj on 26/03/25.
//

import SwiftUI

public struct CoordinatorStack<Page: Coordinatable & Identifiable & Hashable>: View {
    
    @State private var coordinator = Coordinator<Page>()
    private let root: Page
    
    public init(_ root: Page) {
        self.root = root
    }
    
    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            root
                .navigationDestination(for: Page.self) { page in
                    page
                }
                .sheet(item: $coordinator.sheet) { page in
                    page
                }
                .fullScreenCover(item: $coordinator.fullScreenCover) { page in
                    page
                }
                .showAlert(isShowing: $coordinator.isShowingAlert, details: coordinator.alertDetails)
        }
        .environment(coordinator)
        .interactiveDismissDisabled(false)
        .onChange(of: coordinator.path) { oldPath, newPath in
            handleSwipeBackNavigation(oldCount: oldPath.count, newCount: newPath.count)
        }
    }
    
    // MARK: - Private
    private func handleSwipeBackNavigation(oldCount: Int, newCount: Int) {
        if newCount < oldCount {
            coordinator.pop(.link(last: oldCount - newCount))
        }
    }
}
