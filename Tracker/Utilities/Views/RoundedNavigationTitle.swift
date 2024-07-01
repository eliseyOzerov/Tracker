//
//  RoundedNavigationTitle.swift
//  Tracker
//
//  Created by Elisey Ozerov on 1. 7. 24.
//

import SwiftUI

struct RoundedNavigationTitle: ViewModifier {
    var title: String

    func body(content: Content) -> some View {
        content
            .navigationTitle(title)
            .onAppear {
                let largeTitleAppearance = UINavigationBarAppearance()
                largeTitleAppearance.largeTitleTextAttributes = [
                    .font: UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize, weight: .bold, design: .rounded)
                ]
                
                largeTitleAppearance.configureWithTransparentBackground()
                largeTitleAppearance.backgroundColor = .clear
                largeTitleAppearance.shadowColor = .clear
                
                let titleAppearance = UINavigationBarAppearance()
                titleAppearance.titleTextAttributes = [
                    .font: UIFont.preferredFont(forTextStyle: .headline)
                ]
                
                UINavigationBar.appearance().standardAppearance = titleAppearance
                UINavigationBar.appearance().scrollEdgeAppearance = largeTitleAppearance
            }
    }
}

extension View {
    func roundedNavigationTitle(_ title: String) -> some View {
        self.modifier(RoundedNavigationTitle(title: title))
    }
}

extension UIFont {
    static func systemFont(ofSize size: CGFloat, weight: UIFont.Weight, design: UIFontDescriptor.SystemDesign) -> UIFont {
        let systemFont = UIFont.systemFont(ofSize: size, weight: weight)
        let fontDescriptor = systemFont.fontDescriptor.withDesign(design) ?? systemFont.fontDescriptor
        return UIFont(descriptor: fontDescriptor, size: size)
    }
}
