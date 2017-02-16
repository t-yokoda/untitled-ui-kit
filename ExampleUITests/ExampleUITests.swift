//
//  ExampleUITests.swift
//  ExampleUITests
//
//  Created by Anima App
//  Copyright © 2016. All rights reserved.
//

import XCTest

class ExampleUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testTakeScreenshot() {
        sleep(2)
        snapshot("")
    }
    
}
