//
//  ImageExtension.swift
//  UniverseGalleryApp
//
//  Created by Kumar, Sawant on 11/09/22.
//

import UIKit

extension UIImage {
  func scaleToSize(aSize :CGSize) -> UIImage {
      if (self.size.equalTo(aSize)) {
      return self
    }

    UIGraphicsBeginImageContextWithOptions(aSize, false, 0.0)
      self.draw(in: CGRect(x: 0, y: 0, width: aSize.width, height: aSize.height))
      guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return self }
    UIGraphicsEndImageContext()
    return image
  }
}
