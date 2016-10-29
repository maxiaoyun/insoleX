//
//  PhoneVC.swift
//  INSOLE
//
//  Created by Sennotech on 2016/10/29.
//  Copyright © 2016年 Sennotech. All rights reserved.
//

import UIKit

class PhoneVC: QMLViewController,UITextFieldDelegate {
    var cntTf:UITextField?;
    var palceHolder:String?;
    var content:String?;
    var keyboardType:UIKeyboardType?;
    var doneAction:((_ content:String?)->Void)?;
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.bgColor();
        self.view.addNavBar(title: self.title, showBack: true, backTarget: self, backAction: #selector(backToPre));
        
        let w = self.view.w;
        let h = self.view.h;
        let bgView = UIView(frame: CGRect(x: 0, y: 74, width: w, height: 40));
        bgView.backgroundColor = UIColor.colorWithRGB(r: 0xff, g: 0xff, b: 0xff);
        self.view.addSubview(bgView);
        
        cntTf = UITextField(frame:CGRect(x: 15, y: 10, width: w-30, height: 30));
        cntTf?.center = CGPoint(x: w/2, y: bgView.h/2);
        cntTf?.placeholder = palceHolder;
        cntTf?.textColor = UIColor.colorWithRGB(r: 0x66, g: 0x66, b: 0x66);
        cntTf?.font = UIFont.systemFont(ofSize: 44/3.0);
        cntTf?.text = content;
        cntTf?.delegate = self;
        cntTf?.keyboardType = keyboardType ?? .phonePad
        cntTf?.returnKeyType = .done;
        bgView.addSubview(cntTf!);
        
        bgView.addDefaultShadow()
        
        let doneBtn = UIButton(type:.system);
        doneBtn.frame = CGRect(x: w-50, y: 20, width: 44, height: 44);
        doneBtn.setTitle("保存", for: .normal);
        doneBtn.setTitleColor(UIColor.colorWithRGB(r: 0x30, g: 0x9f, b: 0xf7), for: .normal);
        doneBtn.addTarget(self, action: #selector(doneBtnClick), for: .touchUpInside);
        self.view.addSubview(doneBtn);
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        cntTf?.becomeFirstResponder();
    }
    
    func validateAccount(phoneStr:String)->Bool{
        let phoneRegex = "[0-9]{8,15}"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@",phoneRegex)
        return phoneTest.evaluate(with: phoneStr);
    }
    func doneBtnClick() {
        if let fun = doneAction{
            fun(cntTf?.text);
        }
        let isPhone = self.validateAccount(phoneStr: (cntTf?.text)!);
        if isPhone {
            backToPre();
        }else{
            //提示号码有误
        }
        
    }
    func textViewDidChange(_ textView: UITextView) {
        if let tx = textView as? QMLTextView{
            tx.textChanged();
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return false;
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder();
            return false;
        }
        return true;
    }
    //    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    //        self.view.endEditing(true);
    //    }
    func backToPre()  {
        self.navigationController?.popViewController(animated: true);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
