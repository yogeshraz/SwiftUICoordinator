//
//  Coordinator.swift
//  CoordinatorStackDemo
//
//  Created by Yogesh Raj on 26/03/25.
//

import SwiftUI

@Observable
public class Coordinator<CoordinatorPage: Coordinatable> {
    var path: NavigationPath = NavigationPath()
    var sheet: CoordinatorPage?
    var fullScreenCover: CoordinatorPage?
    
    var isShowingAlert: Bool = false
    var alertDetails: AlertDetails = AlertDetails(title: "", message: "", buttons: [], dialogOption: .alert, titleVisibility: .automatic)
    
    private var root: CoordinatorPage? // 👈 New: track current root
    
    public init() {}

    public enum PushType {
        case link
        case sheet
        case fullScreenCover
    }
    
    public enum PopType {
        case link(last: Int)
        case sheet
        case fullScreenCover
    }
    
    public func push(page: CoordinatorPage, type: PushType = .link) {
        switch type {
        case .link:
            path.append(page)
        case .sheet:
            sheet = page
        case .fullScreenCover:
            fullScreenCover = page
        }
    }
    
    public func pop(type: PopType = .link(last: 1)) {
        switch type {
        case .link(let last):
            path.removeLast(last)
        case .sheet:
            sheet = nil
        case .fullScreenCover:
            fullScreenCover = nil
        }
    }
    
    public func popToRoot() {
        path = NavigationPath()
        if let root = root {
            path.append(root)
        }
    }
    
    public func setRoot(page: CoordinatorPage) {
        // Important: first clear everything
        path = NavigationPath()
        root = page
        path.append(page)
        
        // Also clear sheets/fullscreens when setting root
        sheet = nil
        fullScreenCover = nil
        isShowingAlert = false
        alertDetails = AlertDetails(title: "", message: "", buttons: [], dialogOption: .alert, titleVisibility: .automatic)
    }
    
    public func reset() {
        path = NavigationPath()
        sheet = nil
        fullScreenCover = nil
        isShowingAlert = false
        alertDetails = AlertDetails(title: "", message: "", buttons: [], dialogOption: .alert, titleVisibility: .automatic)
        root = nil
    }
}
