//
//  AppDelegate.swift
//  GoToShell
//
//  Created by 张文兵 on 2018/6/10.
//  Copyright © 2018年 Kevin Moran. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationWillFinishLaunching(_ notification: Notification) {
        NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(self.handleAppleEvent(event:replyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
    }
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", "pluginkit -e use -i com.zhangwenbing.GotoShell.GotoShellFinderExtension ; killall Finder"]
        task.launch()
        task.waitUntilExit()
        exit(0)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
    }
    
    @objc func handleAppleEvent(event: NSAppleEventDescriptor, replyEvent: NSAppleEventDescriptor) {
        guard let appleEventDescription = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject)) else {
            return
        }
        
        guard let appleEventURLString = appleEventDescription.stringValue else {
            return
        }
        
        let target = URL(string: appleEventURLString)
        
        if let path = target?.path {
            if let appName=target?.query{
                let name = (appName as NSString).substring(from: 4).replacingOccurrences(of: "%20", with: " ")
                
                if (appName as NSString).substring(to: 3)=="app"{ //打开app
                    NSWorkspace.shared.openFile(path, withApplication: name)
                }else{ //添加文件
                    var index = 0
                    while index < 100 {
                        let filePath:String = path+"/"+name
                        let little_name = index > 0 ? filePath+"."+String(index) : filePath
                        if !FileManager.default.fileExists(atPath: little_name) {
                            
                            let info = ""
                            try! info.write(toFile: little_name, atomically: true, encoding: String.Encoding.utf8)
                            break
                            
                        }
                        index += 1
                    }
                    
                    }
            }
        }
        exit(0)
    }
}



