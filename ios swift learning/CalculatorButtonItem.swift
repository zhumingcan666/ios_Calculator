//
//  CalculatorButtonItem.swift
//  ios swift learning
//
//  Created by 朱明灿 on 2024/3/13.
//

import Foundation

enum CalculatorButtonItem{
    enum Op : String{
        case plus = "+"
        case minus = "-"
        case divide = "÷"
        case multiply = "×"
        case equal = "="
    }
    enum Command : String{
        case clear = "AC"
        case flip = "+/-"
        case percent = "%"
    }
    
    case digit(Int)
    case dot
    case op(Op)
    case command(Command)
}
extension CalculatorButtonItem{
    var title : String{
        switch self{
        case .digit(let num):
            return String(num)
        case .dot:
            return "."
        case .op(let op):
            return op.rawValue
        case .command(let commmand):
            return commmand.rawValue
        }
    }
    
    var size: CGSize{
        if self.title != "0"{
            return CGSize(width: 88, height: 88)
        }
        else{
            return CGSize(width: 88*2+8, height: 88)
        }
    }
    var backgroundColorName : String{
        switch self{
        case .digit,.dot:
            return "digitBackground"
        case .op:
            return "operatorBackground"
        case .command:
            return "commandBackground"
        }
    }
}
extension CalculatorButtonItem : Hashable{}
