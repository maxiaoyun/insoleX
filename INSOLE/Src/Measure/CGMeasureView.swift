//
//  CGMeasureView.swift
//  INSOLE
//
//  Created by Sennotech on 2016/10/25.
//  Copyright © 2016年 Sennotech. All rights reserved.
//

import UIKit


class measureCell: UITableViewCell {
    var titleLa:UILabel?;
    var titlStr:String?{
        didSet{
            if let _ = titleLa{
            }else{
                titleLa = UILabel(frame: CGRect(x: 10, y: 8, width: 100, height: 20));
                titleLa?.font = UIFont.systemFont(ofSize: 18);
                titleLa?.textColor = UIColor.black;
                titleLa?.textAlignment = .left;
                self.contentView.addSubview(titleLa!);
            }
            titleLa?.text = titlStr;
            let size = titleLa?.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude+20, height: 20));
            titleLa?.w = size!.width;
            
            for i in 0...1 {
                var leftImg : UIImageView;
                leftImg = UIImageView(frame: CGRect(x: 15, y: (titleLa?.h)!+10, width: 50, height: 50));
                leftImg.image = UIImage(named: "lined.png");
                leftImg.center = CGPoint(x: CGFloat(i)*(GP.W/2)+45, y: 65);
                self.contentView.addSubview(leftImg);
                
                var rightImg : UIImageView;
                rightImg = UIImageView(frame: CGRect(x: 80, y: (titleLa?.h)!+10, width: 20, height: 20));
                rightImg.image = UIImage(named: "sinhao.png");
                rightImg.center = CGPoint(x: CGFloat(i)*(GP.W/2)+100, y: 65);
                self.contentView.addSubview(rightImg);
            }
        }
    }
}


class CGMeasureView: CGMainView,UITableViewDelegate,UITableViewDataSource {
    var isHaveLinedBLU:Bool?;
    var tab : UITableView?;
    var dataSource:[String] = [];
    override func createView(title: String?) {
        super.createView(title: title);
        self.backgroundColor = UIColor.colorWithRGBA(r: 0xF4, g: 0xF4, b: 0xF4, a: 255);
        let upBtn = UIButton(type: .custom);
        upBtn.frame = CGRect(x: GP.W-50, y: 20, width: 44, height: 44)
        upBtn.setImage(UIImage(named: "search.png"), for: .normal);
        upBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 12*(56/60.0), 12, 12*(56/60.0));
        upBtn.addTarget(self, action: #selector(searchNewBLU), for: .touchUpInside);
        self.addSubview(upBtn);
        
        
        isHaveLinedBLU = true;
        dataSource = ["第一个","第二个","第三个打法是否"];
        if isHaveLinedBLU! {
            tab = UITableView(frame: CGRect(x: 0, y: 64, width: self.w, height: self.h-64), style: .plain);
            tab?.backgroundColor = UIColor.orange;
            tab?.delegate = self;
            tab?.dataSource = self;
            tab?.separatorStyle = .singleLine;
            tab?.backgroundColor = UIColor.white;
            tab?.rowHeight = 100;
            self.insertSubview(tab!, at: 0);
        }

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as? measureCell;
        
        if let _ = cell {
            
        }else{
            cell = measureCell(style: .default, reuseIdentifier: "cellId");
            cell?.accessoryType = .none;
            cell?.backgroundColor = UIColor.white;
            cell?.contentView.backgroundColor = UIColor.clear;
            
        }
        let data = dataSource[indexPath.row];
        cell?.titlStr = data;
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        let vc = Record3DVC();
        self.getNav?()?.pushViewController(vc, animated: true);
        
    }
    
    
    
    
    
    
    
    func searchNewBLU(){
        
    }
    
    
    

}
