//
//  NailsPlaygroundView.swift
//  garnify
//
//  Created by Vladyslav Oliinyk on 23.02.2023.
//

import SwiftUI
import Firebase


struct NailsPlaygroundView: View {
    @StateObject private var nailsApiService = NailsApiService()

    @State private var selectedMode: EditMode?
    @State private var showOptions: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var tagTypedText: String = ""
    @State private var selectedColor = Color.red
    @State public var showColorPicker = false
    @State private var selectedImage: UIImage?
    @State private var imageSelected: Bool = false
    @State private var tags: [String] = []
    @State private var selectedLength: Api.Types.Request.GarnifyNailsRequest.GarnifyRequirements.LengthType = Api.Types.Request.GarnifyNailsRequest.GarnifyRequirements.LengthType.short
    
    var modes: [EditMode] = []
    
    init() {
        modes = [
            EditMode(icon: "color", title: "Color", options: []),
            EditMode(icon: "length", title: "Length", options: [shortLengthOptionButton, midLengthOptionButton, longLengthOptionButton]),
            EditMode(icon: "tags", title: "Tags", options: []),
            EditMode(icon: "influencer", title: "Influence", options: [objInfluenceOptionButton, modelInfluenceOptionButton])
        ]
    }
    
    var body: some View {
        ZStack{
            Color.yellow
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
                // Top bar
                TopBar(selectedMode: $selectedMode)
                Spacer()
                CenterSpace(showImagePicker: $showImagePicker, selectedImage: $selectedImage)
                Spacer()
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage, imageSelected: $imageSelected)
            }
            VStack{
                Spacer()
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                    Spacer()
                }
                if showOptions {
                    EditMenuOptions(
                                        selectedMode: $selectedMode,
                                        selectedColor: $selectedColor,
                                        tagTypedText: $tagTypedText,
                                        tags: $tags,
                                        showColorPicker: $showColorPicker,
                                        selectedLength: $selectedLength // Add this line
                                    )
                }
                EditMenu(modes: modes, imageSelected: $imageSelected, selectedMode: $selectedMode, showOptions: $showOptions, selectedImage: $selectedImage)
            }
        }
        .environmentObject(nailsApiService)
    }
    
    
    private var shortLengthOptionButton: ButtonConfiguration{
        ButtonConfiguration(title: "Short", action: {selectedLength = Api.Types.Request.GarnifyNailsRequest.GarnifyRequirements.LengthType.short}, frameWidth: 100)
    }
    private var midLengthOptionButton: ButtonConfiguration{
        ButtonConfiguration(title: "Mid-length", action: {selectedLength = Api.Types.Request.GarnifyNailsRequest.GarnifyRequirements.LengthType.mid}, frameWidth: 140)
    }
    private var longLengthOptionButton: ButtonConfiguration{
        ButtonConfiguration(title: "Long", action: {selectedLength = Api.Types.Request.GarnifyNailsRequest.GarnifyRequirements.LengthType.long}, frameWidth: 100)
    }
    private var objInfluenceOptionButton: ButtonConfiguration{
        ButtonConfiguration(title: "Object", action: {}, frameWidth: 100)
    }
    private var modelInfluenceOptionButton: ButtonConfiguration{
        ButtonConfiguration(title: "Model", action: {}, frameWidth: 100)
    }
}

struct EditMode: Hashable {
    let icon: String
    let title: String
    let options: [ButtonConfiguration]
}


extension Color {
    var hexString: String {
        guard let components = UIColor(self).cgColor.components else { return "" }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        let a = Float(components[3])
        let hexString = String(format: "#%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        return hexString
    }
}

struct NailsPlaygroundView_Previews: PreviewProvider {
    static var previews: some View {
        NailsPlaygroundView()
    }
}
