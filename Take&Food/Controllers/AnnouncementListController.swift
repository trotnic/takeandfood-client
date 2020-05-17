//
//  AnnouncementListController.swift
//  Take&Food
//
//  Created by Vladislav on 4/22/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import UIKit

class AnnouncementListController: UITableViewController {

    var data: [Announcement]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        
        if (SessionEntity.user.role == 0) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(createNewOne))
        }
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Announcements"
        
        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.tableView.register(AnnouncementCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }

    @objc func createNewOne() {
        self.navigationController?.pushViewController(AnnouncementCreateController(), animated: true)
    }
    
    // MARK: - Table view data source

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fetchData()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let data = self.data {
            return data.count
        }
        return 0
    }

    func fetchData() {
        TAFNetwork.request(router: .getAnnouncementAll(page: 1)) { (result: Result<[Announcement], Error>) in
            switch result {
            case .success(let data):
                self.data = data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
    
        cell.textLabel?.text = self.data?[indexPath.row].date!
        if (self.data?[indexPath.row].status == 1) {
            cell.textLabel?.textColor = .gray
        }

        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        guard let cell = tableView.cellForRow(at: indexPath) as? AnnouncementCell else {
//            return
//        }
//        cell.toggleList()
//        tableView.reloadRows(at: [indexPath], with: .automatic)
//        tableView.beginUpdates()
//        tableView.endUpdates()
//        DispatchQueue.main.async {
//            UIView.animate(withDuration: 0.3) {

//                cell.toggleList()
//            }
//        }
        
        if let data = self.data {
            self.navigationController?.pushViewController(DishTableController(announcement: data[indexPath.row]), animated: true)
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
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
