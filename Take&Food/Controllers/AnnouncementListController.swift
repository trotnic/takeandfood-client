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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }

    func fetchData() {
        TAFNetwork.request(router: .getAnnouncementAll(page: 1)) { (result: Result<[Announcement], Error>) in
            switch result {
            case .success(let data):
                self.data = data.reversed()
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
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        
        cell.textLabel?.text = dateFormatter.string(from: dateFormatter.date(from: self.data?[indexPath.row].date ?? "") ?? Date())
        switch self.data?[indexPath.row].status {
        case 1:
            cell.textLabel?.textColor = .gray
        case 2:
            cell.textLabel?.textColor = .lightGray
        default:
            break
        }
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if data?[indexPath.row].status == 2 { return }
        
        if let data = self.data {
            self.navigationController?.pushViewController(DishTableController(announcement: data[indexPath.row]), animated: true)
        }
    }
}
