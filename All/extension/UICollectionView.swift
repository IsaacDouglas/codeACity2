//
//  UICollectionView.swift
//  codeACity2
//
//  Created by Isaac Douglas on 14/04/19.
//  Copyright © 2019 codeACity2. All rights reserved.
//

import UIKit

extension UICollectionView {
    func register(cell: UICollectionViewCell.Type) {
        let identifier = String(describing: cell.self)
        register(UINib.init(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
}

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
