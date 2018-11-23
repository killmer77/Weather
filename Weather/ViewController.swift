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
    var fromMap = false
    var lon = 0.0
    var lat = 0.0
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var maxMinTempLabel: UILabel!
    var urlString: String = ""
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var imageVIew: UIImageView!
    var cityids:[String] = []
    var cities = [String]()
    var fromhome = false
    
    let userDefaults = UserDefaults.standard
    
    var pictures = ["sunny.jpg", "cloud.jpg", "rain.jpg", "snow.jpg"]
    
    var activityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loading
        let screensize = UIScreen.main.bounds.size
        let navi = UIApplication.shared.statusBarFrame.size.height
        let center = CGPoint(x: screensize.width / 2, y: (screensize.height / 2))
        activityIndicatorView.center = center
        activityIndicatorView.style = .whiteLarge
        activityIndicatorView.color = .gray
        view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        //loading
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if fromMap {
            self.urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(self.lat)&lon=\(self.lon)&appid=e56c905428db86b3e78bd8a5064ef029"
            openweathermap()
        }else if fromhome{
            urlString = "https://api.openweathermap.org/data/2.5/weather?id=\(cityid)&appid=e56c905428db86b3e78bd8a5064ef029"
            openweathermap()
        }else{
            let index = cities.index(of: cityname)!
            self.cityid = cityids[index]
            urlString = "https://api.openweathermap.org/data/2.5/weather?id=\(cityid)&appid=e56c905428db86b3e78bd8a5064ef029"
            openweathermap()
        }
        
        let homenames = userDefaults.object(forKey: "name") as? [String] ?? []
        
        if !fromhome && !homenames.contains(cityname){
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(addTapped))
        }
    }
    
    @objc func addTapped(){
        var homecities : [String] = []
        var homenames : [String] = []
        if let tempArray : [String] = userDefaults.object(forKey: "home") as? [String]{
            userDefaults.removeObject(forKey: "home")
            homenames = (userDefaults.object(forKey: "name") as? [String]) ?? []
            homecities = tempArray
        }
        homecities.append(cityid)
        homenames.append(cityname)
        userDefaults.set(homecities, forKey: "home")
        userDefaults.set(homenames, forKey: "name")
        print(homecities)
        userDefaults.synchronize()
        let add = NSLocalizedString("add", comment: "")
        let message = NSLocalizedString("message", comment: "")
        let alert = UIAlertController(title: add, message: cityname + message, preferredStyle: UIAlertController.Style.alert)
        
       
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
      
        self.present(alert, animated: true, completion: nil)
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
        let name = json["name"].stringValue
        let country = json["sys"]["country"].stringValue
        self.cityname = name
        
        DispatchQueue.main.async {
            self.tempLabel.text = String(temp) + "℃"
            self.maxMinTempLabel.text = String(max) + "℃ / " + String(min) + "℃"
            self.humidityLabel.text = humidity + "%"
            self.weatherLabel.text = weather.capitalized
            self.title = name + ", " + country
            
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
            self.activityIndicatorView.stopAnimating()
        }
    }

}


