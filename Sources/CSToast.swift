//
//  CSToast.swift
//  CSToastDemo
//
//  Created by Joslyn Wu
//  Copyright © 2017年 joslyn. All rights reserved.
//
//  https://github.com/JoslynWu/CSToast.git
//
//  概述:
//  关于工具:
//  本工具是一个简单的提示框（Toast）。
//  默认以window为载体，显示在window中心。可以调整距离上下边的距离。
//  可以指定在某个View中显示，默认显示在中心，不可以调整位置。
//  Toast接收点击事件，点击时可以移除。
//  func viewDidAppear(_ animated: Bool)之后调用有效。
//
//  关于API:
//  除了常用的text和duration外，其他配置都放在闭包里。
//
//  默认配置:
//  inView          --> window
//  backgroundColor --> black 0.8(alpha)
//  textColor       --> white
//  duration        --> 1.5s
//  fontSize        --> 15
//  maxFontSize     --> 22
//  minFontSize     --> 10
//  maxWidth        --> 180 + 30

import UIKit

let Default_max_w: CGFloat = 180
let Default_min_w: CGFloat = 100
let Default_min_h: CGFloat = 24
let Default_Duration: CGFloat = 1.5
let Default_Font_Size: CGFloat = 15
let Default_min_Font_Size: CGFloat = 10
let Default_max_Font_Size: CGFloat = 22
let Default_View_Radius: CGFloat = 8
let Default_bg_Alpha: CGFloat = 0.8

class CSToast: UIView {
    
    static private let shared = CSToast()
    private var showText: String?
    private var duration: CGFloat?
    
    
    // MARK: -----------------------public-----------------------------
    
    /// 指定Toast时间和文字
    ///
    /// - Parameters:
    ///   - text: 文字
    ///   - duration: 显示时间
    static func show(text: String, duration: CGFloat) {
        show(text: text, duration: duration, config: nil)
    }

    static func show(text: String, config: @escaping ((_ toast: CSToast) -> Void)) {
        show(text: text, duration: Default_Duration, config: config)
    }
    
    static func show(text: String, duration: CGFloat = Default_Duration, config: ((_ toast: CSToast) -> Void)? = nil) {
        shared.recoverDefaultConfig()
        shared.showText = text;
        shared.duration = duration;
        config?(shared)
        shared.setupToast()
    }
    
    // 可配置属性
    var fontSize: CGFloat = Default_Font_Size
    var textColor: UIColor = .white
    var bgColor: UIColor = UIColor.black.withAlphaComponent(Default_bg_Alpha)
    
    var inView: UIView = UIApplication.shared.keyWindow!
    var top: CGFloat?
    var bottom: CGFloat?
    
    
    
    
    
    // MARK: -----------------------private-----------------------------
    private func setupToast() {
        toastView.addSubview(msgLabel)
        setText(text: showText!)
        showToast()
    }
    
    private func recoverDefaultConfig() {
        duration = Default_Duration
        fontSize = Default_Font_Size
        textColor = .white
        bgColor = UIColor.black.withAlphaComponent(Default_bg_Alpha)
        inView = UIApplication.shared.keyWindow!
        top = nil
        bottom = nil
    }
    
    private func setText(text: String) {
        if self.fontSize < Default_min_Font_Size {
            self.fontSize = Default_min_Font_Size
        } else if self.fontSize > Default_max_Font_Size {
            self.fontSize = Default_max_Font_Size
        }
        msgLabel.font = UIFont.boldSystemFont(ofSize: self.fontSize)
        let textSize: CGSize = (text as NSString).boundingRect(with: CGSize(width: Default_max_w, height: UIScreen.main.bounds.height), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName : msgLabel.font], context: nil).size
        let msg_w = min(Default_max_w, max(Default_min_w, CGFloat(ceilf(Float(textSize.width)))))
        let msg_h = min(UIScreen.main.bounds.size.height, CGFloat(ceilf(Float(textSize.height))))
        toastView.frame = CGRect(x: 0, y: 0, width: msg_w + 30, height: msg_h + 20)
        toastView.backgroundColor = bgColor
        msgLabel.frame = CGRect(x: 0, y: 0, width: msg_w, height: msg_h)
        msgLabel.center = CGPoint(x: toastView.frame.size.width * 0.5, y: toastView.frame.size.height * 0.5)
        msgLabel.text = showText
        msgLabel.textColor = textColor
    }
    
    private func showAnimation() {
        if toastView.alpha > Default_bg_Alpha {
            toastView.alpha = Default_bg_Alpha
        }
        UIView.animate(withDuration: 0.25) { 
            self.toastView.alpha = 1
        }
    }
    
    @objc private func hideAnimation() {
        UIView.animate(withDuration: 0.25, animations: { 
            self.toastView.alpha = 0
        }, completion: { (finish) in
            if finish { self.dismissToast() }
        })
    }
    
    private func dismissToast() {
        toastView.removeFromSuperview()
    }
    
    private func showToast() {
        showInView(view: inView, center: showWithCenter())
    }
    
    private func showWithCenter() -> CGPoint {
        let center = CGPoint(x: inView.bounds.size.width * 0.5, y: inView.bounds.size.height * 0.5)
        if inView != UIApplication.shared.keyWindow! {
            return center
        }
        if top != nil {
            autoresizingMask = .flexibleTopMargin
            return CGPoint(x: inView.center.x, y: top! + toastView.bounds.size.height * 0.5)
        }
        if bottom != nil {
            autoresizingMask = .flexibleBottomMargin
            return CGPoint(x: inView.center.x, y: toastView.bounds.size.height * 0.5 - bottom!)
        }
        return center
    }
    
    private func showInView(view: UIView, center: CGPoint) {
        if toastView.superview != view {
            toastView.removeFromSuperview()
            view.addSubview(toastView)
        }
        toastView.center = center
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        showAnimation()
        guard duration != CGFloat(0) else {
            hideAnimation()
            return
        }
        guard duration! > CGFloat(0) else {
            return
        }
        perform(#selector(hideAnimation), with: nil, afterDelay: TimeInterval(duration!))
    }
    
    
    // MARK: - lazy
    lazy var toastView: UIView = {
        let btn = UIButton()
        btn.layer.cornerRadius = Default_View_Radius
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(hideAnimation), for: .touchUpInside)
        btn.alpha = 1
        return btn
    }()
    
    lazy var msgLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: self.fontSize)
        return label
    }()
 
}
