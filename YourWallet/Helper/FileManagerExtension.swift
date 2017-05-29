//
//  FileManagerExtension.swift
//  Restaurant Management
//
//  Created by Tran Van Dong on 4/21/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import Foundation
func DocURL()->URL{
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
}
func MainURL()->URL{
    return Bundle.main.bundleURL
}
extension URL{
    func path(forFile: String) -> URL{
        return self.appendingPathComponent(forFile)
    }
}

func listFilesFromFolder(fromPath: String)->[String]?{
    //list all contents of directory and return as [String] OR nil if failed
    return try? FileManager.default.contentsOfDirectory(atPath:fromPath)
}
extension FileManager{
    func createDirectory(at url: URL,withName: String){
        do{
            try FileManager.default.createDirectory(atPath: url.appendingPathComponent(withName).path, withIntermediateDirectories: false, attributes: nil)
        }catch {
            print("Can not create folder < \(withName) > at .../\(url.lastPathComponent)")
        }
    }
    func remoremoveItem(at url: URL, withName: String){
        do{
            try FileManager.default.removeItem(at: url.appendingPathComponent(withName))
            
            print("Removed \(withName) from .../\(url.lastPathComponent)")
        }catch{
            print("Can not remove \(withName) from .../\(url.lastPathComponent)")
        }
        
    }
}

