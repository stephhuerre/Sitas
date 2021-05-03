//
//  PlaneDetailViewController.swift
//  Sitas
//
//  Created by steph on 5/2/21.
//

import UIKit
import Kingfisher

class PlaneDetailViewController: UIViewController {

  // MARK: - public vars
  var plane: Plane? {
    didSet {
      guard isViewLoaded else { return }
      updateUI()
    }
  }

  // MARK: - iboutlets
  @IBOutlet weak var activeView: UIView!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var idLabel: UILabel!
  @IBOutlet weak var iataLabel: UILabel!
  @IBOutlet weak var icaoLabel: UILabel!
  @IBOutlet weak var callsignLabel: UILabel!
  @IBOutlet weak var countryLabel: UILabel!
  @IBOutlet weak var noPlaneLabel: UILabel!

  // MARK: - UIViewController overrides
  override func viewDidLoad() {
    super.viewDidLoad()
    updateUI()
  }

  // MARK: - private functions
  private func updateUI() {
    guard let plane = plane else {
      showNoPlaneLabel(true)
      return
    }
    showNoPlaneLabel(false)
    updateActivity(plane.isActive)
    updateImage()
    nameLabel.text = plane.hasName ? "Name: \(plane.name)" : "No name"
    update(label: idLabel, with: "ID:", content: plane.id)
    update(label: iataLabel, with: "iata:", content: plane.iata)
    update(label: icaoLabel, with: "icao:", content: plane.icao)
    update(label: callsignLabel, with: "Callsign:", content: plane.callsign)
    update(label: countryLabel, with: "Country:", content: plane.country)
  }

  private func updateActivity(_ isActive: Bool) {
    activeView.roundCorners()
    activeView.backgroundColor = isActive ? .green : .red
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
      imageView.kf.setImage(with: URL(string: imageString))
    }
  }

  private func update(label: UILabel, with title: String, content variableStr: String) {
    guard variableStr != "" else {
      label.isHidden = true
      return
    }
    label.isHidden = false
    label.text = "\(title) \(variableStr)"
  }

  private func showNoPlaneLabel(_ show: Bool) {
    noPlaneLabel.isHidden = !show
  }
}
