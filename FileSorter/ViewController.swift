//
//  ViewController.swift
//  FileSorter
//
//  Created by Koray Birand on 12/12/17.
//  Copyright © 2017 Koray Birand. All rights reserved.
//

import Cocoa
import Foundation

class ViewController: NSViewController {

    @IBOutlet weak var progressBar: NSProgressIndicator!
    @IBOutlet weak var selectedfolder: NSTextField!
    @IBOutlet weak var copyfoldername: NSTextField!
    @IBOutlet weak var progress: NSTextField!
    
    var folderOne : URL!
    var folderTwo : URL!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func selectFolder(_ sender: Any) {
        // 1
        guard let window = view.window else { return }
        
        // 2
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        
        // 3
        panel.beginSheetModal(for: window) { (result) in
            if result == NSFileHandlingPanelOKButton {
                // 4
                self.folderOne = panel.urls[0]
                self.selectedfolder.stringValue = panel.urls[0].path
            }
        }
    }
    
    @IBAction func copyFolder(_ sender: Any) {
        
        guard let window = view.window else { return }
        
        // 2
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.canCreateDirectories = true
        
        // 3
        panel.beginSheetModal(for: window) { (result) in
            if result == NSFileHandlingPanelOKButton {
                // 4
                self.folderTwo = panel.urls[0]
                self.copyfoldername.stringValue = panel.urls[0].path
            }
        }
    }
    
    @IBAction func execute(_ sender: Any) {
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: folderOne, includingPropertiesForKeys: nil, options: [])
            progressBar.minValue = 0
            progressBar.isHidden = false
            progressBar.maxValue = Double(directoryContents.count)
            progressBar.doubleValue = 0
            progressBar.isIndeterminate = false
            
            
            for myfile in directoryContents {
                DispatchQueue.global(qos: .userInitiated).async(execute: {
                DispatchQueue.main.async {
                    
                    self.progressBar.increment(by: 1)
                    self.progressBar.display()
                
                    self.progress.stringValue = myfile.lastPathComponent
                    }
                    
                let array = myfile.lastPathComponent.components(separatedBy: "_")
                let mycount = array.count
                let folderName = (array[mycount-2])
                
                
                    let logsPath = self.folderTwo.appendingPathComponent("\(folderName)")
                print(logsPath)
                do {
                    try FileManager.default.createDirectory(atPath: (logsPath.path), withIntermediateDirectories: true, attributes: nil)
                } catch let error as NSError {
                    print("Unable to create directory \(error.debugDescription)")
                }
                
                do {
                    try FileManager.default.copyItem(atPath: myfile.path, toPath: logsPath.appendingPathComponent(myfile.lastPathComponent).path)
                } catch let error as NSError {
                    print("Unable to create directory \(error.debugDescription)")
                }
                
                })
                
                
                
            }
            
            // if you want to filter the directory contents you can do like this:
//            let mp3Files = directoryContents.filter{ $0.pathExtension == "mp3" }
//            print("mp3 urls:",mp3Files)
//            let mp3FileNames = mp3Files.map{ $0.deletingPathExtension().lastPathComponent }
//            print("mp3 list:", mp3FileNames)
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
}

