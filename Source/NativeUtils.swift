//
//  NativeUtils.swift
//  EurobetGiochi
//
//  Created by Eros Reale on 14/04/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

typealias ThrowsCallback<T> = (() throws -> (T)) -> Void

class NativeUtils: NSObject {
  static func presentNative(_ vc: UIViewController, from parent: UIViewController? = nil, completion: (() -> Void)? = nil) {
    DispatchQueue.main.async {
      let parent = parent ?? UIApplication.shared.windows.first?.rootViewController
      parent?.present(vc, animated: false, completion: completion)
    }
  }

  static func closeAll() {
    let parent = UIApplication.shared.windows.first?.rootViewController
    parent?.navigationController?.popToRootViewController(animated: true)
  }

  static func closeFirst() {
    UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true)
  }

}
