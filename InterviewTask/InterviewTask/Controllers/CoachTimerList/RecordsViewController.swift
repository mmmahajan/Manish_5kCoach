//
//  CoachTimerListViewController.swift
//  InterviewTask
//
//  Created by Manish Mahajan  on 13/06/20.
//  Copyright © 2020 Manish Mahajan. All rights reserved.
//

import UIKit
import CoreData

class RecordsViewController: UIViewController {
    
    let tableView = UITableView()
    var safeArea: UILayoutGuide!
    var coachList: [Coach] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var coach : Coach?
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title = "Records"
        tableView.register(RecordTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoachEntity")
        do {
            if let model = try managedContext.fetch(fetchRequest) as? [CoachEntity] {
                coachList = model.compactMap({
                    let coach =  Coach(name: $0.name ?? "", id: $0.id ?? UUID())
                    coach.timeInterval = $0.timeInterval
                    coach.timetaken = $0.timeTaken ?? ""
                    return coach
                }).sorted(by: { $0.timeInterval < $1.timeInterval })
                
                if coachList.count == 0 {
                    self.showAlert(title: "No Records", message: "No records added yet")
                    return
                }
                for (index, item) in coachList.enumerated(){
                    item.rank = index+1
                }
                
                if  let myRank = coachList.firstIndex(where: {$0.id == coach?.id }) {
                    self.showAlert(title: "Rank!!", message: "Your rank is \(myRank+1)")
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        setupTableView()
    }
    
    //Table view setup
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}

//UITableViewDataSource methods
extension RecordsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RecordTableViewCell
        let currentItem = coachList[indexPath.row]
        cell.coach = currentItem
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coachList.count
    }
}
