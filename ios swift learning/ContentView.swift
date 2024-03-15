//
//  ContentView.swift
//  ios swift learning
//
//  Created by 朱明灿 on 2024/3/12.
//

import SwiftUI

//实际呈现的UI
struct ContentView: View {
    @ObservedObject var model = CalculatorModel()
    
    let scale : CGFloat = UIScreen.main.bounds.width / 414
    var body: some View {
        VStack(spacing: 12){
            Spacer()
            Text(model.brain.output)
                .frame(minWidth: 0,maxWidth: .infinity,maxHeight: 76, alignment: .trailing)
                .font(.system(size: 76))
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .padding()
            CalculatorButtonPad(model: model,
                pad: [
                [.command(.clear),.command(.flip),.command(.percent),.op(.divide)],
                [.digit(7),.digit(8),.digit(9),.op(.multiply)],
                [.digit(4),.digit(5),.digit(6),.op(.minus)],
                [.digit(1),.digit(2),.digit(3),.op(.plus)],
                [.digit(0),.dot,.op(.equal)]
            ])
            .padding()
        }
        .scaleEffect(scale)
    }
}


//自定义
struct CalculatorButton: View{
    let fontSize : CGFloat = 38
    let title : String
    let size : CGSize
    let backgroundColorName : String
    let action : () -> Void
    
    var body: some View{
        Button(action: action){
            Text(title)
                .font(.system(size: fontSize))
                .foregroundColor(.white)
                .frame(width: size.width,height: size.height)
                .background(Color(backgroundColorName))
                .cornerRadius(size.width / 2)
        }
    }
}
struct CalculatorButtonRow : View{
    var model: CalculatorModel
    
    var row: [CalculatorButtonItem]
    var body: some View{
        HStack{
            ForEach(row,id: \.self){item in
                CalculatorButton(title: item.title, size: item.size, backgroundColorName: item.backgroundColorName, action: {
                    self.model.apply(item)
                    })
            }
        }
    }
}
struct CalculatorButtonPad : View{
    var model: CalculatorModel
    
    let pad: [[CalculatorButtonItem]]
    var body: some View{
        VStack(spacing: 12){
            ForEach(pad,id: \.self){
                aRow in CalculatorButtonRow(model: model, row: aRow)
            }
        }
    }
}
struct Reducer{
    static func reduce(
        state:CalculatorBrain,
        action:CalculatorButtonItem) -> CalculatorBrain
    {
        return state.apply(item: action)
    }
}

//预览部分
#Preview {
    ContentView()
}
