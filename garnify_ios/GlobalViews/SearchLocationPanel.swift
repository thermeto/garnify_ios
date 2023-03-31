//
//  SearchLocationPanelView.swift
//  garnify_ios
//
//  Created by Vladyslav Oliinyk on 18.03.2023.
//

import Foundation
import SwiftUI

struct SearchLocationPanel  : View {
    @State var searchDefaultText = "Find beauty services..."
    @State var city = "City"
    
    var body: some View {
        VStack(){
            HStack(spacing: 20){
                NavigationLink(destination: UserProfileView()){
                    Label("", systemImage: "person")
                        .frame(width: 41, height: 41)
                        .foregroundColor(Color.black)
                }
                TextField(searchDefaultText, text: $searchDefaultText)
                    .font(.system(size: 18))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding([.trailing, .leading], 20)
            HStack(spacing: 20) {
                Label("My location", systemImage: "")
                Button(action: {}) {
                    Label("", systemImage: "location")
                        .frame(width: 41, height: 41)
                        .background(Color.yellow)
                        .foregroundColor(Color.black)
                }
                TextField(city, text: $city)
                    .font(.system(size: 17))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }.padding([.trailing, .leading, .top], 20)
        }
    }
}
