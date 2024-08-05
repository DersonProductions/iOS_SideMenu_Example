//
//  HomeViewController.swift
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

// used to control the reveal of the MenuViewController that is beneath the view shown
protocol HomeViewControllerDelegate : AnyObject {
    func didTapMenuButton();
};

class HomeViewController: UIViewController {

    // Weak to not cause a memory leak
    weak var delegate: HomeViewControllerDelegate?;
    
    override func viewDidLoad() {
        super.viewDidLoad();

        view.backgroundColor = .systemBackground;
        title = "Home";
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didTapMenuButton)
        );
        // Create VStack and add in the ImageView and Label
        let stack = UIStackView();
        stack.axis = .vertical;
        stack.alignment = .center;
        stack.spacing = 20;
        stack.translatesAutoresizingMaskIntoConstraints = false;
        

        // add a pretty picture
        let imageView = UIImageView(image: UIImage(named: "Logo"));
        imageView.contentMode = .scaleAspectFit;
        imageView.translatesAutoresizingMaskIntoConstraints = false;

        // add a label with word wrap
        let label = UILabel();
        label.text = "Welcome to my simple app!";
        label.numberOfLines = 0;
        label.textAlignment = .center;
        label.font =   UIFont(name: "Arial-BoldMT", size: 30)
        label.textColor = .label;
        label.translatesAutoresizingMaskIntoConstraints = false;


        // add the image and label to the stac
        stack.addArrangedSubview(imageView);
        stack.addArrangedSubview(label);
        
        // add the stack to the view
        view.addSubview(stack);

        // stack.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height);
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 5),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),

            // Set Image View width and height to be half the width of the stack
            imageView.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.5),
            imageView.heightAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.5),

            label.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.5),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            //label.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 1)
        ])
        
    };
    
    @objc private func didTapMenuButton() {
        // call the delgate and attempt to execute the method to present the menu
        delegate?.didTapMenuButton();
    };

};
