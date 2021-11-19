//
//  ChatViewController.swift
//  Velo-Driver
//
//  Created by Ajeet Sharma on 06/06/21.
//  Copyright © 2021 Webcubator Technologies LLP. All rights reserved.
//  https://ibjects.medium.com/simple-text-chat-app-using-firebase-in-swift-5-b9fa91730b6c



/*
 
 
 
 */


import Foundation
import UIKit
import InputBarAccessoryView
//import Firebase

import Firebase
import MessageKit
import FirebaseFirestore
import SDWebImage



class ChatViewController: MessagesViewController, InputBarAccessoryViewDelegate, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {

    // MARK: - Private properties
       private let formatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateStyle = .medium
           return formatter
       }()
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var chatTitleLabel: UILabel!

    var currentUser: LoginUserData?

    var otherUserId:String = ""
    var otherUserName:String = ""
    var otherUserProfilePicUrl:String = ""
    
    var ref: DatabaseReference!


    
    //private var docReference: DocumentReference?
    
    var messages: [Message] = []

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ref = Database.database().reference()

        self.chatTitleLabel.text = "Chat with \(self.otherUserName.capitalized)"

        
        navigationItem.largeTitleDisplayMode = .never
        maintainPositionOnKeyboardFrameChanged = true
        scrollsToLastItemOnKeyboardBeginsEditing = true

        messageInputBar.inputTextView.tintColor = .systemBlue
        messageInputBar.sendButton.setTitleColor(.systemTeal, for: .normal)
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        loadChat()
        
        self.view.bringSubviewToFront(self.headerView)

    }
    
    // MARK:- Fetch profile picture ----
    
//    func fetchProfilePictures(){
//
//        // Reference to an image file in Firebase Storage
//        let reference = Storage.storage().reference().child("\(Constants.DOCUMENT_DRIVER_PROFILE_PHOTO)/\(self.driverId ?? "No_User_id").png")
//
//
//        print("Profile picture show --- \(self.driverId)")
//        print("Create url - \(reference.fullPath)")
//
//
//        // Load the image using SDWebImage
//
//      //  print("Create url -\(reference.fullPath)")
//
//
//        reference.getData(maxSize: 8 * 1024 * 1024) { data, error in
//            if let error = error {
//                // Uh-oh, an error occurred!
//            } else {
//
//                let image = UIImage(data: data!)
//
//                self.senderImage = image
//
//                print("Profile picture show --- \(self.senderImage)")
//                self.messagesCollectionView.reloadData()
//            }
//        }
//
//        SDWebImageManager.shared.loadImage(with: URL(string: currentUserImageUrl), options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
//
//            print("fetchProfilePictures - 2")
//
//            self.currentUserImage = image
//
//            self.messagesCollectionView.reloadData()
//        }
//
//
//
//    }
    
    // MARK: - UIButton actions -------
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    // MARK: - Custom messages handlers
    
    func createNewChat() {
        print("Create new chat - \(self.currentUser!.id), \(self.otherUserId)")

//
//
//        let users = [self.currentUser.uid, self.driverId]
//         let data: [String: Any] = [
//             "users":users
//         ]
//
//        let db = Firestore.firestore().collection("Chats").document(self.orderID!)
//
//        db.setData(data) { (error) in
//            if let error = error {
//                print("Unable to create chat! \(error)")
//                return
//            } else {
//                self.loadChat()
//            }
//        }
//
//
        
    }
    
    func loadChat() {
        
        //Fetch all the chats which has current user in it
//        let db = Firestore.firestore().collection("Chats")
//                .whereField("users", arrayContains: Auth.auth().currentUser?.uid ?? "Not Found User 1")
        
        self.ref.child("UserMessage").child("\(self.currentUser!.id)").child(self.otherUserId).queryOrdered(byChild: "timpstamp").observe(.value) { (snapshot) in
            
            
            
            
            if  let dictResponse:[String:Any] = snapshot.value as? [String : Any]{
                
          
                print(dictResponse)
                let totalUserKeysInchat = Array(dictResponse.keys)
                
                print(totalUserKeysInchat)
                
                self.messages.removeAll()
                
                for key in totalUserKeysInchat{
                    
                    print(key)
                    print(dictResponse[key])
                    
                    let msg = Message(dictionary: dictResponse[key] as! [String : Any])
                    
                    self.messages.append(msg!)
                    
                }

                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)

            }
                
                

                
          
            

        }
        
        
        
