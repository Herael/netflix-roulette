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
    @IBOutlet var synopsis_value: UITextView!
    
    var movie_title: String?
    var movie_image_url: String! = ""
    var movie_id: Int?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //TO DO : Why he don't make my button..?
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.fillViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "fav_white_full"), style: .done, target: self, action: #selector(addMovieToFavorite))
        self.tabBarController?.navigationItem.leftBarButtonItem?.tintColor = UIColor.red
    }
    
    @objc func addMovieToFavorite(){
        print("Movie added to favorite list!")
        
        let idMovie = movie_id
        let authToken = "6513d7f844db"
        
        MovieServices.default.addMovieToFavs(movieID: idMovie!, userAuthToken: authToken)
    }
    
    private func fillViews(){
        guard movie_title != nil else {
            poster.image = UIImage(named: "noPicture")
            return
        }
        title_label.text = movie_title
        if movie_image_url == ""{
            poster.image = UIImage(named: "noPicture")
        }else{
            poster.af_setImage(withURL: URL(string: self.movie_image_url)!)
        }
        
     
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
        let durationEnhanced: [Int] = convertToHours(secondes: duration)
        self.duration_value.text = "Length : " + durationEnhanced[0].description + "h" + durationEnhanced[1].description
        self.synopsis_value.text = "Synopsis : " + synopsis
        self.date_value.text = "Date : " + release

        if let test = notes["mean"] as? Int{
            self.rate_value.text = "Note: " + test.description + "/5"
        } else if let test = notes["mean"] as? Double{
            self.rate_value.text = "Note: " +  Int(test).description + "/5"
        }else if let test = notes["mean"] as? String{
            self.rate_value.text = "Note: " + test + "/5"
        }

        print("response of the server: \(json_response)")
        
        guard let json = response.result.value as? [String: Any],
            let m = json[m] as? [String: Any],
            let movie_genre = m["genres"] as? [String] else {
                return
        }
        let genres_concat = movie_genre.joined(separator: ", ")
        if genres_concat.count == 0 {
                self.genre_value.text = "Type : /"
        }else {
                self.genre_value.text = "Type : " + genres_concat
        }
    }
    
    private func convertToHours(secondes: Int) -> [Int]{
        let hours: Int = secondes/3600
        let minutes: Int = (secondes % 3600) / 60
        var time: [Int] = []
        time.append(hours)
        time.append(minutes)
        return time;
    }

}
