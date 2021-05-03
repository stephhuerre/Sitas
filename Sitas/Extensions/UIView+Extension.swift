//
//  UIView+Extension.swift
//  Sitas
//
//  Created by steph on 4/29/21.
//

import UIKit

extension UIView {

  var frameHeight: CGFloat {
    return frame.size.height
  }

  func roundCorners(_ radius: CGFloat? = nil) {
    guard let radius = radius else {
      layer.cornerRadius = frameHeight / 2
      return
    }
    layer.cornerRadius = radius
  }
}
