//
//  EmbeddedGameViewController.swift
//  casino
//
//  Created by Eros Reale on 14/01/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

import UIKit
import WebKit

class NativeGame: UIViewController {

  
  // MARK: - Properties
  var game = GameManager.shared
  let eventName = "embeddedGameWKHandler"
  var wkWebView :WKWebView! = nil
  
  
  // MARK: - IBOutlets
  @IBOutlet weak var webView :UIView!
  
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    game.web.startServer(game.zip.savedGamePath) { serverPath in
      guard let gameUrl = game.getCurrentGameUrl(), let url = URL(string: gameUrl) else {
        game.rctRejecter?("Could not retrieve game url", nil, nil)
        return
      }
      getWKWebView().load(URLRequest(url: url))
      game.rctResolver?(true)
    }
  }
  
  override public func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    removeCacheData()
  }
}
