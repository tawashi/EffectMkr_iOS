//
//  GameScene.swift
//  EffectMkr
//
//  Created by SolanaAlfredo on 2/17/18.
//  Copyright © 2018 SolanaAlfredo. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var labelId: SKLabelNode = SKLabelNode(fontNamed: "Helvetica");
    var labelFileName: SKLabelNode = SKLabelNode(fontNamed: "Helvetica");
    var labelWidthFrames: SKLabelNode = SKLabelNode(fontNamed: "Helvetica");
    var labelHeightFrames: SKLabelNode = SKLabelNode(fontNamed: "Helvetica");
    var labelDuration: SKLabelNode = SKLabelNode(fontNamed: "Helvetica");
    var labelScale: SKLabelNode = SKLabelNode(fontNamed: "Helvetica");
    var labelDiffY: SKLabelNode = SKLabelNode(fontNamed: "Helvetica");
    var labelFrames: SKLabelNode = SKLabelNode(fontNamed: "Helvetica");
    var labelSound: SKLabelNode = SKLabelNode(fontNamed: "Helvetica");
    var labelR: SKLabelNode = SKLabelNode(fontNamed: "Helvetica");
    var labelG: SKLabelNode = SKLabelNode(fontNamed: "Helvetica");
    var labelB: SKLabelNode = SKLabelNode(fontNamed: "Helvetica");

    private var spinnyNode : SKShapeNode?
    private var effectBtnSprites : [SKSpriteNode] = []
    private var loadedEffectModel: EffectModel?
    private var effectModels: [EffectModel] = []
    private var sheet: SpriteSheet? //Selected effect's SpriteSheet object

    //As an example I'm loading the json data straight from a String.
    private var testEffectJson: String = "{\"1\":{\"id\":1,\"filename\":\"fx1\",\"h\":5,\"v\":6,\"duration\":1,\"scale\":3,\"y\":0,\"r\":255,\"g\":255,\"b\":255,\"frames\":\"\",\"sound\":\"\"},\"2\":{\"id\":2,\"filename\":\"fx2\",\"h\":5,\"v\":3,\"duration\":1,\"scale\":2,\"y\":0,\"r\":255,\"g\":255,\"b\":255,\"frames\":\"\",\"sound\":\"\"}}"
    
    override func didMove(to view: SKView) {
        var allEffectsJsonDictionary: Dictionary<String,Any>?

        do{
            let data = testEffectJson.data(using: String.Encoding.utf8)
            let json =  try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves)

            allEffectsJsonDictionary =  json as! Dictionary<String,Any>

            //Buttons panel offset
            //TODO : Create a decent panel
            var x: CGFloat = -self.frame.size.width/2
            for (_, value) in allEffectsJsonDictionary! {
                let m = value as! Dictionary<String,Any>
                let eModel = EffectModel(json: m)
                effectModels.append(eModel!);

                x += 150;
                //Create a Select button for every effect
                if let effectId: Int = eModel?.id {
                    let effectIdStr = String(effectId)
                    addHudBtn(with: (eModel?.fileName)!, positionX: x, tag: effectIdStr)
                }
            }
        }catch let error {
            print(error.localizedDescription)
        }
        initializeLabelsPositions()
        loadEffectAnimation(with: effectModels[0].id)

    }

    func loadEffectAnimation(with id: Int) {
        loadedEffectModel = effectModels.first(where: { $0.id == id })!
        fillLabels(with: loadedEffectModel!)
        sheet = SpriteSheet(effectModel: loadedEffectModel!);
    }

    func initializeLabelsPositions() {
        var y: CGFloat = -150
        let yGap: CGFloat = 55
        labelId.position = CGPoint(x: 0, y: y)
        self.addChild(labelId)
        y += yGap
        labelFileName.position = CGPoint(x: 0, y: y)
        self.addChild(labelFileName)
        y += yGap
        labelWidthFrames.position = CGPoint(x: 0, y: y)
        self.addChild(labelWidthFrames)
        y += yGap
        labelHeightFrames.position = CGPoint(x: 0, y: y)
        self.addChild(labelHeightFrames)
        y += yGap
        labelDuration.position = CGPoint(x: 0, y: y)
        self.addChild(labelDuration)
        y += yGap
        labelScale.position = CGPoint(x: 0, y: y)
        self.addChild(labelScale)
        y += yGap
        labelDiffY.position = CGPoint(x: 0, y: y)
        self.addChild(labelDiffY)
        y += yGap
        labelFrames.position = CGPoint(x: 0, y: y)
        self.addChild(labelFrames)
        y += yGap
        labelSound.position = CGPoint(x: 0, y: y)
        self.addChild(labelSound)
        y += yGap
        labelR.position = CGPoint(x: 0, y: y)
        self.addChild(labelR)
        y += yGap
        labelG.position = CGPoint(x: 0, y: y)
        self.addChild(labelG)
        y += yGap
        labelB.position = CGPoint(x: 0, y: y)
        self.addChild(labelB)
    }

    func fillLabels(with model: EffectModel) {
        if let id = loadedEffectModel?.id {
            labelId.text = "Id: \(String(id))"
        }
        labelId.fontColor = UIColor.gray
        labelId.fontSize = 20

        if let fileName = loadedEffectModel?.fileName {
            labelFileName.text = "Filename: \(fileName)"
        }
        labelFileName.fontColor = UIColor.gray
        labelFileName.fontSize = 20

        if let width = loadedEffectModel?.width {
            labelWidthFrames.text = "Width: \(width)"
        }
        labelWidthFrames.fontSize = 20
        labelWidthFrames.fontColor = UIColor.gray

        if let height = loadedEffectModel?.height {
            labelHeightFrames.text = "Height: \(height)"
        }
        labelHeightFrames.fontSize = 20
        labelHeightFrames.fontColor = UIColor.gray

        if let duration = loadedEffectModel?.duration {
            labelDuration.text = "Duration: \(duration)"
        }
        labelDuration.fontSize = 20
        labelDuration.fontColor = UIColor.gray

        if let scale = loadedEffectModel?.scale {
            labelScale.text = "Scale: \(scale)"
        }
        labelScale.fontSize = 20
        labelScale.fontColor = UIColor.gray

        if let diffY = loadedEffectModel?.diffY {
            labelDiffY.text = "DiffY: \(diffY)"
        }
        labelDiffY.fontSize = 20
        labelDiffY.fontColor = UIColor.gray

        if let frames = loadedEffectModel?.frames {
            labelFrames.text = "Frames: \(frames)"
        }
        labelFrames.fontSize = 20
        labelFrames.fontColor = UIColor.gray

        if let sound = loadedEffectModel?.sound {
            labelSound.text = "Sound: \(sound)"
        }
        labelSound.fontSize = 20
        labelSound.fontColor = UIColor.gray

        if let colorR = loadedEffectModel?.colorR {
            labelR.text = "Color R: \(colorR)"
        }
        labelR.fontSize = 20
        labelR.fontColor = UIColor.gray

        if let colorG = loadedEffectModel?.colorG {
            labelG.text = "Color G: \(colorG)"
        }
        labelG.fontSize = 20
        labelG.fontColor = UIColor.gray

        if let colorB = loadedEffectModel?.colorB {
            labelB.text = "Color B: \(colorB)"
        }
        labelB.fontSize = 20
        labelB.fontColor = UIColor.gray
    }

    func addHudBtn(with name: String, positionX: CGFloat, tag:String) {
        //Buttons
        backgroundColor = SKColor.white
        let btnImgName = name + "_icon"
        let buttonTexture: SKTexture! = SKTexture(imageNamed: btnImgName)
        let buttonTextureSelected: SKTexture! = SKTexture(imageNamed: btnImgName)
        
        let button = ButtonNode(normalTexture: buttonTexture, selectedTexture: buttonTextureSelected, disabledTexture: buttonTexture)
        button.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(GameScene.buttonTap(from:)))
        button.position = CGPoint(x: positionX, y: CGFloat(-self.frame.size.height/2 + buttonTexture.size().height/2 + 8))
        button.zPosition = 1
        button.name = tag
        self.addChild(button)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        let n: SKSpriteNode = SKSpriteNode(texture: sheet!.getEffectFrames()[0])
            n.position = pos;
            self.addChild(n);
            let animateAction = SKAction.animate(with: sheet!.getEffectFrames(), timePerFrame:TimeInterval((loadedEffectModel?.duration)!/Float(sheet!.getEffectFrames().count)), resize: false, restore: true)
            let doneAction = SKAction.run {
                n.removeFromParent()
            }

            n.run(SKAction.sequence([animateAction, doneAction]))
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }

    @objc func buttonTap(from origin: ButtonNode) {
        loadEffectAnimation(with: Int(origin.name!)!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }

    override func update(_ currentTime: TimeInterval) {
    }
}
