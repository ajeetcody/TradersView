//
//  ChatViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 19/10/21.
//

import UIKit

class ChatViewController: UIViewController {

    //MARK:- Autolayout declaration -----

    
    @IBOutlet weak var leadingScrollIndicator: NSLayoutConstraint!
    
    //MARK:- UI Object declaration -----
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var notificationButton: UIButton!
    
    @IBOutlet weak var messageButton: UIButton!
    
    @IBOutlet weak var groupButton: UIButton!
    
    @IBOutlet weak var channelButton: UIButton!
    
    
    //MARK:- UIViewcontroller lifecycle -----
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()

        self.view.layoutIfNeeded()
        
        
        
    }
    
    //MARK:- UIButton action methods ----
    
    
    @IBAction func searchButtonAction(_ sender: Any) {
        
        
    }
    
    @IBAction func notificationButtonAction(_ sender: Any) {
        
        
    }
    
    @IBAction func messageButtonAction(_ sender: Any) {
        
        
    }
    
    @IBAction func groupButtonAction(_ sender: Any) {
        
        
    }
    
    @IBAction func channelButtonAction(_ sender: Any) {
        
        
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChatViewController:UIScrollViewDelegate{
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        
        print(scrollView.currentPage)
        
        UIView.animate(withDuration: 5.5, delay: 5.5, options: []) {
            
           // self.view.layoutIfNeeded()
            
            self.leadingScrollIndicator.constant = CGFloat(scrollView.currentPage * (Int(self.view.frame.size.width)/3))

            
            
        } completion: { (isComplete) in
            print("Complete animation")
        }

        UIView.animate(withDuration: 3.5) {
            
           // self.leadingScrollIndicator.constant = CGFloat(scrollView.currentPage * (Int(self.view.frame.size.width)/3))
            
        }
        
//        UIView.animate(withDuration: 3.5) {
//
//        //    self.leadingScrollIndicator.constant = CGFloat(scrollView.currentPage * (Int(self.view.frame.size.width)/3))
//
//        } completion: { (isCompleted) in
//            print("Completed")
//        }

        
        
        
    }
    
    
}
