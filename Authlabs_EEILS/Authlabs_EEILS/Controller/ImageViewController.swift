//
//  ImageViewController.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/29/24.
//

import UIKit
import PhotosUI

final class ImageViewController: UIViewController {
  private var configuration = PHPickerConfiguration(photoLibrary: .shared())
  private lazy var picker = PHPickerViewController(configuration: configuration)
  private let imageCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.width / 2)
    collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
    return collectionView
  }()
  private var images: [UIImage] = .init()
  private let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

  override func loadView() {
    super.loadView()
    configureUI()
  }
}

private extension ImageViewController {
  func configureUI() {
    configuration.selectionLimit = 0
    self.title = "마커 등록"
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .add,
      target: self,
      action: #selector(tappedPlusButton)
    )
    navigationItem.rightBarButtonItem?.tintColor = .systemOrange
    picker.delegate = self
    imageCollectionView.dataSource = self
    imageCollectionView.delegate = self
    view = imageCollectionView
  }
  
  @objc
  func tappedPlusButton() {
    self.present(picker, animated: true)
  }
}

extension ImageViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return images.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard 
      let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: ImageCell.identifier,
      for: indexPath) as? ImageCell
    else {
      return ImageCell()
    }
    let image = images[indexPath.row]
    cell.configure(image: image)
    return cell
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
      let width = collectionView.frame.width
      let height = collectionView.frame.height
      let itemsPerRow: CGFloat = 2
      let widthPadding = sectionInsets.left * (itemsPerRow + 1)
      let itemsPerColumn: CGFloat = 3
      let heightPadding = sectionInsets.top * (itemsPerColumn + 1)
      let cellWidth = (width - widthPadding) / itemsPerRow
      let cellHeight = (height - heightPadding) / itemsPerColumn
      
      return CGSize(width: cellWidth, height: cellHeight)
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

extension ImageViewController: PHPickerViewControllerDelegate {
  func picker(
    _ picker: PHPickerViewController,
    didFinishPicking results: [PHPickerResult]
  ) {
    picker.dismiss(animated: true)
    let group = DispatchGroup()
    results.forEach {
      group.enter()
      $0.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] result, error in
        defer {
          group.leave()
        }
        guard
          let image = result as? UIImage,
          error == nil
        else {
          return
        }
        self?.images.append(image)
      }
    }
    group.notify(queue: .main) {
      self.imageCollectionView.reloadData()
    }
  }
}
