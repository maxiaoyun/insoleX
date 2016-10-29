//
//  CGMainView.swift
//  INSOLE
//
//  Created by Sennotech on 2016/10/25.
//  Copyright © 2016年 Sennotech. All rights reserved.
//
import Foundation
import UIKit

class CGMainView: QMLView {

    var getNav:((Void)->UINavigationController?)?;
    func createView(title:String?) {
        self.addNavBar(title: title, showBack: false, backTarget: nil, backAction:#selector(CGMainView.back));
    }
    func willShow() {
        
    }
    func willHidden(){
        
    }
    func back(){
        
    }

}
