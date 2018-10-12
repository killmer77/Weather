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
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var maxMinTempLabel: UILabel!
    var urlString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlString = "https://api.openweathermap.org/data/2.5/weather?q=" + cityname + "&appid=e56c905428db86b3e78bd8a5064ef029"
//        urlString = "https://samples.openweathermap.org/data/2.5/weather?q=London,uk&appid=b6907d289e10d714a6e88b30761fae22"
        
        openweathermap()

        title = cityname        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func openweathermap(){
        let url = NSURL(string: self.urlString)!
        let task = URLSession.shared.dataTask(with: url as URL, completionHandler: {data, response, error in
            let json = try! JSON(data: data!)
            self.parse(json: json)
        })
        task.resume()
    }
    
    func parse(json: JSON) {
        let main = json["main"]
        let max_k = main["temp_max"].floatValue
        let min_k = main["temp_min"].floatValue
        let temp_k = main["temp"].floatValue
        let humidity = main["humidity"].stringValue
        let weatherjson = json["weather"].arrayValue
        let weatherjson2 = weatherjson[0]
        let weather = weatherjson2["main"].stringValue
        let max = Int(max_k - 273.15)
        let min = Int(min_k - 273.15)
        let temp = Int(temp_k - 273.15)
        DispatchQueue.main.async {
            self.tempLabel.text = String(temp) + "℃"
            self.maxMinTempLabel.text = String(max) + "℃ / " + String(min) + "℃"
            self.humidityLabel.text = humidity + "%"
            self.weatherLabel.text = weather
        }
    }

}

