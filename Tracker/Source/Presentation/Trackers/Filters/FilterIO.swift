//
//  FilterIO.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 11.03.2024.
//

import Foundation

protocol IFilterInput {
    func setSelectedFilter(filter: FilterType)
}

protocol IFilterOutput: AnyObject {
    func filterSelected(_ filter: FilterType)
}
