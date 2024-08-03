//
//  ContentView.swift
//  Puzzle Paws
//
//  Created by Bhavesh Audichya on 25/07/24.
//

import SwiftUI

struct ContentView: View {
//    init(){
//        for familyName in UIFont.familyNames{
//            print(familyName)
//            for fontName in UIFont.fontNames(forFamilyName: familyName){
//                print("-- \(fontName)")
//            }
//        }
//    }
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                
                ZStack{
                    Image("homepage_background")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    VStack {
                        ZStack{
                        
        
                            Image(uiImage: UIImage(named: "back_board") ?? UIImage())
                                .resizable()
                                .scaledToFit()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 300, height: 350, alignment: .center).padding(.top,50)
                            Text("Puzzle\nPaws")
                                .font(.custom("PawWowBlockRegular", size: 65))
                                .padding(.top,50)
                                .multilineTextAlignment(.center)
                                .fontWeight(Font.Weight.semibold)
                                .padding(10)
                                .foregroundColor(.brown)
                                .cornerRadius(10)
                        }
                        Spacer()
                        NavigationLink(destination: PuzzleGrid()) {
                            Image(uiImage: UIImage(named: "start_button") ?? UIImage())
                                .resizable()
                                .scaledToFit()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 250, height: 250, alignment: .bottom).padding(.top,50)
                            
                        }
                    }  .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
