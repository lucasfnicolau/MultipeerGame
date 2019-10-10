//
//  MenuViewController.swift
//  MultipeerMadness
//
//  Created by Matheus Silva on 10/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GameViewController {
            if segue.identifier == "create" {
                vc.name = "host"
            } else {
                vc.name = "client"
            }
        }
    }
}
