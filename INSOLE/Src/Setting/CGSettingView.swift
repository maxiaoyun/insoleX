//
//  CGSettingView.swift
//  INSOLE
//
//  Created by Sennotech on 2016/10/25.
//  Copyright © 2016年 Sennotech. All rights reserved.
//

import UIKit

typealias AccountDataStyle = (img:UIImage?,title:String?,subTitle:String?,desc:String?,numDesc:Int?)
class CGSettingView: CGMainView,UITableViewDelegate,UITableViewDataSource {
    
    var dataToShow:[[AccountDataStyle]] = [];
    var tab:UITableView?;
    override func createView(title: String?) {
        super.createView(title: title);
        self.backgroundColor = UIColor.colorWithRGBA(r: 0xF4, g: 0xF4, b: 0xF4, a: 255);
        dataToShow = [
            [
                (UIImage(named:"home.png"),"鞋垫管理",Optional.none,Optional.none,Optional.none),
                (UIImage(named:"sj.png"),"添加测试对象",Optional.none,Optional.none,Optional.none),
                ],
            [
                (UIImage(named:"wo.png"),"关于",Optional.none,Optional.none,Optional.none),
                ],
        ];
        
        tab = UITableView(frame: CGRect(x: 0, y: 64, width: self.w, height: self.h-64), style: .plain);
        tab?.delegate = self;
        tab?.dataSource = self;
        tab?.backgroundColor = UIColor.clear;
        tab?.rowHeight = 50;
        self.insertSubview(tab!, at: 0);
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return dataToShow.count;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataToShow[section].count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellId");
            if let _ = cell {
                
            }else{
                cell = UITableViewCell(style: .default, reuseIdentifier: "cellId");
                cell?.accessoryType = .disclosureIndicator;
                cell?.backgroundColor = UIColor.white;
                cell?.contentView.backgroundColor = UIColor.clear;
                
            }
            let data = dataToShow[indexPath.section][indexPath.row];
                cell?.textLabel?.text = data.title;
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 48/3.0);
                cell?.textLabel?.textColor = UIColor.colorWithRGB(r: 0x33, g: 0x33, b: 0x33);
        
        if indexPath.section==2 {
            cell?.accessoryType = .none;
            cell?.textLabel?.center = CGPoint(x: GP.W/2, y: 50/2);
            cell?.textLabel?.textColor = UIColor.red;
        }
        return cell!;
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10;
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 60;
        }
        return 1;
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.w, height: 1));
        view.backgroundColor = UIColor.bgColor();
        
        if section==1 {
            view.h = 60;
            let btn = UIButton(type: .system);
            btn.frame = CGRect(x: 25, y: 20, width: self.w-50, height: 40);
            btn.backgroundColor = UIColor.colorWithRGB(r: 0x30, g: 0x9f, b: 0xf7);
            btn.layer.cornerRadius = 5;
            btn.setTitle("退出登录", for: .normal);
            btn.addTarget(self, action: #selector(loginOutBtnClick), for: .touchUpInside);
            btn.setTitleColor(UIColor.white, for: .normal);
            view.addSubview(btn);
        }
        return view;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        switch (indexPath.section,indexPath.row) {
        case (0,0):
            let vc = CGMeasureVC();
            self.getNav?()?.pushViewController(vc, animated: true);
        case (0,1):
            let vc = ModifyInfoVC();
            self.getNav?()?.pushViewController(vc, animated: true);
            break;
        default:
            "";
        }
    }
    
    func loginOutBtnClick() {
        
        let storyBoard = UIStoryboard(name: "Login", bundle: nil);
        if let vc = storyBoard.instantiateInitialViewController() {
            self.getNav?()?.present(vc, animated: true, completion: {[weak self] in
                let vc = self?.getNav?()?.viewControllers[0] as? CGMainViewController;
                vc?.index = 0;
//                self?.backToPre();
            });
        }
    }
}
