//
//  MockRemoteFileReader.swift
//  PayPayCurrencyConverterTests
//
//  Created by Ankit on 31/07/22.
//

import Foundation
@testable import PayPayCurrencyConverter

/**
 This class mocks the remote fle reader which reads data from a remote file
 */
class MockRemoteFileReader: PPCRemoteFileDataFetcherProtocol{
    
    var baseUrl: String{
        return "dummy"
    }
    
//    var isReadRemoteFileCalled = false
    var shouldReturnError = false
    var shouldReturnEmptyData = false
    var dummyJson : String?
    
    var fileName : String!
    func readRemoteJsonFile(_ endPoint: String, appID: String?, currencyCode: String?, completion: @escaping (Data?, Error?) -> Void) {
        self.fileName = endPoint
//        isReadRemoteFileCalled = true
        if shouldReturnError{
            completion(nil, PPCCustomError.noRecordFound)
        } else if shouldReturnEmptyData{
            completion(Data("".utf8), nil)
        }else{
            if let unwrappedDummyJson = dummyJson{
                completion(Data(unwrappedDummyJson.utf8), nil)
            }else{
                completion(Data("".utf8), nil)
            }
        }
    }
    
}
