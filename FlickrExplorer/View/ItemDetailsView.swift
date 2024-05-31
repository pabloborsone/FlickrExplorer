//
//  ItemDetailsView.swift
//  FlickrExplorer
//
//  Created by Pablo Borsone on 31/05/24.
//

import SwiftUI

struct ItemDetailsView: View {
    @Environment(\.dismiss) var dismiss

    private let item: HomeItem

    init(item: HomeItem) {
        self.item = item
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            AsyncImage(url: item.thumbnailURL) { imagePhase in
                switch imagePhase {
                case .empty:
                    Text("Empty")
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                case .failure:
                    ProgressView()
                @unknown default:
                    ProgressView()
                }
            }
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading) {
                    HeadlineText("Title")
                    CaptionText(item.title)
                }
                VStack(alignment: .leading) {
                    HeadlineText("Description")
                    CaptionText(item.description)
                }
                VStack(alignment: .leading) {
                    HeadlineText("Author")
                    CaptionText(item.author)
                }
                VStack(alignment: .leading) {
                    HeadlineText("Published Date")
                    CaptionText(item.publishedDate)
                }
            }
            .padding()
        }
    }
}

// If there's enough time, create a parent component to hold both texts
private struct HeadlineText: View {
    private let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.headline)
    }
}

private struct CaptionText: View {
    private let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.caption)
    }
}

#Preview {
    ItemDetailsView(item: .init(title: "Random title",
                                thumbnailURL: .init(string: "https://www.flickr.com/photos/200492195@N07/53760263509/")!,
                                description: "Random description",
                                publishedDate: "05/31/2024",
                                author: "Pablo Borsone"))
}
