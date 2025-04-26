//
//  Coordinator.swift
//  CoordinatorStackDemo
//
//  Created by Yogesh Raj on 26/03/25.
//

import SwiftUI

@Observable
public class Coordinator<Page: Coordinatable & Identifiable & Hashable> {
    
    public var path = NavigationPath()
    private var stack: [Page] = []
    
    public var sheet: Page?
    public var fullScreenCover: Page?
    
    public var isShowingAlert = false
    public var alertDetails = AlertDetails(title: "", message: "", buttons: [], dialogOption: .alert, titleVisibility: .automatic)
    
    public init() {}
    
    public enum PushType {
        case link
        case sheet
        case fullScreenCover
    }
    
    public enum PopType {
        case link(last: Int = 1)
        case sheet
        case fullScreenCover
    }
    
    public func push(_ page: Page, type: PushType = .link) {
        switch type {
        case .link:
            path.append(page)
            stack.append(page)
        case .sheet:
            sheet = page
        case .fullScreenCover:
            fullScreenCover = page
        }
    }
    
    public func pop(_ type: PopType = .link()) {
        switch type {
        case .link(let last):
            guard last > 0 else { return }
            if stack.count >= last {
                stack.removeLast(last)
                path = NavigationPath(stack)
            } else {
                stack.removeAll()
                path = NavigationPath()
            }
        case .sheet:
            sheet = nil
        case .fullScreenCover:
            fullScreenCover = nil
        }
    }
    
    public func popToRoot() {
        stack.removeAll()
        path = NavigationPath()
    }
    
    public func setRoot(_ page: Page) {
        stack = [page]
        path = NavigationPath(stack)
    }
    
    public func popTo(_ page: Page) {
        guard let index = stack.firstIndex(of: page) else { return }
        let remaining = stack.prefix(upTo: index + 1)
        stack = Array(remaining)
        path = NavigationPath(stack)
    }
    
    public func replaceLast(with page: Page) {
        guard !stack.isEmpty else {
            push(page)
            return
        }
        stack.removeLast()
        stack.append(page)
        path = NavigationPath(stack)
    }
    
    public func showAlert(details: AlertDetails) {
        alertDetails = details
        isShowingAlert = true
    }
    
    public func dismissAlert() {
        isShowingAlert = false
    }
}
