//
//  Action.js
//  ViewerActionExtension
//
//  Created by bl4ckra1sond3tre on 2/25/16.
//  Copyright © 2016 bl4ckra1sond3tre. All rights reserved.
//

var Action = function() {};

Action.prototype = {
    
    run: function(arguments) {
        // Here, you can run code that modifies the document and/or prepares
        // things to pass to your action's native code.
        
        // Get the source code of <HTML>.
        // Maybe document.documentElement.outerHTML
        // If you need to parse the source code, you can
        //arguments.completionFunction({ "html": document.documentElement.outerHTML })
        arguments.completionFunction({ "html": "The Viewer" })
    },
    
    finalize: function(arguments) {
        // This method is run after the native code completes.
        
        // Create the script & style
        var script = document.createElement("script"), style = document.createElement("style");
        //var html = document.createTextNode(arguments["html"]);
        var html = document.createTextNode(document.documentElement.outerHTML);
        
        script.type = "text/javascript";
        script.appendChild(document.createTextNode(arguments["script"]));
        script.appendChild(document.createTextNode("; Rainbow.color()")); // Load script
        
        style.type = "text/css";
        style.innerHTML = arguments["style"];
        
        document.write("<pre><code id=\"source\" data-language=\"html\"></code></pre>");
        
        document.getElementById("source").appendChild(html);
        
        // Append to document
        document.head.appendChild(script);
        document.head.appendChild(style);
        
        alert(document)
    }
};
    
var ExtensionPreprocessingJS = new Action
