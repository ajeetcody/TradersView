//
//  SettingsViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 25/10/21.
//

import UIKit

class SettingsViewController: MasterViewController {

    
    @IBOutlet weak var tableViewSettings: UITableView!
    
    
    
    let sectionArray = ["General", "Account", "Privacy", "", "Terms and Conditions", ""]
    
    let rowHeadings:[[String]] =  [["Profile", "Push Notification", "Dark mode"], ["Username","Password","Security"],["Private Account","Blocked Account", "Mute User", "Post ban by You (Police)", "User ban by you (Police)", "Comment", "Tag", "Mention"],["Contact Us"],["SP Softech", "Privacy Policy"],["Subscription", "App version", "Rate our app", "Privacy Policy", "Ads", "Verify ME",""]]
    
    let rowValueTitle:[[String]] =  [["Edit", "", ""], ["","",""],["","View All", "View All", "View All", "View All", "", "", ""],[""],["", ""],["View Plan", "" , "Rate", "Read", "Available Soon", "",""]]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableViewSettings.estimatedRowHeight = 88.0
        self.tableViewSettings.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- UIButton action methods -----
    
    
    @objc func logoutButtonAction(){
        
        print("\(#function)")
        
        self.callLogOutApi()
        
        
    }
    
    //MARK:- Cell button action methods -----
    
    
    @objc func editProfileButtonAction(sender:UIButton){
        
        print("\(#function) - \(sender.tag)")
        
        
        
    }
    
    
    @objc func accountLinkButtonAction(sender:UIButton){
        
        print("\(#function) - \(sender.tag)")
        
        
        
    }
    
    @objc func privacyLinkButtonAction(sender:UIButton){
        
        print("\(#function) - \(sender.tag)")
        
        
        
    }
    
    @objc func lastSectionLinkButtonAction(sender:UIButton){
        
        print("\(#function) - \(sender.tag)")

        
        
    }
    
