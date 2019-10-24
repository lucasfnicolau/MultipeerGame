//
//  MapHandler.swift
//  TileMap
//
//  Created by Matheus Silva on 14/10/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import Foundation

class MapHandler {
    static func loadMapFromJSON() -> Map? {
        if let url = Bundle.main.url(forResource: "map", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                var jsonData = try decoder.decode(Map.self, from: data)
                jsonData.rotate90Degrees() //REMAKE
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}


