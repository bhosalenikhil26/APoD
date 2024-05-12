//
//  ContentView.swift
//  AstroPicDaily
//
//  Created by Nikhil Bhosale on 2024-05-11.
//

import SwiftUI

struct AopdListView<ViewModel: AopdListViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

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
                    Text(picture.title)
                        .onTapGesture {
                            Task {
                                await viewModel.didSelectPicture(picture)
                            }
                        }
                }
            }
        }
        .alert("Something went wrong, try again in a moment.", isPresented: $viewModel.showAlert) {
            Button("Okay", role: .cancel) {}
        }
        .onAppear {
            Task {
                await viewModel.viewAppeared()
            }
        }
        .sheet(isPresented: $viewModel.shouldShowPictureDetails) {
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
            url: "url")
    ]
    var loadingState: LoadingState = .loaded
    var showAlert: Bool = false
    var shouldShowPictureDetails: Bool = false
    var pictureDetailsViewModel: PictureDetailsViewModel? = nil

    func viewAppeared() async {}
    func didTapRetry() async {}
    func didSelectPicture(_ picture: AstroPic) async {}
}
