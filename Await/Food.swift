//
//  Food.swift
//  Await
//
//  Created by Julio-Ernest Costache on 11.08.2022.
//

import Foundation

struct Food: Codable {
    var id: Int
    var uid: String
    var dish: String
    var description: String
    var ingredient: String
    var measurement: String
}
