//
//  PlaneCollectionViewController.swift
//  Sitas
//
//  Created by steph on 4/29/21.
//

import UIKit
import SnapKit

class PlaneCollectionViewController: UICollectionViewController {
  // MARK: - public vars
  private var allPlanes: [Plane]? {
    didSet {
      guard isViewLoaded else { return }
      updateUI()
    }
  }

  // MARK: - private vars

  // collection view parameters
  private let itemsPerRow: CGFloat = 3
  private let sectionInsets = UIEdgeInsets(
    top: 20.0,
    left: 20.0,
    bottom: 20.0,
    right: 20.0)
  private let cellReuseIdentifier = "PlaneCell"

  // UI elements
  private var activityIndicator = UIActivityIndicatorView(style: .large)
  private var noPlanesLabel = UILabel()

  // search results
  private var searchTerm: String? {
    didSet {
      guard isViewLoaded else { return }
      updateUI()
    }
  }

  private var searchResults: [Plane]? {
    guard let searchTerm = searchTerm else {
      return allPlanes
    }
    return allPlanes?.filter { $0.name.contains(searchTerm) }
  }

  // MARK: - UIViewController lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    configureUI()
    startActivityIndicator()
    collectionView.isHidden = true
    loadPlanes {
        self.stopActivityIndicator()
        self.updateUI()
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == Sitas.SegueId.goToDetail,
       let detailViewController = segue.destination as? PlaneDetailViewController,
       let cell = sender as? PlaneCell else {
      return
    }
    detailViewController.plane = cell.plane
  }

  // MARK: - private functions
  private func loadPlanes(completion: (() -> Void)? = nil) {
    APIService.shared.fetchPlanes { planes, errorString in
      guard errorString == nil else {
        let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        completion?()
        self.present(alert, animated: true)
        return
      }
      guard let planes = planes else {
        debugPrint("No planes retreived or not in valid format")
        completion?()
        return
      }
      debugPrint("Retrieved \(planes.count) planes")
      self.allPlanes = planes
      completion?()
    }
  }

  private func configureUI() {
    view.backgroundColor = .white

    // activity indicator
    view.addSubview(activityIndicator)
    activityIndicator.hidesWhenStopped = true
    activityIndicator.center = view.center

    // no planes label
    view.addSubview(noPlanesLabel)
    noPlanesLabel.textAlignment = .center
    noPlanesLabel.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    noPlanesLabel.text = "No planes to display"
    noPlanesLabel.isHidden = true
  }

  private func updateUI() {
    guard let searchResults = searchResults,
          searchResults.count > 0 else {
      planesToShow(false)
      return
    }
    planesToShow(true)
    collectionView.reloadData()
  }

  private func planesToShow(_ show: Bool) {
    noPlanesLabel.isHidden = show
    collectionView.isHidden = !show
  }

  private func startActivityIndicator() {
    activityIndicator.startAnimating()
  }

  private func stopActivityIndicator() {
    activityIndicator.stopAnimating()
  }
}

// MARK: - UICollectionViewDataSource
extension PlaneCollectionViewController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let searchResults = searchResults else {
      return 0
    }
    return searchResults.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? PlaneCell else {
      debugPrint("Error: dequeued cell is not a PlaneCell")
      return PlaneCell()
    }
    cell.plane = searchResults?[indexPath.row]
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PlaneCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView( _ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
      let paddingSpace = (itemsPerRow + 1) * sectionInsets.left
      let availableWidth = view.frame.width - paddingSpace
      let widthPerItem = availableWidth / itemsPerRow
      return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(
      _ collectionView: UICollectionView,
      layout collectionViewLayout: UICollectionViewLayout,
      insetForSectionAt section: Int
    ) -> UIEdgeInsets {
      return sectionInsets
    }

    func collectionView(
      _ collectionView: UICollectionView,
      layout collectionViewLayout: UICollectionViewLayout,
      minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
      return sectionInsets.left
    }
}

// MARK: - Text Field Delegate
extension PlaneCollectionViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let text = textField.text, text != "" {
      searchTerm = text
    } else {
      searchTerm = nil
    }
    textField.resignFirstResponder()
    return true
  }
}
