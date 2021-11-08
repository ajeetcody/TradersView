//
//  NotificationViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 08/11/21.
//

import UIKit

class CellNotification:UITableViewCell{
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var viewPostButton: UIButton!
    @IBOutlet weak var userProfileImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var widthImagePost: NSLayoutConstraint!
    
    @IBOutlet weak var heightImagePost: NSLayoutConstraint!
}
class NotificationViewController: MasterViewController {
    
    

    @IBOutlet weak var tableViewNotification: UITableView!
    var arrayNotificaiton:[NotificationResponseDatum]?
    
    private var pageNumber = 0
    
    //MARK:- UIViewcontroller lifecycle methods ----
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if  let userData:LoginUserData = self.appDelegate.loginResponseData{
            
            
            self.apiCall(userID: userData.id, pageNumber: self.pageNumber)
            
        }
        else{
            
            self.showAlertPopupWithMessage(msg: "User Data is not available")
        }
        
    }
    
    //MARK:- API call to fetch notificaitons ----
    
    
    func apiCall(userID:String, pageNumber:Int){
        
        
        let request = NotificationRequest(_id: userID, _page: pageNumber)
        
        
        ApiCallManager.shared.apiCall(request: request, apiType: .GET_NOTIFICATION, responseType: NotificationResponse.self, requestMethod: .POST) { (results) in
            
            if results.status == 1 {
                
                if let data = results.data{
                    
                    if self.pageNumber == 0{
                        
                        self.arrayNotificaiton = data
                        
                    }
                    else{
                        
                        self.arrayNotificaiton?.append(contentsOf: data)
                        
                    }
                    
                    
                    
                }
                
                
                
                DispatchQueue.main.async {
                    
                    
                    self.tableViewNotification.reloadData()
                    
                }
                
                
            }
            else if results.status == 0{
                
                
                self.showAlertPopupWithMessage(msg: results.messages)
                
            }
            
            
            
        } failureHandler: { (error) in
            
            
            self.showErrorMessage(error: error)
            
            
        }

        
        
        
        
    }
    
    //MARK:- UITapgesture actions ---
    
    
    @objc func profilePicImageViewTapGesture(gesture:UITapGestureRecognizer){
        
        
        
    //We can not show user profile from here because we are not getting user id in response ---
        
            
        
    
            
        
        
    }
    
    //MARK:- UIButton action methods ---
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        
        self.navigationController?.popViewController(animated: true)
        
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
extension NotificationViewController:UITableViewDelegate, UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell:CellNotification = tableView.dequeueReusableCell(withIdentifier: "CellNotification") as! CellNotification
        
        let obj = self.arrayNotificaiton![indexPath.row]
        
        print("imageURL - \(obj.profileImg)")
       
        cell.userProfileImageView.sd_setImage(with: URL(string: "\(obj.profileImg)"), placeholderImage: UIImage(named: "placeholder.png"))
        cell.userProfileImageView.changeBorder(width: 1.0, borderColor: .black, cornerRadius: 45/2.0)
        cell.userProfileImageView.tag = indexPath.row
        
        cell.userProfileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.profilePicImageViewTapGesture(gesture:))))

      //  cell.userNameLabel.text = obj.name.capitalized
        
        cell.dateLabel.text = self.changeDateFormateToDisplay(dateString: obj.date)
        
        
        cell.messageLabel.text = "\(obj.name.capitalized) \(obj.message)"
            
            
            if obj.postImg.count != 0 {
                
             //   cell.viewPostButton.isHidden = true
                
                cell.widthImagePost.constant = 90.0
                cell.heightImagePost.constant = 90.0
                
                cell.postImageView.sd_setImage(with: URL(string: "\(obj.postImg)"), placeholderImage: UIImage(named: ""))

                cell.postImageView.changeBorder(width: 1.0, borderColor: .darkGray, cornerRadius: 3.0)
                

            }
            else{
               // cell.viewPostButton.isHidden = false
                cell.widthImagePost.constant = 0.0
                cell.heightImagePost.constant = 0.0

            }

       
        
        
        return cell
        
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let _result = self.arrayNotificaiton{
        
            return  _result.count
            
        }
        return 0
        
    }
    
}
