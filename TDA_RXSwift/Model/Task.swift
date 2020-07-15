//
//  Task.swift
//  TodoApp RxSwift
//
//  Created by Francis Yuweh on 7/15/20.
//  Copyright © 2020 Francis B. All rights reserved.
//

import Foundation

enum Priority: Int {
    case high
    case medium
    case low
}

struct Task {
    let title: String
    let priority: Priority
}
