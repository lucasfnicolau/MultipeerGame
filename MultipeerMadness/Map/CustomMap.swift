//
//  CustomMap.swift
//  TileMap
//
//  Created by Matheus Silva on 16/10/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import Foundation
import SpriteKit

enum MapCase: Int {
    case grass = 0
    case sand
    case water
}

class CustomMap: SKNode {
    
    private(set) var tileSet  = SKTileSet()
    private(set) var tileSize = CGSize()
    private(set) var columns  = Int()
    private(set) var rows     = Int()
    
    override init() {
        super.init()
    }
    
    convenience init(namedTile: String, tileSize: CGSize) {
        self.init()
        
        guard let tileToSet = SKTileSet(named: namedTile) else { return }
        self.tileSet  = tileToSet
        self.tileSize = tileSize
        
        setupMap()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupMap() {
        
        guard let mapJSON = MapHandler.loadMapFromJSON() else { return }
        self.columns      = mapJSON.getColumns()
        self.rows         = mapJSON.getRows()
        
        // Componentes
        let grass = tileSet.tileGroups.first { $0.name == "Grass" }
        let sand  = tileSet.tileGroups.first { $0.name == "Sand" }
        let water = tileSet.tileGroups.first { $0.name == "Water" }
        
        setBottonLayer(bottonLayer: sand)
        
        let layer = SKTileMapNode(tileSet: tileSet,
                                  columns: columns,
                                  rows: rows,
                                  tileSize: tileSize)
        self.addChild(layer)
        
        for column in 0 ..< columns {
            for row in 0 ..< rows {
                switch mapJSON.map[column][row] {
                case MapCase.grass.rawValue:
                    layer.setTileGroup(grass, forColumn: column, row: row)
                case MapCase.sand.rawValue:
                    layer.setTileGroup(sand, forColumn: column, row: row)
                default:
                    layer.setTileGroup(water, forColumn: column, row: row)
                    
                }
                
            }
        }
        
        self.giveTileMapPhysicsBody(in: layer)
    }
    
    public func setBottonLayer(bottonLayer: SKTileGroup?) {
        let bottomLayer = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        bottomLayer.fill(with: bottonLayer)
        self.addChild(bottomLayer)
    }
    
    public func giveTileMapPhysicsBody(in tileMap: SKTileMapNode) {
        
        let halfWidth  = CGFloat(tileMap.numberOfColumns) / 2.0 * tileSize.width
        let halfHeight = CGFloat(tileMap.numberOfRows)    / 2.0 * tileSize.height
        
        for column in 0..<tileMap.numberOfColumns {
            for row in 0..<tileMap.numberOfRows {
                
                if let tileDefinition = tileMap.tileDefinition(atColumn: column, row: row)
                    
                {
                    let isWaterTile = tileDefinition.userData?["AddBody"] as? Int
                    if (isWaterTile == 1) {
                        let tileArray = tileDefinition.textures
                        let tileTexture = tileArray[0]
                        
                        let x = CGFloat(column) * tileSize.width - halfWidth + (tileSize.width/2)
                        let y = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height/2)
                        
                        let tileNode = SKNode()
                        
                        tileNode.position = CGPoint(x: x, y: y)
                        tileNode.physicsBody = SKPhysicsBody(texture: tileTexture,
                                                             alphaThreshold: 0.3,
                                                             size: tileTexture.size())
                        tileNode.physicsBody?.isDynamic = false
                        
                        
                        tileMap.addChild(tileNode)
                    }
                }
            }
            
        }
        
    }
}
