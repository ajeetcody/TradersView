//
//  AddTradesViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 11/11/21.
//

import UIKit
import SkyFloatingLabelTextField
class AddTradesViewController: MasterViewController {
    
    
    @IBOutlet weak var scrollViewAddTrade: UIScrollView!
    @IBOutlet weak var heightResonView: NSLayoutConstraint!
    @IBOutlet weak var reasonView: UIView!
    
    
    @IBOutlet weak var textViewReasonToClose: UITextView!
    
    @IBOutlet weak var positionShortLabel: UILabel!
    @IBOutlet weak var positionShortView: UIView!
    @IBOutlet weak var positionLongLabel: UILabel!
    @IBOutlet weak var positionLongView: UIView!
    @IBOutlet weak var positionView: UIView!
    
    @IBOutlet weak var statusCloseLabel: UILabel!
    @IBOutlet weak var statusCloseView: UIView!
    @IBOutlet weak var statusOpenLabel: UILabel!
    @IBOutlet weak var statusOpenView: UIView!
    @IBOutlet weak var statusView: UIView!
    
    @IBOutlet weak var postTradeButton: UIButton!
    @IBOutlet weak var symbolTextfield: SkyFloatingLabelTextField!
    
    @IBOutlet weak var stopLossTextfield: SkyFloatingLabelTextField!
    
    @IBOutlet weak var totalProfiteTextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var tradePriceTextfield: SkyFloatingLabelTextField!
    
    private var symbolList:[GetSymbolResponseDatum]?
    private var currentUserId:String?
    
    private var status:Int = -1
    private var position:Int = -1
    
    
    var selectedSymbolID:String?
    var selectedSymbolName:String?
    
    
    //MARK:- UIViewcontroller lifecycle ----
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.heightResonView.constant = 0.0
        if  let userData:LoginUserData = self.appDelegate.loginResponseData{
            
            
            self.currentUserId = userData.id
            self.fetchSymbol()
            
        }
        else{
            
            self.showAlertPopupWithMessage(msg: "User Data is not available")
        }
        
        self.uiSet()
        
