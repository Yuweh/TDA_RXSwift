//
//  TaskListViewController.swift
//  TodoApp RxSwift
//
//  Created by Francis Yuweh on 7/15/20.
//  Copyright © 2020 Francis B. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    private let disposebag = DisposeBag()
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var filteredTask = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func priorityValueChanged(_ sender: UISegmentedControl) {
        let priority = Priority(rawValue: sender.selectedSegmentIndex - 1)
        filterTasks(by: priority)
    }
    
    private func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListViewCell", for: indexPath)
        cell.textLabel?.text = self.filteredTask[indexPath.row].title
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
            let addTVC = navC.viewControllers.first as? AddTaskViewController else {
                fatalError("error controller not found")
        }
        
        addTVC.taskSubjectObservable
            .subscribe(onNext: { [unowned self] task in
                let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex - 1)
                
                var existingTasks = self.tasks.value
                existingTasks.append(task)
                self.tasks.accept(existingTasks)
                
                self.filterTasks(by: priority)
                
            }).disposed(by: disposebag)
    }
    
    private func filterTasks(by priority: Priority?) {
        if priority == nil {
            self.filteredTask = self.tasks.value
            self.updateTableView()
        } else {
            self.tasks.map { tasks in
                return tasks.filter { $0.priority == priority }
            }.subscribe(onNext: { [weak self] tasks in
                self?.filteredTask = tasks
                self?.updateTableView()
            })
            .disposed(by: disposebag)
        }
    }
}
