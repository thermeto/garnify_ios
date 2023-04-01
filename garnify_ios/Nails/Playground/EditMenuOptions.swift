//
//  EditMenuOptions.swift
//  garnify_ios
//
//  Created by thermeto_home on 01.04.2023.
//

import Foundation
import SwiftUI

struct EditMenuOptions: View {
    @Binding var selectedMode: EditMode?
    @Binding var selectedColor: Color
    @Binding var tagTypedText: String
    @Binding var tags: [String]
    @Binding var showColorPicker: Bool
    @Binding var selectedLength: Api.Types.Request.GarnifyNailsRequest.GarnifyRequirements.LengthType
    

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            if selectedMode?.title == "Tags" {
                tagsOptions
            }
            else if selectedMode?.title == "Color" {
                CustomColorPicker(selectedColor: $selectedColor)
                    .padding()
            }
            else {
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
}

