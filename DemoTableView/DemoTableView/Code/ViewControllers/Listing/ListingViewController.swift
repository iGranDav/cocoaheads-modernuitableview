//
//  ListingViewController.swift
//  DemoTableView
//
//  Copyright © 2018 Harpp. All rights reserved.
//

import UIKit
import RealmSwift
import Extra
import SwiftDate
import DemoTableViewCore

class ListingViewController: UITableViewController {

  // MARK: - Members

  // MARK: - Setup

  override func viewDidLoad() {
    super.viewDidLoad()
    title = L10n.listingTitle
    navigationItem.largeTitleDisplayMode = .always
    navigationItem.leftBarButtonItem = editButtonItem

    refreshControl = UIRefreshControl()
    refreshControl?.addTarget(self, action: #selector(reloadData), for: .allEvents)

    tableView.register(cellType: TaskCell.self)

  }

  override func viewWillAppear(_ animated: Bool) {
    clearsSelectionOnViewWillAppear = splitViewController?.isCollapsed ?? true
    super.viewWillAppear(animated)
  }

  // MARK: - Actions

  @objc
  private func reloadData() {

    if refreshControl?.isRefreshing == false {
      refreshControl?.beginRefreshing()
    }

    //Do stuff

    refreshControl?.endRefreshing()
  }

}

// MARK: - UITableViewDataSource
extension ListingViewController {

}

// MARK: - UITableViewDelegate
extension ListingViewController {

}
