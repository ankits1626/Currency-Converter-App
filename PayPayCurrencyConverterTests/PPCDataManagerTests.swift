//
//  PPCDataManagerTests.swift
//  PayPayCurrencyConverterTests
//
//  Created by Ankit on 30/07/22.
//

import XCTest
@testable import PayPayCurrencyConverter


/**
 unit test for PPCDataManager
 */
class PPCDataManagerTests: XCTestCase {
    
    var sut : PPCDataManager!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = PPCDataManager()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

}

//MARK: - Available currencies Tests
extension PPCDataManagerTests{
    
    func testThatDataManagerCallsCachedDataProviderWhenAskedToProvideAvailableCurrencies() {
        //given
        let mockCachedDataManager = MockCachedDataManager()
        sut.cachedDataManager = mockCachedDataManager
        //when
        sut.provideAvailableCurrencies { _, _ in}
        //then
        XCTAssertTrue(mockCachedDataManager.isProvideAvailableCurrenciesCalled, "Data manager should try to fetch available currenncies from local store")
    }
    
    func testThatWhenAskedToProvideAvailableCurrenciesDataManagerCallsNetworkDataProviderIfCachedDataProviderReturnError() {
        //given
        let mockCachedDataManager = MockCachedDataManager()
        mockCachedDataManager.shouldReturnErrorForavailableCurrencies = true
        sut.cachedDataManager = mockCachedDataManager
        
        let mockNetworDataProvider = MockNetworkDataProvider()
        sut.networkDataProvider = mockNetworDataProvider
        //when
        sut.provideAvailableCurrencies { _, _ in}
        //then
        XCTAssertTrue(mockNetworDataProvider.isProvideAvailableCurrenciesCalled, "Data manager should call network data provider to fetch available currencies")
    }
    
    func testThatWhenAskedToProvideAvailableCurrenciesDataManagerNotCallsNetworkDataProviderIfCachedDataProviderReturnsCurrencies() {
        //given
        let mockCachedDataManager = MockCachedDataManager()
        sut.cachedDataManager = mockCachedDataManager
        
        let mockNetworDataProvider = MockNetworkDataProvider()
        sut.networkDataProvider = mockNetworDataProvider
        //when
        sut.provideAvailableCurrencies { _, _ in}
        //then
        XCTAssertFalse(mockNetworDataProvider.isProvideAvailableCurrenciesCalled, "Data manager should not call network data provider")
    }
    
