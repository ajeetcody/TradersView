//
//  MasterViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 17/10/21.
//

import UIKit
import NVActivityIndicatorView
import Firebase
import FirebaseFirestore
import FirebaseStorage


enum MediaType {
    case IMAGE
    case VIDEO
    
}


class MasterViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    
    var loadingView:NVActivityIndicatorView!
    var ref:DatabaseReference =  Database.database().reference()

    let lock = NSLock()
    let appDelegate:AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
    
    var appVersion:String = ""
    var shouldUploadOnFirebase:Bool = false
    var isVideo:Bool = false
    //MARK:- UIViewcontroller lifecycle methods ---

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.appVersion = version
       }
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        loadingView = NVActivityIndicatorView(frame: CGRect(x: Constants.screenWidth - 80, y: Constants.screenHeight - 80, width: 80, height: 80), type: .circleStrokeSpin, color: .black, padding: 20)
        
        
        self.view.addSubview(loadingView)
        self.loadingView.center = self.view.center
        // Do any additional setup after loading the view.
    }
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    //MARK:- Viewcontroller Present ----
    
    func pushChatScreen(dataObj:MyChatScreenModel, chatType:ChatType){
        
        DispatchQueue.main.async {
            
            let dashBoardStoryBoard = UIStoryboard(name: "Chat", bundle: nil)
            let vc:MyChatViewController = dashBoardStoryBoard.instantiateViewController(identifier: "MyChatViewController")
            
            vc.myChatScreenModelObj = dataObj
            vc.chat_VM.chatType = chatType
            
            self.appDelegate.mainNavigation?.pushViewController(vc, animated: true)
            
        }
        
    }
    func pushScreenWithScreenName(screenName:String, currentUserId:String){
        
        DispatchQueue.main.async {
            
            let dashBoardStoryBoard = UIStoryboard(name: "DashboardFlow", bundle: nil)
            let vc = dashBoardStoryBoard.instantiateViewController(identifier: screenName)
            
            self.appDelegate.mainNavigation?.pushViewController(vc, animated: true)
            
        }
        
    }
    

//    func showNotificationScreen(){
//
//
//        //NotificationViewController
//
//        DispatchQueue.main.async {
//
//        let dashBoardStoryBoard = UIStoryboard(name: "DashboardFlow", bundle: nil)
//            let vc = dashBoardStoryBoard.instantiateViewController(identifier: "NotificationViewController")
//
//
//        self.appDelegate.mainNavigation?.pushViewController(vc, animated: true)
//
//        }
//
//    }
//
//    func showContactUsScreen(){
//
//
//        DispatchQueue.main.async {
//
//        let dashBoardStoryBoard = UIStoryboard(name: "DashboardFlow", bundle: nil)
//            let vc = dashBoardStoryBoard.instantiateViewController(identifier: "ContactUsViewController")
//
//
//        self.appDelegate.mainNavigation?.pushViewController(vc, animated: true)
//
//        }
//
//    }
    func showBlockAndMuteScreen(isBLock:Bool){
       
        DispatchQueue.main.async {
        
        let dashBoardStoryBoard = UIStoryboard(name: "DashboardFlow", bundle: nil)
            let vc:BlockAndMuteViewController = dashBoardStoryBoard.instantiateViewController(identifier: "BlockAndMuteViewController")
            
            vc.isBlockUserList = isBLock
            
        self.appDelegate.mainNavigation?.pushViewController(vc, animated: true)
        
        }
        
    }
    
//
//    func showResetPasswordScreen(){
//
//        DispatchQueue.main.async {
//
//        let dashBoardStoryBoard = UIStoryboard(name: "DashboardFlow", bundle: nil)
//        let vc = dashBoardStoryBoard.instantiateViewController(identifier: "ChangePasswordViewController")
//
//        self.appDelegate.mainNavigation?.pushViewController(vc, animated: true)
//
//        }
//
//    }
    
