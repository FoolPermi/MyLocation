//
//  Functions.swift
//  MyLocations
//
//  Created by Permi on 2018/4/16.
//  Copyright © 2018 Razeware. All rights reserved.
//

import Foundation

let CoreDataSaveFailedNotification =
  Notification.Name(rawValue: "CoreDataSaveFailedNotification")

func afterDelay(_ seconds: TimeInterval, run: @escaping () -> Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: run)
}
func fatalCoreDataError(_ error: Error) {
  print("*** Fatal error: \(error)")
  NotificationCenter.default.post(name: CoreDataSaveFailedNotification, object: nil)
}
