//
//  UIImageViewExtension.swift
//  findfood
//
//  Created by Bertay Yönel on 12.12.2022.
//

import UIKit

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleToFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLresponse = response as? HTTPURLResponse, httpURLresponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from urlStr: String, contentMode mode: ContentMode = .scaleToFill) {
        guard let url = URL(string: urlStr) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
