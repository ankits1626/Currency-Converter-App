//
//  PPCCurrencyConverterMainViewControllerTests.swift
//  PayPayCurrencyConverterTests
//
//  Created by Ankit on 30/07/22.
//

import XCTest
@testable import PayPayCurrencyConverter

class PPCCurrencyConverterMainViewControllerTests: XCTestCase {
    
    var sut: PPCCurrencyConverterMainViewController!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = PPCCurrencyConverterMainViewController()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }
    
}

extension PPCCurrencyConverterMainViewControllerTests{
    
    func testThatDataManagerShouldNotBeCalledToFetchConvertedValuesWhenAmountIsZeroAndBaseCurrencyIsSelected() {
        //given
        sut.amountEntered = 0
        sut.baseCurrency = PPCAvailableCurrency(currencyCode: "USD", currencyName: "US Dollars")
        let mockDataManager = MockDataManager()
        sut.dataManager = mockDataManager
        //when
        sut.askDataManagerToConversion()
        //then
        XCTAssertFalse(mockDataManager.isCalledForConversion, "Data Manager should not be called for conversion")
    }
    
    func testThatDataManagerShouldNotBeCalledToFetchConvertedValuesWhenAmountIsGreaterThanZeroAndBaseCurrencyIsNotSelected() {
        //given
        sut.amountEntered = 10
        
        let mockDataManager = MockDataManager()
        sut.dataManager = mockDataManager
        //when
        sut.askDataManagerToConversion()
        //then
        XCTAssertFalse(mockDataManager.isCalledForConversion, "Data Manager should not be called for conversion")
    }
    
    func testThatDataManagerShouldBeCalledToFetchConvertedValuesWhenAmountIsGreaterThanZeroAndBaseCurrencyIsSelected() {
        //given
        sut.amountEntered = 10
        sut.baseCurrency = PPCAvailableCurrency(currencyCode: "USD", currencyName: "US Dollars")
        let mockDataManager = MockDataManager()
        sut.dataManager = mockDataManager
        let mockResultDisplayer = MockConversionResultDisplayer()
        sut.conversionResultDisplayer = mockResultDisplayer
        //when
        sut.askDataManagerToConversion()
        //then
        XCTAssertTrue(mockDataManager.isCalledForConversion, "Data Manager should be called for conversion")
    }
}


extension PPCCurrencyConverterMainViewControllerTests{
    
    func testThatMainViewShouldShowErrorIfConversionResultHasError() {
        //given
        sut.amountEntered = 10
        sut.baseCurrency = PPCAvailableCurrency(currencyCode: "USD", currencyName: "US Dollars")
        
        let mockResultDisplayer = MockConversionResultDisplayer()
        sut.conversionResultDisplayer = mockResultDisplayer
        
        let mockDataManager = MockDataManager()
        mockDataManager.shouldReturnErrorAfterConversion = true
        sut.dataManager = mockDataManager
        
        let mockErrorDisplayer = MockErrorDisplayer()
        sut.errorDisplayer = mockErrorDisplayer
        //when
        let expectation =  expectation(description: "Should wait for data manager to execute completion callback")
        mockDataManager.getConversion(
            amount: 10,
            baseCurrency: MockDataProvider.getDummyCurrency()) { result in
                sut.handleConversionResult(result)
                //then
                XCTAssertTrue(mockErrorDisplayer.isDisplayErrorCalled, "Error displayer should be asked to display the error")
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 1.0)
        
    }
    
    func testThatMainViewShouldShowErrorIfConversionResultIsEmpty() {
        //given
        sut.amountEntered = 10
        sut.baseCurrency = PPCAvailableCurrency(currencyCode: "USD", currencyName: "US Dollars")
        let mockResultDisplayer = MockConversionResultDisplayer()
        sut.conversionResultDisplayer = mockResultDisplayer
        let mockDataManager = MockDataManager()
        mockDataManager.shouldReturnEmptyAfterConversion = true
        sut.dataManager = mockDataManager
        
        let mockErrorDisplayer = MockErrorDisplayer()
        sut.errorDisplayer = mockErrorDisplayer
        //when
        let expectation =  expectation(description: "Should wait for data manager to execute completion callback")
        mockDataManager.getConversion(
            amount: 10,
            baseCurrency: MockDataProvider.getDummyCurrency()) { result in
                sut.handleConversionResult(result)
                //then
                XCTAssertTrue(mockErrorDisplayer.isDisplayErrorCalled, "Error displayer should be asked to display the error")
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testThatManinViewShouldAskConversionResultDisplayerToShowResultIfConversionWasSuccessful() {
        //given
        sut.amountEntered = 10
        sut.baseCurrency = PPCAvailableCurrency(currencyCode: "USD", currencyName: "US Dollars")
        let mockResultDisplayer = MockConversionResultDisplayer()
        sut.conversionResultDisplayer = mockResultDisplayer
        let mockDataManager = MockDataManager()
        sut.dataManager = mockDataManager
        //when
        let expectation =  expectation(description: "Should wait for data manager to execute completion callback")
        mockDataManager.getConversion(
            amount: 10,
            baseCurrency: MockDataProvider.getDummyCurrency()) { result in
                sut.handleConversionResult(result)
                //then
                XCTAssertNotNil(
                    mockResultDisplayer.conversions,
                    "Conversion result displayer should have been called to display the conversion results"
                )
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 1.0)
    }
}
