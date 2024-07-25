//
//  ContentView.swift
//  Puzzle Paws
//
//  Created by Bhavesh Audichya on 25/07/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Puzzle Paws")
                    .font(.largeTitle)
                    .fontWeight(Font.Weight.heavy)
                    .padding()
                    .foregroundColor(.orange)
                
                Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200,height: 200)
                    .cornerRadius(10)
                    .padding()
               
                NavigationLink(destination: PuzzleGrid()) {
                    Text("Start Puzzle")
                        .font(.title)
                        .fontWeight(Font.Weight.heavy)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
