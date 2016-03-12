//
//  ThemeHelper.swift
//  Viewer
//
//  Created by bl4ckra1sond3tre on 3/9/16.
//  Copyright © 2016 bl4ckra1sond3tre. All rights reserved.
//

import Foundation

struct ThemeHelper {

    enum Script: NameRepresentable, Iterable {
        
        enum Style: String, NameRepresentable, Iterable {
            case Github = "github.min.css"
            case Sublime = "monokai-sublime.min.css"
            case SolarizedDark = "solarized-dark.min.css"
            case SolarizedLight = "solarized-light.min.css"
            case Xcode = "xcode.min.css"
            
            var name: String {
                switch self {
                case .Github:
                    return "GitHub"
                case .Sublime:
                    return "Sublime"
                case .SolarizedDark:
                    return "Solarized Dark"
                case .SolarizedLight:
                    return "Solarized Light"
                case .Xcode:
                    return "Xcode"
                }
            }
            
            static let allValues = [Github, Sublime, SolarizedDark, SolarizedLight, Xcode]
        }
        
        case Default(Style)
        case Highlight(Style)
        case Rainbow(Style)
        
        static let allValues = [Default(.Github), Highlight(.Github), Rainbow(.Github)]
        
        var style: Style {
            get {
                switch self {
                case .Default(let style):
                    return style
                case .Highlight(let style):
                    return style
                case .Rainbow(let style):
                    return style
                }
            }
        }
        
        var name: String {
            switch self {
            case .Default:
                return "Default"
            case .Highlight:
                return "Highlight"
            case .Rainbow:
                return "Rainbow"
            }
        }

        static func script(name: String) -> Script {
            switch name {
            case "Default":
                return .Default(.Github)
            case "Highlight":
                return .Highlight(.Github)
            case "Rainbow":
                return .Rainbow(.Github)
            default:
                return .Default(.Github)
            }
        }
        
        private static let kHost = "http://cdn.bootcss.com"
        
        private var basePath: String {
            switch self {
            case .Default:
                return Script.kHost + "/"
            case .Highlight:
                return Script.kHost + "/highlight.js/9.2.0"
            case .Rainbow:
                return Script.kHost + "/rainbow/1.2.0"
            }
        }
        
        var scriptPath: String {
            switch self {
            case .Default:
                return basePath
            case .Highlight:
                return basePath + "/highlight.min.js"
            case .Rainbow:
                return basePath + "/js/rainbow.min.js"
            }
        }
        
        var runScript: String {
            switch self {
            case .Default:
                return ""
            case .Highlight:
                return "<script>hljs.initHighlightingOnLoad();</script>"
            case .Rainbow:
                //return "<script>Rainbow.color();</script>\n"
                let html = "<script src=\"" + basePath + "/js/language/html.min.js\"></script>"
                let javascript = "<script src=\"" + basePath + "/js/language/javascript.min.js\"></script>"
                let css = "<script src=\"" + basePath + "/js/language/css.min.js\"></script>"
                let generic = "<script src=\"" + basePath + "/js/language/generic.min.js\"></script>"
                return html + javascript + css + generic
            }
        }
        
        var stylePath: String {
            switch self {
            case .Default:
                return basePath
            case .Highlight:
                return basePath + "/styles/"
            case .Rainbow:
                return basePath + "/themes/"
            }
        }
    }
    
    
    private static let kStyleKey = "com.xspyhack.Style"
    private static let kScriptKey = "com.xspyhack.Script"
    
    mutating func resetScript(name: String, _ style: Script.Style) {
        switch name {
        case "Default":
            script = .Default(style)
        case "Highlight":
            script = .Highlight(style)
        case "Rainbow":
            script = .Rainbow(style)
        default:
            script = .Default(style)
        }
    }
    
    var script: Script = .Default(.Github)
    
    mutating func resetScript(script: Script, _ style: Script.Style) {
        switch script {
        case .Default:
            self.script = .Default(style)
        case .Highlight:
            self.script = .Highlight(style)
        case .Rainbow:
            self.script = .Rainbow(style)
        }
    }
    
    mutating func fetch() {
        let scriptName = NSUserDefaults.standardUserDefaults().objectForKey(ThemeHelper.kScriptKey) as? String
        let styleRawValue = NSUserDefaults.standardUserDefaults().objectForKey(ThemeHelper.kStyleKey) as? String
        let style = Script.Style(rawValue: styleRawValue ?? "github.min.css") ?? .Github
        resetScript(scriptName ?? "Default", style)
        tv_print(script.name)
        tv_print(script.style.rawValue)
    }
    
    func synchronize() {
        NSUserDefaults.standardUserDefaults().setObject(script.style.rawValue, forKey: ThemeHelper.kStyleKey)
        NSUserDefaults.standardUserDefaults().setObject(script.name, forKey: ThemeHelper.kScriptKey)
        tv_print(script.name)
        tv_print(script.style.rawValue)
    }
}

protocol Iterable {
    static var allValues: [Self] { get }
}

protocol NameRepresentable {
    var name: String { get }
}

extension NameRepresentable { }

