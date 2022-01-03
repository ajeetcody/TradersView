//
//  SplashViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 17/10/21.
//

import UIKit
import CoreLocation
import Photos
import AVFoundation


class SplashViewController: MasterViewController {
    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var shadowEffectView: UIView!
    var locationManager:CLLocationManager?
    
    //MARK:- UIViewcontroller lifecycle ---
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.appDelegate.mainNavigation = self.navigationController
        self.continueButton.changeBorder(width: 1.0, borderColor: .white, cornerRadius: 25.0)
        
        
        // self.createFadOutEffect()
        
        
        
        
    }
    
    //    func createFadOutEffect(){
    //
    //        let gradient = CAGradientLayer()
    //        gradient.frame = view.bounds
    //        gradient.colors = [UIColor.white.cgColor, UIColor.clear.withAlphaComponent(0.4)]
    //        gradient.locations = [0.0 , 0.50]
    //
    //
    //        self.shadowEffectView.layer.addSublayer(gradient)
    //
    //
    //    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        if UserDefaults.standard.value(forKey: Constants.USER_DEFAULT_KEY_USER_DATA) != nil{
            
            print("Login data response ----")
            
            let userDefaults = UserDefaults.standard
            do {
                let loginData = try userDefaults.getObject(forKey: Constants.USER_DEFAULT_KEY_USER_DATA, castTo: LoginUserData.self)
                
                self.appDelegate.loginResponseData = loginData
                print("Login data response ----")
                
                self.showTabbarController(animated: false)
                
                
            } catch {
                print(error.localizedDescription)
            }
            
            
        }
    }
    
    //MARK:- UIButton action -----
    
    @IBAction func privacyButtonAction(_ sender: Any) {
        
        self.showAlertCommingSoon()
        
        
    }
    
    @IBAction func continueButtonAction(_ sender: Any) {
        
        
        /* Location permission */
        self.locationManager  = CLLocationManager()
        self.locationManager?.requestAlwaysAuthorization()
        
        /* Access photo media and file */
        
        self.checkPhotoLibraryPermission()
        
        /* Record audio */
        
        self.checkAudioRecordPermission()
        
        /* Notification permission */
        
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }
    
    func checkAudioRecordPermission(){
        switch AVAudioSession.sharedInstance().recordPermission {
            case .granted:
                print("Permission granted")
            case .denied:
                print("Permission denied")
            case .undetermined:
                print("Request permission here")
                AVAudioSession.sharedInstance().requestRecordPermission({ granted in
                    // Handle granted
                })
            @unknown default:
                print("Unknown case")
            }
    }
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized: break
        //handle authorized status
        case .denied, .restricted : break
        //handle denied status
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization() { (status) -> Void in
                switch status {
                case .authorized: break
                // as above
                case .denied, .restricted: break
                // as above
                case .notDetermined: break
                // won't happen but still
                case .limited:
                    break
                @unknown default:
                    print("default")
                }
            }
        case .limited:
            break
        @unknown default:
            print("default")
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

