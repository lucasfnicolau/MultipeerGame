//
//  TexturesManages.swift
//  MultipeerMadness
//
//  Created by Matheus Silva on 23/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import Foundation
import SpriteKit

public class TextureManager: NSObject {
    //Sing
    static let shared = TextureManager()
    
    let map:SKTextureAtlas = SKTextureAtlas(named: "Map")
    
    let idle_nothing_left_0:SKTextureAtlas = SKTextureAtlas(named: "idle_nothing_left_0")
    let idle_nothing_left_1:SKTextureAtlas = SKTextureAtlas(named: "idle_nothing_left_1")
    let idle_nothing_left_2:SKTextureAtlas = SKTextureAtlas(named: "idle_nothing_left_2")
    let idle_nothing_left_3:SKTextureAtlas = SKTextureAtlas(named: "idle_nothing_left_3")
    
    let idle_shooting_left_0:SKTextureAtlas = SKTextureAtlas(named: "idle_shooting_left_0")
    let idle_shooting_left_1:SKTextureAtlas = SKTextureAtlas(named: "idle_shooting_left_1")
    let idle_shooting_left_2:SKTextureAtlas = SKTextureAtlas(named: "idle_shooting_left_2")
    let idle_shooting_left_3:SKTextureAtlas = SKTextureAtlas(named: "idle_shooting_left_3")
    
    let run_nothing_left_0:SKTextureAtlas = SKTextureAtlas(named: "run_nothing_left_0")
    let run_nothing_left_1:SKTextureAtlas = SKTextureAtlas(named: "run_nothing_left_1")
    let run_nothing_left_2:SKTextureAtlas = SKTextureAtlas(named: "run_nothing_left_2")
    let run_nothing_left_3:SKTextureAtlas = SKTextureAtlas(named: "run_nothing_left_3")
    
    let run_shooting_left_0:SKTextureAtlas = SKTextureAtlas(named: "run_shooting_left_0")
    let run_shooting_left_1:SKTextureAtlas = SKTextureAtlas(named: "run_shooting_left_1")
    let run_shooting_left_2:SKTextureAtlas = SKTextureAtlas(named: "run_shooting_left_2")
    let run_shooting_left_3:SKTextureAtlas = SKTextureAtlas(named: "run_shooting_left_3")
    
    let idle_nothing_front_0:SKTextureAtlas = SKTextureAtlas(named: "idle_nothing_front_0")
    let idle_nothing_front_1:SKTextureAtlas = SKTextureAtlas(named: "idle_nothing_front_1")
    let idle_nothing_front_2:SKTextureAtlas = SKTextureAtlas(named: "idle_nothing_front_2")
    let idle_nothing_front_3:SKTextureAtlas = SKTextureAtlas(named: "idle_nothing_front_3")
    
    
    func preloadAssets(_ handler: @escaping () -> Void) {
        SKTextureAtlas.preloadTextureAtlases([map,
                                              
                                              idle_nothing_left_0,
                                              idle_nothing_left_1,
                                              idle_nothing_left_2,
                                              idle_nothing_left_3,
                                              
                                              idle_shooting_left_0,
                                              idle_shooting_left_1,
                                              idle_shooting_left_2,
                                              idle_shooting_left_3,
                                              
                                              run_nothing_left_0,
                                              run_nothing_left_1,
                                              run_nothing_left_2,
                                              run_nothing_left_3,
                                              
                                              run_shooting_left_0,
                                              run_shooting_left_1,
                                              run_shooting_left_2,
                                              run_shooting_left_3
                                                
                                              ], withCompletionHandler: handler)
        
    }
    
    func getTextureAtlasFrames(for name: String) -> [SKTexture]{
        var textureAtlas:SKTextureAtlas = SKTextureAtlas()
        
        switch name {
            case "map":
                textureAtlas = map
            
            case "idle_nothing_left_0":
                textureAtlas = idle_nothing_left_0
            case "idle_nothing_left_1":
                textureAtlas = idle_nothing_left_1
            case "idle_nothing_left_2":
                textureAtlas = idle_nothing_left_2
            case "idle_nothing_left_3":
                textureAtlas = idle_nothing_left_3
            
            case "idle_shooting_left_0":
                textureAtlas = idle_shooting_left_0
            case "idle_shooting_left_1":
                textureAtlas = idle_shooting_left_1
            case "idle_shooting_left_2":
                textureAtlas = idle_shooting_left_2
            case "idle_shooting_left_3":
                textureAtlas = idle_shooting_left_3
            
            case "run_nothing_left_0":
                textureAtlas = run_nothing_left_0
            case "run_nothing_left_1":
                textureAtlas = run_nothing_left_1
            case "run_nothing_left_2":
                textureAtlas = run_nothing_left_2
            case "run_nothing_left_3":
                textureAtlas = run_nothing_left_3
            
            case "run_shooting_left_0":
                textureAtlas = run_shooting_left_0
            case "run_shooting_left_1":
                textureAtlas = run_shooting_left_1
            case "run_shooting_left_2":
                textureAtlas = run_shooting_left_2
            case "run_shooting_left_3":
                textureAtlas = run_shooting_left_3
            
            case "idle_nothing_front_0":
                textureAtlas = idle_nothing_front_0
            case "idle_nothing_front_1":
                textureAtlas = idle_nothing_front_1
            case "idle_nothing_front_2":
                textureAtlas = idle_nothing_front_2
            case "idle_nothing_front_3":
                textureAtlas = idle_nothing_front_3
            
            default:
                print("Mangeger falhou ao carregar o Atlas: \(name)")
        }
        
        var frames = [SKTexture]()
        let names = textureAtlas.textureNames.sorted()
        
        for name in names {
            frames.append(textureAtlas.textureNamed(name))
            textureAtlas.textureNamed(name).filteringMode = .nearest
        }
        return frames
    }
}
