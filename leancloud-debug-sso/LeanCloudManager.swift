//
//  LeanCloudManager.swift
//  leancloud-debug-sso
//
//  Created by Meng Ye on 2017/4/24.
//  Copyright © 2017年 jk2K. All rights reserved.
//

import Foundation
import AVOSCloudIM

class LeanCloudManager: NSObject {
    /// singleton
    static let shared = LeanCloudManager()
    
    /// leanCloud client
    var client: AVIMClient?
    
    fileprivate override init() {
        super.init()
    }
    
    func setup(with UUID: String) {
        let client = AVIMClient(clientId: UUID, tag: "Mobile")
        client.delegate = self
        let option = AVIMClientOpenOption()
        option.force = true
        client.open(with: option) { succeeded, error in
            if let _error: NSError = error as NSError? {
                print(_error)
            }
        }
        self.client = client
    }
    
}

// MARK: AVIMClientDelegate
extension LeanCloudManager: AVIMClientDelegate {
    func client(_ client: AVIMClient, didOfflineWithError error: Error) {
        let error: NSError = error as NSError
        
        if error.code == 4111 {
            print(error)
        } else {
            print(error)
        }
    }
    
}
