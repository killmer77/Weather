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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString: String
        urlString = "https://api.openweathermap.org/data/2.5/weather?q={" + cityname + "}"
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                let json = try! JSON(data: data)
                print(json)
                
//                if json["metadata"]["responseInfo"]["status"].intValue == 200 {
//                    parse(json: json)
//                    return
//                }
            }else{
                print("error")
            }
        }else{
            print("error2")
        }

        title = cityname
        self.weatherLabel.text = "Rainy"
        self.tempLabel.text = "25℃"
        self.maxMinTempLabel.text = "25℃ / 16℃"
        self.humidityLabel.text = "49%"
        
        // Do any additional setup after loading the view, typically from a nib.
    }

}

