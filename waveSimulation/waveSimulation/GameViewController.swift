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

    var Menu: UIView!
    var leftButton: UIButton!
    var rightButton: UIButton!
    var center: SCNNode!
    var electron: SCNNode!
    var scnView: SCNView!
    
    var room2: SCNNode!
    var inExperiment = 0
    
    var particles: SCNParticleSystem!
    

    
    
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
        electron = scene2.rootNode.childNodeWithName("electro", recursively: true)!
        
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
        
        center = SCNNode()
        center.position = SCNVector3(x: 70, y: 0, z: 0)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        lightNode.light?.color = UIColor.grayColor()
        scene.rootNode.addChildNode(lightNode)
        
        var lightNode2: SCNNode = lightNode.clone() as! SCNNode
        lightNode2.position = SCNVector3(x: 140, y: 10, z: 10)
        lightNode2.light!.type = SCNLightTypeOmni
        lightNode.light?.color = UIColor.grayColor()
        //scene.rootNode.addChildNode(lightNode2)
        
//        // create and add a third light to the scene
//        let lightNode3 = SCNNode()
//        lightNode3.light = SCNLight()
//        lightNode3.light!.type = SCNLightTypeOmni
//        lightNode3.position = SCNVector3(x: 70, y: 10, z: 10)
//        lightNode3.light?.color = UIColor.grayColor()
//        scene.rootNode.addChildNode(lightNode3)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor.darkGrayColor()
        scene.rootNode.addChildNode(ambientLightNode)
        
        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad)
        {
            // Ipad
            
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
        }
        else
        {
            // Iphone
            
            for var i = 1; i < 16; ++i{
                
                var x = SCNScene(named: "art.scnassets/frames3/\(i).dae")!
                var waveNode1 = x.rootNode.childNodeWithName("Cube", recursively: true)!
                var waveNode2 = x.rootNode.childNodeWithName("Plane", recursively: true)!
                
                var waveNode = SCNNode()
                waveNode.addChildNode(waveNode1)
                waveNode.addChildNode(waveNode2)
                arrayOfWaves.addObject(waveNode)
                
                println(i)
            }
            
            
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
        
        
        scnView.pointOfView = cameraNode
        
        if Menu == nil{
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            let screenWidth = screenSize.width;
            let screenHeight = screenSize.height;
            
            Menu = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight ))
            Menu.backgroundColor = UIColor.clearColor()
            leftButton = UIButton(frame : CGRect(x:0, y: 0, width: screenWidth/2, height:screenHeight ))
            leftButton.addTarget(self, action: "leftButtonClick", forControlEvents: .TouchUpInside)
            Menu.addSubview(leftButton)
            rightButton = UIButton(frame: CGRect(x: screenWidth/2, y:0, width: screenWidth/2, height:screenHeight))
            rightButton.addTarget(self, action: "rightButtonClick", forControlEvents:.TouchUpInside)
            Menu.addSubview(rightButton)
            
        }
        self.view.addSubview(Menu)
        
        var attrs = [NSFontAttributeName : UIFont.systemFontOfSize(25.0)]
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width;
        let screenHeight = screenSize.height;
        
        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad)
        {
            // Ipad
            
            cameraButton = UIButton(frame : CGRect(x:screenWidth - 80, y: 10, width: 60, height:60 ))
            backButton = UIButton(frame : CGRect(x: 10, y: 10, width: 90, height:60 ))
        }
        else
        {
            // Iphone
            
            cameraButton = UIButton(frame : CGRect(x:screenWidth - 80, y: 10, width: 50, height:44))
            backButton = UIButton(frame : CGRect(x: 10, y: 10, width: 60, height: 44))
            
            attrs = [NSFontAttributeName : UIFont.systemFontOfSize(20.0)]
        }
        
        cameraButton.backgroundColor = UIColor.clearColor()
        cameraButton.addTarget(self, action: "changeCameraView", forControlEvents:.TouchUpInside)
        
        
        
        let img = UIImage(named: "camera.png")! as UIImage
        cameraButton.setImage(img, forState: UIControlState.Normal)
        self.view.addSubview(cameraButton)
        
        let scene4 = SCNScene(named: "art.scnassets/ExperimentRoom.dae")!
        
        wallX = scene4.rootNode.childNodeWithName("fade", recursively: true)!
        room2 = scene4.rootNode.childNodeWithName("SketchUp", recursively: true)
        
        
        backButton.backgroundColor = UIColor.grayColor()
        backButton.setAttributedTitle(NSMutableAttributedString(string: "Menu", attributes: attrs), forState: UIControlState.Normal)
        backButton.addTarget(self, action: "openMenu", forControlEvents:.TouchUpInside)
        self.view.addSubview(backButton)
        
      
        backButton.hidden = true
        cameraButton.hidden = true
        
    }
    
    func moveToExperiment2(){
        SCNTransaction.begin()
        SCNTransaction.setAnimationDuration(0.5)
        self.cameraNode.position = SCNVector3(x: 3.5, y: 15, z: 60)
        self.cameraPoint = 1
        let point = self.scene.rootNode.childNodeWithName("point", recursively: true)!
        self.cameraNode.constraints = [SCNLookAtConstraint(target: point)] // pov is the camera
        readyToWave()
        
        inExperiment = 2
        SCNTransaction.commit()
    }
    
    func openMenu(){
        cameraNode.position = SCNVector3(x: 70, y: 0, z: 15)
        self.cameraNode.eulerAngles.x = 0
        self.cameraNode.eulerAngles.y = 0
        self.cameraNode.constraints = [SCNLookAtConstraint(target: center)] // pov is the camera
        room2.hidden = true
        rightButton.enabled = true
        leftButton.enabled = true
        rightButton.hidden = false
        leftButton.hidden = false
        backButton.hidden = true
        cameraButton.hidden = true
    }
    
    var backButton: UIButton!
    
    
    func leftButtonClick(){
        print("l")
        rightButton.enabled = false
        leftButton.enabled = false
        rightButton.hidden = true
        leftButton.hidden = true
        backButton.hidden = false
        cameraButton.hidden = false
        moveToExperiment2()
        texture.opacity = 1
        
    }
    
    func rightButtonClick(){
        print("r")
        rightButton.enabled = false
        leftButton.enabled = false
        rightButton.hidden = true
        leftButton.hidden = true
        wallX.opacity = 1
        backButton.hidden = false
        cameraButton.hidden = false
        moveToExperiment1()
    }
    
    var cameraButton: UIButton!
    var wallX: SCNNode!
    
    
    
    func moveToExperiment1(){
        let scene4 = SCNScene(named: "art.scnassets/ExperimentRoom.dae")!
        
        inExperiment = 1
        
        readyToWave()

        
        room2 = scene4.rootNode.childNodeWithName("SketchUp", recursively: true)!
        room2.scale = SCNVector3Make(0.2, 0.2, 0.2)
        room2.position = SCNVector3Make(140, -2.8, 0)
        room2.hidden = false
        let wall1 = scene4.rootNode.childNodeWithName("wall1", recursively: true)!
        let wall2 = scene4.rootNode.childNodeWithName("wall2", recursively: true)!
        let wall3 = scene4.rootNode.childNodeWithName("wall3", recursively: true)!
        let center = scene4.rootNode.childNodeWithName("x", recursively: true)!
        self.cameraNode.constraints = [SCNLookAtConstraint(target: center)] // pov is the camera
        
        if(particles == nil)
        {
            particles = SCNParticleSystem(named: "atoms.scnp", inDirectory: "")
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
        }
        
 
        scene.rootNode.addChildNode(room2)
        
        wallX = scene.rootNode.childNodeWithName("fade", recursively: true)!
        
        
        cameraNode.eulerAngles.x = 0
        
        SCNTransaction.begin()
        SCNTransaction.setAnimationDuration(0.5)
        
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
      
        if inExperiment == 1{
            //fim
            switch self.cameraPoint{
            case 0:
                self.cameraNode.position = SCNVector3(x: 140, y: 8, z: 25)
                self.cameraNode.eulerAngles.x = 0
                self.cameraPoint = 2
            case 1:
                self.cameraNode.position = SCNVector3(x: 140, y: 8, z: 25)
                self.cameraNode.eulerAngles.x = 0
                self.cameraPoint = 2
            case 2:
                self.cameraNode.position = SCNVector3(x: 140, y: 60, z: 15)
                self.cameraPoint = 3
                self.cameraNode.eulerAngles.x = 0
            case 3:
                self.cameraNode.position = SCNVector3(x: 200, y: 17, z: 35)
                self.cameraPoint = 0
                
                self.cameraNode.eulerAngles.x = 25.5
            default:
                break
            }
            let point = self.scene.rootNode.childNodeWithName("x", recursively: true)!
            self.cameraNode.constraints = [SCNLookAtConstraint(target: point)] // pov is the camera
            
        }
        
        if inExperiment == 2{
            
            //fim
            switch self.cameraPoint{
            case 0:
                self.cameraNode.position = SCNVector3(x: 3.5, y: 15, z: 60)
                self.cameraNode.eulerAngles.x = 0
                self.cameraPoint = 1
            case 1:
                self.cameraNode.position = SCNVector3(x: 3.5, y: -30, z: 55)
                self.cameraNode.eulerAngles.x = 0
                self.cameraPoint = 2
            case 2:
                self.cameraNode.position = SCNVector3(x: 3.5, y: 80, z: 15)
                self.cameraPoint = 3
                self.cameraNode.eulerAngles.x = 0
            case 3:
                self.cameraNode.position = SCNVector3(x: 70, y: 17, z: 35)
                self.cameraPoint = 0
                
                self.cameraNode.eulerAngles.x = 25.5
            default:
                break
            }
            let point = self.scene.rootNode.childNodeWithName("point", recursively: true)!
            self.cameraNode.constraints = [SCNLookAtConstraint(target: point)] // pov is the camera
        }
        

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
        alphaValue = CGFloat(1)
        delay = 600;
    }
    
    var alphaValue = CGFloat(1)
    var texture: SCNNode!
    var delay = 0
    var ready = true
    func renderer(aRenderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
        
        
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
