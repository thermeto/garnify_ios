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
    @Binding var selectedImage: UIImage?
    @Binding var selectedTags: [String]
    @Binding var selectedColor: Color
    @Binding var selectedLength: Api.Types.Request.GarnifyNailsRequest.GarnifyRequirements.LengthType
    @EnvironmentObject var nailsApiService: NailsApiService
    
    
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
                if let _ = selectedImage {
                    VStack(spacing: 8) {
                        // Button icon
                        Button(action: {
                            Task {
                                if let image = selectedImage {
                                    do {
                                        let (receivedImage, receivedDatetime) = try await nailsApiService.sendGarnifyNailsRequest(
                                            image: image,
                                            selectedTags: selectedTags,
                                            selectedColorHex: selectedColor.hexString,
                                            selectedLength: selectedLength
                                        )
                                        DispatchQueue.main.async {
                                            selectedImage = receivedImage
                                        }
                                        print("Received datetime:", receivedDatetime)
                                    } catch {
                                        print("Error sending image: \(error.localizedDescription)")
                                    }
                                }
                            }
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
