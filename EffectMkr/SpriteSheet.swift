//
//  SpriteSheet.swift
//  EffectMkr
//
//  Created by SolanaAlfredo on 2/17/18.
//  Copyright © 2018 SolanaAlfredo. All rights reserved.
//

//
//  SpriteSheet.swift
//

import SpriteKit

struct EffectModel {
    let id: Int
    let fileName: String
    let width: Int
    let height: Int
    var duration: Float
    let scale: Int
    let diffY: Int
    let frames: String
    var framesArray: [Int]
    let sound: String
    let colorR: Int
    let colorG: Int
    let colorB: Int

    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
            let fileName = json["filename"] as? String,
            let width = json["h"] as? Int,
            let height = json["v"] as? Int,
            let duration = json["duration"] as? Float,
            let scale = json["scale"] as? Int,
            let diffY = json["y"] as? Int,
            let frames = json["frames"] as? String,
            let sound = json["sound"] as? String,
            let colorR = json["r"] as? Int,
            let colorG = json["g"] as? Int,
            let colorB = json["b"] as? Int
        else {
            return nil
        }
        self.id = id;
        self.fileName = fileName
        self.width = width
        self.height = height
        self.duration = duration
        self.scale = scale
        self.diffY = diffY
        self.frames = frames
        self.framesArray = [Int]()
        self.sound = sound
        self.colorR = colorR
        self.colorG = colorG
        self.colorB = colorB
        
        if (!frames.isEmpty) {
            self.framesArray = parseFrames(from: frames)
        }
    }
    
    func parseFrames (from framesString: String) -> [Int]{
        var partsString = [String]()
        var partsInt = [Int]()
        if (!framesString.isEmpty) {
            partsString = framesString.components(separatedBy: ",")
            for var frameStr in partsString {
                if frameStr.contains(Character("-")) {
                    if let rangeStartBracket = frameStr.range(of: "[") {
                        frameStr.remove(at: rangeStartBracket.lowerBound)
                    }
                    if let rangeEndBracket = frameStr.range(of: "]") {
                        frameStr.remove(at: rangeEndBracket.lowerBound)
                    }
                    let bracketsParts = frameStr.components(separatedBy: "-")
                    let bracketsFirstFrame: Int = Int(bracketsParts[0])!
                    let bracketsEndFrame: Int = Int(bracketsParts[1])!
                    var index: Int = bracketsFirstFrame
                    while index != bracketsEndFrame {
                        partsInt.append(index)
                        if (bracketsFirstFrame < bracketsEndFrame) {
                            index += 1;
                        } else {
                            index -= 1;
                        }
                    }
                    partsInt.append(bracketsEndFrame)
                } else {
                    partsInt.append(Int(frameStr)!)
                    continue
                }
            }
        }
        return partsInt
    }
    
}

class SpriteSheet {
    let model: EffectModel
    let texture: SKTexture
    var animFrames = [SKTexture]()
    var margin: CGFloat=0
    var spacing: CGFloat=0
    var frameSize: CGSize {
    return CGSize(width: (self.texture.size().width-(self.margin*2+self.spacing*CGFloat(model.width-1)))/CGFloat(model.width),
    height: (self.texture.size().height-(self.margin*2+self.spacing*CGFloat(model.height-1)))/CGFloat(model.height))
}

    init(effectModel: EffectModel) {
        self.model = effectModel
        texture = SKTexture(imageNamed: model.fileName)
        margin = 0
        spacing = 0

        //Gather animation's frames
        animFrames.removeAll()
        //If frames are not declared the animation uses all of them
        if effectModel.frames.isEmpty {
            for row in (0..<effectModel.height).reversed() {//Reversed to start frames from top left corner
                if effectModel.width > 0{
                    for column in 0..<effectModel.width {
                        if let frame = self.textureForColumn(column: column, row: row) {
                            animFrames.append(frame)
                        }
                    }
                }
            }
        } else {
            for frame in model.framesArray {
                let xVar = frame % model.width
                let yVar = frame / model.width
                let frameWidth = texture.size().width / CGFloat(effectModel.width)
                let frameHeight = texture.size().height / CGFloat(effectModel.height)
                let frameRect: CGRect = CGRect(x: (self.margin + frameWidth * CGFloat(xVar)) / self.texture.size().width, y: (texture.size().height - (frameHeight * CGFloat(yVar)) - frameHeight - self.margin) / self.texture.size().height, width: frameWidth / self.texture.size().width, height: frameHeight / self.texture.size().height)
                let frameTexture = SKTexture(rect: frameRect, in: self.texture)
                animFrames.append(frameTexture)
            }
        }
    }

    func textureForColumn(column: Int, row: Int)->SKTexture? {
        if !(0...model.height ~= row && 0...model.width ~= column) {
            return nil
        }

        var textureRect = CGRect(x: self.margin + CGFloat(column) * (self.frameSize.height + self.spacing) - self.spacing,
                               y: self.margin + CGFloat(row) * (self.frameSize.width + self.spacing) - self.spacing,
                               width: self.frameSize.width,
                               height: self.frameSize.height)

        textureRect = CGRect(x: textureRect.origin.x / self.texture.size().width, y: textureRect.origin.y / self.texture.size().height,
                           width: textureRect.size.width / self.texture.size().width, height: textureRect.size.height / self.texture.size().height)
        return SKTexture(rect: textureRect, in: self.texture)
    }

    public func getEffectFrames()->[SKTexture] {
        return self.animFrames
    }

}
