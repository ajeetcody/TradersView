//
//  HomeViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 01/11/21.
//

import UIKit
import SDWebImage

class CollectionViewCellMostPopular:UICollectionViewCell{
    
    @IBOutlet weak var popularImageView: UIImageView!
    
    
}


class CollectionViewCellTopProfile:UICollectionViewCell{
    
    @IBOutlet weak var topProfileImageView: UIImageView!
    @IBOutlet weak var topProfileNameLabel: UILabel!

    
}



class CellMostPopular:UITableViewCell{
    
    @IBOutlet weak var collectionViewMostPopular: UICollectionView!
    
    
}

class CellTopProfile:UITableViewCell{
    
    
    @IBOutlet weak var collectionViewTopProfile: UICollectionView!
    
    
}

class CellFeedAndCommunity:UITableViewCell{
    
    
    @IBOutlet weak var scrollViewFeedAndCommunity: UIScrollView!
    
    
}

class HomeViewController: MasterViewController {
    
    @IBOutlet weak var tableViewHome: UITableView!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    let sectionTitle:[String] = ["Most Popular", "Top Profile",""]
    
    var arrayPopular:[MostPopularDatum] = []
    var topProfile = ["Ajit", "Amit","Rakesh", "Ramesh", "Kapil", "chintoo", "Sourach", "Ravi"]
    var arrayCommunity: [CommunityResponseDatum] = []
    var arrayMyPost:[PostByUserIDDatum] = []
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableViewHome.estimatedRowHeight = 88.0
        self.tableViewHome.rowHeight = UITableView.automaticDimension
        
        self.apiCallMostPopular()
        
        
    }
    
    
    func apiCallMostPopular(){
        
        
        
        
        ApiCallManager.shared.apiCall(request: ApiRequestModel(), apiType: .MOST_POPULAR, responseType: MostPopularResponse.self, requestMethod: .GET) { (results) in
            
            
            let response:MostPopularResponse = results
            
            if response.status == 0{
                
                
                self.showAlertPopupWithMessage(msg: response.messages)
                
            }
            else{
                
                if let popularList = response.data{
                
                    self.arrayPopular = popularList
                    
                }
                
                DispatchQueue.main.async {
                
                    self.tableViewHome.reloadData()
                }
                
                
            }
            
            
            
        } failureHandler: { (error) in
            
            self.showErrorMessage(error: error)
        }

        
    }
    
    func apiCallTopProfile(){
        
        
        
    }
    
    func apiCallCommunity(){
        
        
        
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
            
            return Constants.screenWidth / 3
            
        }
        else if indexPath.section == 1{
            
            
            return Constants.screenWidth / 4
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
        
        return self.sectionTitle.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return 1
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            
            
            let cell:CellMostPopular = tableView.dequeueReusableCell(withIdentifier: "CellMostPopular") as! CellMostPopular
            
            cell.collectionViewMostPopular.tag = 101
            cell.collectionViewMostPopular.delegate = self
            cell.collectionViewMostPopular.dataSource = self
            
            cell.collectionViewMostPopular.reloadData()
            
            return cell
            
            
            
        }
        else if indexPath.section == 1 {
            
            
            
            
            let cell:CellTopProfile = tableView.dequeueReusableCell(withIdentifier: "CellTopProfile") as! CellTopProfile
            cell.collectionViewTopProfile.tag = 102
            cell.collectionViewTopProfile.delegate = self
            cell.collectionViewTopProfile.dataSource = self
            cell.collectionViewTopProfile.reloadData()
            
            return cell
            
            
        }
        else if indexPath.section == 2 {
            
            
            let cell:CellFeedAndCommunity = tableView.dequeueReusableCell(withIdentifier: "CellFeedAndCommunity") as! CellFeedAndCommunity
            
            
            return cell
            
            
        }
        
        
        return UITableViewCell()
    }
    
    
}

extension HomeViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        return CGSize(width: 150.0, height: 190.0)
        
    }
    
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//            return UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
//        }
//
//
//
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 5
        }
    
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//            return 20
//        }

    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 101{
            
            return self.arrayPopular.count
            
        }
        else if collectionView.tag == 102{
            
            return self.topProfile.count
            
        }
        
        return 10
    }
    
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView.tag == 101{
            
            
            let cell:CollectionViewCellMostPopular = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellMostPopular", for: indexPath as IndexPath) as! CollectionViewCellMostPopular
            

            let popular:MostPopularDatum = self.arrayPopular[indexPath.row]
            
            print(popular.image)
            cell.popularImageView.sd_setImage(with: URL(string: "\(popular.image)"), placeholderImage: UIImage(named: "placeholder.png"))

            cell.popularImageView.contentMode = .scaleAspectFit
           // popular.
            
            
            return cell
            
        }
        else if collectionView.tag == 102{
            
            let cell:CollectionViewCellTopProfile = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellTopProfile", for: indexPath as IndexPath) as! CollectionViewCellTopProfile
            
            cell.topProfileNameLabel.text  = "Test"

            // Use the outlet in our custom class to get a reference to the UILabel in the cell
            // cell.myLabel.text = self.items[indexPath.row] // The row value is the same as the index of the desired text within the array.
            // cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
            
            cell.backgroundColor = .systemPink
            
            print("fggfgfg")
            return cell
            
        }
        
        return UICollectionViewCell()
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        
        print("You selected cell #\(indexPath.item)!")
        
        
        
    }
}
