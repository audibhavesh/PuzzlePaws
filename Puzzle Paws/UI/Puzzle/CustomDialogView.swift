import SwiftUI

struct CustomDialogView: View {
    @Binding var isPresented: Bool
    
    @Binding var stars:Int
    
    @Binding var resetGame:Bool
    
    @Binding var goHome:Bool
    

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            ZStack{
                Image(uiImage: UIImage(named: "wooden_board") ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 350, alignment: .center)
                getStar()
                VStack {
                    Text("Congratulations\nYou Won!!")
                        .font(.custom("PawWowBlockRegular", size: 40).weight(.semibold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.top,20)
                    
                    HStack{
                        Image(uiImage: UIImage(named: "home_button") ?? UIImage())
                            .resizable()
                            .scaledToFit()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 70, height: 70)
                            .onTapGesture {
                                goHome=true
                                isPresented=false
                            }
                            
                        
                        Image(uiImage: UIImage(named: "restart_button") ?? UIImage())
                            .resizable()
                            .scaledToFit()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 70, height: 70).onTapGesture {
                                isPresented=false
                                resetGame=true
                            }
                    }
                    
                }
               
            }
        }
        
    }
    func getStar()-> some View{
        let width: CGFloat? = 80
        let height: CGFloat? = 100
        return HStack(){
            ForEach(0..<stars, id: \.self) { _ in
                Image(uiImage: UIImage(named: "filled_star") ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
            }
            ForEach(0..<(3 - stars), id: \.self) { _ in
                Image(uiImage: UIImage(named: "empty_star") ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
            }
        }.offset(y:-110)
    }
}

#Preview {
    CustomDialogView(isPresented:.constant(true),stars: .constant(3),resetGame: .constant(false),goHome: .constant(false))
}
