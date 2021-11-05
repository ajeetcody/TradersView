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
    
}

class SearchViewController: MasterViewController {
    
    
    @IBOutlet weak var searchView: UISearchBar!
    
    @IBOutlet weak var tableViewSearch: UITableView!
    
    
    var searchResult:[SearchDatum]?
    
    var searchTextStr:String = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.tableViewSearch.isHidden = true

    }
    
    func callSearchApi(){
        
        
        
        if self.searchTextStr.trimmingCharacters(in: .whitespaces).count == 0 {
            
          //  self.showAlertPopupWithMessage(msg: "Please enter all the fields")
            
            self.searchResult?.removeAll()
            self.tableViewSearch.reloadData()
            return
            
        }
        
        if  let userData:LoginUserData = self.appDelegate.loginResponse?.userdata?[0]{

        
            let request:SearchRequest = SearchRequest(_user_id: userData.id , _search: self.searchTextStr, _page: 0)
            
            
            ApiCallManager.shared.apiCall(request: request, apiType: .SEARCH, responseType: SearchResponse.self, requestMethod: .POST) { (results) in
                
                if results.status == 1{
                
                    if let data = results.data{
                        
                        self.searchResult = data
                      
                        
                        self.tableViewSearch.isHidden = false
                        DispatchQueue.main.async {
                        
                            self.tableViewSearch.reloadData()
                            
                        }
                        
                        
                        
                    }
                    else{
                        
                        self.tableViewSearch.isHidden = true
                        self.searchResult?.removeAll()
                        self.tableViewSearch.reloadData()

                        self.showAlertPopupWithMessage(msg: results.messages)
                        
                    }
                    
                }
                else{
                    
                    
                    self.tableViewSearch.isHidden = true
                    self.searchResult?.removeAll()
                    DispatchQueue.main.async {
                    
                        self.tableViewSearch.reloadData()
                    }
                    self.showAlertPopupWithMessage(msg: "No Result Found")

                }
                
                
                
            } failureHandler: { (error) in
                
                self.tableViewSearch.isHidden = true
                self.showErrorMessage(error: error)
            }

        
        
        
        }
        
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    

    
    @objc func profilePicImageViewTapGesture(gesture:UITapGestureRecognizer){
        
        
        
        let obj = self.searchResult![gesture.view!.tag]
            
        
        
        if  let userData:LoginUserData = self.appDelegate.loginResponse?.userdata?[0]{

        
            self.pushUserProfileScreen(userId: obj.userid, currentUserId: userData.id)
            
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
        
        let searchUser = self.searchResult![indexPath.row]
        
        print("imageURL - \(searchUser.profileImg)")
        cell.profileImageView.sd_setImage(with: URL(string: "\(searchUser.profileImg)"), placeholderImage: UIImage(named: "placeholder.png"))
        cell.profileImageView.changeBorder(width: 1.0, borderColor: .black, cornerRadius: 65/2.0)
        
        cell.profileImageView.tag = indexPath.row
        
        cell.profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.profilePicImageViewTapGesture(gesture:))))

        cell.userNameLabel.text = searchUser.name.capitalized
        return cell
        
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let _searchResult = self.searchResult{
        
            return  _searchResult.count
            
        }
        return 0
        
    }
    
}
extension SearchViewController:UISearchBarDelegate{
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {


        self.searchTextStr = searchText

        self.callSearchApi()
        
      }
    
    
}
