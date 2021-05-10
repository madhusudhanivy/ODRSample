//
//  ZipManager.swift
//  casino
//
//  Created by Eros Reale on 17/01/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import SSZipArchive



class ZipManager {
  
  
  // MARK: - Singleton
  private init() {}
  static var shared = ZipManager()
  
  
  // MARK: - Properties
  private var fm = FileManager()
  
  private var cacheDir :URL {
    get {
      return fm.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
  }
  
  var savedGamePath :String {
    get {
      // Test; Search for this comment line and toggle comments below
//      return Bundle.main.bundleURL.relativePath
      return cacheDir.appendingPathComponent("eurobetCasinoGames").relativePath
    }
  }
  
  
  // MARK: - Methods
  func resourceExists(_ tag: String) -> String? {
    var filePath = savedGamePath
  
    filePath.append("/" + tag)
    
    if fm.fileExists(atPath: filePath) {
      return filePath
    }
    return nil
  }
  
  
  func extractGame(_ zipPath: String, resolver: @escaping ThrowableCallback<String>) {
    SSZipArchive.unzipFile(atPath: zipPath, toDestination: savedGamePath, progressHandler: nil) { path, succeded, error in
      if let e = error {
        resolver({ throw e })
        return
      }
      resolver({ return path })
    }
  }
}

extension ZipManager {
  func gamesCoreExists() -> String? {
    var filePath = savedGamePath
    filePath.append("/ProjectTemplate")
    
    if fm.fileExists(atPath: filePath) {
      return filePath
    }
    return nil
  }
}
