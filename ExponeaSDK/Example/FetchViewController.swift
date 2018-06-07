//
//  FetchViewController.swift
//  Example
//
//  Created by Dominik Hadl on 25/05/2018.
//  Copyright © 2018 Exponea. All rights reserved.
//

import UIKit
import ExponeaSDK

class FetchViewController: UIViewController {

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func fetchPersonalisation(_ sender: Any) {
        let req = EventsRequest(eventTypes: ["my_custom_event_type"])
        Exponea.shared.fetchEvents(with: req) { (result) in
                switch result {
                case .success(let recom):
                    AppDelegate.memoryLogger.logMessage("\(recom)")
                case .failure(let error):
                    AppDelegate.memoryLogger.logMessage(error.localizedDescription)
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
        }
    }

    @IBAction func fetchRecommendation(_ sender: Any) {
        let recomm = RecommendationRequest(type: "", id: "")
        Exponea.shared.fetchRecommendation(with: recomm) { (result) in
            switch result {
            case .success(let recom):
                AppDelegate.memoryLogger.logMessage("\(recom)")
                self.showAlert(title: "Fetch Recommendation", message: """
                    Success: \(recom.success ?? false)
                    Content: \(recom.results ?? [])
                    """)
            case .failure(let error):
                AppDelegate.memoryLogger.logMessage(error.localizedDescription)
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }

    @IBAction func fetchEvents(_ sender: Any) {
        let req = EventsRequest(eventTypes: ["my_custom_event_type"])
        Exponea.shared.fetchEvents(with: req) { (result) in
            switch result {
            case .success(let events):
                AppDelegate.memoryLogger.logMessage("\(events)")
                self.showAlert(title: "Fetch Events", message: """
                    Success: \(events.success)
                    Content: \(events.data)
                    """)
            case .failure(let error):
                AppDelegate.memoryLogger.logMessage(error.localizedDescription)
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    @IBAction func fetchAttributes(_ sender: Any) {
        let req = AttributesDescription(key: "a", value: "b", identificationKey: "", identificationValue: "")
        Exponea.shared.fetchAttributes(with: req) { (result) in
            switch result {
            case .success(let recom):
                AppDelegate.memoryLogger.logMessage("\(recom)")
                self.showAlert(title: "Fetch Attributes", message: """
                    Type: \(recom.type)
                    List: \(recom.list)
                    """)
            case .failure(let error):
                AppDelegate.memoryLogger.logMessage(error.localizedDescription)
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}
