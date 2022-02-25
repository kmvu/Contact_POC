//
//  LocalContactLoaderTests.swift
//  Contact_POCTests
//
//  Created by Khang Vu on 23/02/2022.
//

import XCTest
import Contact_POC

class LocalContactLoaderTests: XCTestCase {
    
    func test_load_sendExactQuantityNumber() {
        let expectedQuantity = 1
        
        let (sut, spy) = makeSUT(quantity: expectedQuantity)
        sut.load { _ in }
        
        XCTAssertEqual(spy.quantity, expectedQuantity)
    }
    
    func test_load_returnsEmptyData() {
        let (sut, spy) = makeSUT()
        sut.load { result in
            switch result {
            case .success(let items):
                XCTAssertEqual(items.count, 0)
                
            case .failure:
                XCTFail("Should not happen. Expected items to have 0 values returned.")
            }
        }
        spy.complete(withContacts: [])
    }
    
    // MARK: Failure cases
    
    func test_load_deliversErrorOnSpyUnkownError() {
        // Given
        let expectedResult = failure(LocalContactLoader.Error.unkown)

        // When
        let (sut, spy) = makeSUT()
        
        // Then
        expect(sut, toCompleteWith: expectedResult, when: {
            let error = NSError(domain: "UnkownSpy", code: 0)
            spy.complete(withError: error)
        })
    }
    
    func test_load_deliversErrorOnSpyInvalidQuantityError() {
        let expectedResult = failure(LocalContactLoader.Error.invalidQuantity)

        let (sut, spy) = makeSUT()
        
        expect(sut, toCompleteWith: expectedResult, when: {
            let error = LocalContactLoader.Error.invalidQuantity as NSError
            spy.complete(withError: error)
        })
    }
    
    // MARK: Success cases
    
    func test_load_succeedsOnLoadingAnyContacts() {
        // Given
        let expectedQuantity = 10
        let expectedValue = mockContacts(expectedQuantity)
        let expectedResult = success(expectedValue)
        
        // When
        let (sut, spy) = makeSUT(quantity: expectedQuantity)
        
        // Then
        expect(sut, toCompleteWith: expectedResult, when: {
            spy.complete(withContacts: expectedValue)
        })
    }
    
    // MARK: - Mocks
    
    private var mockContacts: ((Int) -> [ContactItem]) = { quantity in
        return Array(repeating: .data, count: quantity)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(quantity: Int = 0) -> (LocalContactLoader, StorageSpy) {
        let spy = StorageSpy()
        let sut = LocalContactLoader(with: spy, quantity: quantity)
        
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(spy)
        
        return (sut, spy)
    }
    
    private func expect(_ sut: LocalContactLoader,
                        toCompleteWith expectedResult: LocalContactLoader.Result,
                        when action: () -> Void) {
        let exp = expectation(description: "Wait for completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(items), .success(expectedItems)):
                XCTAssertEqual(items, expectedItems)
                
            case let(.failure(receivedError as NSError),
                     .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError)
                
            default:
                XCTFail("Expected \(expectedResult), but got \(receivedResult) instead")
            }
            exp.fulfill()
        }
        action()

        wait(for: [exp], timeout: 1.0)
    }
    
    private func success(_ value: [ContactItem]) -> LocalContactLoader.Result {
        return .success(value)
    }
    
    private func failure(_ error: LocalContactLoader.Error) -> LocalContactLoader.Result {
        return .failure(error)
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
        
        func complete(withContacts contactItems: [ContactItem],
                      at index: Int = 0) {
            handlers[index](.success(contactItems))
        }
        
        func complete(withError error: Error, at index: Int = 0) {
            handlers[index](.failure(error))
        }
    }
}
