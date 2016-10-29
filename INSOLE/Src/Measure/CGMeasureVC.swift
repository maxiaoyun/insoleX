//
//  CGMeasureVC.swift
//  INSOLE
//
//  Created by Sennotech on 2016/10/25.
//  Copyright © 2016年 Sennotech. All rights reserved.
//

import UIKit
typealias ManageredDataStyle = (title:String?,leftStr:String?,leftSubTitle:String?,rightStr:String?,rightSubTitle:String?);
typealias shouldSelectedDataStyle = (title:String?,leftOrRight:String?,distanceTitle:String?);
class CGManagerCell: UITableViewCell {
    var width = GP.W;
    var titleLa:UILabel?;
    var title:String?{
        didSet{
            if let _ = titleLa{
            }else{
                titleLa = UILabel(frame: CGRect(x: 0, y: 8, width: 100, height: 20));
                titleLa?.font = UIFont.systemFont(ofSize: 22);
                titleLa?.textColor = UIColor.black;
                titleLa?.textAlignment = .center;
                self.contentView.addSubview(titleLa!);
            }
            titleLa?.text = title;
            let size = titleLa?.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude+20, height: 20));
            titleLa?.w = size!.width;
            titleLa?.center = CGPoint(x: GP.W/2, y: 15);
        }
    }
    
    var leftLa:UILabel?;
    var leftTitle:String?{
        didSet{
            if let _ = leftLa{
            }else{
                leftLa = UILabel(frame: CGRect(x: 10, y: 35, width: (GP.W/2)-20, height: 20));
                leftLa?.font = UIFont.systemFont(ofSize: 15);
                leftLa?.textColor = UIColor.black;
                leftLa?.textAlignment = .left;
                self.contentView.addSubview(leftLa!);
            }
            leftLa?.text = leftTitle;
            let size = leftLa?.sizeThatFits(CGSize(width: (GP.W/2)-10, height: 25));
            leftLa?.w = size!.width;
            leftLa?.center = CGPoint(x: 1*(GP.W-10)/4, y: 50);
        }
    }
    var leftSubLa:UILabel?;
    var leftSubTitle:String?{
        didSet{
            if let _ = leftSubLa{
            }else{
                leftSubLa = UILabel(frame: CGRect(x: 10, y: 65, width: (GP.W/2)-20, height: 25));
                leftSubLa?.font = UIFont.systemFont(ofSize: 18);
                leftSubLa?.textColor = UIColor.black;
                leftSubLa?.textAlignment = .center;
                self.contentView.addSubview(leftSubLa!);
            }
            leftSubLa?.text = leftSubTitle;
            let size = leftSubLa?.sizeThatFits(CGSize(width: (GP.W/2)-10, height: 25));
            leftSubLa?.w = size!.width;
            leftSubLa?.center = CGPoint(x: 1*(GP.W-10)/4, y: 75);
        }
    }
    
    var rightLa:UILabel?;
    var rightTitle:String?{
        didSet{
            if let _ = rightLa{
            }else{
                rightLa = UILabel(frame: CGRect(x: 10, y: 35, width: (GP.W/2)-20, height: 20));
                rightLa?.font = UIFont.systemFont(ofSize: 15);
                rightLa?.textColor = UIColor.black;
                rightLa?.textAlignment = .left;
                self.contentView.addSubview(rightLa!);
            }
            rightLa?.text = rightTitle;
            let size = rightLa?.sizeThatFits(CGSize(width: (GP.W/2)-10, height: 25));
            rightLa?.w = size!.width;
            rightLa?.center = CGPoint(x: 3*(GP.W-20)/4, y: 50);
        }
    }

    var rightSubLa:UILabel?;
    var lineLa:UILabel?;
    var rightSubTitle:String?{
        didSet{
            if let _ = rightSubLa{
            }else{
                rightSubLa = UILabel(frame: CGRect(x: GP.W/2, y: 65, width: (GP.W/2)-20, height: 25));
                rightSubLa?.font = UIFont.systemFont(ofSize: 18);
                rightSubLa?.textColor = UIColor.black;
                rightSubLa?.textAlignment = .center;
                self.contentView.addSubview(rightSubLa!);
            }
            rightSubLa?.text = rightSubTitle;
            let size = rightSubLa?.sizeThatFits(CGSize(width: (GP.W/2)-10, height: 20));
            rightSubLa?.w = size!.width;
            rightSubLa?.center = CGPoint(x: 3*(GP.W-20)/4, y: 75);
            
            lineLa = UILabel(frame: CGRect(x: 10, y: 99, width: GP.W-20, height: 0.5));
            lineLa?.backgroundColor = UIColor.lightGray;
            self.contentView.addSubview(lineLa!);
        }
    }
    
    
}

