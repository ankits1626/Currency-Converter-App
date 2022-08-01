//
//  XCTestCase+extension.swift
//  PayPayCurrencyConverterTests
//
//  Created by Ankit on 30/07/22.
//

import XCTest

extension XCTestCase{
    func executeTestCaseAsynchronously(expectationMessage: String,  assertExpression: Bool, testFailureMessageMessage: String, waitTime: TimeInterval = 2.0){
        let expectation =  expectation(description: expectationMessage)
        XCTAssertTrue(assertExpression, testFailureMessageMessage)
        print("<<<<<< executeTestCaseAsynhronously called")
        expectation.fulfill()
        wait(for: [expectation], timeout: waitTime)
    }
}
