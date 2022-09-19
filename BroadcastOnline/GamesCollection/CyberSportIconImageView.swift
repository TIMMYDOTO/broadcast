//
//  CyberSportIconImageView.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 23.03.2022.
//

import UIKit
import Kingfisher

class CyberSportIconImageView: UIImageView {

    private var downloadTask: DownloadTask?
    
    func setImage(path: String, selected: Bool) {
        guard let url = URL(string: path) else {
            clear()
            return
        }
        let resource = ImageResource(downloadURL: url)
        self.downloadTask = KingfisherManager.shared.retrieveImage(with: resource) { [weak self] result in
            guard let self = self, case let .success(response) = result else { return }
            self.image = selected ? response.image : self.convertToGrayScale(image: response.image)
        }
    }
    
    func clear() {
        downloadTask?.cancel()
        self.image = nil
    }
}

private extension CyberSportIconImageView {
    func convertToGrayScale(image: UIImage) -> UIImage {
        let imageRect:CGRect = CGRect(x:0, y:0, width:image.size.width, height: image.size.height)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let width = image.size.width
        let height = image.size.height
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)

        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        context?.draw(image.cgImage!, in: imageRect)
        let imageRef = context!.makeImage()

        let newImage = UIImage(cgImage: imageRef!)
        return newImage
    }
}
