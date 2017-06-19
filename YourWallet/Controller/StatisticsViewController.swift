//
//  StatisticsViewController.swift
//  YourWallet
//
//  Created by Tran Van Dong on 30/5/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit
import Charts

class StatisticsViewController: UIViewController {

    @IBOutlet weak var pieChartView: PieChartView!
    
    @IBOutlet weak var SelectWallet_Button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
        
        
        //pieChartView = PieChartView(frame: self.view.bounds)
        //self.view.addSubview(pieChartView!)
        setChart(dataPoints: months, values: unitsSold)
    }
    override func viewWillAppear(_ animated: Bool) {
        print("🖥 Thống kê --------------------------------")
        isSelectWallet = false
        isAddTransaction = false
        currentTabBarItem = 3
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(true, animated: true)
       
        if wallet_GV != nil {
            SelectWallet_Button.setImage(UIImage(named: (wallet_GV?.Icon)!), for: .normal)
        }else {
            SelectWallet_Button.setImage(#imageLiteral(resourceName: "All-Wallet-icon"), for: .normal)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SelectWallet_ButtonTapped(_ sender: Any) {
        isSelectWallet = true
        pushToVC(withStoryboardID: "WalletVC",animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry1 = PieChartDataEntry(value: values[i], label: dataPoints[i])
            dataEntries.append(dataEntry1)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "Units Sold")
        pieChartDataSet.colors = ChartColorTemplates.colorful()
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        
        pieChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInSine)
        //pieChartView.chartDescription?.text = "des"
    }

}
