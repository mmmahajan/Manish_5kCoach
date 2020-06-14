//
//  ViewController.swift
//  InterviewTask
//
//  Created by Manish Mahajan  on 11/06/20.
//  Copyright © 2020 Manish Mahajan. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var timer: Timer?
    var coach :  Coach?
    var safeArea: UILayoutGuide!
    
    private let StartButton : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Start Race", for: UIControl.State.normal)
        btn.backgroundColor = UIColor.FlatColor.PrimaryColor
        btn.imageView?.contentMode = .scaleAspectFill
        return btn
    }()
    
    private let StopButton : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Finish Race", for: UIControl.State.normal)
        btn.backgroundColor = UIColor.FlatColor.RedColor
        btn.imageView?.contentMode = .scaleAspectFill
        return btn
    }()
    
    private let clockView : ClockView = {
        let view = ClockView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        return view
    }()
    
    var timeLabel : UILabel =  {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        label.text = "00:00:00"
        label.textColor = UIColor.FlatColor.SecondaryColor
        return label
        
    }()
    
    var coachLable : UILabel =  {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        label.text = ""
        label.textColor = UIColor.FlatColor.SecondaryColor
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.FlatColor.LightPrimaryColor
        navigationController?.navigationBar.isTranslucent = false
        
        let addButton = UIBarButtonItem(title: "Add Coach", style: .plain,  target: self,
                                         action: #selector(addButtonTapped))
        let listButton = UIBarButtonItem(title: "Records", style: .plain,  target: self,
                                         action: #selector(navigateToDetailScreen))
        addButton.tintColor = UIColor.FlatColor.SecondaryColor
        listButton.tintColor = UIColor.FlatColor.SecondaryColor
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = listButton
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.FlatColor.SecondaryColor
        safeArea = view.layoutMarginsGuide
        setUpView()
    }
    
    func setUpView() {
        let stackView = UIStackView(arrangedSubviews: [StartButton,StopButton])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 0
        self.view.addSubview(stackView)
        self.view.addSubview(clockView)
        self.view.addSubview(timeLabel)
        self.view.addSubview(coachLable)
        stackView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 75, enableInsets: false)
        clockView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 300, height: 300, enableInsets: false)
        
        timeLabel.anchor(top: nil, left: nil, bottom: clockView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 16, paddingRight: 0, width: 300, height: 30, enableInsets: false)
        
        timeLabel.centerXAnchor.constraint(equalTo: clockView.centerXAnchor).isActive = true
        
        coachLable.anchor(top: nil, left: self.view.leftAnchor, bottom: clockView.topAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 60, paddingRight: 0, width: 300, height: 30, enableInsets: false)
        
        coachLable.centerXAnchor.constraint(equalTo: clockView.centerXAnchor).isActive = true
        
        clockView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        clockView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
                
        StartButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        StopButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        
        self.view.backgroundColor = .white
    }
    
    
    @objc func updateTimer() {
        if coach?.completed ?? false  {
            print("timerStopped")
            return
        }
        let time = Date().timeIntervalSince(coach!.creationDate)
        
        print("timeInterval",time)
        let msec = time.truncatingRemainder(dividingBy: 1)
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        var times: [String] = []
        if hours > 0 {
            times.append("\(hours)h")
        }
        if minutes > 0 {
            times.append("\(minutes)m")
        }
        times.append("\(seconds)s")
        
        times.append("\(Int(msec*100))ms")
        
        let timeTaken = times.joined(separator: " : ")
        timeLabel.text = timeTaken
        coach?.timetaken = timeTaken
        coach?.timeInterval = time
    }
    
    //Start button action
    @objc func startButtonTapped(_ sender: UIButton) {
        if timeLabel.text == "00:00:00" {
            if let coach = coach  {
                if !coach.completed {
                    createTimer()
                    clockView.animating  = true
                } else {
                    showAlert(title: "Add Coach", message: "Please add a new coach")
                }
            } else {
                cancelTimer()
                clockView.animating  = false
                showAlert(title: "Add Coach", message: "Please add a new coach")
            }
        }
    }
    
    //Stop button action
    @objc func stopButtonTapped(_ sender: UIButton) {
        
        if clockView.animating {
            coach?.completed = true
            cancelTimer()
            clockView.animating  = false
            if let coach = coach {
                save(coach: coach)
            }
        } else {
            showAlert(title: "Start Race", message: "Please start race")
        }
    }
    
    //Save data to core data models
    func save(coach : Coach) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CoachEntity", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(coach.name, forKeyPath: "name")
        person.setValue(coach.creationDate.toString(), forKeyPath: "created_at")
        person.setValue(coach.timetaken, forKeyPath: "timeTaken")
        person.setValue(coach.timeInterval, forKeyPath: "timeInterval")
        person.setValue(coach.id, forKeyPath: "id")
        do {
            try managedContext.save()
            showAlert(title: "Record Added", message: "Your record has been added in list")
            timeLabel.text = "00:00:00"
            coachLable.text = ""
            self.coach = nil
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    @objc func addButtonTapped() {
        presentAlertController()
    }
    
    @objc func navigateToDetailScreen() {
        let vc = RecordsViewController()
        vc.coach = coach
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func createTimer() {
        if timer == nil {
            let timer = Timer(timeInterval: 0.01,
                              target: self,
                              selector: #selector(updateTimer),
                              userInfo: nil,
                              repeats: true)
            RunLoop.current.add(timer, forMode: .common)
            timer.tolerance = 0.1
            
            self.timer = timer
        }
    }
    
    func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }
}

extension ViewController {
    
    //Alert controller for coach name
    func presentAlertController() {
        
        let alertController = UIAlertController(title: "Your Name",
                                                message: nil,
                                                preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Your name "
            textField.autocapitalizationType = .sentences
        }
        let createAction = UIAlertAction(title: "OK", style: .default) {
            [weak self, weak alertController] _ in
            guard
                let self = self,
                let text = alertController?.textFields?.first?.text
                else {
                    return
            }
            
            DispatchQueue.main.async {
                self.coach = Coach(name: text, id: UUID())
                self.coachLable.text = text
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
