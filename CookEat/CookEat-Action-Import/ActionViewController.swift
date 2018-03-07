//
//  ActionViewController.swift
//  CookEat-Action-Import
//
//  Created by David Bonnet on 28/02/2018.
//  Copyright © 2018 Harpp. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

  @IBOutlet weak var infoLabel: UILabel!

  private var foundUrl: URL?

  override func viewDidLoad() {
    super.viewDidLoad()

    guard let context = self.extensionContext, let items = context.inputItems as? [NSExtensionItem] else {
      return
    }

    items.forEach { item in

      guard let providers = item.attachments as? [NSItemProvider] else { return }

      providers.forEach { provider in
        let typeId = kUTTypeURL as String
        guard provider.hasItemConformingToTypeIdentifier(typeId) else { return }

        weak var weakLabel = self.infoLabel
        provider.loadItem(forTypeIdentifier: typeId, options: nil, completionHandler: { (url, _) in
          guard let url = url as? URL else {
            return
          }

          self.foundUrl = url
          OperationQueue.main.addOperation {
            weakLabel?.text = "\(url.absoluteString)\n\n à bien été ajouté à votre collection 🥘"
          }
        })
      }
    }

    if foundUrl == nil {
      self.infoLabel.text = "Nous n'avons rien trouvé 😢"
    }
  }

  @IBAction func done() {
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.
    guard let context = self.extensionContext, let items = context.inputItems as? [NSExtensionItem] else {
      return
    }

    context.completeRequest(returningItems: items, completionHandler: nil)
  }

}

extension ActionViewController: UIBarPositioning {

  var barPosition: UIBarPosition {
    return .topAttached
  }

}
