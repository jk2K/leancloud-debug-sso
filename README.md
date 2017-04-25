## PrivateConstant.swift
内容如下

```swift
import Foundation

enum PrivateConstant: String {
    case leanCloudAppId = "your app id"
    case leanCloudAppKey = "your app key"
}
```


## 复现步骤
1. 新建 `PrivateConstant.swift`, 内容如上
2. Bundle Identifier 改为有推送通知权限的 Bundle ID
3. Xcode -> target -> Capabilities: 开启推送通知权限
4. 运行应用，点击登录 LeanCloud 按钮, 给予推送通知权限，进入后台，再回到前台，就会看到错误了

## 注意
测试时，只有第一次安装登录才会复现，后续运行是没有这个错误的, 然后一定要给予推送通知权限

如果不给予推送通知权限，也是无法复现错误的

