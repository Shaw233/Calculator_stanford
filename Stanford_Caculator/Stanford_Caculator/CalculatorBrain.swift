//
//  CalculatorBrain.swift
//  Stanford_Caculator
//
//  Created by Shaw Yang on 08/01/2017.
//  Copyright © 2017 Shaw Yang. All rights reserved.
//
//

//Then , think, This really does not belong to MY controller , because this is the code of what my app is
//
//Its a calculator an d I’m doing calculations here So
//
//So , this needs to move into a model class .
//
//So, How?  File - new file , swift file ,name it CalculatorBrain .
//
//Then we will find , in the beginning ,  There is no UIKit ?   Surely!   This is Model, not the UI//!
import Foundation

// So, here ,Lets figure out What is API?
// That Means the interface through which we`re going to be programming ,using this,CalculatorBrain


func multiply(op1:Double,op2 : Double) -> Double{
    
    return op1 * op2
}

class CalculatorBrain{
    
    var result: Double {
        get {
            return accumulator
        }
        //think, this result is public? it could be set and get?
        //     ANYONE using Calcu, they can set Result?
        //SO,  we only implement the GET
        
        //AND, rememe , currentTitle is a read-only Property OF Button
    }
    
    private var accumulator  = 0.0
    private var internalProgram = [AnyObject]()
    
    func addUnaryOperation(symbol: String,operation: @escaping (Double)->Double) {
        operations[symbol] = Operations.UnaryOperation(operation)
    }
    
    private var operations: Dictionary<String,Operations> = [
        "π" : Operations.Constant(M_PI),   //M_PI,
        "e" : Operations.Constant(M_E),   //M_E,
        "√" : Operations.UnaryOperation(sqrt),
        "cos" : Operations.UnaryOperation(cos),
        "±" : Operations.UnaryOperation({ return -$0 }),
        "×" : Operations.BinaryOperation({ return $0 * $1}),
        "÷" : Operations.BinaryOperation({ return $0 / $1}),

        "+" : Operations.BinaryOperation({ return $0 + $1}),
        "-" : Operations.BinaryOperation({ return $0 - $1}),
        "=" : Operations.Equals
    ]
    enum Operations{
        case Constant(Double)
        case UnaryOperation((Double)->Double)
        case BinaryOperation((Double,Double)->Double)
        case Equals
        
    }
    func setOperand(operand : Double){
        accumulator = operand
        internalProgram.append(operand as AnyObject)
        
    }
    
    
    //OP2
    private struct PendingBinaryOperationInfo{
        var binaryFunction : (Double,Double) -> Double
        var firstOperand : Double
    }
    
    private var pending : PendingBinaryOperationInfo?
    
    func performOperation (symbol: String){
        internalProgram.append(symbol as AnyObject)
        
        
        if let operation = operations[symbol]{
            switch operation{
            case .Constant(let value) : accumulator = value
            case .UnaryOperation(let function) : accumulator = function(accumulator)
            case .BinaryOperation(let function): pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand:accumulator)
            case .Equals :
                if self.pending != nil {
                    self.accumulator = self.pending!.binaryFunction(self.pending!.firstOperand,self.accumulator)
                    self.pending = nil
                }
            }
        }
        
//        switch symbol{
//        case "π": accumulator = M_PI
//        case "√": accumulator = sqrt(accumulator)
//        default:break
//        }
    }
    
    //L03 we get around with "Program it "
    typealias Propertylist = AnyObject
    var program : Propertylist { // seems it not reach to me some how
        get{
            return internalProgram as CalculatorBrain.Propertylist
        }
        set{
            clear()
            if let arrayOfOps = newValue as? [AnyObject]{ //see if the given value is what we want  
                for op in arrayOfOps{
                    if let operand = op as? Double{
                        setOperand(operand: operand)
                    }
                    else if let operation = op as? String{
                        performOperation(symbol: operation)
                    }
                    //else if let
                }
                
            }
        }
    }
    func clear(){
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }

}
//  we will find that we have done . have been essentially PUBLIC
// MEANING , any class can call any of the methods in any of the calsses
// Thats BAD
// these var result etc is internal implementation ,
// We DO NOT want other calsses to be able to call it

// NO, there , setOperand \ performOperation , we WANT them to be called by Other classes

// So , they can use Calculator
