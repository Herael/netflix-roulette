//
//  MovieSearchTableViewCell.swift
//  NetflixRoulette
//
//  Created by Benjamin Rousval on 17/01/2019.
//  Copyright © 2019 Ramzy Kermad. All rights reserved.
//

import UIKit

class MovieSearchTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var typeImageView: UIImageView!
    @IBOutlet var releaseDateLabel: UILabel!
    @IBOutlet var lengthLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
