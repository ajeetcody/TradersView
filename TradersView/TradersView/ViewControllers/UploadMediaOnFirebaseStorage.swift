//
//  UploadMediaOnFirebaseStorage.swift
//  TradersView
//
//  Created by Ajeet Sharma on 23/11/21.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

protocol UploadMediaOnFirebaseStorageDelegate {

    func didImageUploaded(imgUrl:String)
    func didFailedImageUpload(err:Error)
    
}

class UploadMediaOnFirebaseStorage: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    
    let delegate:UploadMediaOnFirebaseStorageDelegate?
    let vc:MasterViewController?
    
    
    //MARK:- Photo select - 1
    
    func openCameraOptionActionsheet(){
        
        
        
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
        
        vc!.present(actionSheet, animated: true, completion: nil)
        
    }
    
    
    
    func fetchImages(sourceType:UIImagePickerController.SourceType){
        
        let imgPickerController = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType){
            
            imgPickerController.sourceType = sourceType
            imgPickerController.mediaTypes = ["public.image", "public.movie"]
            //imgPickerController.allowsEditing = true
            imgPickerController.delegate = self
            imgPickerController.modalPresentationStyle = .fullScreen
            vc!.present(imgPickerController, animated: true, completion: nil)
            
        }
        
        else{
            
            vc!.showAlertPopupWithMessage(msg: sourceType == .camera ?  "Camera is not available" :  "Photo library is not available")
            
            
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
            
            
//            self.uploadImageToStorageFirebase(img: image, formate: imgFormate) { (strUrl) in
//
//                self.sendMessaage(msg:strUrl, messageType: "Image")
//
//            }
            
            
            
        }
        
    }
    
    //MARK:- Select Video ---
    func selectVideoForSending(info:[UIImagePickerController.InfoKey : Any]){
        
        
        let  videoURL = info[UIImagePickerController.InfoKey.mediaURL]as? NSURL
        
        print(videoURL!)
        
      //  self.uploadVideoToStorageFirebase(videoUrl: videoURL! as URL, formate: "mov", completionHandler: <#(String) -> Void#>)
        
//        self.uploadVideoToStorageFirebase(videoUrl: videoURL! as URL, formate: "mov") { (urlString) in
//
//            self.sendMessaage(msg:urlString, messageType: "Video")
//
//        }
        
        
        
    }
    
    
    
    //MARK:- Firebase call ---
    func uploadVideoToStorageFirebase(videoUrl:URL, formate:String, completionHandler:@escaping(String)->Void){
        
        
        vc!.loadingView.startAnimating()

        do {
            
            let videoData = try Data(contentsOf: videoUrl)
            
            let fileName = "\(Int(Date().timeIntervalSince1970)).\(formate)"
            
            let storageReference = Storage.storage().reference().child("video").child(fileName)
            
            
            print("Video file name - \(fileName)")
            
            _ = storageReference.putData(videoData, metadata: nil) { (storageMetaData, error) in
                
                vc!.loadingView.stopAnimating()
                
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
                    
                    completionHandler(url!.absoluteString)
                    
                   
                    
                    
                    
                }
            }
            
            
            
            
        } catch {
            
            vc!.loadingView.stopAnimating()
            print("Error on extracting data from url: \(error.localizedDescription)")
        }
        
        
    }
    
    
    func uploadImageToStorageFirebase(img:UIImage, formate:String, completionHandler:@escaping(String)->Void){
        
        //  let storageRef = FIRStorage.storage().reference().child("myImage.png")
        
        vc!.loadingView.startAnimating()
        do {
            // Create file name
            //  let fileExtension = fileUrl.pathExtension
            let fileName = "\(Int(Date().timeIntervalSince1970)).\(formate)"
            
            let storageReference = Storage.storage().reference().child("uploads").child(fileName)
            
            //let task = storageReference.putData(img.pngData(), metadata: StorageMetadata(dictionary: [:]))
            
            _ = storageReference.putData(img.jpegData(compressionQuality: 1.0)!, metadata: nil) { (storageMetaData, error) in
                
                vc!.loadingView.stopAnimating()
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

                  

                    completionHandler(url!.absoluteString)
                    
                    
                    
                    
                }
            }
            
            
            
            
        } catch {
            vc!.loadingView.stopAnimating()
            print("Error on extracting data from url: \(error.localizedDescription)")
        }
        
        
    }
    
    
    
    
}
