//
//  AnnouncementCell.swift
//  Take&Food
//
//  Created by Vladislav on 5/16/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import UIKit

class AnnouncementCell: UITableViewCell {

    var announcement: Announcement? {
        didSet {
            dateLabel.text = announcement?.date
            announcement?.dishes?.forEach({ (dish) in
                let dishLabel = UILabel()
                dishLabel.text = dish.name
                dropDown.addArrangedSubview(dishLabel)
            })
        }
    }
    
    private var dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private var dropDown: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .red
        return stack
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(dateLabel)
        addSubview(dropDown)
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 30),
            
            dropDown.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 35),
            dropDown.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            dropDown.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            dropDown.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.dateLabel = UILabel()
        self.dropDown = UIStackView()
    }
    
    func toggleList() {
        self.dropDown.isHidden = !self.dropDown.isHidden
    }
}
