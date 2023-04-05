//
//  NailsLobbyView.swift
//  garnify
//
//  Created by Vladyslav Oliinyk on 23.02.2023.
//

import SwiftUI

struct NailsLobbyView: View {
    
    var body: some View {
        NavigationView{
            
            ZStack{
                Color.yellow
                    .edgesIgnoringSafeArea(.all)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                VStack(){
                    SearchLocationPanel()

                    Spacer()
                    HStack(spacing: 30){
                        NavigationLink(destination: NailsPlaygroundView()) {
                            Image("workshop_icon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 150)
                        }
                        
                        NavigationLink(destination: NailsPlaygroundView()) {
                            Image("playground_icon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 150)
                        }
                    }
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
}

struct NailsLobbyView_Previews: PreviewProvider {
    static var previews: some View {
        NailsLobbyView()
    }
}
