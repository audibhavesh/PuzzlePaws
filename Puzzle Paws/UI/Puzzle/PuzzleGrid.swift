import SwiftUI

extension UIImage {
    func crop(to rect: CGRect) -> UIImage? {
        guard let cgImage = self.cgImage?.cropping(to: rect) else { return nil }
        return UIImage(cgImage: cgImage)
    }
    
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
}

extension View {
    @ViewBuilder
    func onChangeCompatible<V: Equatable>(of value: V, perform action: @escaping (V) -> Void) -> some View {
        if #available(iOS 17.0, *) {
            self.onChange(of: value) { oldValue, newValue in
                action(newValue)
            }
        } else {
            self.onChange(of: value, perform: action)
        }
    }
}
struct PuzzleGrid: View {
    
    @State private var pieces: [[PuzzlePiece?]] = Array(repeating: Array(repeating: nil, count: 3), count: 3)
    
    @Environment(\.presentationMode) var presentationMode
    
    
    @StateObject private var unsplashService = UnsplashService()
    @State private var image: UIImage? = nil
    @State private var showAlert = false
    @State private var totalStars = 0
    
    @State private var startTime:TimeInterval? = nil
    @State private var endTime:TimeInterval? = nil
    
    @State private var resetGame=false
    
    @State private var goHome=false
    
    @State private var soundOn=true
    
    private var downloadImage=true
    
    
    @StateObject var soundManager = SoundManager()
    
