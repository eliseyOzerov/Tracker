//
//  TextInput.swift
//  letsgo-swiftui
//
//  Created by Elisey Ozerov on 19. 5. 24.
//

import SwiftUI

struct TextInput: View {
    
    @Binding var text: String
    
    var label: String? = nil
    var hint: String = ""
    var caption: String? = nil
    
    var showSearch: Bool = false
    var showClear: Bool = true
    
    var minLines: Int = 1
    var maxLines: Int = 1
    
    var keyboardType: UIKeyboardType = .default
    
    @FocusState private var focused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            if let label = label {
                Text(label)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(.bottom, Theme.spacing.s2)
            }
            HStack {
                if showSearch {
                    Image(systemName: "magnifyingglass")
                        .font(.headline.weight(.semibold))
                        .transition(.opacity)
                }
                TextField(hint, text: $text, axis: maxLines > 1 ? .vertical : .horizontal)
                    .padding(.vertical, Theme.spacing.s2)
                    .lineLimit(min(minLines, maxLines)...max(minLines, maxLines))
                    .focused($focused)
                    .frame(minHeight: Theme.spacing.s10)
                    .tint(Theme.color.primary)
                    .foregroundColor(Theme.color.primaryText)
                    .fontWeight(.medium)
                    .keyboardType(keyboardType)
                if showClear && !text.isEmpty {
                    Image(systemName: "xmark.circle.fill")
                        .font(.headline.weight(.semibold))
                        .transition(.opacity)
                        .onTapGesture {
                            text = ""
                            focused = false
                        }
                }
            }
            .animation(.easeInOut, value: showClear && !text.isEmpty)
            .foregroundStyle(Theme.color.secondaryText)
            .padding(.horizontal, Theme.spacing.s4)
            .background(Theme.color.secondarySurface)
            .cornerRadius(Theme.radius.s2)
            .onTapGesture {
                focused = true
            }
            if let caption = caption {
                Text(caption)
                    .font(.caption)
                    .foregroundStyle(Theme.color.secondaryText)
                    .padding(.top, Theme.spacing.s1)
            }
        }
    }
}

struct DynamicWidthTextField: View {
    @Binding var text: String
    @State private var textWidth: CGFloat = 0

    var body: some View {
        ZStack {
            Text(text)
                .background(GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            textWidth = geometry.size.width
                        }
                        .onChange(of: text) { oldValue, newValue in
                            textWidth = geometry.size.width
                        }
                })
                .hidden() // Hide the text view but keep it in the view hierarchy

            TextField(text: $text) {}
                .frame(width: textWidth + Theme.spacing.s2)
                .padding(4)
        }
    }
}

#Preview {
    TextInput(text: .constant(""))
}
