function setupWebViewJavascriptBridge(callback) {
    if (window.WebViewJavascriptBridge) { return callback(WebViewJavascriptBridge); }
    if (window.WVJBCallbacks) { return window.WVJBCallbacks.push(callback); }
    window.WVJBCallbacks = [callback];
    var WVJBIframe = document.createElement('iframe');
    WVJBIframe.style.display = 'none';
    WVJBIframe.src = 'wvjbscheme://__BRIDGE_LOADED__';
    document.documentElement.appendChild(WVJBIframe);
    setTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0)
}

setupWebViewJavascriptBridge(function(bridge) {
	function linkForImg(){
		var images=document.getElementsByTagName("img");
		var imgLen=images.length;
		for(var i=0;i<imgLen;i++){
			images[i].setAttribute("data-index",i)
			images[i].onclick = function(){
				bridge.callHandler('imageClickHandler',
								    {'index': this.getAttribute("data-index")}, 
									function(response) {})
			}
		}

		var images=document.querySelectorAll("p.media img");
		var imgLen=images.length;
		for(var i=0;i<imgLen;i++){
			images[i].setAttribute("data-index",i)
			images[i].onclick = function(){
				return 0;
			}
		}
	}
                             
	bridge.registerHandler('bindImages', function(data, responseCallback) {
	    linkForImg()
	    var values = new Array();
	    var images=document.getElementsByTagName("img");
	    var imgLen=images.length;
	    for(var i=0;i<imgLen;i++){
		    var index = images[i].getAttribute("data-index");
		    var src = images[i].getAttribute("src");
		    var value = {"src":src,"index":index};
		    values.push(value);
		}

		var responseData = { 'data':values }
		    responseCallback(responseData)
		})
})