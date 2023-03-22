//
//  SquaresLayout.swift
//  PhotoPickerService
//
//  Created by Jinwoo Kim on 3/22/23.
//

import SwiftUI

struct SquaresLayout: Layout {
    static var layoutProperties: LayoutProperties {
        var layoutProperties: LayoutProperties = .init()
        layoutProperties.stackOrientation = .vertical
        return layoutProperties
    }
    
    @Binding var maxItemLength: CGFloat
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        let count: Int = subviews.count
        
        guard 
            count > .zero,
            let width: CGFloat = proposal.width,
            width > .zero,
            width < .greatestFiniteMagnitude // ExtensionKit Bug...
        else {
            return .zero
        }
        
        let column: Int = column(viewWidth: width)
        let row: Int = row(viewWidth: width, count: count, column: column)
        let height: CGFloat = preferredItemLength(viewWidth: width, column: column) * .init(row)
        
        let result: CGSize = .init(
            width: width,
            height: height
        )
        
        return result
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
        guard bounds.size.width > .zero && bounds.size.height > .zero else {
            return
        }
        
        let column: Int = column(viewWidth: bounds.size.width)
        let width: CGFloat = preferredItemLength(viewWidth: bounds.size.width, column: column)
        
        subviews
            .enumerated()
            .forEach { index, subview in
                let columnIndex: Int = index % column
                let currentRow: Int = index / column
                
                let origin: CGPoint = .init(
                    x: bounds.minX + .init(columnIndex) * width,
                    y: bounds.minY + .init(currentRow) * width
                )
                
                subview.place(
                    at: origin,
                    anchor: .topLeading,
                    proposal: .init(width: width, height: width)
                )
            }
    }
    
    private func column(viewWidth: CGFloat) -> Int {
        guard viewWidth > maxItemLength else {
            return 1
        }
        
        return Int(viewWidth / maxItemLength)
    }
    
    private func row(viewWidth: CGFloat, count: Int, column: Int? = nil) -> Int {
        let column: Int = column ?? self.column(viewWidth: viewWidth)
        let rowQuotient: Int = count / column
        let rowRemainder: Int = count % column
        let row: Int = (rowRemainder == .zero) ? rowQuotient : (rowQuotient + 1)
        
        return row
    }
    
    private func preferredItemLength(viewWidth: CGFloat, column: Int? = nil) -> CGFloat {
        let column: Int = column ?? self.column(viewWidth: viewWidth)
        return min((viewWidth / .init(column)), viewWidth)
    }
}

extension SquaresLayout: LazyLayoutScrollViewProtocol {
    func isSubviewVisible(index: Int, frame: CGRect, safeAreaInsets: EdgeInsets) -> Bool {
        let correctedFrame: CGRect = .init(
            origin: .init(x: -frame.origin.x, y: -frame.origin.y),
            size: frame.size
        )
        
        let column: Int = column(viewWidth: correctedFrame.size.width)
        let preferredItemLength: CGFloat = preferredItemLength(viewWidth: correctedFrame.size.width, column: column)
        let row: Int = index / column
        let yOffset: CGFloat = preferredItemLength * CGFloat(row) + preferredItemLength
        let isVisible: Bool = (yOffset >= (correctedFrame.origin.y - safeAreaInsets.top)) && (yOffset <= (correctedFrame.origin.y + correctedFrame.size.height + preferredItemLength + safeAreaInsets.bottom))
        
        return isVisible
    }
}
