//
//  AppNativeCallAnalyzer.swift
//  NativeCallAnalyzer
//
//  Created by Santhosh Marripelli on 28/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import Foundation
import UIKit

public class APPNativeCallAnalyzer {
    public static let sharedInstance: APPNativeCallAnalyzer = APPNativeCallAnalyzer()
    private let nativeCallAnalyzerVC: APPNativeCallAnalyzerVC =
        APPNativeCallAnalyzerVC(nibName: "APPNativeCallAnalyzerVC", bundle: Bundle.main)
    fileprivate var isNativeAPILogEnable: Bool = true
    private init() {}
    private let accessQueue: DispatchQueue = DispatchQueue(label: "SynchronizedArrayAccess", attributes: .concurrent)
    private var nativeRestAPILogHistoryArray: [APPNativeCallAnalyzerModel] = []
    
    /// Open Call Analyzer
    ///
    /// - Parameters:
    ///   - parentVC: base viewcontroller
    ///   - frame: call analyzer frame
    public func openNativeCallAnalyzer(in parentVC: UIViewController, frame: CGRect) {
        nativeCallAnalyzerVC.presentingFrame = frame
        nativeCallAnalyzerVC.modalPresentationStyle = .custom
        nativeCallAnalyzerVC.transitioningDelegate = nativeCallAnalyzerVC
        
        print(nativeCallAnalyzerVC)
        parentVC.present(nativeCallAnalyzerVC, animated: true, completion: nil)
    }
    
    /// Close Call Analyzer
    public func closeNativeCallAnalyzer() {
        nativeCallAnalyzerVC.dismiss(animated: true, completion: nil)
    }
    
    /// Add Logs for calls
    ///
    /// - Parameter callInfo: call model
    public func addNetworkCallLog(callInfo: APPNativeCallAnalyzerModel) {
        if isNativeAPILogEnable {
            self.accessQueue.async(flags: .barrier) { [weak self] in
                self?.nativeRestAPILogHistoryArray.append(callInfo)
            }
        }
    }
    
    /// Get Array Count
    public func getArrayCount() -> Int {
        var count = 0
        self.accessQueue.sync {
            count = self.nativeRestAPILogHistoryArray.count
        }
        return count
    }
    
    /// Get Array Reference
    public func getResponseArray() -> [APPNativeCallAnalyzerModel] {
        var array: [APPNativeCallAnalyzerModel] = []
        self.accessQueue.sync {
            array = self.nativeRestAPILogHistoryArray
        }
        return array
    }
    
    /// Clear current logs
    public func clearLogs() {
        self.accessQueue.async(flags: .barrier) { [weak self] in
            self?.nativeRestAPILogHistoryArray.removeAll()
        }
    }
    
    fileprivate static func getNibBundle() -> Bundle? {
        if let bundleURL = Bundle.main.url(forResource: "VFTools_NativeCallAnalyzer",
                                           withExtension: "bundle", subdirectory: "Frameworks/VFTools.framework"),
            let bundle = Bundle(url: bundleURL) {
            return bundle
        }
        return nil
    }
}

public class APPNativeCallAnalyzerVC: UIViewController {
    
    enum DynamicCell {
        case collapse
        case expand
        
        func getHeight () -> CGFloat {
            switch self {
            case .collapse:
                return 164 
            case .expand:
                return 600
            }
        }
    }
    
    @IBOutlet fileprivate var tableCallList: UITableView?
    @IBOutlet fileprivate var exportLogBtn: UIButton?
    @IBOutlet fileprivate var enableCallLogBtn: UIButton!
    var presentingFrame: CGRect = .zero
    @IBOutlet private weak var closeButton: UIButton!
    fileprivate var indexArray: [IndexPath] = []
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        closeButton.isHidden = false
        tableCallList?.register(UINib(nibName: "APPNetworkCallAnalyzerCell",
                                      bundle: Bundle.main),
                                forCellReuseIdentifier: "APPNetworkCallAnalyzerCellID")
        
