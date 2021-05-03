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
  @IBOutlet weak var countryLabel: UILabel!

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
      countryLabel.text = "-"
      return
    }
    nameLabel.text = plane.hasName ? plane.name : "No name"
    activeView.backgroundColor = plane.isActive ? UIColor.green : UIColor.red
    countryLabel.text = plane.hasCountry ? plane.country : "No country"
  }
}
