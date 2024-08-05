//
//  MenuViewController.swift
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

protocol MenuViewControllerDelegate : AnyObject {
    func didSelect(menuItem: MenuViewController.MenuOptions);
};

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    weak var delegate: MenuViewControllerDelegate?;
    
    enum MenuOptions: String, CaseIterable { // order matters
        case home = "Home";
        case info = "Information";
        case appRating = "App Rating";
        case shareApp = "Share App";
        case settings = "Settings";
        case website = "Website"
        
        var imageName: String {
            switch self {
            case .home:
                return "house";
            case .info:
                return "info.circle";
            case .appRating:
                return "star";
            case .shareApp:
                return "square.and.arrow.up"; //"message";
            case .settings:
                return "gear";
            case .website:
                return "globe";
            };
        };
    };
    
    private let tableView: UITableView = {
        let table = UITableView();
        table.backgroundColor = nil;
        // Could use a custom cell, but for this example we will use a standard cell
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell");
        return table;
    }()
    
    // Make the menu background a dark grey
    let greyColor =  UIColor(
        red: 32/255.0,
        green: 32/255.0,
        blue: 32/255.0,
        alpha: 1
    );
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        view.addSubview(self.tableView);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        view.backgroundColor = self.greyColor;
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        self.tableView.frame = CGRect(x: 0,
                                      y: view.safeAreaInsets.top,
                                      width: view.bounds.size.width,
                                      height: view.bounds.size.height);
    }
    
    // Table View Delegate and Data Source Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count;
    };

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        // return string from MenuOptions enumeration
        cell.textLabel?.text = MenuOptions.allCases[indexPath.row].rawValue;
        cell.textLabel?.textColor = .white;
        cell.imageView?.image = UIImage(systemName: MenuOptions.allCases[indexPath.row].imageName);
        // image has same color background as text
        cell.imageView?.tintColor = .white;
        cell.backgroundColor = self.greyColor;
        cell.contentView.backgroundColor = self.greyColor;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // un highlight
        tableView.deselectRow(at: indexPath, animated: true);
        let item = MenuOptions.allCases[indexPath.row];
        delegate?.didSelect(menuItem: item);
    }
}
