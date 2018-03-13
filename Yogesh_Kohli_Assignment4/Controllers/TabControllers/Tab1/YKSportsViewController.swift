//
//  YKSportsViewController.swift
//  Yogesh_Kohli_Assignment4
//
//  Created by Yogesh Kohli on 10/11/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit
import Foundation


class YKSportsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var countriesAndSports:Dictionary<String,Array<String>>?
    var countryType:Array<String>?
    var selectedCountry:String?
    var sports:Array<String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPlistData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pickerView.reloadAllComponents()
    }
    
    //MARK: Private Methods
    func loadPlistData() {
        let data:Bundle = Bundle.main
        let countryPlist:String? = data.path(forResource: "Country", ofType: "plist")
        if countryPlist != nil {
            countriesAndSports = (NSDictionary.init(contentsOfFile: countryPlist!) as! Dictionary)
            countryType = countriesAndSports?.keys.sorted()
            selectedCountry = countryType![0]
            sports = countriesAndSports![selectedCountry!]!
            // Do any additional setup after loading the view.
        }
    }
    
    //MARK: UISlider Action
    @IBAction func sliderMoved(_ sender: Any) {
        let sportCount = round(Double((self.sports?.count)!-1))
        let tempRow = round((((Double(self.slider.value))*sportCount)/100))
        let finalIndex = Int(tempRow)
        DispatchQueue.main.async {
            if finalIndex <= (self.sports?.count)! {
                self.pickerView.selectRow(finalIndex, inComponent: 1, animated: true)
            }
        }
    }
    
    //MARK: UIPickerView DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard (countryType != nil) && sports != nil else { return 0 }
        switch component {
        case 0: return countryType!.count
        case 1: return sports!.count
        default: return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard (countryType != nil) && sports != nil else { return nil }
        switch component {
        case 0: return countryType?[row]
        case 1: return sports?[row]
        default: return nil
        }
    }
    //MARK: UIPickerView Delegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard (countryType != nil) && sports != nil else { return }
        if component == 0 {
            selectedCountry = countryType![row]
            sports = countriesAndSports![selectedCountry!]!
            DispatchQueue.main.async {
                let component2RowSelected = self.pickerView.selectedRow(inComponent: 1)
                self.slider.value = Float(component2RowSelected*100/((self.sports?.count)!-1))
                self.pickerView.reloadComponent(1)
            }
        }
        else {
            DispatchQueue.main.async {
                self.slider.value = Float(row*100/((self.sports?.count)!-1))
            }
        }
    }
}
