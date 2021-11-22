//
//  MyChatViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 21/11/21.
//

import UIKit
import AVKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

class PlayerView: UIView {
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self;
    }

    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer;
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player;
        }
        set {
            playerLayer.player = newValue;
        }
    }
}

class ChatTextRightCell: UITableViewCell{
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    @IBOutlet weak var messageLabel: PaddingLabel!
    
    
}
class ChatTextLeftCell: UITableViewCell{
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    @IBOutlet weak var messageLabel: PaddingLabel!
    
    
}
class ChatImageRightCell: UITableViewCell{
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var imageChatImageView: UIImageView!
    
}
class ChatImageLeftCell: UITableViewCell{
   
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var imageChatImageView: UIImageView!

    
}

class ChatVideoLeftCell: UITableViewCell{
   
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var videoView: PlayerView!
    
}
class ChatVideoRightCell: UITableViewCell{
   
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var videoView: PlayerView!
    
}

struct MyChatScreenModel{
    
    var currentUserImageUrl:String = "https://spsofttech.com/projects/treader/images/dummy.png"

    var currentUserName:String = "Ajeet Sharma"
    var currentUserId:String = "318"
   
    var otherUserId:String = "319"
    var otherUserName:String = "NA"
    var isGroupChat:Bool = false

}

class MyChatViewController:  MasterViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {


    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var tableViewMessages: UITableView!
    @IBOutlet weak var textViewChat: UITextView!
    
    var chat_VM =  MyChatViewModel()
    
    var myChatScreenModelObj:MyChatScreenModel?
    
    //MARK:- UIViewcontroller delegate ----
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        self.fetchMessages()
        self.fetchNewAddedMessage()
        self.headingLabel.text = "Chat with \(myChatScreenModelObj!.otherUserName)"
        self.tableViewMessages.estimatedRowHeight = 80.0
        self.tableViewMessages.rowHeight = UITableView.automaticDimension
        self.textViewChat.changeBorder(width: 1.0, borderColor: .lightGray, cornerRadius: 5.0)
    }
    
    
    
    //MARK:- View model request for messages --
    
    func fetchMessages(){
        
        self.chat_VM.currentUserId = self.myChatScreenModelObj!.currentUserId
        self.chat_VM.otherUserId = self.myChatScreenModelObj!.otherUserId
        
        self.chat_VM.fetchAllMessages {
            
            
            self.tableViewMessages.reloadData()
            
            
            self.tableViewMessages.scrollToRow(at: IndexPath(row: self.chat_VM.messageList.count - 1, section: 0), at: .bottom, animated: true)
            debugPrint("Crash point ----")
            
        }
    }
    
    func fetchNewAddedMessage(){
        
        
//        self.chat_VM.currentUserId = self.myChatScreenModelObj!.currentUserId
//        self.chat_VM.otherUserId = self.myChatScreenModelObj!.otherUserId
//
//        self.chat_VM.fetchNewAddedMessage {
//
//
//            self.tableViewMessages.reloadData()
//
//
//        }
        
        
    }
    
    //MARK:- Image fetch actions ---
    
    
    
    func fetchImages(sourceType:UIImagePickerController.SourceType){
        
        let imgPickerController = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType){
            
            imgPickerController.sourceType = sourceType
            imgPickerController.mediaTypes = ["public.image", "public.movie"]
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
        
        
        var imgFormate = "JPG"
        
        
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! String
        
        if mediaType  == "public.image" {
            print("Image Selected")
            
            self.selectImageForSending(info: info)
            
            
        }
        else if mediaType == "public.movie" {
            print("Video Selected")
            
            self.selectVideoForSending(info: info)
        }
        
        
        
        //print("Testtttt")
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
            
            
            self.uploadImageToStorageFirebase(img: image, formate: imgFormate)
            
            
            
        }
        
    }
    
    //MARK:- Select Video ---
    func selectVideoForSending(info:[UIImagePickerController.InfoKey : Any]){
        
        
        let  videoURL = info[UIImagePickerController.InfoKey.mediaURL]as? NSURL
        
        print(videoURL!)
        
        self.uploadVideoToStorageFirebase(videoUrl: videoURL! as URL, formate: "mov")
        
        
        
    }
    
    //MARK:- UIButton action methods ------
    
    @IBAction func takePhotoVideoAction(_ sender: Any) {
        
        
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
    
    @IBAction func sendButtonAction(_ sender: Any) {
        
        
        if self.textViewChat.text.trimmingCharacters(in: .whitespaces).count != 0 {
            
            self.sendMessaage(msg: self.textViewChat.text, messageType: "text")
            self.textViewChat.text = ""
            
        }
    }
    
    //MARK:- Firebase call ---
    func uploadVideoToStorageFirebase(videoUrl:URL, formate:String){
        
        //  let storageRef = FIRStorage.storage().reference().child("myImage.png")
        
        
        //        let name = "\(Int(Date().timeIntervalSince1970)).mp4"
        
        self.loadingView.startAnimating()

        do {
            
            let videoData = try Data(contentsOf: videoUrl)
            
            // Create file name
            //  let fileExtension = fileUrl.pathExtension
            let fileName = "\(Int(Date().timeIntervalSince1970)).\(formate)"
            
            let storageReference = Storage.storage().reference().child("video").child(fileName)
            
            //let task = storageReference.putData(img.pngData(), metadata: StorageMetadata(dictionary: [:]))
            
            print("Video file name - \(fileName)")
            
            _ = storageReference.putData(videoData, metadata: nil) { (storageMetaData, error) in
                
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
                    //  print("baseURL  of \(fileName) is \(url!.baseURL?.absoluteString)")
                    
                    self.sendMessaage(msg:"\(url!.absoluteString)", messageType: "Video")
                    
                    
                    
                }
            }
            
            
            
            
        } catch {
            
            self.loadingView.stopAnimating()
            print("Error on extracting data from url: \(error.localizedDescription)")
        }
        
        
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
                    print("baseURL  of \(fileName) is \(url!.baseURL?.absoluteString)")
                    self.sendMessaage(msg:"\(url!.absoluteString)", messageType: "Image")
                    
                    
                    
                }
            }
            
            
            
            
        } catch {
            self.loadingView.stopAnimating()
            print("Error on extracting data from url: \(error.localizedDescription)")
        }
        
        
    }
    
    func sendMessaage(msg:String, messageType:String){
        
        
        let date = Timestamp().dateValue()
        
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        
        // Set Date Format
        dateFormatter.dateFormat = "dd MMM yyyy HH:MM:SS"
        
        
        
        let textMsg:[String:Any] = ["groupId":"This is not group", "message":msg, "message_type":messageType, "profile_image":self.myChatScreenModelObj?.currentUserImageUrl, "sender_id":self.myChatScreenModelObj?.currentUserId, "sender_user_name":self.myChatScreenModelObj?.currentUserName, "timestamp":dateFormatter.string(from: date)]
        
        self.chat_VM.messageToBeSend = textMsg
        
        
        self.chat_VM.sendChat()
        
        
    }
    
