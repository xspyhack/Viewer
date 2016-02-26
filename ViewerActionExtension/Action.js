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
        arguments.completionFunction({ "innerHTML" : document.all[0].innerHTML })
    },
    
    finalize: function(arguments) {
        // This method is run after the native code completes.
        
        // Replace it with new source code
        var newInnerHTML = arguments["newInnerHTML"]
        if (newInnerHTML) {
            document.all[0].innerHTML = newInnerHTML
        } else {
            alert(arguments["message"])
        }
    }
};
    
var ExtensionPreprocessingJS = new Action
