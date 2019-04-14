//
//  DetailItemMapViewController.swift
//  codeACity2
//
//  Created by Isaac Douglas on 14/04/19.
//  Copyright © 2019 codeACity2. All rights reserved.
//

import UIKit

class DetailItemMapViewController: UIViewController {

    var item: ItemMap!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let back = UIBarButtonItem(title: "Voltar", style: .plain, target: self, action: #selector(self.backAction))
        self.navigationItem.leftBarButtonItem = back
    }
    
    @objc func backAction() {
        self.dismiss(animated: true, completion: nil)
    }

}
