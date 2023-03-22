//
//  ContentView.swift
//  Demo
//
//  Created by Jinwoo Kim on 3/23/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LazyLayoutScrollView(data: 0..<3_000) {
            SquaresLayout(maxItemLength: .constant(150))
        } content: { index, isVisible in
            if isVisible {
                StateColor()
            } else {
                Color.clear
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
