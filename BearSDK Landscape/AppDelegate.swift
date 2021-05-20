//
//  AppDelegate.swift
//  BearSDK Landscape
//
//  Created by Vladimir Nitochkin on 19.05.2021.
//

import UIKit
import BearGL
import BearSDK

// allows orientation changes after init
// for example camera output would be displayed wrong if app was first open from landscape orientation
class OrientationAdaptableARViewController: ARViewController {
    
    override var shouldAutorotate: Bool {
        true
    }
}

private class PassingTouchesWindow: UIWindow {
    unowned var touchesTargetWindow: UIWindow!
    
    static func create(passingTo otherWindow: UIWindow) -> PassingTouchesWindow {
        let window = PassingTouchesWindow(frame: UIScreen.main.bounds)
        window.touchesTargetWindow = otherWindow
        return window
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchesTargetWindow.rootViewController?.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        touchesTargetWindow.rootViewController?.touchesMoved(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        touchesTargetWindow.rootViewController?.touchesCancelled(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        touchesTargetWindow.rootViewController?.touchesEnded(touches, with: event)
    }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var arController: ARViewController!
    var uiWindow: UIWindow!
    
    static let secretKey = """
    VD8L/DzF+CP7nWyTkW59mnVAT2asg3hC4e1SyfWdHY4R7Hphw34kB/q5v3e12cYivlAijX6p9s4DvfDHfjYuifrXgkESQD7KL1wjDWfTl5plzi/XDSNTOAyYVazyKL6U+PU5lWL2H2dfAGDJjGevfGlCiLyhhyMHZCt0zWdmvpBFTq1dp2rD/g3XMpx5dNinYDNIMdrSEg4RDACsULmTMgt2bVVkNRTUlb0CTEO2krZll1uCtzTpGa6VmMo8KNvnqF2NGZUxC4yxS/rqwSAVclaUL6E5Qi6p06s6gseAfbkW2h5mnbdNjfqPvt51BzutD2nCFLs+bolqYzOAv6O3W4h7Xm20TE1YmCESzShmlsaYDAOWv69UELBr2OxP7fn1UH+xy/ulZLTPUBV0b78Nkmwgnrq6mmzlxWiYMnI3zBxxfrWMMJ3v/yN9Xb+g5zxVHPc+P+ZQk2ESNINVSukVz9aZYJKGEz8w2kkErCpBSiE6KtHJ/cEKKu0E3nvS6T/FAliC1Xj4NcUrFlbFTnk8Dmzz2bVnMMkE7dC8SvqgLNqmdybckJ2sDI8I+pcsKNH6QBDP0Nbo5jH+vQtqAuWKErEH/rqhjcBWoL8OrbM2dJptaCivbtQw4ZCXkEeoWMtWvgD2QJnBWWqDo3VVCsD7aCHyhtP1f59z4iGLBw1qu9JsWrO2TRyz6kcLVggC6/wPU1eecYUTRLsXHf4iYgmJ4R2QbHy826BvDKAdBqcsxkPpK1kk22h9hWCiiKtz72ji6Ml2IXI0T4hjWJuMDSlBXRrcmaVCn+WLoMe+00dm5fZGQgpyKEYYC+ID9cUCNiqrEfInjA5yiPveTsRCTpTKO3jiHrV3tMS+Po/aFRUos3OdGewFfulpkCNOJZE0cKZjCEec0igyHzacsAbSLZoPyoDYeVdjFxV1J97CgNxv9ERR5yOjWZyev3X80rLwtWQeeOIetXe0xL4+j9oVFSizc8tUq6e0/MK+fVZyMO3rvgbtzZxh5V+avwK9oVgxT9Fj
    """
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Bear initialization
        try! BearSDK.setSecretKey(AppDelegate.secretKey)
        print("device id \(BearSDK.shared.deviceId)")

        // init ar layer window
        let arWindow = UIWindow()
        arController = OrientationAdaptableARViewController()
        arWindow.rootViewController = arController
        arWindow.makeKeyAndVisible()
        window = arWindow
        
        // init ui layer window
        // should pass touches, because otherwise asset touches and gestures won't be triggered
        uiWindow = PassingTouchesWindow.create(passingTo: arWindow)
        uiWindow.windowLevel = .normal + 1
        uiWindow.rootViewController = UIStoryboard(name: "Initial", bundle: nil).instantiateInitialViewController()
        uiWindow.makeKeyAndVisible()
       
        return true
    }
}

