//
//  ModifyInfoVC.swift
//  INSOLE
//
//  Created by Sennotech on 2016/10/26.
//  Copyright © 2016年 Sennotech. All rights reserved.
//

import UIKit

class ModifyInfoVC: QMLViewController,UITableViewDelegate,UITableViewDataSource {

    func backToPre()  {
        self.navigationController?.popViewController(animated: true);
    }
    var dataToShow:[(String?,String?)] = [];
    var tab:UITableView?;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.bgColor();
        self.view.addNavBar(title: "添加测试对象", showBack: true, backTarget: self, backAction: #selector(backToPre));

        tab = UITableView(frame:  CGRect(x: 0, y: 64, width: self.view.w, height: self.view.h-64), style: .plain);
        tab?.delegate = self;
        tab?.dataSource = self;
        tab?.backgroundColor = UIColor.colorWithRGB(r: 0xF4, g: 0xF4, b: 0xF4);
        self.view.insertSubview(tab!, at: 0);
        reloadData();
    }

    var gender = 0;
    var nikeNameStr:String?;
    var yearAndMouthStr:String?;
    var heightStr:String?;
    var weightStr:String?;
    var phoneStr:String?;
    func reloadData(){
        dataToShow = [("昵称",nikeNameStr),
                      ("性别",gender==0 ? "男" : "女"),
                      ("年月",yearAndMouthStr),
                      ("身高",heightStr),
                      ("体重",weightStr),
                      ("电话",phoneStr)
        ];
        tab?.reloadData();
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataToShow.count;
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: GP.W, height: 10));
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
            cell?.accessoryType = .disclosureIndicator;
        }
        let data = dataToShow[indexPath.row];
        cell?.textLabel?.text = data.0;
        cell?.detailTextLabel?.text = data.1;
        return cell!;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        var data = dataToShow[indexPath.row];
        switch indexPath.row {
        case 0:
            let nickNameVC = NickNameVC();
            nickNameVC.title = data.0;
            nickNameVC.palceHolder = "请输入昵称";
            nickNameVC.content = data.1;
            nickNameVC.doneAction = {[weak self](content:String?) in
                self?.nikeNameStr = content;
                if let bSelf = self{
                    bSelf.reloadData();
                }
            };
            self.navigationController?.pushViewController(nickNameVC, animated: true);
        case 1:
            let genderVC = GenderVC();
            genderVC.type = .Gendar;
            genderVC.title = data.0;
            switch gender {
            case 0:
                genderVC.selelctedContentStr = "男";
            case 1:
                genderVC.selelctedContentStr = "女";
            default:
                ""
            }
            genderVC.selectItemsCallback = {[weak self](item:String?) in
//                self?.gender = item == "男" ? 0 : 1;
                if let bSelf = self{
                    bSelf.gender = item == "男" ? 0 : 1;
                    bSelf.reloadData();
                }
            };
            self.navigationController?.pushViewController(genderVC, animated: true);
        case 2:
            let yearandMouthVC = YearAndMouthVC();
            yearandMouthVC.classType = .yearAndMouthClass;
            yearandMouthVC.modalPresentationStyle = .overCurrentContext;
            yearandMouthVC.doneAction = {[weak self](str:String?) in
                self?.yearAndMouthStr = str;
                if let bSelf = self{
                    bSelf.reloadData();
                }
            };
            self.present(yearandMouthVC, animated: true, completion: nil);
        case 3:
            let yearandMouthVC = YearAndMouthVC();
            yearandMouthVC.classType = .heightClass;
            yearandMouthVC.modalPresentationStyle = .overCurrentContext;
            yearandMouthVC.doneAction = {[weak self](str:String?) in
                self?.heightStr = str;
                if let bSelf = self{
                    bSelf.reloadData();
                }
            };
            self.present(yearandMouthVC, animated: true, completion: nil);
        case 4:
            let yearandMouthVC = YearAndMouthVC();
            yearandMouthVC.classType = .weightClass;
            yearandMouthVC.modalPresentationStyle = .overCurrentContext;
            yearandMouthVC.doneAction = {[weak self](str:String?) in
                self?.weightStr = str;
                if let bSelf = self{
                    bSelf.reloadData();
                }
            };
            self.present(yearandMouthVC, animated: true, completion: nil);
        case 5:
            let phoneVC = PhoneVC();
            phoneVC.title = data.0;
            phoneVC.palceHolder = "请输入电话号码";
            phoneVC.content = data.1;
            phoneVC.doneAction = {[weak self](content:String?) in
                self?.phoneStr = content;
                if let bSelf = self{
                    bSelf.reloadData();
                }
            };
            self.navigationController?.pushViewController(phoneVC, animated: true);
            
        default:
            "";
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
