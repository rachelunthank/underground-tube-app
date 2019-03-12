//
//  Copyright © 2019 rachelunthank. All rights reserved.
//

import XCTest

class LondonUndergroundStatusUITests: XCTestCase {

    var app: XCUIApplication?

    override func setUp() {
        super.setUp()

        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        guard let app = app else {
            XCTFail("app not initialised correctly")
            return
        }

        snapshot("Home")
        let cellsQuery = app.collectionViews.cells
        cellsQuery.otherElements.containing(.staticText, identifier:"Bakerloo").element.tap()
        snapshot("GoodService")
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element
        element.tap()
        cellsQuery.otherElements.containing(.staticText, identifier:"Emirates Air Line").element.tap()
        snapshot("BadService")
        element.tap()
        app.toolbars["Toolbar"].buttons["Settings"].tap()
        snapshot("Settings")
        app.navigationBars["Settings"].buttons["Done"].tap()

    }

}
