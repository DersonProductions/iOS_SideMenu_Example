//
//  ViewController.swift
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
//  1. The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  2. The name "Derson Productions" and any associated trademarks or other identifiers
//  may not be used to endorse or promote products derived from this Software without
//  specific prior written permission from Derson Productions, LLC.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit
import StoreKit
import MessageUI
import SwiftUI
import WebKit

class ContainerViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    // Create enumerations for the state of the menu so automation knows
    // what action it needs to perform.
    enum MenuState {
        case opened;
        case closed;
    };
    
    // Define Menu as closed
    private var menuState: MenuState = .closed;
    
    let menuVC = MenuViewController();
    let homeVC = HomeViewController();
    let settingsVC = SettingsViewController();
    var navVC: UINavigationController?;
    // lazy so it isn't created when app is opened
    lazy var infoVC = InfoViewController();
    var websiteVC: UIViewController? = nil; //();

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .red;
        self.addChildViewControllers();
    }

    private func addChildViewControllers() {
        // Menu - 0 z-axis index
        self.menuVC.delegate = self; // assign the MenuVC delegate to be the ContainerViewController
        addChild(self.menuVC);
        view.addSubview(self.menuVC.view);
        self.menuVC.didMove(toParent: self);
        
        // Home
        self.homeVC.delegate = self;
        addTapGesture(viewToModify: self.homeVC.view, selector: #selector(closeMenu));

        // Settings
        self.settingsVC.delegate = self;
        

        // NavigationController is going to wrap the other views
        let navVC = UINavigationController(rootViewController: self.homeVC);
        addChild(navVC);
        view.addSubview(navVC.view);
        navVC.didMove(toParent: self);
        self.navVC = navVC;
    }

    private func addTapGesture( viewToModify: UIView, selector: Selector? = nil) {
        let tap = UITapGestureRecognizer(target: self, action: selector);
        tap.numberOfTapsRequired = 1;
        viewToModify.addGestureRecognizer(tap);
    }
}

// Making ContainerViewController a delegate for the home view controller via an extension
// extension for controller
extension ContainerViewController: HomeViewControllerDelegate {
    func didTapMenuButton() {
        self.toggleMenu(completion: nil);
    }
    @objc func closeMenu() {
        if menuState == .opened {
            self.toggleMenu(completion: nil);
        }
    }
    // Completion method for be called by
    func toggleMenu(completion: (() -> Void)?) {
        // Animate the menu
        switch menuState {
        case .closed:
            // open it
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options:
                    .curveEaseInOut) {
                        self.navVC?.view.frame.origin.x = self.homeVC.view.frame.size.width * 0.6;
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .opened;
                }
            }
        case .opened:
            // close it
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options:
                    .curveEaseInOut) {
                        self.navVC?.view.frame.origin.x = 0; // set x back to
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .closed;
                    // optional closures are already escaping
                    DispatchQueue.main.async { completion?(); };
                    // want to call completion once menu is closed;
                }
            }
        }
    }
}

// Making a extension delegate for the Menu View Controller to respond to events that occur within it
extension ContainerViewController: MenuViewControllerDelegate {
    func didSelect(menuItem: MenuViewController.MenuOptions) {
//        // The switch statement can go in side the completion block, but automation will not present the clicked
//        // menu until after the animation is complete.
//        toggleMenu { [weak self] in
//            switch menuItem {
//            case .home:
//                self?.resetToHome();
//            case .info:
//                self?.addInfo();
//            case .appRating:
//                break;
//            case .shareApp:
//                break;
//            case .settings:
//                break;
//            }
//        }
        toggleMenu(completion: nil);
        // moving switch inline with ToggleMenu will make it run
        // at same time as update of UI.
        switch menuItem {
        case .home:
            self.resetToHome();
        case .info:
            self.addInfo();
        case .appRating:
            self.requestAppReview();
        case .shareApp:
            self.shareApp();
        case .settings:
            self.addSettings();
        case .website:
            self.openWebsite();
        }
    }
    // Reset the Home View Controller to the default view when the Home menu item is selected.
    func resetToHome() {
        // remove infoVC if it exists
        infoVC.willMove(toParent: nil);
        infoVC.view.removeFromSuperview();
        infoVC.removeFromParent();
        // remove settingsVC if it exists
        settingsVC.willMove(toParent: nil);
        settingsVC.view.removeFromSuperview();
        settingsVC.removeFromParent();
        // remove websiteVC if it exists
        if let websiteVC = self.websiteVC {
            if websiteVC.isViewLoaded {
                websiteVC.dismiss(animated: true, completion: nil);
            }
            websiteVC.willMove(toParent: nil);
            websiteVC.view.removeFromSuperview();
            websiteVC.removeFromParent()
            self.websiteVC = nil // Clear the reference
        }
        
        homeVC.title = "Home";
    }
    
    // Add the Info View Controller to the Home View Controller when the Info menu item is selected.
    func addInfo() {
        let vc = infoVC;
        homeVC.addChild(vc);
        homeVC.view.addSubview(vc.view);
        vc.view.frame = view.frame;
        vc.didMove(toParent: homeVC);
        homeVC.title = vc.title;
    }

    // Add the Settings View Controller to the Home View Controller when the Settings menu item is selected.
    func addSettings() {
        let vc = self.settingsVC;
        homeVC.addChild(vc);
        homeVC.view.addSubview(vc.view);
        vc.view.frame = view.frame;
        vc.didMove(toParent: homeVC);
        homeVC.title = vc.title;
    }

