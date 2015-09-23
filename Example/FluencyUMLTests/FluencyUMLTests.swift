//
//  FluencyUMLTests.swift
//  FluencyUMLTests
//
//  Created by Andreas Ganske on 23.09.15.
//  Copyright © 2015 Andreas Ganske. All rights reserved.
//

import XCTest

class FluencyUMLTests: XCTestCase {
        
	class func outputPlantUMLURL() -> NSURL
	{
		return NSURL(fileURLWithPath: "/tmp/Fluency/")
	}
	
	override class func setUp() {
		super.setUp()
		
		let fileManager = NSFileManager.defaultManager()
		let url = outputPlantUMLURL()
		
		try! fileManager.createDirectoryAtURL(url, withIntermediateDirectories: true, attributes: nil)
		
		let files = try! NSFileManager.defaultManager().contentsOfDirectoryAtURL(url, includingPropertiesForKeys: nil, options: .SkipsSubdirectoryDescendants)
		
		for file in files
		{
			try! NSFileManager.defaultManager().removeItemAtURL(file)
		}
	}
	
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
		let exampleProcess = ExampleProcess()
		outputProcessPlantUML(exampleProcess)
    }
	
	func testWork() {
		let workProcess = WorkProcess()
		outputProcessPlantUML(workProcess)
	}
	
	func outputProcessPlantUML(process : Process)
	{
		outputPlantUML(process.className(), content: process.plantUML())
	}
	
	func outputPlantUML(filename : String, content : String)
	{
		let url = self.dynamicType.outputPlantUMLURL()
		let fileURL = url.URLByAppendingPathComponent("\(filename).plantuml")
		
		try! content.writeToURL(fileURL, atomically: false, encoding: NSUTF8StringEncoding)
	}
    
}
