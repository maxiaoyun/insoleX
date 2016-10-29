//
//  LYExtension.swift
//  Designer
//
//  Created by Myron on 16/6/15.
//  Copyright © 2016年 Myron. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable extension UIView{
    
    func addNavBar(title:String?,showBack:Bool,backTarget:AnyObject?,backAction:Selector) -> UIView! {
        let barView = UIView(frame: CGRect(x: 0, y: 0, width: self.w, height: 64));
        barView.backgroundColor = LYMainConfig.TAB_BAR_BG_COLOR;
        barView.addDefaultShadow();
        self.addSubview(barView);
        
        let titleLa = UILabel(frame: CGRect(x: 0, y: 20, width: self.w, height: 44));
        titleLa.font = UIFont.systemFont(ofSize: 56/3.0);
        titleLa.textAlignment = .center;
        titleLa.tag = 10086;
        titleLa.textColor = UIColor.black;
        titleLa.text = title;
        barView.addSubview(titleLa);
        
        if showBack {
            let backBtn = UIButton(type: .custom);
            backBtn.frame = CGRect(x: 0, y: 20, width: 44, height: 44)
            backBtn.setImage(UIImage(named: "back.png"), for: .normal);
            backBtn.imageEdgeInsets = UIEdgeInsetsMake(5+8, 15+8*42/68.0 - 5, 5+8, 8+8*42/68.0 + 5);
            backBtn.addTarget(backTarget, action: backAction, for: .touchUpInside);
            barView.addSubview(backBtn);
        }
        
        return barView;
    }
    
    func addDefaultShadow() {
        addShadowWithColor(color: UIColor.black);
    }
    func addShadowWithColor(color:UIColor!) {
        self.layer.shadowColor = color.cgColor;
        self.layer.shadowOpacity = 0.75;
        self.layer.shadowRadius = CGFloat(M_PI/8);
        self.layer.shadowOffset = CGSize.zero;
    }
    
    func addLineView(x:CGFloat,y:CGFloat,w:CGFloat) -> UIView {
        let lineView = UIView(frame: CGRect(x: x, y: y, width: w, height: 1));
//        lineView.backgroundColor = LYConfig.LINE_COLOR;
        self.addSubview(lineView);
        return lineView;
    }
}

extension NSDate {
    func stringWithFormatter(formatterStr:String!)->String {
        let formatter = DateFormatter();
        formatter.dateFormat = formatterStr;
        return formatter.string(from: self as Date);
    }
    static func dateFromStr(str:String!,formatterStr:String!) -> NSDate? {
        let formatter = DateFormatter();
        formatter.dateFormat = formatterStr;
        return formatter.date(from: str) as NSDate?;
    }
}

extension UIColor{
    static func bgColor()->UIColor!{
        return colorWithRGBA(r: 0xF4, g: 0xF4, b: 0xF4, a: 255);
    }
    static func colorWithRGB(r:UInt8,g:UInt8,b:UInt8)->UIColor!{
        return colorWithRGBA(r: r, g: g, b: b, a: 255);
    }
    static func colorWithRGBA(r:UInt8,g:UInt8,b:UInt8,a:UInt8)->UIColor!{
        return UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: CGFloat(a)/255)
    }
}
