//
//  MapJSON.swift
//  TileMap
//
//  Created by Matheus Silva on 14/10/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import Foundation

struct Map: Codable {
    var map: [[Int]]
    
    func getColumns() -> Int {
        return self.map.count 
    }
    
    func getRows() -> Int {
        return self.map[0].count
    }
    
    /// Essa funcao serve para igualar a visao do json com o resultado final, roda em O(n**2).
    /// Para isso a matriz tem que ser quadrada.
    mutating func rotate90Degrees() {
        for layer in 0 ..< (getRows())/2 {
            let first = layer
            let last = (getRows()) - 1 - layer

            for i in first..<last {
                let offset = i - first
                let top = map[first][i]

                // top is now left
                self.map[first][i] = map[last - offset][first]
                // left is now bottom
                self.map[last - offset][first] = map[last][last - offset]
                // bottom is now right
                self.map[last][last - offset] = map[i][last]
                // right is now top
                self.map[i][last] = top
            }
        }
    }
}

