//
//  CreateGroupViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 17/11/21.
//

import UIKit

class CreateGroupViewController: MasterViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var publicSwitch: UISwitch!
    @IBOutlet weak var groupNameTextfield: UITextField!
    @IBOutlet weak var searchView: UISearchBar!
    
    @IBOutlet weak var tableViewSearch: UITableView!
    
    private var workItemReference:DispatchWorkItem? = nil
    
    fileprivate var searchVM = SearchViewModel()
    
    
    
    //MARK:- UIViewcontroller lifecycle methods ---
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableViewSearch.isHidden = true
        self.searchView.barTintColor = UIColor.clear
        self.searchView.backgroundColor = UIColor.clear
        self.searchView.isTranslucent = true
        self.searchView.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        self.searchView.searchTextField.font = UIFont.systemFont(ofSize: 18.0)
        
        if  let userData:LoginUserData = self.appDelegate.loginResponseData{
            
            self.searchVM.userData = userData
            
        }
        
        self.groupImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.groupImageSelected(gesture:))))
        
        self.groupImageView.changeBorder(width: 1.0, borderColor: .lightGray, cornerRadius: 45.0)
        
    }
    
    
    
    //MARK:- UIButton action methods ----
    
    @IBAction func publicSwitchAction(_ sender: UISwitch) {
        
        print(sender.isOn)
        
    }
    
    @IBAction func createGroupButtonAction(_ sender: Any)
    {
        
        
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    //MRK:- Call search API --
    
    
    func callSearchApi(){
        
        
        
        
        self.searchVM.callSearchApiModelView {
            
            
            DispatchQueue.main.async {
                
                self.tableViewSearch.isHidden = false
                self.tableViewSearch.reloadData()
                
            }
            
            
            
        } errorHandler: { (errorMessage) in
            
            
            self.showAlertPopupWithMessage(msg: errorMessage)
            
            
        }
        
        
        
    }
    
    
    //MARK:- UITapgesture action methods ----
    
    @objc func groupImageSelected(gesture:UITapGestureRecognizer){
        
        
        let actionSheet = UIAlertController(title: "Select Option", message: "", preferredStyle: .actionSheet)
        
        let actionLibrary = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            
            self.fetchImages(sourceType: .photoLibrary)
            
        }
        let actionCamera = UIAlertAction(title: "Camera", style: .default) { (action) in
            
            
            self.fetchImages(sourceType: .camera)
            
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            
            debugPrint("Cancel the photo options")
            
            
        }
        
        
        actionSheet.addAction(actionLibrary)
        actionSheet.addAction(actionCamera)
        actionSheet.addAction(actionCancel)
        
        self.present(actionSheet, animated: true, completion: nil)
        
        
        
    }
    
    
    
    //MARK:- Image fetch actions ---
    
    
    
    func fetchImages(sourceType:UIImagePickerController.SourceType){
        
        let imgPickerController = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType){
            
            imgPickerController.sourceType = sourceType
            imgPickerController.allowsEditing = true
            imgPickerController.delegate = self
            imgPickerController.modalPresentationStyle = .fullScreen
            self.present(imgPickerController, animated: true, completion: nil)
            
        }
        
        else{
            
            self.showAlertPopupWithMessage(msg: sourceType == .camera ?  "Camera is not available" :  "Photo library is not available")
            
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print("\(#function)")
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
            self.groupImageView.image = image
        }
        
        print("Testtttt")
        picker.dismiss(animated: true, completion: nil);
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil);
        
        
        print("\(#function)")
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

extension CreateGroupViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell:SearchCell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchCell
        
        if let searchResult = self.searchVM.searchResult{
            
            let searchUser = searchResult[indexPath.row]
            
            cell.profileImageView.sd_setImage(with: URL(string: "\(searchUser.profileImg)"), placeholderImage: UIImage(named: "placeHolderProfileImage.jpeg"))
            cell.profileImageView.changeBorder(width: 1.0, borderColor: .black, cornerRadius: 65/2.0)
            
            cell.profileImageView.tag = indexPath.row
            
            
            cell.nameLabel.text = searchUser.name.capitalized
            cell.userNameLabel.text = "@\(searchUser.username.capitalized)"
            
            
            if self.searchVM.checkUserIsSelected(userData: searchUser){
                
                cell.accessoryType = .checkmark
                
            }
            else{
                
                cell.accessoryType = .none
                
            }
            
            
            
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        if let searchResult = self.searchVM.searchResult{
            
            let obj = searchResult[indexPath.row]
            
            if self.searchVM.checkUserIsSelected(userData: obj){
                
                self.searchVM.removeUserFromSelectedList(userData: obj)
            }
            else{
            
                self.searchVM.selectedUserData.append(obj)
                
            }
            
            
            print(obj.name)
            self.tableViewSearch.reloadData()
        }
        
        
        
        
    }
    
}
extension CreateGroupViewController:UISearchBarDelegate{
    
    
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

extension CreateGroupViewController:UITextFieldDelegate{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
}
