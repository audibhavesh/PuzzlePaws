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

struct PuzzleGrid: View {
    @State private var pieces: [[PuzzlePiece?]] = Array(repeating: Array(repeating: nil, count: 3), count: 3)
    
    
    @StateObject private var unsplashService = UnsplashService()
    @State private var image: UIImage? = nil
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            if let image = image {
                VStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200,height: 200)
                        .cornerRadius(10)
                        .padding()
                    ForEach(0..<3) { row in
                        HStack {
                            ForEach(0..<3) { column in
                                PuzzlePieceView(piece: pieces[row][column]) {
                                    //                                    handleTap(piece: pieces[row][column],atRow: row,column:column)
                                }
                                .frame(width: 100, height: 100)
                                .border(Color.black, width: 0.5)
                                .onDrop(of: [.text], isTargeted: nil) { providers in
                                    providers.first?.loadObject(ofClass: String.self) { pieceID, _ in
                                        if let pieceID = pieceID, let (pieceRow, pieceColumn) = getPiecePosition(byID: pieceID) {
                                            handleDrop(fromRow: pieceRow, fromColumn: pieceColumn, toRow: row, toColumn: column)
                                        }
                                    }
                                    return true
                                }
                            }
                        }
                    }
                    Text("Check Puzzle")
                        .font(.title2)
                        .fontWeight(Font.Weight.semibold)
                        .padding(10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .onTapGesture {
                            self.showAlert = checkCompletion()
                            
                            
                        }
                }.alert(isPresented: $showAlert){
                    Alert(
                        title: Text("You won"),
                        message: Text("Puzzle Completed"),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .onAppear {
                    initializePuzzle()
                }
            } else {
                ProgressView("Loading...")
            }
        }
        .onAppear {
            unsplashService.fetchPhotos()
        }
        .onChange(of: unsplashService.photos) {
            if unsplashService.photos.first != nil {
                fetchImage(from: unsplashService.photos.first?.urls?.raw)
            }
        }
    }
    
    //    func handleTap(piece: PuzzlePiece?) {
    //        guard var piece = piece else { return }
    //
    //        let (pieceRow, pieceColumn) = (piece.row, piece.column)
    //        let (emptyRow, emptyColumn) = (emptyPosition.row, emptyPosition.column)
    //        print("EMPTY \(emptyRow),\(emptyColumn) Curr \(pieceRow),\(pieceColumn)")
    //
    //        // Check if the tapped piece is adjacent to the empty slot
    //        if (abs(pieceRow - emptyRow) == 1 && pieceColumn == emptyColumn) || // Check for top/bottom adjacency
    //            (abs(pieceColumn - emptyColumn) == 1 && pieceRow == emptyRow) { // Check for left/right adjacency
    //            // Move the piece
    //            piece.row=emptyRow
    //            piece.column=emptyColumn
    //            pieces[emptyRow][emptyColumn] = piece
    //            pieces[pieceRow][pieceColumn] = nil
    //
    //            // Update empty position
    //            emptyPosition = (row: pieceRow, column: pieceColumn)
    //        }
    //
    //
    //    }
    func handleDrop(fromRow: Int, fromColumn: Int, toRow: Int, toColumn: Int)->Bool {
        guard var piece1 = pieces[fromRow][fromColumn] else { return false }
        guard var piece2 = pieces[toRow][toColumn] else { return false }
        
        
        piece1.row=toRow
        piece1.column=toColumn
        pieces[toRow][toColumn] = piece1
        
        piece2.row=fromRow
        piece2.column=fromColumn
        pieces[fromRow][fromColumn] = piece2
        
        return true
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
        
        //        print("\(uiImage.size.width) \(uiImage.size.height)")
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
        print(count)
        if(count==9){
            return true
        }
        return false
    }
}


#Preview {
    PuzzleGrid()
}
