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
    @State private var selectedImageURL: URL?
    @State private var tags: [String] = []
    @State private var selectedLength: Api.Types.Request.GarnifyNailsRequest.GarnifyRequirements.LengthType = Api.Types.Request.GarnifyNailsRequest.GarnifyRequirements.LengthType.short
    @State private var showStatusBar: Bool = false
    @State private var isLoading: Bool = false

    
    var modes: [EditMode] = []
    
    init() {
        modes = [
            EditMode(icon: "color", title: "Color", options: []),
            EditMode(icon: "length", title: "Length", options: [
                ButtonConfiguration(title: "Short", frameWidth: 100, value: Api.Types.Request.GarnifyNailsRequest.GarnifyRequirements.LengthType.short),
                ButtonConfiguration(title: "Mid-length", frameWidth: 140, value: Api.Types.Request.GarnifyNailsRequest.GarnifyRequirements.LengthType.mid),
                ButtonConfiguration(title: "Long", frameWidth: 100, value: Api.Types.Request.GarnifyNailsRequest.GarnifyRequirements.LengthType.long)
            ]),
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
                TopBar(selectedMode: $selectedMode, showImagePicker: $showImagePicker)
                Spacer()
                CenterSpace(showImagePicker: $showImagePicker, selectedImage: $selectedImage)
                    .offset(y: -40)
                Spacer()
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage, imageSelected: $imageSelected, selectedImageURL: $selectedImageURL)
            }
            VStack{
                Spacer()
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
                EditMenu(modes: modes, isLoading: $isLoading, imageSelected: $imageSelected, selectedMode: $selectedMode, showOptions: $showOptions, selectedImage: $selectedImage, selectedTags: $tags, selectedColor: $selectedColor, selectedLength: $selectedLength, selectedImageURL: $selectedImageURL)
            }
            VStack{
                StatusBarContainerView(showStatusBar: $showStatusBar, selectedColor: selectedColor, selectedLength: selectedLength, tags: tags)
            }
        }
        .environmentObject(nailsApiService)
        .navigationBarBackButtonHidden(true)
        .overlay(Group {
                if isLoading {
                    ZStack {
                        Color.black.opacity(0.5)
                            .ignoresSafeArea()
                        ProgressView()
                            .scaleEffect(2)
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    }
                }
            })
        
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

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

