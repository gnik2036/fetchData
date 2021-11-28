//
//  ViewController.swift
//  testTask
//
//  Created by Mohammed Hassan on 28/11/2021.
//
import Foundation

// MARK: - HomeModelVC
struct HomeModelVC: Codable {
    let success: Bool?
    let data: [SectionData]?
    let message: String?
}

// MARK: - Datum
struct SectionData: Codable {
    let id: Int?
    let title: String?
    let states: [State]?
}

// MARK: - State
struct State: Codable {
    let id: Int?
    let title: String?
    let cityID: Int?

    enum CodingKeys: String, CodingKey {
        case id, title
        case cityID = "city_id"
    }
}
