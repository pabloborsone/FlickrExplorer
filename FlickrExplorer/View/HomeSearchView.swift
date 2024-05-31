//
//  HomeSearchView.swift
//  FlickrExplorer
//
//  Created by Pablo Borsone on 31/05/24.
//

import SwiftUI

struct HomeSearchView: View {
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    @StateObject private var viewModel: HomeSearchViewModel
    @State private var showingSheet = false
    @State private var selectedItem: HomeItem?

    init(viewModel: HomeSearchViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach($viewModel.items) { $item in
                        HStack {
                            AsyncImage(url: item.thumbnailURL) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                case .failure:
                                    VStack {
                                        Image(systemName: "x.circle")
                                        Text("Oops, something went wrong while loading this image ):")
                                    }
                                case .empty:
                                    ProgressView()
                                @unknown default:
                                    ProgressView()
                                }
                            }
                            .onTapGesture {
                                selectedItem = item
                                showingSheet = true
                            }
                        }
                    }
                    .sheet(item: $selectedItem, onDismiss: dismiss) { item in
                        ItemDetailsView(item: item)
                    }
                }
                .padding()
            }
        }
        .searchable(text: $viewModel.searchQuery)
        .textInputAutocapitalization(.never)
    }

    private func dismiss() {
        showingSheet = false
    }
}

#Preview {
    HomeSearchView(viewModel: .init(service: FlickrFeedService(decoder: .init()),
                                    dateFormatter: .init()))
}
