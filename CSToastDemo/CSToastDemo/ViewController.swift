//
//  ViewController.swift
//  CSToastDemo
//
//  Created by Joslyn Wu on 2017/4/20.
//  Copyright © 2017年 joslyn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        welcomeToast()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        welcomeToast()
    }
    
    @IBAction func showInWindow(_ sender: Any) {
        
        CSToast.show(text: "I am in window.")
    }
    
    @IBAction func showInView(_ sender: UIButton) {
        
        CSToast.show(text: "I am in view.") {
            $0.inView = sender
        }
    }
    
    func welcomeToast() {
        CSToast.show(text: "Welcome to CSToast !", duration: 2) { (toast) in
            toast.fontSize = 16
            toast.textColor = .green
            toast.bgColor = .brown
            toast.top = 100
        }
    }
    
}