    //    var body: some View {
    //        GeometryReader { geo in
    //            ZStack{
    //                Image("game_background")
    //                    .resizable()
    //                    .scaledToFill()
    //                    .edgesIgnoringSafeArea(.all)
    //                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
    //                VStack {
    //                    if let image = image {
    //                        VStack {
    //                            ZStack{
    //                                Image("puzzle_board")
    //                                    .resizable()
    //                                    .edgesIgnoringSafeArea(.all)
    //                                    .frame(width: 180, height: 180, alignment: .center)
    //                                Image(uiImage: image)
    //                                    .resizable()
    //                                    .scaledToFit()
    //                                    .frame(width: 150,height: 150)
    //                                    .cornerRadius(10)
    //                                    .padding()
    //                            }.padding(.bottom,40)
    //                            ZStack{
    //                                Image("wooden_board")
    //                                    .resizable()
    //                                    .edgesIgnoringSafeArea(.all)
    //                                    .frame(width: 380, height: 380, alignment: .center)
    //                                VStack{
    //                                    ForEach(0..<3) { row in
    //                                        HStack {
    //                                            ForEach(0..<3) { column in
    //                                                PuzzlePieceView(piece: pieces[row][column]) {}
    //                                                    .frame(width: 90, height: 90)
    //                                                    .border(Color.black, width: 0.5)
    //                                                    .cornerRadius(10)
    //                                                    .onDrop(of: [.text], isTargeted: nil) { providers in
    //                                                        _ = providers.first?.loadObject(ofClass: String.self) { (pieceID, error) in
    //                                                            if let pieceID = pieceID, let (pieceRow, pieceColumn) = getPiecePosition(byID: pieceID) {
    //                                                                handleDrop(fromRow: pieceRow, fromColumn: pieceColumn, toRow: row, toColumn: column)
    //
    //                                                            }
    //                                                            else if let error = error {
    //                                                                print("Something went wrong \(error)")
    //
    //                                                            }
    //                                                        }
    //                                                        return true
    //                                                    }
    //                                            }
    //                                        }
    //                                    }
    //                                }
    //                            }
    //                            HStack{
    //                                Image("home_button")
    //                                    .resizable()
    //                                    .edgesIgnoringSafeArea(.all)
    //                                    .frame(width: 100, height: 100, alignment: .center).onTapGesture {
    //                                        soundManager.stopSound()
    //                                        self.presentationMode.wrappedValue.dismiss()
    //
    //
    //                                    }
    //                                if soundOn{
    //                                    Image("sound_on")
    //                                        .resizable()
    //                                        .edgesIgnoringSafeArea(.all)
    //                                        .frame(width: 100, height: 100, alignment: .center).onTapGesture {
    //                                            self.soundOn = !self.soundOn
    //                                            soundManager.stopSound()
    //
    //                                        }
    //                                }
    //                                else{
    //                                    Image("sound_off")
    //                                        .resizable()
    //                                        .edgesIgnoringSafeArea(.all)
    //                                        .frame(width: 100, height: 100, alignment: .center).onTapGesture {
    //                                            self.soundOn = !self.soundOn
    //                                            soundManager.playSound(sound: "cottoncandy", type: "mp3")
    //                                        }
    //                                }
    //                            }
    //
    //                        }.onAppear {
    //                            initializePuzzle()
    //                        }
    //                    } else {
    //                        GIFImageView(name: "loader").frame(width: 300,height:50)
    //                        Text("Loading...")
    //                            .font(.custom("PawWowBlockRegular", size: 40,weight:.bold))
    //                            .foregroundColor(.white)
    //
    //                    }
    //                }
    //                .onAppear {
    //                    getImage()
    //                }
    //                .onChange(of: unsplashService.photos) {
    //                    if unsplashService.photos.first != nil {
    //                        fetchImage(from: unsplashService.photos.first?.urls?.raw)
    //                    }
    //                }
    //            }
    //            if showAlert {
    //                CustomDialogView(isPresented: $showAlert,stars: $totalStars,resetGame: $resetGame, goHome: $goHome)
    //            }
    //
    //        }
    //        .onChange(of:resetGame){
    //            if resetGame{
    //                DispatchQueue.main.async {
    //                    self.image=nil
    //                    self.startTime=nil
    //                    self.endTime=nil
    //                    self.totalStars=0
    //                    self.getImage()
    //                }
    //            }
    //
    //        }
    //        .onChange(of: goHome){
    //            if goHome{
    //                soundManager.stopSound()
    //                self.presentationMode.wrappedValue.dismiss()
    //            }
    //        }
    //    }
    
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                backgroundImage(for: geo)
                mainContent(for:geo)
            }
            .overlay(alertOverlay)
        }
        .onChangeCompatible(of: resetGame) { _ in handleResetGame() }
        .onChangeCompatible(of: goHome) { _ in handleGoHome() }
    }
    
    private func backgroundImage(for geometry: GeometryProxy) -> some View {
        Image("game_background")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
    }
    
    private func mainContent(for geometry: GeometryProxy)-> some View {
        VStack {
            if let image = image {
                puzzleContent(image: image,for: geometry)
            } else {
                loadingView
            }
        }
        .onAppear { getImage() }
        .onChangeCompatible(of: unsplashService.photos) { _ in handlePhotosChange() }
    }
    private var loadingView: some View {
        VStack {
            GIFImageView(name: "loader").frame(width: 300, height: 50)
            Text("Loading...")
                .font(.custom("PawWowBlockRegular", size: 40).weight(.bold))
                .foregroundColor(.white)
        }
    }
    
    private func puzzleContent(image: UIImage,for geometry: GeometryProxy) -> some View {
        VStack {
            previewImage(image)
            puzzleBoard
            controlButtons
        }.frame(width: geometry.size.width,height: geometry.size.height)
            .onAppear { initializePuzzle() }
        
        
    }
    
    private func previewImage(_ image: UIImage) -> some View {
        ZStack {
            Image("puzzle_board")
                .resizable()
                .frame(width: 180, height:180)
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .cornerRadius(10)
                .padding()
        }
    }
    
    private var puzzleBoard: some View {
        ZStack {
            Image("wooden_board")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .frame(width: 380, height: 380)
            VStack {
                ForEach(0..<3) { row in
                    HStack {
                        ForEach(0..<3) { column in
                            puzzlePiece(at: row, column: column)
                        }
                    }
                }
            }
        }
    }
    
    private func puzzlePiece(at row: Int, column: Int) -> some View {
        PuzzlePieceView(piece: pieces[row][column]) {}
            .frame(width: 90, height: 90)
            .border(Color.black, width: 0.5)
            .cornerRadius(10)
            .onDrop(of: [.text], isTargeted: nil) { providers in
                handleDrop(providers: providers, toRow: row, toColumn: column)
            }
    }
    
    
    
    private var controlButtons: some View {
        HStack {
            homeButton
            soundButton
        }.padding(.bottom,60)
    }
    
    private var homeButton: some View {
        Image("home_button")
            .resizable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: 100, height: 100, alignment: .center)
            .onTapGesture {
                soundManager.stopSound()
                self.presentationMode.wrappedValue.dismiss()
            }
    }
    
    private var soundButton: some View {
        Group {
            if soundOn {
                Image("sound_on")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: 100, height: 100, alignment: .center)
                    .onTapGesture {
                        self.soundOn.toggle()
                        soundManager.stopSound()
                    }
            } else {
                Image("sound_off")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: 100, height: 100, alignment: .center)
                    .onTapGesture {
                        self.soundOn.toggle()
                        soundManager.playSound(sound: "cottoncandy", type: "mp3")
                    }
            }
        }
    }
    
    private var alertOverlay: some View {
        Group {
            if showAlert {
                CustomDialogView(isPresented: $showAlert, stars: $totalStars, resetGame: $resetGame, goHome: $goHome)
            }
        }
    }
    
    private func handleDrop(providers: [NSItemProvider], toRow: Int, toColumn: Int) -> Bool {
        guard let provider = providers.first else { return false }
        
        _ = provider.loadObject(ofClass: String.self) { (pieceID, error) in
            if let pieceID = pieceID, let (pieceRow, pieceColumn) = getPiecePosition(byID: pieceID) {
                handleDrop(fromRow: pieceRow, fromColumn: pieceColumn, toRow: toRow, toColumn: toColumn)
            } else if let error = error {
                print("Something went wrong \(error)")
            }
        }
        return true
    }
    
    private func handleResetGame() {
        if resetGame {
            DispatchQueue.main.async {
                self.image = nil
                self.startTime = nil
                self.endTime = nil
                self.totalStars = 0
                self.getImage()
            }
        }
    }
    
    
    
    private func handleGoHome() {
        if goHome {
            soundManager.stopSound()
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func handlePhotosChange() {
        if let firstPhoto = unsplashService.photos.first {
            fetchImage(from: firstPhoto.urls?.raw)
        }
    }
    
    func getImage(){
        if(downloadImage){
            unsplashService.fetchPhotos()
        }
        else{
            DispatchQueue.main.async {
                self.image=UIImage(named:"AppIcon60x60") ?? UIImage()
                    .resize(to: CGSize(width: 300, height: 300))
            }
        }
    }
    
    func handleDrop(fromRow: Int, fromColumn: Int, toRow: Int, toColumn: Int) {
        guard var piece1 = pieces[fromRow][fromColumn] else { return  }
        guard var piece2 = pieces[toRow][toColumn] else { return  }
        
        
        piece1.row=toRow
        piece1.column=toColumn
        pieces[toRow][toColumn] = piece1
        
        piece2.row=fromRow
        piece2.column=fromColumn
        pieces[fromRow][fromColumn] = piece2
        
        if(startTime==nil){
            startTime=Date().timeIntervalSince1970
        }
        
        self.showAlert = checkCompletion()
        
    }
    
    func getPiecePosition(byID id: String) -> (Int, Int)? {
        for row in 0..<3 {
            for column in 0..<3 {
                if let piece = pieces[row][column], piece.id == id {
                    return (row, column)
                }
            }
        }
        return nil
    }
    
    
    func initializePuzzle() {
        guard let uiImage = image else { return }
        
        let width = (uiImage.size.width) / 3
        let height = (uiImage.size.height) / 3
        let scale=uiImage.scale
        
        var allPieces: [PuzzlePiece] = []
        
        var index:Int = 0
        for row in 0..<3 { // Initialize pieces only for the top 3 rows
            for column in 0..<3 {
                let x = CGFloat(column) * width*scale
                let y = CGFloat(row) * height*scale
                let cropRect = CGRect(x: x, y: y, width: width*scale, height: height*scale)
                if let cgImage = image?.cgImage?.cropping(to: cropRect) {
                    let croppedImage = Image(uiImage: UIImage(cgImage:cgImage))
                    allPieces.append(PuzzlePiece(image:croppedImage, row: row, column: column,index:index))
                    index+=1
                }
                
                
            }
        }
        
        allPieces.shuffle()
        
        for row in 0..<3{
            for column in 0..<3 {
                if !allPieces.isEmpty {
                    var piece = allPieces.removeLast()
                    piece.row=row
                    piece.column=column
                    pieces[row][column] = piece
                } else {
                    pieces[row][column] = PuzzlePiece(image:nil, row: row, column: column,index:-1)
                }
            }
        }
        
        
        
        
    }
    
    func shufflePieces( piecesOld:[[PuzzlePiece?]] )->[[PuzzlePiece?]]{
        // Flatten the 2D array into a 1D array
        var piecesNew=piecesOld;
        var flattened: [PuzzlePiece?] = piecesOld.flatMap { $0 }
        flattened = Array(flattened.dropLast(3))        // Shuffle the 1D
        flattened.shuffle()
        // Reshape the shuffled 1D array back into the 2D array
        var index = 0
        for row in 0..<3 {
            for col in 0..<3{
                piecesNew[row][col] = flattened[index]
                index += 1
            }
        }
        print(piecesNew)
        return piecesNew
    }
    
    func fetchImage(from urlString: String?) {
        guard let url = URL(string: urlString!) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    if(soundOn){
                        soundManager.playSound(sound: "cottoncandy", type: "mp3")
                    }
                    self.image=uiImage.resize(to: CGSize(width: 300, height: 300))
                }
            }
        }.resume()
    }
    
    func checkCompletion() -> Bool {
        var index=0
        var count=0
        for row in 0..<3 {
            for column in 0..<3 {
                if let piece = pieces[row][column] {
                    if (piece.index == index) {
                        count+=1
                    }
                }
                index+=1
            }
        }
        if(count==9){
            endTime=Date().timeIntervalSince1970
            totalStars = calculateElapsedTimeValue(startTime: startTime ?? 0, endTime: endTime ?? 0)
            return true
        }
        return false
    }
    
    func calculateElapsedTimeValue(startTime: TimeInterval, endTime: TimeInterval) -> Int {
        let elapsedTime = (endTime - startTime) / 60.0
        
        if elapsedTime <= 1 {
            return 3
        } else if elapsedTime > 1{
            return 2
        } else {
            return 1
        }
    }
    
}


#Preview {
    PuzzleGrid()
}
