//
//  AopdListViewModel.swift
//  AstroPicDaily
//
//  Created by Nikhil Bhosale on 2024-05-11.
//

import Foundation

protocol AopdListViewModelProtocol: ObservableObject {
    var loadingState: LoadingState { get }
    var showAlert: Bool { get set }
    var pictureDetailsViewModel: PictureDetailsViewModel? { get }

    func didSelectPicture(_ picture: AstroPic) async
    func didTapRetry() async
    func getPictureCellViewModel(for picture: AstroPic) -> PictureCellViewModel
}

final class AopdListViewModel {
    @Published var loadingState: LoadingState = .initial
    @Published var showAlert = false

    var pictureDetailsViewModel: PictureDetailsViewModel?

    private var astronomyPics: [AstroPic] = []
    private let pictureLoaderService: PictureLoaderServiceProtocol & ImageDownloaderServiceProtocol

    init(pictureLoaderService: PictureLoaderServiceProtocol & ImageDownloaderServiceProtocol) {
        self.pictureLoaderService = pictureLoaderService
        Task {
            await loadPictures()
        }
    }
}

extension AopdListViewModel: AopdListViewModelProtocol {
    func didTapRetry() async {
        await loadPictures()
    }

    func didSelectPicture(_ picture: AstroPic) async {
        pictureDetailsViewModel = PictureDetailsViewModel(astroPic: picture, pictureLoaderService: pictureLoaderService)
    }

    func getPictureCellViewModel(for picture: AstroPic) -> PictureCellViewModel {
        PictureCellViewModel.init(picture: picture,
                                  imageDownloaderService: pictureLoaderService)
    }
}

private extension AopdListViewModel {
    @MainActor func updateState(_ state: LoadingState) async {
        loadingState = state
    }

    @MainActor func showAlert(_ shouldShow: Bool) async {
        showAlert = shouldShow
    }

    @MainActor func updatePictures(_ pictures: [AstroPic]) async {
        self.astronomyPics = pictures
    }

    func loadPictures() async {
        await updateState(.loading)
        do {
            let pictures = try await pictureLoaderService.loadLastAstroPictures(numberOfDays: 6)
            guard !pictures.isEmpty else {
                return await handleEmtyPicturesState()
            }
            await updatePictures(pictures)
            await updateState(.loaded(astronomyPics: pictures))
        } catch {
            print("Error while loading Pictures", error) //Log remote error
            await handleEmtyPicturesState()
        }
    }

    func handleEmtyPicturesState() async {
        await showAlert(true)
        await updateState(.initial)
    }
}

enum LoadingState {
    case initial
    case loading
    case loaded(astronomyPics: [AstroPic])
}

