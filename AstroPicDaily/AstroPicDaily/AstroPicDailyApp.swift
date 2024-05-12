//
//  AstroPicDailyApp.swift
//  AstroPicDaily
//
//  Created by Nikhil Bhosale on 2024-05-11.
//

import SwiftUI

@main
struct AstroPicDailyApp: App {
    var body: some Scene {
        WindowGroup {
            AstroPicListView(viewModel: getAopdListViewModel())
        }
    }

    private func getAopdListViewModel() -> AstroPicListViewModel {
        AstroPicListViewModel(
            pictureLoaderService: PictureLoaderService(
                apiPictureLoaderService: APIPictureLoaderService(),
                imageCache: ImageCache.shared)
        )
    }
}
