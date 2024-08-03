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
                            Image(uiImage: UIImage(named: "puzzle_board") ?? UIImage())
                                .resizable()
                                .scaledToFit()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 250, alignment: .center).padding(.top,50)
                            Text("Puzzle\nPaws")
                                .font(.custom("PawWowBlockRegular", size: 65).weight(.semibold))
                                .padding(.top,50)
                                .multilineTextAlignment(.center)
                                
                                .padding(10)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        Spacer()
                        NavigationLink(destination: PuzzleGrid().navigationBarBackButtonHidden(true)){
                            ZStack{
                                Image(uiImage: UIImage(named: "go_button") ?? UIImage())
                                    .resizable()
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 250, height: 150, alignment: .bottom)
                                Text("Start")
                                    .font(.custom("PawWowBlockRegular", size: 55).weight(.semibold))
                                    .padding(.top,60)
                                    .multilineTextAlignment(.center)
                                   
                                    .padding(10)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }.padding(.bottom,50)
                            
                        }.navigationBarBackButtonHidden(true)
                    }  .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }.navigationViewStyle(.stack)
    }
}

#Preview {
    ContentView()
}
