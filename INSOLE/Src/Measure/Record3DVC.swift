//
//  Record3DVC.swift
//  INSOLE
//
//  Created by Sennotech on 2016/10/26.
//  Copyright © 2016年 Sennotech. All rights reserved.
//

import UIKit

class Record3DVC: QMLViewController {

    var leftConented:Bool = false;
    var rightContented:Bool = false;
    var recording:Bool = false;
    
    func backToPre()  {
        self.navigationController?.popViewController(animated: true);
    }

    var tipView:UIView?;
    var bottomBtn:UIButton?;
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.bgColor();
        self.view.addNavBar(title: "3D记录", showBack: true, backTarget: self, backAction: #selector(backToPre));
        // Do any additional setup after loading the view. 
        
        createNewView();
        self.perform(#selector(changeViewStyle), with: self, afterDelay: 3);
    }

    func createNewView(){
        if let _=tipView{
            let leftXH = tipView?.viewWithTag(1001) as? UIImageView;
            leftXH?.image = UIImage(named: "lightRightXH.png");
            let leftD = tipView?.viewWithTag(1002) as? UIImageView;
            leftD?.image = UIImage(named: "lightLiftD.png");
            let rightXH = tipView?.viewWithTag(1003) as? UIImageView;
            rightXH?.image = UIImage(named: "lightLeftXH.png");
            let rightD = tipView?.viewWithTag(1004) as? UIImageView;
            rightD?.image = UIImage(named: "lightRightD.png");
        }else{
            tipView = UIView(frame: CGRect(x: 0, y: 64, width: self.view.w, height: 30));
            tipView?.backgroundColor = UIColor.white;
            self.view.addSubview(tipView!);
            
            var leftXH : UIImageView?;
            leftXH = UIImageView(frame: CGRect(x: 50, y: 5, width: 20, height: 20));
            leftXH?.tag = 1001;
            leftXH?.image = UIImage(named: "rightXinhao.png");
            tipView?.addSubview(leftXH!);
            var leftD : UIImageView?;
            leftD = UIImageView(frame: CGRect(x: self.view.w/2-80, y: 5, width: 40, height: 20));
            leftD?.tag = 1002;
            leftD?.image = UIImage(named: "leftD.png");
            tipView?.addSubview(leftD!);
            
            var rightXH : UIImageView?;
            rightXH = UIImageView(frame: CGRect(x: self.view.w-70, y: 5, width: 20, height: 20));
            rightXH?.tag = 1003;
            rightXH?.image = UIImage(named: "sinhao.png");
            tipView?.addSubview(rightXH!);
            var rightD : UIImageView?;
            rightD = UIImageView(frame: CGRect(x: self.view.w/2+40, y: 5, width: 40, height: 20));
            rightD?.tag = 1004;
            rightD?.image = UIImage(named: "rightD.png");
            tipView?.addSubview(rightD!);
        }
        
        if !recording || bottomBtn == nil{
            bottomBtn = UIButton(type: .custom);
            bottomBtn?.frame = CGRect(x: 0, y: self.view.h-64, width: self.view.w, height: 64);
            bottomBtn?.backgroundColor = UIColor.lightGray;
            bottomBtn?.setTitle("正在校准数据", for: .normal);
            bottomBtn?.isUserInteractionEnabled = false;
            self.view.addSubview(bottomBtn!);
        }else{
            bottomBtn?.backgroundColor = UIColor.colorWithRGB(r: 0x30, g: 0x9f, b: 0xf7);
            bottomBtn?.setTitle("开始记录", for: .normal);
            bottomBtn?.isUserInteractionEnabled = true;
            bottomBtn?.addTarget(self, action: #selector(comeToRecord(btn:)), for: .touchUpInside);
        }
    }
    func changeViewStyle(){
        recording = true;
        createNewView();
    }
    func comeToRecord(btn:UIButton?){
        let testEditVC = TestEditVC();
        testEditVC.modalPresentationStyle = .overCurrentContext;
//        let device = UIDevice.current;
        self.present(testEditVC, animated: true, completion: nil);
        
    }
}




class TestEditVC: QMLViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    var maskView:UIView?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cnl = UIControl(frame: self.view.bounds);
        cnl.addTarget(self, action: #selector(backToPre), for: .touchUpInside);
        self.view = cnl;
        self.view.backgroundColor = UIColor.clear;
        createTestEditView();
    }
    func backToPre(){
        self.dismiss(animated: true, completion: nil);
    }
    func createTestEditView(){
        
        var scale:CGFloat = UIScreen.main.bounds.size.height/736;
        scale = 0.8;
        var x:CGFloat;
        x = 20;
        var font:UIFont;
        font = UIFont.systemFont(ofSize: 21);
        let platform : UBCPlatform = QMLUnit.currentPlatform();
        if platform==UBCPlatformI6||platform==UBCPlatformI6Plus {
            x = 40;
            font = UIFont.systemFont(ofSize: 21);
        }
        if (platform == UBCPlatformI6){
            scale = 0.85;
            font = UIFont.systemFont(ofSize: 18);
        }
        if (platform == UBCPlatformI5){
            scale = 0.65;
            font = UIFont.systemFont(ofSize: 18);
        }
        if (platform == UBCPlatformI4){
            scale = 0.65;
            font = UIFont.systemFont(ofSize: 18);
        }
        
        
        maskView = UIView(frame: CGRect(x: x, y: 120*scale, width: self.view.frame.size.width-2*x, height: self.view.frame.size.height-240*scale));
        maskView?.backgroundColor = UIColor.white;
        maskView?.clipsToBounds = true;
        maskView?.layer.cornerRadius = 8;
        self.view.addSubview(maskView!);
        
        var titleLa : UILabel?;
        titleLa = UILabel(frame: CGRect(x: 30, y: 30*scale, width: 100, height: 20));
        titleLa?.text = "测试项目";
        titleLa?.font = font;
        maskView?.addSubview(titleLa!);
        
        let imgNames:[String] = ["warkLight.png","run.png"];
        let textStr:[String] = ["步行","慢跑"];
        var warkView:UIView?;
        var str : NSAttributedString?;
        for i in 0...1 {
        str = NSAttributedString(string: textStr[Int(i)], attributes: [NSForegroundColorAttributeName:UIColor.lightGray]);
        let img : UIImage? = UIImage(named: imgNames[Int(i)]);
        warkView = QMLUnit.createView(with: img, imgScale: 1.5, span: 5, text: str, maxTextWidth: 0, textPosition: QMLDirectionDown);
        warkView?.frame = CGRect(x: 30+120*i, y: Int(80*scale), width: Int(100*scale), height: Int(100*scale));
        maskView?.addSubview(warkView!);
    }
    
    let laStr:[String] = ["测试时长","测试对象","测试标签"];
    let holder:[String] = ["额而发","大地方","收到对方答复"];
    for i in 0..<3 {
        var timeLa : UILabel?;
        timeLa = UILabel(frame: CGRect(x: 30, y: Int(230*scale)+i*80, width: 100, height: 20));
        timeLa?.text = laStr[Int(i)];
        timeLa?.font = font;
        maskView?.addSubview(timeLa!);
        var timeView:UIView?;
        timeView = UIView(frame: CGRect(x: 30, y: Int(267*scale)+i*80, width: Int((maskView?.frame.size.width)!-60), height: 40));
        timeView?.layer.borderColor = UIColor.colorWithRGB(r: 0x30, g: 0x9f, b: 0xf7).cgColor;
        timeView?.layer.borderWidth = 1;
        timeView?.layer.cornerRadius = 10;
        timeView?.tag = 1000+i;
        let viewTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeTimeOrPerson(tap:)));
        timeView?.addGestureRecognizer(viewTap);
        timeView?.clipsToBounds = true;
        maskView?.addSubview(timeView!);
        var textfieldTime:UITextField?;
        textfieldTime = UITextField(frame: CGRect(x: 5, y: 5.0*scale, width: (timeView?.frame.size.width)!-60, height: 30));
        textfieldTime?.placeholder = holder[Int(i)];
        textfieldTime?.isUserInteractionEnabled = false;
        textfieldTime?.tag = 2000+i;
        timeView?.addSubview(textfieldTime!);
        var moreBtn : UIButton?;
        moreBtn = UIButton(type: .custom);
        moreBtn?.isUserInteractionEnabled = false;
        moreBtn?.frame = CGRect(x: (timeView?.frame.size.width)!-60+5+20, y: 10.0*scale, width: 25, height: 20);
        let img : UIImage = UIImage(named: "down.png")!;
        moreBtn?.setImage(img, for: .normal);
        timeView?.addSubview(moreBtn!);
        if i == 1 {
        timeView?.frame = CGRect(x: 30, y: Int(267*scale)+i*80, width: Int((maskView?.frame.size.width)!-120), height: 40);
        textfieldTime?.frame = CGRect(x: 5, y: 5, width: (timeView?.frame.size.width)!-60, height: 30);
        moreBtn?.frame = CGRect(x: (timeView?.frame.size.width)!-60+5+20, y: 10, width: 25, height: 20);
        var addPersonBtn : UIButton?;
        addPersonBtn = UIButton(type: .contactAdd);
        addPersonBtn?.frame = CGRect(x: Int((timeView?.frame.size.width)!+10+30), y: Int(267*scale)+i*80, width: 30, height: 30);
        addPersonBtn?.addTarget(self, action: #selector(postToModifyInfoVC), for: .touchUpInside);
        maskView?.addSubview(addPersonBtn!);
    }
        if i == 2 {
        textfieldTime?.isUserInteractionEnabled = true;
        textfieldTime?.delegate = self;
        textfieldTime?.frame = CGRect(x: 5, y: 5.0*scale, width: (timeView?.frame.size.width)!-10, height: 30);
        moreBtn?.removeFromSuperview();
        }
    }
    
    var cancleBtn : UIButton?;
    var suerBtn : UIButton?;
        cancleBtn = UIButton(type: .custom);
        cancleBtn?.frame = CGRect(x: (maskView?.frame.size.width)!-170, y: (maskView?.frame.size.height)!-50*scale, width: 60, height: 30);
        cancleBtn?.setTitle("取消", for: .normal);
        cancleBtn?.backgroundColor = UIColor.colorWithRGB(r: 0x30, g: 0x9f, b: 0xf7);
        cancleBtn?.addTarget(self, action: #selector(backToPre), for: .touchUpInside);
        cancleBtn?.layer.cornerRadius = 5;
        cancleBtn?.clipsToBounds = true;
        maskView?.addSubview(cancleBtn!);
        
        suerBtn = UIButton(type: .custom);
        suerBtn?.frame = CGRect(x: (maskView?.frame.size.width)!-90, y: (maskView?.frame.size.height)!-50*scale, width: 60, height: 30);
        suerBtn?.setTitle("确定", for: .normal);
        suerBtn?.backgroundColor = UIColor.colorWithRGB(r: 0x30, g: 0x9f, b: 0xf7);
        suerBtn?.layer.cornerRadius = 5;
        suerBtn?.clipsToBounds = true;
        maskView?.addSubview(suerBtn!);
}
func postToModifyInfoVC(){
//    let infoVC = ModifyInfoVC();
//    self.navigationController?.pushViewController(infoVC, animated: true);
}


    let timeDataSource:[String] = ["1分钟","5分钟","10分钟","30分钟","1小时"];
    let personDataSouce:[String] = ["张三","李四","王五"];
    var textFieldIndex:Int = 0;
    func changeTimeOrPerson(tap:UITapGestureRecognizer){
        let index : Int = (tap.view?.tag)!-1000;
        textFieldIndex = index;
        switch index {
        case 0,1:
            createTableView(view: tap.view!);
        default:
            "";
        }
    }
    var tab : UITableView?;
    func createTableView(view:UIView?){
        let bgView : UIView? = view?.superview;
        tab = UITableView(frame: CGRect(x: 30, y: Int(view!.frame.origin.y+view!.frame.size.height), width: Int((bgView?.frame.size.width)!-60), height: 150), style: .plain);
        tab?.rowHeight = 30;
        tab?.delegate = self;
        tab?.dataSource = self;
        bgView?.addSubview(tab!);
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if textFieldIndex != 1 {
            return timeDataSource.count;
        }else{
            return personDataSouce.count;
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellId");
        if let _ = cell {
        }else{
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellId");
            cell?.accessoryType = .none;
            cell?.backgroundColor = UIColor.white;
            cell?.contentView.backgroundColor = UIColor.clear;
        }
        var dataSouce : [String];
        if textFieldIndex != 1{
            dataSouce = timeDataSource;
        }else{
            dataSouce = personDataSouce;
        }
        let data = dataSouce[indexPath.row];
        cell?.textLabel?.text = data;
        return cell!;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        var dataSouce : [String];
        if textFieldIndex != 1{
            dataSouce = timeDataSource;
        }else{
            dataSouce = personDataSouce;
        }
        let data = dataSouce[indexPath.row];
        let textV : UIView? = maskView?.viewWithTag(1000+textFieldIndex);
        let textFieldV : UITextField? = textV?.viewWithTag(2000+textFieldIndex) as! UITextField?;
        textFieldV?.text = data;
        tab?.removeFromSuperview();
        tab = nil;
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.5) {
            self.maskView?.frame = CGRect(x: (self.maskView?.frame.origin.x)!, y: (self.maskView?.frame.origin.y)!-100, width: (self.maskView?.frame.size.width)!, height: (self.maskView?.frame.size.height)!);
        }
        return true;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        UIView.animate(withDuration: 0.5) {
            self.maskView?.frame = CGRect(x: (self.maskView?.frame.origin.x)!, y: (self.maskView?.frame.origin.y)!+100, width: (self.maskView?.frame.size.width)!, height: (self.maskView?.frame.size.height)!);
        }
        return true;
    }
}
