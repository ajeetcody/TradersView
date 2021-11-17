//
//  MyTabbarController.swift
//  PlasmaForCorona
//
//  Created by Ajeet Sharma on 25/04/21.
//


import UIKit
import CoreLocation



class MyTabbarController: UITabBarController {
    
    
    //MARK:- UI object declarations -----
    
    
    //  var indicatorLabel = UILabel()
    
    
    var tabViewArray:[UIView] = []
    var labelArray:[UILabel] = []
    var imageViewArray:[UIImageView] = []
    
    
    var imageList:[String] = ["home_tab","profile_tab","post_tab","chat_tab","setting_tab"]
    
    let  kBarHeight:CGFloat = 100
    
    var tabbarWidthConst:CGFloat = 0.0
    
    
    
    
    //MARK: Data variables ---
    
    let appDelegate:AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
    
    
    
    
    //MARK:- Viewcontroller lifecycle -----
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.designCustomTabbar()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        tabBar.frame.size.height = kBarHeight
        tabBar.frame.origin.y = view.frame.height - kBarHeight
    }
    
    
    //MARK:- UI Change operations ----
    
    
    func designCustomTabbar(){
        
        
        
        tabbarWidthConst = self.tabBar.frame.size.width/5
        
        var xCordinateOfTabView:CGFloat = 0.0
        
        let totalTabs = self.imageList.count
        
        let viewTabbar = UIView()
        
        viewTabbar.frame = CGRect(x: 0, y: 0, width:  self.tabBar.frame.size.width, height: self.tabBar.frame.size.height)
        viewTabbar.backgroundColor = UIColor(hexString: "#FFFFFF", alpha: 2.0)
        self.tabBar.addSubview(viewTabbar)
        
        
        
        for index in 0...totalTabs-1{
            
            
            
            
            //------ schedule view -----
            
            let tabViewCustom = UIView()
            
            let tabImageView = UIImageView()
            
            
            tabViewCustom.frame = CGRect(x: CGFloat(xCordinateOfTabView), y: 0.0, width: self.tabbarWidthConst, height: self.tabBar.frame.size.height)
            
            
            if index == 0{
                
                //17325A
                tabViewCustom.backgroundColor = self.hexStringToUIColorTabbar(hex: "#17325A")
                
            }
            else{
                
                
                tabViewCustom.backgroundColor = .lightGray
                
            }
            
            tabViewCustom.tag = index
            
            
            tabImageView.frame = CGRect(x: 8, y: 8.0 , width: self.tabbarWidthConst - 16, height: self.tabBar.frame.height - 16)
            tabImageView.contentMode = .scaleAspectFit
            tabImageView.image = UIImage(named: "\(self.imageList[index])")
            tabViewCustom.addSubview(tabImageView)
            
            
            tabViewCustom.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tabbarSelection(gesture:))))
            tabViewCustom.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.tabbarLongPressSelection(gesture:))))

            self.tabViewArray.append(tabViewCustom)
            
            viewTabbar.addSubview(tabViewCustom)
            
            xCordinateOfTabView = xCordinateOfTabView + tabbarWidthConst
            
            
        }
        
        
        
    }
    
    func hexStringToUIColorTabbar (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    //MARK:- Gesture Methods ----
    
    
    @objc func tabbarLongPressSelection(gesture: UITapGestureRecognizer) {
        
        let tag = gesture.view?.tag
        
        
        let nvController:UINavigationController = self.viewControllers![tag!] as! UINavigationController
        nvController.popToRootViewController(animated: true)
        self.changeUITabbarAfterTabSelection(tabIndex: tag!)
        
        
    }
    
    
    @objc func tabbarSelection(gesture: UITapGestureRecognizer) {
        
        
        
        if let tag = gesture.view?.tag{
        
            if tag == 2 {
                
               
                self.showActionSheet()
                
                
            }
            else{
                
            
                self.selectedIndex = tag
                self.changeUITabbarAfterTabSelection(tabIndex: tag)
                
                
            }
            
        }
      
        
    }
    
    
    func changeUITabbarAfterTabSelection(tabIndex:Int){
        
        
        _ =  self.tabViewArray.map { (view) -> UIView in
            
            if view.tag == tabIndex{
                
                view.backgroundColor = self.hexStringToUIColorTabbar(hex: "#17325A")
                
            }
            else{
                
                view.backgroundColor = .lightGray
                
            }
            
            return view
            
        }
        
        
    }
    
    func showActionSheet(){
        
        
        let actionSheet = UIAlertController(title: "Select Option", message: "", preferredStyle: .actionSheet)
        
        let actionPost = UIAlertAction(title: "Add Post", style: .default) { (action) in
            self.addPostScreen()
        }
        
        let actionTrade = UIAlertAction(title: "Add Trade", style: .default) { (action) in
            self.addtradeScreen()
        }
        
        let actionCreateGroup = UIAlertAction(title: "Create Group", style: .default) { (action) in
            self.createGroupScreen()
            
        }
        
        let actionCreateChannel = UIAlertAction(title: "Create Channel", style: .default) { (action) in
            self.createChannelScreen()
            
        }
        
        let actionCancel = UIAlertAction(title: "Close", style: .destructive, handler: nil)
        
        
        actionSheet.addAction(actionPost)
        actionSheet.addAction(actionTrade)
        actionSheet.addAction(actionCreateGroup)
        actionSheet.addAction(actionCreateChannel)
        actionSheet.addAction(actionCancel)
        
        self.present(actionSheet, animated: true, completion: nil)
        
        
        
    }
    
    
    func addPostScreen(){
        
        let storyBoardDashboard = UIStoryboard(name: "DashboardFlow", bundle: nil)
        
        let vc:PostViewController = storyBoardDashboard.instantiateViewController(identifier: "PostViewController") as! PostViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
        
        
    }
    func addtradeScreen(){
        
        let storyBoardDashboard = UIStoryboard(name: "DashboardFlow", bundle: nil)
        let vc = storyBoardDashboard.instantiateViewController(identifier: "AddTradesViewController")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
        
        
    }
    
    func createGroupScreen(){
        
        let storyBoardDashboard = UIStoryboard(name: "Chat", bundle: nil)
        
        let vc:CreateGroupViewController = storyBoardDashboard.instantiateViewController(identifier: "CreateGroupViewController") as! CreateGroupViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
        
        
    }
    func createChannelScreen(){
        
        let storyBoardDashboard = UIStoryboard(name: "Chat", bundle: nil)
        
        let vc:CreateChannelViewController = storyBoardDashboard.instantiateViewController(identifier: "CreateChannelViewController") as! CreateChannelViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)

        
        
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




