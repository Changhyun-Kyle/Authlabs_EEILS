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
    view = imageCollectionView
  }
  
  @objc
  func tappedPlusButton() {
    self.present(picker, animated: true)
  }
}

extension ImageViewController: UICollectionViewDataSource {
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
