//
//  ViewController.swift
//  leancloud-debug-sso
//
//  Created by Meng Ye on 2017/4/24.
//  Copyright © 2017年 jk2K. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let UUID: String = "test-uuid"
        LeanCloudManager.shared.setup(with: UUID)
        UserDefaults.standard.set(UUID, forKey: UserDefaultKey.uuid.rawValue)
        UserDefaults.standard.synchronize()
    }

    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        LeanCloudManager.shared.client?.close(callback: { (success, error) in
            if let error = error {
                print(error.localizedDescription)
            }
        })
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.uuid.rawValue)
        UserDefaults.standard.synchronize()
    }
}

