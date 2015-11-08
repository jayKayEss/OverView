//
//  WindowController.swift
//  OverView
//
//  Created by Justin Sheckler on 11/8/15.
//  Copyright © 2015 Justin Sheckler. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {

    @IBOutlet var toolbar: Toolbar!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        toolbar.assignViewController(self.contentViewController as! ViewController)
    }
    
}
