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
        let receivedContacts = getLocalContacts(quantity: 2)

        switch receivedContacts {
        case let .success(items)?:
            XCTAssertEqual(items.count, 2)

            XCTAssertEqual(items[0], ContactItem.data(1))
            XCTAssertEqual(items[1], ContactItem.data(2))

        case let .failure(error)?:
            XCTFail("Expected Success result, but got \(error) instead")

        default:
            XCTFail("Expected Success result, but got no instead")
        }
    }

    func test_endToEndRetrieveData_matchesFixedTestDataFailure() {
        let receivedContacts = getLocalContacts(quantity: -1)

        switch receivedContacts {
        case let .success(items)?:
            XCTFail("Expected Failure result, but got \(items) instead")

        case let .failure(error)?:
            let expectedError = LocalContactLoader.Error.invalidQuantity
            XCTAssertEqual(error as NSError, expectedError as NSError)

        default:
            XCTFail("Expected Success result, but got no instead")
        }
    }

    // MARK: - Helpers

    private func getLocalContacts(quantity: Int) -> LoadContactResult? {
        let client = LocalStorage()
        let loader = LocalContactLoader(with: client, quantity: quantity)

        trackForMemoryLeaks(client)
        trackForMemoryLeaks(loader)

        let exp = expectation(description: "Wait for retrieving")
        var receivedContacts: LoadContactResult?

        loader.load { result in
            receivedContacts = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)

        return receivedContacts
    }
}
