//
//  SnowboardJumpTrickTests.swift
//  CoreTrickTests
//
//  Created by Tigran  Simonyan on 5/9/19.
//  Copyright © 2019 Tigran  Simonyan. All rights reserved.
//

import XCTest

@testable import CoreTrick

class SnowboardJumpTrickTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testThatAnyReasonableMultipleOf180IsAValidSpin() {
        
        let validSpins = [180, 360, 540, 720, 900, 1080]
        
        for spin in validSpins {
            let isValid = SnowboardJumpTrick.isMultipleOf180(spinDegrees: spin)
            XCTAssertTrue(isValid)
        }
    }
}
