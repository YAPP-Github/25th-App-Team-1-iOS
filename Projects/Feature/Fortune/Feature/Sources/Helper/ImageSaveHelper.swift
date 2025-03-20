//
//  ImageSaveHelper.swift
//  Fortune
//
//  Created by choijunios on 3/18/25.
//

import UIKit

final class ImageSaveHelper: NSObject {
    var onError: ((Error) -> Void)?
    var onSuccess: (() -> Void)?
    
    func saveImageToAlbumAndExit(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSavedToAlbum), nil)
    }
    
    @objc private func imageSavedToAlbum(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error {
            onError?(error)
        } else {
            onSuccess?()
        }
    }
}
