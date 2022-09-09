//
//  XCTTestCase+Helpers.swift
//  ImageryFeed
//
//  Created by Kumar, Sawant on 08/09/22.
//

import XCTest

extension XCTestCase {

    func trackForMemoryLeak(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }

}
