//
//  SettingsViewController.swift
//  Side Menu Example
//
//  Created by Derson Productions, LLC on 2024-AUG-03.
//
//  MIT License
//
//  Copyright (c) 2024 Derson Productions, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

protocol SettingsViewControllerDelegate : AnyObject {
    func didSelect(settingMenuItem: SettingsViewController.SettingOptions);
};

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties

    weak var delegate: SettingsViewControllerDelegate?;

    enum SettingOptions: String, CaseIterable { // order matters
        case profile = "Profile";
        case notifications = "Notifications";
        case privacy = "Privacy";
        case logout = "Logout";
        
        var imageName: String {
            switch self {
            case .profile:
                return "person";
            case .notifications:
                return "bell";
            case .privacy:
                return "hand.raised";
            case .logout:
                return "rectangle.portrait.and.arrow.right";
            };
        };
    };

    private var tableView: UITableView = {
        let table = UITableView();
        table.backgroundColor = .clear; // nil
        // Could use a custom cell, but for this example we will use a standard cell
        // table.register(UITableViewCell.self, forCellReuseIdentifier: "cell");
        table.register(ButtonTableViewCell.self, forCellReuseIdentifier: "cell")
        return table;
    }();

    // MARK: - Colors

    let ViewColor: UIColor = .systemBackground;
    let TextColor: UIColor = .label;

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings";

        view.addSubview(self.tableView);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.allowsSelection = true;
        view.backgroundColor = ViewColor;

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        self.tableView.frame = CGRect(x: 0,
                                      y: view.safeAreaInsets.top,
                                      width: view.bounds.size.width,
                                      height: view.bounds.size.height);
    }

    // MARK: - Functions

    // Table View Delegate and Data Source Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingOptions.allCases.count;
    };

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ButtonTableViewCell;
        let option = SettingOptions.allCases[indexPath.row];
        // return string from MenuOptions enumeration
        // cell.textLabel?.text = option.rawValue;
        cell.textLabel?.textColor = TextColor;
        cell.imageView?.image = UIImage(systemName: option.imageName);
        // image has same color background as text
        cell.imageView?.tintColor = TextColor;
        cell.backgroundColor = ViewColor;
        cell.contentView.backgroundColor = ViewColor;

        cell.button.setTitle("\(option.rawValue)", for: .normal)
        cell.button.tag = indexPath.row

        switch option {
        case .profile:
            cell.button.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)    
        case .notifications:
            cell.button.addTarget(self, action: #selector(notificationsButtonTapped), for: .touchUpInside)
        case .privacy:
            cell.button.addTarget(self, action: #selector(privacyButtonTapped), for: .touchUpInside)
        case .logout:
            cell.button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        }

        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // un highlight
        print("Here")
        tableView.deselectRow(at: indexPath, animated: true);
        let selectedOption = SettingOptions.allCases[indexPath.row];
        self.delegate?.didSelect(settingMenuItem: selectedOption);
    }

    @objc private func profileButtonTapped() {
        print("Profile button tapped")
        self.delegate?.didSelect(settingMenuItem: SettingOptions.profile)
    }

    @objc private func notificationsButtonTapped() {
        print("Notifications button tapped")
        self.delegate?.didSelect(settingMenuItem: SettingOptions.notifications)
    }

    @objc private func privacyButtonTapped() {
        print("Privacy button tapped")
        self.delegate?.didSelect(settingMenuItem: SettingOptions.privacy)
    }

    @objc private func logoutButtonTapped() {
        print("Logout button tapped")
        self.delegate?.didSelect(settingMenuItem: SettingOptions.logout)
    }
    
}

class ButtonTableViewCell: UITableViewCell {
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tap me", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(button)
        
        // Constraints for the button
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            button.leadingAnchor.constraint(equalTo: imageView!.trailingAnchor, constant: 8),
            button.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
