//
//  SelectTimeRange_ViewController.swift
//  YourWallet
//
//  Created by Tran Van Dong on 30/5/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class SelectTimeRange_ViewController: UIViewController {

    @IBOutlet weak var datePickerTxt: UITextField!
    @IBOutlet weak var datePickerTxt1: UITextField!
    @IBAction func doneBtn(_ sender: Any) {
        done()
    }
    
    
    let datePicker = UIDatePicker()
    let datePicker1 = UIDatePicker()
    
    var date1 = String("")
    var date2 = String("")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDatePicker()
        createDatePicker1()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //self.navigationController?.navigationBar.barTintColor = UIColor.green
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // tạo chọn ngày: Từ ngày
    func createDatePicker()
    {
        // format for picker
        datePicker.datePickerMode = .date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateRaw1 = dateFormatter.date(from: StatisticsViewController.date1)!
        dateFormatter.dateFormat = "dd-MM-yyyy"
        datePicker.setDate(dateRaw1, animated: true)
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: false)
        
        datePickerTxt.inputAccessoryView = toolbar
        datePickerTxt.inputView = datePicker
        
    }
    
    // tạo chọn ngày: Tới ngày
    func createDatePicker1()
    {
        // format for picker
        datePicker1.datePickerMode = .date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateRaw1 = dateFormatter.date(from: StatisticsViewController.date2)!
        dateFormatter.dateFormat = "dd-MM-yyyy"
        datePicker1.setDate(dateRaw1, animated: true)
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,target: nil, action: #selector(donePressed1))
        toolbar.setItems([doneButton], animated: false)
        
        datePickerTxt1.inputAccessoryView = toolbar
        datePickerTxt1.inputView = datePicker
        
    }
    
    // nút done 1
    func donePressed()
    {
        // format date
        let dateFormattor = DateFormatter()
        
        dateFormattor.dateFormat = "yyyy-MM-dd"
        
        //        dateFormattor.dateStyle = .long
        //        dateFormattor.timeStyle = .none
        
        datePickerTxt.text = dateFormattor.string(from: datePicker.date)
        date1 = dateFormattor.string(from: datePicker.date)
        
        self.view.endEditing(true)
    }
    
    // nút done 2
    func donePressed1()
    {
        // format date
        let dateFormattor = DateFormatter()
        dateFormattor.dateFormat = "yyyy-MM-dd"
        
        //dateFormattor.dateStyle = .medium
        //dateFormattor.timeStyle = .none
        datePickerTxt1.text = dateFormattor.string(from: datePicker.date)
        date2 = dateFormattor.string(from: datePicker.date)
        
        
        self.view.endEditing(true)
    }
    
    func done() -> Bool {
        if(date1 == nil || date2 == nil)
        {
            return false
        }
        if(date1 != "" || date2 != ""){//Đã chọn 1 trong 2 mốc date
            
            if (date1 == ""){
                date1 = date2
            }
            else{
                if(date2 == ""){
                    date2 = date1
                }
            }
            
            
            if (date1! > date2!){
                let dateTemp = date1
                date1 = date2
                date2 = dateTemp
                
            }
            
            //date2 =  date2! + " 23:59:59"
            //sqlite
            
            
            //Bills.removeAll()
            StatisticsViewController.date1 = date1! + " 00:00:00"
            StatisticsViewController.date2 = date2! + " 23:59:59"
            
            self.navigationController?.popViewController(animated: true)
            
            return true
        }
        
        return false
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
