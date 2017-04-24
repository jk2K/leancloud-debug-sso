//
//  Constant.swift
//  leancloud-debug-sso
//
//  Created by Meng Ye on 2017/4/24.
//  Copyright © 2017年 jk2K. All rights reserved.
//

import Foundation

enum UserDefaultKey: String {
    // uuid
    case uuid                       = "com.test.leanCloud.uuid"
}

struct LeanCloudConfig {
    static let appId: String = PrivateConstant.leanCloudAppId.rawValue
    static let appKey: String = PrivateConstant.leanCloudAppKey.rawValue
}
