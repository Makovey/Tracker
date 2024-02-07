//
//  CategorySelectorIO.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 06.02.2024.
//

import Foundation

protocol ICategorySelectorInput {
    func setSelectedCategory(category: String?)
    func setAllCategories(categories: [String])
}

protocol ICategorySelectorOutput: AnyObject {
    func categorySelected(_ category: String)
}
