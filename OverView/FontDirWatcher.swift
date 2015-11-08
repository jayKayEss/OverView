//
//  FontDirWatcher.swift
//  OverView
//
//  Created by Justin Sheckler on 11/8/15.
//  Copyright © 2015 Justin Sheckler. All rights reserved.
//

import Cocoa
import CoreServices

let kFontsDidChangeNotificationKey = "com.jaykayess.OverView.FontsDidChangeNotification";
let kFontDir = "/Users/jks/Desktop";
let kFontFileExtension = "otf";

class FontDirWatcher {
    
    static let sharedInstance = FontDirWatcher();
    
    var events: CDEvents!
    var fontFiles: [String] = [];
    
    init() {
        let url = NSURL(fileURLWithPath: kFontDir)
        events = CDEvents(URLs: [url]) { (watcher, event) -> Void in
            self.scanFiles()
            NSNotificationCenter.defaultCenter().postNotificationName(kFontsDidChangeNotificationKey, object: nil)
        }
        scanFiles();
    }
    
    func scanFiles() {
        fontFiles = [];
        
        let dirEnum = NSFileManager.defaultManager().enumeratorAtPath(kFontDir);
        for path in dirEnum! {
            if path.pathExtension == kFontFileExtension {
                fontFiles.append(path as! String);
            }
        }
    }
    
    func fontForFileName(fontFileName: String?, size:Double) -> NSFont? {
        guard fontFileName != nil else { return nil }
        let fontPath = kFontDir + "/" + fontFileName!
        return NSFont.fontFromPath(fontPath, size: size)
    }
    
}

extension NSFont {
    
    static func fontFromPath(filePath:String, size:Double) -> NSFont? {
        guard filePath != "" else { return nil }
        
        let dataProvider = CGDataProviderCreateWithFilename((filePath as NSString).UTF8String);
        guard dataProvider != nil else { return nil }
        
        let fontRef = CGFontCreateWithDataProvider(dataProvider)
        guard fontRef != nil else { return nil }
        
        let fontCore = CTFontCreateWithGraphicsFont(fontRef!, CGFloat(size), nil, nil)
        return fontCore as NSFont
    }
    
}
