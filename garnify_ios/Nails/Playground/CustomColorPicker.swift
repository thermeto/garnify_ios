//
//  CustomColorPicker.swift
//  garnify_ios
//
//  Created by thermeto_home on 01.04.2023.
//

import Foundation
import SwiftUI


struct CustomColorPicker: View {
    @Binding var selectedColor: Color
    let colors: [Color] = [
        .yellow,
        .orange,
        .red,
        .pink,
        .purple,
        .blue,
        .teal,
        .green,
        .mint,
        .indigo
    ]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(colors, id: \.self) { color in
                    Button(action: {
                        self.selectedColor = color
                    }) {
                        Circle()
                            .fill(color)
                            .frame(width: 50, height: 50)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: self.selectedColor == color ? 5 : 1)
                            )
                    }
                }
            }
            .padding()
        }
    }
}
