//
//  LoginVC.swift
//  INSOLE
//
//  Created by Sennotech on 2016/10/29.
//  Copyright © 2016年 Sennotech. All rights reserved.
//

import UIKit

class LoginVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var logoIm: UIImageView!
    @IBOutlet weak var phoneTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addNavBar(title: "登录", showBack: true, backTarget: self, backAction: #selector(backToPre));

        // Do any additional setup after loading the view.
        phoneTf.delegate = self;
        passwordTf.delegate = self;
        self.view.backgroundColor = UIColor.bgColor();
        logoIm.center = CGPoint(x: self.view.w/2, y: logoIm.center.y);
        
        contentView.layer.shadowColor = UIColor.bgColor().cgColor;
        contentView.layer.shadowOpacity = 0.75;
        contentView.layer.shadowRadius = CGFloat(M_PI/8);
        contentView.layer.shadowOffset = CGSize.zero;
    }

    
    @IBAction func loginBtnClick(_ sender: AnyObject) {
        guard let _ = phoneTf.text else{
//            SVProgressHUD.showErrorWithStatus("请输入手机号");
            return;
        }
        guard let _ = passwordTf.text else{
//            SVProgressHUD.showErrorWithStatus("请输入密码");
            return;
        }
//        SVProgressHUD.showWithStatus("登录中");
        self.view.isUserInteractionEnabled = false;
        //登录网络请求
        
        
    }
    var keyboardHeight:CGFloat?;
    func keyboardWillChanged(not:NSNotification) {
        keyboardHeight = (not.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height;
        let keyboardY = (not.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.origin.y;
        var c_y:CGFloat = 74;
        if keyboardY!>=self.view.h {
        }else{
            
            let span = self.view.h - 74 - passwordTf.y + passwordTf.h - (keyboardHeight ?? 0) - 10;
            if span<0{
                c_y = 74+span;
            }
        }
        UIView.animate(withDuration: 0.25) {
            [weak self] in self?.contentView.y = c_y;
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == phoneTf {
            passwordTf.becomeFirstResponder();
        }
        if textField == passwordTf {
            textField.resignFirstResponder();
        }
        return true;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChanged(not:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil);
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil);
    }
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        self.view.endEditing(true);
//    }
    func backToPre() {
        self.navigationController?.dismiss(animated: true, completion: nil);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
