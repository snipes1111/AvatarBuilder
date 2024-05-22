//
//  MainViewController+CollectionView.swift
//  AvatarBuilder
//
//  Created by user on 21/05/2024.
//

import UIKit

extension MainViewController {
    
    func setupCollectionView() {
        imageCollectionView.register(AvatarCell.self,
                                     forCellWithReuseIdentifier: String(describing: AvatarCell.self))
        imageCollectionView.dataSource = self
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfImages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AvatarCell.self),
                                                            for: indexPath) as? AvatarCell else { fatalError() }
        let image = presenter.getImage(for: indexPath.item)
        cell.configureCell(with: image)
        return cell
    }
}
