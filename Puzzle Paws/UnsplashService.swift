import Foundation
import SwiftUI

class UnsplashService: ObservableObject {
    @Published var photos: [UnsplashPhoto] = []
    private let baseUrl = "https://api.unsplash.com/photos"
    private let apiKey = "Ec2n7sEfnOnMoo8hdS5phT3FzGbtcBnqttKMsb_ECIQ"
    
    func fetchPhotos() {
        let urlString = "\(baseUrl)/random?query=cute%20pets&client_id=\(apiKey)&count=1"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data returned")
                return
            }
            
            do {
                let photos = try JSONDecoder().decode([UnsplashPhoto].self, from: data)
                DispatchQueue.main.async {
                    self.photos = photos
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }
        
        task.resume()
    }
}
