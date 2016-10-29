//
//  CGReportView.swift
//  INSOLE
//
//  Created by Sennotech on 2016/10/25.
//  Copyright © 2016年 Sennotech. All rights reserved.
//

import UIKit

class CGReportView: CGMainView {
    override func createView(title: String?) {
        super.createView(title: title);
        self.backgroundColor = UIColor.colorWithRGBA(r: 0xF4, g: 0xF4, b: 0xF4, a: 255);
        
        let upBtn = UIButton(type: .custom);
        upBtn.frame = CGRect(x: GP.W-50, y: 20, width: 44, height: 44)
        upBtn.setImage(UIImage(named: "select.png"), for: .normal);
        upBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 12*(56/60.0), 12, 12*(56/60.0));
        upBtn.addTarget(self, action: #selector(upDataToServe), for: .touchUpInside);
        self.addSubview(upBtn);
    }

    func upDataToServe(){
        
    }

}
