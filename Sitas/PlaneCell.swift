//
//  PlaneCell.swift
//  Sitas
//
//  Created by steph on 4/29/21.
//

import UIKit

class PlaneCell: UICollectionViewCell {

  // MARK: - public vars
  var plane: Plane? = nil {
    didSet {
      updateUI()
    }
  }

  // MARK: - ibOtulets
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var activeView: UIView!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var imageActivityView: UIActivityIndicatorView!

  // MARK: - UIView lifecycle
  override func layoutSubviews() {
    super.layoutSubviews()
    configureUI()
  }

  // MARK: - private functions
  private func configureUI() {
    activeView.roundCorners()
    contentView.layer.borderWidth = 1
    contentView.roundCorners(5)
    contentView.clipsToBounds = true
  }

  private func updateUI() {
    guard let plane = plane else {
      nameLabel.text = "No Plane"
      activeView.backgroundColor = .red
      imageView.isHidden = true
      return
    }
    nameLabel.text = plane.hasName ? plane.name : "No name"
    activeView.backgroundColor = plane.isActive ? UIColor.green : UIColor.red
    updateImage()
  }

  private func updateImage() {
    guard let imageString = plane?.imageString else {
      imageView.isHidden = true
      return
    }

    imageView.isHidden = false
    let results = imageString.matches(for: "data:image\\/([a-zA-Z]*);base64,([^\\\"]*)")
    if let base64Image = results.first {
      imageView.image = base64Image.base64ToImage()
    } else {
      imageActivityView.startAnimating()
      imageView.kf.setImage(with: URL(string: imageString), placeholder: nil,
                            options: []) { result in
        self.imageActivityView.stopAnimating()
      }
    }
  }
}
