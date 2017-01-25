//
//  ViewController.swift
//  Stanford_Caculator
//
//  Created by Shaw Yang on 06/01/2017.
//  Copyright © 2017 Shaw Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var displayValue:Double {
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String (newValue)
        }
    }
    
    @IBOutlet var display: UILabel!
    @IBOutlet var opsDisplay: UILabel!
    var userIsInMiddleTyping = false
    var alreadyOneDot = false //make sure there only one dot
    var isPartialResult = true
    
    var calculatorCount = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        calculatorCount += 1
        print("Loaded up a new Calculator ( count = \(calculatorCount)")
        
        brain.addUnaryOperation(symbol: "Z"){
            [unowned me  = self] in
            me.display.textColor = UIColor.red
            return sqrt($0)
        }
        
    }
    
    deinit {
        calculatorCount -= 1
        print(" Calculator left the heap (count = \(calculatorCount)")
    }
    
    
    internal  var descriptions: String {
        get{
            return opsDisplay.text!
        }
        set{
            opsDisplay.text = descriptions
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
    @IBAction func clicked(_ sender: UIButton) { //actually is numClicked
        
        let digit = sender.titleLabel!.text!
        
        if userIsInMiddleTyping{ //already one dot &&  == . , not execute ---
                if alreadyOneDot == false || digit != "."{
                    let textCurrentInDisplay = display.text!
                    display.text  = textCurrentInDisplay + digit
                    opsDisplay.text = descriptions + digit
                }
        }
        else{
            display.text = digit
            opsDisplay.text = descriptions + digit
            descriptions = digit
        }
        if digit == "." {
            alreadyOneDot = true
        }

        userIsInMiddleTyping = true
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func oprationTouched(_ sender: UIButton) {
        if userIsInMiddleTyping{
            brain.setOperand(operand: displayValue)
            userIsInMiddleTyping = false
        }
        if let mathematicalSymbol = sender.titleLabel?.text{
            
            opsDisplay.text  = descriptions + mathematicalSymbol
            brain.performOperation(symbol:mathematicalSymbol)
            displayValue = brain.result
        }
    }
    

    var savedProgram: CalculatorBrain.Propertylist?
    @IBAction func save() {
        savedProgram = brain.program
    }
    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    
    
    
    
}
