//
//  HUDView.swift
//  MyLocations
//
//  Created by Permi on 2018/4/16.
//  Copyright © 2018 Razeware. All rights reserved.
//

import UIKit

class HUDView: UIView {
  var text = ""
  static func hud(inView view: UIView, animated: Bool) -> HUDView {
    let hudView = HUDView(frame: view.bounds)
    hudView.isOpaque = false
    view.addSubview(hudView)
    view.isUserInteractionEnabled = false
    hudView.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.1)
    
    hudView.show(animated: animated)
    return hudView
  }
  
  func show(animated: Bool) {
    if animated {
      alpha = 0
      transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//      UIView.animate(withDuration: 0.3) {
//        self.alpha = 1
//        self.transform = CGAffineTransform.identity
//      }
      UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
        self.alpha = 1
        self.transform = CGAffineTransform.identity
      }, completion: nil)
    }
  }
  
  override func draw(_ rect: CGRect) {
    let boxWidth: CGFloat = 96
    let boxHeight: CGFloat = 96
    let boxRect = CGRect(x: round((bounds.size.width - boxWidth)/2), y: round((bounds.size.height - boxHeight)/2), width: boxWidth, height: boxHeight)
    let roundRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
    UIColor(white: 0.3, alpha: 0.8).setFill()
    roundRect.fill()
    
    if let image = UIImage(named: "Checkmark") {
      let imagePoint = CGPoint(x: center.x - round(image.size.width/2), y: center.y - round(image.size.height/2) - boxHeight/8)
      image.draw(at: imagePoint)
    }
    
    let attrs = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.white]
    let textSize = text.size(withAttributes: attrs)
    let textPoint = CGPoint(x: center.x - round(textSize.width/2), y: center.y - round(textSize.height/2) + boxHeight/4)
    text.draw(at: textPoint, withAttributes: attrs)
  }
  
  func hide() {
    superview?.isUserInteractionEnabled = true
    removeFromSuperview()
  }
}
