//
//  HomeCitiesTableViewController.swift
//  Weather
//
//  Created by 冨田悠斗 on 2018/11/07.
//  Copyright © 2018 kang haejoon. All rights reserved.
//

import UIKit

class HomeCitiesTableViewController: UITableViewController {
    
    var homecities : [String] = []
    let userDefaults = UserDefaults.standard
    var homenames : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        if let tempArray : [String] = userDefaults.object(forKey: "home") as? [String]{
            self.homecities = tempArray
            print(tempArray)
            print(homecities)
        }
        if let tempnames : [String] = userDefaults.object(forKey: "name") as? [String]{
            self.homenames = tempnames
            print(tempnames)
            print(homenames)
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.homenames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = homenames[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            homecities.remove(at: indexPath.row)
            homenames.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            userDefaults.set(homecities, forKey: "home")
            userDefaults.set(homenames, forKey: "name")
            userDefaults.synchronize()
        }
    }

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
