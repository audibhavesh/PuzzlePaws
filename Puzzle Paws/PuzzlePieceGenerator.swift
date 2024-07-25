import SwiftUI
import CoreImage.CIFilterBuiltins

class PuzzlePieceGenerator {
    func generatePuzzlePieces(from image: UIImage, rows: Int, columns: Int) -> [PuzzlePiece] {
        let size = CGSize(width: image.size.width / CGFloat(columns), height: image.size.height / CGFloat(rows))
        var pieces: [PuzzlePiece] = []
        
        for row in 0..<rows {
            for column in 0..<columns {
                let rect = CGRect(x: CGFloat(column) * size.width, y: CGFloat(row) * size.height, width: size.width, height: size.height)
                if let pieceImage = cropImage(image: image, toRect: rect) {
                    let piece = PuzzlePiece(image: pieceImage, position: rect.origin, correctPosition: rect.origin)
                    pieces.append(piece)
                }
            }
        }
        return pieces
    }
    
    private func cropImage(image: UIImage, toRect rect: CGRect) -> Image? {
        let cgImage = image.cgImage?.cropping(to: rect)
        guard let croppedCGImage = cgImage else { return nil }
        let croppedImage = UIImage(cgImage: croppedCGImage)
        return Image(uiImage: croppedImage)
    }
}
