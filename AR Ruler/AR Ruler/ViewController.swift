//
//  ViewController.swift
//  AR Ruler
//
//  Created by Yashraj jadhav on 24/03/22.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var dotNodes = [SCNNode]()
    var textNode = SCNNode()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        
        
}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //pause the View's session
        sceneView.session.pause()
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if dotNodes.count >= 2 {
            for dot in dotNodes {
                dot.removeFromParentNode()
                
            }
            dotNodes = [SCNNode]()
        }
        if let touchLocation = touches.first?.location(in: sceneView) {
            let hitTestResult = sceneView.hitTest(touchLocation, types: .featurePoint)
            if let hitResult = hitTestResult.first {
                addDot(at: hitResult)
            }
            
        }}
        func addDot (at hitResult : ARHitTestResult) {
            let dotGeometery = SCNSphere(radius: 0.005)
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.red
            
            dotGeometery.materials = [material]
            
            let dotNode = SCNNode(geometry: dotGeometery)
            
            dotNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y
                                          , hitResult.worldTransform.columns.3.z)
            sceneView.scene.rootNode.addChildNode(dotNode)
            
            dotNodes.append(dotNode)
            if dotNodes.count >= 2 {
                calculate()
            }
        }
    
    func calculate () {
        let start = dotNodes[0]
        let end = dotNodes[1]
      
    
        
        print(start.position)
        print(end.position)
        
       // distance = √ ((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2)
        
        // lets convert this raw eqn to swift code
        
        let a = end.position.x - start.position.x
        let b = end.position.y - start.position.y
        let c = end.position.z - start.position.z
        
        let distance = sqrt(pow(a, 2) + pow(b, 2) + pow(c, 2))
    //    print(abs(distance))  // abs (absolute) is used to remove the + or - sign of the calculation result .
        
        updateText(text: "\(abs(distance))", atPosition: end.position)
    }
    func updateText(text: String, atPosition position: SCNVector3) {
        textNode.removeFromParentNode()
        
        
        let textGeometery = SCNText(string: text, extrusionDepth: 1.0)
        textGeometery.firstMaterial?.diffuse.contents = UIColor.white
        
         textNode = SCNNode(geometry: textGeometery)
      
        textNode.position = SCNVector3(position.x, position.y + 0.01 , position.z)
        
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        sceneView.scene.rootNode.addChildNode(textNode)
        
    }
    
    }



