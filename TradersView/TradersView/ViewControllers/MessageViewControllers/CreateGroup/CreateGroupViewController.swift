//
//  CreateGroupViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 17/11/21.
//

import UIKit

class CreateGroupViewController: MasterViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var cancelButton: UIButton!

    @IBOutlet weak var createGroupButton: UIButton!
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var publicSwitch: UISwitch!
    @IBOutlet weak var groupNameTextfield: UITextField!
    @IBOutlet weak var searchView: UISearchBar!
    
    @IBOutlet weak var tableViewSearch: UITableView!
    
    private var workItemReference:DispatchWorkItem? = nil
    
    
    fileprivate var chatUserList_VM = ChatUserListViewModel()
    
    
    //MARK:- UIViewcontroller lifecycle methods ---
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableViewSearch.isHidden = true
        self.searchView.barTintColor = UIColor.clear
        self.searchView.backgroundColor = UIColor.clear
        self.searchView.isTranslucent = true
        self.searchView.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        self.searchView.searchTextField.font = UIFont.systemFont(ofSize: 18.0)
        
       
        
        self.groupImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.groupImageSelected(gesture:))))
        
        self.groupImageView.changeBorder(width: 1.0, borderColor: .lightGray, cornerRadius: 45.0)
        
        self.createGroupButton.changeBorder(width: 1.0, borderColor: .lightGray, cornerRadius: 8.0)
        self.cancelButton.changeBorder(width: 1.0, borderColor: .lightGray, cornerRadius: 8.0)

        
        self.fetchChatUserList()
        
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
    
   
    //MARK:- Fetch Chat user list ---
    
    
    func fetchChatUserList(){
        
        self.chatUserList_VM.fetchChatUserList {
            
            
            print("--- Fetch chat user list ---")
            
            self.tableViewSearch.isHidden = self.chatUserList_VM.chatUserList.count > 0 ?  false :  true
            
          
            self.tableViewSearch.reloadData()
            
            
        }
        
        
    }
    
    //MRK:- Call search API --

    
    
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
        

            let searchUser = self.chatUserList_VM.filterUserList[indexPath.row]

            cell.profileImageView.sd_setImage(with: URL(string: "\(searchUser.imageURL)"), placeholderImage: UIImage(named: "placeHolderProfileImage.jpeg"))
            cell.profileImageView.changeBorder(width: 1.0, borderColor: .black, cornerRadius: 65/2.0)

            cell.profileImageView.tag = indexPath.row


            cell.nameLabel.text = searchUser.username.capitalized
            cell.userNameLabel.text = "@\(searchUser.psd.capitalized)"


            if self.chatUserList_VM.checkUserIsSelected(userData: searchUser){

                cell.accessoryType = .checkmark

            }
            else{

                cell.accessoryType = .none

            }




        
        
        return cell
        
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.chatUserList_VM.filterUserList.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        

            let obj = self.chatUserList_VM.chatUserList[indexPath.row]

            if self.chatUserList_VM.checkUserIsSelected(userData: obj){

                self.chatUserList_VM.removeUserFromSelectedList(userData: obj)
            }
            else{

                self.chatUserList_VM.selectedUserData.append(obj)

            }


          //  print(obj.name)
            
            self.tableViewSearch.reloadData()
       
        
    }
    
}
extension CreateGroupViewController:UISearchBarDelegate{
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        if searchText.trimmingCharacters(in: .whitespaces).count == 0{
            
            
            self.chatUserList_VM.filterUserList = self.chatUserList_VM.chatUserList
            self.tableViewSearch.reloadData()
            return
        }
        
        print("\(#function) - 1 \(searchText)")
        self.chatUserList_VM.filterUserList =   self.chatUserList_VM.chatUserList.filter { (userModel) -> Bool in
            
            print("\(userModel.username) == \(searchText)")
            
            return userModel.username.containsIgnoringCase(find: searchText)
        }
        
        print("\(#function) - 2")
        self.tableViewSearch.reloadData()
        
        
        
    }
    
    
}

extension CreateGroupViewController:UITextFieldDelegate{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
}
