//
//  ExtensionsTests.swift
//  ParseSwift
//
//  Created by Corey Baker on 11/19/21.
//  Copyright © 2021 Parse Community. All rights reserved.
//

import Foundation
import XCTest
@testable import ParseSwift

class ExtensionsTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        guard let url = URL(string: "http://localhost:1337/1") else {
            XCTFail("Should create valid URL")
            return
        }
        ParseSwift.initialize(applicationId: "applicationId",
                              clientKey: "clientKey",
                              masterKey: "masterKey",
                              serverURL: url,
                              testing: true)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        MockURLProtocol.removeAll()
        #if !os(Linux) && !os(Android) && !os(Windows)
        try KeychainStore.shared.deleteAll()
        #endif
        try ParseStorage.shared.deleteAll()
    }

    #if !os(Linux) && !os(Android) && !os(Windows)
    func testURLSession() throws {
        ParseSwift.configuration.isTestingSDK = false
        XCTAssertNotNil(URLSession.parse.configuration.urlCache)
    }

    func testReconnectInterval() throws {
        for index in 1 ..< 50 {
            let time = URLSession.reconnectInterval(index)
            XCTAssertLessThan(time, 30)
            XCTAssertGreaterThan(time, -1)
        }
    }
    #endif
}