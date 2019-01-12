//
//  ItemDescriptionViewController.swift
//  NetflixRoulette
//
//  Created by Ramzy Kermad on 25/12/2018.
//  Copyright © 2018 Ramzy Kermad. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ItemDescriptionViewController: UIViewController {
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title_label: UILabel!
    
    @IBOutlet weak var rate_value: UILabel!
    @IBOutlet weak var duration_value: UILabel!
    @IBOutlet weak var date_value: UILabel!
    @IBOutlet weak var genre_value: UILabel!
    @IBOutlet weak var synopsis_value: UILabel!
    
    
    var movie_title: String = ""
    var movie_image_url: String = ""
    var movie_id: Int?
    
//    var movies_sinopsis: String = ""
//    var movie_rate: Int = 0
//    var movie_duration: Int = 0
//    var movie_release_date: String = ""
//    var movie_productor: String = ""
//    var movie_actors: String = ""
//    var movie_type: String = ""
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fillViews()
    }

    private func fillViews(){
        guard movie_title != nil,
                movie_id != nil else {
            poster.image = UIImage(named: "report_problem_white")
            return
        }
        title_label.text = movie_title
        guard let url = self.movie_image_url as? String else{
            poster.image = UIImage(named: "report_problem_white")
            return
        }
        poster.af_setImage(withURL: URL(string: url)!)
        
        self.getOtherInformationsAboutMovie()
    }

    private func getOtherInformationsAboutMovie(){
        let params: [String : Int] = [
            "id": self.movie_id!
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-BetaSeries-Key": "ef873e84f313",
            "X-BetaSeries-Version": "3.0"
        ]
        
        _ = Alamofire.request("https://api.betaseries.com/movies/movie", method: .get, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response: DataResponse<Any>) in
            
            let main_response = response.result.value as? [String: Any]
            let _movie = main_response?["movie"] as? [String: Any]
            
            if(_movie == nil){
                self.apiDataGetter(m: "movies", response: response)
            }else{
                self.apiDataGetter(m: "movie", response: response)
            }
            
           
        }
    }
    
    private func apiDataGetter(m: String, response: DataResponse<Any>){
        
        guard let json_response = response.result.value as? [String: Any],
            let movie = json_response[m] as? [String: Any],
            let duration = movie["length"] as? Int,
            let synopsis = movie["synopsis"] as? String,
            let notes = movie["notes"] as? [String: Any],
            let release = movie["original_release_date"] as? String else{
                return
        }
        self.duration_value.text = duration.description
        self.synopsis_value.text = synopsis
        self.date_value.text = release
        
        let test = notes["mean"]

        if test as? Int != nil{
            self.rate_value.text = (test as! Int).description
        } else if type(of: test) == type(of: String()){
            self.rate_value.text = test as? String
        }
        
        
        
        
        print("response of the server: \(json_response)")
        
        guard let json = response.result.value as? [String: Any],
            let m = json[m] as? [String: Any],
            let movie_genre = m["genres"] as? [String] else {
                return
        }
        let genres_concat = movie_genre.joined(separator: ", ")
        self.genre_value.text = genres_concat
    }

}
