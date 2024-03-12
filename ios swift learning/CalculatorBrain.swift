//
//  CalculatorBrain.swift
//  ios swift learning
//
//  Created by 朱明灿 on 2024/3/13.
//

import Foundation

/*var formatter: NumberFormatter = {
    let f = NumberFormatter()
    f.minimumFractionDigits = 0
    f.maximumFractionDigits = 8
    f.numberStyle = .decimal
    return f
}()*/

//四种状态
enum CalculatorBrain{
    //计算器的四种状态
    case left(String)
    case leftOp(left: String,op: CalculatorButtonItem.Op)
    case leftOpRight(left: String,op: CalculatorButtonItem.Op,right: String)
    case error
}

extension CalculatorBrain{
    //output最终显示在计算器上的一行
    var output:String{
        let result: String
        switch self{
        case .left(let left):
            result = left
        case .leftOp(left: let left, op: let op):
            result = left
        case .leftOpRight(left: let left, op: let op, right: let right):
            result = right
        case .error:
            result = "Error"
        }
        guard let value = Double(result) else{
            return "Error"
        }
        return toString(num: value)
    }
    //按下等号计算最终值
    func done(left: String, op: CalculatorButtonItem.Op,right: String) -> String{
        let temp: String
        switch op{
        case .minus: temp = String(Double(left)!-Double(right)!)
        case .plus: temp = String(Double(left)!+Double(right)!)
        case .divide: temp = String(Double(left)!/Double(right)!)
        case .multiply: temp = String(Double(left)!*Double(right)!)
        default: temp = ""
        }
        return temp
    }
    //按下某个数字
    func apply(num: Int) -> CalculatorBrain{
        let temp: CalculatorBrain
        switch self{
        case .left(let left):
            temp = .left(left+String(num))
        case .leftOp(left: let left,op: let op):
            temp = .leftOpRight(left: left, op: op, right: String(num))
        case .leftOpRight(left: let left, op: let op, right: let right):
            temp = .leftOpRight(left: left, op: op, right: right+String(num))
        case .error:
            temp = .error
        }
        return temp
    }
    //按下小数点
    func applyDot() -> CalculatorBrain{
        let temp: CalculatorBrain
        switch self{
        case .left(let left):
            temp = .left(left+".")
        case .leftOp(left: let left,op: let op):
            temp = self
        case .leftOpRight(left: let left, op: let op, right: let right):
            temp = .leftOpRight(left: left, op: op, right: right+".")
        case .error:
            temp = .error
        }
        return temp
            
    }
    //按下某个运算符
    func apply(op: CalculatorButtonItem.Op) -> CalculatorBrain{
        let temp: CalculatorBrain
        switch self{
        case .left(let left):
            temp = .leftOp(left: left, op: op)
        case .leftOp(left: let left,op: let oldOp):
            temp = .leftOp(left: left, op: op)
        case .leftOpRight(left: let left, op: let oldOp, right: let right):
            if op != .equal{
                temp = .leftOp(left: done(left: left, op: oldOp, right: right), op: op)
            }
            else{
                temp = .left(done(left: left, op: oldOp, right: right))
            }
        case .error:
            temp = .error
        }
        return temp
    }
    //按下某个功能键
    func apply(command: CalculatorButtonItem.Command) -> CalculatorBrain{
        let temp: CalculatorBrain
        switch command{
        case .clear:
            temp = .left("0")
        case .flip:
            switch self{
            case .left(let left): temp = .left(String(-Double(left)!))
            case .leftOp(left: let left, op: let op): temp = .leftOpRight(left: left, op: op, right: "-0")
            case .leftOpRight(left: let left, op: let op, right: let right): temp = .leftOpRight(left: left, op: op, right: String(-Double(right)!))
            case .error: temp = .error
            }
        case .percent:
            switch self{
            case .left(let left): temp = .left(String(Double(left)! / 100.0))
            case .leftOp(left: let left, op: let op): temp = .leftOpRight(left: left, op: op, right: String(Double(left)! / 100.0))
            case .leftOpRight(left: let left, op: let op, right: let right): temp = .leftOpRight(left: left, op: op, right: String(Double(left)! / 100.0))
            case .error: temp = .error
            }
        }
        return temp
    }
    //按下某个键
    func apply(item: CalculatorButtonItem) -> CalculatorBrain{
        switch item{
        case .digit(let num):
            return apply(num: num)
        case .dot:
            return applyDot()
        case .op(let op):
            return apply(op: op)
        case .command(let command):
            return apply(command: command)
        }
    }
}

//格式化输出
func toString(num: Double) -> String {
    let formatter = NumberFormatter()
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 5
    formatter.numberStyle = .decimal
    
    return formatter.string(from: num as NSNumber) ?? "N/A"
}
