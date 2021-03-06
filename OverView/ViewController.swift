//
//  ViewController.swift
//  OverView
//
//  Created by Justin Sheckler on 11/7/15.
//  Copyright © 2015 Justin Sheckler. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, ToolbarVCDelegate {

    @IBOutlet var textView: NSTextView!

    var toolbar: Toolbar!
    var currentFont: String? = nil
    var currentSize: Double = 96.00
    var isKerningOn: Bool = true

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.representedObject = "Hello, World!";

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleFontsDidChangeNotification", name: kFontsDidChangeNotificationKey, object: nil)
        
        if (FontDirWatcher.sharedInstance.fontFiles.count > 0) {
            currentFont = FontDirWatcher.sharedInstance.fontFiles[0]
        }
        
        textView.drawsBackground = false
        textView.wantsLayer = true
        textView.layer?.backgroundColor = NSColor.whiteColor().CGColor
    }

    override func viewWillAppear() {
        toolbar.initializeFontMenu(FontDirWatcher.sharedInstance.fontFiles, selectedFont: currentFont)
        toolbar.initializeSizeWidgets(currentSize)
        toolbar.initializeRulerButton(textView.rulerVisible)
        
        updateView()
    }
    
    override var representedObject: AnyObject? {
        didSet {
            textView.string = representedObject as? String;
        }
    }
    
    func updateView(animated: Bool = false) {
        var font: NSFont?
        
        font = FontDirWatcher.sharedInstance.fontForFileName(currentFont, size: currentSize)
        
        if (font == nil) {
            font = NSFont.systemFontOfSize(CGFloat(currentSize))
        }
        
        textView.font = font!

        if (animated) {
            let anim = CABasicAnimation(keyPath: "backgroundColor")
            anim.fromValue = NSColor(red: 1.0, green: 1.0, blue: 0.6, alpha: 1.0).CGColor
            anim.toValue = NSColor.whiteColor().CGColor
            anim.duration = 0.75
            anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            textView.layer!.addAnimation(anim, forKey: "backgroundColor")
        }
    }
    
    func toolbarDidChangeFont(selectedFont: String?) {
        currentFont = selectedFont
        updateView()
    }
    
    func toolbarDidChangeSize(fontSize: Double) {
        currentSize = fontSize
        updateView()
    }

    func toolbarDidToggleRuler() {
        textView.toggleRuler(self)
    }
    
    func handleFontsDidChangeNotification() {
        let allFonts = FontDirWatcher.sharedInstance.fontFiles
        if (allFonts.count > 0) {
            if currentFont == nil || !allFonts.contains(currentFont!) {
                currentFont = allFonts[0]
            }
        } else {
            currentFont = nil
        }
        
        toolbar.initializeFontMenu(allFonts, selectedFont: currentFont)
        updateView(true)
    }
    
}

