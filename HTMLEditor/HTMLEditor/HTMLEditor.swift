//
//  HTMLEditor.swift
//  HTMLEditor
//
//  Created by Weerasooriya, Tulakshana on 12/14/16.
//  Copyright © 2016 Tulakshana. All rights reserved.
//

import UIKit

enum WRIssueType: String {
    case concision
    case clarity
    case logic
    case grammar
    case spelling
}

class WRIssueText {
    var start:Int = 0
    var end:Int = 0
    var currentText:String = "" //saving this here because it will be useful to rollback the change
    var types:[WRIssue] = [WRIssue()]
}

extension String{
    
    func subString(from:Int, to:Int) -> String {
        if from > to {
            return ""
        }
        
        let start = self.index(self.startIndex, offsetBy: from)
        let end = self.index(self.startIndex, offsetBy: to - from)
        
        return self.substring(from: start).substring(to: end)
    }
    
    func replaceString(from:Int, to:Int, replacementString:String) -> String{
        if from > to {
            return ""
        }
        
        let toIndex = self.index(self.startIndex, offsetBy: from)
        let toText:String = self.substring(to: toIndex)
        
        let fromIndex = self.index(self.startIndex, offsetBy: to)
        let fromText:String = self.substring(from: fromIndex)
        
        return toText + replacementString + fromText
    }
    
    func javaScriptEscapedString() -> String {
        // Because JSON is not a subset of JavaScript, the LINE_SEPARATOR and PARAGRAPH_SEPARATOR unicode
        // characters embedded in (valid) JSON will cause the webview's JavaScript parser to error. So we
        // must encode them first. See here: http://timelessrepo.com/json-isnt-a-javascript-subset
        // Also here: http://media.giphy.com/media/wloGlwOXKijy8/giphy.gif
        let str = self
            .replacingOccurrences(of: "\u{2028}", with: "\\u2028")
            .replacingOccurrences(of: "\u{2029}", with: "\\u2029")
        // Because escaping JavaScript is a non-trivial task (https://github.com/johnezang/JSONKit/blob/master/JSONKit.m#L1423)
        // we proceed to hax instead:
        let data = try! JSONSerialization.data(withJSONObject: [str], options: [])
//        let data = try! JSONSerialization.dataWithJSONObject([str], options: [])
        let encodedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
        return encodedString.substring(with: NSMakeRange(1, encodedString.length - 2))
//        return encodedString.substringWithRange(NSMakeRange(1, encodedString.length - 2))
    }
    
