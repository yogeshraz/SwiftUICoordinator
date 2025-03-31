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
    
    @State private var coordinator =  Coordinator<CoordinatorViews>()
    
    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            root
                .navigationDestination (for: CoordinatorViews.self) { view in
                    view.onDisappear() {
                        detectBackNavigation()
                    }
                }
                .sheet(item: $coordinator.sheet) { $0 }
                .fullScreenCover(item: $coordinator.fullScreenCover) { $0 }
                .showAlert(isShowing: $coordinator.isShowingAlert, details: coordinator.alertDetails)
        }
        .environment(coordinator)
        .onChange(of: coordinator.path) { oldStack, newStack in
            if newStack.count < oldStack.count {
                coordinator.pop()
                print("Back button tapped or swiped back")
            }
        }
    }
    
    private func detectBackNavigation() {
        coordinator.pop()
        print("User navigated back via swipe or back button")
    }
}
