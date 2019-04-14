//
//  GoogleNearby.swift
//  codeACity2
//
//  Created by Isaac Douglas on 13/04/19.
//  Copyright © 2019 codeACity2. All rights reserved.
//

import Foundation

struct GoogleNearby: Codable {
    var status: String
    var results: [Place]
}

struct Place: Codable {
    var name: String
    var icon: String
    var types: [String]
    var vicinity: String
}
