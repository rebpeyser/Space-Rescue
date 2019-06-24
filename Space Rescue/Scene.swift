//
//  Scene.swift
//  Space Rescue
//
//  Created by Rebecca Peyser on 6/24/19.
//  Copyright © 2019 Rebecca Peyser. All rights reserved.
//

import SpriteKit
import ARKit

class Scene: SKScene {
    
    var sceneView: ARSKView {
        return view as! ARSKView
    }
    var isWorldSetUp = false
    var aim: SKSpriteNode!
    let gameSize = CGSize(width: 2, height: 2)


    override func didMove(to view: SKView) {
        // Setup your scene here
        aim = SKSpriteNode(imageNamed: "aim")
        addChild(aim)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if isWorldSetUp == false {
            setUpWorld()
        }
        adjustLighting()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        rescueDog()
    }
    
    func setUpWorld() {
        // Create anchor using the camera's current position
        guard let currentFrame = sceneView.session.currentFrame,
            let scene = SKScene(fileNamed: "Level1") else {
                return
            }
        for node in scene.children {
            if let node = node as? SKSpriteNode {
                var translation = matrix_identity_float4x4
                let positionX = node.position.x/scene.size.width
                let positionY = node.position.y/scene.size.height
                translation.columns.3.x = Float(positionX*gameSize.width)
                translation.columns.3.z = Float(positionY*gameSize.height)
                translation.columns.3.y = Float.random(in: -0.5..<0.5)
                let transform = simd_mul(currentFrame.camera.transform, translation)
                //let anchor = ARAnchor(transform: transform)
                //sceneView.session.add(anchor: anchor)
                let anchor = Anchor(transform: transform)
                if let name = node.name,
                    let type = NodeType(rawValue: name) {
                    anchor.type = type
                    sceneView.session.add(anchor: anchor)
                }
            }
        }
        isWorldSetUp = true
        
    }
        

    
    
    func adjustLighting() {
        guard let currentFrame = sceneView.session.currentFrame, let lightEstimate = currentFrame.lightEstimate else {
            return
        }
        let neutralIntensity: CGFloat = 1000
        let ambientIntensity = min(lightEstimate.ambientIntensity, neutralIntensity)
        let blendFactor = 1 - ambientIntensity / neutralIntensity
        for node in children {
            if let spaceDog = node as? SKSpriteNode {
                spaceDog.color = .black
                spaceDog.colorBlendFactor = blendFactor
            }
        }
    }
    
    func rescueDog() {
        let location = aim.position
        let hitNodes = nodes(at: location)
        var rescuedDog: SKNode?
        for node in hitNodes {
            if node.name == "trappedDog" {
                rescuedDog = node
                break
            }
        }
        if let rescuedDog = rescuedDog {
            let wait = SKAction.wait(forDuration: 0.3)
            let removeDog = SKAction.removeFromParent()
            let sequence = SKAction.sequence([wait, removeDog])
            rescuedDog.run(sequence)
        }
    }
}
