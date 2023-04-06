//
//  StatusBar.swift
//  garnify_ios
//
//  Created by thermeto_home on 06.04.2023.
//

import Foundation
import SwiftUI

struct StatusBarContainerView: View {
    @Binding var showStatusBar: Bool
    var selectedColor: Color
    var selectedLength: Api.Types.Request.GarnifyNailsRequest.GarnifyRequirements.LengthType
    var tags: [String]

    var body: some View {
        VStack {
            Rectangle()
                .frame(height: 60)
                .opacity(0)
            HStack {
                Spacer()
                Button(action: {
                    showStatusBar.toggle()
                }) {
                    HStack(spacing: 10) {
                        Circle().frame(width: 18, height: 18)
                        Circle().frame(width: 18, height: 18)
                        Circle().frame(width: 18, height: 18)
                    }
                    .foregroundColor(.blue) // Set the color of the dots
                }
                .padding([.trailing], 20)
            }

            HStack {
                Spacer()
                if showStatusBar {
                    StatusBarView(selectedColor: selectedColor, selectedLength: selectedLength, tags: tags)
                        .padding(.bottom)
                }
            }
            .padding(10)
            Spacer()
        }
    }
}

struct StatusBarView: View {
    var selectedColor: Color
    var selectedLength: Api.Types.Request.GarnifyNailsRequest.GarnifyRequirements.LengthType
    var tags: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Color:").bold()
                selectedColor
                    .frame(width: 20, height: 20)
                    .clipShape(Circle())
            }
            
            Text("Length:").bold()
            Text(selectedLength.rawValue)
            
            Text("Tags:").bold()
            ForEach(tags, id: \.self) { tag in
                Text("#" + tag)
            }
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .cornerRadius(10)
    }
}
