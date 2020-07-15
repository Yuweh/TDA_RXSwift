//
//  AddTaskViewController.swift
//  TodoApp RxSwift
//
//  Created by Francis Yuweh on 7/15/20.
//  Copyright © 2020 Francis B. All rights reserved.
//

import UIKit
import RxSwift

final class AddTaskViewController: UIViewController, UITextViewDelegate  {
    
    private let taskSubject = PublishSubject<Task>()
    var taskSubjectObservable: Observable<Task> {
        return taskSubject.asObservable()
    }
    
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var taskTitleTextField: UITextView!
    @IBOutlet weak var createGoalBtnLbl: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGoalBtnLbl.bindToKeyboard()
        taskTitleTextField.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.taskTitleTextField.text = ""
        self.taskTitleTextField.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    @IBAction func save() {
        guard let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex),
            let title = self.taskTitleTextField.text else {
            return
        }
        
        let task = Task(title: title, priority: priority)
        taskSubject.onNext(task)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
