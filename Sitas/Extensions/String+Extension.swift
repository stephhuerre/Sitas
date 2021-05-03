//
//  String+Extension.swift
//  Sitas
//
//  Created by steph on 5/2/21.
//

import UIKit

extension String {
  func base64ToImage() -> UIImage? {
    if let url = URL(string: self),
       let data = try? Data(contentsOf: url),
       let image = UIImage(data: data) {
      return image
    }
    return nil
  }

  func matches(for regex: String) -> [String] {
    do {
      let regex = try NSRegularExpression(pattern: regex)
      let results = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
      return results.map {
        String(self[Range($0.range, in: self)!])
      }
    } catch let error {
      print("invalid regex: \(error.localizedDescription)")
      return []
    }
  }
}
