//
//  YKSegmentControlViewController.swift
//  Yogesh_Kohli_Assignment4
//
//  Created by Yogesh Kohli on 10/11/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit

class YKSegmentControlViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customiseUI()
        addTapGesture()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    @IBAction func segmentControlPressed(_ sender: Any) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //MARK: UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if segmentControl.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: POST_PROGRESS_SEGMENT_CUSTOM_CELL, for: indexPath as IndexPath) as! YKProgressSegmentTableViewCell
            cell.layer.cornerRadius = 5.0
            cell.layer.masksToBounds = true
            cell.switchActivityIndicator.addTarget(self, action: #selector(switchTriggered(sender:)), for: .valueChanged)
            
            return cell
        }
        else if segmentControl.selectedSegmentIndex == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: POST_TEXT_SEGMENT_CUSTOM_CELL, for: indexPath as IndexPath) as! YKTextSegmentTableViewCell
            cell.textViewMessage.delegate = self
            cell.textViewMessage.text = "Hello Professor ! It's my text!!"
            cell.textViewMessage.layer.cornerRadius = 5.0
            cell.textViewMessage.layer.masksToBounds = true
            cell.textViewMessage.backgroundColor = UIColor.init(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0)
            cell.textViewMessage.layer.borderColor = UIColor.lightGray.cgColor
            cell.textViewMessage.layer.borderWidth = 1.0
            cell.textViewMessage.placeholder = "Write your text here!"
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: POST_ALERT_SEGMENT_CUSTOM_CELL, for: indexPath as IndexPath) as! YKAlertSegmentTableViewCell
            cell.buttonAlert.addTarget(self, action: #selector(buttonAlertPressed(sender:)), for: .touchUpInside)
            
            return cell
        }
    }
    //UITableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if segmentControl.selectedSegmentIndex == 0 {
            return 80.0
        }
        else if segmentControl.selectedSegmentIndex == 1 {
            return 120.0
        }
        else {
            return 60.0
        }
    }
    
    //MARK: Private Methods
    func customiseUI() -> Void {
        self.segmentControl.selectedSegmentIndex = 0
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.clear
    }
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(YKSegmentControlViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)
    }
    @objc func hideKeyboard() {
        tableView.endEditing(true)
    }
    
    //MARK: UIElement Actions
    @objc func buttonAlertPressed (sender: UIButton) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Alert", message:"Do you like the iPhone?", preferredStyle: UIAlertControllerStyle.alert)
            let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            }
            let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil)
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    @objc func switchTriggered(sender: UISwitch) {
        let switchIndicator = sender.isOn
        if switchIndicator {
            let indexPath = IndexPath(row: 0, section: 0)
            let cell = tableView.cellForRow(at: indexPath) as! YKProgressSegmentTableViewCell
            DispatchQueue.main.async {
                cell.activityIndicator.startAnimating()
            }
        }
        else {
            let indexPath = IndexPath(row: 0, section: 0)
            let cell = tableView.cellForRow(at: indexPath) as! YKProgressSegmentTableViewCell
            DispatchQueue.main.async {
                cell.activityIndicator.stopAnimating()
            }
        }
    }
}

/// Extend UITextView and implemented UITextViewDelegate to listen for changes
extension UITextView: UITextViewDelegate {
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    public var placeholder: String? {
        get {
            var placeholderText: String?
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        placeholderLabel.isHidden = self.text.count > 0
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.count > 0
        }
    }
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
}
