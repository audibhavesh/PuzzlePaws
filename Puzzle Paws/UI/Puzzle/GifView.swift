import SwiftUI
import UIKit
import ImageIO

struct GIFImageView: UIViewRepresentable {
    let name: String
    
    //    func makeUIView(context: Context) -> UIImageView {
    //        let imageView = UIImageView()
    //        imageView.contentMode = .scaleToFill
    //        return imageView
    //    }
    //
    //    func updateUIView(_ uiView: UIImageView, context: Context) {
    //        uiView.loadGif(name: name)
    //    }
    
    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        let gifImageView = UIImageView()
        gifImageView.contentMode = .scaleAspectFit
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(gifImageView)
        
        NSLayoutConstraint.activate([
            gifImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            gifImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            gifImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            gifImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        gifImageView.loadGif(name: name)
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let gifImageView = uiView.subviews.first as? UIImageView {
            gifImageView.loadGif(name: name)
        }
    }
}

extension UIImageView {
    func loadGif(name: String) {
        DispatchQueue.global().async {
            guard let path = Bundle.main.path(forResource: name, ofType: "gif") else {
                print("GIF not found: \(name)")
                return
            }
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
                return
            }
            guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
                return
            }
            
            var images = [UIImage]()
            let count = CGImageSourceGetCount(source)
            for i in 0..<count {
                if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                    images.append(UIImage(cgImage: cgImage))
                }
            }
            
            DispatchQueue.main.async {
                self.animationImages = images
                self.animationDuration = Double(count) * 0.1 // Adjust the duration
                self.startAnimating()
            }
        }
    }
}
