//
//  FavoriteUserProfileViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 11/11/21.
//

import UIKit

class FavoriteTableViewCell:UITableViewCell{
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
}

class FavoriteUserProfileViewController: MasterViewController {

    
    @IBOutlet weak var tableViewFavorite: UITableView!
    
   private var currentUserId:String?
    
    
    var pageNumber:Int = 0
    
    var favoriteUsersList:[FavoriteUserResponseDatum]?
    
    var shouldLoadeMore:Bool = false
    
    var refreshControl = UIRefreshControl()
    
    //MARK:- UIViewcontroller lifecycle methods ---
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.tableViewFavorite.addSubview(refreshControl) // not required when using UITableViewController

        
   

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.pageNumber = 0
        
        self.favoriteUsersList?.removeAll()
        self.tableViewFavorite.reloadData()

        if  let userData:LoginUserData = self.appDelegate.loginResponseData{
            
            self.currentUserId = userData.id
            self.fetchFavoriteUsersList()

            
        }
        else{
            
            self.showAlertPopupWithMessage(msg: "User Data is not available")
        }
    }
    
    //MARK:- UIButton action ----
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //MARK:- Pull to refresh ----
    
    
    @objc func refresh(_ sender: AnyObject) {
       
        shouldLoadeMore = false
        
        self.pageNumber = 0
        
        self.fetchFavoriteUsersList()
        
    }
    
    
    //MARK:- API call ---
    
    func fetchFavoriteUsersList(){
        
        if let userID = self.currentUserId{
        
            let request = FavoriteUsersListRequest(_id: userID, _page: self.pageNumber)
            
            
            ApiCallManager.shared.apiCall(request: request, apiType: .FAV_PROFILE_LIST, responseType: FavoriteUserResponse.self, requestMethod: .POST) { (results) in
                
                DispatchQueue.main.async {
                
                    self.refreshControl.endRefreshing()
                }
                
                
                if results.status == 1{
                    
                    
                    if let list = results.data{
                        
                        print("Continue reloading...")
                        self.shouldLoadeMore = true
                        self.favoriteUsersList = list
                        DispatchQueue.main.async {
                        
                            self.tableViewFavorite.reloadData()
                        }
                        
                        
                    }
                    else{
                        
                        if self.pageNumber == 0 {
                            DispatchQueue.main.async {

                            self.tableViewFavorite.isHidden = true
                            }
                            self.showAlertPopupWithMessage(msg: results.messages)
                            
                        }
                        else{
                            
                            self.shouldLoadeMore = false
                            
                        }
                        
                    }
                    
                    
                }
                else{
                    
                    if self.pageNumber == 0 {
                        
                        self.tableViewFavorite.isHidden = true
                        self.showAlertPopupWithMessage(msg: results.messages)
                        
                    }
                    else{
                        
                        print("Stop reloading...")
                        self.shouldLoadeMore = false
                        
                    }
                    
                    
                }
                
            } failureHandler: { (error) in
                
                DispatchQueue.main.async {
                
                    self.refreshControl.endRefreshing()
                }
                
                
                self.showErrorMessage(error: error)
            }

            
        }
        else{
            
            self.showAlertPopupWithMessage(msg: "User ID is not available")
            
        }
        
    }
    
    //MARK:- Tabgesture action ---
    
    @objc func profilePicImageViewTapGesture(gesture:UITapGestureRecognizer){
        
        if let _result = self.favoriteUsersList{
            
            
            let obj = _result[gesture.view!.tag]
            
            if let currentUserid = self.currentUserId{
                
                self.pushUserProfileScreen(userId: obj.userid, currentUserId: currentUserid)
                
            }
            
        }
        
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

extension FavoriteUserProfileViewController:UITableViewDelegate, UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell:FavoriteTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell") as! FavoriteTableViewCell
        
        if let _result = self.favoriteUsersList{

            let user = _result[indexPath.row]
            
            cell.profileImageView.sd_setImage(with: URL(string: "\(user.profileImg)"), placeholderImage: UIImage(named: Constants.DEFAULT_PROFILE_PIC))
            cell.profileImageView.changeBorder(width: 1.0, borderColor: .black, cornerRadius: 65/2.0)
            
            cell.profileImageView.tag = indexPath.row
            
            cell.profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.profilePicImageViewTapGesture(gesture:))))

            cell.userNameLabel.text = user.name.capitalized
            
            if self.favoriteUsersList!.count - 1 == indexPath.row{
                
                
                if self.shouldLoadeMore{
                    
                    self.pageNumber = self.pageNumber + 1
                    
                    self.fetchFavoriteUsersList()
                }
                
                
            }
            
            
            return cell
            
        }
       
        
        return UITableViewCell()
        
        
        
    }
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let _result = self.favoriteUsersList{
        
            return  _result.count
            
        }
        return 0
        
    }
    
    
    
}
