//
//  Functions.swift
//  Restaurant Management
//
//  Created by Tran Van Dong on 4/19/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import Foundation
import UIKit
import ImageIO
// MARK: *** extension

extension UIViewController {
    // Hiển thị thông báo đơn giản
    func alert(title: String, message: String?) {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // Hiện thông báo xong làm gì đó
    func alert(title: String, message: String,titleAction: String, handler: @escaping (UIAlertAction) -> Void ) {
        let Action = UIAlertAction(title: titleAction, style: .default, handler: handler)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(Action)
        self.present(alert, animated: true, completion: nil)
    }
    // Thêm nút Done để ẩn đi bàn phím
    func addDoneButton(to control: UITextField){
        let toolbar = UIToolbar()
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: control,
                            action: #selector(UITextField.resignFirstResponder))
        ]
        
        toolbar.sizeToFit()
        control.inputAccessoryView = toolbar
    }
    
    func addDoneButton(_ textview: UITextView){
        if textview.isEditable{
            let toolbar = UIToolbar()
            toolbar.items = [
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
                UIBarButtonItem(title: "Done", style: .done, target: textview,
                                action: #selector(UITextField.resignFirstResponder))
            ]
            
            toolbar.sizeToFit()
            textview.inputAccessoryView = toolbar
        }
    }
    
    func addDoneButton(tos controls: [UITextField]){
        
        for control in controls {
            let toolbar = UIToolbar()
            toolbar.items = [
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
                UIBarButtonItem(title: "Done", style: .done, target: control,
                                action: #selector(UITextField.resignFirstResponder))
            ]
            
            toolbar.sizeToFit()
            control.inputAccessoryView = toolbar
        }
    }
    func moveToVC(withStoryboardID: String,animated: Bool){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let objSomeViewController = storyBoard.instantiateViewController(withIdentifier: withStoryboardID)
        
        // If you want to present the new ViewController then use this - animated: Hiệu ứng chuyển cảnh
        self.present(objSomeViewController, animated: animated, completion: nil)
    }
    func pushToVC(withStoryboardID: String, animated: Bool){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let objSomeViewController = storyBoard.instantiateViewController(withIdentifier: withStoryboardID)

        self.navigationController?.pushViewController(objSomeViewController, animated: animated)
    }
    
}
public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}
//Kiểm tra TextField & TextView trống
extension UITextField {
    func isEmpty() -> Bool {
        return self.text?.characters.count == 0
    }
}

extension UITextView {
    func isEmpty() -> Bool {
        return self.text?.characters.count == 0
    }
}
extension UILabel{
    func isEmpty() -> Bool {
        return self.text?.characters.count == 0
    }
}
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
        nextField.becomeFirstResponder()
    } else {
        // Not found, so remove keyboard.
        textField.resignFirstResponder()
    }
    return true
}

extension UIImage{
    // Lưu ảnh vào dicectory
    func saveImageToDir(at url: URL,name: String){
        // Kiểm tra định dạng file: or print("Formart: \(name.hasSuffix(".png"))")
        let format:String = String(name.characters.suffix(4))   //Lấy 4 ký tự cuối
        do{
            if format == ".png" || format == ".PNG"{
                try UIImagePNGRepresentation(self)?.write(to: url.appendingPathComponent(name))
            }else if format == ".jpg" || format == ".JPG"{
                try UIImageJPEGRepresentation(self, 0.8)?.write(to: url.appendingPathComponent(name))
            }
            print("Saved image: \(name) to .../\(url.lastPathComponent)")
        }catch{
            print("Can not save image: \(name) to .../\(url.lastPathComponent)")
        }
    }
}

//Kiểm tra định dạng ảnh

struct ImageHeaderData{
    static var PNG: [UInt8] = [0x89]
    static var JPEG: [UInt8] = [0xFF]
    static var GIF: [UInt8] = [0x47]
    static var TIFF_01: [UInt8] = [0x49]
    static var TIFF_02: [UInt8] = [0x4D]
}

enum ImageFormat{
    case Unknown, PNG, JPEG, GIF, TIFF
}


extension NSData{
    var imageFormat: ImageFormat{
        var buffer = [UInt8](repeating: 0, count: 1)
        self.getBytes(&buffer, range: NSRange(location: 0,length: 1))
        if buffer == ImageHeaderData.PNG
        {
            return .PNG
        } else if buffer == ImageHeaderData.JPEG
        {
            return .JPEG
        } else if buffer == ImageHeaderData.GIF
        {
            return .GIF
        } else if buffer == ImageHeaderData.TIFF_01 || buffer == ImageHeaderData.TIFF_02{
            return .TIFF
        } else{
            return .Unknown
        }
    }
}
extension UIViewController{
    func AlertPickerImage(pickerController: UIImagePickerController, cancelAction: Bool = false)->UIAlertController{
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: NSLocalizedString("Camera", comment: " "), style: .default){
            (ACTION) in pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
        }
        let photosLibraryAction = UIAlertAction(title: NSLocalizedString("Photo Library", comment: " "), style: .default){
            (ACTION) in pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
        
        
        
        
        alertController.addAction(cameraAction)
        alertController.addAction(photosLibraryAction)
        if cancelAction{
            let CancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: " "), style: .destructive, handler: nil)
            alertController.addAction(CancelAction)
        }
        
        
        return alertController
        
    }
    func GetCancelAction()->UIAlertAction{
        return UIAlertAction(title: NSLocalizedString("Cancel", comment: " "), style: .destructive, handler: nil)
    }
}
extension UIView{
    /**
     Fade in a view with a duration
     
     - parameter duration: custom animation duration
     */
    func fadeIn(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
    /**
     Fade out a view with a duration
     
     - parameter duration: custom animation duration
     */
    func fadeOut(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }
}
