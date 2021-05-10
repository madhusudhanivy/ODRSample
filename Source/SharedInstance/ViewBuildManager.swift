//
//  ViewBuildManager.swift
//  casino
//
//  Created by Eros Reale on 17/01/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

import UIKit

class ViewBuildManager {
  
  // MARK: - Singleton
  private init() {}
  static var shared = ViewBuildManager()
  
  
  // MARK: - Methods
  func loading() -> LoadingScreenViewController {
    let vc = LoadingScreenViewController()
    vc.modalPresentationStyle = .fullScreen
    return vc
  }
}
