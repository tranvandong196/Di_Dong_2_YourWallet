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
    func alert(title: String, message: String) {
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
    func moveToVC(withIdentifier: String,animated: Bool){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let objSomeViewController = storyBoard.instantiateViewController(withIdentifier: withIdentifier)
        
        // If you want to present the new ViewController then use this - animated: Hiệu ứng chuyển cảnh
        self.present(objSomeViewController, animated: animated, completion: nil)
    }
    func pushToVC(withIdentifier: String){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let objSomeViewController = storyBoard.instantiateViewController(withIdentifier: withIdentifier)
        //let newViewController = NewViewController()
        // If you want to present the new ViewController then use this - animated: Hiệu ứng chuyển cảnh
        self.navigationController?.pushViewController(objSomeViewController, animated: true)
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

