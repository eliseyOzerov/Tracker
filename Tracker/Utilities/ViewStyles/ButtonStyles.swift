//
//  ButtonStyles.swift
//  letsgo-swiftui
//
//  Created by Elisey Ozerov on 18. 5. 24.
//

import Foundation
import SwiftUI

enum ButtonSize {
    case small
    case regular
    case large
}

struct BasicButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.75 : 1)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

extension ButtonStyle {
    static func basic() -> BasicButton { BasicButton() }
}

extension View {
    func buttonPadding(_ size: ButtonSize?) -> some View {
        switch size {
        case .small:
            return self
                .padding(.horizontal, Theme.spacing.s2)
                .padding(.vertical, Theme.spacing.s1)
        case .regular:
            return self
                .padding(.horizontal, Theme.spacing.s4)
                .padding(.vertical, Theme.spacing.s2)
        case .large:
            return self
                .padding(.horizontal, Theme.spacing.s6)
                .padding(.vertical, Theme.spacing.s3)
        default:
            return self
                .padding(.horizontal, .zero)
                .padding(.vertical, .zero)
        }
    }
    
    func buttonSize(_ size: ButtonSize, expand: Bool = false) -> some View {
        switch size {
        case .small:
            return self
                .frame(minWidth: Theme.spacing.s10, maxWidth: expand ? .infinity : nil, minHeight: Theme.spacing.s10)
        case .regular:
            return self
                .frame(minWidth: Theme.spacing.s12, maxWidth: expand ? .infinity : nil, minHeight: Theme.spacing.s12)
        case .large:
            return self
                .frame(minWidth: Theme.spacing.s14, maxWidth: expand ? .infinity : nil, minHeight: Theme.spacing.s14)
        }
    }
}
