//
//  LocalContactLoaderTests.swift
//  Contact_POCTests
//
//  Created by Khang Vu on 23/02/2022.
//

import XCTest
import Contact_POC

class LocalContactLoaderTests: XCTestCase {
    
    func test_load_sendSpecificQuantityNumber() {
        let expectedQuantity = 1
        let (sut, client) = makeSUT(quantity: expectedQuantity)
        
        sut.load { _ in }
        
        XCTAssertEqual(client.quantity, expectedQuantity)
    }
    
    func test_load_returnsEmptyData() {
        let quantity = 10
        let (sut, client) = makeSUT(quantity: quantity)
        
        sut.load { result in
            switch result {
            case .success(let items):
                XCTAssertEqual(items.count, 0)
                
            case .failure:
                XCTFail("Should not happen. Expected items to have 0 values returned.")
            }
        }
        client.complete(with: [])
    }
    
    func test_loadTwice_retrieveDataTwiceFromStorage() {
    }
    
    // MARK: - Helpers
    
    private func makeSUT(quantity: Int = 0,
                         file: StaticString = #filePath, line: UInt = #line) -> (LocalContactLoader, StorageSpy) {
        let client = StorageSpy()
        let sut = LocalContactLoader(with: client, quantity: quantity)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        
        return (sut, client)
    }
    
    private class StorageSpy: PersistentStorage {
        typealias ResponseHandler = (Result<[ContactItem], Error>) -> Void
        private var handlers = [ResponseHandler]()
        
        var quantity: Int!
        
        func retrieve(quantity: Int,
                      completion: @escaping (Result<[ContactItem], Error>) -> Void) {
            self.quantity = quantity
            handlers.append(completion)
        }
        
        func complete(with contactItem: [ContactItem],
                      at index: Int = 0) {
            handlers[index](.success(contactItem))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            handlers[index](.failure(error))
        }
    }
}

