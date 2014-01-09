(function () {

	var getElementsByClassName = function (className, tag, elm){
		if (document.getElementsByClassName) {
			getElementsByClassName = function (className, tag, elm) {
				elm = elm || document;
				var elements = elm.getElementsByClassName(className),
					nodeName = (tag)? new RegExp("\\b" + tag + "\\b", "i") : null,
					returnElements = [],
					current;
				for(var i=0, il=elements.length; i<il; i+=1){
					current = elements[i];
					if(!nodeName || nodeName.test(current.nodeName)) {
						returnElements.push(current);
					}
				}
				return returnElements;
			};
		}
		else if (document.evaluate) {
			getElementsByClassName = function (className, tag, elm) {
				tag = tag || "*";
				elm = elm || document;
				var classes = className.split(" "),
					classesToCheck = "",
					xhtmlNamespace = "http://www.w3.org/1999/xhtml",
					namespaceResolver = (document.documentElement.namespaceURI === xhtmlNamespace)? xhtmlNamespace : null,
					returnElements = [],
					elements,
					node;
				for(var j=0, jl=classes.length; j<jl; j+=1){
					classesToCheck += "[contains(concat(' ', @class, ' '), ' " + classes[j] + " ')]";
				}
				try	{
					elements = document.evaluate(".//" + tag + classesToCheck, elm, namespaceResolver, 0, null);
				}
				catch (e) {
					elements = document.evaluate(".//" + tag + classesToCheck, elm, null, 0, null);
				}
				while ((node = elements.iterateNext())) {
					returnElements.push(node);
				}
				return returnElements;
			};
		}
		else {
			getElementsByClassName = function (className, tag, elm) {
				tag = tag || "*";
				elm = elm || document;
				var classes = className.split(" "),
					classesToCheck = [],
					elements = (tag === "*" && elm.all)? elm.all : elm.getElementsByTagName(tag),
					current,
					returnElements = [],
					match;
				for(var k=0, kl=classes.length; k<kl; k+=1){
					classesToCheck.push(new RegExp("(^|\\s)" + classes[k] + "(\\s|$)"));
				}
				for(var l=0, ll=elements.length; l<ll; l+=1){
					current = elements[l];
					match = false;
					for(var m=0, ml=classesToCheck.length; m<ml; m+=1){
						match = classesToCheck[m].test(current.className);
						if (!match) {
							break;
						}
					}
					if (match) {
						returnElements.push(current);
					}
				}
				return returnElements;
			};
		}
		return getElementsByClassName(className, tag, elm);
	};

    var blClean = function () {
        setTimeout(function () {
            var customLink = getElementsByClassName("sidebarModule linksModule");
            var result = sforce.connection.query("Select Id, WalkMe4sf__LicenseID__c From WalkMe4sf__WalkMeLicense__c");
            var records = result.getArray("records");
            var LicenseNumber = records[0].WalkMe4sf__LicenseID__c;
            
			var user = sforce.connection.getUserInfo();
			window.walkme_username = user.userName;
			window.walkme_profileid = user.profileId;
			window.walkme_language = user.userLanguage;
			window.walkme_orgid = user.organizationId;
			
			
            if (records.length == 0) {
                alert("No Record");
            } else {
                try {
                    var doc = window.top.document;
                    var head = document.getElementsByTagName('head')[0];
                    var scriptElement = doc.createElement('script');
                    scriptElement.async = true;
                    scriptElement.src = "https://d3b3ehuo35wzeh.cloudfront.net/users/" + LicenseNumber + "/walkme_" + LicenseNumber + "_https.js";
                    head.appendChild(scriptElement);
                } catch (e) {}
            }
        }, 1)
    };
    if (window.attachEvent) {
        window.attachEvent('onload', blClean);
    } else {
        window.addEventListener('load', blClean, false);
    }
})();