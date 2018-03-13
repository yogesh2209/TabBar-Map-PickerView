//
//  YKProgressSegmentTableViewCell.swift
//  Yogesh_Kohli_Assignment4
//
//  Created by Yogesh Kohli on 10/11/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit

class YKProgressSegmentTableViewCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var switchActivityIndicator: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