        self.addDoneButtonOnKeyboard()
        
        
    }
    
    func uiSet(){
        
        self.reasonView.isHidden = true
        
        self.statusView.changeBorder(width: 1.0, borderColor: .lightGray, cornerRadius: 3.0)
        
        self.statusOpenView.backgroundColor = .lightGray
        self.statusOpenLabel.textColor = .white
        self.statusCloseView.backgroundColor = .lightGray
        self.statusCloseLabel.textColor = .white
        
        self.postTradeButton.changeBorder(width: 1.0, borderColor: .darkGray, cornerRadius: 25.0)
        
        self.statusOpenView.changeBorder(width: 1.0, borderColor: .lightGray, cornerRadius: 5.0)
        
        self.statusCloseView.changeBorder(width: 1.0, borderColor: .lightGray, cornerRadius: 5.0)
        
        
        self.positionView.changeBorder(width: 1.0, borderColor: .lightGray, cornerRadius: 3.0)
        
        self.positionShortView.backgroundColor = .lightGray
        self.positionShortLabel.textColor = .white
        self.positionLongView.backgroundColor = .lightGray
        self.positionLongLabel.textColor = .white
        
        self.positionShortView.changeBorder(width: 1.0, borderColor: .lightGray, cornerRadius: 5.0)
        self.positionLongView.changeBorder(width: 1.0, borderColor: .lightGray, cornerRadius:5.0)
        
        
        
        self.textViewReasonToClose.changeBorder(width: 1.0, borderColor: .lightGray, cornerRadius: 5.0)
        
        
        self.statusOpenView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.openStatusTapGestureAction(_gesture:))))
        
        self.statusCloseView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.closeStatusTapGestureAction(_gesture:))))
        
        self.positionShortView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.shortPositionTapGestureAction(_gesture:))))
        
        self.positionLongView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.longPositionTapGestureAction(_gesture:))))
        
        self.textViewReasonToClose.leftSpace()
        
    }
    
    
    //MARK:- Add done button on keyboard ----
    
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.tradePriceTextfield.inputAccessoryView = doneToolbar
        self.totalProfiteTextfield.inputAccessoryView = doneToolbar
        self.stopLossTextfield.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        
        self.tradePriceTextfield.resignFirstResponder()
        self.totalProfiteTextfield.resignFirstResponder()
        self.stopLossTextfield.resignFirstResponder()
        

    }
    
    //MARK:- Gesture action methods ---
    
    
    @objc func openStatusTapGestureAction(_gesture: UITapGestureRecognizer){
        
        print("\(#function)")
        
        self.statusOpenView.backgroundColor = .black
        self.statusOpenLabel.textColor = .white
        self.statusCloseView.backgroundColor = .lightGray
        self.statusCloseLabel.textColor = .white
        
        self.status = 1
        self.heightResonView.constant = 0.0
        self.reasonView.isHidden = true
        
    }
    
    @objc func closeStatusTapGestureAction(_gesture: UITapGestureRecognizer){
        print("\(#function)")
        
        self.statusOpenView.backgroundColor = .lightGray
        self.statusOpenLabel.textColor = .white
        self.statusCloseView.backgroundColor = .black
        self.statusCloseLabel.textColor = .white
        
        self.status = 0
        self.reasonView.isHidden = false
        self.textViewReasonToClose.text = ""
        
        self.heightResonView.constant = 160.0
    }
    
    @objc func shortPositionTapGestureAction(_gesture: UITapGestureRecognizer){
        print("\(#function)")
        
        self.positionShortView.backgroundColor = .black
        self.positionShortLabel.textColor = .white
        self.positionLongView.backgroundColor = .lightGray
        self.positionLongLabel.textColor = .white
        
        self.position = 0
    }
    
    @objc func longPositionTapGestureAction(_gesture: UITapGestureRecognizer){
        
        print("\(#function)")
        self.positionShortView.backgroundColor = .lightGray
        self.positionShortLabel.textColor = .white
        self.positionLongView.backgroundColor = .black
        self.positionLongLabel.textColor = .white
        self.position = 1
    }
    
    
    //MARK:- Api call ---
    
    func fetchSymbol(){
        
        ApiCallManager.shared.apiCall(request: ApiRequestModel(), apiType: .GET_SYMBOL, responseType: GetSymbolResponse.self, requestMethod: .GET) { (results) in
            
            
            let response:GetSymbolResponse = results
            
            if response.status == 0{
                
                
                self.showAlertPopupWithMessage(msg: response.messages)
                
                
                
            }
            else{
                
                if let symbols = response.data{
                    
                    self.symbolList = symbols
                    
                    if self.symbolList?.count == 0 {
                        
                        self.showAlertPopupWithMessageWithHandler(msg: "No Symbol Available") {
                            
                            
                            self.dismiss(animated: true, completion: nil)
                            
                        }
                        
                    }
                    
                }
                else{
                    
                    
                    self.showAlertPopupWithMessageWithHandler(msg: "No Symbol Available") {
                        
                        
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                    
                    
                    
                }
                
                
                
            }
            
            
            
        } failureHandler: { (error) in
            
            self.showErrorMessage(error: error)
        }
        
        
    }
    
    
    //MARK:- UIButton action methods ----
    
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func postTradeAction(_ sender: Any) {
        
        
        if !self.isTextfieldEmpty(textFields: [self.symbolTextfield, self.totalProfiteTextfield, self.stopLossTextfield, self.tradePriceTextfield]){
            
            if self.status == 0 && self.textViewReasonToClose.text.trimmingCharacters(in: .whitespaces).count == 0 {
                
                self.showAlertPopupWithMessage(msg: "Please enter reason of closing trade")
                
            }
            if self.status == -1 {
                
                self.showAlertPopupWithMessage(msg: "Please select status")

                
                
            }
            else if self.position == -1{
                
                
                self.showAlertPopupWithMessage(msg: "Please select position")

            }
            else{
                
                let request =   AddTradeRequest(userId: self.currentUserId!, symbolId: self.selectedSymbolID ?? "0", status: "\(self.status)", position: "\(self.position)", tradePrice: self.tradePriceTextfield.text!, takeProfit: self.totalProfiteTextfield.text!, stopLoss: self.stopLossTextfield.text!, reasonLost: self.textViewReasonToClose.text)
                
                ApiCallManager.shared.apiCallUsingEncodableRequest(request: request, apiType: .ADD_TRADE, responseType: AddTradeResponse.self, requestMethod: .POST) { (results) in
                    
                    if results.status == 1{
                        
                        self.showAlertPopupWithMessageWithHandler(msg: "Trade added successfully") {
                            
                            self.dismiss(animated: true, completion: nil)
                            
                        }
                    }
                    else{
                        
                        
                        self.showAlertPopupWithMessage(msg: "Error - \(results.messages)")
                        
                    }
                    
                    
                } failureHandler: { (error) in
                    
                    
                    self.showErrorMessage(error: error)
                    
                    
                }

                
                
            }
            
            
        }
        
        
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "SelectSymbolViewController"{
            
            
            let vc:SelectSymbolViewController = segue.destination as! SelectSymbolViewController
            
            vc.deleage = self
            vc.arraySymbolList = self.symbolList
            
            
            if let _selectedSymbolID = self.selectedSymbolID, let _selectedSymbolName = self.selectedSymbolName{
                
                
                vc.selectedSymbolID = _selectedSymbolID
                vc.selectedSymbolName = _selectedSymbolName
                
                
                
            }
            
            
        }
        
    }
}

extension AddTradesViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        textField.resignFirstResponder()
        
        return true
        
        
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        
        if textField.tag == 0{
            
            self.performSegue(withIdentifier: "SelectSymbolViewController", sender: nil)
            
            return false
        }
        
        return true
    }
    
}

extension AddTradesViewController:UITextViewDelegate{
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        self.scrollViewAddTrade.setContentOffset(CGPoint(x: 0, y: 140), animated: true)
        
    }
    
    
    
}

extension AddTradesViewController:SelectSymbolDelegate{
    
    
    func didDoneSelected(symbolID: String, sym_name: String) {
        
        
        self.selectedSymbolID = symbolID
        self.selectedSymbolName = sym_name
        
        self.symbolTextfield.text = sym_name
        
        
        
    }
    
    func didCancelSelected() {
        
        
    }
    
}
