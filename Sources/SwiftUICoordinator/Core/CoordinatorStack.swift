//
//  CoordinatorStack.swift
//  CoordinatorStackDemo
//
//  Created by Yogesh Raj on 26/03/25.
//

import SwiftUI

public struct CoordinatorStack<CoordinatorViews: Coordinatable>: View {
    
    let root: CoordinatorViews
    init(_ root: CoordinatorViews) {
        self.root = root
    }
    
    @State private var coordinator =  Coordinator<CoordinatorViews>()
    
    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            root
                .navigationDestination (for: CoordinatorViews.self) { $0 }
                .sheet(item: $coordinator.sheet) { $0 }
                .fullScreenCover(item: $coordinator.fullScreenCover) { $0 }
                .showAlert(isShowing: $coordinator.isShowingAlert, details: coordinator.alertDetails)
        }
        .environment(coordinator)
    }
}
