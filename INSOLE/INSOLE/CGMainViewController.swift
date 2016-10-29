//
//  CGMainViewController.swift
//  INSOLE
//
//  Created by Sennotech on 2016/10/25.
//  Copyright © 2016年 Sennotech. All rights reserved.
//

import UIKit
class LYMainConfig {
    static let TAB_BAR_TEXT_FONT = UIFont.systemFont(ofSize: 32/3.0);
    static let TAB_BAR_DEFAULT_TEXT_COLOR =  UIColor.colorWithRGB(r: 0x99, g: 0x99, b: 0x99);
    static let TAB_BAR_SELECTED_TEXT_COLOR = UIColor.colorWithRGB(r: 0x66, g: 0x66, b: 0x66);
    static let TAB_BAR_BG_COLOR = UIColor.colorWithRGB(r: 0xF9, g: 0xF9, b: 0xF9);
}
class CGMainViewController: QMLViewController {

    var tabBar:QMLShapeView!;
    
    var currentView:CGMainView?;
    var lastIndex:Int! = 0;
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.index = lastIndex;
        currentView?.willShow();
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        currentView?.willHidden();
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.bgColor();
        let w = self.view.w;
        let h = self.view.h;
        
        tabBar = QMLShapeView(frame: CGRect(x: 0, y: h-60, width: w, height: 60));
        tabBar.backgroundColor = LYMainConfig.TAB_BAR_BG_COLOR;
        view.addSubview(tabBar);
        
        let items = [(UIImage(named: "home.png"),"步态测量"),(UIImage(named: "sj.png"),"步态报告"),(UIImage(named: "wo.png"),"设置")];
        for i in 0..<items.count {
            let str = items[i].1;
            let attStr = NSAttributedString(string: str, attributes: [
                NSFontAttributeName:LYMainConfig.TAB_BAR_TEXT_FONT,
                NSForegroundColorAttributeName:UIColor.lightGray
                ]);
            let itemView = QMLUnit.createView(with: items[i].0, imgScale: 1/3, span: 6, text: attStr, maxTextWidth: 0, textPosition: QMLDirectionDown);
            itemView?.tag = 10+i;
            itemView?.center = CGPoint(x: w*CGFloat(i)/3+w/6, y: 10+(tabBar.h-10)/2)
            tabBar.addSubview(itemView!);
            let control = UIControl(frame: CGRect(x: 0, y: 0, width: w/3, height: tabBar.h));
            control.center = (itemView?.center)!;
            control.tag = 100+i;
            control.addTarget(self, action: #selector(tabBarItemClick(control:)), for: .touchUpInside);
            tabBar.insertSubview(control, at: 0);
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(CGMainViewController.tabbarItemTap(tap:)));
            itemView?.isUserInteractionEnabled = true;
            itemView?.addGestureRecognizer(tap);
        }
        
        self.index = 0;
    }
    func tabBarItemClick(control:UIControl) {
        self.index = control.tag - 100;
    }
    func tabbarItemTap(tap:UITapGestureRecognizer) {
        self.index = tap.view!.tag - 10
    }
    var index:Int! = 0{
        willSet{
            lastIndex = index;
            let items = [(UIImage(named: "home.png"),UIImage(named: "home2.png"),"步态测量"),
                         (UIImage(named: "sj.png"),UIImage(named: "sj2.png"),"步态报告"),
                         (UIImage(named: "wo.png"),UIImage(named: "wo2.png"),"设置")];
            let view = tabBar.viewWithTag(10+index);
            if let imageView = view?.viewWithTag(1) as? UIImageView{
                imageView.image = items[index].0;
            }
            if let la = view?.viewWithTag(2) as? UILabel {
                la.attributedText = NSAttributedString(string: items[index].2, attributes: [
                    NSFontAttributeName:LYMainConfig.TAB_BAR_TEXT_FONT,
                    NSForegroundColorAttributeName:UIColor.lightGray
                    ]);
            }
        }
        didSet{
            let items = [(UIImage(named: "home.png"),UIImage(named: "home2.png"),"步态测量"),
                         (UIImage(named: "sj.png"),UIImage(named: "sj2.png"),"步态报告"),
                         (UIImage(named: "wo.png"),UIImage(named: "wo2.png"),"设置")];
            let view = tabBar.viewWithTag(10+index);
            if let imageView = view?.viewWithTag(1) as? UIImageView{
                imageView.image = items[index].1;
            }
            if let la = view?.viewWithTag(2) as? UILabel {
                la.attributedText = NSAttributedString(string: items[index].2, attributes: [
                    NSFontAttributeName:LYMainConfig.TAB_BAR_TEXT_FONT,
                    NSForegroundColorAttributeName:UIColor.black
                    ]);
            }
            makeCurrntViewShow()
        }
    }
    var measureView:CGMeasureView?;
    var repeportView:CGReportView?
    var settingView:CGSettingView?
    func makeCurrntViewShow() {
        let rect = CGRect(x: 0, y: 0, width: self.view.w, height: self.view.h-50);
        switch index {
        case 0:
            lastIndex = index;
            if let _ = measureView{
            }else{
                measureView = CGMeasureView(frame: rect);
                measureView?.createView(title: "步态测量");
                self.view.addSubview(measureView!);
            }
            currentView?.willHidden();
            measureView?.willShow();
            measureView?.isHidden = false;
            repeportView?.isHidden = true;
            settingView?.isHidden = true;
            currentView = measureView;
        case 1:
            lastIndex = index;
            if let _ = repeportView{
            }else{
                repeportView = CGReportView(frame: rect);
                repeportView?.createView(title: "步态报告");
                self.view.addSubview(repeportView!);
            }
            currentView?.willHidden();
            repeportView?.willShow();
            
            measureView?.isHidden = true;
            repeportView?.isHidden = false;
            settingView?.isHidden = true;
            
            currentView = repeportView;
        case 2:
            //判断是否登录，没有登录进行showLogin（）登录
            lastIndex = index;
            if let _ = settingView{
            }else{
                settingView = CGSettingView(frame: rect);
                settingView?.createView(title: "设置");
                self.view.addSubview(settingView!);
            }
            currentView?.willHidden();
            settingView?.willShow();
            
            measureView?.isHidden = true;
            repeportView?.isHidden = true;
            settingView?.isHidden = false;
            
            currentView = settingView;
        
        default:
            "";
        }
        currentView?.getNav = { [weak self](Void) in
            if let bSelf = self {
                return bSelf.navigationController;
            }
            return Optional.none;
        };
        self.view.bringSubview(toFront: tabBar);
    }
   
    func showLogin(){
        let storyBoard = UIStoryboard(name: "Login", bundle: nil);
        if let vc = storyBoard.instantiateInitialViewController() {
            self.present(vc, animated: true, completion: nil);
        }
    }

}
