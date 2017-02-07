//
//  ViewController.swift
//  HTMLEditor
//
//  Created by Weerasooriya, Tulakshana on 12/14/16.
//  Copyright © 2016 Tulakshana. All rights reserved.
//

import UIKit

extension ViewController: UIWebViewDelegate {
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        print(request.url ?? "Could not read url")
        
        if let url: URL = request.url {
            let components: URLComponents? = URLComponents(url: url, resolvingAgainstBaseURL: true)
            print(components?.scheme ?? "No url scheme provided")
            if components?.scheme == HTMLEditor.URL_SCHEME_WRITING_REVIEW {
                if let queryItems: [URLQueryItem] = components?.queryItems {
                    
                    for item: URLQueryItem in queryItems {
                        if item.name == HTMLEditor.URL_QUERY_ITEM_ISSUE_INDEX {
                            if let arrayIndex: Int = Int(item.value ?? "") {
                                self.didSelectText(index: arrayIndex)
                                return false
                            }
                        }
                    }
                }
            }
        }
        
        return true
    }

    public func webViewDidStartLoad(_ webView: UIWebView) {
        print(#function)
    }

    public func webViewDidFinishLoad(_ webView: UIWebView) {
        print(#function)
    }

    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print(error.localizedDescription)
    }
}

class ViewController: UIViewController {
    
    @IBOutlet var editor: HTMLEditor?
    @IBOutlet var btnEdit: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - 
    
    @IBAction func toggleEdit() {
        if let editable:Bool = editor?.toggleEditMode(){
            if editable {
                btnEdit?.setTitle("exit edit mode", for: UIControlState.normal)
            }else {
                btnEdit?.setTitle("edit", for: UIControlState.normal)
            }
        }
    }
    
    @IBAction func removeIssues() {
        editor?.removeIssues()
    }
    
    @IBAction func addDummyIssues() {
        
        let issue:WRIssueText = WRIssueText()
        issue.start = 5
        issue.end = 7
        issue.types = [WRIssue.init(issueType: WRIssueType.spelling, issueDetails: "")]
        
        let issue2:WRIssueText = WRIssueText()
        issue2.start = 0
        issue2.end = 23
        issue2.types = [WRIssue.init(issueType: WRIssueType.grammar, issueDetails: "")]
        
        let issue3:WRIssueText = WRIssueText()
        issue3.start = 29
        issue3.end = 120
        issue3.types = [WRIssue.init(issueType: WRIssueType.clarity, issueDetails: ""), WRIssue.init(issueType: WRIssueType.logic, issueDetails: ""), WRIssue.init(issueType: WRIssueType.concision, issueDetails: ""), WRIssue.init(issueType: WRIssueType.grammar, issueDetails: "")]
        
        let issue4:WRIssueText = WRIssueText()
        issue4.start = 130
        issue4.end = 135
        issue4.types = [WRIssue.init(issueType: WRIssueType.logic, issueDetails: "")]
        
        let issue5:WRIssueText = WRIssueText()
        issue5.start = 34
        issue5.end = 38
        issue5.types = [WRIssue.init(issueType: WRIssueType.spelling, issueDetails: "")]
        
        let issue6:WRIssueText = WRIssueText()
        issue6.start = 149
        issue6.end = 157
        issue6.types = [WRIssue.init(issueType: WRIssueType.grammar, issueDetails: "")]
        
        let issue7:WRIssueText = WRIssueText()
        issue7.start = 150
        issue7.end = 152
        issue7.types = [WRIssue.init(issueType: WRIssueType.concision, issueDetails: "")]
        
        let issue8:WRIssueText = WRIssueText()
        issue8.start = 12
        issue8.end = 16
        issue8.types = [WRIssue.init(issueType: WRIssueType.spelling, issueDetails: "")]
        //
        
        let array:[WRIssueText] = [issue,issue2,issue3,issue4/*,issue5,issue6,issue7,issue8*/]
        editor?.markIssues(issues: array)
    }
    
    @IBAction func addDummyContent() {
        editor?.loadContent(content: "<pre>This as a <b>sample</b> text.\n\n In lite of the growing ubiquity of mobile phones within the context of developing counties, there is a gap in understanding the information and communication needs of rural users. Using the backdrop of Uganda, this work reports on a detailed study, of rural users of various information and communications technologies (ICTs). It explores how rural users prioritise various information needs, identifies their current methods of information access, their frequency of information access as well as their satisfaction level with the information that they do receive. The study discusses priorities and gaps in current access to information that may highlight opportunities for mobile applications. The study sample includes an urban component that is used for purposes of contrasting differences between rural and urban information practices as well as exploring the communication linkages that do exist between the two sides.</pre>")
    }
    
    //MARK:- 
    
    func didSelectText(index: Int) {
        print(#function)
        print(String(index))
    }
}