    var html: String {
        get {
            let enc:  [Character:String] = [" ":"&emsp;", " ":"&ensp;"/*, " ":"&nbsp;"*/, " ":"&thinsp;", "‾":"&oline;", "–":"&ndash;", "—":"&mdash;", "¡":"&iexcl;", "¿":"&iquest;", "…":"&hellip;", "·":"&middot;", "'":"&apos;", "‘":"&lsquo;", "’":"&rsquo;", "‚":"&sbquo;", "‹":"&lsaquo;", "›":"&rsaquo;", "‎":"&lrm;", "‏":"&rlm;", "­":"&shy;", "‍":"&zwj;", "‌":"&zwnj;", "\"":"&quot;", "“":"&ldquo;", "”":"&rdquo;", "„":"&bdquo;", "«":"&laquo;", "»":"&raquo;", "⌈":"&lceil;", "⌉":"&rceil;", "⌊":"&lfloor;", "⌋":"&rfloor;", "〈":"&lang;", "〉":"&rang;", "§":"&sect;", "¶":"&para;", "&":"&amp;", "‰":"&permil;", "†":"&dagger;", "‡":"&Dagger;", "•":"&bull;", "′":"&prime;", "″":"&Prime;", "´":"&acute;", "˜":"&tilde;", "¯":"&macr;", "¨":"&uml;", "¸":"&cedil;", "ˆ":"&circ;", "°":"&deg;", "©":"&copy;", "®":"&reg;", "℘":"&weierp;", "←":"&larr;", "→":"&rarr;", "↑":"&uarr;", "↓":"&darr;", "↔":"&harr;", "↵":"&crarr;", "⇐":"&lArr;", "⇑":"&uArr;", "⇒":"&rArr;", "⇓":"&dArr;", "⇔":"&hArr;", "∀":"&forall;", "∂":"&part;", "∃":"&exist;", "∅":"&empty;", "∇":"&nabla;", "∈":"&isin;", "∉":"&notin;", "∋":"&ni;", "∏":"&prod;", "∑":"&sum;", "±":"&plusmn;", "÷":"&divide;", "×":"&times;", "<":"&lt;", "≠":"&ne;", ">":"&gt;", "¬":"&not;", "¦":"&brvbar;", "−":"&minus;", "⁄":"&frasl;", "∗":"&lowast;", "√":"&radic;", "∝":"&prop;", "∞":"&infin;", "∠":"&ang;", "∧":"&and;", "∨":"&or;", "∩":"&cap;", "∪":"&cup;", "∫":"&int;", "∴":"&there4;", "∼":"&sim;", "≅":"&cong;", "≈":"&asymp;", "≡":"&equiv;", "≤":"&le;", "≥":"&ge;", "⊄":"&nsub;", "⊂":"&sub;", "⊃":"&sup;", "⊆":"&sube;", "⊇":"&supe;", "⊕":"&oplus;", "⊗":"&otimes;", "⊥":"&perp;", "⋅":"&sdot;", "◊":"&loz;", "♠":"&spades;", "♣":"&clubs;", "♥":"&hearts;", "♦":"&diams;", "¤":"&curren;", "¢":"&cent;", "£":"&pound;", "¥":"&yen;", "€":"&euro;", "¹":"&sup1;", "½":"&frac12;", "¼":"&frac14;", "²":"&sup2;", "³":"&sup3;", "¾":"&frac34;", "á":"&aacute;", "Á":"&Aacute;", "â":"&acirc;", "Â":"&Acirc;", "à":"&agrave;", "À":"&Agrave;", "å":"&aring;", "Å":"&Aring;", "ã":"&atilde;", "Ã":"&Atilde;", "ä":"&auml;", "Ä":"&Auml;", "ª":"&ordf;", "æ":"&aelig;", "Æ":"&AElig;", "ç":"&ccedil;", "Ç":"&Ccedil;", "ð":"&eth;", "Ð":"&ETH;", "é":"&eacute;", "É":"&Eacute;", "ê":"&ecirc;", "Ê":"&Ecirc;", "è":"&egrave;", "È":"&Egrave;", "ë":"&euml;", "Ë":"&Euml;", "ƒ":"&fnof;", "í":"&iacute;", "Í":"&Iacute;", "î":"&icirc;", "Î":"&Icirc;", "ì":"&igrave;", "Ì":"&Igrave;", "ℑ":"&image;", "ï":"&iuml;", "Ï":"&Iuml;", "ñ":"&ntilde;", "Ñ":"&Ntilde;", "ó":"&oacute;", "Ó":"&Oacute;", "ô":"&ocirc;", "Ô":"&Ocirc;", "ò":"&ograve;", "Ò":"&Ograve;", "º":"&ordm;", "ø":"&oslash;", "Ø":"&Oslash;", "õ":"&otilde;", "Õ":"&Otilde;", "ö":"&ouml;", "Ö":"&Ouml;", "œ":"&oelig;", "Œ":"&OElig;", "ℜ":"&real;", "š":"&scaron;", "Š":"&Scaron;", "ß":"&szlig;", "™":"&trade;", "ú":"&uacute;", "Ú":"&Uacute;", "û":"&ucirc;", "Û":"&Ucirc;", "ù":"&ugrave;", "Ù":"&Ugrave;", "ü":"&uuml;", "Ü":"&Uuml;", "ý":"&yacute;", "Ý":"&Yacute;", "ÿ":"&yuml;", "Ÿ":"&Yuml;", "þ":"&thorn;", "Þ":"&THORN;", "α":"&alpha;", "Α":"&Alpha;", "β":"&beta;", "Β":"&Beta;", "γ":"&gamma;", "Γ":"&Gamma;", "δ":"&delta;", "Δ":"&Delta;", "ε":"&epsilon;", "Ε":"&Epsilon;", "ζ":"&zeta;", "Ζ":"&Zeta;", "η":"&eta;", "Η":"&Eta;", "θ":"&theta;", "Θ":"&Theta;", "ϑ":"&thetasym;", "ι":"&iota;", "Ι":"&Iota;", "κ":"&kappa;", "Κ":"&Kappa;", "λ":"&lambda;", "Λ":"&Lambda;", "µ":"&micro;", "μ":"&mu;", "Μ":"&Mu;", "ν":"&nu;", "Ν":"&Nu;", "ξ":"&xi;", "Ξ":"&Xi;", "ο":"&omicron;", "Ο":"&Omicron;", "π":"&pi;", "Π":"&Pi;", "ϖ":"&piv;", "ρ":"&rho;", "Ρ":"&Rho;", "σ":"&sigma;", "Σ":"&Sigma;", "ς":"&sigmaf;", "τ":"&tau;", "Τ":"&Tau;", "ϒ":"&upsih;", "υ":"&upsilon;", "Υ":"&Upsilon;", "φ":"&phi;", "Φ":"&Phi;", "χ":"&chi;", "Χ":"&Chi;", "ψ":"&psi;", "Ψ":"&Psi;", "ω":"&omega;", "Ω":"&Omega;", "ℵ":"&alefsym;"]

            var html = ""
            for c in self.characters {
                if let entity = enc[c] {
                    html.append(entity)
                } else {
                    html.append(c)
                }
            }
            return html
        }
    }
}

