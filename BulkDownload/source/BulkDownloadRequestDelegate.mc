using Toybox.Communications;

// Helper class makes a web or image request with context data.
class BulkDownloadRequestDelegate
{
    hidden var mCallback;
    hidden var mContext;

    // Initialize self
    //
    // callback is the Lang.Method to invoke when the request completes.
    // It is expected to take three parameters; the response code, the
    // response data, and the context.
    // context is the Lang.Object to pass to callback.
    function initialize(callback, context) {
        mCallback = callback;
        mContext = context;
    }

    // Make a web request using the given options.
    function makeWebRequest(url, params, options) {
        Communications.makeWebRequest(url, params, options, self.method(:onResponse));
    }

    // Make an image request using the given options.
    function makeImageRequest(url, params, options) {
        Communications.makeImageRequest(url, params, options, self.method(:onResponse));
    }

    // Implementation detail
    function onResponse(code, data) {
        return mCallback.invoke(code, data, mContext);
    }
}
