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
    
    private var workItemReference:DispatchWorkItem? = nil
    
    var searchResult:[SearchDatum]?
    
    
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

    }
    
    private func callSearchApi(searchStr:String){
        
        
        
        if searchStr.trimmingCharacters(in: .whitespaces).count == 0 {
            
          //  self.showAlertPopupWithMessage(msg: "Please enter all the fields")
            
            self.searchResult?.removeAll()
            self.tableViewSearch.reloadData()
            return
            
        }
        
        if  let userData:LoginUserData = self.appDelegate.loginResponseData{

        
            let request:SearchRequest = SearchRequest(_user_id: userData.id , _search: searchStr, _page: 0)
            
            
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
    
    //MARK:- UIButton action methods ----

    
    @IBAction func closeButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    

    //MARK:- UITapgesture action methods ----

    @objc func profilePicImageViewTapGesture(gesture:UITapGestureRecognizer){
        
        
        
        let obj = self.searchResult![gesture.view!.tag]
            
        
        
        if  let userData:LoginUserData = self.appDelegate.loginResponseData{

        
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
        
        cell.profileImageView.sd_setImage(with: URL(string: "\(searchUser.profileImg)"), placeholderImage: UIImage(named: "placeHolderProfileImage.jpeg"))
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

        workItemReference?.cancel()
        

        let workItem = DispatchWorkItem{
            
            self.callSearchApi(searchStr: searchText)

            
        }
         
        workItemReference = workItem

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: workItem)
        
        
      }
    
    
}
