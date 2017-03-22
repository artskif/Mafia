//
//  MafiaTests.swift
//  MafiaTests
//
//  Created by Vadim Kamyshnikov on 10.03.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import XCTest
@testable import Mafia

class MafiaTests: XCTestCase {
    // MARK: Player Class tests
    func testPlayerInitializationSucceeds(){
        // Not nil Player
        let notEmptyPlayer = Account.init(name: "Ivan")
        XCTAssertNotNil(notEmptyPlayer)
    }
    
    func testPlayerInitializationFail(){
        let emptyPlayer = Account.init(name: "")
        XCTAssertNil(emptyPlayer)
    }
}
