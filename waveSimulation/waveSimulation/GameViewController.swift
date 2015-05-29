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
    
    var leapButton: UIButton!
    var classicButton: UIButton!
    
    var label1: UILabel!
    var label2: UILabel!
    var center: SCNNode!
    var electron: SCNNode!
    var electron2: SCNNode!
    var scnView: SCNView!
    
    var room2: SCNNode!
    var inExperiment = 0
    
    var particles: SCNParticleSystem!
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
            
            for var i = 1; i < 16; ++i{
                
                arrayOfWaves.addObject(SCNScene(named: "art.scnassets/Waves4/\(i).dae")!.rootNode)
                println(i)
            }
        
        
        setup()
        
        
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
            label1 = UILabel(frame : CGRect(x: screenWidth/4.8, y: 20, width: 200, height: 60))
            label2 = UILabel(frame : CGRect(x: screenWidth/1.1, y: 20, width: 200, height: 60))
            label1.font = UIFont.systemFontOfSize(17.0)
            label2.font = UIFont.systemFontOfSize(17.0)
            
        }
        else
        {
            // Iphone
            
            cameraButton = UIButton(frame : CGRect(x:screenWidth - 80, y: 10, width: 50, height:44))
            backButton = UIButton(frame : CGRect(x: 10, y: 10, width: 60, height: 40))
            
            label1 = UILabel(frame : CGRect(x: screenWidth/4.8, y: 20, width: 160, height: 60))
            
            label2 = UILabel(frame : CGRect(x: screenWidth/1.1, y: 20, width: 150, height: 60))
            
            label1.center = CGPoint(x: screenWidth/4, y: screenHeight - 25)
            label2.center = CGPoint(x: screenWidth/1.25, y: screenHeight - 25)
            
            
            attrs = [NSFontAttributeName : UIFont.systemFontOfSize(20.0)]
        }
        
        label1.center = CGPoint(x: screenWidth/4.5, y: screenHeight - 25)
        label2.center = CGPoint(x: screenWidth/1.22, y: screenHeight - 25)
        
        label1.text = "⬅︎ Quantum behavior"
        label2.text = "Classic behavior ➡︎"
        label1.textColor = UIColor.whiteColor()
        label2.textColor = UIColor.whiteColor()
        
        
        leapButton = UIButton(frame: CGRect(x: screenWidth / 4.6, y: screenHeight - 25, width: 60, height: 60))
        leapButton.setTitle("ⓘ", forState: UIControlState.Normal)
        leapButton.titleLabel?.textColor = UIColor.whiteColor()
        leapButton.titleLabel?.font = UIFont.systemFontOfSize(21.0)
        leapButton.center = CGPoint(x: screenWidth/3.2, y: screenHeight - 24)
        leapButton.addTarget(self, action: "moveToLeapDescription", forControlEvents:.TouchUpInside)
        classicButton = UIButton(frame: CGRect(x: screenWidth / 1.3, y: screenHeight - 25, width: 60, height: 60))
        classicButton.setTitle("ⓘ", forState: UIControlState.Normal)
        classicButton.titleLabel?.textColor = UIColor.whiteColor()
        classicButton.titleLabel?.font = UIFont.systemFontOfSize(21.0)
        classicButton.center = CGPoint(x: screenWidth/1.44, y: screenHeight - 24)
        
        
        Menu.addSubview(leapButton)
        Menu.addSubview(classicButton)
        
        Menu.addSubview(label1)
        Menu.addSubview(label2)
        
        cameraButton.backgroundColor = UIColor.clearColor()
        cameraButton.addTarget(self, action: "changeCameraView", forControlEvents:.TouchUpInside)
        
        
        
        let img = UIImage(named: "camera.png")! as UIImage
        cameraButton.setImage(img, forState: UIControlState.Normal)
        self.view.addSubview(cameraButton)
        
        let scene4 = SCNScene(named: "art.scnassets/ExperimentRoom.dae")!
        
        wallX = scene4.rootNode.childNodeWithName("fade", recursively: true)!
        room2 = scene4.rootNode.childNodeWithName("SketchUp", recursively: true)
        
        
        backButton.backgroundColor = nil
        
        backButton.setAttributedTitle(NSMutableAttributedString(string: "Back", attributes: attrs ), forState: UIControlState.Normal)
        backButton.titleLabel?.font = UIFont(name: "calibri", size: 16)
        backButton.titleLabel?.textColor = UIColor.whiteColor()
        backButton.addTarget(self, action: "openMenu", forControlEvents:.TouchUpInside)
        self.view.addSubview(backButton)
        
      
        backButton.hidden = true
        cameraButton.hidden = true
        
    }
    
    func moveToLeapDescription(){
        SCNTransaction.begin()
        SCNTransaction.setAnimationDuration(0.5)
            electron.position.z -= 36
            electron.position.x -= 1.2
        
            cameraNode.position.z -= 40
        SCNTransaction.commit()
    }
    
    func setup(){
        UIApplication.sharedApplication().idleTimerDisabled = true
        
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
        
        
        
        
        
        
        
        // place the camera
        cameraNode.position = SCNVector3(x: 70, y: 0, z: 15)
        
        center = SCNNode()
        center.position = SCNVector3(x: 70, y: 0, z: 0)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 15, y: 10, z: 10)
        lightNode.light?.color = UIColor.grayColor()
        scene.rootNode.addChildNode(lightNode)
        
        var lightNode2: SCNNode = lightNode.clone() as! SCNNode
        lightNode2.position = SCNVector3(x: 140, y: 10, z: -26)
        lightNode2.light!.type = SCNLightTypeOmni
        lightNode.light?.color = UIColor.grayColor()
        scene.rootNode.addChildNode(lightNode2)
        
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
        
        
        
        
        placeElectrons()
        
        
        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad)
        {
            // Ipad
            
        }
        else
        {
            // Iphone
            
        }
    }
    
    func placeElectrons(){
        let scene2 = SCNScene(named: "art.scnassets/fastOrbit.dae")!
        electron = scene2.rootNode.childNodeWithName("electro", recursively: true)!
        var electronM = scene2.rootNode.childNodeWithName("nucleo", recursively: true)!
        electronM.geometry?.subdivisionLevel = 2
        
        electronM.geometry?.firstMaterial?.emission.contents = CGFloat(1)
        
        electron.position = SCNVector3(x: 65, y: 0, z: 0)
        electron.scale = SCNVector3Make(0.9, 0.9, 0.9)
        
        
        let spin = CABasicAnimation(keyPath: "rotation")
        spin.fromValue = NSValue(SCNVector4: SCNVector4(x: 1, y: 1, z: 0, w: 0))
        spin.toValue = NSValue(SCNVector4: SCNVector4(x: 1, y:1, z: 0, w: 2 * Float(M_PI)))
        spin.duration = 2
        spin.repeatCount = .infinity
        electron.addAnimation(spin, forKey: "spin around")
        
        let scene3 = SCNScene(named: "art.scnassets/fastOrbit.dae")!
        electron2 = scene3.rootNode.childNodeWithName("electro", recursively: true)!
        electron2.addAnimation(spin, forKey: "spin around")
        let n = scene3.rootNode.childNodeWithName("nucleo", recursively: true)!
        n.geometry?.subdivisionLevel = 2
        n.geometry?.firstMaterial?.emission.contents = CGFloat(1)
        
        
        
        
        var material1 = SCNMaterial()
        material1.diffuse.contents = UIColor(red: 0.7, green: 0.1, blue: 0.2, alpha: 1)
        material1.specular.contents = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1)
        material1.emission.contents = UIColor(red: 0.1, green: 0, blue: 0, alpha: 1)
        material1.shininess = CGFloat(0.1)
        var material2 = SCNMaterial()
        material2.diffuse.contents = UIColor(red: 0.47, green: 0.3, blue: 0.9, alpha: 0.8)
        material2.specular.contents = UIColor(red: 1, green: 0.2, blue: 0.2, alpha: 1)
        
        
        electron2.position = SCNVector3(x: 75, y: 0, z: 0)
        electron2.scale = SCNVector3Make(0.9, 0.9, 0.9)
        for var i = 0; i < 3; ++i{
            var x = electron.childNodeWithName("\(i+1)", recursively: true)!
            var y = electron.childNodeWithName("orbit\(i+1)", recursively: true)!
            x.geometry?.firstMaterial = material1
            y.geometry?.firstMaterial = material2
           
            var x2 = electron2.childNodeWithName("\(i+1)", recursively: true)!
            var y2 = electron2.childNodeWithName("orbit\(i+1)", recursively: true)!
            x2.geometry?.firstMaterial = material1
            y2.geometry?.firstMaterial = material2
            
        }
        scene.rootNode.addChildNode(electron)
        scene.rootNode.addChildNode(electron2)
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
        cameraNode.camera?.xFov = 60
        room2.hidden = true
        rightButton.enabled = true
        leftButton.enabled = true
        rightButton.hidden = false
        leftButton.hidden = false
        backButton.hidden = true
        
        cameraButton.hidden = true
        
        label1.hidden = false
        label2.hidden = false
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
        label1.hidden = true
        label2.hidden = true
        moveToExperiment2()
        texture.opacity = 1
        
    }
    
    func rightButtonClick(){
        print("r")
        rightButton.enabled = false
        leftButton.enabled = false
        rightButton.hidden = true
        leftButton.hidden = true
        label1.hidden = true
        label2.hidden = true
        wallX.opacity = 1
        backButton.hidden = false
        cameraButton.hidden = false
        moveToExperiment1()
    }
    
    var cameraButton: UIButton!
    var wallX: SCNNode!
    
    var room2center: SCNNode!
    
    func moveToExperiment1(){
        let scene4 = SCNScene(named: "art.scnassets/ExperimentRoom.dae")!
        
        inExperiment = 1
        
        alphaValue = 1
        cameraPoint = 2
        
        

        
        
        if(particles == nil)
        {
            room2 = scene4.rootNode.childNodeWithName("SketchUp", recursively: true)!
            room2.scale = SCNVector3Make(0.2, 0.2, 0.2)
            room2.position = SCNVector3Make(140, -2.8, 0)
            
            let wall1 = scene4.rootNode.childNodeWithName("wall1", recursively: true)!
            let wall2 = scene4.rootNode.childNodeWithName("wall2", recursively: true)!
            let wall3 = scene4.rootNode.childNodeWithName("wall3", recursively: true)!
            room2center = scene4.rootNode.childNodeWithName("x", recursively: true)!
            
            
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
            scene.rootNode.addChildNode(room2)
            
            wallX = scene.rootNode.childNodeWithName("fade", recursively: true)!
        }
        
        readyToWave()
        room2.hidden = false
        self.cameraNode.constraints = [SCNLookAtConstraint(target: room2center)]
        
        //cameraNode.eulerAngles.x = 0
        
        SCNTransaction.begin()
        SCNTransaction.setAnimationDuration(0.5)
        
            cameraNode.position = SCNVector3(x: 140, y: 8, z: 25)
        
        SCNTransaction.commit()

    }
    
    var layerCounter = 1
    func leap(){
        
        if layerCounter == 1{
            electron2 = scene.rootNode.childNodeWithName("3", recursively: true)!
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
                self.cameraNode.position = SCNVector3(x: 3.35, y: 10, z: 15)
                self.cameraPoint = 2
                self.cameraNode.eulerAngles.x = 0
            case 2:
                self.cameraNode.position = SCNVector3(x: 3.5, y: 80, z: 15)
                self.cameraPoint = 3
                self.cameraNode.eulerAngles.x = 0
            case 3:
                self.cameraNode.position = SCNVector3(x: 70, y: 23, z: 35)
                self.cameraPoint = 4
                
                self.cameraNode.eulerAngles.x = 25.5
            case 4:
                self.cameraNode.position = SCNVector3(x: 3.5, y: -33, z: 60)
                self.cameraNode.eulerAngles.x = 0
                self.cameraPoint = 0
            default:
                break
            }
            var point = SCNNode()
            if cameraPoint == 2 {
                point = self.scene.rootNode.childNodeWithName("w", recursively: true)!
                cameraNode.camera?.xFov = 90
                
            }else{
//                if cameraPoint == 5 {
//                    point = self.scene.rootNode.childNodeWithName("text", recursively: true)!
//                    cameraNode.camera?.xFov = 90
//                }else{
                point = self.scene.rootNode.childNodeWithName("point", recursively: true)!
                cameraNode.camera?.xFov = 60
                //}
            }
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
        
        
        if alphaValue > 0{
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
