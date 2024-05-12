//
//  PictureCellView.swift
//  AstroPicDaily
//
//  Created by Nikhil Bhosale on 2024-05-12.
//

import SwiftUI

struct PictureCellView<ViewModel: PictureCellViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        ZStack {
            if let uiImage = viewModel.image {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(height: 300)
                    .scaledToFit()
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20)
                    )
                    .clipped()
            } else {
                ActivityIndicator()
                    .frame(height: 300)
            }
            VStack {
                Spacer()
                HStack {
                    VStack(alignment: .leading, spacing: 7) {
                        Text("Picture of the day")
                            .bold()
                        Text(viewModel.title)
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
                    Spacer()
                    Text(viewModel.date)
                        .bold()
                }
                .font(.callout)
                .padding()
            }
        }
        .frame(maxWidth: .infinity)
        .foregroundStyle(.white)
    }
}

#Preview {
    PictureCellView(viewModel: PictureCellViewModel(picture: AstroPic(
        copyright: nil,
        date: "date",
        explanation: "explanation",
        hdurl: "hdurl",
        title: "title",
        url: "url",
        mediaType: "image"),
                                                    imageDownloaderService: MockDownloaderService()))
}
