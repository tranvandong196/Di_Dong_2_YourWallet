//
//  NotificationExtension.swift
//  Restaurant Management
//
//  Created by Tran Van Dong on 4/19/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import Foundation
// Chạy một func khi keyboard hiện/ẩn (#selector(self.<Tên hàm(tham số)>))
func KeyboardShow(_ observer: Any, open_Func: Selector){
    NotificationCenter.default.addObserver(observer, selector: open_Func, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
}
func KeyboardHide(_ observer: Any, open_Func: Selector){
    NotificationCenter.default.addObserver(observer, selector: open_Func, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
}
