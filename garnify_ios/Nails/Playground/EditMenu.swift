//
//  EditMenu.swift
//  garnify_ios
//
//  Created by thermeto_home on 01.04.2023.
//

import Foundation
import SwiftUI

struct EditMenu: View {
    var modes: [EditMode]
    @Binding var imageSelected: Bool
    @Binding var selectedMode: EditMode?
    @Binding var showOptions: Bool

    private func modeButton(mode: EditMode) -> some View {
        Button(action: {
            if selectedMode == mode {
                showOptions.toggle()
            } else {
                selectedMode = mode
                showOptions = true
            }
        }, label: {
            VStack(spacing: 8) {
                // Button icon
                Image(mode.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .font(.system(size: 24))

                // Button title
                Text(mode.title)
                    .font(.system(size: 12))
            }
            .foregroundColor(selectedMode == mode ? .white : .gray)
            .padding(8)
            .background(selectedMode == mode ? Color.blue : Color.clear)
            .cornerRadius(16)
        })
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                if imageSelected {
                    VStack(spacing: 8) {
                        // Button icon
                        Button(action: {
                            // Action here
                        }, label: {
                            Image("g_icon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .font(.system(size: 24))
                        })

                        // Button title
                        Text("garnify")
                            .font(.system(size: 12))
                    }
                }
                ForEach(modes, id: \.self) { mode in
                    modeButton(mode: mode)
                }
            }
            .padding(.horizontal)
        }
    }
}
