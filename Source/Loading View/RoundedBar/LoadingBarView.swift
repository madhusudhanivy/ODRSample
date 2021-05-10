//
//  LoadingBarViewController.swift
//  casino
//
//  Created by Eros Reale on 16/01/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

import UIKit

class LoadingBarView: UIView {
    
    // MARK: - Lifecycle
    override init(frame: CGRect) { // Custom View code
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) { // Custom View IB
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        // init here
        Bundle.main.loadNibNamed("LoadingBarView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }


    // MARK: - Outlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var frontBar: RoundedBarView!
    @IBOutlet weak var backBar: RoundedBarView! {
        didSet { backBar.layer.borderWidth = 1 }
    }
    @IBOutlet weak var fractionCompletedWidth: NSLayoutConstraint!
    
    
    // MARK: - Properties
    var percentage :Double = 100 {
        didSet {
          DispatchQueue.main.async {
            let width = self.backBar.frame.size.width * CGFloat(self.percentage / 100.0)
            self.fractionCompletedWidth.constant = width
            self.updateConstraints()
          }
        }
    }
    
    @IBInspectable
    var barColor: UIColor? {
        didSet {
            frontBar.backgroundColor = barColor
            backBar.layer.borderColor = barColor?.cgColor
            backBar.layer.borderWidth = 1
        }
    }
  
  
  private var observation: NSKeyValueObservation? = nil
  var progress :Progress = Progress() {
    didSet {
      observation = progress.observe(\.fractionCompleted, options: [.new]) { _, _ in
        self.percentage = self.progress.fractionCompleted * 100
      }
    }
  }
  
  
  // MARK: - Utils
  deinit {
    observation = nil
  }
  
}