        if APPNativeCallAnalyzer.sharedInstance.isNativeAPILogEnable {
            enableCallLogBtn.isSelected = false
        } else {
            enableCallLogBtn.isSelected = true
        }
        self.btnEnablePressed(btnEnable: enableCallLogBtn)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableCallList?.dataSource = self
        tableCallList?.delegate = self
        tableCallList?.reloadData()
        tableCallList?.animateCells(duration: 0.6)
    }
    
    @IBAction func btnBackPressed(btnBack: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnEnablePressed(btnEnable: UIButton) {
        if btnEnable.isSelected {
            btnEnable.isSelected = false
            btnEnable.setTitle("Disabled", for: .normal)
            APPNativeCallAnalyzer.sharedInstance.isNativeAPILogEnable = false
            
        } else {
            btnEnable.isSelected = true
            btnEnable.setTitle("Enabled", for: .normal)
            APPNativeCallAnalyzer.sharedInstance.isNativeAPILogEnable = true
        }
    }
    
    @IBAction func btnClearCallPressed(btnClearCall: UIButton) {
        APPNativeCallAnalyzer.sharedInstance.clearLogs()
        tableCallList?.reloadData()
    }
    
    @IBAction func btnRefreshPressed(btnRefresh: UIButton) {
        tableCallList?.reloadData()
        tableCallList?.animateCells(duration: 0.3)
    }
    
    @IBAction func btnExportLogsPressed(btnExportLogs: UIButton) {
        var logs: [[String: Any]] = [[:]]
        
        for model: APPNativeCallAnalyzerModel in APPNativeCallAnalyzer.sharedInstance.getResponseArray() {
            var callLogDict: [String: Any] = [:]
            callLogDict["api"] = model.url
            callLogDict["url"] = model.url
            callLogDict["request"] = model.requestParameter
            callLogDict["response"] = model.responseString
            logs.append(callLogDict)
        }
        
        if logs.isEmpty == false {
            let callAnalyzerLogs: [String: Any] = ["callanalyser": logs]
            self.writeFiles(callAnalyzerLogs.description)
        }
    }
    
    func reloadTable() {
        self.tableCallList?.reloadData()
    }
    
    func writeFiles(_ jsonString: String) {
        guard jsonString.isEmpty == false  else {
            return
        }
        
        var directoryPath = self.getDirectoryPath()
        let currentDateString = String(describing: Date())
        directoryPath = directoryPath.appending("/\(currentDateString)-callanalyser.json")
        do {
            try jsonString.write(toFile: directoryPath, atomically: true, encoding: .utf8)
        } catch {
            print("Error writing to folder in documents dir: \(error)")
        }
    }
    
    func getDirectoryPath() -> String {
        guard let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                              .userDomainMask, true).first
            else { return "" }
        
        let logsDirectoryPath = documentDirectoryPath.appending("/CallAnalyzer")
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: logsDirectoryPath) {
            do {
                try fileManager.createDirectory(atPath: logsDirectoryPath,
                                                withIntermediateDirectories: false,
                                                attributes: nil)
            } catch {
                print("Error creating logs folder in documents dir: \(error)")
            }
        }
        
        return logsDirectoryPath
    }
    
    func removeDirectoryPath() {
        guard let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                              .userDomainMask, true).first
            else {
                return
        }
        
        let logsDirectoryPath = documentDirectoryPath.appending("/CallAnalyzer")
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: logsDirectoryPath) {
            try? fileManager.removeItem(atPath: logsDirectoryPath)
        }
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension APPNativeCallAnalyzerVC: UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return APPNativeCallAnalyzer.sharedInstance.getArrayCount()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "APPNetworkCallAnalyzerCellID",
                                                       for: indexPath) as? APPNetworkCallAnalyzerCell else {
                                                        return APPNetworkCallAnalyzerCell()
        }
        let model: APPNativeCallAnalyzerModel =
            APPNativeCallAnalyzer.sharedInstance.getResponseArray()[indexPath.row]
        cell.callAnalyzerData = model
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model: APPNativeCallAnalyzerModel =
            APPNativeCallAnalyzer.sharedInstance.getResponseArray()[indexPath.row]
        model.isExpanded = !model.isExpanded
        if self.indexArray.contains(indexPath) {
            self.indexArray = self.indexArray.filter({ $0 != indexPath })
        } else {
            self.indexArray.append(indexPath)
        }
        tableView.reloadData()
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.indexArray.contains(indexPath) {
            return DynamicCell.expand.getHeight()
        } else {
            return DynamicCell.collapse.getHeight()
        }
