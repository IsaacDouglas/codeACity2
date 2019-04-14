//
//  Double.swift
//  codeACity2
//
//  Created by Isaac Douglas on 14/04/19.
//  Copyright © 2019 codeACity2. All rights reserved.
//

import Foundation

extension Double {
    func formatter(qtd: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.roundingMode = NumberFormatter.RoundingMode.halfUp
        formatter.maximumFractionDigits = qtd
        return formatter.string(from: self as NSNumber)!
    }
    
    func currencyFormatting() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self))!
    }
}
