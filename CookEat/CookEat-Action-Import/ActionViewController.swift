//
//  ActionViewController.swift
//  CookEat-Action-Import
//
//  Created by David Bonnet on 28/02/2018.
//  Copyright © 2018 Harpp. All rights reserved.
//

import UIKit
import MobileCoreServices
import CookEatCore

class ActionViewController: UIViewController {

  @IBOutlet weak var infoLabel: UILabel!

  private var foundUrl: URL?

  override func viewDidLoad() {
    super.viewDidLoad()
    Config.setup()

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
            OperationQueue.main.addOperation {
              weakLabel?.text = "Nous n'avons rien trouvé 😢"
            }
            return
          }

          var result = ""
          do {
            try RecipeWorker.add(from: url)
            result = "\(url.absoluteString)\n\n à bien été ajouté à votre collection 🥘"
          } catch {
            result = """
                     Êtes-vous sûr qu'il s'agit d'un lien contenant une recette ?

                     (\(error))
                     """
          }

          self.foundUrl = url
          OperationQueue.main.addOperation {
            weakLabel?.text = result
          }
        })
      }
    }

    if foundUrl == nil {
      self.infoLabel.text = "Récupération de votre recette en cours..."
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
