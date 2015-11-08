//
//  ViewController.swift
//  OverView
//
//  Created by Justin Sheckler on 11/7/15.
//  Copyright © 2015 Justin Sheckler. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet var textView: NSTextView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.representedObject = "Hello, World!";
    }

    override var representedObject: AnyObject? {
        didSet {
            textView.string = representedObject as? String;
        }
    }
    
    func updateViewForFont(font:NSFont) {
        textView.font = font
    }
}

