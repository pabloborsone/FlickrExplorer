//
//  APIService.swift
//  FlickrExplorer
//
//  Created by Pablo Borsone on 31/05/24.
//

import Foundation

protocol APIService {
    func fetch(tag: String) async throws -> [FlickrItem]
}
