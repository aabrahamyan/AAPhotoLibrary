//
//  LibraryItemCell.swift
//  AAPhotoLibrary
//
//  Created by Armen Abrahamyan on 5/8/16.
//  Copyright © 2016 Armen Abrahamyan. All rights reserved.
//

import UIKit

class AALibraryItemCell: UITableViewCell {

    @IBOutlet weak var libraryItemTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
