//
//  HorizontalCollectionView.swift
//  AvatarBuilder
//
//  Created by user on 20/05/2024.
//

import UIKit

final class HorizontalCollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    convenience init(view: UIView, numberOfItems: CGFloat) {
        let builder = CompositionalLayoutBuilder(view: view, numberOfItems: numberOfItems)
        let layout = builder.createLayout()
        self.init(frame: .zero, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class CompositionalLayoutBuilder {
    
    private let view: UIView
    private let numberOfItems: CGFloat
    private let interItemInsets: CGFloat
    
    private var fraction: CGFloat { 1 / numberOfItems }
    private var figuredItemWidth: CGFloat { view.bounds.width / numberOfItems }
    private var sideInsets: CGFloat { view.bounds.width / 2 - figuredItemWidth / 2 }
    
    init(view: UIView, numberOfItems: CGFloat, interItemInsets: CGFloat = 0) {
        self.view = view
        self.numberOfItems = numberOfItems
        self.interItemInsets = interItemInsets
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let section = createSectionWithScaleAnimation()
        return .init(section: section)
    }
    
    private func createItem() -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        return item
    }
    
    private func createGroup() -> NSCollectionLayoutGroup {
        let item = createItem()
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        return group
    }
    
    private func createSectionWithScaleAnimation() -> NSCollectionLayoutSection {
        let group = createGroup()
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: sideInsets, bottom: 16, trailing: sideInsets)
        section.orthogonalScrollingBehavior = .paging
        section.addScaleAnimation()
        return section
    }
}

extension NSCollectionLayoutSection {
    func addScaleAnimation(minScale: CGFloat = 0.7, maxScale: CGFloat = 1.1) {
        visibleItemsInvalidationHandler = { (items, offset, environment) in
            items.forEach { item in
                let distanceForCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2)
                let scale = max(maxScale - (distanceForCenter / environment.container.contentSize.width), minScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
    }
}
