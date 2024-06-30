//
//  OverlapView.swift
//  letsgo-swiftui
//
//  Created by Elisey Ozerov on 18. 5. 24.
//

import SwiftUI

struct OverlapView: View {
        
    @State var children: [AnyView]
    @State var overlap: CGFloat
    @State var direction: Axis
    @State var below: Bool = true
    
    @State var sizes = [Int:CGSize]()
    
    @State var size: CGSize = .zero
    
    func totalSize(_ index: Int) -> CGSize {
        var height: CGFloat = 0
        var width: CGFloat = 0
        let lowerThanIndex = sizes.filter { Int($0.key) < index}
        let ltiKeys = Array(lowerThanIndex.keys).sorted()
        if direction == .vertical {
            ltiKeys[0..<min(index, sizes.count)].forEach { key in
                let size = sizes[key]!
                width = max(width, size.width)
                height += size.height * (1 - (key == sizes.count - 1 ? 0 : overlap))
            }
        } else {
            ltiKeys[0..<min(index, sizes.count)].forEach { key in
                let size = sizes[key]!
                height = max(height, size.height)
                width += size.width * (1 - (key == sizes.count - 1 ? 0 : overlap))
            }
        }
        let res = CGSize(width: width, height: height)
        return res
    }
    
    func offset(_ index: Int) -> CGSize {
        if (index < 1) {
            return .zero
        }
        let res = totalSize(index)
        if (direction == .vertical) {
            return CGSize(width: 0, height: res.height)
        } else {
            return CGSize(width: res.width, height: 0)
        }
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<children.count, id: \.self) { index in
                (below ? children.reversed() : children)[index]
                    .offset(offset(below ? children.count - 1 - index : index))
                    .background(GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                sizes[index] = geo.size
                            }
                    })
                    
            }
        }
        .frame(width: size.width, height: size.height, alignment: direction == .horizontal ? .leading : .top)
        .onAppear {
            DispatchQueue.main.async {
                size = totalSize(sizes.count)
            }
        }
    }
}
