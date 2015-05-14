//
//  GameViewController.swift
//  quantum mechanics
//
//  Created by Evandro Remon Pulz Viva on 13/05/15.
//  Copyright (c) 2015 Evandro Remon Pulz Viva. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, SCNPhysicsContactDelegate, SCNSceneRendererDelegate{

    
    var texture: SCNNode!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/ExperimentRoom.dae")!
        
        let ship = scene.rootNode.childNodeWithName("SketchUp", recursively: true)!
        scene.physicsWorld.contactDelegate = self
        ship.scale = SCNVector3Make(0.2, 0.2, 0.2)
        ship.position = SCNVector3Make(0, -2.8, 0)
        let moduleScene = SCNScene(named: "art.scnassets/module.dae")!
        let module = moduleScene.rootNode.childNodeWithName("SketchUp", recursively: true)!
        module.scale = SCNVector3Make(0.2, 0.2, 0.2)
        module.position = SCNVector3Make(0, -2.8, 0)
        scene.rootNode.addChildNode(module)

        let wall1 = scene.rootNode.childNodeWithName("1", recursively: true)!
        wall1.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.Kinematic, shape: nil)
        let wall2 = scene.rootNode.childNodeWithName("2", recursively: true)!
        wall1.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.Kinematic, shape: nil)
        let wall3 = scene.rootNode.childNodeWithName("3", recursively: true)!
        wall1.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.Kinematic, shape: nil)
//        let texture1 = scene.rootNode.childNodeWithName("t1", recursively: true)!
        texture = scene.rootNode.childNodeWithName("fade", recursively: true)!
        
        let texture2 = scene.rootNode.childNodeWithName("x", recursively: true)!
        texture2.scale = SCNVector3Make(1, 0.17, 1)
        texture2.position = SCNVector3Make(texture2.position.x, texture2.position.y + 8, texture2.position.z)
        
        //texture1.geometry?.firstMaterial?.diffuse. = true
//        texture.scale = SCNVector3Make(1, 0.3, 1)
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        let particles = SCNParticleSystem(named: "atoms.scnp", inDirectory: "")
        particles.affectedByPhysicsFields = true
        var arrayOfNodes = NSMutableArray()
        arrayOfNodes.addObject(wall1)
        arrayOfNodes.addObject(wall2)
        arrayOfNodes.addObject(wall3)
//        arrayOfNodes.addObject(backWall)
        particles.colliderNodes = arrayOfNodes as [AnyObject]
        println(particles.colliderNodes?.count)
        

        let atomsNode = SCNNode()
        atomsNode.addParticleSystem(particles)
        
        scene.rootNode.addChildNode(atomsNode)
        
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 5, z: 15)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor.darkGrayColor()
        scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the ship node
        //let ship = scene.rootNode.childNodeWithName("ship", recursively: true)!
        
        // animate the 3d object
        //ship.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y: 2, z: 0, duration: 1)))
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.blackColor()
        scnView.delegate = self
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        var gestureRecognizers = [AnyObject]()
        gestureRecognizers.append(tapGesture)
        if let existingGestureRecognizers = scnView.gestureRecognizers {
            gestureRecognizers.extend(existingGestureRecognizers)
        }
        scnView.gestureRecognizers = gestureRecognizers
    }
    var alphaValue = CGFloat(1)
    func renderer(aRenderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
        if alphaValue > 0{
            alphaValue -= 0.0005
            texture.opacity = alphaValue
        }
    }
    
    func handleTap(gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.locationInView(scnView)
        if let hitResults = scnView.hitTest(p, options: nil) {
            // check that we clicked on at least one object
            if hitResults.count > 0 {
                // retrieved the first clicked object
                let result: AnyObject! = hitResults[0]
                
                // get its material
                let material = result.node!.geometry!.firstMaterial!
                
                // highlight it
                SCNTransaction.begin()
                SCNTransaction.setAnimationDuration(0.5)
                
                // on completion - unhighlight
                SCNTransaction.setCompletionBlock {
                    SCNTransaction.begin()
                    SCNTransaction.setAnimationDuration(0.5)
                    
                    material.emission.contents = UIColor.blackColor()
                    
                    SCNTransaction.commit()
                }
                
                material.emission.contents = UIColor.redColor()
                
                SCNTransaction.commit()
            }
        }
    }
    

    
    func physicsWorld(world: SCNPhysicsWorld, didBeginContact contact: SCNPhysicsContact){
        
        
        
       println("hit")
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
