//
//  BMITrackingViewController.swift
//  BMITrackingApp-TanishkReddy
//
//  Created by Tanishk Sai Reddy Peruvala-301293616 on 2022-12-12.
//

import UIKit

class BMITrackingViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var history: [History] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Task.init {
            let his = try? await HistoryRepository.shared.getAllHistory()
            self.history = his ?? []
            self.tableView.reloadData()
        }
        
    }
    

}

extension BMITrackingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    
}
