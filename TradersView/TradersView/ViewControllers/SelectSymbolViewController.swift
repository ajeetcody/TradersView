//
//  SelectSymbolViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 13/11/21.
//

import UIKit


protocol SelectSymbolDelegate: class {
    
    
    func didDoneSelected(symbolID:String, sym_name:String)
    func didCancelSelected()
    
}

class CellSymbol:UITableViewCell{
    
    @IBOutlet weak var symbolLabel: UILabel!
    
    
}
class SelectSymbolViewController: MasterViewController {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var tableViewSymbol: UITableView!
    var arraySymbolList:[GetSymbolResponseDatum]?
    
    weak var deleage:SelectSymbolDelegate?
    
    var selectedSymbolID:String?
    var selectedSymbolName:String?
    
    @IBOutlet weak var popupViewSelectSymbol: UIView!
    
    //MARK:- UIViewcontroller delegates -----
    
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        self.cancelButton.changeBorder(width: 1.0, borderColor: .darkGray, cornerRadius: 5.0)
        
        self.doneButton.changeBorder(width: 1.0, borderColor: .darkGray, cornerRadius: 5.0)
        
        self.popupViewSelectSymbol.changeBorder(width: 1.0, borderColor: .darkGray, cornerRadius: 15.0)
        
        self.popupViewSelectSymbol.dropShadow(opacity: 0.5, radius: 15.0)

    }
    
    //MARK:- UIButton action methods ----
    
    
    @IBAction func doneButtonAction(_ sender: Any) {
        
        if let _selectedSymbolID = self.selectedSymbolID, let _selectedSymbolName = self.selectedSymbolName{
            
            
            self.deleage?.didDoneSelected(symbolID: _selectedSymbolID, sym_name: _selectedSymbolName)
            
            self.dismiss(animated: true, completion: nil)
            
            
        }
        else{
            
            self.showAlertPopupWithMessage(msg: "Please select symbol from this list")

            
        }
        
    }
    
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
        self.deleage?.didCancelSelected()
        
    }
    
    
    deinit{
        
    print("- Object deinitialization - ")
        
        
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

extension SelectSymbolViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let symbolList = self.arraySymbolList{
            
            return symbolList.count
            
        }
        
        return 0
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell:CellSymbol = tableView.dequeueReusableCell(withIdentifier: "CellSymbol") as! CellSymbol
        
        
        let obj = self.arraySymbolList![indexPath.row]
        
        cell.symbolLabel.text = obj.symbolName
        
        if let _selectedSymbolID = self.selectedSymbolID{
            
            if _selectedSymbolID == obj.id{
                
                
                cell.accessoryType = .checkmark
            }
            else{
                
                cell.accessoryType = .none
                
            }
            
        }
        else{
            
            cell.accessoryType = .none
        }
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj = self.arraySymbolList![indexPath.row]

        self.selectedSymbolID = obj.id
        self.selectedSymbolName = obj.symbolName
        self.tableViewSymbol.reloadData()
        
        
    }
    
    
}
