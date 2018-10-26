//
//  CityTableViewController.swift
//  Weather
//
//  Created by 冨田悠斗 on 2018/10/10.
//  Copyright © 2018 kang haejoon. All rights reserved.
//

import UIKit

class CityTableViewController: UITableViewController , UISearchBarDelegate{
    
//    var cities = ["Kusatsu", "Taipei", "Seoul", "Kyoto", "Yellowknife"]
    var cities = [String]()
    var searchResults:[String] = []
    var tempResults:[String] = []
    var previoustext = ""
    var searchController = UISearchController()
    var cityid:[String] = []
    var idresult:[String] = []
    var deleted = false

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self as! UISearchBarDelegate
        searchBar.enablesReturnKeyAutomatically = false
        
        let json = loadJson()
        parse(json: json!)
        searchResults = cities
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "city", for: indexPath)
        cell.textLabel?.text = searchResults[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as? ViewController {
            vc.cityname = searchResults[indexPath.row]
            vc.cities = self.cities
            vc.cityids = self.cityid
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func parse(json: JSON) {
        for city in json.arrayValue {
            let name = city["name"].stringValue
            let id = city["id"].stringValue
            cities.append(name)
            cityid.append(id)
        }
        tableView.reloadData()
    }
    
    func loadJson() -> JSON? {
        let path = Bundle.main.path(forResource: "city.list", ofType: "json")
        do{
            let jsonStr = try String(contentsOfFile: path!)
            let json =  JSON.init(parseJSON: jsonStr)
            return json
        } catch{
            return nil
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults.removeAll()
        if(searchBar.text == "") {
            searchResults = cities
        } else {
            if let word = searchBar.text!.range(of: previoustext){
                deleted = false
                print(deleted)
            }else{
                deleted = true
                print(deleted)
            }
            if deleted {
                tempResults = searchResults
                for city in tempResults {
                    if let range = city.range(of: searchBar.text!) {
                        searchResults.append(city)
                    }
                }
            }else{
                for city in cities {
                    if let range = city.range(of: searchBar.text!) {
                        searchResults.append(city)
                    }
                }
            }
            previoustext = searchBar.text!
        }
        tableView.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
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
