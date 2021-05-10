//
//  EmbeddedGameViewController.swift
//  casino
//
//  Created by Eros Reale on 14/01/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

import UIKit
import WebKit

typealias EventData = Dictionary<String, Any>

class NativeGame: UIViewController {

  
  // MARK: - Properties
  var game = GameManager.shared
  
  private let eventName = "embeddedGameWKHandler"
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
    
    getWKWebView().configuration.userContentController.removeScriptMessageHandler(forName: eventName)
    removeCacheData()
  }
}


extension NativeGame {
  func getWKWebView() -> WKWebView {
    
    if let alreadyInstatiated = wkWebView {
      return alreadyInstatiated
    }
    
    return buildWKWebView()
  }
  
  fileprivate func buildWKWebView() -> WKWebView {
    
    let configuration = WKWebViewConfiguration()
    configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
    configuration.allowsInlineMediaPlayback = true
    configuration.userContentController.addUserScript(buildUserScript())
    configuration.userContentController.add(self, name: eventName)
    
    
    let wkWebView = WKWebView(frame: webView.frame, configuration: configuration)
    wkWebView.scrollView.showsVerticalScrollIndicator = false
    wkWebView.scrollView.showsHorizontalScrollIndicator = false
    wkWebView.translatesAutoresizingMaskIntoConstraints = false
    
    webView.addSubview(wkWebView)
    fitIntoWebView(wkWebView)
    self.wkWebView = wkWebView
    
    return wkWebView
  }
  
  fileprivate func buildUserScript() -> WKUserScript {
    
    let jScript = """
      window.open = function (open){
        return function(url, name, features){
          var message = function(obj){
          window.webkit.messageHandlers.\(eventName).postMessage(JSON.stringify(obj),'*')
          };

          url.lastIndexOf('close-game') > 0 ? message({type: 'closeGame'}) : message({type: 'openUrl', data: {url: url}});
          return window;
        };
      } (window.open)
    """
    
    return WKUserScript(source: jScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
  }
}


//MARK: - Private Helpers
extension NativeGame {
  fileprivate func fitIntoWebView(_ wkWebView: WKWebView) {
    NSLayoutConstraint.activate([
      wkWebView.topAnchor.constraint(equalTo: webView.topAnchor),
      wkWebView.bottomAnchor.constraint(equalTo: webView.bottomAnchor),
      wkWebView.leadingAnchor.constraint(equalTo: webView.leadingAnchor),
      wkWebView.trailingAnchor.constraint(equalTo: webView.trailingAnchor)
    ])
  }
  
  func removeCacheData() {
    wkWebView = nil;
    
    HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
    
    WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
      records.forEach { record in
        WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
      }
    }
  }

}



//MARK: - Script Handler Delegate
extension NativeGame: WKScriptMessageHandler {
  public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    
    guard let data = message.body as? String, let dict = parseMessageType(data) else {
      return
    }
    
    if message.name == eventName {
      handleMessageData(dict)
      return
    }
  }
  
  fileprivate func parseMessageType(_ messageBody :String) -> EventData? {
    let data = messageBody.data(using: .utf8)!
    do {
      guard let json = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? EventData else {
        print("bad json")
        return nil
      }
      
      return json
    } catch let error as NSError {
      print(error)
      return nil
    }
  }
  
  fileprivate func handleMessageData(_ json :EventData) {
    guard let action = json["type"] as? String else {
      return
    }
    
    action == "closeGame" ? closeGame() : goToUrl(json)
  }
  
  fileprivate func closeGame() {
    view.window!.rootViewController?.dismiss(animated: false) {
      UIDevice.current.setValue(UIDeviceOrientation.portrait.rawValue, forKey: "orientation")
    }
  }
  fileprivate func goToUrl(_ json :EventData) {
    guard let data = json["data"] as? Dictionary<String, String>, let urlString = data["url"], let url = URL(string: urlString) else {
      return
    }
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }
}
