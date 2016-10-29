//
//  YearAndMouthVC.swift
//  INSOLE
//
//  Created by Sennotech on 2016/10/28.
//  Copyright © 2016年 Sennotech. All rights reserved.
//

import UIKit
enum className: Int {
    case yearAndMouthClass
    case heightClass
    case weightClass
}
class YearAndMouthVC: QMLViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    var classType:className = .yearAndMouthClass;
    var bgView:UIView?;
    var yearArr : [String] = [];
    var mouthArr : [String] = [];
    var heightArr : [String] = [];
    var weightArr : [String] = [];
    let minYear:Int = 1900;
    let maxYear:Int = 2016;
    var doneAction:((_ content:String?)->Void)?;
    let minHeight:Int = 60;
    let maxHeight:Int = 210;
    let minWeight:Int = 40;
    let maxWeight:Int = 80;
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...12 {
            mouthArr.append(String(i));
        }
        for i in minYear...maxYear {
            yearArr.append(String(i));
        }
        for i in minHeight...maxHeight {
            heightArr.append(String(i));
        }
        for i in minWeight...maxWeight {
            weightArr.append(String(i));
        }
        // Do any additional setup after loading the view.
        let cnl = UIControl(frame: self.view.bounds);
        cnl.addTarget(self, action: #selector(backToPre), for: .touchUpInside);
        self.view = cnl;
        self.view.backgroundColor = UIColor.clear;
        createView();
    }

    func createView(){
        var titleStr:String?;
        switch classType {
        case .yearAndMouthClass:
            titleStr = "出生年月";
        case .heightClass:
            titleStr = "身高";
        case .weightClass:
            titleStr = "体重";
        default:
            ""
        }
        bgView = UIView(frame: CGRect(x: 50, y: 150, width: self.view.frame.size.width-100, height: self.view.frame.size.height-300));
        bgView?.backgroundColor = UIColor.lightGray;
        bgView?.clipsToBounds = true;
        bgView?.layer.cornerRadius = 8;
        self.view.addSubview(bgView!);
        
        var la : UILabel?;
        la = UILabel(frame: CGRect(x: 10, y: 20, width: (bgView?.w)!-20, height: 20));
        la?.text = titleStr;
        la?.textColor = UIColor.colorWithRGB(r: 0x30, g: 0x9f, b: 0xf7);
        la?.textAlignment = .center;
        la?.font = UIFont.systemFont(ofSize: 18);
        bgView?.addSubview(la!);
        
        var pickerView:UIPickerView?;
        pickerView = UIPickerView(frame: CGRect(x: 20, y: 50, width: (bgView?.w)!-40, height: (bgView?.h)!-88));
        pickerView?.clipsToBounds = true;
        pickerView?.layer.cornerRadius = 8;
        pickerView?.backgroundColor = UIColor.white;
        pickerView?.dataSource = self;
        pickerView?.delegate = self;
        pickerView?.showsSelectionIndicator = true;
        bgView?.addSubview(pickerView!);
    }
    //    列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        if classType == .yearAndMouthClass {
            return 2;
        }
        return 1;
    }
    //    行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
      if classType == .yearAndMouthClass {
            if component == 1 {
                return mouthArr.count
            }else if component == 0{
                return yearArr.count;
            }
      }else if classType == .heightClass{
        return heightArr.count;
        }
        return weightArr.count;
    }
    //    行的宽度
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if classType == .yearAndMouthClass {
            if component == 1 {
                return 50;
            }else if component == 0{
                return 150;
            }
        }
        return 150;
    }
    //    行的高度
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40;
    }
    //    每行显示的标题：
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         if classType == .yearAndMouthClass {
            if component == 1 {
                return mouthArr[row];
            }else if component == 0{
                return yearArr[row];
            }
         }else if classType == .heightClass{
            return heightArr[row];
        }
        return weightArr[row];
    }
    //    每行显示的标题字体、颜色等属性
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var attrubutiStr:NSAttributedString;
        var titleStr:String?;
        if classType == .yearAndMouthClass {
            if component == 1 {
                attrubutiStr = NSAttributedString(string: mouthArr[row], attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 25),NSForegroundColorAttributeName:UIColor.colorWithRGB(r: 0x30, g: 0x9f, b: 0xf7)]);
            }else{
                attrubutiStr = NSAttributedString(string: yearArr[row], attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 25),NSForegroundColorAttributeName:UIColor.colorWithRGB(r: 0x30, g: 0x9f, b: 0xf7)]).attributedSubstring(from: NSRange(location: 0, length: 4));
            }
        }else{
            if classType == .heightClass {
                titleStr = heightArr[row];
            }else if classType == .weightClass{
                titleStr = weightArr[row];
            }
            attrubutiStr = NSAttributedString(string: titleStr!, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 25),NSForegroundColorAttributeName:UIColor.colorWithRGB(r: 0x30, g: 0x9f, b: 0xf7)]);
        }
        return attrubutiStr;
    }
    //    被选择行
    var yearStr:String?;
    var mouthStr:String = "1";
    var yearAndMouthStr:String?;
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      if classType == .yearAndMouthClass {
        
        if component == 0 {
           yearStr = yearArr[row];
        }else if component == 1{
          mouthStr = mouthArr[row];
        }
        if yearStr != nil{
            yearAndMouthStr = yearStr!+"-"+mouthStr;
        }
        
            }else if classType == .heightClass{
                yearAndMouthStr = heightArr[row]+"cm";
            }else if classType == .weightClass{
                yearAndMouthStr = weightArr[row]+"kg";
        }
    }
    
    func backToPre(){
        var defalueStr:String?;
        if classType == .yearAndMouthClass {
            defalueStr = "1985-1";
        }else if classType == .heightClass{
            defalueStr = "175cm";
        }else if classType == .weightClass{
            defalueStr = "50kg";
        }
        if let fun = doneAction{
            fun(yearAndMouthStr ?? defalueStr);
        }
        self.dismiss(animated: true, completion: nil);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
