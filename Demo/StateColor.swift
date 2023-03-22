//
//  StateColor.swift
//  PhotoPickerService
//
//  Created by Jinwoo Kim on 3/23/23.
//

import SwiftUI

struct StateColor: View {
    @State private var color: Color = .init(
        red: Double.random(in: 0...1),
        green: Double.random(in: 0...1),
        blue: Double.random(in: 0...1)
    )
    
    var body: some View {
        color
    }
}
