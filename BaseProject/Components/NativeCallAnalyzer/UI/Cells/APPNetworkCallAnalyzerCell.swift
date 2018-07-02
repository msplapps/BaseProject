//
//  APPNetworkCallAnalyzerCell.swift
//  NativeCallAnalyzer
//
//  Created by Santhosh Marripelli on 28/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import UIKit
import UIKit

extension String {
    var lastPathComponent: String {
        let components = self.split(separator: "/")
        let words = components.count - 1
        return components.dropFirst(words).map(String.init)[0]
    }
}

class APPNetworkCallAnalyzerCell: UITableViewCell {
    
    var callAnalyzerData: APPNativeCallAnalyzerModel? {
        didSet {
            guard let callAnalyzerData = callAnalyzerData else {
                return
            }
            unSelectAllButtons()
            btnResponseData.isSelected = true
            lblUrlName?.text = callAnalyzerData.url.lastPathComponent
            lblTotalTime?.text = "Time Taken(sec): \(callAnalyzerData.callTime ?? "")"
            lblStatusDesc?.text = "Status Code: \(callAnalyzerData.responseStatus ?? "")"
            lblByteSent?.text = "Bytes Sent: \(callAnalyzerData.requestSize ?? "")"
            lblByteReceived?.text = "Bytes Received: \(callAnalyzerData.responseSize ?? "")"
            
            if callAnalyzerData.errorDescription != nil {
                detailTextView?.text = callAnalyzerData.errorDescription
            } else {
                detailTextView?.text = callAnalyzerData.responseString
            }
        }
    }
    
    @IBOutlet private var searchBar: UISearchBar?
    @IBOutlet private var lblUrlName: UILabel?
    @IBOutlet private var lblTotalTime: UILabel?
    @IBOutlet private var lblByteSent: UILabel?
    @IBOutlet private var lblByteReceived: UILabel?
    @IBOutlet private var lblStatusDesc: UILabel?
    @IBOutlet fileprivate var lblSearchCount: UILabel?
    
    @IBOutlet private var btnHeader: UIButton!
    @IBOutlet private var btnParametr: UIButton!
    @IBOutlet private var btnResponseDesc: UIButton!
    @IBOutlet private var btnResponseData: UIButton!
    @IBOutlet private var btnError: UIButton!
    @IBOutlet fileprivate weak var nextButton: UIButton!
    
    @IBOutlet fileprivate var detailTextView: UITextView?
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var optionsStackView: UIStackView!
    @IBOutlet weak var searchStackView: UIStackView!
    
    
    
    
    
    
    var attributedString: NSMutableAttributedString?
    var searchResultArray: [NSRange] = [NSRange]()
    var searchResultIndex: Int = 0
    var upimage: UIImage?
    var downimage: UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.accessoryType = .none
        searchBar?.delegate = self
        nextButton.isEnabled = false
        detailTextView?.layer.borderColor = UIColor.gray.cgColor
        detailTextView?.layer.borderWidth = 1.0
        self.textLabel?.font = UIFont.systemFont(ofSize: 20)
    }
    
    private func unSelectAllButtons() {
        btnHeader?.isSelected = false
        btnParametr?.isSelected = false
        btnResponseDesc?.isSelected = false
        btnResponseData?.isSelected = false
        btnError?.isSelected = false
        searchBar?.text = nil
        lblSearchCount?.text = "0"
    }
    
    fileprivate func reloadDescText(text: String) {
        
        guard let descriptionString = detailTextView?.text, descriptionString.count >= text.count else {
            return
        }
        var count = 0
        searchResultIndex = 0
        searchResultArray.removeAll()
        attributedString = NSMutableAttributedString(string: descriptionString)
        do {
            let regex = try NSRegularExpression(pattern: text, options: .caseInsensitive)
            let range = NSRange(location: 0, length: descriptionString.utf16.count)
            for match in regex.matches(in: descriptionString,
                                       options: .withTransparentBounds,
                                       range: range) {
                                        attributedString?.addAttribute(NSAttributedStringKey.font,
                                                                       value: UIFont.systemFont(ofSize: 16,
                                                                                                weight: UIFont.Weight.bold),
                                                                       range: match.range)
                                        attributedString?.addAttribute(NSAttributedStringKey.foregroundColor,
                                                                       value: UIColor.blue,
                                                                       range: match.range)
                                        searchResultArray.append(match.range)
                                        count += 1
            }
            lblSearchCount?.text = "count: \(count)"
            detailTextView?.attributedText = attributedString
            self.scrollToSerachString()
            self.nextButton.isEnabled = searchResultArray.isEmpty ? false : true
        } catch _ {
            debugPrint("Faild to find target string")
        }
    }
    
    fileprivate func resetHighLightString() {
        guard let descriptionString = detailTextView?.text else {
            return
        }
        let attributedString = NSMutableAttributedString(string: descriptionString)
        let range = NSRange(location: 0, length: descriptionString.utf16.count)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor,
                                      value: UIColor.black,
                                      range: range)
        detailTextView?.attributedText = attributedString
    }
    
    fileprivate func scrollToSerachString () {
        
        guard let text = searchBar?.text, !text.isEmpty else {
            return
        }
        
        guard !searchResultArray.isEmpty else {
            return
        }
        
        for range in searchResultArray {
            attributedString?.addAttribute(NSAttributedStringKey.foregroundColor,
                                           value: UIColor.blue,
                                           range: range)
        }
        let selectedRange = searchResultArray[searchResultIndex]
        detailTextView?.scrollRangeToVisible(selectedRange)
        attributedString?.addAttribute(NSAttributedStringKey.foregroundColor,
                                       value: UIColor.red,
                                       range: selectedRange)
        detailTextView?.attributedText = attributedString
        lblSearchCount?.text = "\(searchResultIndex + 1) of \(searchResultArray.count)"
        if searchResultIndex == searchResultArray.count - 1 {
            searchResultIndex = 0
        } else {
            searchResultIndex += 1
        }
    }
    
    @IBAction func showDetails(sender: UIButton) {
        attributedString = nil
        self.unSelectAllButtons()
        sender.isSelected = !sender.isSelected
        switch sender {
        case btnHeader:
            detailTextView?.text = callAnalyzerData?.requestHeaderParameter.description
        case btnParametr:
            detailTextView?.text = callAnalyzerData?.requestParameter.description
        case btnResponseDesc:
            guard let status = callAnalyzerData?.statusDescription else {
                break
            }
            detailTextView?.text = status
        case btnResponseData:
            guard let response = callAnalyzerData?.responseString else {
                break
            }
            detailTextView?.text = response
        case btnError:
            guard let error = callAnalyzerData?.errorDescription else {
                detailTextView?.text = "No error"
                break
            }
            detailTextView?.text = error
        default:
            detailTextView?.text = callAnalyzerData?.requestHeaderParameter.description
        }
    }
    
    @IBAction func nextSearchString(_ sender: Any) {
        self.scrollToSerachString()
    }
}

extension APPNetworkCallAnalyzerCell: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            attributedString = nil
            self.lblSearchCount?.text = "0"
            self.resetHighLightString()
            self.nextButton.isEnabled = false
        }
        self.reloadDescText(text: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        attributedString = nil
        self.lblSearchCount?.text = "0"
        searchBar.text = nil
        self.resetHighLightString()
        self.nextButton.isEnabled = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.scrollToSerachString()
    }
}
