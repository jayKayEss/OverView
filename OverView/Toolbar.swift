//
//  Toolbar.swift
//  OverView
//
//  Created by Justin Sheckler on 11/8/15.
//  Copyright © 2015 Justin Sheckler. All rights reserved.
//

import Cocoa

protocol ToolbarVCDelegate {
    
    var toolbar: Toolbar! { get set }

    func toolbarDidChangeFont(selectedFont: String?)
    func toolbarDidToggleRuler()
    func toolbarDidChangeSize(fontSize: Double)
    
}

class Toolbar: NSToolbar {

    var viewController: ToolbarVCDelegate?

    @IBOutlet var fontMenu: NSPopUpButton!
    @IBOutlet var sizeSlider: NSSlider!
    @IBOutlet var sizeInput: NSTextField!
    @IBOutlet var rulerButton: NSButton!
    
    func assignViewController(viewController: ToolbarVCDelegate) {
        self.viewController = viewController
        self.viewController!.toolbar = self
    }
    
    func initializeFontMenu(allFonts: [String], selectedFont: String?) {
        fontMenu.removeAllItems()
        fontMenu.addItemsWithTitles(allFonts)
        
        if (selectedFont != nil) {
            fontMenu.selectItemWithTitle(selectedFont!)
        } else {
            fontMenu.selectItemAtIndex(0)
        }
    }
    
    func initializeSizeWidgets(selectedSize: Double) {
        sizeSlider.doubleValue = selectedSize
        sizeInput.stringValue = String(format: "%d", Int(selectedSize))
    }
    
    func initializeRulerButton(isRulerOn: Bool) {
        rulerButton.state = isRulerOn ? NSOnState : NSOffState
    }
    
    @IBAction func fontMenuDidChange(sender: NSToolbarItem) {
        viewController!.toolbarDidChangeFont(fontMenu.titleOfSelectedItem)
    }

    @IBAction func fontSizeSliderDidChange(sender: NSToolbarItem) {
        let newSize = sizeSlider.doubleValue
        initializeSizeWidgets(newSize)
        viewController!.toolbarDidChangeSize(newSize)
    }

    @IBAction func fontSizeInputDidChange(sender: NSToolbarItem) {
        let newSize = Double(sizeInput.stringValue)!
        initializeSizeWidgets(newSize)
        viewController!.toolbarDidChangeSize(newSize)
    }
    
    @IBAction func rulerButtonWasClicked(sender: NSToolbarItem) {
        viewController!.toolbarDidToggleRuler()
    }
    
}
