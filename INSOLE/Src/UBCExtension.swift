//
//  UBCExtension.swift
//  USENSE
//
//  Createdclu by Myron on 16/3/23.
//  Copyright © 2016年 Myron. All rights reserved.
//

import UIKit

class UBCExtension: NSObject {

}

class GP {
    static let W = UIScreen.main.bounds.size.width;
    static let H = UIScreen.main.bounds.size.height;
    static let Scale = UIScreen.main.scale;
}
extension UIFont{
    static func normal()->UIFont{
        return s16();
    }
    static func s16()->UIFont{
        return UIFont.systemFont(ofSize: 16);
    }
    subscript(key:CGFloat)->UIFont{
        return UIFont.systemFont(ofSize: key);
    }
}

@IBDesignable extension UIView{
    @IBInspectable var cornerRadius:CGFloat{
        get{
            return self.layer.cornerRadius;
        }
        set{
            self.layer.cornerRadius = newValue;
            self.clipsToBounds = true;
            self.layer.masksToBounds = true;
        }
    }
    @IBInspectable var borderWidth:CGFloat{
        get{
            return self.layer.borderWidth;
        }
        set{
            self.layer.borderWidth = newValue;
        }
    }
    @IBInspectable var borderColor:UIColor?{
        get{
            guard let _ = self.layer.borderColor else{
                return nil;
            }
            return UIColor(cgColor: self.layer.borderColor!);
        }
        set{
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    func offsetX(offset:CGFloat){
        var rect = self.frame;
        rect.origin.x += offset;
        self.frame = rect;
    }
    
    var x:CGFloat{
        get{
            return self.frame.origin.x;
        }
        set{
            var rect = self.frame;
            rect.origin.x = newValue;
            self.frame = rect;
        }
    }
    var y:CGFloat{
        get{
            return self.frame.origin.y;
        }
        set{
            var rect = self.frame;
            rect.origin.y = newValue;
            self.frame = rect;
        }
    }
    var w:CGFloat{
        get{
            return self.frame.size.width;
        }
        set{
            var rect = self.frame;
            rect.size.width = newValue;
            self.frame = rect;
        }
    }
    var h:CGFloat{
        get{
            return self.frame.size.height;
        }
        set{
            var rect = self.frame;
            rect.size.height = newValue;
            self.frame = rect;
        }
    }
    
}


@IBDesignable extension UITextView{
    @IBInspectable var lineFragmentPadding:CGFloat{
        get{
            return self.textContainer.lineFragmentPadding;
        }
        set {
            self.textContainer.lineFragmentPadding = newValue;
        }
    }
}
