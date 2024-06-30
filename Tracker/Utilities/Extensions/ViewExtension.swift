//
//  ViewExtension.swift
//  letsgo-swiftui
//
//  Created by Elisey Ozerov on 17. 5. 24.
//

import Foundation
import SwiftUI

extension View {
    func resignFirstResponder() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
