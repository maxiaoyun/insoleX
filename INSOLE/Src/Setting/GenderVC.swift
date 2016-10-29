//
//  GenderVC.swift
//  INSOLE
//
//  Created by Sennotech on 2016/10/26.
//  Copyright © 2016年 Sennotech. All rights reserved.
//

import UIKit
enum LYSelectType {
    case Major
    case Specialty
    case City
    case Tag
    case Gendar
}
class GenderVC: QMLViewController,UITableViewDataSource,UITableViewDelegate {

    var type:LYSelectType?;
    
    var selectItemsCallback:((String?)->Void)?;
    var tab:UITableView?;
    var dataToShow:[String]! = [];
    
    var selelctedContentStr:String?;
    func backToPre()  {
        self.navigationController?.popViewController(animated: true);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.bgColor();
        self.view.addNavBar(title: self.title, showBack: true, backTarget: self, backAction: #selector(backToPre));
        
        loadData();
    }
    var selectedIndex:[Int]! = [];
    func doneBtnClick() {
        if let callback =  self.selectItemsCallback {
            var items:[String] = [];
            for i in selectedIndex {
                items.append(dataToShow[i]);
            }
            callback(items.joined(separator: ","));
        }
        self.backToPre();
    }
    func createView() {
        if let _ = tab {
            
        }else{
            tab = UITableView(frame:CGRect(x: 0, y: 64, width: self.view.w, height: self.view.h-64), style: .plain);
            tab?.delegate = self;
            tab?.dataSource = self;
            tab?.backgroundColor = UIColor.bgColor();
            self.view.insertSubview(tab!, at: 0);
            
            let doneBtn = UIButton(type:.system);
            doneBtn.frame = CGRect(x: self.view.w-50, y: 20, width: 44, height: 44);
            doneBtn.setTitle("确定", for: .normal);
            doneBtn.setTitleColor(UIColor.colorWithRGB(r: 0x30, g: 0x9f, b: 0xf7), for: .normal);
            doneBtn.addTarget(self, action: #selector(doneBtnClick), for: .touchUpInside);
            self.view.addSubview(doneBtn);
        }
    }
    func loadData() {
        dataToShow.append(contentsOf: ["男","女"]);
        createView()
    
    }
    func loadDataFinished(rev:[String : AnyObject]?) {
//        SVProgressHUD.dismiss();
//        switch type! {
//        case .Gendar:
//            dataToShow.append(contentsOf: ["男","女"]);
//        }
//        for i in 0..<dataToShow.count {
//            if self.selelctedContentStr?.containsString(dataToShow[i]) ?? false{
//                selectedIndex.append(i);
//            }
//        }
//        createView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataToShow!.count;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44;
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10;
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.w, height: 1));
        view.backgroundColor = UIColor.clear;
        return view;
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1;
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.w, height: 10));
        view.backgroundColor = UIColor.bgColor();
        return view;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellId");
        if let _ =  cell{
            
        }else{
            cell = UITableViewCell(style: .value1, reuseIdentifier: "cellId");
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 48/3.0);
            cell?.textLabel?.textColor = UIColor.colorWithRGB(r: 0x33, g: 0x33, b: 0x33);
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 48/3.0);
            cell?.detailTextLabel?.textColor = UIColor.colorWithRGB(r: 0x99, g: 0x99, b: 0x99);
            cell?.backgroundColor = UIColor.colorWithRGB(r: 0xFA, g: 0xFA, b: 0xFA);
            cell?.contentView.backgroundColor = UIColor.colorWithRGB(r: 0xFA, g: 0xFA, b: 0xFA);
        }
        if selectedIndex.contains(indexPath.row) {
            cell?.accessoryType = .checkmark;
        }else{
            cell?.accessoryType = .none;
        }
        let data = dataToShow[indexPath.row];
        cell?.textLabel?.text = data;
        return cell!;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true);
        let cell = tableView.cellForRow(at: indexPath as IndexPath);
        
        if self.type != .Specialty {
            selectedIndex.removeAll();
        }
        if selectedIndex.contains(indexPath.row) {
            selectedIndex.remove(at: selectedIndex.index(of: indexPath.row)!);
            cell?.accessoryType = .none;
        }else{
            selectedIndex.append(indexPath.row);
            cell?.accessoryType = .checkmark;
        }
        if self.type == .Specialty {
            if selectedIndex.count>5 {
                selectedIndex.removeLast();
                cell?.accessoryType = .none;
            }
        }else{
            doneBtnClick();
        }
    }
}
