//
//  XCTestCase+MemoryLeaksTracking.swift
//  Contact_POCTests
//
//  Created by Khang Vu on 24/02/2022.
//

import Foundation
import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject,
                             file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should be deallocated, potential memory leaks.",
                         file: file, line: line)
        }
    }
}
