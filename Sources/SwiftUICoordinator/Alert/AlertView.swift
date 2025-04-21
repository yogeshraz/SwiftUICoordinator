//
//  AlertView.swift
//  CoordinatorStackDemo
//
//  Created by Yogesh Raj on 26/03/25.
//

import SwiftUI

// If use separately
//protocol AlertPresentable {
//    var isShowingAlert: Bool { get set }
//    var alertDetails: AlertDetails { get }
//}

public struct AlertButton: Identifiable, Equatable {
    public let id = UUID().uuidString
    
    let title: String
    let role: ButtonRole?
    let action: (() -> Void)?
    let accessibilityIdentifier: String
    
    public init(title: String, role: ButtonRole? = nil, action: ( () -> Void)? = nil, accesibilityIdentifier: String = "") {
        self.title = title
        self.role = role
        self.action = action
        self.accessibilityIdentifier = accesibilityIdentifier
    }
    
    public static func == (lhs: AlertButton, rhs: AlertButton) -> Bool {
        lhs.title == rhs.title &&
        lhs.role == rhs.role
    }
}

public struct AlertDetails: Equatable {
    let title: String
    let message: String
    let buttons: [AlertButton]
    let dialogOption: DialogOption
    let titleVisibility: Visibility
}

struct AlertView: ViewModifier {
    @Binding var isShowing: Bool
    let details: AlertDetails
    
    func body(content: Content) -> some View {
        let dialogType = details.dialogOption
        if dialogType == .alert {
            content
                .alert(details.title, isPresented: $isShowing) {
                    ForEach(details.buttons) { button in
                        Button(role: button.role, action: {
                            button.action?()
                            isShowing = false
                        }) {
                            Text(button.title)
                        }
                        .accessibilityIdentifier(button.accessibilityIdentifier)
                    }
                } message: {
                    Text(details.message)
                }
        } else {
            content
                .confirmationDialog(details.title, isPresented: $isShowing, titleVisibility: details.titleVisibility) {
                    ForEach(details.buttons) { button in
                        Button(role: button.role, action: {
                            button.action?()
                            isShowing = false
                        }) {
                            Text(button.title)
                        }
                        .accessibilityIdentifier(button.accessibilityIdentifier)
                    }
                } message: {
                    Text(details.message)
                }
        }
    }
}

extension Coordinator {
    public func showBasicAlert(title: String, message: String, buttonTitle: String = "Ok", closer: @escaping () -> () = nil) {
        let button = AlertButton(title: buttonTitle, action: {
            if let closer = closer as? () -> Void {
                closer()
            }
            print("Pressed:- \(buttonTitle)")
        })
        alertDetails = AlertDetails(title: title, message: message, buttons: [button], dialogOption: .alert, titleVisibility: .automatic)
        isShowingAlert = true
    }
    
    public func showAlertWithAction(title: String, message: String, buttonTitle: String = "Ok", cancelButtonTitle: String = "Cancel", option: DialogOption = .alert, sheetTitleVisitibility: Visibility = .automatic, closer: @escaping () -> ()) {
        let button1 = AlertButton(title: buttonTitle, action: {
            closer()
        })
        let button2 = AlertButton(title: cancelButtonTitle, action: {})
        alertDetails = AlertDetails(title: title, message: message, buttons: [button1,button2], dialogOption: option, titleVisibility: sheetTitleVisitibility)
        isShowingAlert = true
    }
    
    public func showAlertWithMultiAction(title: String, message: String, buttonTitle: String = "Ok", cancelButtonTitle: String = "Cancel", option: DialogOption = .alert, sheetTitleVisitibility: Visibility = .automatic, closer: @escaping () -> (), closerCancel: @escaping () -> ()) {
        let button1 = AlertButton(title: buttonTitle, action: {
            closer()
        })
        let button2 = AlertButton(title: cancelButtonTitle, action: {
            closerCancel()
        })
        alertDetails = AlertDetails(title: title, message: message, buttons: [button1,button2], dialogOption: option, titleVisibility: sheetTitleVisitibility)
        isShowingAlert = true
    }
    
    public func showAlertWithMultiAction(title: String, message: String, option: DialogOption = .alert, sheetTitleVisitibility: Visibility = .automatic, buttons: [AlertButton]) {
        alertDetails = AlertDetails(title: title, message: message, buttons: buttons, dialogOption: option, titleVisibility: sheetTitleVisitibility)
        isShowingAlert = true
    }
}

extension View {
    func showAlert(isShowing: Binding<Bool>, details: AlertDetails) -> some View {
        self.modifier(AlertView(isShowing: isShowing, details: details))
    }
}
