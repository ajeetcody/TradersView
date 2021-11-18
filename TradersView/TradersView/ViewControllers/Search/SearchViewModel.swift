//
//  SearchViewModel.swift
//  TradersView
//
//  Created by Ajeet Sharma on 17/11/21.
//

import Foundation

class SearchViewModel: NSObject {
    
    var page = 0
    var searchResult:[SearchDatum]?
    var didEndReached = false
    var shouldLoadMoreData = false
    var isFetching = false
    var userData:LoginUserData?
    
    var errorMessage:String = ""
    var searchString:String = ""
    
    var selectedUserData: [SearchDatum] = []
    
    
    
    // FIXME: - How to use High order function on custom objects ---
    
    
    func checkUserIsSelected(userData:SearchDatum)->Bool{
        
        
        self.selectedUserData.contains { (user) -> Bool in
            
            return user.userid == userData.userid
        }
        
        
        
    }
    
    
    func removeUserFromSelectedList(userData:SearchDatum){
        
      
        self.selectedUserData.removeAll { (user) -> Bool in
            
            return user.userid == userData.userid
        }
        
        
        
        
    }



    func callSearchApiModelView(reloadData:@escaping()->Void, errorHandler:@escaping(_ msg:String)->Void){
        
        
        print("Search flow - 1")
        
        
        
        if self.searchString.trimmingCharacters(in: .whitespaces).count == 0 {
            
            self.searchResult?.removeAll()
           
            reloadData()
            
            print("Search flow - 2")
            return
            
        }
        
        if  let userData:LoginUserData = self.userData{
            
            
            let request:SearchRequest = SearchRequest(_user_id: userData.id , _search: self.searchString, _page: self.page)
            
            self.isFetching = true
            
            
            ApiCallManager.shared.apiCall(request: request, apiType: .SEARCH, responseType: SearchResponse.self, requestMethod: .POST) { (results) in
                
                
                self.isFetching = false
                
                if results.status == 1{
                    
                    
                    if let data = results.data{
                        
                        
                        
                        
                        if self.page == 0 {
                            
                            self.shouldLoadMoreData = true
                            
                            
                                self.searchResult = data

                                reloadData()
                           
                            
                        }
                        else{
                            
                         
                            self.searchResult?.append(contentsOf: data)
                                
                                reloadData()
                         
                            
                        }
                        
                        self.page += 1
                        
                    }
                    
                    
                    
                   
                    
                }
                else {
                    
                    print("Search flow - 6")
                    
                    self.shouldLoadMoreData = false
                    
                    
                    
                    if self.page == 0 {
                        
                        reloadData()
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                }
                
                
            } failureHandler: { (error) in
                
                self.isFetching = false
                print("Error - \(error.localizedDescription)")
                
            }

            
            
            
        }
        
    }
    
}
