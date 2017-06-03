//
//  Global variable.swift
//  YourWallet
//
//  Created by Tran Van Dong on 2/6/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import Foundation

/* Màn hình danh sách ví và nhóm sẽ có chức năng khác nhau: giữa CHỌN và XEM
    -> Đặt biến isSelectWallet = false ở viewWillAppear ở màn hình Sổ giao dịch, thống kê
    -> Đặt biến isSelectCategory = false ở viewWillAppear ở màn hình Thêm giao dịch, ví
*/
var isAddTransaction:Bool = false
var isSelectWallet:Bool = false
var isSelectCategory:Bool = false

var transaction_GV: Transaction? = nil
var currency_GV: Currency? = nil
var category_GV: Category? = nil
var wallet_GV: Wallet? = nil

var wallet_detail: Wallet? = nil
/*
    Đặt giá trị biến phù hợp = nil khi bắt đầu load màn hình CHỌN (Tiền tệ) - Màn hình Ví ko cần
    -> Nếu có chọn thì lưu lại vào biến trước khi Pop ViewController
    -> Nếu wallet_GV = nil: Thống kê và xem theo tất cả các ví
    -> Nếu sau khi qua màn hình chọn ví mà loại ví ko thay đổi: Giữ nguyên nội dung trên màn hình (Ko nên load lại)
*/




/*
    Lưu dữ liệu dưới UserDefault với forKey:
    - Mã tiền tệ mặc định String: "Currency"
    - Mã ví đã chọn Int: "Wallet"
*/

/*
    Hàm & lênh sử dụng thường xuyên:
    - Push tới màn hình bất kỳ: func pushToVC(withStoryboardID: String, animated: Bool)
    - Di chuyển tới màn hình bất kỳ (Mất navigation): func moveToVC(withStoryboardID: String,animated: Bool)
    - Pop màn hình hiện tại (Sau khi chọn xong nhóm, ví, tiền tệ): self.navigationController?.popViewController(animated: true)
 extension Double{
    - Đổi tiền hiện tại sang VND (Khi user nhập tiền thì chuyển sang VND để lưu vào CSDL):
        func toVND(ExchangeRate: Double) -> Double
    - Đổi tiền VND sang tiền hiện tại (Để hiển thị tiền hiện tại - nên dùng cho TextField):
        func VNDtoCurrency(ExchangeRate: Double) -> Double
    - Định dạng lại kiểu hiển thị số tiền (Dùng để hiển thị ra màn hình):
        func toCurrencyFormatter(CurrencyID: String)->String
    Với ExchangeRate là tỷ giá của loại tiền tệ đang dùng trong hệ thống
    Ví dụ: let money = TransactionsA.Amount!.VNDtoCurrency(ExchangeRate: (currency_GV?.ExchangeRate)!).toCurrencyFormatter(CurrencyID: (currency_GV?.ID)!)
 }
        
*/
