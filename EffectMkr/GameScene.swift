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

    private var effectBtnSprites : [SKSpriteNode] = []
    private var loadedEffectModel: EffectModel!
    private var effectModels: [EffectModel] = []
    private var sheet: SpriteSheet! //Selected effect's SpriteSheet object
    
    private var onDisplayEffectId = 0;

    //Test json
    //private var testEffectJson: String = "{\"1\":{\"id\":1,\"filename\":\"fx1\",\"h\":5,\"v\":6,\"duration\":1,\"scale\":1,\"y\":0,\"r\":255,\"g\":255,\"b\":255,\"frames\":\"\",\"sound\":\"\"},\"2\":{\"id\":2,\"filename\":\"fx1\",\"h\":5,\"v\":6,\"duration\":1.2,\"scale\":3,\"y\":0,\"r\":245,\"g\":245,\"b\":255,\"frames\":\"[29-0]\",\"sound\":\"\"},\"3\":{\"id\":3,\"filename\":\"fx1\",\"h\":5,\"v\":6,\"duration\":1,\"scale\":3,\"y\":0,\"r\":255,\"g\":0,\"b\":0,\"frames\":\"\",\"sound\":\"\"},\"4\":{\"id\":4,\"filename\":\"fx1\",\"h\":5,\"v\":6,\"duration\":1,\"scale\":3,\"y\":0,\"r\":0,\"g\":250,\"b\":220,\"frames\":\"[29-0]\",\"sound\":\"\"},\"5\":{\"id\":5,\"filename\":\"fx1\",\"h\":5,\"v\":6,\"duration\":3,\"scale\":3,\"y\":0,\"r\":255,\"g\":255,\"b\":255,\"frames\":\"[0-9],[7-9],[7-9],[7-9],[7-9],[7-9],[7-9],[8-0]\",\"sound\":\"\"},\"6\":{\"id\":6,\"filename\":\"fx1\",\"h\":5,\"v\":6,\"duration\":1.5,\"scale\":2,\"y\":0,\"r\":205,\"g\":255,\"b\":205,\"frames\":\"[0-7],[24-29]\",\"sound\":\"\"}}"
    private var testEffectJson: String = "{\"1\":{\"id\":1,\"filename\":\"fx1\",\"h\":5,\"v\":6,\"duration\":1,\"scale\":1,\"y\":0,\"r\":255,\"g\":255,\"b\":255,\"frames\":\"\",\"sound\":\"\"},\"2\":{\"id\":2,\"filename\":\"fx1\",\"h\":5,\"v\":6,\"duration\":1.2,\"scale\":2,\"y\":0,\"r\":245,\"g\":245,\"b\":255,\"frames\":\"[29-0]\",\"sound\":\"\"},\"3\":{\"id\":3,\"filename\":\"fx1\",\"h\":5,\"v\":6,\"duration\":1,\"scale\":3,\"y\":0,\"r\":255,\"g\":0,\"b\":0,\"frames\":\"\",\"sound\":\"\"},\"4\":{\"id\":4,\"filename\":\"fx1\",\"h\":5,\"v\":6,\"duration\":1,\"scale\":3,\"y\":0,\"r\":0,\"g\":250,\"b\":220,\"frames\":\"[29-0]\",\"sound\":\"\"},\"5\":{\"id\":5,\"filename\":\"fx1\",\"h\":5,\"v\":6,\"duration\":3,\"scale\":3,\"y\":0,\"r\":255,\"g\":255,\"b\":255,\"frames\":\"[0-9],[7-9],[7-9],[7-9],[7-9],[7-9],[7-9],[8-0]\",\"sound\":\"\"},\"6\":{\"id\":6,\"filename\":\"fx1\",\"h\":5,\"v\":6,\"duration\":1.5,\"scale\":2,\"y\":0,\"r\":205,\"g\":255,\"b\":205,\"frames\":\"[0-7],[24-29]\",\"sound\":\"\"}}";
    
    override func didMove(to view: SKView) {
        var allEffectsJsonDictionary: Dictionary<String,Any>?
        backgroundColor = SKColor.white

        do{
            let data = testEffectJson.data(using: String.Encoding.utf8)
            let json =  try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves)

            allEffectsJsonDictionary =  (json as! Dictionary<String,Any>)

            for (_, value) in allEffectsJsonDictionary! {
                let m = value as! Dictionary<String,Any>
                let eModel = EffectModel(json: m)
                effectModels.append(eModel!);
            }
            //Sort effects by id
            effectModels.sort(by: {$0.id < $1.id})
            //Create buttons
            addControlBtns()
        }catch let error {
            print(error.localizedDescription)
        }
        
        initializeLabelsPositions()
        loadedEffectModel = effectModels[onDisplayEffectId]
        loadEffectAnimation()

    }

    func loadEffectAnimation() {
        fillLabels()
        sheet = SpriteSheet(effectModel: loadedEffectModel);
    }

    func initializeLabelsPositions() {
        var y: CGFloat = 100
        let yGap: CGFloat = 45
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

    func fillLabels() {
        
        labelId.text = "Id: \(String(loadedEffectModel.id))"
        labelId.fontColor = UIColor.black
        labelId.fontSize = 26

        
        labelFileName.text = "Filename: \(loadedEffectModel.fileName)"
        labelFileName.fontColor = UIColor.gray
        labelFileName.fontSize = 26

        
        labelWidthFrames.text = "Width: \(loadedEffectModel.width)"
        labelWidthFrames.fontSize = 24
        labelWidthFrames.fontColor = UIColor.gray

        
        labelHeightFrames.text = "Height: \(loadedEffectModel.height)"
        labelHeightFrames.fontSize = 24
        labelHeightFrames.fontColor = UIColor.gray

        
        labelDuration.text = "Duration: \(loadedEffectModel.duration)"
        labelDuration.fontSize = 24
        labelDuration.fontColor = UIColor.gray


        labelScale.text = "Scale: \(loadedEffectModel.scale)"
        labelScale.fontSize = 24
        labelScale.fontColor = UIColor.gray

        
        labelDiffY.text = "DiffY: \(loadedEffectModel.diffY)"
        labelDiffY.fontSize = 24
        labelDiffY.fontColor = UIColor.gray

        
        labelFrames.text = "Frames: \(loadedEffectModel.frames)"
        labelFrames.fontSize = 24
        labelFrames.fontColor = UIColor.gray

        
        labelSound.text = "Sound: \(loadedEffectModel.sound)"
        labelSound.fontSize = 24
        labelSound.fontColor = UIColor.gray

        
        labelR.text = "Color R: \(loadedEffectModel.colorR)"
        labelR.fontSize = 24
        labelR.fontColor = UIColor.gray

        
        labelG.text = "Color G: \(loadedEffectModel.colorG)"
        labelG.fontSize = 24
        labelG.fontColor = UIColor.gray

        
        labelB.text = "Color B: \(loadedEffectModel.colorB)"
        labelB.fontSize = 24
        labelB.fontColor = UIColor.gray
    }

    func addControlBtns() {
        //Back btn
        let backButtonTexture: SKTexture! = SKTexture(imageNamed: "back2.png")
        let backButtonTextureSelected: SKTexture! = SKTexture(imageNamed: "back1.png")
        let backButtonTextureDisable: SKTexture! = SKTexture(imageNamed: "back1.png")
        
        let backButton = ButtonNode(normalTexture: backButtonTexture, selectedTexture: backButtonTextureSelected, disabledTexture: backButtonTextureDisable)
        backButton.anchorPoint = CGPoint(x:0, y:0)
        backButton.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(GameScene.buttonTap(from:)))
        backButton.position = CGPoint(x: -frame.size.width/2 + 20, y: CGFloat(-self.frame.size.height/2) + 20)
        backButton.name = "back"
        self.addChild(backButton)
        
        //Play btn
        let playBtnTexture: SKTexture! = SKTexture(imageNamed: "play2.png")
        let playBtnTextureSelected: SKTexture! = SKTexture(imageNamed: "play1.png")
        let playBtnTextureDisable: SKTexture! = SKTexture(imageNamed: "play1.png")
        
        let playBtn = ButtonNode(normalTexture: playBtnTexture, selectedTexture: playBtnTextureSelected, disabledTexture: playBtnTextureDisable)
        playBtn.anchorPoint = CGPoint(x:0.5, y:0)
        playBtn.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(GameScene.buttonTap(from:)))
        playBtn.position = CGPoint(x: 0, y: CGFloat(-self.frame.size.height/2) + 30)
        playBtn.name = "play"
        self.addChild(playBtn)
        
        //Next btn
        let nextButtonTexture: SKTexture! = SKTexture(imageNamed: "forward2.png")
        let nextButtonTextureSelected: SKTexture! = SKTexture(imageNamed: "forward1.png")
        let nextButtonTextureDisable: SKTexture! = SKTexture(imageNamed: "forward1.png")
        
        let nextButton = ButtonNode(normalTexture: nextButtonTexture, selectedTexture: nextButtonTextureSelected, disabledTexture: nextButtonTextureDisable)
        nextButton.anchorPoint = CGPoint(x:1, y:0)
        nextButton.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(GameScene.buttonTap(from:)))
        nextButton.position = CGPoint(x: frame.size.width/2 - 20, y: CGFloat(-self.frame.size.height/2) + 20)
        nextButton.name = "next"
        self.addChild(nextButton)
        
        //Less btn
        let lessButtonTexture: SKTexture! = SKTexture(imageNamed: "minus2.png")
        let lessButtonTextureSelected: SKTexture! = SKTexture(imageNamed: "minus1.png")
        let lessButtonTextureDisable: SKTexture! = SKTexture(imageNamed: "minus1.png")
        
        let lessButton = ButtonNode(normalTexture: lessButtonTexture, selectedTexture: lessButtonTextureSelected, disabledTexture: lessButtonTextureDisable)
        lessButton.anchorPoint = CGPoint(x:0.5, y:0)
        lessButton.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(GameScene.buttonTap(from:)))
        lessButton.position = CGPoint(x: -frame.size.width/4, y: CGFloat(-self.frame.size.height/2 + 180))
        lessButton.name = "durationLess"
        self.addChild(lessButton)
        
        //Plus btn
        let plusButtonTexture: SKTexture! = SKTexture(imageNamed: "plus2.png")
        let plusButtonTextureSelected: SKTexture! = SKTexture(imageNamed: "plus1.png")
        let plusButtonTextureDisable: SKTexture! = SKTexture(imageNamed: "plus1.png")
        
        let plusButton = ButtonNode(normalTexture: plusButtonTexture, selectedTexture: plusButtonTextureSelected, disabledTexture: plusButtonTextureDisable)
        plusButton.anchorPoint = CGPoint(x:0.5, y:0)
        plusButton.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(GameScene.buttonTap(from:)))
        plusButton.position = CGPoint(x: frame.size.width/4, y: CGFloat(-self.frame.size.height/2 + 180))
        plusButton.name = "durationPlus"
        self.addChild(plusButton)
    }
    
    func runEffect(atPosition pos : CGPoint) {
        let n: SKSpriteNode = SKSpriteNode(texture: sheet.getEffectFrames()[0])
        n.colorBlendFactor = 1
        n.position = pos;
        
        if ((loadedEffectModel.scale != 0)) {
            n.scale(to: CGSize(width: CGFloat(loadedEffectModel.scale) * n.size.width, height: CGFloat(loadedEffectModel.scale) * n.size.width))
        }
        
        self.addChild(n);
        let animateAction = SKAction.animate(with: sheet.getEffectFrames(), timePerFrame:TimeInterval(loadedEffectModel.duration/Float(sheet.getEffectFrames().count)), resize: false, restore: true)
        let doneAction = SKAction.run {
            n.removeFromParent()
        }
        
        n.color = UIColor(red: CGFloat(loadedEffectModel.colorR/255), green: CGFloat(loadedEffectModel.colorG/255), blue: CGFloat(loadedEffectModel.colorB/255), alpha: 1)
        n.run(SKAction.sequence([animateAction, doneAction]))
    }
    
    func touchDown(atPoint pos : CGPoint) {
        runEffect(atPosition: pos)
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }

    @objc func buttonTap(from origin: ButtonNode) {
        if origin.name == "back" {
            if (onDisplayEffectId > 0) {
                onDisplayEffectId -= 1
                loadedEffectModel = effectModels[onDisplayEffectId]
                loadEffectAnimation()
            }
        } else if origin.name == "play" {
            runEffect(atPosition: CGPoint(x: 0, y: -80))
        } else if origin.name == "next" {
            if (onDisplayEffectId + 1 < effectModels.count) {
                onDisplayEffectId += 1
                loadedEffectModel = effectModels[onDisplayEffectId]
                loadEffectAnimation()
            }
        } else if origin.name == "durationPlus" {
            loadedEffectModel.duration += 0.1
            labelDuration.text = "Duration: \(loadedEffectModel.duration)"
            labelDuration.fontColor = UIColor.red
        } else if origin.name == "durationLess" {
            if (loadedEffectModel.duration >= 0.1) {
                loadedEffectModel.duration -= 0.1
                labelDuration.fontColor = UIColor.red
                labelDuration.text = "Duration: \(loadedEffectModel.duration)"
            }
        }
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
