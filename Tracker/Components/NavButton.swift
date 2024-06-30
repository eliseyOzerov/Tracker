//
//  NavButton.swift
//  Tracker
//
//  Created by Elisey Ozerov on 29. 6. 24.
//

import SwiftUI

struct NavButton: View {
    var label: String
    var action: () -> Void
    
    init(_ label: String, action: @escaping () -> Void) {
        self.label = label
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(label)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue.lighter(0.5))
            }
        }
    }
}

#Preview {
    NavButton("NavButton") { }
}
