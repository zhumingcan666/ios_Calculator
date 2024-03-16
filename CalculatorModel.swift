//
//  CalculatorModel.swift
//  ios swift learning
//
//  Created by 朱明灿 on 2024/3/15.
//

import Foundation
import SwiftUI
import Combine

class CalculatorModel: ObservableObject{
    //@Published声明的变量在改变时自动调用send()广播，而在ContentView中订阅了model（即这里的brain+history）
    //会收到广播，知道有变量发生改变，进行刷新UI
    @Published var brain: CalculatorBrain = .left("0")
    @Published var history: [CalculatorButtonItem] = []
    
    //更新函数
    func apply(_ item: CalculatorButtonItem){
        brain = brain.apply(item: item)
        history.append(item)
        
        //还在按键的时候就不需要回溯操作，history数组就是total
        temporaryKept.removeAll()
        slidingIndex = Float(totalCount)
    }
    //一个字符串，包含点击过的所有键，如“9+1-8x4”
    //其中map为对history数组中每个元素进行闭包处理，这里$0是速记，代表数组中的某个元素，joined()将得到的新数组进行每个元素拼接为一个字符串
    var historyDetail: String{
        history.map{$0.title.description}.joined(separator: "")
    }
    
    
    var temporaryKept: [CalculatorButtonItem] = []
    
    var totalCount: Int{
        history.count + temporaryKept.count
    }
    
    var slidingIndex: Float = 0{
        didSet{
            keepHistory(upTo: Int(slidingIndex))
        }
    }
    //index是滑到了哪个位置，index之前的按键记为history，之后的记为temporary，keepHistory负责更新这件事
    func keepHistory(upTo index: Int){
        precondition(index <= totalCount,"out of index.")
        
        let total = history + temporaryKept
        history = Array(total[..<index])
        temporaryKept = Array(total[index...])
        
        //reduce参数1:计算的初始值，参数2:闭包，result存储暂时的结果，item是当前history中的某个元素
        //相当于对history中的按键从头到尾模拟了一次，得出此时index处的brain值
        brain = history.reduce(CalculatorBrain.left("0"), {
            result,item in
            result.apply(item: item)
        })
    }
}

struct HistoryView: View{
    @ObservedObject var model: CalculatorModel
    
    var body: some View{
        VStack{
            if model.totalCount == 0{
                Text("暂无操作")
            }
            else{
                HStack{
                    Text("历史操作")
                        .font(.headline)
                    Text("\(model.historyDetail)")
                        .lineLimit(nil)
                }
                HStack{
                    Text("屏幕显示")
                        .font(.headline)
                    Text("\(model.brain.output)")
                }
                //滑动条，和slidingIndex绑定，滑动会直接改变其值
                Slider(value: $model.slidingIndex, in: 0...Float(model.totalCount),step: 1)
            }
        }
    }
}
