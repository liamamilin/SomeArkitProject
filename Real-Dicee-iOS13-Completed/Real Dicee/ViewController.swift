//
//  ViewController.swift
//  Real Dicee
//
//  Created by Angela Yu on 12/07/2017.
//  Copyright © 2017 Angela Yu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]

//        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)

//        let sphere = SCNSphere(radius: 0.2)
//
//        let material = SCNMaterial()
//
//        material.diffuse.contents = UIImage(named: "art.scnassets/moon.jpg")
//
//        sphere.materials = [material]
//
//        let node = SCNNode()
//
//        node.position = SCNVector3(x: 0, y: 0.1, z: -0.5)
//
//        node.geometry = sphere
//
//        sceneView.scene.rootNode.addChildNode(node)

        sceneView.autoenablesDefaultLighting = true

      
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection =  [.horizontal,.vertical]
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { // 1  点击
 
        if let touch = touches.first { // 2 获取第一次点击
            
            let touchLocation = touch.location(in: sceneView)
            /* hitter 不太用了
             // 3 获取点击的位置
             
             if let rayresult = sceneView.raycastQuery(from: touchLocation, allowing: .estimatedPlane, alignment: .any){
                 let result = sceneView.session.raycast(rayresult)
                 result.first
             }

            */
  
             
            
            let results = sceneView.hitTest(touchLocation, types:.estimatedHorizontalPlane) //4 生成检测对象
            
            if let hitResult = results.first { // 5

                // Create a new scene
                let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")! //6

                if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) { //7
                    
                    diceNode.position = SCNVector3( // 8
                        x: hitResult.worldTransform.columns.3.x,
                        y: hitResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
                        z: hitResult.worldTransform.columns.3.z
                    )

                    sceneView.scene.rootNode.addChildNode(diceNode)
                    
                    let randomX = Float((arc4random_uniform(4) + 1)) * (Float.pi/2)
                    //        let randomY = Double((arc4random_uniform(10) + 11)) * (Double.pi/2)
                    let randomZ = Float((arc4random_uniform(4) + 1)) * (Float.pi/2)
                    
                    diceNode.runAction(SCNAction.rotateBy(x: CGFloat(randomX * 5), y: 0, z: CGFloat(randomZ * 5), duration: 0.5)) // 9

                }
                
            }
            
        }
    }
    
    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        if anchor is ARPlaneAnchor { // 10

            
            print("plane detected")
            
            let planeAnchor = anchor as! ARPlaneAnchor //11

            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))  //12
            //plane.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            plane.materials = [gridMaterial]
            
            let planeNode = SCNNode()

            planeNode.geometry = plane
            planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0) //13
            
            node.addChildNode(planeNode)
            //self.sceneView.scene.rootNode.addChildNode(<#T##child: SCNNode##SCNNode#>)
            return(node)
            
        } else {
            return(nil)
        }
    }
    /*
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if anchor is ARPlaneAnchor { // 10
            
            print("plane detected")
            
            let planeAnchor = anchor as! ARPlaneAnchor //11

            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))  //12
            
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            plane.materials = [gridMaterial]
            
            let planeNode = SCNNode()

            planeNode.geometry = plane
            planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0) //13
            
            node.addChildNode(planeNode)
            
        } else {
            return
        }
        
        //guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
    }
 */


}
