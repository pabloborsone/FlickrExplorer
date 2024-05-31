//
//  HomeSearchViewModel.swift
//  FlickrExplorer
//
//  Created by Pablo Borsone on 31/05/24.
//

import Combine
import Foundation

@MainActor
final class HomeSearchViewModel: ObservableObject {
    @Published var searchQuery = ""
    @Published var items = [HomeItem]()

    private var cancellables: Set<AnyCancellable>
    private let dateFormatter: DateFormatter
    private let debounceTime: TimeInterval

    private let service: APIService

    init(service: APIService,
         dateFormatter: DateFormatter,
         cancellables: Set<AnyCancellable> = Set<AnyCancellable>(),
         debounceTime: TimeInterval = 0.5) {
        self.service = service
        self.dateFormatter = dateFormatter
        self.cancellables = cancellables
        self.debounceTime = debounceTime

        setUpQuery()
    }

    private func setUpQuery() {
        $searchQuery
            .debounce(for: .seconds(debounceTime), scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { [weak self] tag -> AnyPublisher<[HomeItem], Never> in
                guard let self = self else {
                    return Just([]).eraseToAnyPublisher()
                }
                return self.fetchItems(for: tag)
                    .replaceError(with: [])
                    .eraseToAnyPublisher()
            }
            .receive(on: RunLoop.main)
            .assign(to: &$items)
    }

    private func fetchItems(for tag: String) -> Future<[HomeItem], Error> {
        Future { promise in
            Task {
                do {
                    let fetchedItems = try await self.service.fetch(tag: tag)
                    let homeItems = fetchedItems.map { HomeItem(flickrItem: $0, dateFormatter: self.dateFormatter) }
                    promise(.success(homeItems))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
}
