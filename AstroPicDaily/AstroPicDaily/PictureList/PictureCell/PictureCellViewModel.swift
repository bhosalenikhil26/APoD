//
//  PictureCellViewModel.swift
//  AstroPicDaily
//
//  Created by Nikhil Bhosale on 2024-05-12.
//

import UIKit

protocol PictureCellViewModelProtocol: ObservableObject {
    var title: String { get }
    var date: String { get }
    var image: UIImage? { get }
}

final class PictureCellViewModel {
    @Published var image: UIImage?

    private let picture: AstroPic
    private let imageDownloaderService: ImageDownloaderServiceProtocol

    init(picture: AstroPic, imageDownloaderService: ImageDownloaderServiceProtocol) {
        self.picture = picture
        self.imageDownloaderService = imageDownloaderService
        Task {
            await fetchImage()
        }
    }
}

extension PictureCellViewModel: PictureCellViewModelProtocol {
    var title: String {
        picture.title
    }
    
    var date: String {
        picture.date
    }
}

private extension PictureCellViewModel {
    @MainActor func fetchImage() async {
        guard picture.isImageTypeMedia else { return }
        guard let uiImage = await imageDownloaderService.getImage(with: picture.url) else {
            print("Unable to fetch image") //Log remote error
            image = UIImage(named: "image-placeholder")
            return
        }
        image = uiImage
    }
}
