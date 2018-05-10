/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
import UIKit
import SpriteKit

class GameOverScene: SKScene {
  
  // Private GameScene Properties
  
  var contentCreated = false
    
    private let predictionCollector : PredictionCollector
  
  // Object Lifecycle Management
    
    init(size : CGSize, predictionCollector : PredictionCollector){
        self.predictionCollector = predictionCollector
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  // Scene Setup and Content Creation
  
  override func didMove(to view: SKView) {
    
    if (!self.contentCreated) {
      self.createContent()
      self.contentCreated = true
    }
  }
  
  func createContent() {
    
    let gameOverLabel = SKLabelNode(fontNamed: "Courier")
    gameOverLabel.fontSize = 50
    gameOverLabel.fontColor = SKColor.white
    gameOverLabel.text = "Game Over!"
    gameOverLabel.position = CGPoint(x: self.size.width/2, y: 2.0 / 3.0 * self.size.height);
    
    self.addChild(gameOverLabel)
    
    let tapLabel = SKLabelNode(fontNamed: "Courier")
    tapLabel.fontSize = 20
    tapLabel.fontColor = SKColor.white
    tapLabel.text = "(Tap to play again)"
    tapLabel.position = CGPoint(x: self.size.width/2, y: gameOverLabel.frame.origin.y - gameOverLabel.frame.size.height - 40);
    
    self.addChild(tapLabel)
    
    // black space color
    self.backgroundColor = SKColor.black
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)  {
    
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)  {
    let gameScene = GameScene(size: self.size, predictionCollector: predictionCollector)
    gameScene.scaleMode = .aspectFill
    
    self.view?.presentScene(gameScene, transition: SKTransition.doorsCloseHorizontal(withDuration: 1.0))
    
  }
}
