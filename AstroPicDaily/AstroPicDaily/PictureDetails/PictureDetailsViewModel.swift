//
//  PictureDetailsViewModel.swift
//  AstroPicDaily
//
//  Created by Nikhil Bhosale on 2024-05-12.
//

import UIKit

protocol PictureDetailsViewModelProtocol: ObservableObject {
    var image: UIImage? { get }
    var title: String { get }
    var explaination: String { get }
    var copyright: String? { get }
    var date: String { get }

    func viewAppeared() async
}

final class PictureDetailsViewModel {
    @Published var image: UIImage? = UIImage(named: "image-placeholder")

    private let astroPic: AstroPic
    private let imageDownloaderService: ImageDownloaderServiceProtocol

    init(astroPic: AstroPic, pictureLoaderService: ImageDownloaderServiceProtocol) {
        self.astroPic = astroPic
        self.imageDownloaderService = pictureLoaderService

        Task {
            await fetchImage()
        }
    }
}

extension PictureDetailsViewModel: PictureDetailsViewModelProtocol {    
    var title: String {
        astroPic.title
    }
    
    var explaination: String {
        astroPic.explanation
    }

    var copyright: String? {
        astroPic.copyright
    }

    var date: String {
        astroPic.date
    }

    func viewAppeared() async {
       await fetchImage()
    }
}

private extension PictureDetailsViewModel {
    @MainActor func fetchImage() async {
        guard astroPic.isImageTypeMedia else { return }
        guard let uiImage = await imageDownloaderService.getImage(with: astroPic.hdurl ?? astroPic.url) else {
            print("Unable to fetch image") //Log remote error
            return
       }
        image = uiImage
    }
}