    // Open the App Store when the App Rating menu item is selected.
    func requestAppReview() {
        if #available(iOS 16.0, *) {
            // implement a RequestReviewAction
            // Use SwiftUI's environment value to get an instance of RequestReviewAction
            let hostingController = UIHostingController(rootView: ReviewRequestView())
            self.present(hostingController, animated: true, completion: nil)
        } else if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            // Fallback for earlier iOS versions
            openAppStoreForReview()
        }
    }

    func openAppStoreForReview() {
        // add your app's app store URL here: 
        // Example: "https://apps.apple.com/us/app/itunes-store/id1234567890?action=write-review"
        let appStoreURL: URL = URL(string: "https://apps.apple.com")!
        if UIApplication.shared.canOpenURL(appStoreURL) {
            UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
        }
    }

    // Function to bring up the share menu
    func shareApp() {
        // The link to be shared
        let link: String = "https://apps.apple.com/us/app/itunes-store/id1234567890"
        
        // Create an array with the link
        let items: [String] = [link]
        
        // Initialize the UIActivityViewController with the items
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        // Exclude some activity types if needed
        activityViewController.excludedActivityTypes = [
            .addToReadingList,
            .assignToContact,
            .saveToCameraRoll,
            .markupAsPDF,
            .openInIBooks,
            .print      
        ]

        // For iPad, set the popover presentation controller's source view to the view and source rect
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            popoverPresentationController.sourceView = view
            popoverPresentationController.sourceRect = CGRect(x: view.frame.midX, y: view.frame.midY, width: 0, height: 0)
            popoverPresentationController.permittedArrowDirections = []
        }
        
        // Present the activity view controller
        present(activityViewController, animated: true, completion: nil)
    }

    /*
    // Open Messenger app to send text message with app link
    // func shareAppViaMessage() {
    //     if MFMessageComposeViewController.canSendText() {
    //         let link: String = "https://apps.apple.com/us/app/itunes-store/id1234567890";
    //         let appName: String = "iTunes Store"
    //         let messageVC = MFMessageComposeViewController()
    //         messageVC.body = "Check out this awesome app: [\(appName)]! \(link)"
    //         messageVC.messageComposeDelegate = self      
    //         self.present(messageVC, animated: true, completion: nil)
    //     } else {
    //         // Create a UI Alert to inform the user that SMS services are not available
    //         let alert = UIAlertController(title: "SMS services are not available", message: "Please check your device settings to ensure SMS services are enabled.", preferredStyle: .alert)
    //         alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    //         self.present(alert, animated: true, completion: nil)
    //         // Log the error
    //         print("SMS services are not available")
    //     }
    // }
    */

    // MFMessageComposeViewControllerDelegate method
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }

    // Open the website when the Website menu item is selected.
    // open it in app
    private func openWebsite() {
        let url: URL = URL(string: "https://www.dersonproductions.us")!
        let request: URLRequest = URLRequest(url: url)
        let webView: WKWebView = WKWebView()
        webView.load(request)
        // let vc = UIViewController()
        self.websiteVC = UIViewController();
        if let websiteVC = self.websiteVC {
            websiteVC.view = webView
            websiteVC.title = "Website"
            homeVC.view.addSubview(websiteVC.view);
            websiteVC.view.frame = view.frame;
            websiteVC.didMove(toParent: homeVC);
            homeVC.title = websiteVC.title;
        }
    }
}

// SwiftUI view to handle the review request for iOS 16.0 and later
struct ReviewRequestView: View {
    @Environment(\.requestReview) private var requestReview

    var body: some View {
        VStack {
            Text("Requesting Review...")
                .onAppear {
                    requestReview()
                }
        }
    }
}

// Making a extension delegate for the Settings View Controller to respond to events that occur within it
extension ContainerViewController: SettingsViewControllerDelegate {
    func didSelect(settingMenuItem: SettingsViewController.SettingOptions) {
        switch settingMenuItem {
        case .profile:
            self.didTapProfile();
        case .notifications:
            self.didTapNotifications();
        case .privacy:
            self.didTapPrivacy();
        case .logout:
            self.didTapSignOut();
        }
    }

    private func didTapProfile() {
        // Alert user that the profile is not available
        let alert = UIAlertController(title: "Profile",
                                      message: "Profile is not available at this time",
                                      preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil));
        present(alert, animated: true);
    }

    private func didTapNotifications() {
        // Alert user that notifications are not available
        let alert = UIAlertController(title: "Notifications",
                                      message: "Notifications are not available at this time",
                                      preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil));
        present(alert, animated: true);
    }

    private func didTapPrivacy() {
        // Alert user that privacy information is not available
        let alert = UIAlertController(title: "Privacy",
                                      message: "Privacy information is not available at this time",
                                      preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil));
        present(alert, animated: true);
    }

    func didTapSignOut() {
        let alert = UIAlertController(title: "Sign Out",
                                      message: "Are you sure you want to sign out?",
                                      preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil));
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { [weak self] _ in
            // Sign out the user
            self?.signOut();
        }));
        present(alert, animated: true);
    }

    private func signOut() {
        // Sign out the user from whatever they're authenticated with
        // ...
        // Alert user that they've been signed out
        let alert = UIAlertController(title: "Signed Out",
                                      message: "You have been signed out",
                                      preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil));
        present(alert, animated: true);
    }

}
