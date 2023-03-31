//
//  ContentView.swift
//  garnify
//
//  Created by Vladyslav Oliinyk on 17.02.2023.
//
import SwiftUI

struct MainMenuView: View {
    @State private var navigateToNailsPlayground = false
    
    var body: some View {
        NavigationView{
            ZStack(){
                Color.yellow
                    .edgesIgnoringSafeArea(.all)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                VStack(){
                    SearchLocationPanel()
                    Spacer()
                    CircularMenuView()
                    Spacer()
                }
            }
        }
        .analyticsScreen(name: "MainMenu")
    }
}


struct CircularMenuView: View {
    @State private var radius: CGFloat = 120
    
    var body: some View {
        GeometryReader { geo in
            let center = CGPoint(x: geo.size.width/2, y: geo.size.height/2)
            
            let menuItems = [MenuItem(id: 0, icon: "hair_icon", destination: AnyView(UserProfileView())),
                             MenuItem(id: 1, icon: "nails_icon", destination: AnyView(NailsLobbyView())),
                             MenuItem(id: 2, icon: "eyes_icon", destination: AnyView(NailsLobbyView()))]
            
            let angleIncrement: Int = 360 / menuItems.count
            ZStack{
                
                ForEach(menuItems, id: \.id) { item in
                    let index = item.id
                    let angle = Double(index * angleIncrement)
                    let radians = angle * Double.pi / 180
                    let x = center.x + radius * CGFloat(cos(radians))
                    let y = center.y + radius * CGFloat(sin(radians))
                    let iconSize: CGFloat = 110
                    NavigationLink(destination: item.destination) {
                        Image(item.icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: iconSize, height: iconSize)
                    }
                    .position(CGPoint(x: x, y: y))
                    
                }
            }
            Image("other_services_icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 110, height: 110)
                .position(center)
        }
        .frame(width: 350.0, height: 350)
        .background(Color.orange.opacity(0.2))
        .cornerRadius(300)
    }
}


struct MenuItem {
    let id: Int
    let icon: String
    let destination: AnyView
    
    init<T: View>(id: Int, icon: String, destination: T) {
        self.id = id
        self.icon = icon
        self.destination = AnyView(destination)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}
