//
//  NativeGame+WebView.swift
//  EurobetGiochi
//
//  Created by Eros Reale on 22/06/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

import WebKit

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
    getWKWebView().configuration.userContentController.removeScriptMessageHandler(forName: eventName)
    
    wkWebView = nil;
    
    HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
    
    WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
      records.forEach { record in
        WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
      }
    }
  }

}
