//
//  BootViewController.swift
//  DemoTableView
//
//  Copyright © 2018 Harpp. All rights reserved.
//

import UIKit

class BootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let segueId = segue.identifier, StoryboardSegue.Main.embedListing.rawValue == segueId else {
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

        guard let secondaryAsNavVC = secondaryViewController as? UINavigationController,
              let topAsDetailController = secondaryAsNavVC.topViewController as? TaskDetailViewController else {
            return false
        }

        if topAsDetailController.task == nil {
            // Return true to indicate that we have handled the collapse by doing nothing;
            // the secondary controller will be discarded.
            return true
        }

        return false
    }
}
