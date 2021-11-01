//
//  HomeViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 01/11/21.
//

import UIKit

class CellMostPopular:UITableViewCell{
    
    @IBOutlet weak var collectionViewMostPopular: UICollectionView!
    
  
}

class CellTopProfile:UITableViewCell{
    
    
    @IBOutlet weak var collectionViewTopProfile: UICollectionView!
    
  
}

class CellFeedAndCommunity:UITableViewCell{
    
    
    @IBOutlet weak var scrollViewFeedAndCommunity: UIScrollView!
    
    
}

class HomeViewController: UIViewController {

    @IBOutlet weak var tableViewHome: UITableView!
    @IBOutlet weak var notificationButton: UIButton!
    
    @IBOutlet weak var searchButton: UIButton!
    
    
    let sectionTitle:[String] = ["Most Popular", "Top Profile"]
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.tableViewHome.estimatedRowHeight = 88.0
        self.tableViewHome.rowHeight = UITableView.automaticDimension

        
        
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
extension HomeViewController:UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.section == 0{
        
            return Constants.screenWidth / 4
            
        }
        else if indexPath.section == 1{
            
            
            return Constants.screenWidth / 6
        }
        
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        
        return 40.0
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.screenWidth, height: 40))
        
        sectionHeaderView.backgroundColor = .white
        let headingLabel = UILabel(frame: CGRect(x: 15, y: 0, width: Constants.screenWidth, height: 40))
        
        headingLabel.text = self.sectionTitle[section]
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
        
        
        if indexPath.section == 0 {
            
                
                let cell:CellMostPopular = tableView.dequeueReusableCell(withIdentifier: "CellMostPopular") as! CellMostPopular

            cell.collectionViewMostPopular.delegate = self
            cell.collectionViewMostPopular.dataSource = self


                return cell
          
            
            
        }
        else if indexPath.section == 1 {
            
           
            
                
                let cell:CellTopProfile = tableView.dequeueReusableCell(withIdentifier: "CellTopProfile") as! CellTopProfile
            cell.collectionViewTopProfile.delegate = self
            cell.collectionViewTopProfile.dataSource = self

              
             return cell
            
            
        }
        else if indexPath.section == 2 {
            
                
                let cell:CellFeedAndCommunity = tableView.dequeueReusableCell(withIdentifier: "CellFeedAndCommunity") as! CellFeedAndCommunity

                
                return cell
                
            
        }
       
        
        return UITableViewCell()
    }
    
    
}

extension HomeViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    
    
}
