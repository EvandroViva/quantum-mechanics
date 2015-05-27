//
//  GameViewController.swift
//  waveSimulation
//
//  Created by Fernando Lucheti on 19/05/15.
//  Copyright (c) 2015 Fernando Lucheti. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, SCNSceneRendererDelegate, SCNPhysicsContactDelegate {

    
    var scene: SCNScene!
    var floorNode: SCNNode!
    var wave: SCNTorus!
    var waveNode: SCNNode!
    var arrayOfWaves = NSMutableArray()
    var cameraNode: SCNNode!
    
    var waveArray = NSMutableArray()
    var nodesArray = NSMutableArray()
    var counter = 0
    var frame = 0
    
    var cameraPoint = 0
    var scnView: SCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for var i = 0; i < 21; ++i{
            waveArray.addObject(SCNTorus())
            nodesArray.addObject(SCNNode())
        }
        
        for var i = 0; i < 21; ++i{
            array2Waves.addObject(SCNNode())
        }
        
        
        
        // create a new scene
        scene = SCNScene(named: "art.scnassets/Quantum2.dae")!
        let room = scene.rootNode.childNodeWithName("SketchUp", recursively: true)!
        room.scale = SCNVector3Make(0.2, 0.2, 0.17)
        room.position.z += 36
        room.position.x += 3.5
        
        // create and add a camera to the scene
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.xFov = 60
        cameraNode.camera?.zFar = 200
        scene.rootNode.addChildNode(cameraNode)
        
        
        let scene2 = SCNScene(named: "art.scnassets/fastOrbit.dae")!
        let electron = scene2.rootNode.childNodeWithName("electro", recursively: true)!
        
        electron.position = SCNVector3(x: 65, y: 0, z: 0)
        electron.scale = SCNVector3Make(0.9, 0.9, 0.9)
        scene.rootNode.addChildNode(electron)
        
        let spin = CABasicAnimation(keyPath: "rotation")
        spin.fromValue = NSValue(SCNVector4: SCNVector4(x: 1, y: 1, z: 0, w: 0))
        spin.toValue = NSValue(SCNVector4: SCNVector4(x: 1, y:1, z: 0, w: 2 * Float(M_PI)))
        spin.duration = 2
        spin.repeatCount = .infinity
        electron.addAnimation(spin, forKey: "spin around")
        
         let scene3 = SCNScene(named: "art.scnassets/fastOrbit.dae")!
        let electron2 = scene3.rootNode.childNodeWithName("electro", recursively: true)!
        electron2.addAnimation(spin, forKey: "spin around")
        
        electron2.position = SCNVector3(x: 75, y: 0, z: 0)
        electron2.scale = SCNVector3Make(0.9, 0.9, 0.9)
        scene.rootNode.addChildNode(electron2)
        
        
        // place the camera
        cameraNode.position = SCNVector3(x: 70, y: 0, z: 15)
        
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
        
        
        for var i = 1; i < 16; ++i{
            
            var x = SCNScene(named: "art.scnassets/Frames/\(i).dae")!
            var waveNode1 = x.rootNode.childNodeWithName("Cube", recursively: true)!
            var waveNode2 = x.rootNode.childNodeWithName("Plane", recursively: true)!
            
            var waveNode = SCNNode()
            waveNode.addChildNode(waveNode1)
            waveNode.addChildNode(waveNode2)
            arrayOfWaves.addObject(waveNode)
            
            println(i)
        }
        
        
        for var i = 1; i < 3; ++i{
            let electron = scene.rootNode.childNodeWithName("\(i)", recursively: true)!
            electron.hidden = true
            let orbit = scene.rootNode.childNodeWithName("orbit\(i)", recursively: true)!
            orbit.hidden = true
        }
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: Selector("leap"), userInfo: nil, repeats: true)
        
        // retrieve the ship node
        //let ship = scene.rootNode.childNodeWithName("ship", recursively: true)!
        
        // animate the 3d object
        //ship.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y: 2, z: 0, duration: 1)))
        
        texture = scene.rootNode.childNodeWithName("wall", recursively: true)!
        
        //spawnTimer = NSTimer.scheduledTimerWithTimeInterval(0.6, target: self, selector: Selector("spawn2Waves"), userInfo: nil, repeats: true)
        
        //var ready = NSTimer.scheduledTimerWithTimeInterval(6, target: self, selector: Selector("readyToWave"), userInfo: nil, repeats: true)
        
        //var sp2awnTimer = NSTimer.scheduledTimerWithTimeInterval(0.6, target: self, selector: Selector("spawnWave"), userInfo: nil, repeats: true)
        
        var timerx = NSTimer.scheduledTimerWithTimeInterval(0.08, target: self, selector: Selector("updateWave"), userInfo: nil, repeats: true)
        
        let point = scene.rootNode.childNodeWithName("point", recursively: true)!
        
        //cameraNode.constraints = [SCNLookAtConstraint(target: electron)] // pov is the camera
        
        //let sceneroom = SCNScene(named: "art.scnassets/ExperimentRoom.dae")!
        // retrieve the SCNView
        scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = false
        
        // show statistics such as fps and timing information
