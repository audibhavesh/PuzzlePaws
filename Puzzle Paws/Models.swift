import Foundation
import SwiftUI

// Unsplash API response models
struct UnsplashPhoto: Codable, Identifiable,Equatable {
    let id: String?
    let slug: String?
    let urls: PhotoUrls?
    let alt_description: String?
    let user: User?
    static func == (lhs: UnsplashPhoto, rhs: UnsplashPhoto) -> Bool {
          return lhs.id == rhs.id
            
      }
    
}

struct PhotoUrls: Codable {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
}

struct User: Codable {
    let id: String?
    let username: String?
    let name: String?
    let profile_image: ProfileImage?
}

struct ProfileImage: Codable {
    let small: String?
    let medium: String?
    let large: String?
}


struct PuzzlePiece: Identifiable,Equatable {
    let id:String = UUID().uuidString
    let image: Image?
    var row: Int
    var column: Int
    let index:Int
    
    static func == (lhs: PuzzlePiece, rhs: PuzzlePiece) -> Bool {
          return lhs.id == rhs.id
            
      }
}
struct Position: Hashable {
    let row: Int
    let column: Int
}
