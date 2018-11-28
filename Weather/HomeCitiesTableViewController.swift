//
//  HomeCitiesTableViewController.swift
//  Weather
//
//  Created by 冨田悠斗 on 2018/11/07.
//  Copyright © 2018 kang haejoon. All rights reserved.
//

import UIKit
import GoogleMobileAds

class HomeCitiesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let userDefaults = UserDefaults.standard
    var homecities : [String] = []
    var homenames : [String] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var adsView: UIView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    //ads
    // Ads Unit ID
    let AdMobID = "ca-app-pub-3243383061950023/4668585209"
    // Ads Testing Unit ID
    let TEST_ID = "ca-app-pub-3940256099942544/2934735716"
    let AdMobTest : Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ads
        print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
        var admobView = GADBannerView()
        admobView = GADBannerView(adSize:kGADAdSizeBanner)
        admobView.frame.origin = CGPoint(x:0, y:0)
        admobView.frame.size = CGSize(width:self.view.frame.width, height:admobView.frame.height)
        if AdMobTest {
            admobView.adUnitID = TEST_ID
        }else{
            admobView.adUnitID = AdMobID
        }
        admobView.rootViewController = self
        admobView.load(GADRequest())
        adsView.addSubview(admobView)
        self.view.addSubview(adsView)
        //ads
        
        self.navigationBar.title = NSLocalizedString("homecity", comment: "")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.homecities = userDefaults.object(forKey: "home") as? [String] ?? []
        self.homenames = userDefaults.object(forKey: "name") as? [String] ?? []
        tableView.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homenames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = homenames[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as? ViewController {
            vc.cityid = self.homecities[indexPath.row]
            vc.fromhome = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
