//
//  CustomTabBar.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 20.10.2024.
//


import UIKit

class CustomTabBar: UITabBar {

    private var shapeLayer: CALayer?

    override func draw(_ rect: CGRect) {
        self.addShape()
    }

    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = AppColors.color20.cgColor

        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }

        self.shapeLayer = shapeLayer
    }

    private func createPath() -> CGPath {
        let height: CGFloat = 55
        let slopeHeight: CGFloat = 20
        let centerWidth = self.bounds.width / 2
        let path = UIBezierPath()

      
        path.move(to: CGPoint(x: 0, y: 0))

       
        path.addLine(to: CGPoint(x: centerWidth - 60, y: 0))

        
        path.addQuadCurve(to: CGPoint(x: centerWidth - 30, y: slopeHeight),
                          controlPoint: CGPoint(x: centerWidth - 45, y: 0))

       
        path.addQuadCurve(to: CGPoint(x: centerWidth + 30, y: slopeHeight),
                          controlPoint: CGPoint(x: centerWidth, y: height))

       
        path.addQuadCurve(to: CGPoint(x: centerWidth + 60, y: 0),
                          controlPoint: CGPoint(x: centerWidth + 45, y: 0))

       
        path.addLine(to: CGPoint(x: self.bounds.width, y: 0))

        
        path.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        path.addLine(to: CGPoint(x: 0, y: self.bounds.height))
        path.close()

        return path.cgPath
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
      
        let pointForTargetView = self.convert(point, to: self)
        
       
        if self.bounds.contains(pointForTargetView) {
           
            for subview in self.subviews {
               
                let pointInSubview = subview.convert(point, from: self)
             
                if let result = subview.hitTest(pointInSubview, with: event) {
                    return result
                }
            }
        }
        
        return super.hitTest(point, with: event)
    }



}

import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var responder: UIResponder? = self
        while let r = responder {
            if let viewController = r as? UIViewController {
                return viewController
            }
            responder = r.next
        }
        return nil
    }
}

