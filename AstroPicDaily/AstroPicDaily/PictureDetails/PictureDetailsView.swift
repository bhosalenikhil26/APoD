//
//  PictureDetailsView.swift
//  AstroPicDaily
//
//  Created by Nikhil Bhosale on 2024-05-12.
//

import SwiftUI

struct PictureDetailsView<ViewModel: PictureDetailsViewModelProtocol>: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        ScrollView {
            VStack {
                closeButton
                if let image = viewModel.image {
                    pictureView(image)
                }
                getTextContainerView()
                Spacer()
            }
        }
        .onAppear {
            Task {
                await viewModel.viewAppeared()
            }
        }
    }
}

private extension PictureDetailsView {
    var closeButton: some View {
        HStack {
            Spacer()
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(.close)
            }
        }
        .padding(EdgeInsets(top: 24, leading: 0, bottom: 0, trailing: 24))
    }

    func pictureView(_ image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .background(Color.black)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 7)
            .padding()
    }

    func getTextContainerView() -> some View {
        VStack(alignment: .leading) {
            titleView()
            copyrightAndDateView()
            Divider()
            explainationView()
        }
        .padding()
    }

    func titleView() -> some View {
        Text(viewModel.title)
            .font(.title)
            .padding(.bottom, 5)
    }

    func copyrightAndDateView() -> some View {
        HStack {
            if let copyright = viewModel.copyright {
                Text("Copyright: \(copyright)")
                    .font(.headline)
            }
            Spacer()
            Text(viewModel.date)
                .font(.headline)
        }
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }

    func explainationView() -> some View {
        Text("\(viewModel.explaination)")
            .font(.body)
            .foregroundStyle(.secondary)
            .padding(.bottom, 5)
    }
}

#Preview {
    PictureDetailsView(viewModel: MockDetailsViewModel())
}

final class MockDetailsViewModel: PictureDetailsViewModelProtocol {
    var copyright: String? = "Dennis Huff"
    var date: String = "2024-01-20"
    var image: UIImage? = UIImage(named: "image-placeholder")
    var title: String = "Falcon Heavy Boostback Burn"
    var explaination: String = "The December 28 night launch of a Falcon Heavy rocket from Kennedy Space Center in Florida marked the fifth launch for the rocket's reusable side boosters."

    func viewAppeared() async {}
}
