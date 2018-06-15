//
//  FinderSync.swift
//  GoToShellFinderExtension
//
//  Created by 张文兵 on 2018/6/10.
//  Copyright © 2018年 Kevin Moran. All rights reserved.
//

import Cocoa
import FinderSync

class FinderSync: FIFinderSync {

    var myFolderURL = URL(fileURLWithPath: "/")
    var appDict = Dictionary<String, String>()
    var addDict = Dictionary<String, String>()
    
    override init() {
        super.init()
        
        appDict["打开终端(hyper)"] = "Hyper"
        appDict["打开终端(iterm)"] = "iTerm"
        appDict["打开终端(terminal)"] = "Terminal"
        appDict["打开编辑器(vscode)"] = "Visual Studio Code"
        addDict["新建文件(.txt)"] = "Untitled.txt"
        
        NSLog("FinderSync() launched from %@", Bundle.main.bundlePath as NSString)
        
        // Set up the directory we are syncing.
        FIFinderSyncController.default().directoryURLs = [self.myFolderURL]
        
    }
    
    // MARK: - Menu and toolbar item support
    
    override var toolbarItemName: String {
        return "Go To Shell"
    }
    
    override var toolbarItemToolTip: String {
        return "Click Here to use OpenTerm to open a Terminal in current Finder directory."
    }
    
    override var toolbarItemImage: NSImage {
        return NSImage(named:NSImage.Name(rawValue: "terminal.png"))!
    }
    
    override func menu(for menuKind: FIMenuKind) -> NSMenu {
        // Produce a menu for the extension.
        let menu = NSMenu(title: "Go To Shell")
        for (key, _) in appDict{
            menu.addItem(withTitle: key, action: #selector(open(_:)), keyEquivalent: "")
        }
        for (key, _) in addDict{
            menu.addItem(withTitle: key, action: #selector(add(_:)), keyEquivalent: "")
        }
        return menu
    }
    
    @IBAction func open(_ item: NSMenuItem) {
        let target = FIFinderSyncController.default().targetedURL()
        
        guard let targetPath = target?.path.replacingOccurrences(of: " ", with: "%20"), let url = NSURL(string:"gotoshell://"+targetPath+"?app="+(appDict[item.title]?.replacingOccurrences(of: " ", with: "%20"))!) else {
            return
        }
        NSWorkspace.shared.open(url as URL)
    }
    
    @IBAction func add(_ item: NSMenuItem) {
        let target = FIFinderSyncController.default().targetedURL()
        
        guard let targetPath = target?.path.replacingOccurrences(of: " ", with: "%20"), let url = NSURL(string:"gotoshell://"+targetPath+"?add="+(addDict[item.title]?.replacingOccurrences(of: " ", with: "%20"))!) else {
            return
        }
        NSWorkspace.shared.open(url as URL)
    }
}

