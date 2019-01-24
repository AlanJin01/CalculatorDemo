//
//  ViewController.swift
//  CalculatorDemo1
//
//  Created by J K on 2019/1/23.
//  Copyright © 2019 KimsStudio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var selectedNumbers = Array<Double>() //存储点击的数字
    private var number: String = String() //当前数字
    private var isClick: Bool = false //为了防止用户连续点击计算符号时系统崩溃，
    private var operat: String! //计算符号1
    private var operat2: String! //计算符号2
    private var operators: [String] = [String]() //每次点击计算符号时存储在这个数组里
    private var t: String? //点击"="按钮时把最后计算结果存储在这个变量中
    
    @IBOutlet weak var numberLabel: UILabel! //显示数字的标签
    @IBOutlet weak var operatorMark: UILabel! //显示点击的计算符号，以便用户知道自己在进行什么运算
    
    //数字按钮
    @IBAction func numberButton(_ sender: UIButton) {
        t = nil
        self.number = self.number + sender.currentTitle!
        numberLabel.text = self.number
    }
    
    //计算符号按钮
    @IBAction func operatorButton(_ sender: UIButton) {
        operat = sender.currentTitle!
        switch operat {
            case "+":
                operatorMark.text = "+"
                if operators.isEmpty {               //如果是清零后或第一次开始进行计算的话，把当前计算符号传给operat2
                    operat2 = operat
                }
                operators.append(operatorMark.text!) //存储当前运算符号
                calculate {$0 + $1}                 //进行相应计算，这里就是两个数相加
            case "-":
                operatorMark.text = "-"
                if operators.isEmpty {
                    operat2 = operat
                }
                operators.append(operatorMark.text!)
                calculate {$0 - $1}
            case "/":
                operatorMark.text = "/"
                if operators.isEmpty {
                    operat2 = operat
                }
                operators.append(operatorMark.text!)
                calculate {$0 / $1}
            case "✕":
                operatorMark.text = "✕"
                if operators.isEmpty {
                    operat2 = operat
                }
                operators.append(operatorMark.text!)
                calculate {$0 * $1}
            default:
                break
        }
    }
    
    //点击"="符号时输出总计算结果
    @IBAction func resultButton(_ sender: UIButton) {
        if self.selectedNumbers.isEmpty { //用户如果啥也没选计算符号就点击"="的话，就调用这个
            if self.number.isEmpty { //如果是空
                self.numberLabel.text = "0.0"
            }else { //如果有用户输入的数字的话
                self.numberLabel.text = self.number
            }
        }else {
            if self.number != "" {
                isClick = false   //如果连续点击一次以上的话，下面代码就不执行，以防程序崩溃
                if isClick == false {
                    switch operators[(operators.endIndex - 1)] {
                    case "+":
                        self.selectedNumbers[0] = self.selectedNumbers[0] + Double(self.number)!
                        self.numberLabel.text = String(self.selectedNumbers[0])
                    case "-":
                        self.selectedNumbers[0] = self.selectedNumbers[0] - Double(self.number)!
                        self.numberLabel.text = String(self.selectedNumbers[0])
                    case "/":
                        self.selectedNumbers[0] = self.selectedNumbers[0] / Double(self.number)!
                        self.numberLabel.text = String(self.selectedNumbers[0])
                    case "✕":
                        self.selectedNumbers[0] = self.selectedNumbers[0] * Double(self.number)!
                        self.numberLabel.text = String(self.selectedNumbers[0])
                    default:
                        break
                    }
                    t = String(self.selectedNumbers[0]) //把当前总结果传给t, 如果用户点击"="并获得了总结果后，再点击其他计算符号想继续做运算的话，把这个当成初始值
                    self.number = ""   //清空
                    self.operators = []
                    self.selectedNumbers = []
                    isClick = true
                }
            }
        }
    }
    
    //清除按钮
    @IBAction func clearButton(_ sender: UIButton) {
        self.numberLabel.text = "0.0"
        self.selectedNumbers.removeAll()
        self.operatorMark.text = ""
        self.number = ""
        self.operators = []
    }
    
    //点击计算符号时进行小计算
    func calculate(operate: (Double, Double) -> Double) {
        if t != nil {     //如果总结果有值的话
            self.number = t!
        }
        if self.number.isEmpty == false && operat2 == operat {    //如果当前运算符号跟上一个相同时执行以下代码
            t = nil      // t只需用一次
            
            isClick = false
            if isClick == false {
                selectedNumbers.append(Double(number)!)
                self.number = ""
                if selectedNumbers.count >= 2 {
                    let total = operate(self.selectedNumbers[0], self.selectedNumbers[1])
                    self.selectedNumbers.removeAll()
                    self.selectedNumbers.append(total)
                    self.numberLabel.text = String(self.selectedNumbers[0])
                    isClick = true
                }else {
                    self.numberLabel.text = String(self.selectedNumbers[0])
                }
            }
        }else if self.number.isEmpty == false && operat2 != operat {    //如果当前运算符号跟上一个不同时执行已下代码
            isClick = false
            if isClick == false {
                switch operators[(operators.endIndex - 2)] {
                    case "+":
                        self.selectedNumbers[0] = self.selectedNumbers[0] + Double(self.number)!
                        self.numberLabel.text = String(self.selectedNumbers[0])
                    case "-":
                        self.selectedNumbers[0] = self.selectedNumbers[0] - Double(self.number)!
                        self.numberLabel.text = String(self.selectedNumbers[0])
                    case "/":
                        self.selectedNumbers[0] = self.selectedNumbers[0] / Double(self.number)!
                        self.numberLabel.text = String(self.selectedNumbers[0])
                    case "✕":
                        self.selectedNumbers[0] = self.selectedNumbers[0] * Double(self.number)!
                        self.numberLabel.text = String(self.selectedNumbers[0])
                    default:
                        break
                }
                self.number = ""
                if selectedNumbers.count >= 2 {
                    let total = operate(self.selectedNumbers[0], self.selectedNumbers[1])
                    self.selectedNumbers.removeAll()
                    self.selectedNumbers.append(total)
                    self.numberLabel.text = String(self.selectedNumbers[0])
                    isClick = true
                }
            }
        }
        operat2 = operat  //把当前运算符号传给operat2，以便在下一次运算时用
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }


}

