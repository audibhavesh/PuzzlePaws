import SwiftUI
struct PuzzlePieceView: View {
    let piece: PuzzlePiece?
    let onTap: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            if let piece = piece {
                piece.image?
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                
                    .onTapGesture {
                        onTap()
                    }
                    .onDrag {
                        // Provide a unique identifier for the dragged piece
                        let itemProvider = NSItemProvider(object: piece.id as NSString)
                        return itemProvider
                    }
            } else {
                Color.clear
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}
