//
//  Debouncer.swift
//  letsgo-swiftui
//
//  Created by Elisey Ozerov on 20. 5. 24.
//

import Foundation

class Debouncer {
    private var lastCallTime: DispatchTime = .now()
    private var delay: TimeInterval
    private var workItem: DispatchWorkItem?

    init(delay: TimeInterval) {
        self.delay = delay
    }

    func call(_ action: @escaping () -> Void) {
        // Cancel the previous call if it has not been executed yet
        workItem?.cancel()

        // Create a new work item that performs the desired action
        workItem = DispatchWorkItem(block: action)

        // Schedule the new work item to execute after the delay
        let deadline = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: deadline, execute: workItem!)
    }
}
