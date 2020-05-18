//
//  RestaurantListController.swift
//  Take&Food
//
//  Created by Vladislav on 4/22/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import UIKit

class RestaurantListController: UITableViewController {

    var data: [Restaurant]?
    
    override func loadView() {
        super.loadView()
        
        self.navigationItem.title = "Restaurants"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.fetchData()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func fetchData() {
        TAFNetwork.request(router: .getRestaurantAll(page: 1)) { (result: Result<[Restaurant], Error>) in
            switch result {
            case .success(let data):
                print(data)
                self.data = data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = self.data {
            return data.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        cell.textLabel?.text = self.data?[indexPath.row].name!

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = RestaurantViewController(restaurant: self.data![indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
