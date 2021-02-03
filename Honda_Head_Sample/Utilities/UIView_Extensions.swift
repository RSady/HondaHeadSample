//
//  UIView_Extensions.swift
//  HondaHead
//
//  Created by Ryan Sady on 11/18/20.
//

import Foundation
import UIKit

extension UIView {

    func addCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }

    func asImage() -> UIImage {
            if #available(iOS 10.0, *) {
                let renderer = UIGraphicsImageRenderer(bounds: bounds)
                return renderer.image { rendererContext in
                    layer.render(in: rendererContext.cgContext)
                }
            } else {
                UIGraphicsBeginImageContext(self.frame.size)
                self.layer.render(in:UIGraphicsGetCurrentContext()!)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return UIImage(cgImage: image!.cgImage!)
            }
        }
}
