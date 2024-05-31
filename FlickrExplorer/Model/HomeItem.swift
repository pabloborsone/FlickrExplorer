//
//  HomeItem.swift
//  FlickrExplorer
//
//  Created by Pablo Borsone on 31/05/24.
//

import Foundation

/// This view model should be consumed by the views, rather than the backend model directly
struct HomeItem: Identifiable {
    let id = UUID()
    let title: String
    let thumbnailURL: URL
    let description: String
    let publishedDate: String
    let author: String

    init(title: String, thumbnailURL: URL, description: String, publishedDate: String, author: String) {
        self.title = title
        self.thumbnailURL = thumbnailURL
        self.description = description
        self.publishedDate = publishedDate
        self.author = author
    }

    init(flickrItem: FlickrItem, dateFormatter: DateFormatter) {
        self.title = flickrItem.title
        self.thumbnailURL = flickrItem.media.m
        self.description = flickrItem.description
        self.publishedDate = dateFormatter.string(from: flickrItem.published)
        self.author = flickrItem.author
    }
}
