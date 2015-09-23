//
//  ViewController.swift
//  Fluency
//
//  Created by Andreas Ganske on 22.09.15.
//  Copyright © 2015 Andreas Ganske. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func startProcess() {
		let process = WorkProcess()
		process.successClosure = { _ in
			print("SUCCESS!")
		}
		process.execute()
	}
}