//
//    func showSearchViewController(){
//
//        DispatchQueue.main.async {
//
//        let dashBoardStoryBoard = UIStoryboard(name: "DashboardFlow", bundle: nil)
//        let vc = dashBoardStoryBoard.instantiateViewController(identifier: "SearchViewController")
//
//            print("Show tabbar controller")
//        self.appDelegate.mainNavigation?.pushViewController(vc, animated: true)
//
//        }
//
//    }
    
    //MARK:- Viewcontroller Navigation ----
    
    
    func pushCommentScreen(postId:String, notifyUserId:String){
        
        
        print("post id before showing the comment screen - \(postId)")
        
        DispatchQueue.main.async {
            
            let dashBoardStoryBoard = UIStoryboard(name: "DashboardFlow", bundle: nil)
            let vc:CommentListViewController = dashBoardStoryBoard.instantiateViewController(identifier: "CommentListViewController")
            
            vc.postId = postId
            vc.notifyToUserOfPost = notifyUserId
            self.appDelegate.mainNavigation?.pushViewController(vc, animated: true)

            
        }
        
    }
    
    func pushFollowerFollowingList(userId:String, currentUserId:String, flag:String){
        
        
        DispatchQueue.main.async {
            
            let dashBoardStoryBoard = UIStoryboard(name: "DashboardFlow", bundle: nil)
            let vc:FollowersFollowingViewController = dashBoardStoryBoard.instantiateViewController(identifier: "FollowersFollowingViewController")
            
            vc.userId = userId
            vc.fetchFlag = flag
            
            self.appDelegate.mainNavigation?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    func pushUserProfileScreen(userId:String, currentUserId:String){
        
        
        DispatchQueue.main.async {
            
            let dashBoardStoryBoard = UIStoryboard(name: "DashboardFlow", bundle: nil)
            let vc:UserProfileViewController = dashBoardStoryBoard.instantiateViewController(identifier: "UserProfileViewController")
            
            vc.userIDOfProfile = userId
            
            self.appDelegate.mainNavigation?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    
    func showTabbarController(animated:Bool){
       
        DispatchQueue.main.async {
        
        let dashBoardStoryBoard = UIStoryboard(name: "DashboardFlow", bundle: nil)
        let tbBarController = dashBoardStoryBoard.instantiateViewController(identifier: "MyTabbarController")
            
            print("Show tabbar controller")
        self.appDelegate.mainNavigation?.pushViewController(tbBarController, animated: animated)
        
        }
        
    }
    
    
    //MARK:- Textfield Empty Validation
    
    func isTextfieldEmpty(textFields:[UITextField])->Bool{
        
        for textField in textFields{
            
            
            if textField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                
                self.showAlertPopupWithMessage(msg: "Please enter all the fields")
                return true
                
            }
        }
        
        return false
        
    }
    
    
    //MARK:- Photo select - 1
    
    func openCameraOptionActionsheet(shouldUploadOnFirebase:Bool, isVideo:Bool){
        
        self.shouldUploadOnFirebase = shouldUploadOnFirebase
        self.isVideo = isVideo
        
        
        let actionSheet = UIAlertController(title: "Select Option", message: "", preferredStyle: .actionSheet)
        
        let actionLibrary = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            
            self.fetchImages(sourceType: .savedPhotosAlbum)
            
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
    
    
    
    func fetchImages(sourceType:UIImagePickerController.SourceType){
        
        let imgPickerController = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType){
            
            imgPickerController.sourceType = sourceType
            
            if self.isVideo{
            
                print("Open camera - with video and image")
                imgPickerController.mediaTypes = ["public.image", "public.movie"]
                
            }
            else{
                print("Open camera - with image")
                imgPickerController.mediaTypes = ["public.image"]
                
            }
            
            //imgPickerController.allowsEditing = true
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
    
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! String
        
        
        
        if mediaType  == "public.image" {
            print("Image Selected")
            
            self.selectImageForSending(info: info)
            
            
        }
        else if mediaType == "public.movie" {
            print("Video Selected")
            
            self.selectVideoForSending(info: info)
        }
        
        
        
        picker.dismiss(animated: true, completion: nil);
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil);
        
        
        print("\(#function)")
    }
    
    //MARK:- Select Image ---
    
    
    func selectImageForSending(info:[UIImagePickerController.InfoKey : Any]){
        
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
            
            var imgFormate = "JPG"
            
            
            let assetPath = info[UIImagePickerController.InfoKey.referenceURL] as! NSURL
            if (assetPath.absoluteString?.hasSuffix("JPG"))! {
                print("JPG")
                imgFormate = "JPG"
            }
            else if (assetPath.absoluteString?.hasSuffix("PNG"))! {
                print("PNG")
                
                imgFormate = "PNG"
            }
            else if (assetPath.absoluteString?.hasSuffix("GIF"))! {
                print("GIF")
                
                imgFormate = "GIF"
            }
            else {
                print("Unknown")
                
                imgFormate = "Unknown"
            }
            
            
            self.loadingView.stopAnimating()
          
           if self.shouldUploadOnFirebase{
                
            self.uploadImageToStorageFirebase(img: image, formate: imgFormate)

                
            }
            else{
                
                self.sendImageOnly(img: image, formate: imgFormate)

            }

            
            
            

            
            
        }
        
    }
    
    //MARK:- Select Video ---
    func selectVideoForSending(info:[UIImagePickerController.InfoKey : Any]){
        
        
        let  videoURL = info[UIImagePickerController.InfoKey.mediaURL]as? NSURL
        
        print(videoURL!)
        
        
        
        self.uploadVideoToStorageFirebase(videoUrl: videoURL! as URL, formate: "mov")
        
        
        
    }
    
    
    func sendFileURLAfterUpload(imgUrl:String, mediaType:MediaType){
        
        
     //   print("ImageURL - \(imgUrl)")
        
        
    }
    
    
    //MARK:- Firebase call ---
    func uploadVideoToStorageFirebase(videoUrl:URL, formate:String){
        
        
        self.loadingView.startAnimating()

        do {
            
            let videoData = try Data(contentsOf: videoUrl)
            
            let fileName = "\(Int(Date().timeIntervalSince1970)).\(formate)"
            
            let storageReference = Storage.storage().reference().child("video").child(fileName)
            
            
            print("Video file name - \(fileName)")
            
            _ = storageReference.putData(videoData, metadata: nil) { (storageMetaData, error) in
                
                self.loadingView.stopAnimating()
                
                if let error = error {
                    print("Upload error: \(error.localizedDescription)")
                    return
                }
                
                print("Image file: \(fileName) is uploaded! View it at Firebase console!")
                
                storageReference.downloadURL { (url, error) in
                    if let error = error  {
                        print("Error on getting download url: \(error.localizedDescription)")
                        return
                    }
                    
                    self.loadingView.stopAnimating()
                    self.sendFileURLAfterUpload(imgUrl: url!.absoluteString, mediaType: .VIDEO)
                   
                    
                    
                    
                }
            }
            
            
            
            
        } catch {
            
            self.loadingView.stopAnimating()
            print("Error on extracting data from url: \(error.localizedDescription)")
        }
        
        
    }
    
    func sendImageOnly(img:UIImage, formate:String){
        
        
        
        
    }
    
    func uploadImageToStorageFirebase(img:UIImage, formate:String){
        
        //  let storageRef = FIRStorage.storage().reference().child("myImage.png")
        
        self.loadingView.startAnimating()
        do {
            // Create file name
            //  let fileExtension = fileUrl.pathExtension
            let fileName = "\(Int(Date().timeIntervalSince1970)).\(formate)"
            
            let storageReference = Storage.storage().reference().child("uploads").child(fileName)
            
            //let task = storageReference.putData(img.pngData(), metadata: StorageMetadata(dictionary: [:]))
            
            _ = storageReference.putData(img.jpegData(compressionQuality: 1.0)!, metadata: nil) { (storageMetaData, error) in
                
                self.loadingView.stopAnimating()
                if let error = error {
                    print("Upload error: \(error.localizedDescription)")
                    return
                }
                
                // Show UIAlertController here
                print("Image file: \(fileName) is uploaded! View it at Firebase console!")
                
                storageReference.downloadURL { (url, error) in
                    if let error = error  {
                        print("Error on getting download url: \(error.localizedDescription)")
                        return
                    }
                    print("Download url of \(fileName) is \(url!.absoluteString)")
                    print("path url of \(fileName) is \(url!.path)")

                  
                    self.loadingView.stopAnimating()
                    self.sendFileURLAfterUpload(imgUrl: url!.absoluteString, mediaType: .IMAGE)

                    
                    
                    
                }
            }
            
            
            
            
        } catch {
            self.loadingView.stopAnimating()
            print("Error on extracting data from url: \(error.localizedDescription)")
        }
        
        
    }
    //MARK:- Alert popup ----
    
    
    fileprivate func masterAlertPopup(title:String, message:String){
        
        DispatchQueue.main.async {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        
    }
    
    func showErrorMessage(error:Error){
        
        DispatchQueue.main.async {

        
        self.masterAlertPopup(title: "Error", message: "\(error.localizedDescription). Please try again.")
        
        }
        
        
    }
    
    func showAlertCommingSoon(){
        
        
        DispatchQueue.main.async {

        self.masterAlertPopup(title: "Message", message: "We are working on this feature")
        
        }
    }
    
    
    
    func showAlertPopupWithMessage(msg:String){
        
        
        DispatchQueue.main.async {

        self.masterAlertPopup(title: "Message", message: msg)
        
        }
    }
    
    
    func showAlertSomethingWentWrong(){
        
        
        DispatchQueue.main.async {

        self.masterAlertPopup(title: "Message", message: "Something went wrong")
        
        }
        
    }
    
    func showAlertPopupWithMessageWithHandler(msg:String, handler:@escaping()->Void){
        
        
        DispatchQueue.main.async {

       
            
            let alertController = UIAlertController(title: "Message", message: msg, preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
                
                handler()
                
                
            }
            alertController.addAction(defaultAction)
        
        
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        
        
    }
    
    func areYouSureAlertPopup(title:String, msg:String, yesHandler:@escaping()->Void, noHandler:@escaping()->Void ){
        
        
        DispatchQueue.main.async {

       
            
            let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                
                yesHandler()
                
                
            }
            
            let noAction = UIAlertAction(title: "No", style: .cancel) { (action) in
                
                noHandler()
                
                
            }
            alertController.addAction(yesAction)
            alertController.addAction(noAction)

        
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        
        
    }
    
    func changeDateFormateToDisplay(dateString:String)->String{
        
        
        print("Date before - \(dateString) \n ")
        

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        dateFormatter.locale = NSLocale.current

           

        
        guard let myDate = dateFormatter.date(from: dateString) else {
            fatalError("ERROR: Date conversion failed due to mismatched format.")
        }
            dateFormatter.dateFormat = "MMM dd, YYYY, hh:mm a"
            let somedateString = dateFormatter.string(from: myDate)
        
        
        

        //print("Date after - \(somedateString)")
        return somedateString
        
    }
   
    
    func changeLikeButtonIconAndCount(results:LikePostResponse, imgViewLike:UIImageView, likeCountLabel:UILabel){
        
        
        
        lock.lock()
        
        var currentValue = 0
        
        DispatchQueue.main.async {
            
            currentValue =   Int(likeCountLabel.text!)!
        
        
        if results.like == 1 {
            
            
            
            currentValue = currentValue + 1
            
            
            
            DispatchQueue.main.async {
                
                imgViewLike.image = UIImage(named: "like-filled")
                likeCountLabel.text = "\(currentValue)"
                print("currentValue --- \(currentValue)")
            }
            
        }
        else{
            
            
            currentValue = currentValue - 1
            
            if currentValue < 0{
                
                currentValue = 0
            }
            
            
            DispatchQueue.main.async {
                
                likeCountLabel.text = "\(currentValue)"
                imgViewLike.image = UIImage(named: "like-empty")
            }
            
        }
        
    }
        
        lock.unlock()
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


extension MasterViewController:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