//        self.ref.child("UserMessage").child("\(self.currentUser!.id)").child(self.otherUserId).observe(.childAdded) { (snapshot) in
//            
//          
//                
//            
//            if  let dictResponse:[String:Any] = snapshot.value as? [String : Any]{
//                
//          
//                print(dictResponse)
//                let totalUserKeysInchat = Array(dictResponse.keys)
//                
//                print(totalUserKeysInchat)
//                
//                self.messages.removeAll()
//                
//                for key in totalUserKeysInchat{
//                    
//                    print(key)
//                    print(dictResponse[key])
//                    
//                    let msg = Message(dictionary: dictResponse[key] as! [String : Any])
//                    
//                    self.messages.append(msg!)
//                    
//                }
//
//                self.messagesCollectionView.reloadData()
//                self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
//
//            }
//                
//                
//
//                
//          
//            
//
//        }
        
        
        /*
        let db = Firestore.firestore().collection("Chats").document(self.orderID!)
        
        db.getDocument { (docSnapshot, error) in
            
            if let error = error {
                print("Error: \(error)")
                return
            } else {
                
                //Count the no. of documents returned
                guard let docSnapshot = docSnapshot else {
                    return
                }
                
//                if queryCount == 0 {
//                    //If documents count is zero that means there is no chat available and we need to create a new instance
//                    self.createNewChat()
//                }
//                else if queryCount >= 1 {
                
                    //Chat(s) found for currentUser
                   // for doc in chatQuerySnap!.documents {
               
                if let docData = docSnapshot.data(){
                    
                    let chat = Chat(dictionary: docData)
                            //Get the chat which has user2 id
                            if (chat?.users.contains(self.driverId!))! {
                                
                                self.docReference = docSnapshot.reference
                                //fetch it's thread collection
                                docSnapshot.reference.collection("thread")
                                    .order(by: "created", descending: false)
                                    .addSnapshotListener(includeMetadataChanges: true, listener: { (threadQuery, error) in
                                if let error = error {
                                    print("Error: \(error)")
                                    return
                                } else {
                                    self.messages.removeAll()
                                        for message in threadQuery!.documents {

                                            let msg = Message(dictionary: message.data())
                                            self.messages.append(msg!)
                                            print("Data: \(msg?.content ?? "No message found")")
                                        }
                                    
                                    
                                    self.messagesCollectionView.reloadData()
                                    self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
                                }
                                })
                                return
                            }
                    
                    
                }
                
                
                

                
                //end of if
                   // } //end of for
                    
                    self.createNewChat()
                    
//                } else {
//                    print("Let's hope this error never prints!")
//                }
                    
            }
        }
        */
        
    }
    
    
    private func insertNewMessage(_ message: Message) {
        
        messages.append(message)
        messagesCollectionView.reloadData()
        
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
        }
    }
    
    private func save(_ message: Message) {
        
       
        
        
        
        self.ref.child("UserMessage").child("\(self.currentUser!.id)").child(self.otherUserId).childByAutoId().setValue(message.dictionary) { (error, reference) in

            if let err = error{

                DispatchQueue.main.async {


                    let alert = UIAlertController(title: "Error", message: "Error: \(err.localizedDescription)", preferredStyle: .alert)

                    let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in


                    }

                    alert.addAction(okAction)

                    self.present(alert, animated: true, completion: nil)



                }



            }
            else{
                
                print(reference.key!)
                
                var tempDict  = message.dictionary
                
                tempDict["refidfirbasekey"] = reference.key!
                
                
                self.ref.child("UserMessage").child("\(self.currentUser!.id)").child(self.otherUserId).child(reference.key!).setValue(tempDict)
                
                
                //setValue(reference.key!, forKey:"refidfirbasekey")
                
                
            }



        }
        
        /*
         
          let data: [String: Any] = [
         "content": message.content,
         "created": message.created,
         "id": message.id,
         "senderID": message.senderID,
         "senderName": message.senderName,
         "key":"1"
         ]
         
         docReference?.collection("thread").addDocument(data: data, completion: { (error) in
         
         if let error = error {
         print("Error Sending message: \(error)")
         return
         }
         
         self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
         
         })
         
         */
        
    }
    
    // MARK: - InputBarAccessoryViewDelegate
    
            func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {

                let date = Timestamp().dateValue()

                // Create Date Formatter
                let dateFormatter = DateFormatter()

                // Set Date Format
                dateFormatter.dateFormat = "dd MMM yyyy HH:MM:SS"

                // Convert Date to String
                print(dateFormatter.string(from: date))
                
//                var msg:[String:Any] = ["groupId":"This is not group", "message":message.message, "message_type":"text", "profile_image":self.otherUserProfilePicUrl, "sender_id":self.currentUser!.id, "sender_user_name":self.currentUser!.name, "timpstamp":dateFormatter.string(from: date)]
                
                 print("Message sent --")
                
                let msg = Message(groupId: "This is not group", message: text, message_type: "text", profile_image: self.currentUser!.profileImg, sender_id: self.currentUser!.id, sender_user_name: self.currentUser!.username, timpstamp: dateFormatter.string(from: date))
                
                  //messages.append(message)
                  insertNewMessage(msg)
                  save(msg)

                  inputBar.inputTextView.text = ""
                  messagesCollectionView.reloadData()
                  messagesCollectionView.scrollToBottom(animated: true)
                
            }
    
    
    // MARK: - MessagesDataSource
    func currentSender() -> SenderType {
        
        return ChatUser(senderId: currentUser!.id, displayName: currentUser?.name ?? "")

    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return messages[indexPath.section]
        
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        
        if messages.count == 0 {
            print("No messages to display")
            return 0
        } else {
            return messages.count
        }
    }
    
    
    // MARK: - MessagesLayoutDelegate
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
    
    // MARK: - MessagesDisplayDelegate
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .systemBlue: UIColor(hexString: "#DCDCDC")
    }

    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        if message.sender.senderId == self.currentUser!.id {
            
            /*
            SDWebImageManager.shared.loadImage(with: currentUser.photoURL, options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                avatarView.image = image
            }
            */
            
          //  avatarView.image = UIImage(named: "AppLogo.png")
            
//            if self.currentUser. != nil {
//
//                avatarView.image = self.currentUserImage
//                avatarView.backgroundColor = UIColor.black
//
//            }
//            else{
//
//                avatarView.backgroundColor = UIColor(hexString: "#DCDCDC")
//
//            }

            
        } else {
            
//            if self.senderImage != nil {
//            
//                avatarView.image = self.senderImage
//                avatarView.backgroundColor = UIColor.black
//
//            }
//            else{
//            
//                avatarView.backgroundColor = UIColor(hexString: "#DCDCDC")
//                
//            }
            
//            SDWebImageManager.shared.loadImage(with: URL(string: user2ImgUrl), options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
//                avatarView.image = image
//            }
            
            
            
        }
    }

    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {

        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight: .bottomLeft
        return .bubbleTail(corner, .curved)

    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        
        print("cellTopLabelAttributedText - 1 - \(message.sentDate)")
        
        return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        
    }
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 20.0
    }
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return NSAttributedString(string: "Read", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        print("messageTopLabelAttributedText - 1 \(message.sender.displayName)")
        let name = message.sender.displayName
        return NSAttributedString(string: name.capitalized, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 20.0
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
    
    
    func textCell(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell? {
        return nil
    }
    
    
    
    
}
