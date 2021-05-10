//
//  RoundedView.swift
//  casino
//
//  Created by Eros Reale on 16/01/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

import UIKit

@IBDesignable
open class RoundedBarView: UIView {
  open override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = frame.height / 2
  }
}
