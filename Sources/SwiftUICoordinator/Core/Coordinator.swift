//
//  Coordinator.swift
//  CoordinatorStackDemo
//
//  Created by Yogesh Raj on 26/03/25.
//

import SwiftUI

@Observable
public class Coordinator<Page: Coordinatable & Identifiable & Hashable> {
    
    // MARK: - Navigation State
    public var path = NavigationPath()
    public var sheet: Page?
    public var fullScreenCover: Page?
    
    // MARK: - Alert State
    public var isShowingAlert = false
    public var alertDetails = AlertDetails(title: "", message: "", buttons: [], dialogOption: .alert, titleVisibility: .automatic)
    
    // MARK: - Init
    public init() {}
    
    // MARK: - Enums
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
    
    // MARK: - Navigation Methods
    public func push(_ page: Page, type: PushType = .link) {
        switch type {
        case .link:
            path.append(page)
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
            if path.count >= last {
                path.removeLast(last)
            } else {
                path.removeLast(path.count)
            }
        case .sheet:
            sheet = nil
        case .fullScreenCover:
            fullScreenCover = nil
        }
    }
    
    public func popToRoot() {
        path = NavigationPath()
    }
    
    public func setRoot(_ page: Page) {
        path = NavigationPath()
        path.append(page)
    }
    
    public func replaceLast(with page: Page) {
        guard !path.isEmpty else {
            push(page)
            return
        }
        path.removeLast()
        path.append(page)
    }
    
    public func popTo<PageType: Hashable>(_ page: PageType) {
        while let last = path.elements.last as? PageType, last != page {
            path.removeLast()
            if path.isEmpty { break }
        }
    }
    
    // MARK: - Alert Methods
    public func showAlert(details: AlertDetails) {
        alertDetails = details
        isShowingAlert = true
    }
    
    public func dismissAlert() {
        isShowingAlert = false
    }
}
