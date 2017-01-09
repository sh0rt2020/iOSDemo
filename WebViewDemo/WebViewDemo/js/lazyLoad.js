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
    
    function replaceServerImageWithLocalImage(pOldUrl, pNewUrl) {
    	var images=document.getElementsByTagName("img");
		for(var i=0;i<images.length;i++){
			var image = images[i]
			if (image.getAttribute("sbsrc") == pOldUrl || image.getAttribute("sbsrc") == decodeURIComponent(pOldUrl)) {
				image.src = pNewUrl
			}

			image.setAttribute("data-index",i)
			image.onclick = function(){
				bridge.callHandler('imageClickHandler',
								    {'index': this.getAttribute("data-index")}, 
									function(response) {})
			}
		}
    }
                             
    bridge.registerHandler('finishDownloadImgs', function(data, responseCallback) {
        console.log("加载本地图片");
        replaceServerImageWithLocalImage();
    })
})
