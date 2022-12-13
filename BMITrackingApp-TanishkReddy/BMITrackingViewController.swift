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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addTapped))
        tableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Task.init { await getHistory() }
        
    }
    
    @objc func addTapped() {
        let addView = HistoryEditView(frame: self.view.frame)
        addView.action = { [weak self] (weight) in
            self?.addNewWeight(weight: weight)
        }
        self.view.addSubview(addView)
    }
    
    // add new weight and bmi to database
    func addNewWeight(weight: Double) {
        Task.init {
            let personalInfo = try? await PersonRespository.shared.getPerson()
            _ = await HistoryRepository.shared.addBMI(bmi: getBMI(weight: weight, height: personalInfo?.height ?? 0.0), height: personalInfo?.height ?? 0.0, weight: weight, date: Date())
            await getHistory()
        }
    }
    
    func getBMI(weight: Double, height: Double) -> Double {
        return (weight/(height*height))
    }
    
    //get BMI tracking history from database
    func getHistory() async {
        
            let his = try? await HistoryRepository.shared.getAllHistory()
            self.history = his ?? []
            self.tableView.reloadData()
       
    }
    

}

extension BMITrackingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
        cell.history = self.history[indexPath.row]
        return cell
    }
    
    // left swipe action
    func tableView(_ tableView: UITableView,
                       trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let longSwipeToDelete = UIContextualAction(style: .destructive,
                                       title: "Delete") { [weak self] (action, view, completionHandler) in
            print("Delete")
            self?.deleteBMI(row: indexPath.row)
            
        }
        longSwipeToDelete.backgroundColor = .red
        
        let swipeToEdit = UIContextualAction(style: .destructive,
                                       title: "Edit") { [weak self] (action, view, completionHandler) in
            print("Edit")
            self?.editBMI(row: indexPath.row)
            
        }
        longSwipeToDelete.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [longSwipeToDelete,swipeToEdit])
    }
    
    func editBMI(row: Int) {
        let bmi = self.history[row]
        let addView = HistoryEditView(frame: self.view.frame)
        addView.action = { [weak self] (weight) in
            Task.init {
                _ = await HistoryRepository.shared.updateBMI(history: bmi, weight: weight, bmi: self?.getBMI(weight: weight, height: bmi.height) ?? 0.0)
                await self?.getHistory()
            }
        }
        self.view.addSubview(addView)
    }
    
    func deleteBMI(row: Int) {
        Task.init {
            let bmi = self.history[row]
                let _ = try await HistoryRepository.shared.deleteBMI(object: bmi)
            await getHistory()
            if self.history.count == 0 {
                tabBarController?.selectedIndex = 0
            }
            
        }
    }
    
}
