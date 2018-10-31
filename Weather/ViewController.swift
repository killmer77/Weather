//
//  ViewController.swift
//  Weather
//
//  Created by kang haejoon on 2018/10/10.
//  Copyright © 2018 kang haejoon. All rights reserved.
//
//Tommy
//Ann
//Joon
import UIKit


class ViewController: UIViewController {
    
    var cityname = ""
    var cityid = ""
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var maxMinTempLabel: UILabel!
    var urlString: String = ""
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var imageVIew: UIImageView!
    var cityids:[String] = []
    var cities = [String]()
    
    var pictures = ["sunny.jpg", "cloud.jpg", "rain.jpg", "snow.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let index = cities.index(of: cityname)!
        self.cityid = cityids[index]
        urlString = "https://api.openweathermap.org/data/2.5/weather?id=" + cityid + "&appid=e56c905428db86b3e78bd8a5064ef029"
        openweathermap()
        title = cityname
    }
    
    func openweathermap(){
        if let url = NSURL(string: self.urlString){
            let task = URLSession.shared.dataTask(with: url as URL, completionHandler: {data, response, error in
            let json = try! JSON(data: data!)
            self.parse(json: json)
            })
            task.resume()
        }else{
            let ac = UIAlertController(title: title, message: "We cannot find \(cityname)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: back))
            present(ac, animated: true)
        }
    }
    
    func back(action: UIAlertAction! = nil) {
            navigationController?.popViewController(animated: true)
    }
    
    func parse(json: JSON) {
        let main = json["main"]
        let max_k = main["temp_max"].floatValue
        let min_k = main["temp_min"].floatValue
        let temp_k = main["temp"].floatValue
        let humidity = main["humidity"].stringValue
        let weatherjson = json["weather"].arrayValue
        let weatherjson2 = weatherjson[0]
        let weather = weatherjson2["description"].stringValue
        let icon = weatherjson2["icon"].stringValue
        let url = NSURL(string: "https://openweathermap.org/img/w/" + String(icon.prefix(2)) + "d.png")
        let max = Int(max_k - 273.15)
        let min = Int(min_k - 273.15)
        let temp = Int(temp_k - 273.15)
        DispatchQueue.main.async {
            self.tempLabel.text = String(temp) + "℃"
            self.maxMinTempLabel.text = String(max) + "℃ / " + String(min) + "℃"
            self.humidityLabel.text = humidity + "%"
            self.weatherLabel.text = weather.capitalized
            
            let data = try? Data(contentsOf: url as! URL)
            
            if let imageData = data {
                let image = UIImage(data: imageData)
                self.iconImage.image = image
            }
            
            print(icon)
            
            if icon.hasPrefix("01") || icon.hasPrefix("02"){
                self.imageVIew.image = UIImage(named: self.pictures[0])
            } else if icon.hasPrefix("03") || icon.hasPrefix("04"){
                self.imageVIew.image = UIImage(named: self.pictures[1])
            } else if icon.hasPrefix("13"){
                self.imageVIew.image = UIImage(named: self.pictures[3])
            }else{
                self.imageVIew.image = UIImage(named: self.pictures[2])
                self.tempLabel.textColor = UIColor.white
                self.maxMinTempLabel.textColor = UIColor.white
                self.humidityLabel.textColor = UIColor.white
                self.weatherLabel.textColor = UIColor.white
            }
        }
    }

}


