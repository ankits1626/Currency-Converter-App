//
//  PPCCurrencySelectorWidgetTests.swift
//  PayPayCurrencyConverterTests
//
//  Created by Ankit on 30/07/22.
//

import XCTest
@testable import PayPayCurrencyConverter

/**
 Unit test for PPCCurrencySelectorWidgetTests
 
 Following boundaries tested:
    -  Data manager
    -  PPCCurrencySelectorWidgetDelegate
    -  PPCCurrencyListView
 */
class PPCCurrencySelectorWidgetTests: XCTestCase {
    
    var sut: PPCCurrencySelectorWidget!
    
    //mocks
    private var mockDataManager  =  MockDataManager()
    private var mockErrorDislayer  =  MockErrorDisplayer()
    private var mockCurrencyListPicker = MockCurrencyListDisplayer()

    override func setUpWithError() throws {
        sut = PPCCurrencySelectorWidget(
            PPCCurrencySelectorWidgetInitModel(
                dataManager: mockDataManager,
                errorDisplayer: mockErrorDislayer
            )
        )
        sut.availableCurrencyPicker = mockCurrencyListPicker
    }

    override func tearDownWithError() throws {
        print("<<<<< PPCCurrencySelectorWidgetTests tearDownWithError")
        sut  = nil
    }
}

extension PPCCurrencySelectorWidgetTests{
    
    func testThatDataManagerIsCalledWhenSelectCurrencyIsTapped() {
        
        //when
        sut.selectCurrencyTapped()
        //then
        XCTAssertTrue(mockDataManager.isProvideAvailableCurrenciesCalled, "Data manager should have been called when select currency is tapped")
    }
    
    func testThatErrorShouldBeDisplayedIfDataManagerReturnErrorWhenSelectCurrencyIsTapped() {
        //given
        mockDataManager.shouldReturnError = true
        
        //when
        let expectation =  expectation(description: "Wait for completion block from data manager")
        mockDataManager.provideAvailableCurrencies { result, error in
            sut.handleAvaileCurrenciesResponse(result, error)
            //then
            XCTAssertTrue(mockErrorDislayer.isDisplayErrorCalled, "Error returned by data manager should be displayed ")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testThatErrorShouldBeDisplayedIfDataManagerReturnEmptyListWhenSelectCurrencyIsTapped() {
        //given
        mockDataManager.shouldReturnEmptyCurrenciesArray = true
        
        //when
        let expectation =  expectation(description: "Wait for completion block from data manager")
        mockDataManager.provideAvailableCurrencies { result, error in
            sut.handleAvaileCurrenciesResponse(result, error)
            //then
            XCTAssertTrue(mockErrorDislayer.isDisplayErrorCalled, "When received empty error by data manager, error should be displayed ")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testThatCurrencyListDisplayerShouldBeAskedToDisplayCurrencyListifDataManagerDoesNotReturnErrorAndAvailableCurrencIsNotEmptyWhenSelectCurrencyIsTapped() {
        //given
        sut.availableCurrencyPicker = mockCurrencyListPicker
        //when
        let expectation =  expectation(description: "Wait for completion block from data manager")
        mockDataManager.provideAvailableCurrencies { result, error in
            sut.handleAvaileCurrenciesResponse(result, error)
            //then
            XCTAssertTrue(mockCurrencyListPicker.isDisplayCurrencyListCalled, "When received available currencies from data manager, currency list should be displayed ")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testThatCurrencyListReceivesTheSameCurrencyListAsReceivedByDataManager() {
        //given
        sut.availableCurrencyPicker = mockCurrencyListPicker
        let dummyInrCurrency = PPCAvailableCurrency(currencyCode: "INR", currencyName: "Indian Rupee")
        let dummyUsdCurrency = PPCAvailableCurrency(currencyCode: "USD", currencyName: "US Dollar")
        mockDataManager.dummyAvailableCurrencies = [dummyInrCurrency, dummyUsdCurrency]
        //when
        let expectation =  expectation(description: "Wait for completion block from data manager")
        mockDataManager.provideAvailableCurrencies { result, error in
            sut.handleAvaileCurrenciesResponse(result, error)
            //then
            //1)
            XCTAssertTrue(
                !mockCurrencyListPicker.receivedCurrencyList.isEmpty,
                "Currency list should have received the available currencies "
            )
            //2)
            XCTAssertTrue(
                mockCurrencyListPicker.receivedCurrencyList.count == mockDataManager.dummyAvailableCurrencies.count,
                "Count of currencies sent by data manage should be same as received currencies by currency list"
            )
            //3)
            XCTAssertTrue(
                mockCurrencyListPicker.receivedCurrencyList[0].presentationCurrencyCode == mockDataManager.dummyAvailableCurrencies[0].presentationCurrencyCode,
                "Same currencies should be received by currency list as fetched from data manager"
            )
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
    }
    
    
    func testThatCurrencyWidgetReceivesTheSameCurrencyAsSelectedInPicker() {
        //given
        let dummyCurrency = PPCAvailableCurrency(currencyCode: "JPY", currencyName: "Japanese Yen")
        let expectation =  expectation(description: "Wait for completion block from data manager")
        mockCurrencyListPicker.currencySelectionCompletionBlock = {selectedCurrency in
            self.sut.handleSelectedCurrencyFromCurrencyList(selectedCurrency)
            //then
            XCTAssertTrue(
                dummyCurrency.presentationCurrencyCode == self.sut.selectedCurrency?.presentationCurrencyCode,
                "Receiver should receive the same currency as selected in currency list"
            )
            expectation.fulfill()
        }

        //when
        mockCurrencyListPicker.selectCurrency(dummyCurrency)
        wait(for: [expectation], timeout: 1.0)
        
        
    }
    
    func testThatWidgetNotifiesDelegateWhenCurrencyIsPicked() {
        
        //given
        let mockDelegate = MockCurrencyWidgetDelegate()
        sut.delegate = mockDelegate
        
        let dummyCurrency = PPCAvailableCurrency(currencyCode: "JPY", currencyName: "Japanese Yen")
        let expectation =  expectation(description: "Wait for completion block from data manager")
        mockCurrencyListPicker.currencySelectionCompletionBlock = {selectedCurrency in
            self.sut.handleSelectedCurrencyFromCurrencyList(selectedCurrency)
            //then
            if let unwrappedCurrency = mockDelegate.selectedCurrency{
                XCTAssertTrue(
                    dummyCurrency.presentationCurrencyCode == unwrappedCurrency.presentationCurrencyCode,
                    "Delegate should receive the selected currency"
                )
            }else{
                XCTFail( "Delegate should receive the selected currency and it should not be nil")
            }
            expectation.fulfill()
        }

        //when
        mockCurrencyListPicker.selectCurrency(dummyCurrency)
        wait(for: [expectation], timeout: 1.0)        
    }
}

