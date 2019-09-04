//
//  StudentLocationTableViewCell.swift
//  OnTheMap
//
//  Created by Elaine Ernst on 2019/09/02.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import UIKit

class StudentLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var mediaLink: UILabel!
    @IBOutlet weak var fullName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(firstName: String, lastname: String, media: String)
    {
        self.fullName.text = "\(firstName) \(lastname)"
        self.mediaLink.text = media
    }

}