class CGMeasureVC: QMLViewController,UITableViewDelegate,UITableViewDataSource {

    var tab:UITableView?;
    var dataSource:[ManageredDataStyle] = [];
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.bgColor();
        self.view.addNavBar(title: "鞋垫管理", showBack: true, backTarget: self, backAction: #selector(CGMeasureVC.backToPre));
        
        dataSource = [("第一个","左","左边简介","右","右边简介"),("第二个","左","第二个左边简介","右","第二个右边简介"),("第三个","左","左边三个简介","右","右边三个简介")];
        shouldSelectedDataSource = [("5456:656564","左","左边简介"),("5466hj:fxgd","右","第二个左边简介"),("sdfdsdf55:dsaf","左","左边三个简介"),("df:sdf","右","dfsdfdfdaff")];
        tab = UITableView(frame: CGRect(x: 0, y: 64, width: self.view.w, height: self.view.h-64), style: .plain);
        tab?.delegate = self;
        tab?.dataSource = self;
        tab?.separatorStyle = .singleLine;
        tab?.backgroundColor = UIColor.white;
        tab?.rowHeight = 100;
        self.view.insertSubview(tab!, at: 0);
        
        let searchBtnBtn = UIButton(type: .custom);
        searchBtnBtn.frame = CGRect(x: GP.W-50, y: 20, width: 44, height: 44)
        searchBtnBtn.setImage(UIImage(named: "search.png"), for: .normal);
        searchBtnBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 12*(56/60.0), 12, 12*(56/60.0));
        searchBtnBtn.addTarget(self, action: #selector(searchNewBtn), for: .touchUpInside);
        self.view.addSubview(searchBtnBtn);
        
        
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tab {
            return dataSource.count;
        }else{
            return shouldSelectedDataSource.count;
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView==tab {
            var cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as? CGManagerCell;
            if let _ = cell {
            }else{
                cell = CGManagerCell(style: .default, reuseIdentifier: "cellId");
                cell?.accessoryType = .none;
                cell?.width = self.view.w;
                cell?.backgroundColor = UIColor.white;
                cell?.contentView.backgroundColor = UIColor.clear;
            }
            let data = dataSource[indexPath.row];
            cell?.title = data.title;
            cell?.leftTitle = "左";
            cell?.rightTitle = "右";
            cell?.leftSubTitle = data.leftSubTitle;
            cell?.rightSubTitle = data.rightSubTitle;
            return cell!;
        }else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as? searchNewBLTCell;
            if let _ = cell {
            }else{
                cell = searchNewBLTCell(style: .default, reuseIdentifier: "cellId");
                cell?.accessoryType = .none;
                cell?.width = self.view.w;
                cell?.backgroundColor = UIColor.white;
                cell?.contentView.backgroundColor = UIColor.clear;
                
            }
            let data = shouldSelectedDataSource[indexPath.row];
            cell?.title = data.title;
            cell?.directionStr = data.leftOrRight;
            cell?.distanceStr = data.distanceTitle;
            return cell!;
        }
    }
    var selectedIndexArr:[Int] = [];
    var alterView : UIAlertController?;
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        let index = indexPath.row;
        if tableView == tabV {
            let searchCell : searchNewBLTCell = tabV?.cellForRow(at: indexPath) as! searchNewBLTCell;
            if searchCell.cellSelected {
                for (i,value) in selectedIndexArr.enumerated() {
                    if value == index {
                        selectedIndexArr.remove(at: i);
                    }
                }
                searchCell.cellSelected = false;
                searchCell.backgroundColor = UIColor.white;
                searchCell.accessoryType = .none;
            }else{
                selectedIndexArr.append(index);
                searchCell.cellSelected = true;
                searchCell.backgroundColor = UIColor.cyan;
                searchCell.accessoryType = .checkmark;
            }
        }else{
         let index = indexPath.row;
         var data = dataSource[index];
        alterView = UIAlertController();
        var newNameAction : UIAlertAction?;
        newNameAction = UIAlertAction(title: "重命名", style: .destructive, handler: { (void) in
           
            var textfiledVC : UIAlertController?;
            textfiledVC = UIAlertController(title: "重命名", message: "", preferredStyle: .alert);
            textfiledVC?.addTextField(configurationHandler: { (textFiled) in
                textFiled.textAlignment = .center;
                textFiled.placeholder = "请输入新的名称";
                
            });
           
            var alteraction : UIAlertAction?;
            alteraction = UIAlertAction(title: "确定", style: .destructive, handler: { (alterAction) in
                var tf:UITextField?;
                tf = textfiledVC?.textFields?.last;
                data.title = tf?.text;
                self.dataSource[index].title = data.title;
                self.tab?.reloadData();
            });
            textfiledVC?.addAction(alteraction!);
            self.present(textfiledVC!, animated: true, completion: nil);
        });
        
        alterView?.addAction(newNameAction!);
        var deleteAction : UIAlertAction?;
        deleteAction = UIAlertAction(title: "删除", style: .destructive, handler: { (void) in
            self.dataSource = [self.dataSource.remove(at: index)];
            self.tab?.reloadData();
        });
        alterView?.addAction(deleteAction!);
        var upAction : UIAlertAction?;
        upAction = UIAlertAction(title: "固件升级", style: .destructive, handler: { (void) in
            
        });
        alterView?.addAction(upAction!);
        self.present(alterView!, animated: false, completion: nil);
        }
    }
    
    var newView:UIView?;
    var tabV : UITableView?;
    var shouldSelectedDataSource:[shouldSelectedDataStyle] = [];
    func searchNewBtn(){
        var addBtn:UIButton?;
        if (newView != nil) {
        }else{
            newView = UIView(frame: CGRect(x: 0, y: 64, width: GP.W, height: GP.H-64));
            newView?.backgroundColor = UIColor.lightGray;
            
            addBtn = UIButton(type: .custom);
            addBtn?.frame = CGRect(x: 0, y: (newView?.h)!-44, width: GP.W, height: 44);
            addBtn?.backgroundColor = UIColor.colorWithRGB(r: 0x30, g: 0x9f, b: 0xf7);
            addBtn?.setTitle("添加", for: .normal);
            addBtn?.addTarget(self, action: #selector(releaseNewView), for: .touchUpInside);
            addBtn?.setTitleColor(UIColor.white, for: .normal);
            newView?.addSubview(addBtn!);
            self.view.addSubview(newView!);
            
            tabV = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.w, height: (newView?.h)!-44), style: .plain);
            tabV?.delegate = self;
            tabV?.dataSource = self;
            tabV?.separatorStyle = .singleLine;
            tabV?.backgroundColor = UIColor.white;
            tabV?.rowHeight = 80;
            newView?.insertSubview(tabV!, at: 0);
        }
    }
    
    func releaseNewView(){
        //先要判断添加几只，在判断是否是一双，如果是一双的话可以添加，如果不是  提示
        if selectedIndexArr.count==0||selectedIndexArr.count%2==1 {
            //提示“请选择鞋垫”
            print("请选择鞋垫");
        }else{
            //判断左右脚和唯一标示
            UIView.animate(withDuration: 0.5) {
                self.newView?.alpha = 0;
                self.newView = nil;
            }

        }
    }
    func backToPre(){
        self.navigationController?.popViewController(animated: true);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


class searchNewBLTCell: UITableViewCell {
    var width = GP.W;
    var cellSelected:Bool = false;
    var titleLa:UILabel?;
    var title:String?{
        didSet{
            if let _ = titleLa{
            }else{
                titleLa = UILabel(frame: CGRect(x: 0, y: 5, width: 100, height: 20));
                titleLa?.font = UIFont.systemFont(ofSize: 22);
                titleLa?.textColor = UIColor.black;
                titleLa?.textAlignment = .center;
                self.contentView.addSubview(titleLa!);
            }
            titleLa?.text = title;
            let size = titleLa?.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude+20, height: 20));
            titleLa?.w = size!.width;
        }
    }
    
    var directionLa:UILabel?;
    var directionStr:String?{
        didSet{
            if let _ = directionLa{
            }else{
                directionLa = UILabel(frame: CGRect(x: 10, y: 30, width: (GP.W/2)-20, height: 20));
                directionLa?.font = UIFont.systemFont(ofSize: 15);
                directionLa?.textColor = UIColor.black;
                directionLa?.textAlignment = .left;
                self.contentView.addSubview(directionLa!);
            }
            directionLa?.text = directionStr;
            let size = directionLa?.sizeThatFits(CGSize(width: (GP.W/2)-10, height: 20));
            directionLa?.w = size!.width;
        }
    }
    var distanceLa:UILabel?;
    var distanceStr:String?{
        didSet{
            if let _ = distanceLa{
            }else{
                distanceLa = UILabel(frame: CGRect(x: 10, y: 55, width: (GP.W/2)-20, height: 20));
                distanceLa?.font = UIFont.systemFont(ofSize: 18);
                distanceLa?.textColor = UIColor.black;
                distanceLa?.textAlignment = .center;
                self.contentView.addSubview(distanceLa!);
            }
            distanceLa?.text = distanceStr;
            let size = distanceLa?.sizeThatFits(CGSize(width: (GP.W/2)-10, height: 20));
            distanceLa?.w = size!.width;
        }
    }
}
