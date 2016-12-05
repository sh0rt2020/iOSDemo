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

    function dealWithImages() {
        var allImage = document.querySelectorAll("img");
        allImage = Array.prototype.slice.call(allImage, 0);
        allImage.forEach(function(image) {
            image.src = image.getAttribute("esrc");
        });
    }

    //get all images in web page and replace the 'src' with 'esrc'
    bridge.registerHandler('bindImages', function(data, responseCallback) {
        linkForImg()
        var allImage = document.querySelectorAll("img");
        allImage = Array.prototype.slice.call(allImage, 0);
        var imageUrlsArray = new Array();
        allImage.forEach(function(image) {                         
            var index = image.getAttribute("data-index");
            var src = image.getAttribute("esrc");
            var value = {"src":src,"index":index};
            imageUrlsArray.push(value);
        });
        var responseData = { 'data':imageUrlsArray }
        responseCallback(responseData)
    })


    //native code complete image download
    bridge.registerHandler('imagesDownloadComplete', function(data, responseCallback) {
                        dealWithImages()
                        })
})
