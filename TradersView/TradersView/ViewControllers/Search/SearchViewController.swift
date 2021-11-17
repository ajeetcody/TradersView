//
//  SearchViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 03/11/21.
//

import UIKit

class SearchCell:UITableViewCell{
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

}

class SearchViewController: MasterViewController {
    
    
    @IBOutlet weak var searchView: UISearchBar!
    
    @IBOutlet weak var tableViewSearch: UITableView!
    
    private var workItemReference:DispatchWorkItem? = nil
    
    fileprivate var searchVM = SearchViewModel()
    
   // let lock = NSLock()
    
    
    //MARK:- UIViewcontroller lifecycle methods ---

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableViewSearch.isHidden = true
        self.searchView.barTintColor = UIColor.clear
        self.searchView.backgroundColor = UIColor.clear
        self.searchView.isTranslucent = true
        self.searchView.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        self.searchView.searchTextField.textColor = UIColor.white
        self.searchView.searchTextField.font = UIFont.systemFont(ofSize: 18.0)

        if  let userData:LoginUserData = self.appDelegate.loginResponseData{

            self.searchVM.userData = userData
            
        }
        
    }
    

    
    //MARK:- UIButton action methods ----

    
    @IBAction func closeButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    //MRK:- Call search API --
    
    
    func callSearchApi(){
        
        
        
       // lock.lock()
        
        self.searchVM.callSearchApiModelView {
            
          
            DispatchQueue.main.async {
                
                self.tableViewSearch.isHidden = false
                self.tableViewSearch.reloadData()
                
            }
            
            
            
        } errorHandler: { (errorMessage) in
            
            
            self.showAlertPopupWithMessage(msg: errorMessage)
            
            
        }


      //  lock.unlock()
        //self.searchVM.
        
        
    }
    

    //MARK:- UITapgesture action methods ----

    @objc func profilePicImageViewTapGesture(gesture:UITapGestureRecognizer){
        
        if let searchResult = self.searchVM.searchResult{
            
            let obj = searchResult[gesture.view!.tag]

            if  let userData:LoginUserData = self.appDelegate.loginResponseData{

            
                self.pushUserProfileScreen(userId: obj.userid, currentUserId: userData.id)
                
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

extension SearchViewController:UITableViewDelegate, UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell:SearchCell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchCell
        
        if let searchResult = self.searchVM.searchResult{

        let searchUser = searchResult[indexPath.row]
        
        cell.profileImageView.sd_setImage(with: URL(string: "\(searchUser.profileImg)"), placeholderImage: UIImage(named: "placeHolderProfileImage.jpeg"))
        cell.profileImageView.changeBorder(width: 1.0, borderColor: .black, cornerRadius: 65/2.0)
        
        cell.profileImageView.tag = indexPath.row
        
        cell.profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.profilePicImageViewTapGesture(gesture:))))

        cell.nameLabel.text = searchUser.name.capitalized
            cell.userNameLabel.text = "@\(searchUser.username.capitalized)"
            
            if self.searchVM.shouldLoadMoreData &&  !self.searchVM.isFetching{
                
                
                self.callSearchApi()
                
                
            }
            else{
                
                debugPrint("Load more stopped -- \(#function)")
                
            }
            
            
            
        }
        
        return cell
        
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let _searchResult = self.searchVM.searchResult{
        
            return  _searchResult.count
            
        }
        return 0
        
    }
    
}
extension SearchViewController:UISearchBarDelegate{
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        workItemReference?.cancel()
        

        let workItem = DispatchWorkItem{
            
            
            self.searchVM.searchString = searchText
            self.searchVM.page = 0
            self.searchVM.shouldLoadMoreData = true
            self.callSearchApi()

            
        }
         
        workItemReference = workItem

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: workItem)
        
        
      }
    
    
}
