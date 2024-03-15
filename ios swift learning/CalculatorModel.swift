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
    @Published var brain: CalculatorBrain = .left("0")
    @Published var history: [CalculatorButtonItem] = []
    
    func apply(_ item: CalculatorButtonItem){
        brain = brain.apply(item: item)
        history.append(item)
    }
}
