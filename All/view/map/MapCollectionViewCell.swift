//
//  MapCollectionViewCell.swift
//  codeACity2
//
//  Created by Isaac Douglas on 14/04/19.
//  Copyright © 2019 codeACity2. All rights reserved.
//

import UIKit

class MapCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.roundedCorners()
    }

}
