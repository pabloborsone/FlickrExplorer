//
//  FlickrImage.swift
//  FlickrExplorer
//
//  Created by Pablo Borsone on 31/05/24.
//

import Foundation

struct FlickrFeed: Codable {
    let title: String
    let link: URL
    let description: String
    let modified: String
    let generator: URL
    let items: [FlickrItem]
}

struct FlickrItem: Codable {
    let title: String
    let link: URL
    let media: Media
    let dateTaken: String
    let description: String
    let published: String
    let author: String
    let authorID: String
    let tags: String

    enum CodingKeys: String, CodingKey {
        case title
        case link
        case media
        case dateTaken = "date_taken"
        case description
        case published
        case author
        case authorID = "author_id"
        case tags
    }
}

struct Media: Codable {
    let m: URL
}
