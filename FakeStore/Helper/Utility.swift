//
//  Utility.swift
//  Calendar App
//
//  Created by Abhishek Kurmi on 23/06/23.
//

import UIKit
import SVProgressHUD


class Utility: NSObject {
    
    
    // MARK: Loading View
    class func showLoadingView() {
        let defaultColor = UIColor.black
        SVProgressHUD.show()
        SVProgressHUD.setForegroundColor(defaultColor)
        SVProgressHUD.setDefaultMaskType(.black)
    }
    
    class func showLoadingView(withTitle title: String) {
        SVProgressHUD.show(withStatus: title)
        SVProgressHUD.setDefaultMaskType(.black)
    }
    
    class func hideLoadingView() {
        SVProgressHUD.dismiss()
    }

}
