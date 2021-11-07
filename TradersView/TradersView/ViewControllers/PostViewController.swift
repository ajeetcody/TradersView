//
//  PostViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 01/11/21.
//

import UIKit

class PostViewController: MasterViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextview: UITextView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var graphButton: UIButton!
    @IBOutlet weak var imgButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    private var userID:String?

    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.postButton.changeBorder(width: 1.0, borderColor: .white, cornerRadius: 10.0)
        
        self.postTextview.changeBorder(width: 1.0, borderColor: .black, cornerRadius: 15.0)
        
        self.postTextview.becomeFirstResponder()
        
        self.postTextview.leftSpace()
        
        if  let userData:LoginUserData = self.appDelegate.loginResponseData{
            
            
            self.userID = userData.id

        }
        else{
            
            self.showAlertPopupWithMessage(msg: "User Data is not available")
        }
        

    }
    
    
    @IBAction func postButtonAction(_ sender: Any) {
        
        print("\(#function)")
      
        
      
        
        let requestPost = AddPostRequest(_id: "", _user_id:self.userID! , _message: self.postTextview.text, _location: "Indore", _latitude: "22.2332", _longitude: "75.2323")
        
        
        if let postImage = self.postImageView.image{
            
            
            ApiCallManager.shared.UploadImage(request: requestPost, apiType: .ADD_POST, uiimagePic: postImage, responseType: AddPostResponse.self) { (response) in
                
                let result:AddPostResponse = response
                print("Result - \(result.messages) -- ")
                
                if result.status == 1 {
                    
                    self.showAlertPopupWithMessageWithHandler(msg: result.messages) {
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                }
                else{
                    
                    self.showAlertPopupWithMessage(msg: result.messages)
                    
                }
                
            } failureHandler: { (error) in
                
                self.showErrorMessage(error: error)
                
            }


            
            
            
        }
        else{
            
            print("Request object post without image - \(#function)")

            print(requestPost.toObjectString())
            
            ApiCallManager.shared.apiCall(request: requestPost, apiType: .ADD_POST, responseType: AddPostResponse.self, requestMethod: .POST) { (results) in
                
                let result:AddPostResponse = results
                print("Result - \(result.messages) -- ")
                
                if result.status == 1 {
                    
                    self.showAlertPopupWithMessageWithHandler(msg: result.messages) {
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                }
                else{
                    
                    self.showAlertPopupWithMessage(msg: result.messages)
                    
                }
                
                
            } failureHandler: { (error) in
                
                self.showErrorMessage(error: error)
                
            }

            
//            ApiCallManager.shared.apiCall(request: requestPost, apiType: .ADD_POST) { (success, data) in
//                
//                
//                UserDefaults.standard.setValue(data, forKey: Constants.USER_DEFAULT_KEY_USER_DATA)
//
//                let parseManager:ParseManager = ParseManager()
//                parseManager.delegate = self
//                parseManager.parse(data: data, apiType: .ADD_POST)
//                
//                
//                
//            } failureHandler: { (error) in
//                
//                self.showErrorMessage(error: error)
//                
//            } somethingWentWrong: {
//                
//                self.showAlertSomethingWentWrong()
//                
//            }

            
            
        }
        
        
        
        
        
        
    }
    
    @IBAction func grpahButtonAction(_ sender: Any) {
        
        print("\(#function)")
        
        self.showAlertCommingSoon()

    }
    
    @IBAction func locationButtonAction(_ sender: Any) {
        print("\(#function)")
        
        self.showAlertCommingSoon()

    }
    
    @IBAction func imgButtonAction(_ sender: Any) {
        
        print("\(#function)")
        
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
    
    @IBAction func closeButtonAction(_ sender: Any) {
        
        print("\(#function)")
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
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
                self.postImageView.image = image
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



//extension PostViewController:UIImagePickerControllerDelegate & UINavigationControllerDelegate{
//
//
//
//   public  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        if let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
//            self.postImageView.image = image
//        }
//
//        print("Testtttt")
//        picker.dismiss(animated: true, completion: nil);
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            self.dismiss(animated: true, completion: nil)
//        }
//
//}
