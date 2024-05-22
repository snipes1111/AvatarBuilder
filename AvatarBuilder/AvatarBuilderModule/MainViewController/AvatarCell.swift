//
//  AvatarCell.swift
//  AvatarBuilder
//
//  Created by user on 21/05/2024.
//

import UIKit

final class AvatarCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func commonInit() {
        setupImageView()
    }
    
    private func setupImageView() {
        contentView.addSubview(imageView)
        imageView.fillSuperView(contentView)
    }
}

extension AvatarCell {
    func configureCell(with image: String) {
        imageView.image = UIImage(named: image)
    }
}