    func testThatWhenAskedToProvideAvailableCurrenciesDataManagerProvidesCachedDataIfCachedDataProviderReturnsCurrencies() {
        //given
        let dummyCurrency = PPCAvailableCurrency(currencyCode: "USD", currencyName: "USD Dollar")
        let mockCachedDataManager = MockCachedDataManager()
        mockCachedDataManager.dummyAvailableCurrencies = [dummyCurrency]
        sut.cachedDataManager = mockCachedDataManager
        
        let mockNetworDataProvider = MockNetworkDataProvider()
        sut.networkDataProvider = mockNetworDataProvider
        //when
        
        let expectation =  expectation(description: "Could have received call back from data manager")
        sut.provideAvailableCurrencies { result, error in
            //then
            
            if let unwrappedResult = result{
                
                XCTAssertTrue(
                    unwrappedResult[0].presentationCurrencyCode == dummyCurrency.presentationCurrencyCode,
                    "Data manager should return the result as received from local"
                )
            }else{
                XCTFail("Available currency reslt should not be nil")
            }
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testThatWhenAskedToProvideAvailableCurrenciesDataManagerReturnsErrorIfItReceivesErrorFromNetworkDataProvider() {
        //given
        let mockCachedDataManager = MockCachedDataManager()
        mockCachedDataManager.shouldReturnErrorForavailableCurrencies = true
        sut.cachedDataManager = mockCachedDataManager
        
        let mockNetworDataProvider = MockNetworkDataProvider()
        mockNetworDataProvider.shouldReturnErrorForavailableCurrencies = true
        sut.networkDataProvider = mockNetworDataProvider
        //when
        let expectation =  expectation(description: "Could have received call back from data manager")
        sut.provideAvailableCurrencies { result, error in
            //then
            if let unwrappedError = error as? PPCCustomError{
                XCTAssertTrue(
                    unwrappedError == PPCCustomError.noRecordFound,
                    "Data manager should return same error as received by network data provider"
                )
            }else{
                XCTFail("Error should not be nil")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testThatWhenAskedToProvideAvailableCurrenciesDataManagerProvidesResultFetchedByNetworkDataProvider() {
        //given
        let dummyCurrency = PPCAvailableCurrency(currencyCode: "USD", currencyName: "USD Dollar")
        let mockCachedDataManager = MockCachedDataManager()
        mockCachedDataManager.shouldReturnErrorForavailableCurrencies = true
        sut.cachedDataManager = mockCachedDataManager
        
        let mockNetworDataProvider = MockNetworkDataProvider()
        mockNetworDataProvider.dummyAvailableCurrencies = [dummyCurrency]
        sut.networkDataProvider = mockNetworDataProvider
        //when
        
        let expectation =  expectation(description: "Could have received call back from data manager")
        sut.provideAvailableCurrencies { result, error in
            //then
            
            if let unwrappedResult = result{
                
                XCTAssertTrue(
                    unwrappedResult[0].presentationCurrencyCode == dummyCurrency.presentationCurrencyCode,
                    "Data manager should return the result as received from network data provider"
                )
            }else{
                XCTFail("Available currency result should not be nil")
            }
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testThatWhenAskedToProvideAvailableCurrenciesDataManagerReturnsErrorIfResultFetchedByNetworkDataProviderIsEmpty() {
        //given
        let mockCachedDataManager = MockCachedDataManager()
        mockCachedDataManager.shouldReturnErrorForavailableCurrencies = true
        sut.cachedDataManager = mockCachedDataManager
        
        let mockNetworDataProvider = MockNetworkDataProvider()
        mockNetworDataProvider.shouldReturnEmptyCurrenciesArray = true
        sut.networkDataProvider = mockNetworDataProvider
        //when
        
        let expectation =  expectation(description: "Could have received call back from data manager")
        sut.provideAvailableCurrencies { result, error in
            //then
            
            if let unwrappedError = error as? PPCCustomError{
                XCTAssertTrue(
                    unwrappedError == PPCCustomError.noRecordFound,
                    "Data manager should return same error as received by network data provider"
                )
            }else{
                XCTFail("Error should not be nil")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testThatWhenAskedToProvideAvailableCurrenciesDataManagerProvidesAsksCoreDataCoordinatorToSaveDataFetchedByNetworkDataProvider() {
        //given
        let dummyCurrency = PPCAvailableCurrency(currencyCode: "USD", currencyName: "USD Dollar")
        let mockCachedDataManager = MockCachedDataManager()
        mockCachedDataManager.shouldReturnErrorForavailableCurrencies = true
        sut.cachedDataManager = mockCachedDataManager
        
        let mockNetworDataProvider = MockNetworkDataProvider()
        mockNetworDataProvider.dummyAvailableCurrencies = [dummyCurrency]
        sut.networkDataProvider = mockNetworDataProvider
        //when
        
        let expectation =  expectation(description: "Could have received call back from data manager")
        sut.provideAvailableCurrencies { _, _ in
            XCTAssertNotNil(mockCachedDataManager.savedAvailableCurrencies, "Available currencies saved should not be nil")
            expectation.fulfill()
            XCTAssertTrue(mockCachedDataManager.savedAvailableCurrencies[0].presentationCurrencyCode == dummyCurrency.presentationCurrencyCode, "Available currency should be same as passed by network data provider")
        }
        wait(for: [expectation], timeout: 1.0)
    }
}

//MARK: - Conversion Tests
extension PPCDataManagerTests{
    
    func testThatDataManagerCallsCachedDataProviderWhenAskedToGetConversion() {
        let mockCachedDataManager = MockCachedDataManager()
        sut.cachedDataManager = mockCachedDataManager
        //when
        sut.getConversion(
            amount: 10,
            baseCurrency: PPCAvailableCurrency(currencyCode: "USD", currencyName: "US Dollar")) { _ in
            }
        //then
        XCTAssertTrue(mockCachedDataManager.isCalledForConversion, "Data manager should try to fetch conversions from local store")
    }
    
    func testThatWhenAskedToGetConversionDataManagerCallsNetworkDataProviderIfCachedDataManagerReturnError() {
        //given
        let mockCachedDataManager = MockCachedDataManager()
        mockCachedDataManager.shouldReturnErrorAfterConversion = true
        sut.cachedDataManager = mockCachedDataManager
        
        let mockNetworDataProvider = MockNetworkDataProvider()
        sut.networkDataProvider = mockNetworDataProvider
        //when
        sut.getConversion(
            amount: 10,
            baseCurrency: PPCAvailableCurrency(currencyCode: "USD", currencyName: "US Dollar")) { _ in
            }
        //then
        XCTAssertTrue(mockNetworDataProvider.isCalledForConversion, "Data manager should call network data provider to get conersions")
    }
    
    func testThatWhenAskedToGetConversionAndReceivedConversionRatiosFromNetworkDataManagerSendsConversionsToListener() {
        //given
        let dummyCurrency = PPCAvailableCurrency(currencyCode: "USD", currencyName: "US Dollar")
        let dummyCoversion = PPCCurrencyConversion(currency: dummyCurrency, conversionAmount: 10)
        let mockCachedDataManager = MockCachedDataManager()
        mockCachedDataManager.shouldReturnErrorAfterConversion = true
        sut.cachedDataManager = mockCachedDataManager
        
        let mockNetworDataProvider = MockNetworkDataProvider()
        mockNetworDataProvider.dummyConversions = [dummyCoversion]
        sut.networkDataProvider = mockNetworDataProvider
        
        let amountThatNeedToBeConverted : Double = 10
        //when
        let expectation =  expectation(description: "Wait for completion block from data manager")
        sut.getConversion(
            amount: amountThatNeedToBeConverted,
            baseCurrency: PPCAvailableCurrency(currencyCode: "USD", currencyName: "US Dollar")) { result in
                
                //then
                XCTAssertNotNil(result.conversions, "Data manager should send cnversions to the listener")
                XCTAssertTrue(
                    result.conversions![0].currency.presentationCurrencyCode == dummyCurrency.presentationCurrencyCode,
                    "Data manager should send currency as received by the network data provider to the listener"
                )
                XCTAssertTrue(
                    result.conversions![0].conversionAmount == amountThatNeedToBeConverted * dummyCoversion.conversionAmount,
                    "Data manager should send converted amount"
                )
                
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 1.0)
    }
    
    
    func testThatWhenAskedToGetConversionAndReceivingErrorFromDataProviderAndRecevingErrorFromCachedDataManagerDataManagerSendsErrorToListener(){
        //given
        let mockCachedDataManager = MockCachedDataManager()
        mockCachedDataManager.shouldReturnErrorAfterConversion = true
        sut.cachedDataManager = mockCachedDataManager
        
        let mockNetworDataProvider = MockNetworkDataProvider()
        mockNetworDataProvider.shouldReturnErrorAfterConversion = true
        sut.networkDataProvider = mockNetworDataProvider
        
        //when
        let expectation =  expectation(description: "Wait for completion block from data manager")
        sut.getConversion(
            amount: 10,
            baseCurrency: PPCAvailableCurrency(currencyCode: "USD", currencyName: "US Dollar")) { result in
                
                //then
                XCTAssertNotNil(result.error, "Data manager should send error to the listener")
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 1.0)
    }
    
    
}
