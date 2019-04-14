//
//  ItemMap.swift
//  codeACity2
//
//  Created by Isaac Douglas on 14/04/19.
//  Copyright © 2019 codeACity2. All rights reserved.
//

import Foundation

struct ItemMap {
    var name: String
    var location: CLLocationCoordinate2D
    var zoom: Float
    var kml: String
    var predios: [Predio]
}

struct Predio {
    var name: String
    var location: CLLocationCoordinate2D
}
