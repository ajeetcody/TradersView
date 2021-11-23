//
//  PostViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 01/11/21.
//

import UIKit

class PostViewController: MasterViewController {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextview: UITextView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var graphButton: UIButton!
    @IBOutlet weak var imgButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    private var userID:String?
    
    //MARK:- UIViewcontroller lifecycle methods ---
    
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
    
    //MARK:- Image  overriding ---
    
    override func sendImageOnly(img: UIImage, formate:String) {
        
        self.postImageView.image = img
        
    }
    
    override func sendFileURLAfterUpload(imgUrl: String, mediaType: MediaType) {
        
        print("img url - \(imgUrl)")
        print("media type - \(mediaType)")
        
    }
    
    
    
    //MARK:- UIButton action methods ----
    
    @IBAction func postButtonAction(_ sender: Any) {
        
        print("\(#function)")
        
        
        
        
        let requestPost = AddPostRequest(_id: "", _user_id:self.userID! , _message: self.postTextview.text, _location: "Indore", _latitude: "22.2332", _longitude: "75.2323")
        
        
        if let postImage = self.postImageView.image{
            
            self.apiCallPostWithImage(postImage: postImage, requestPost: requestPost)
            
            
            
        }
        else{
            
            self.apiCallPostWithoutImage(requestPost:requestPost)
            
        }
        
        
    }
    
    //MARK:- API call methods ----
    
    
    func apiCallPostWithoutImage(requestPost:AddPostRequest){
        
        
        
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
        
        
        
        
    }
    
    func apiCallPostWithImage(postImage:UIImage, requestPost:AddPostRequest){
        
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
        
        
        self.openCameraOptionActionsheet(shouldUploadOnFirebase: false, isVideo: false)

    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        
        print("\(#function)")
        self.dismiss(animated: true, completion: nil)
        
    }
    
   
    
    
    
    //MARK:- Image fetch actions ---
    
    
    /*
     
     
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