    //MARK:- Api call for registration ----
    
    
    func callLogOutApi(){
        
        
        if  let userData:LoginUserData = self.appDelegate.loginResponse?.userdata?[0]{
            
            print("Login id  : - \(userData.id)")

            let logoutRequest = LogoutRequest(id: userData.id)
            
            ApiCallManager.apiCall(request: logoutRequest, apiType: .LOGOUT) { (responseString, data) in
                
                
                print("Response : - \(responseString)")
                
                UserDefaults.standard.setValue(data, forKey: Constants.USER_DEFAULT_KEY_USER_DATA)

                let parseManager:ParseManager = ParseManager()
                parseManager.delegate = self
                parseManager.parse(data: data, apiType: .LOGOUT)
                
                
            } failureHandler: { (error) in
                
                
                self.showErrorMessage(error: error)
                
                
            } somethingWentWrong: {
                
                self.showAlertSomethingWentWrong()
                
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

extension SettingsViewController:UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        
        return UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        
        return 40.0
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.screenWidth, height: 40))
        
        sectionHeaderView.backgroundColor = .white
        let headingLabel = UILabel(frame: CGRect(x: 15, y: 0, width: Constants.screenWidth, height: 40))
        
        headingLabel.text = self.sectionArray[section]
        headingLabel.textColor = .black
        sectionHeaderView.addSubview(headingLabel)
        
        return sectionHeaderView
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.sectionArray.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        let tempArray:[String] = self.rowHeadings[section]
        return tempArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let rowTitleArray:[String] = self.rowHeadings[indexPath.section]
        let rowValueArray:[String] = self.rowValueTitle[indexPath.section]
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                
                let cell:SettingsCellLabelAndButton = tableView.dequeueReusableCell(withIdentifier: "SettingsCellLabelAndButton") as! SettingsCellLabelAndButton

                cell.titleLabelSetting.text = rowTitleArray[indexPath.row]
                cell.linkButton.underlineTextButton(title: rowValueArray[indexPath.row], forState: .normal)
                cell.linkButton.tag = indexPath.row
                cell.linkButton.addTarget(self, action: #selector(editProfileButtonAction), for: .touchUpInside)

                print("Title buttons ----- \(rowValueArray[indexPath.row])")
                return cell
                
            }
            else{
                
                let cell:SettingsCellLabelAndSwitch = tableView.dequeueReusableCell(withIdentifier: "SettingsCellLabelAndSwitch") as! SettingsCellLabelAndSwitch

                cell.titleLabelSetting.text = rowTitleArray[indexPath.row]
                
                return cell
                
            }
            
            
        }
        else if indexPath.section == 1 {
            
           
            if indexPath.row == 0 {
                
                let cell:SettingsCellTwoLabels = tableView.dequeueReusableCell(withIdentifier: "SettingsCellTwoLabels") as! SettingsCellTwoLabels

                cell.titleLabelSetting.text = rowTitleArray[indexPath.row]
                cell.detailsLabel.text = "<User Name>"
                
                return cell
                
            }
            else{
                
                let cell:SettingsCellLabelAndButton = tableView.dequeueReusableCell(withIdentifier: "SettingsCellLabelAndButton") as! SettingsCellLabelAndButton

                cell.titleLabelSetting.text = rowTitleArray[indexPath.row]
                cell.linkButton.underlineTextButton(title: rowValueArray[indexPath.row], forState: .normal)
                
                cell.linkButton.tag = indexPath.row
                cell.linkButton.addTarget(self, action: #selector(accountLinkButtonAction), for: .touchUpInside)

                
                return cell
                
            }
            
            
            
            
            
        }
        else if indexPath.section == 2 {
            
            if indexPath.row == 0 {
                
                let cell:SettingsCellLabelAndSwitch = tableView.dequeueReusableCell(withIdentifier: "SettingsCellLabelAndSwitch") as! SettingsCellLabelAndSwitch

                cell.titleLabelSetting.text = rowTitleArray[indexPath.row]
                
                return cell
                
            }
            else if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 {
                
                
                
                let cell:SettingsCellLabelAndButton = tableView.dequeueReusableCell(withIdentifier: "SettingsCellLabelAndButton") as! SettingsCellLabelAndButton

                cell.titleLabelSetting.text = rowTitleArray[indexPath.row]
                cell.linkButton.underlineTextButton(title: rowValueArray[indexPath.row], forState: .normal)
                cell.linkButton.tag = indexPath.row
                cell.linkButton.addTarget(self, action: #selector(privacyLinkButtonAction), for: .touchUpInside)


                return cell
                
            }
            else {
                
                
                
                let cell:SettingsCellTwoLabels = tableView.dequeueReusableCell(withIdentifier: "SettingsCellTwoLabels") as! SettingsCellTwoLabels

                cell.titleLabelSetting.text = rowTitleArray[indexPath.row]
                cell.detailsLabel.text = "<Working>"
                return cell

                
                
            }
            
            
        }
        else if indexPath.section == 3 {
            
            
            let cell:SettingsCellTwoLabels = tableView.dequeueReusableCell(withIdentifier: "SettingsCellTwoLabels") as! SettingsCellTwoLabels

            cell.titleLabelSetting.text = rowTitleArray[indexPath.row]
            cell.detailsLabel.text = rowValueArray[indexPath.row]

            return cell

            
            
            
        }
        else if indexPath.section == 4 {
            
            
            
            let cell:SettingsCellTwoLabels = tableView.dequeueReusableCell(withIdentifier: "SettingsCellTwoLabels") as! SettingsCellTwoLabels

            cell.titleLabelSetting.text = rowTitleArray[indexPath.row]
            cell.detailsLabel.text = rowValueArray[indexPath.row]
            return cell

            
            
        }
        else if indexPath.section == 5 {
            
             if indexPath.row == 1 {
                
                let cell:SettingsCellTwoLabels = tableView.dequeueReusableCell(withIdentifier: "SettingsCellTwoLabels") as! SettingsCellTwoLabels

                cell.titleLabelSetting.text = rowTitleArray[indexPath.row]
                cell.detailsLabel.text = self.appVersion
                return cell

               
            }
             else if indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 3 {
                
                let cell:SettingsCellLabelAndButton = tableView.dequeueReusableCell(withIdentifier: "SettingsCellLabelAndButton") as! SettingsCellLabelAndButton
                
                
                cell.titleLabelSetting.text = rowTitleArray[indexPath.row]
                cell.linkButton.underlineTextButton(title: rowValueArray[indexPath.row], forState: .normal)
                cell.linkButton.tag = indexPath.row
                cell.linkButton.addTarget(self, action: #selector(lastSectionLinkButtonAction), for: .touchUpInside)

                
                
                
                return cell
                
                
                
             }
           else if indexPath.row == 6 {
                
                let cell:SettingsCellButtonOnly = tableView.dequeueReusableCell(withIdentifier: "SettingsCellButtonOnly") as! SettingsCellButtonOnly
                
            cell.logoutButton.changeBorder(width: 1.0, borderColor: .black, cornerRadius: 10.0)
                

            cell.logoutButton.addTarget(self, action: #selector(logoutButtonAction), for: .touchUpInside)
            
            return cell
            }
            
           else{
               
               let cell:SettingsCellTwoLabels = tableView.dequeueReusableCell(withIdentifier: "SettingsCellTwoLabels") as! SettingsCellTwoLabels

               cell.titleLabelSetting.text = rowTitleArray[indexPath.row]
               cell.detailsLabel.text = rowValueArray[indexPath.row]
               return cell


           }
            
           
            
            
        }
        
        return UITableViewCell()
    }
    
    
}

extension SettingsViewController:ParseManagerDelegate{
   
    
    func parseSuccessHandler(response: ResponseModel) {
        
        print("\(#function)")
        
        
        
        let logoutResonse:LogoutResponse = response as! LogoutResponse
        
        if logoutResonse.status != 1 {
            
            self.showAlertPopupWithMessage(msg: logoutResonse.messages)
            
        }
        else{
            
            self.showAlertPopupWithMessageWithHandler(msg: "Logout Successfully Successfully!!") {
                
                
                self.appDelegate.loginResponse = nil
                UserDefaults.standard.setValue(nil, forKey: Constants.USER_DEFAULT_KEY_USER_DATA)
                
                self.navigationController?.tabBarController?.navigationController?.popViewController(animated: true)
            }
            
            
        }
        
    }
    func parseErrorHandler(error: Error) {
        print("\(#function)")
        self.showErrorMessage(error: error)
    }
    
    func parseSomethingWentWrong() {
        print("\(#function)")
        self.showAlertSomethingWentWrong()
        
    }
}
