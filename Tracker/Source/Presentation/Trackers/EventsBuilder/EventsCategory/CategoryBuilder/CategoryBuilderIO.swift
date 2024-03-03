//
//  CategoryBuilderIO.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 06.02.2024.
//

import Foundation

protocol ICategoryBuilderInput {
    func setExistedCategories(_ categories: [String])
}

protocol ICategoryBuilderOutput: AnyObject {
    func didBuildNewCategory(_ category: String)
}
