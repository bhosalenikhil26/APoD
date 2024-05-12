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
    private let pictureLoaderService: PictureLoaderServiceProtocol

    init(astroPic: AstroPic, pictureLoaderService: PictureLoaderServiceProtocol) {
        self.astroPic = astroPic
        self.pictureLoaderService = pictureLoaderService
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
    func fetchImage() async {
        guard let uiImage = await pictureLoaderService.getImage(with: astroPic.url) else { return }
        image = uiImage
    }
}
