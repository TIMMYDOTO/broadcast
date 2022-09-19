//
//  CyberSportIconView.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 28.03.2022.
//

import UIKit
import Kingfisher

class CyberSportIconView: UIView {
    
    private weak var activeIcon: UIImageView!
    private weak var inactiveIcon: UIImageView!
    
    private var downloadTask: DownloadTask?
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(_ model: CSSportInfo, vm: CSInfoVM) {
        if vm.type != nil {
            setImages(vm.icon)
        } else {
            guard let url = URL(string: model.iconPath) else {
                setImages(vm.icon)
                return
            }
            let resource = ImageResource(downloadURL: url)
            self.downloadTask = KingfisherManager.shared.retrieveImage(with: resource) { [weak self] result in
                guard let self = self else { return }
                if case let .success(response) = result {
                    self.setImages(response.image)
                } else {
                    self.setImages(vm.icon)
                }
            }
        }
    }
    
    func clear() {
        downloadTask?.cancel()
        activeIcon.image = nil
        inactiveIcon.image = nil
    }
    
    func active() {
        activeIcon.alpha = 1
    }
    
    func inactive() {
        activeIcon.alpha = 0
    }
    
}

private extension CyberSportIconView {
    func setup() {
        setupInactiveIcon()
        setupActiveIcon()
    }
    
    func setupInactiveIcon() {
        let image = UIImageView()
        
        inactiveIcon = image
        addSubview(inactiveIcon)
        inactiveIcon.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.width.equalTo(28)
        }
    }
    
    func setupActiveIcon() {
        let image = UIImageView()
        image.alpha = 0
        
        activeIcon = image
        addSubview(activeIcon)
        activeIcon.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.width.equalTo(28)
        }
    }
    
    func setImages(_ model: UIImage) {
        activeIcon.image = model
        inactiveIcon.image = model.tonal
    }
}

extension UIImage {
    var tonal: UIImage? {
        let context = CIContext(options: nil)
        guard let currentFilter = CIFilter(name: "CIPhotoEffectTonal") else { return nil }
        currentFilter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        if let output = currentFilter.outputImage,
            let cgImage = context.createCGImage(output, from: output.extent) {
            return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
        }
        return nil
    }
}
