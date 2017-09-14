//
//  TabBarViewController.swift
//  YourWallet
//
//  Created by Tran Van Dong on 3/6/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        if let newButtonImage = UIImage(named: "Add-transaction-icon") {
            self.addCenterButton(withImage: newButtonImage, highlightImage: newButtonImage)
        }
        
    }

    
    func handleTouchTabbarCenter(sender : UIButton)
    {
        self.selectedIndex = 2
//        if let count = self.tabBar.items?.count
//        {
//            let i = floor(Double(count / 2))
//            self.selectedViewController = self.viewControllers?[Int(i)]
//        }
    }
    func addCenterButton(withImage buttonImage : UIImage, highlightImage: UIImage) {
        
        let paddingBottom : CGFloat = self.view.frame.height == 812.0 ? -160.0:10.0
        
        let button = UIButton(type: .system)
        button.autoresizingMask = [.flexibleRightMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin]
        button.frame = CGRect(x: 0.0, y: 0.0, width: buttonImage.size.width / 2.0, height: buttonImage.size.height / 2.0)
        button.setBackgroundImage(buttonImage, for: .normal)
        button.setBackgroundImage(highlightImage, for: .highlighted)

        let rectBoundTabbar = self.tabBar.bounds
        let xx = rectBoundTabbar.midX
        let yy = rectBoundTabbar.midY - paddingBottom
        button.center = CGPoint(x: xx, y: yy)
        
        self.tabBar.addSubview(button)
        self.tabBar.bringSubview(toFront: button)
        
        button.addTarget(self, action: #selector(handleTouchTabbarCenter), for: .touchUpInside)

        if let count = self.tabBar.items?.count
        {
            let i = floor(Double(count / 2))
            let item = self.tabBar.items![Int(i)]
            item.title = "Thêm giao dịch"
        }
    }
/* Change amimaion when switch TabbarItem
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if let fromView = tabBarController.selectedViewController?.view, let toView = viewController.view {
            
            if fromView == toView {
                return false
            }
            
            UIView.transition(from: fromView, to: toView, duration: 0.7, options: .transitionFlipFromBottom) { (finished) in
            }
        }
        
        return true
    }
 */
    override var selectedIndex: Int{
        get{
            return super.selectedIndex
        }
        set{
            animateToCenterButton(toIndex: newValue)
            super.selectedIndex = newValue
        }
    }
    
    func animateToCenterButton(toIndex: Int) {
        guard let tabViewControllers = viewControllers, tabViewControllers.count > toIndex, let fromViewController = selectedViewController, let fromIndex = tabViewControllers.index(of: fromViewController), fromIndex != toIndex else {return}
        
        view.isUserInteractionEnabled = false
        
        let toViewController = tabViewControllers[toIndex]
        var push = 0
        if let count = self.tabBar.items?.count
        {
            let i = floor(Double(count / 2))
            push = Int(i)
        }
        let bounds = UIScreen.main.bounds
        
        let StaticScreenCenter = CGPoint(x: fromViewController.view.center.x , y: fromViewController.view.center.y  + bounds.height)
        
        if push == toIndex{
            fromViewController.view.superview?.addSubview(toViewController.view)
        }else{
            fromViewController.view.superview?.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        }
        toViewController.view.center = StaticScreenCenter
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            if push == toIndex{
                toViewController.view.center = fromViewController.view.center
                
            }
            if push != toIndex{
                fromViewController.view.center = StaticScreenCenter
            }
        }, completion: { finished in
            fromViewController.view.removeFromSuperview()
            self.view.isUserInteractionEnabled = true
        })
    }
    
//    func animateToTab(toIndex: Int) {
//        guard let tabViewControllers = viewControllers, tabViewControllers.count > toIndex, let fromViewController = selectedViewController, let fromIndex = tabViewControllers.index(of: fromViewController), fromIndex != toIndex else {return}
//        
//        view.isUserInteractionEnabled = false
//        
//        let toViewController = tabViewControllers[toIndex]
//        let push = toIndex > fromIndex //thử rồi chạy sẽ biết
//        let bounds = UIScreen.main.bounds
//        
//        let offScreenCenter = CGPoint(x: fromViewController.view.center.x, y: fromViewController.view.center.y + bounds.height)
//        let partiallyOffCenter = CGPoint(x: fromViewController.view.center.x , y: bounds.height*0.25)
//        
//        if push{
//            fromViewController.view.superview?.addSubview(toViewController.view)
//            toViewController.view.center = offScreenCenter
//        }else{
//            fromViewController.view.superview?.insertSubview(toViewController.view, belowSubview: fromViewController.view)
//            toViewController.view.center = partiallyOffCenter
//        }
//        
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
//            toViewController.view.center   = fromViewController.view.center
//            fromViewController.view.center = push ? partiallyOffCenter : offScreenCenter
//        }, completion: { finished in
//            fromViewController.view.removeFromSuperview()
//            self.view.isUserInteractionEnabled = true
//        })
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
