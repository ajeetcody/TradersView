//
//  ChannelDetailViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 27/11/21.
//

import UIKit

class ChannelDetailViewController: UIViewController {

    @IBOutlet weak var scrollViewPagination: UIScrollView!
    @IBOutlet weak var gifButton: UIButton!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var groupNameLabel: UILabel!
    
    @IBOutlet weak var groupProfilePicture: UIImageView!
    @IBOutlet weak var mediaButton: UIButton!
    @IBOutlet weak var memberButton: UIButton!
    @IBOutlet weak var leadingOptionSelectConsraints: NSLayoutConstraint!
    @IBOutlet weak var coverImageView: UIImageView!
    
    
    var groupNameString = ""
    var groupId = ""
    var currentPage = 0
    
    let xPoint = Constants.screenWidth/4
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        
       // self.coverImageView.roundUpCorners(UIRectCorner.bottomLeft, radius: 50.0)
       // self.coverImageView.roundUpCorners(UIRectCorner.bottomRight, radius: 50.0)
        
        self.groupProfilePicture.changeBorder(width: 3.0, borderColor: .lightGray, cornerRadius: 50.0)

        self.groupNameLabel.text = self.groupNameString
    }
    
    
    //MARK:- UIButton action methods ---------
    
    
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    @IBAction func optionButtonSelectAction(_ sender: Any) {
        
        
        
        debugPrint("\((sender as! UIButton).tag)")
        
      
        
        self.changeUIAfterSelectingOption(optionNumber: ((sender as! UIButton).tag))
        
    }
    
    
    //MARK:- UIChanges ----
    
    func changeUIAfterSelectingOption(optionNumber:Int){
        
      
        let selectedFont = UIFont.boldSystemFont(ofSize: 15.0)
        
        let deSelectFont = UIFont.systemFont(ofSize: 15.0)
        
        let selectedColor = UIColor.darkGray
        let deselectColor = UIColor.lightGray
        
        
        if optionNumber == 0 {
            
            self.memberButton.titleLabel?.font = selectedFont
            self.mediaButton.titleLabel?.font = deSelectFont
            self.linkButton.titleLabel?.font = deSelectFont
            self.gifButton.titleLabel?.font = deSelectFont
            
            self.memberButton.setTitleColor(selectedColor, for: .normal)
            self.mediaButton.setTitleColor(deselectColor, for: .normal)
            self.linkButton.setTitleColor(deselectColor, for: .normal)
            self.gifButton.setTitleColor(deselectColor, for: .normal)
            
            
            
        }
        else if optionNumber == 1{
            self.memberButton.titleLabel?.font = deSelectFont
            self.mediaButton.titleLabel?.font = selectedFont
            self.linkButton.titleLabel?.font = deSelectFont
            self.gifButton.titleLabel?.font = deSelectFont
            
            
            self.memberButton.setTitleColor(deselectColor, for: .normal)
            self.mediaButton.setTitleColor(selectedColor, for: .normal)
            self.linkButton.setTitleColor(deselectColor, for: .normal)
            self.gifButton.setTitleColor(deselectColor, for: .normal)

        }
        else if optionNumber == 2{
            
            self.memberButton.titleLabel?.font = deSelectFont
            self.mediaButton.titleLabel?.font = deSelectFont
            self.linkButton.titleLabel?.font = selectedFont
            self.gifButton.titleLabel?.font = deSelectFont
            
            
            self.memberButton.setTitleColor(deselectColor, for: .normal)
            self.mediaButton.setTitleColor(deselectColor, for: .normal)
            self.linkButton.setTitleColor(selectedColor, for: .normal)
            self.gifButton.setTitleColor(deselectColor, for: .normal)
            
        }
        else if optionNumber == 3{
            
            self.memberButton.titleLabel?.font = deSelectFont
            self.mediaButton.titleLabel?.font = deSelectFont
            self.linkButton.titleLabel?.font = deSelectFont
            self.gifButton.titleLabel?.font = selectedFont
            
            
            self.memberButton.setTitleColor(deselectColor, for: .normal)
            self.mediaButton.setTitleColor(deselectColor, for: .normal)
            self.linkButton.setTitleColor(deselectColor, for: .normal)
            self.gifButton.setTitleColor(selectedColor, for: .normal)
            
        }
        
        
        
        self.scrollViewPagination.scrollTo(horizontalPage: optionNumber, verticalPage: 0, animated: true)


        UIView.animate(withDuration: 0.5) {
            
            self.leadingOptionSelectConsraints.constant = self.xPoint * CGFloat(optionNumber)
            
            
            
            //self.scrollViewPagination.contentOffset.x = CGFloat(self.currentPage) * Constants.screenWidth

            self.view.layoutIfNeeded()
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

extension ChannelDetailViewController:UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
      
        let width = scrollView.frame.width
        self.currentPage = Int(round(scrollView.contentOffset.x/width))
        print("CurrentPage:\(self.currentPage)")
        self.changeUIAfterSelectingOption(optionNumber: self.currentPage)
        
    }
    
}
