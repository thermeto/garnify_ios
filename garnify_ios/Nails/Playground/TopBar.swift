//
//  TopBar.swift
//  garnify_ios
//
//  Created by thermeto_home on 01.04.2023.
//

import Foundation
import SwiftUI

struct TopBar: View {
    @Binding var selectedMode: EditMode?

    var body: some View {
        HStack {
            BackButton(selectedMode: $selectedMode)
            Spacer()
            PhotoButton()
        }
        .padding(.top, 16)
        .padding(.bottom, 8)
    }
}

struct BackButton: View {
    @Binding var selectedMode: EditMode?

    var body: some View {
        Button(action: {
            selectedMode = nil
        }, label: {
            Image(systemName: "arrow.left")
                .padding(.horizontal)
        })
    }
}

struct PhotoButton: View {
    var body: some View {
        Button(action: {
            // ...
        }, label: {
            Image(systemName: "photo")
                .padding(.horizontal)
        })
    }
}
