import SwiftUI

struct PuzzlePiece: Identifiable,Equatable {
    let id = UUID()
    var image: Image
    var position: CGPoint
    var correctPosition: CGPoint
    var isCorrectlyPlaced: Bool = false
    
    static func == (lhs: PuzzlePiece, rhs: PuzzlePiece) -> Bool {
            return lhs.id == rhs.id
                && lhs.position == rhs.position
                && lhs.correctPosition == rhs.correctPosition
                && lhs.isCorrectlyPlaced == rhs.isCorrectlyPlaced
        }
}
