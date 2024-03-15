//
//  NSManagedObjectContext+Ext.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 19.02.2024.
//

import CoreData
import Foundation

extension NSManagedObjectContext {
    func safeSave () {
        if self.hasChanges {
            do {
                try self.save()
            } catch {
                let error = error as NSError
                assertionFailure("Tried to save context, but -> \(error), with info -> \(error.userInfo)")
                self.rollback()
            }
        }
    }
}
