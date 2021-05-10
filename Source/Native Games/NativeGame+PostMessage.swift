//
//  NativeGame+PostMessage.swift
//  EurobetGiochi
//
//  Created by Eros Reale on 22/06/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

import WebKit

//MARK: - Script Handler Delegate
extension NativeGame: WKScriptMessageHandler {
  public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    
    guard let data = message.body as? String, let dict = parseMessageType(data) else {
      return
    }
    
    if message.name == eventName {
      handlePostMessage(dict)
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
  
  fileprivate func handlePostMessage(_ json :EventData) {
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
