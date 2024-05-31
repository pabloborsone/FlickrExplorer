//
//  FlickrExplorerApp.swift
//  FlickrExplorer
//
//  Created by Pablo Borsone on 31/05/24.
//

import SwiftUI

@main
struct FlickrExplorerApp: App {
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return decoder
    }()

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YYYY"

        return formatter
    }()

    var body: some Scene {
        WindowGroup {
            HomeSearchView(viewModel: .init(service: FlickrFeedService(decoder: decoder), dateFormatter: dateFormatter))
        }
    }
}
