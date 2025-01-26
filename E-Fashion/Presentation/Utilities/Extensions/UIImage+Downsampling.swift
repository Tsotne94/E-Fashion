//
//  UIImage+Downsampling.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 24.01.25.
//

import UIKit

extension UIImage {
    func downsample(to size: CGSize, scale: CGFloat = UIScreen.main.scale, compressionQuality: CGFloat = 0.5) -> UIImage? {
        var resultImage: UIImage?
        let semaphore = DispatchSemaphore(value: 0)

        DispatchQueue.global(qos: .userInitiated).async {
            guard let imageData = self.jpegData(compressionQuality: compressionQuality) else {
                semaphore.signal()
                return
            }

            let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
            let maxDimensionInPixels = max(size.width, size.height) * scale

            guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, imageSourceOptions) else {
                semaphore.signal()
                return
            }

            let downscaledOptions = [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
            ] as CFDictionary

            guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downscaledOptions) else {
                semaphore.signal()
                return
            }

            resultImage = UIImage(cgImage: downsampledImage, scale: scale, orientation: .up)
            semaphore.signal()
        }

        semaphore.wait()
        return resultImage
    }
}
