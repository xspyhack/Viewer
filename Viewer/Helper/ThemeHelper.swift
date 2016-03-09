//
//  ThemeHelper.swift
//  Viewer
//
//  Created by bl4ckra1sond3tre on 3/9/16.
//  Copyright © 2016 bl4ckra1sond3tre. All rights reserved.
//

import Foundation

struct ThemeHelper {
    enum Style: String {
        case Github = "github.min.css"
        case Sublime = "monokai_sublime.min.css"
        case SolarizedDark = "solarized-dark.min.css"
        case SolarizedLight = "solarized-light.min.css"
        case Xcode = "xcode.min.css"
    }
    
    enum Script {
        case Default(style: Style)
        case Highlight(style: Style)
        case Rainbow(style: Style)
        
        var style: Style {
            switch self {
            case .Default(let style):
                return style
            case .Highlight(let style):
                return style
            case .Rainbow(let style):
                return style
            }
        }
        
        private static let host = "http://cdn.bootcss.com"
        
        private var basePath: String {
            switch self {
            case .Default:
                return Script.host + "/"
            case .Highlight:
                return Script.host + "/highlight.js/9.2.0"
            case .Rainbow:
                return Script.host + "/rainbow/1.2.0"
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
                return "<script>hljs.initHighlightingOnLoad();</script>\n"
            case .Rainbow:
                //return "<script>Rainbow.color();</script>\n"
                let html = "<script src=\"" + basePath + "/js/language/html.min.js\"></script>\n"
                let javascript = "<script src=\"" + basePath + "/js/language/javascript.min.js\"></script>\n"
                let css = "<script src=\"" + basePath + "/js/language/css.min.js\"></script>\n"
                let generic = "<script src=\"" + basePath + "/js/language/generic.min.js\"></script>\n"
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
    
    static let shareHelper = ThemeHelper()
    var script: Script = .Default(style: .Github)
}