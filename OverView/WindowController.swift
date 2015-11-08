//
//  WindowController.swift
//  OverView
//
//  Created by Justin Sheckler on 11/8/15.
//  Copyright © 2015 Justin Sheckler. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {

    @IBOutlet var fontMenu: NSPopUpButton!
    @IBOutlet var sizeSlider: NSSlider!
    @IBOutlet var sizeInput: NSTextField!
    
    var fontDirWatcher: FontDirWatcher!
    var currentFont: String? = ""
    var currentSize: Double = 96.00

    var textVC: ViewController {
        get {
            return self.contentViewController! as! ViewController
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleFontsDidChangeNotification", name: kFontsDidChangeNotificationKey, object: nil)
        
        fontDirWatcher = FontDirWatcher()
        initializeUI()
        updateTextView()
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func updateFontsMenu() {
        fontMenu.removeAllItems()
        fontMenu.addItemsWithTitles(fontDirWatcher.fontFiles)
        if (currentFont != nil) {
            fontMenu.selectItemWithTitle(currentFont!)
        }
    }

    @IBAction func fontMenuDidChange(sender: NSToolbarItem) {
        currentFont = fontMenu.titleOfSelectedItem!
        updateTextView()
    }

    @IBAction func fontSizeSliderDidChange(sender: NSToolbarItem) {
        currentSize = sizeSlider.doubleValue
        sizeInput.stringValue = String(format: "%d", Int(sizeSlider.doubleValue))
        updateTextView()
    }
    
    @IBAction func fontSizeInputDidChange(sender: NSToolbarItem) {
        currentSize = Double(sizeInput.stringValue)!
        sizeSlider.doubleValue = Double(sizeInput.stringValue)!
        updateTextView()
    }
    
    func initializeUI() {
        if (fontDirWatcher.fontFiles.count > 0) {
            currentFont = fontDirWatcher.fontFiles[0]
        }
        sizeSlider.doubleValue = currentSize
        sizeInput.doubleValue = currentSize
        updateFontsMenu()
    }
    
    func updateTextView() {
        var font: NSFont?
        if (currentFont != nil) {
            font = fontDirWatcher.fontForFileName(currentFont!, size: currentSize)
        } else {
            font = NSFont.systemFontOfSize(CGFloat(currentSize))
        }
        textVC.updateViewForFont(font!)
    }
    
    func handleFontsDidChangeNotification() {
        if (fontDirWatcher.fontFiles.count > 0) {
            if currentFont == nil || !fontDirWatcher.fontFiles.contains(currentFont!) {
                currentFont = fontDirWatcher.fontFiles[0]
            }
        } else {
            currentFont = nil
        }
        updateFontsMenu()
        updateTextView()
    }
    
}
