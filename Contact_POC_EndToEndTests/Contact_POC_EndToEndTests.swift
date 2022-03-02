//
//  Contact_POC_EndToEndTests.swift
//  Contact_POC_EndToEndTests
//
//  Created by Khang Vu on 2/28/22.
//

import XCTest
import Contact_POC

class Contact_POC_EndToEndTests: XCTestCase {

    func test_endToEndRetrieveData_matchesFixedTestDataSuccess() {
        let resourceFileName = "MOCK_DATA"
        let receivedContacts = getLocalContacts(resourceName: resourceFileName, quantity: 2)

        switch receivedContacts {
        case let .success(items)?:
            XCTAssertEqual(items.count, 2)

            XCTAssertEqual(items[0], json_samples(resourceFileName)[0])
            XCTAssertEqual(items[1], json_samples(resourceFileName)[1])

        case let .failure(error)?:
            XCTFail("Expected Success result, but got \(error) instead")

        default:
            XCTFail("Expected Success result, but got no instead")
        }
    }

    func test_endToEndRetrieveData_matchesFixedTestDataFailure() {
        let receivedContacts = getLocalContacts(resourceName: "MOCK_DATA", quantity: -1)

        switch receivedContacts {
        case let .success(items)?:
            XCTFail("Expected Failure result, but got \(items) instead")

        case let .failure(error)?:
            let expectedError = LocalContactLoader.Error.invalidQuantity
            XCTAssertEqual(error as NSError, expectedError as NSError)

        default:
            XCTFail("Expected Failure result, but got no result instead")
        }
    }
    
    func test_endToEndRetrieveData_withEmptySamples() {
        let resourceFileName = "INVALID_DATA"
        let receivedContacts = getLocalContacts(resourceName: resourceFileName, quantity: 2)

        switch receivedContacts {
        case let .success(items)?:
            XCTFail("Expected Failure result, but got success with \(items) instead")

        case let .failure(error)?:
            let expectedError = LocalContactLoader.Error.empty
            XCTAssertEqual(error as NSError, expectedError as NSError)

        default:
            XCTFail("Expected Failure result, but got no result instead")
        }
    }

    func test_endToEndRetrieveData_withCorruptedFormat() {
        let resourceFileName = "CORRUPTED_DATA"
        let receivedContacts = getLocalContacts(resourceName: resourceFileName, quantity: 2)

        switch receivedContacts {
        case let .success(items)?:
            XCTFail("Expected Failure result, but got success with \(items) instead")

        case let .failure(error)?:
            let expectedError = LocalContactLoader.Error.invalidFormat
            XCTAssertEqual(error as NSError, expectedError as NSError)

        default:
            XCTFail("Expected Failure result, but got no result instead")
        }
    }
    
    // MARK: - Helpers

    private func getLocalContacts(resourceName: String = "", quantity: Int) -> LoadContactResult? {
        let client = LocalStorage(resourceFileName: resourceName)
        let loader = LocalContactLoader(with: client)
        
        trackForMemoryLeaks(client)
        trackForMemoryLeaks(loader)

        let exp = expectation(description: "Wait for retrieving")
        var receivedContacts: LoadContactResult?

        loader.load(withQuantity: quantity) { result in
            receivedContacts = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)

        return receivedContacts
    }
    
    // MARK: - Mock JSON samples
    
    private let json_samples: (String) -> [ContactItem] = { fileName in
        guard let urlPath = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            return []
        }
        
        guard
            let objectData = try? Data(contentsOf: urlPath),
            let contacts = try? JSONDecoder().decode([ContactItem].self, from: objectData)
        else { return [] }
        
        return contacts
    }
    
    // MARK: - Mocking for contacts testing

    private let mockContacts: (Int) -> [ContactItem] = { quantity in
        var contacts: [ContactItem] = []
        
        for id in 1...quantity {
            let item = ContactItem.data(id)
            contacts.append(item)
        }
        return contacts
    }
}
