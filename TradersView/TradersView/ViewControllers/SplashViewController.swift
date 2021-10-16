//
//  SplashViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 17/10/21.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.appdelegate.mainNavigation = self.navigationController
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
