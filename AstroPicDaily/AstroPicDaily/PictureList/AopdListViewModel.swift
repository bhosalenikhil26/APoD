//
//  AopdListViewModel.swift
//  AstroPicDaily
//
//  Created by Nikhil Bhosale on 2024-05-11.
//

import Foundation

protocol AopdListViewModelProtocol: ObservableObject {
    var astronomyPics: [AstroPic] { get }
    var loadingState: LoadingState { get }
    var showAlert: Bool { get set }
    var shouldShowPictureDetails: Bool { get set }

    func viewAppeared() async
    func didSelectPicture(_ picture: AstroPic) async
    func didTapRetry() async
}

final class AopdListViewModel {
    @Published var astronomyPics: [AstroPic] = []
    @Published var loadingState: LoadingState = .initial
    @Published var showAlert = false
    @Published var shouldShowPictureDetails = false

    private let pictureLoaderService: PictureLoaderServiceProtocol

    init(pictureLoaderService: PictureLoaderServiceProtocol) {
        self.pictureLoaderService = pictureLoaderService
    }
}

extension AopdListViewModel: AopdListViewModelProtocol {
    func viewAppeared() async {
        await loadPictures()
    }
    
    func didTapRetry() async {
        await loadPictures()
    }

    func didSelectPicture(_ picture: AstroPic) async {
        print(picture.title)
    }
}

private extension AopdListViewModel {
    @MainActor func updateState(_ state: LoadingState) {
        loadingState = state
    }

    @MainActor func showAlert(_ shouldShow: Bool) {
        showAlert = shouldShow
    }

    @MainActor func updatePictures(_ pictures: [AstroPic]) async {
        self.astronomyPics = pictures
    }

    func loadPictures() async {
        await updateState(.loading)
        do {
            let pictures = try await pictureLoaderService.loadLastAstroPictures(numberOfDays: 6)
            await updatePictures(pictures)
            await updateState(.loaded)
        } catch {
            print("Error while loading countries", error) //Log remote error
            await showAlert(true)
            await updateState(.initial)
        }
    }
}

enum LoadingState {
    case initial
    case loading
    case loaded
}