class HTMLEditor: UIWebView {
    
    static let URL_SCHEME_WRITING_REVIEW = "wr"
    static let URL_QUERY_ITEM_ISSUE_INDEX = "issueIndex"
    
    var editable:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let filepath = Bundle.main.path(forResource: "editor", ofType: "html") {
            do {
                let htmlString:String = try String.init(contentsOfFile: filepath)
                self.loadHTMLString(htmlString, baseURL: nil)
            } catch {
                // contents could not be loaded
            }
        } else {
            // editor.html not found!
        }
        
        self.keyboardDisplayRequiresUserAction = false
    }
    
    func loadContent(content:String) {
        self.stringByEvaluatingJavaScript(from: "insertTextToEditor(" + content.javaScriptEscapedString() + ")")
    }
    
    func htmlIndexFor(index: Int, text: String) -> Int {
        let letters: [String] = text.characters.map { String($0) }
        
        var cursor: Int = 0
        var tagOpened: Bool = false
        var wrTagOpened: Bool = false
        for k: Int in 0...(letters.count - 1) {
            let currentLetter: String = letters[k]
            
            if tagOpened || wrTagOpened {
                if currentLetter == ">" {
                    tagOpened = false
                }
            }else {
                if currentLetter == "<" {
                    tagOpened = true
                    if (k + 1) <= (letters.count - 1) {
                        wrTagOpened = (letters[k+1] == "w")
                    }
                }else {
                    if index == cursor {
                        return k
                    }
                    cursor = cursor + 1
                }
            }
        }
        return 0
    }
    
    func markIssues(issues:[WRIssueText]) {
        if issues.count <= 0 {
            return
        }

        //Optional sorting code. To be deleted when the APIs finalized
//        var issuesArray:[WRIssueText] = issues.sorted { (obj1, obj2) -> Bool in
//            obj1.start < obj2.start
//        }
        let issuesArray:[WRIssueText] = issues
        
        self.removeIssues()

        if var markedContent:String = self.stringByEvaluatingJavaScript(from: "textFromEditor()") {
            if markedContent.characters.count <= 0 {
                return
            }

            for i in 0...(issuesArray.count - 1){
                let issueText:WRIssueText = issuesArray[i]
                if issueText.types.count <= 0 {
                    continue
                }
                
                let htmlStartIndex = self.htmlIndexFor(index: issueText.start, text: markedContent)
                let htmlEndIndex = self.htmlIndexFor(index: issueText.end, text: markedContent)
                
                issueText.currentText = markedContent.subString(from: htmlStartIndex, to: htmlEndIndex)
                
                var replacement = ""
                
                for j in 0...(issueText.types.count - 1){
                    let issue:WRIssue = issueText.types[j]
                    if j == 0 {
                        replacement = "<WRSpan class=\"" + issue.type.rawValue + " issue\" onTouchStart=selectIssue(" + String(i) + ",event); id=te" + String(i) + "><WRSpan class=issueCategory id=ce" + String(i) + ">"
                    }
                    switch issue.type {
                    case WRIssueType.clarity:
                        replacement = replacement + "<WRSpan class=cl role=\"note\" aria-label=\"" + issue.type.rawValue + "\">Cl </WRSpan>"
                    case WRIssueType.concision:
                        replacement = replacement + "<WRSpan class=co role=\"note\" aria-label=\"" + issue.type.rawValue + "\">Co </WRSpan>"
                    case WRIssueType.grammar:
                        replacement = replacement + "<WRSpan class=g role=\"note\" aria-label=\"" + issue.type.rawValue + "\">G </WRSpan>"
                    case WRIssueType.logic:
                        replacement = replacement + "<WRSpan class=l role=\"note\" aria-label=\"" + issue.type.rawValue + "\">L </WRSpan>"
                    case WRIssueType.spelling:
                        replacement = replacement + "<WRSpan class=s role=\"note\" aria-label=\"" + issue.type.rawValue + "\">S </WRSpan>"
                    }
                }
                
                replacement = replacement + "</WRSpan>" + issueText.currentText + "</WRSpan>"
                
                markedContent = markedContent.replaceString(from: htmlStartIndex, to: htmlEndIndex, replacementString: replacement)
            }
            self.loadContent(content: markedContent)
        }
    }
    
    func removeIssues() {
        self.stringByEvaluatingJavaScript(from: "removeAllIssues()")
    }
    
    func toggleEditMode() -> Bool{
        editable = !editable
        var value:String = "true"
        if editable == false {
            value = "false"
            self.endEditing(true)
        }
        self.stringByEvaluatingJavaScript(from: "toggleEditMode(" + value + ")")
        
        return editable
    }
}
