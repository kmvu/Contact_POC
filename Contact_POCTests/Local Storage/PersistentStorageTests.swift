//
//  PersistentStorageTests.swift
//  Contact_POCTests
//
//  Created by Khang Vu on 27/02/2022.
//

import XCTest
import Contact_POC

class StorageTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override class func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Helpers

    private func makeSUT() -> PersistentStorage {
        let sut = StorageStub()
    }

    private class StorageStub: PersistentStorage {
        private struct Stub {
            let data: ContactItem?
            let error: Error?
        }
        private var stub: Stub?
        private var requestObserver: ((Int) -> Void)?

        func stub(data: ContactItem?, error: Error?) {
            stub = Stub(data: data, error: error)
        }

        func retrieve(quantity: Int,
                      completion: @escaping (Result<[ContactItem], Error>) -> Void) {
            requestObserver?(quantity)
        }
    }
}