////        return UIScreen.main.bounds.height
    }
}

extension APPNativeCallAnalyzerVC: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController,
                                    source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let presentationAnimator = NativeCallAnalyzerPresentationAnimator()
        presentationAnimator.presentingFrame = presentingFrame
        return presentationAnimator
    }
    
    public func animationController(forDismissed dismissed: UIViewController) ->
        UIViewControllerAnimatedTransitioning? {
            let dismissAnimator = NativeCallAnalyzerDismissalAnimator()
            return dismissAnimator
    }
}

class NativeCallAnalyzerPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let xPadding: CGFloat = 20
    let yPadding: CGFloat = 15
    var presentingFrame: CGRect = .zero
    var shouldShowZoomAnimation: Bool = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return  0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        print("presentation delegate")
        if let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) {
            let containerView = transitionContext.containerView
            containerView.frame = presentingFrame
            toViewController.view.frame = containerView.bounds
            containerView.clipsToBounds = true
            toViewController.view.alpha = 0.0
            containerView.addSubview(toViewController.view)
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
                toViewController.view.alpha = 1.0
            }) { (finished) in
                transitionContext.completeTransition(finished)
            }
        }
    }
}

class NativeCallAnalyzerDismissalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return  0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let animationDuration = self .transitionDuration(using: transitionContext)
        UIView.animate(withDuration: animationDuration, animations: {
            containerView.alpha = 0.0
        }) { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}


public extension UITableView {
    
    func animateCells(duration: TimeInterval, completion: (() -> Void)? = nil) {
        self.animateWithFade(duration: duration, consecutively: true, completion: completion)
    }
    
    func reloadData(smoothly: Bool, completion: (() -> Void)? = nil) {
        guard smoothly else {
            self.reloadData()
            return
        }
        
        UIView.setAnimationsEnabled(false)
        CATransaction.begin()
        
        CATransaction.setCompletionBlock {
            UIView.setAnimationsEnabled(true)
            completion?()
        }
        
        self.reloadData()
        self.beginUpdates()
        self.endUpdates()
        CATransaction.commit()
    }
}

// MARK: UITableView animations
fileprivate extension UITableView {
    func animateWithFade(duration: TimeInterval, consecutively: Bool, completion: (() -> Void)? = nil) {
        if consecutively {
            for (index, cell) in self.visibleCells.enumerated() {
                let animationDelay: TimeInterval = duration / Double(visibleCells.count) * Double(index)
                cell.alpha = 0.0
                UIView.animate(withDuration: duration, delay: animationDelay, options: .curveEaseInOut, animations: {
                    cell.alpha = 1.0
                }, completion: { _ in
                    completion?()
                })
            }
        } else {
            let animation = UITableView.fadeAnimationTransition
            animation.duration = duration
            self.layer.add(animation, forKey: "UITableViewReloadDataAnimationKey")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(duration * 1000))) {
                completion?()
            }
        }
    }
    
    static let fadeAnimationTransition: CATransition = {
        let animation = CATransition()
        animation.type = kCATransitionFade
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fillMode = kCAFillModeBoth
        return animation
    }()
}
