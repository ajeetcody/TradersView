//
//  SplashViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 17/10/21.
//

import UIKit
import Firebase


class SplashViewController: MasterViewController {

    @IBOutlet weak var continueButton: UIButton!
    
    
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.appDelegate.mainNavigation = self.navigationController
        self.continueButton.changeBorder(width: 1.0, borderColor: .white, cornerRadius: 10.0)
        
    
        
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