//        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.blackColor()
        scnView.delegate = self
        
        //setupFloor()
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        var gestureRecognizers = [AnyObject]()
        gestureRecognizers.append(tapGesture)
        if let existingGestureRecognizers = scnView.gestureRecognizers {
            gestureRecognizers.extend(existingGestureRecognizers)
        }
        scnView.gestureRecognizers = gestureRecognizers
        scnView.pointOfView = cameraNode
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width;
        let screenHeight = screenSize.height;
        
        
        
        cameraButton = UIButton(frame : CGRect(x:screenWidth - 54, y: 10, width: 44, height:44 ))
        //let img = UIImage(named: "camera.jpg")! as UIImage
        //cameraButton.setImage(img, forState: UIControlState.Normal)
        cameraButton.backgroundColor = UIColor.grayColor()
        cameraButton.addTarget(self, action: "changeCamera", forControlEvents:.TouchUpInside)
        self.view.addSubview(cameraButton)
        
        
        
    }
    var cameraButton: UIButton!
    var wallX: SCNNode!
    func moveToExperiment1(){
        let scene4 = SCNScene(named: "art.scnassets/ExperimentRoom.dae")!
        
        wallX = scene4.rootNode.childNodeWithName("fade", recursively: true)!
        
        readyToWave()
        
        
        let room = scene4.rootNode.childNodeWithName("SketchUp", recursively: true)!
        room.scale = SCNVector3Make(0.2, 0.2, 0.2)
        room.position = SCNVector3Make(140, -2.8, 0)
        
        let wall1 = scene4.rootNode.childNodeWithName("wall1", recursively: true)!
        let wall2 = scene4.rootNode.childNodeWithName("wall2", recursively: true)!
        let wall3 = scene4.rootNode.childNodeWithName("wall3", recursively: true)!
        
        let particles = SCNParticleSystem(named: "atoms.scnp", inDirectory: "")
        particles.affectedByPhysicsFields = true
        var arrayOfNodes = NSMutableArray()
        arrayOfNodes.addObject(wall1)
        arrayOfNodes.addObject(wall2)
        arrayOfNodes.addObject(wall3)
        //        arrayOfNodes.addObject(backWall)
        particles.colliderNodes = arrayOfNodes as [AnyObject]
        
        
        let atomsNode = SCNNode()
        atomsNode.addParticleSystem(particles)
        atomsNode.position.x += 140
        scene.rootNode.addChildNode(atomsNode)
        
        scnView.allowsCameraControl = true
        scene.rootNode.addChildNode(room)
        
        
        SCNTransaction.begin()
        SCNTransaction.setAnimationDuration(0.5)
            //cameraNode.eulerAngles.x = 25
            cameraNode.position = SCNVector3(x: 140, y: 8, z: 25)
        
        SCNTransaction.commit()
    }
    
    var layerCounter = 1
    func leap(){
        
        if layerCounter == 1{
            let electron2 = scene.rootNode.childNodeWithName("3", recursively: true)!
            let orbit2 = scene.rootNode.childNodeWithName("orbit3", recursively: true)!
            electron2.hidden = false
            orbit2.hidden = false
        }else{
            let electron2 = scene.rootNode.childNodeWithName("\(layerCounter - 1)", recursively: true)!
            let orbit2 = scene.rootNode.childNodeWithName("orbit\(layerCounter - 1)", recursively: true)!
            electron2.hidden = false
            orbit2.hidden = false
        }
        
        
        if layerCounter < 3{
            layerCounter += 1
        }else{
            layerCounter = 1
        }
        
        
        
        let electron = scene.rootNode.childNodeWithName("\(layerCounter)", recursively: true)!
        let orbit = scene.rootNode.childNodeWithName("orbit\(layerCounter)", recursively: true)!
        electron.hidden = true
        orbit.hidden = true
    }
    
    
    
    
    func changeCameraView(){
      
            SCNTransaction.begin()
            SCNTransaction.setAnimationDuration(0.5)
            
            //fim
            switch self.cameraPoint{
            case 0:
                self.cameraNode.position = SCNVector3(x: 3.5, y: 15, z: 60)
                self.cameraPoint = 1
            case 1:
                self.cameraNode.position = SCNVector3(x: 3.5, y: -30, z: 55)
                self.cameraPoint = 2
            case 2:
                self.cameraNode.position = SCNVector3(x: 3.5, y: 60, z: 15)
                self.cameraPoint = 3
            case 3:
                self.cameraNode.position = SCNVector3(x: 70, y: 17, z: 35)
                self.cameraPoint = 0
            default:
                break
            }
            let point = self.scene.rootNode.childNodeWithName("point", recursively: true)!
        
            self.cameraNode.eulerAngles.x = 0
            self.cameraNode.eulerAngles.y = 90
            self.cameraNode.constraints = [SCNLookAtConstraint(target: point)] // pov is the camera
            
            SCNTransaction.commit()
       
    }
    
    func updateWave(){
        
        
        if frame == 0{
            var toRemove = arrayOfWaves.objectAtIndex(14) as! SCNNode
            toRemove.removeFromParentNode()
        }
        
        var waveNode = arrayOfWaves.objectAtIndex(frame) as! SCNNode
        scene.rootNode.addChildNode(waveNode)
        
        if frame > 0{
            var toRemove = arrayOfWaves.objectAtIndex(frame - 1) as! SCNNode
            toRemove.removeFromParentNode()
        }
        
        
        
        
        if frame < 14{
            
            frame += 1
        }else{
            
            frame = 0
        }
    }
    
    func readyToWave(){
        delay = 400;
    }
    
    var alphaValue = CGFloat(1)
    var texture: SCNNode!
    var delay = 0
    var ready = true
    func renderer(aRenderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
        delay += 1
        
        
        
        if alphaValue > 0 && delay > 560{
            alphaValue -= 0.0005
            texture.opacity = alphaValue
            wallX.opacity = alphaValue
        }
    }
    
    
    var spawnTimer: NSTimer!
    func spawnWave(){
        
        var toRemove = nodesArray.objectAtIndex(counter2) as! SCNNode
        toRemove.removeFromParentNode()
        
        var wave = SCNTorus(ringRadius: 2.8, pipeRadius: 0.1)
        var waveNode = SCNNode(geometry: wave)
        waveNode.geometry?.firstMaterial?.diffuse.contents = UIColor(red: 1, green: 0.4, blue: 0.4, alpha: 1)
        
        waveNode.position = SCNVector3Make(0, 0, 0)
        nodesArray.replaceObjectAtIndex(counter2, withObject: waveNode)
        if counter2 < 20 {
            counter2++
        }else{
            counter2 = 0
        }
        waveNode.runAction(SCNAction.scaleBy(12, duration: 6))
        waveNode.runAction(SCNAction.moveByX(0, y: -5.5, z: 0, duration: 25))
        scene.rootNode.addChildNode(waveNode)
       //var timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("removeNode"), userInfo: nil, repeats: true)
    }
    
    
    var array2Waves = NSMutableArray()
    var waveNodeParent = SCNNode()
    var counter2 = 0
    var wall: SCNNode!
    func spawn2Waves(){
        
        if delay > 360{
            var toRemove = array2Waves.objectAtIndex(counter) as! SCNNode
            toRemove.removeFromParentNode()
            
            var wave = SCNTorus(ringRadius: 3, pipeRadius: 0.1)
            var waveNode = SCNNode(geometry: wave)
            var waveNode2 = SCNNode(geometry: wave)
            waveNode.geometry?.firstMaterial?.diffuse.contents = UIColor(red: 1, green: 0.4, blue: 0.4, alpha: 1)
            waveNode2.geometry?.firstMaterial?.diffuse.contents = UIColor(red: 1, green: 0.4, blue: 0.4, alpha: 1)
            waveNode.position = SCNVector3Make(-4, -3.9, -33)
            waveNode2.position = SCNVector3Make(4, -3.9, -33)
            
            waveNodeParent.addChildNode(waveNode)
            waveNodeParent.addChildNode(waveNode2)
            
            array2Waves.replaceObjectAtIndex(counter, withObject: waveNodeParent)
            if counter < 20 {
                counter++
            }else{
                counter = 0
            }
            waveNode.runAction(SCNAction.scaleBy(12, duration: 6))
            waveNode.runAction(SCNAction.moveByX(0, y: -5.5, z: 0, duration: 25))
            
            waveNode2.runAction(SCNAction.scaleBy(12, duration: 6))
            waveNode2.runAction(SCNAction.moveByX(0, y: -5.5, z: 0, duration: 25))
            scene.rootNode.addChildNode(waveNodeParent)
        }
    }
    
    func scaleRadius(){
        var wave = waveArray.objectAtIndex(counter) as! SCNTorus
            wave.pipeRadius -= 0.012
    }
    
    func setupFloor(){
        var floor = SCNFloor()
        floor.reflectionFalloffEnd = 0
        floorNode = SCNNode()
        floorNode.geometry = floor
        floorNode.geometry?.firstMaterial?.diffuse.contents = UIColor.grayColor()
//        floorNode.geometry?.firstMaterial?.emission.contents = UIColor(red: 0, green: 0.1, blue: 0, alpha: 0.2)
        floorNode.geometry?.firstMaterial?.locksAmbientWithDiffuse = true
        floorNode.geometry?.firstMaterial?.diffuse.wrapS = SCNWrapMode.Repeat
        floorNode.geometry?.firstMaterial?.diffuse.wrapT = SCNWrapMode.Repeat
        floorNode.geometry?.firstMaterial?.diffuse.mipFilter = SCNFilterMode.Linear
        floorNode.position = SCNVector3Make(0, 0, 0)
        scene.rootNode.addChildNode(floorNode)
    }
    
    func handleTap(gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        
        //changeCameraView()
        moveToExperiment1()
       
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
