//
//  ChatViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 19/10/21.
//

import UIKit

class ChatViewController: MasterViewController {

    //MARK:- Autolayout declaration -----

    
    @IBOutlet weak var leadingScrollIndicator: NSLayoutConstraint!
    @IBOutlet weak var leadingGroupScrollIndicator: NSLayoutConstraint!

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
        self.showAlertCommingSoon()

        
        
    }
    
    //MARK:- UIButton action methods ----
    
    
    @IBAction func searchButtonAction(_ sender: Any) {
        
        self.showSearchViewController()
    }
    
    @IBAction func notificationButtonAction(_ sender: Any) {
        
        self.showAlertCommingSoon()
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
        
        if scrollView.tag == 0 {
        
            UIView.animate(withDuration: 0.3, delay: 0.0, options: []) {
                
               
                
                self.leadingScrollIndicator.constant = CGFloat(scrollView.currentPage * (Int(self.view.frame.size.width)/3))

                self.view.layoutIfNeeded()
                
            } completion: { (isComplete) in
                print("Complete animation")
            }

            
        }
        else if scrollView.tag == 1{

            UIView.animate(withDuration: 0.3, delay: 0.0, options: []) {
                
               
                
                self.leadingGroupScrollIndicator.constant = CGFloat(scrollView.currentPage * (Int(self.view.frame.size.width)/2))

                self.view.layoutIfNeeded()
                
            } completion: { (isComplete) in
                print("Complete animation")
            }

            
        }
        
     
        
    }
    
    
}
