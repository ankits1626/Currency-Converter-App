//
//  PPCCurrencyListViewControllerTests.swift
//  PayPayCurrencyConverterTests
//
//  Created by Ankit on 30/07/22.
//

import XCTest
@testable import PayPayCurrencyConverter

class PPCCurrencyListViewControllerTests: XCTestCase {
    
    var sut: PPCCurrencyListViewController!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = PPCCurrencyListViewController()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }
}

extension PPCCurrencyListViewControllerTests{
    
    func testThatCurrencyListShouldPassSelectedCurrencyToLstener() {
        //given
        let dummyCurrency = PPCAvailableCurrency(currencyCode: "JPY", currencyName: "Japanese Yen")
        sut.currencySelectionCompletionBlock = { selectedCurrency in
            //then
            XCTAssertTrue(
                dummyCurrency.presentationCurrencyCode == selectedCurrency.presentationCurrencyCode,
                "Receiver should receive the same currency as selected in currency list"
            )
        }
        //when
        sut.passSelectedCurrencyToListener(dummyCurrency)
        
    }
}
