//
//  BootViewController.swift
//  CookEat
//
//  Copyright © 2018 Harpp. All rights reserved.
//

import UIKit

class BootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let id = segue.identifier, StoryboardSegue.Main.embedListing.rawValue == id else {
            return
        }

        let splitVC = segue.destination as? UISplitViewController
        splitVC?.delegate = self
    }
}

extension BootViewController: UISplitViewControllerDelegate {

    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {

        guard let secondaryAsNavController = secondaryViewController as? UINavigationController,
              let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else {
            return false
        }

        if topAsDetailController.detailItem == nil {
            // Return true to indicate that we have handled the collapse by doing nothing;
            // the secondary controller will be discarded.
            return true
        }

        return false
    }
}
