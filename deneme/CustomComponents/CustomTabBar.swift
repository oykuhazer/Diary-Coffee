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
        shapeLayer.fillColor = UIColor(red: 0.4, green: 0.3, blue: 0.25, alpha: 1.0).cgColor

        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }

        self.shapeLayer = shapeLayer
    }

    private func createPath() -> CGPath {
        let height: CGFloat = 55 // Depth of the central dip
        let slopeHeight: CGFloat = 20 // Height of the downward slope at the edges of the curve
        let centerWidth = self.bounds.width / 2
        let path = UIBezierPath()

        // Start at top-left corner
        path.move(to: CGPoint(x: 0, y: 0))

        // Line to the left of the curve
        path.addLine(to: CGPoint(x: centerWidth - 60, y: 0))

        // Create a smooth downward slope on the left side of the curve
        path.addQuadCurve(to: CGPoint(x: centerWidth - 30, y: slopeHeight),
                          controlPoint: CGPoint(x: centerWidth - 45, y: 0))

        // Central deep curve
        path.addQuadCurve(to: CGPoint(x: centerWidth + 30, y: slopeHeight),
                          controlPoint: CGPoint(x: centerWidth, y: height))

        // Create a smooth downward slope on the right side of the curve
        path.addQuadCurve(to: CGPoint(x: centerWidth + 60, y: 0),
                          controlPoint: CGPoint(x: centerWidth + 45, y: 0))

        // Continue to the right edge of the tab bar
        path.addLine(to: CGPoint(x: self.bounds.width, y: 0))

        // Line to the bottom-right corner, then to bottom-left corner
        path.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        path.addLine(to: CGPoint(x: 0, y: self.bounds.height))
        path.close() // Close the shape

        return path.cgPath
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Make sure touch events on the tab bar items are handled
        let pointForTargetView = self.convert(point, to: self)
        
        // Check if the point is inside the tab bar's bounds
        if self.bounds.contains(pointForTargetView) {
            // Loop through all tab bar subviews (items)
            for subview in self.subviews {
                // Convert the point to the subview's coordinate system
                let pointInSubview = subview.convert(point, from: self)
                // Check if the point is inside the subview
                if let result = subview.hitTest(pointInSubview, with: event) {
                    return result
                }
            }
        }
        
        return super.hitTest(point, with: event)
    }



}