//    func fetchMessages(){
//        
//        
//        self.ref.child("UserMessage").child(self.currentUserId).child(otherUserId).queryOrderedByKey().observe(.value) { (snapshot) in
//            
//            if  let dictResponse:[String:Any] = snapshot.value as? [String : Any]{
//                
//                let totalUserKeysInchat = Array(dictResponse.keys)
//                self.messageList.removeAll()
//                print("Response -\(dictResponse)")
//                for key in totalUserKeysInchat{
//                    
//                    print(key)
//                    print(dictResponse[key])
//                    print("Crash point -1")
//                    
//                    let msg = Message(dictionary: dictResponse[key] as! [String : Any])
//                    
//                    //  print(msg?.message)
//                    print(dictResponse[key])
//                    
//                    self.messageList.append(msg!)
//                    
//                    
//                    
//                }
//                
//                self.tableViewMessages.reloadData()
//                
//                
//                
//                
//            }
//            
//        }
//        
//    }
    
    //MARK:- UIButton action methods ----
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
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


extension MyChatViewController:UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.chat_VM.messageList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let msg = self.chat_VM.messageList[indexPath.row]
        if msg.message_type == "text" && msg.sender_id == self.myChatScreenModelObj?.currentUserId{
            
            let cell:ChatTextRightCell = tableView.dequeueReusableCell(withIdentifier: "ChatTextRightCell") as! ChatTextRightCell
            
            cell.dateLabel.text = msg.timpstamp
            cell.userNameLabel.text = msg.sender_user_name.capitalized
            cell.profilePictureImageView.sd_setImage(with: URL(string: "\(msg.profile_image)"), placeholderImage: UIImage(named: "placeHolderProfileImage.jpeg"))
            cell.messageLabel.text = msg.message
            cell.messageLabel.changeBorder(width: 1.0, borderColor: .darkGray, cornerRadius: 15.0)
            cell.profilePictureImageView.changeBorder(width: 1.0, borderColor: .systemGreen, cornerRadius: 12.5)

            
            return cell
        }
        else if msg.message_type == "text" && msg.sender_id != self.myChatScreenModelObj?.currentUserId{
            
            let cell:ChatTextLeftCell = tableView.dequeueReusableCell(withIdentifier: "ChatTextLeftCell") as! ChatTextLeftCell
            
            cell.dateLabel.text = msg.timpstamp
            cell.userNameLabel.text = msg.sender_user_name.capitalized
            cell.profilePictureImageView.sd_setImage(with: URL(string: "\(msg.profile_image)"), placeholderImage: UIImage(named: "placeHolderProfileImage.jpeg"))
            cell.messageLabel.text = msg.message
            cell.messageLabel.changeBorder(width: 1.0, borderColor: .darkGray, cornerRadius: 15.0)
            cell.profilePictureImageView.changeBorder(width: 1.0, borderColor: .systemRed, cornerRadius: 12.5)

            return cell
        }
        else  if msg.message_type == "Image" && msg.sender_id == self.myChatScreenModelObj?.currentUserId{
            
            let cell:ChatImageRightCell = tableView.dequeueReusableCell(withIdentifier: "ChatImageRightCell") as! ChatImageRightCell
            
            cell.dateLabel.text = msg.timpstamp
            cell.userNameLabel.text = msg.sender_user_name.capitalized
            cell.profilePictureImageView.sd_setImage(with: URL(string: "\(msg.profile_image)"), placeholderImage: UIImage(named: "placeHolderProfileImage.jpeg"))
            cell.imageChatImageView.sd_setImage(with: URL(string: "\(msg.message)"), placeholderImage: UIImage(named: "placeHolderProfileImage.jpeg"))

            cell.profilePictureImageView.changeBorder(width: 1.0, borderColor: .systemGreen, cornerRadius: 12.5)
            cell.imageChatImageView.changeBorder(width: 1.0, borderColor: .darkGray, cornerRadius: 8.0)


            return cell
        }
        else if msg.message_type == "text" && msg.sender_id != self.myChatScreenModelObj?.currentUserId{
            
            let cell:ChatImageLeftCell = tableView.dequeueReusableCell(withIdentifier: "ChatImageLeftCell") as! ChatImageLeftCell
            
            cell.dateLabel.text = msg.timpstamp
            cell.userNameLabel.text = msg.sender_user_name.capitalized
            cell.profilePictureImageView.sd_setImage(with: URL(string: "\(msg.profile_image)"), placeholderImage: UIImage(named: "placeHolderProfileImage.jpeg"))
            cell.imageChatImageView.sd_setImage(with: URL(string: "\(msg.message)"), placeholderImage: UIImage(named: "placeHolderProfileImage.jpeg"))
            cell.profilePictureImageView.changeBorder(width: 1.0, borderColor: .systemRed, cornerRadius: 12.5)
            cell.imageChatImageView.changeBorder(width: 1.0, borderColor: .darkGray, cornerRadius: 8.0)
            
            return cell
        }
        else  if msg.message_type == "Video" && msg.sender_id == self.myChatScreenModelObj?.currentUserId{
            
            let cell:ChatVideoRightCell = tableView.dequeueReusableCell(withIdentifier: "ChatVideoRightCell") as! ChatVideoRightCell
            
            cell.dateLabel.text = msg.timpstamp
            cell.userNameLabel.text = msg.sender_user_name.capitalized
            cell.profilePictureImageView.sd_setImage(with: URL(string: "\(msg.profile_image)"), placeholderImage: UIImage(named: "placeHolderProfileImage.jpeg"))

            cell.profilePictureImageView.changeBorder(width: 1.0, borderColor: .systemGreen, cornerRadius: 12.5)
            
           // cell.videoTitleLabel.text = "Sample Video" ;
            let url = NSURL(string: msg.message);
            let avPlayer = AVPlayer(url: url as! URL);
            cell.videoView?.playerLayer.player = avPlayer;


            return cell
        }
        else if msg.message_type == "Video" && msg.sender_id != self.myChatScreenModelObj?.currentUserId{
            
            let cell:ChatVideoLeftCell = tableView.dequeueReusableCell(withIdentifier: "ChatVideoLeftCell") as! ChatVideoLeftCell
            
            cell.dateLabel.text = msg.timpstamp
            cell.userNameLabel.text = msg.sender_user_name.capitalized
            cell.profilePictureImageView.sd_setImage(with: URL(string: "\(msg.profile_image)"), placeholderImage: UIImage(named: msg.message))
            cell.profilePictureImageView.changeBorder(width: 1.0, borderColor: .systemRed, cornerRadius: 12.5)
            
            let url = NSURL(string: msg.message);
            let avPlayer = AVPlayer(url: url! as URL);
            cell.videoView?.playerLayer.player = avPlayer;

            
            return cell
        }
        
        
        
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let videoCell = (tableView.cellForRow(at: indexPath) as? ChatVideoRightCell) else { return }
      //  let visibleCells = tableView.visibleCells
//        let minIndex = visibleCells.startIndex
    
        if videoCell.videoView.player?.timeControlStatus == AVPlayer.TimeControlStatus.playing{
            
            print("PAUSE")

            videoCell.videoView.player?.pause()
            videoCell.videoView.player?.seek(to: CMTime.zero)

        }
        else{
            print("PLAY")
            videoCell.videoView.player?.seek(to: CMTime.zero)

            videoCell.videoView.player?.play()
        }
    
    
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return UITableView.automaticDimension
        
    }
    
    
}
