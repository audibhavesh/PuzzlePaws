import Foundation
import Foundation

// Model for the Unsplash API response


class NetworkManager {
    private let apiKey = "Ec2n7sEfnOnMoo8hdS5phT3FzGbtcBnqttKMsb_ECIQ"
    private let baseUrl = "https://api.unsplash.com/photos"
    
    func fetchRandomPetImage(completion: @escaping (Result<Data, Error>) -> Void) {
        let urlString = "\(baseUrl)/random?query=cute%20pets&client_id=\(apiKey)&count=1"
        print(urlString)
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                } else {
                    print("Failed to convert data to string")
                }
                let response = try JSONDecoder().decode([UnsplashPhoto].self, from: data)
                print("response \(response)")
                if let imageUrlString = response.first?.urls?.raw, let imageUrl = URL(string: imageUrlString) {
                    self.downloadImage(from: imageUrl, completion: completion)
                } else {
                    completion(.failure(NetworkError.noImageUrl))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func downloadImage(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            completion(.success(data))
        }
        task.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case noImageUrl
}
