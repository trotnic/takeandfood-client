//
//  OrdersListControllerTableViewController.swift
//  Take&Food
//
//  Created by Vladislav on 5/17/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import UIKit

class OrdersListControllerTableViewController: UITableViewController {

    var orders: [[String: [String: Announcement]]] = []
    
    override func loadView() {
        super.loadView()
        
        
        
    }
    
    func fetchData() {
        TAFNetwork.request(router: .getOrdersForRestaurant(id: SessionEntity.user.restaurantId!)) { (result: Result<[Order], Error>) in
            switch result {
            case .success(let data):
                for order in data {
                    TAFNetwork.request(router: .getAnnouncementById(id: order.announcementId!)) { (result: Result<Announcement, Error>) in
                        switch result {
                        case .success(let announcement):
                            self.orders.append(["\(order.id!)": ["\(order.userId!)":announcement]])
                            DispatchQueue.main.async {
                                print(self.orders)
                                self.tableView.reloadData()
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Orders"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.orders.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = self.orders[indexPath.row].keys.first
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(AcceptOrderViewController(data: self.orders[indexPath.row].values.first!, orderId: Int(self.orders[indexPath.row].keys.first!)!), animated: true)
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
