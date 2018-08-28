//
//  MacHelperTest.swift
//  MacHelperTest
//
//  Created by mathieu on 11.08.18.
//  Copyright © 2018 altab. All rights reserved.
//

import XCTest

class MacHelperTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        print("----------------------------")
    }
    
    override func tearDown() {
        print("----------------------------")
        super.tearDown()
    }
    
    func testScenarioDecode() {
        let bundle = Bundle(for: type(of: self))
        guard let filepath = bundle.url(forResource: "scenario", withExtension: "plist"),
            let data = try? Data(contentsOf: filepath)
        else {
            print("cant read scenario file")
            XCTAssert(false)
            return
        }
        let scenario = ScenarioManager.decodeScenario(json: data)
        XCTAssertNotNil(scenario)
    }
    
    func testLoadScenario() {
        let bundle = Bundle(for: type(of: self))
        guard let filepath = bundle.path(forResource: "scenario", ofType: "plist")
            else{
                print("cant read scenario file")
                XCTAssert(false)
                return
        }
        if let scenario = ScenarioManager.loadScenario(path: filepath) {
            let runningScenario = ScenarioManager.loadRunningStatus(scenarioId: scenario.id)
            XCTAssertNotNil(runningScenario)
        }else{
            XCTAssert(false)
        }
    }
    
    /*func testScenarioEncode() {
        
        let bundle = Bundle(for: type(of: self))
        
        guard let filepath = bundle.url(forResource: "scenario", withExtension: "plist"),
            let data = try? Data(contentsOf: filepath),
            let scenario = ScenarioManager.decodeScenario(json: data)
            else {
                print("cant instanciate scenario file")
                XCTAssert(false)
                return
        }
        
        let string = ScenarioManager.encodeScenario(scenario: scenario)
        //print(string ?? "string is nil")
        XCTAssertNotNil(string)
        XCTAssert(string?.hasPrefix("{\"name\":\"") == true)
        
    }*/
    
}
