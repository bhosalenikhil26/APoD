//
//  ContentView.swift
//  AstroPicDaily
//
//  Created by Nikhil Bhosale on 2024-05-11.
//

import SwiftUI

struct AopdListView<ViewModel: AopdListViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @State var shouldShowPictureDetails: Bool = false

    var body: some View {
        ZStack {
            switch viewModel.loadingState {
            case .initial:
                Button("Load Pictures") {
                    Task {
                        await viewModel.didTapRetry()
                    }
                }
            case .loading:
                ActivityIndicator()
            case .loaded:
                List(viewModel.astronomyPics, id: \.self) { picture in
                    PictureCellView(viewModel: viewModel.getPictureCellViewModel(for: picture))
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            Task {
                                await viewModel.didSelectPicture(picture)
                                shouldShowPictureDetails = true
                            }
                        }
                }
                .listStyle(.plain)
            }
        }
        .alert("Something went wrong, try again in a moment.", isPresented: $viewModel.showAlert) {
            Button("Okay", role: .cancel) {}
        }
        .sheet(isPresented: $shouldShowPictureDetails) {
            if let detailsViewModel = viewModel.pictureDetailsViewModel {
              PictureDetailsView(viewModel: detailsViewModel)
            } else {
                EmptyView()
            }
        }
    }
}

#Preview {
    AopdListView(viewModel: MockAopdListViewModel())
}

final class MockAopdListViewModel: AopdListViewModelProtocol {
    var astronomyPics: [AstroPic] = [
        AstroPic(
            copyright: nil,
            date: "date",
            explanation: "explanation",
            hdurl: "hdurl",
            title: "title",
            url: "url",
            mediaType: "image")
    ]
    var loadingState: LoadingState = .loaded
    var showAlert: Bool = false
    var pictureDetailsViewModel: PictureDetailsViewModel? = nil

    func viewAppeared() async {}
    func didTapRetry() async {}
    func didSelectPicture(_ picture: AstroPic) async {}
    func getPictureCellViewModel(for picture: AstroPic) -> PictureCellViewModel {
        PictureCellViewModel(picture: picture, imageDownloaderService: MockDownloaderService())
    }
}

final class MockDownloaderService: ImageDownloaderServiceProtocol {
    func getImage(with url: String) async -> UIImage? {
        UIImage(named: "image-placeholder")
    }
}
