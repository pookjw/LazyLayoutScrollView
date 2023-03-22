//
//  LazyLayoutScrollView.swift
//  PhotoPickerService
//
//  Created by Jinwoo Kim on 3/22/23.
//

import SwiftUI

private let coordinateSpaceName: String = "lazy_coordinate_name"

protocol LazyLayoutScrollViewProtocol: Layout {
    func isSubviewVisible(index: Int, frame: CGRect, safeAreaInsets: EdgeInsets) -> Bool
}

struct LazyLayoutScrollView<Layout, Content>: View where Layout: LazyLayoutScrollViewProtocol, Content: View {
    private let axes: Axis.Set
    private let showsIndicators: Bool
    private let data: Range<Int>
    private let layout: () -> Layout
    private let content: (Int, Bool) -> Content
    @State private var frameBuffer: CGRect = .zero
    @State private var sizeBuffer: CGSize = .zero
    @State private var visibleCache: [Int: Bool] = .init()
    
    init(
        _ axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        data: Range<Int>,
        layout: @escaping () -> Layout,
        @ViewBuilder content: @escaping (Int, Bool) -> Content
    ) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.data = data
        self.layout = layout
        self.content = content
    }
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(axes, showsIndicators: showsIndicators) {
                let layout: Layout = layout()
                
                layout
                    .callAsFunction {
                        ForEach(data, id: \.self) { index in
                            let isVisible: Bool = layout.isSubviewVisible(index: index, frame: .init(origin: frameBuffer.origin, size: proxy.size), safeAreaInsets: proxy.safeAreaInsets)
                            content(index, isVisible)
                        }
                    }
                    .background {
                        GeometryReader { proxy in
                            Color.clear
                                .preference(
                                    key: CGRectValueKey.self,
                                    value: proxy.frame(in: .named(coordinateSpaceName))
                                )
                        }
                    }
                    .onPreferenceChange(CGRectValueKey.self) { frame in
                        frameBuffer = frame
                    }
            }
            .coordinateSpace(name: coordinateSpaceName)
        }
    }
}

private struct CGRectValueKey: PreferenceKey {
    static let defaultValue = CGRect.zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        
    }
}
