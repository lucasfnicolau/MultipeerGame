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
    case floor = 0
    case wall
    case hazard
    case ceiling
    case shadow
}

class CustomMap: SKNode {
    
    private(set) var tileSet  = SKTileSet()
    private(set) var tileSize = CGSize()
    private(set) var columns  = Int()
    private(set) var rows     = Int()
    static var normalBitmask: UInt32 = 00100
    static var hazardBitmask: UInt32 = 01000
    
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
        let floor = tileSet.tileGroups.first { $0.name == "Floor" }
        let wall  = tileSet.tileGroups.first { $0.name == "Wall" }
        let hazard = tileSet.tileGroups.first { $0.name == "Hazard" }
        
        setBottonLayer(bottonLayer: floor)
        
        let layer = SKTileMapNode(tileSet: tileSet,
                                  columns: columns,
                                  rows: rows,
                                  tileSize: tileSize)
        self.addChild(layer)
        
        for column in 0 ..< columns {
            for row in 0 ..< rows {
                switch mapJSON.map[column][row] {
                case MapCase.floor.rawValue:
                    layer.setTileGroup(floor, forColumn: column, row: row)
                case MapCase.wall.rawValue:
                    layer.setTileGroup(wall, forColumn: column, row: row)
                case MapCase.hazard.rawValue:
                    layer.setTileGroup(hazard, forColumn: column, row: row)
//                case MapCase.wall.rawValue:
//                    layer.setTileGroup(wall, forColumn: column, row: row)
                default:
                    layer.setTileGroup(floor, forColumn: column, row: row)
                    
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
                
                if let tileDefinition = tileMap.tileDefinition(atColumn: column, row: row) {
                    guard let tileType = tileDefinition.userData?["TileType"] as? Int else { return }
                    
                    let tileArray = tileDefinition.textures
                    let tileTexture = tileArray[0]
                    
                    let x = CGFloat(column) * tileSize.width - halfWidth + (tileSize.width/2)
                    let y = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height/2)
                    
                    let tileNode = SKNode()
                    
                    tileNode.position = CGPoint(x: x, y: y)
                    
                    if tileType != 0 {
                        tileNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 128, height: 128))
                        tileNode.physicsBody?.isDynamic = false
                        
                        if tileType != 2 {
                            tileNode.physicsBody?.collisionBitMask = CustomMap.normalBitmask
                        } else {
                            tileNode.physicsBody?.collisionBitMask = CustomMap.hazardBitmask
                        }
                    }
                    
                    tileMap.addChild(tileNode)
                }
            }
        }
    }
}
