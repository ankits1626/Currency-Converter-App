//
//  PPCNetworkDataProviderTests.swift
//  PayPayCurrencyConverterTests
//
//  Created by Ankit on 31/07/22.
//

import XCTest
@testable import PayPayCurrencyConverter

class PPCNetworkDataProviderTests: XCTestCase {
    var sut : PPCNetworkDataProvider!
    
    override func setUpWithError() throws {
        sut = PPCNetworkDataProvider()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
}

// MARK: - Available Currencies
extension PPCNetworkDataProviderTests{
    func testThatWhenAskedToFetchAvailableCurrenciewListRemoteFileReaderIsCalled() {
        //given
        let mockRemoteFileReader = MockRemoteFileReader()
        sut.remoteFileReader = mockRemoteFileReader
        //when
        sut.provideAvailableCurrencies { _, _ in}
        //then
        XCTAssertTrue(mockRemoteFileReader.fileName == "currencies.json", "Remote file reader should be called when asked to fetch available currencies")
    }
    
    func testThatNetworkDataProviderReturnErrorIfRemoteFileReaderReturnsError() {
        //given
        let mockRemoteFileReader = MockRemoteFileReader()
        mockRemoteFileReader.shouldReturnError = true
        sut.remoteFileReader = mockRemoteFileReader
        //when
        let expectation =  expectation(description: "Should have received call back from network data provider")
        sut.provideAvailableCurrencies { _, error in
            //then
            XCTAssertNotNil(error, "Network data provider should have retured the error")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
    }
    
    func testThatNetworkDataProviderReturnErrorIfRemoteFileReaderReturnsEmpty() {
        let mockRemoteFileReader = MockRemoteFileReader()
        mockRemoteFileReader.shouldReturnEmptyData = true
        sut.remoteFileReader = mockRemoteFileReader
        //when
        let expectation =  expectation(description: "Should have received call back from network data provider")
        sut.provideAvailableCurrencies { _, error in
            //then
            XCTAssertNotNil(error, "Network data provider should have retured the error")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testThatNetworkDataProviderReturnAvailableCurrenciesIfRemoteFileReaderReturnsCurrenciesList() {
        let mockRemoteFileReader = MockRemoteFileReader()
        mockRemoteFileReader.dummyJson = "{\"AED\": \"United Arab Emirates Dirham\", \"AFN\": \"Afghan Afghani\"}"
        sut.remoteFileReader = mockRemoteFileReader
        //when
        let expectation =  expectation(description: "Should have received call back from network data provider")
        sut.provideAvailableCurrencies { result, error in
            //then
            XCTAssertNil(error, "Network data provider should not have retured the error")
            XCTAssertNotNil(result, "Network data provider should not have retured the currencies")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
}


// MARK: - Available Currencies
extension PPCNetworkDataProviderTests{
    
    func testThatApiMangerIsAskedToFetchConversionWhengetConversionsIsCalled() {
        let mockRemoteFileReader = MockRemoteFileReader()
        sut.remoteFileReader = mockRemoteFileReader
        //when
        sut.getConversion(
            amount: 10,
            baseCurrency: MockDataProvider.getDummyCurrency()) { _ in
            }
        
        //then
        XCTAssertTrue(mockRemoteFileReader.fileName == "latest.json", "Remote file reader should be called when asked to fetch available currencies")
    }
    
    func testThatNetworkDataProviderReturnCoversionsIfRemoteFileReaderReturnsConversion(){
        let mockRemoteFileReader = MockRemoteFileReader()
        mockRemoteFileReader.dummyJson = MockDataProvider.dummyConversionResponseFromServer
        sut.remoteFileReader = mockRemoteFileReader
        //when
        let expectation =  expectation(description: "Should have received call back from network data provider")
        sut.getConversion(amount: 10, baseCurrency: MockDataProvider.getDummyCurrency()) { result in
            //then
            XCTAssertNil(result.error, "Network data provider should not have retured the error")
            XCTAssertNotNil(result.conversions, "Network data provider should not have retured the currencies")
            expectation.fulfill()
        }
    
        wait(for: [expectation], timeout: 1.0)
    }

}
