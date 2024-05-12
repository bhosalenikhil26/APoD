//
//  ContentView.swift
//  AstroPicDaily
//
//  Created by Nikhil Bhosale on 2024-05-11.
//

import SwiftUI

struct AopdListView<ViewModel: AopdListViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @State private var selectedPicture: AstroPic?

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
                Text("Show Loader") //TODO: Show activity indicator
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
    }
}

#Preview {
    AopdListView(viewModel: MockAopdListViewModel())
}

final class MockAopdListViewModel: AopdListViewModelProtocol {
    var astronomyPics: [AstroPic] = []
    var loadingState: LoadingState = .initial
    var showAlert: Bool = false
    var shouldShowPictureDetails: Bool = false

    func viewAppeared() async {}
    func didTapRetry() async {}
    func didSelectPicture(_ picture: AstroPic) async {}
}
