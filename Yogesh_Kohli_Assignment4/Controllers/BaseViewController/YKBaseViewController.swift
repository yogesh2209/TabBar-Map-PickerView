//
//  YKBaseViewController.swift
//  Yogesh_Kohli_Assignment4
//
//  Created by Yogesh Kohli on 10/14/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit

class YKBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: CUSTOM METHODS
    func alertMessage(_ message: String) -> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Alert", message:message, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
