//
//  NailsPlaygroundView.swift
//  garnify
//
//  Created by Vladyslav Oliinyk on 23.02.2023.
//

import SwiftUI
import Firebase


struct NailsPlaygroundView: View {
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
    func sendRequest() {
        // Get the current user's ID token
        Auth.auth().currentUser?.getIDToken(completion: { token, error in
            guard let token = token, error == nil else {
                return
            }
            print("token:\(token) ended")
            // Prepare the URL request
            let url = URL(string: "http://127.0.0.1:8000/")!
            var request = URLRequest(url: url)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            // Send the request
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    // Handle the error case
                    return
                }
                
                if let responseString = String(data: data, encoding: .utf8) {
                    // Handle the success case
                    print(data)
                }
            }.resume()
        })
    }
    
    var body: some View {
        ZStack{
            Color.yellow
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
                // Top bar
                topBar
                Spacer()
                centerSpace
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
                    // Second scroll view with buttons
                    optionScrollView
                }
                scrollView
            }
        }
    }
    
    // Scrollable bar with buttons
    private var scrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                if imageSelected{
                    VStack(spacing: 8) {
                        // Button icon
                        Button(action: {
                            sendRequest()
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
    
    private var optionScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            if selectedMode?.title == "Tags"{
                tagsOptions
            }
            else if selectedMode?.title == "Color"{
                CustomColorPicker(selectedColor: $selectedColor)
                    .padding()
            }
            else{
                regularOptions
            }
        }
        .background(Color.yellow)
        .cornerRadius(16)
    }
    
    private var regularOptions: some View{
        HStack(spacing: 10) {
            ForEach(selectedMode!.options, id: \.self) { option in
                Button(action: option.action) {
                    Text(option.title)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .foregroundColor(Color.white)
                        .background(Color.black.opacity(0.5))
                        .frame(width: option.frameWidth, height: 40, alignment: .center)
                        .cornerRadius(15)
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var tagsOptions: some View{
        HStack(spacing: 10) {
            Spacer()
            Text("#")
                .bold()
                .font(.title3)
            TextField("Enter Tag", text: $tagTypedText)
                .font(.system(size: 18))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.trailing, 20)
                .frame(height: 40)
            Button(action: {
                tags.append(tagTypedText)
                tagTypedText = ""
            }) {
                Text("Add")
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .foregroundColor(Color.white)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(10)
                    .frame(height: 40)
            }
            Spacer()
        }
        .padding(.horizontal)
        
    }
    
    private var colorOptions: some View{
        HStack(spacing: 10) {
            Button(action: {
                showColorPicker.toggle()
            }, label: {
                Circle()
                    .fill(selectedColor)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )
            })
            .sheet(isPresented: $showColorPicker, content: {
                ColorPicker("Select a color", selection: $selectedColor)
            })
        }
        .padding(.horizontal)
    }
    
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
    
    
    private var topBar: some View {
        HStack {
            backButton
            Spacer()
            photoButton
        }
        .padding(.top, 16)
        .padding(.bottom, 8)
    }
    
    private var backButton: some View {
        Button(action: {
            selectedMode = nil
        }, label: {
            Image(systemName: "arrow.left")
                .padding(.horizontal)
        })
    }
    
    // Photo upload button
    private var photoButton: some View {
        Button(action: {
            
        }, label: {
            Image(systemName: "photo")
                .padding(.horizontal)
        })
    }
    
    // Center button
    private var centerSpace: AnyView {
        if let image = selectedImage {
            return AnyView(Image(uiImage: image)
                .resizable()
                .scaledToFit())
        } else {
            return AnyView(Button(action: {
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
                .padding(.bottom, 32))
        }
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
    
    func sendGarnifyRequest(){
        if let imageData = selectedImage?.jpegData(compressionQuality: 1.0) {
            let requirements = Api.Types.Request.GarnifyNailsRequest.GarnifyRequirements(color: selectedColor.hexString, tags: tags, length: selectedLength)
            
            Api.Client.shared.uploadImage(imageData: imageData, requirements: requirements) { (result: Result<Api.Types.Response.GarnifyResponse, Error>) in
                switch result {
                case .success(let response):
                    print("Received response with id: \(response.id)")
                    
                    // Convert the Data to UIImage
                    if let image = UIImage(data: response.image) {
                        // Do something with the image
                    } else {
                        print("Error: Could not convert Data to UIImage")
                    }
                    
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}

struct EditMode: Hashable {
    let icon: String
    let title: String
    let options: [ButtonConfiguration]
}

struct ButtonConfiguration: Hashable {
    let title: String
    let action: () -> Void
    let frameWidth: CGFloat
    
    static func == (lhs: ButtonConfiguration, rhs: ButtonConfiguration) -> Bool {
        return lhs.title == rhs.title
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}

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

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImage: UIImage?
    @Binding var imageSelected: Bool
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
                parent.imageSelected = true
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
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
