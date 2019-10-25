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
    
    //IDLE NOTHING
    let idle_nothing_left_0:SKTextureAtlas = SKTextureAtlas(named: "idle_nothing_left_0")
    let idle_nothing_left_1:SKTextureAtlas = SKTextureAtlas(named: "idle_nothing_left_1")
    let idle_nothing_left_2:SKTextureAtlas = SKTextureAtlas(named: "idle_nothing_left_2")
    let idle_nothing_left_3:SKTextureAtlas = SKTextureAtlas(named: "idle_nothing_left_3")
    
    let idle_nothing_front_0:SKTextureAtlas = SKTextureAtlas(named: "idle_nothing_front_0")
    let idle_nothing_front_1:SKTextureAtlas = SKTextureAtlas(named: "idle_nothing_front_1")
    let idle_nothing_front_2:SKTextureAtlas = SKTextureAtlas(named: "idle_nothing_front_2")
    let idle_nothing_front_3:SKTextureAtlas = SKTextureAtlas(named: "idle_nothing_front_3")
    
    let idle_nothing_back_0:SKTextureAtlas = SKTextureAtlas(named: "idle_nothing_back_0")
    let idle_nothing_back_1:SKTextureAtlas = SKTextureAtlas(named: "idle_nothing_back_1")
    let idle_nothing_back_2:SKTextureAtlas = SKTextureAtlas(named: "idle_nothing_back_2")
    let idle_nothing_back_3:SKTextureAtlas = SKTextureAtlas(named: "idle_nothing_back_3")
    
    let idle_nothing_right_0:SKTextureAtlas = SKTextureAtlas(named: "idle_nothing_right_0")
    let idle_nothing_right_1:SKTextureAtlas = SKTextureAtlas(named: "idle_nothing_right_1")
    let idle_nothing_right_2:SKTextureAtlas = SKTextureAtlas(named: "idle_nothing_right_2")
    let idle_nothing_right_3:SKTextureAtlas = SKTextureAtlas(named: "idle_nothing_right_3")
    
    //IDLE SHOOTING
    let idle_shooting_left_0:SKTextureAtlas = SKTextureAtlas(named: "idle_shooting_left_0")
    let idle_shooting_left_1:SKTextureAtlas = SKTextureAtlas(named: "idle_shooting_left_1")
    let idle_shooting_left_2:SKTextureAtlas = SKTextureAtlas(named: "idle_shooting_left_2")
    let idle_shooting_left_3:SKTextureAtlas = SKTextureAtlas(named: "idle_shooting_left_3")
    
    let idle_shooting_back_0:SKTextureAtlas = SKTextureAtlas(named: "idle_shooting_back_0")
    let idle_shooting_back_1:SKTextureAtlas = SKTextureAtlas(named: "idle_shooting_back_1")
    let idle_shooting_back_2:SKTextureAtlas = SKTextureAtlas(named: "idle_shooting_back_2")
    let idle_shooting_back_3:SKTextureAtlas = SKTextureAtlas(named: "idle_shooting_back_3")
    
    let idle_shooting_front_0:SKTextureAtlas = SKTextureAtlas(named: "idle_shooting_front_0")
    let idle_shooting_front_1:SKTextureAtlas = SKTextureAtlas(named: "idle_shooting_front_1")
    let idle_shooting_front_2:SKTextureAtlas = SKTextureAtlas(named: "idle_shooting_front_2")
    let idle_shooting_front_3:SKTextureAtlas = SKTextureAtlas(named: "idle_shooting_front_3")
    
    let idle_shooting_right_0:SKTextureAtlas = SKTextureAtlas(named: "idle_shooting_right_0")
    let idle_shooting_right_1:SKTextureAtlas = SKTextureAtlas(named: "idle_shooting_right_1")
    let idle_shooting_right_2:SKTextureAtlas = SKTextureAtlas(named: "idle_shooting_right_2")
    let idle_shooting_right_3:SKTextureAtlas = SKTextureAtlas(named: "idle_shooting_right_3")
    
    
    //RUN SHOOTING
    let run_shooting_front_0:SKTextureAtlas = SKTextureAtlas(named: "run_shooting_front_0")
    let run_shooting_front_1:SKTextureAtlas = SKTextureAtlas(named: "run_shooting_front_1")
    let run_shooting_front_2:SKTextureAtlas = SKTextureAtlas(named: "run_shooting_front_2")
    let run_shooting_front_3:SKTextureAtlas = SKTextureAtlas(named: "run_shooting_front_3")
    
    
    let run_shooting_left_0:SKTextureAtlas = SKTextureAtlas(named: "run_shooting_left_0")
    let run_shooting_left_1:SKTextureAtlas = SKTextureAtlas(named: "run_shooting_left_1")
    let run_shooting_left_2:SKTextureAtlas = SKTextureAtlas(named: "run_shooting_left_2")
    let run_shooting_left_3:SKTextureAtlas = SKTextureAtlas(named: "run_shooting_left_3")
    
    
    let run_shooting_right_0:SKTextureAtlas = SKTextureAtlas(named: "run_shooting_right_0")
    let run_shooting_right_1:SKTextureAtlas = SKTextureAtlas(named: "run_shooting_right_1")
    let run_shooting_right_2:SKTextureAtlas = SKTextureAtlas(named: "run_shooting_right_2")
    let run_shooting_right_3:SKTextureAtlas = SKTextureAtlas(named: "run_shooting_right_3")
    
    
    let run_shooting_back_0:SKTextureAtlas = SKTextureAtlas(named: "run_shooting_back_0")
    let run_shooting_back_1:SKTextureAtlas = SKTextureAtlas(named: "run_shooting_back_1")
    let run_shooting_back_2:SKTextureAtlas = SKTextureAtlas(named: "run_shooting_back_2")
    let run_shooting_back_3:SKTextureAtlas = SKTextureAtlas(named: "run_shooting_back_3")
    
    //RUN NOTHING
    let run_nothing_front_0:SKTextureAtlas = SKTextureAtlas(named: "run_nothing_front_0")
    let run_nothing_front_1:SKTextureAtlas = SKTextureAtlas(named: "run_nothing_front_1")
    let run_nothing_front_2:SKTextureAtlas = SKTextureAtlas(named: "run_nothing_front_2")
    let run_nothing_front_3:SKTextureAtlas = SKTextureAtlas(named: "run_nothing_front_3")
    
    let run_nothing_left_0:SKTextureAtlas = SKTextureAtlas(named: "run_nothing_left_0")
    let run_nothing_left_1:SKTextureAtlas = SKTextureAtlas(named: "run_nothing_left_1")
    let run_nothing_left_2:SKTextureAtlas = SKTextureAtlas(named: "run_nothing_left_2")
    let run_nothing_left_3:SKTextureAtlas = SKTextureAtlas(named: "run_nothing_left_3")
    
    let run_nothing_right_0:SKTextureAtlas = SKTextureAtlas(named: "run_nothing_right_0")
    let run_nothing_right_1:SKTextureAtlas = SKTextureAtlas(named: "run_nothing_right_1")
    let run_nothing_right_2:SKTextureAtlas = SKTextureAtlas(named: "run_nothing_right_2")
    let run_nothing_right_3:SKTextureAtlas = SKTextureAtlas(named: "run_nothing_right_3")
    
    let run_nothing_back_0:SKTextureAtlas = SKTextureAtlas(named: "run_nothing_back_0")
    let run_nothing_back_1:SKTextureAtlas = SKTextureAtlas(named: "run_nothing_back_1")
    let run_nothing_back_2:SKTextureAtlas = SKTextureAtlas(named: "run_nothing_back_2")
    let run_nothing_back_3:SKTextureAtlas = SKTextureAtlas(named: "run_nothing_back_3")

    //DIE
    let die_nothing_front_0:SKTextureAtlas = SKTextureAtlas(named: "die_nothing_front_0")
    let die_nothing_front_1:SKTextureAtlas = SKTextureAtlas(named: "die_nothing_front_1")
    let die_nothing_front_2:SKTextureAtlas = SKTextureAtlas(named: "die_nothing_front_2")
    let die_nothing_front_3:SKTextureAtlas = SKTextureAtlas(named: "die_nothing_front_3")
    
    
    func preloadAssetsMap(_ handler: @escaping () -> Void) {
    SKTextureAtlas.preloadTextureAtlases([map], withCompletionHandler: handler)}

    func preloadAssetsDie(_ handler: @escaping () -> Void) {
        SKTextureAtlas.preloadTextureAtlases([
            
            die_nothing_front_0,
            die_nothing_front_1,
            die_nothing_front_2,
            die_nothing_front_3,
            
        ], withCompletionHandler: handler)}
    
    func preloadAssetsIdle(_ handler: @escaping () -> Void) {
        SKTextureAtlas.preloadTextureAtlases([

            //IDLE NOTHING
            idle_nothing_left_0,
            idle_nothing_left_1,
            idle_nothing_left_2,
            idle_nothing_left_3,
            
            idle_nothing_back_0,
            idle_nothing_back_1,
            idle_nothing_back_2,
            idle_nothing_back_3,
            
            idle_nothing_front_0,
            idle_nothing_front_1,
            idle_nothing_front_2,
            idle_nothing_front_3,
            
            idle_nothing_right_0,
            idle_nothing_right_1,
            idle_nothing_right_2,
            idle_nothing_right_3,
            
        ], withCompletionHandler: handler)}
    
    func preloadAssetsIdleShooting(_ handler: @escaping () -> Void) {
        SKTextureAtlas.preloadTextureAtlases([

            //IDLE SHOOTING
            idle_shooting_left_0,
            idle_shooting_left_1,
            idle_shooting_left_2,
            idle_shooting_left_3,
            
            idle_shooting_front_0,
            idle_shooting_front_1,
            idle_shooting_front_2,
            idle_shooting_front_3,
            
            idle_shooting_back_0,
            idle_shooting_back_1,
            idle_shooting_back_2,
            idle_shooting_back_3,
            
            idle_shooting_right_0,
            idle_shooting_right_1,
            idle_shooting_right_2,
            idle_shooting_right_3,
            
        ], withCompletionHandler: handler)}
    
    func preloadAssetsRun(_ handler: @escaping () -> Void) {
        SKTextureAtlas.preloadTextureAtlases([

            //RUN NOTHING
            run_nothing_left_0,
            run_nothing_left_1,
            run_nothing_left_2,
            run_nothing_left_3,
            
            run_nothing_front_0,
            run_nothing_front_1,
            run_nothing_front_2,
            run_nothing_front_3,
            
            run_nothing_back_0,
            run_nothing_back_1,
            run_nothing_back_2,
            run_nothing_back_3,
            
            run_nothing_right_0,
            run_nothing_right_1,
            run_nothing_right_2,
            run_nothing_right_3,
            
            
        ], withCompletionHandler: handler)}
    
    func preloadAssetsRunShooting(_ handler: @escaping () -> Void) {
        SKTextureAtlas.preloadTextureAtlases([
            
            //RUN SHOOTING
            run_shooting_left_0,
            run_shooting_left_1,
            run_shooting_left_2,
            run_shooting_left_3,
            
            run_shooting_front_0,
            run_shooting_front_1,
            run_shooting_front_2,
            run_shooting_front_3,
            
            run_shooting_back_0,
            run_shooting_back_1,
            run_shooting_back_2,
            run_shooting_back_3,
            
            run_shooting_right_0,
            run_shooting_right_1,
            run_shooting_right_2,
            run_shooting_right_3,
            
            
        ], withCompletionHandler: handler)}
    
    func getTextureAtlasFrames(for name: String) -> [SKTexture]{
        var textureAtlas:SKTextureAtlas = SKTextureAtlas()
        
        switch name {
        case "map":
            textureAtlas = map
            
        //IDLE NOTHING
        case "idle_nothing_left_0":
            textureAtlas = idle_nothing_left_0
        case "idle_nothing_left_1":
            textureAtlas = idle_nothing_left_1
        case "idle_nothing_left_2":
            textureAtlas = idle_nothing_left_2
        case "idle_nothing_left_3":
            textureAtlas = idle_nothing_left_3
            
        case "idle_nothing_front_0":
            textureAtlas = idle_nothing_front_0
        case "idle_nothing_front_1":
            textureAtlas = idle_nothing_front_1
        case "idle_nothing_front_2":
            textureAtlas = idle_nothing_front_2
        case "idle_nothing_front_3":
            textureAtlas = idle_nothing_front_3
            
        case "idle_nothing_back_0":
            textureAtlas = idle_nothing_back_0
        case "idle_nothing_back_1":
            textureAtlas = idle_nothing_back_1
        case "idle_nothing_back_2":
            textureAtlas = idle_nothing_back_2
        case "idle_nothing_back_3":
            textureAtlas = idle_nothing_back_3
            
        case "idle_nothing_right_0":
            textureAtlas = idle_nothing_right_0
        case "idle_nothing_right_1":
            textureAtlas = idle_nothing_right_1
        case "idle_nothing_right_2":
            textureAtlas = idle_nothing_right_2
        case "idle_nothing_right_3":
            textureAtlas = idle_nothing_right_3
            
            
        //IDLE SHOOTING
        case "idle_shooting_left_0":
            textureAtlas = idle_shooting_left_0
        case "idle_shooting_left_1":
            textureAtlas = idle_shooting_left_1
        case "idle_shooting_left_2":
            textureAtlas = idle_shooting_left_2
        case "idle_shooting_left_3":
            textureAtlas = idle_shooting_left_3
            
        case "idle_shooting_front_0":
            textureAtlas = idle_shooting_front_0
        case "idle_shooting_front_1":
            textureAtlas = idle_shooting_front_1
        case "idle_shooting_front_2":
            textureAtlas = idle_shooting_front_2
        case "idle_shooting_front_3":
            textureAtlas = idle_shooting_front_3
            
        case "idle_shooting_back_0":
            textureAtlas = idle_shooting_back_0
        case "idle_shooting_back_1":
            textureAtlas = idle_shooting_back_1
        case "idle_shooting_back_2":
            textureAtlas = idle_shooting_back_2
        case "idle_shooting_back_3":
            textureAtlas = idle_shooting_back_3
            
        case "idle_shooting_right_0":
            textureAtlas = idle_shooting_right_0
        case "idle_shooting_right_1":
            textureAtlas = idle_shooting_right_1
        case "idle_shooting_right_2":
            textureAtlas = idle_shooting_right_2
        case "idle_shooting_right_3":
            textureAtlas = idle_shooting_right_3
            
            
        //RUN SHOOTING
        case "run_shooting_left_0":
            textureAtlas = run_shooting_left_0
        case "run_shooting_left_1":
            textureAtlas = run_shooting_left_1
        case "run_shooting_left_2":
            textureAtlas = run_shooting_left_2
        case "run_shooting_left_3":
            textureAtlas = run_shooting_left_3
            
        case "run_shooting_front_0":
            textureAtlas = run_shooting_front_0
        case "run_shooting_front_1":
            textureAtlas = run_shooting_front_1
        case "run_shooting_front_2":
            textureAtlas = run_shooting_front_2
        case "run_shooting_front_3":
            textureAtlas = run_shooting_front_3
            
        case "run_shooting_right_0":
            textureAtlas = run_shooting_right_0
        case "run_shooting_right_1":
            textureAtlas = run_shooting_right_1
        case "run_shooting_right_2":
            textureAtlas = run_shooting_right_2
        case "run_shooting_right_3":
            textureAtlas = run_shooting_right_3
            
        case "run_shooting_back_0":
            textureAtlas = run_shooting_back_0
        case "run_shooting_back_1":
            textureAtlas = run_shooting_back_1
        case "run_shooting_back_2":
            textureAtlas = run_shooting_back_2
        case "run_shooting_back_3":
            textureAtlas = run_shooting_back_3
            
        //RUN NOTHING
        case "run_nothing_front_0":
            textureAtlas = run_nothing_front_0
        case "run_nothing_front_1":
            textureAtlas = run_nothing_front_1
        case "run_nothing_front_2":
            textureAtlas = run_nothing_front_2
        case "run_nothing_front_3":
            textureAtlas = run_nothing_front_3
            
        case "run_nothing_right_0":
            textureAtlas = run_nothing_right_0
        case "run_nothing_right_1":
            textureAtlas = run_nothing_right_1
        case "run_nothing_right_2":
            textureAtlas = run_nothing_right_2
        case "run_nothing_right_3":
            textureAtlas = run_nothing_right_3
            
        case "run_nothing_left_0":
            textureAtlas = run_nothing_left_0
        case "run_nothing_left_1":
            textureAtlas = run_nothing_left_1
        case "run_nothing_left_2":
            textureAtlas = run_nothing_left_2
        case "run_nothing_left_3":
            textureAtlas = run_nothing_left_3
            
        case "run_nothing_back_0":
            textureAtlas = run_nothing_back_0
        case "run_nothing_back_1":
            textureAtlas = run_nothing_back_1
        case "run_nothing_back_2":
            textureAtlas = run_nothing_back_2
        case "run_nothing_back_3":
            textureAtlas = run_nothing_back_3

        //DIE
        case "die_nothing_front_0":
            textureAtlas = die_nothing_front_0
        case "die_nothing_front_1":
            textureAtlas = die_nothing_front_1
        case "die_nothing_front_2":
            textureAtlas = die_nothing_front_2
        case "die_nothing_front_3":
            textureAtlas = die_nothing_front_3
            
        default:
            NSLog("Mangeger falhou ao carregar o Atlas: \(name)")
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
