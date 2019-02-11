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
    @IBOutlet weak var favIcon: UIImageView!
    
    private var isFav = false;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(MovieSearchTableViewCell.addMovieToFavorite))
        favIcon.isUserInteractionEnabled = true
        favIcon.addGestureRecognizer(singleTap)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func addMovieToFavorite(){
        // fonction à supprimer pour enlever el coeur des cellules des listes
        isFav = !isFav
        if isFav{
            favIcon.image = UIImage(named: "fav_white_full")
            //MovieServices.default.addMovieToFavs(movieID: <#T##Int#>, userAuthToken: <#T##String#>)
        }else{
            favIcon.image = UIImage(named: "fav_white_empty")
        }
        
        
    }

    
}
