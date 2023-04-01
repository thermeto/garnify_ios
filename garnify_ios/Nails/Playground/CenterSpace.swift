//
//  CenterSpace.swift
//  garnify_ios
//
//  Created by thermeto_home on 01.04.2023.
//

import Foundation
import SwiftUI

struct CenterSpace: View {
    @Binding var showImagePicker: Bool
    @Binding var selectedImage: UIImage?

    var body: some View {
        if let image = selectedImage {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        } else {
            Button(action: {
                showImagePicker = true
            }, label: {
                Image(systemName: "camera.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    .background(Color.white)
                    .cornerRadius(32)
                    .shadow(radius: 8)
            })
            .padding(.bottom, 32)
        }
    }
}
