//
//  GameManager.swift
//  casino
//
//  Created by Eros Reale on 21/01/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation


typealias ThrowableCallback<T> = (() throws -> (T)) -> Void

class GameManager: NSObject {
  
  // MARK: - Singleton
  static var shared = GameManager()
  override private init() {
    super.init()
  }
  
  
  // MARK: - Properties
  var odr = ODRManager.shared
  var zip = ZipManager.shared
  var web = WebServerManager.shared
  
  var currentGame: String?
  var webServerIndexFile: String? {didSet{web.webServerIndexFile=webServerIndexFile}}
  var webServerPort: UInt? {didSet{web.port=webServerPort ?? 8080}}
  var queryString: String?
  var isForReal: Bool?
  
  var rctResolver: RCTPromiseResolveBlock?
  var rctRejecter: RCTPromiseRejectBlock?
  
  
  // MARK: - Methods
  func requestUnzippedResource(_ tag: String, resolver: @escaping ThrowableCallback<String>) {
    
    // check if resource is already unzipped
    if let resourceUnzippedPath = zip.resourceExists(tag) {
      resolver({ return resourceUnzippedPath })
      return
    }
    
    // Request resource with odr
    odr.requestResourceWith(tag) { zipPathThrowable in
      if let zipPath = try? zipPathThrowable() {
        self.zip.extractGame(zipPath, resolver: resolver)
        return
      }
      
      resolver({ throw GameViewController.CustomErrors.genericError })
    }
  }
  
  
  func getCurrentGameUrl() -> String? {
    guard let _ = currentGame, let _ = webServerPort, let gameLaunchUrl = queryString else { return nil }
    return gameLaunchUrl
  }
}


// MARK: - F***ing GamesCore is unzipped as ProjectTemplate
extension GameManager {
  func requestGamesCore(resolver: @escaping ThrowableCallback<String>) {
    
    // check if resource is already unzipped
    if let resourceUnzippedPath = zip.gamesCoreExists() {
      resolver({ return resourceUnzippedPath })
      return
    }
    
    // Request resource with odr
    odr.requestResourceWith("GamesCore") { zipPathThrowable in
      if let zipPath = try? zipPathThrowable() {
        self.zip.extractGame(zipPath, resolver: resolver)
        return
      }
      
      resolver({ throw GameViewController.CustomErrors.genericError })
    }
  }
}
