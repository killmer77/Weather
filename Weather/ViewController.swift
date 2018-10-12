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
//        urlString = "https://api.openweathermap.org/data/2.5/weather?q=" + cityname + "&appid=e56c905428db86b3e78bd8a5064ef029"
        urlString = "https://samples.openweathermap.org/data/2.5/weather?q=London,uk&appid=b6907d289e10d714a6e88b30761fae22"
//        if let url = URL(string: urlString) {
//            if let data = try? Data(contentsOf: url) {
//                let json = try! JSON(data: data)
//                print(json)
//
////                if json["metadata"]["responseInfo"]["status"].intValue == 200 {
////                    parse(json: json)
////                    return
////                }
//            }else{
//                print("error")
//            }
//        }else{
//            print("error2")
//        }
        
        openweathermap()

        title = cityname
        self.weatherLabel.text = "Rainy"
        self.tempLabel.text = "25℃"
        self.maxMinTempLabel.text = "25℃ / 16℃"
        self.humidityLabel.text = "49%"
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func openweathermap(){
        // openweathermapApiを用いて各情報を取得
        let url = NSURL(string: self.urlString)!
        let task = URLSession.shared.dataTask(with: url as URL, completionHandler: {data, response, error in
            // リソースの取得が終わると、ここに書いた処理が実行
            let json = try! JSON(data: data!)
            print(json)
        })
        task.resume()
    }

}

