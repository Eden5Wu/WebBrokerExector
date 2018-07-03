/*
 * Class for executing methods from the class hosted at the specified address/port
 * @param className The name of the class on the server methods will be invoked on
 * @param connectionInfo a map of key/value pairs with required connection info. Currently supported properties are as follows:
 *       - "host" (host to connect to)
 *       - "port" (port on the host to connect on)
 *       - "authentication" (optional base64 encoded user:password pair, encoded as a single string, including the colon)
 *       - "pathPrefix" (optional URL segment to place after the host/port but before the REST url segments.)
 *       - "dscontext" (what to put in the URL for datasnap. If not specified, defaults to 'datasnap' ... as in /datasnap/rest/)
 *       - "restcontext" (what to put in the URL for rest. If not specified, defaults to 'rest' ... as in /datasnap/rest/) 
 * @param owner an optional parameter: another JavaScript object which owns this executor. This value will be passed 
 *         to the callback provided in the executeMethod call, if any.
 */
function WebBrokerFunctionExecutor(className, connectionInfo, owner)
{
  this.connectionInfo = connectionInfo;
  //if host or port aren't given in the connectionInfo then they are taken from the current URL
  this.host = getConnectionHost(connectionInfo);
  this.port = getConnectionPort(connectionInfo);
  this.dsContext = getDSContext(connectionInfo); //should be empty string, or end with a '/'
  this.restContext = getRestContext(connectionInfo); //should be empty string, or end with a '/'
  this.cacheContext = getCacheContext(connectionInfo); //must not be empty, defaults to 'cache/'
  this.isHttpS = getIsHTTPS(connectionInfo); //true or false
  this.className = className;
  
  //optional string which is a base64 encrypted user/password pair of format: "user:password"
  //(the pair itself, including the ':', must be encoded as a single string.)
  this.authentication = (connectionInfo == null || connectionInfo.authentication == null) ? null : connectionInfo.authentication;
  this.owner = owner;

  /*
   * This function uses the connection info of this class to construct a URL to the server cache. Note that this URL is only
   * meaningful URLSuffix is also specified (pointing to a single parameter in the cache) or includeSessionId is false and the
   * URLSuffix is later added.
   * @param URLSuffix This is the partial URL value which would be returned from a server method returning a complex data type as application/rest
   * @param includeSessionId [optional - defaults to false] true to include the session ID in the URL,
   *           false if you will set the session ID later in the request header or url.
   */
  this.getCacheURL = function(URLSuffix, includeSessionId) {
    if (URLSuffix != null && isArray(URLSuffix))
    {
      return null;
    }
    
    if (includeSessionId == null)
    {
      includeSessionId = false;
    }

    var url = this.getURLPrefix(false) + this.cacheContext;
    var hasParams = false;
    
    if (URLSuffix != null)
    {
      URLSuffix += "";
      if (URLSuffix.indexOf("/") == 0)
      {
        URLSuffix = URLSuffix.substring(1);
      }
      if (URLSuffix.indexOf("cache/") == 0)
      {
        URLSuffix = URLSuffix.substring(6);
      }
      url += URLSuffix;
      
      hasParams = URLSuffix.indexOf("?") > -1;
    }
    
    var sessId = getSessionID();
    if (includeSessionId && (sessId != null))
    {
      url += (hasParams ? "&" : "?");
      url += "sid=" + encodeURIComponent(sessId);
    }
    
    return url;  
  };
  
  /*
   * Returns the REST URL up to and including the "datasnap/rest/"
   * @param includeRest true to include the rest context string (whatever it is) false to stop after datasnap. Defaults to true.
   */
  this.getURLPrefix = function(includeRest) {
    if (includeRest == null)
    {
      includeRest = true;
    }
    //optionally using the "pathPrefix" property which could be contributed through connectionInfo
    var pathPrefix = '';
    if (this.connectionInfo != null && this.connectionInfo.pathPrefix != null && this.connectionInfo.pathPrefix != '')
    {
       pathPrefix = '/' + this.connectionInfo.pathPrefix;
    }
    
    var portString = isValidPort(this.port) ? ":" + this.port : "";
    
    var dsAndRestSegments = "/" + this.dsContext;
    
    if (includeRest)
    {
      dsAndRestSegments += this.restContext;  
    }
    
    var httpPrefix = this.isHttpS ? "https://" : "http://";
    
    return httpPrefix + encodeURIComponent(this.host) + portString + pathPrefix + dsAndRestSegments;
  };

  /*
   * This function returns the request URL for the specified method with the given parameters, where the first
   * item of the array is the request URL and the second item is the request content (or null if no content.)
   * null will be returned if invalid parameters are passed in.
   * @param methodName the name of the method in the class to invoke
   * @param requestType must be one of: GET, POST, PUT, DELETE
   * @param params an array of parameter values to pass into the method, or a single parameter value
   * @param requestFilters JSON Object containing pairs of key/value filters to add to the request (filters such as ss.r, for example.)
   * @return an array of length 2 where the first item is the string url and the second is the content to attach to the body (which may be null)
   */
  this.getMethodURL = function(methodName, requestType, params, requestFilters) {
    if (methodName == null)
    {
      return null;
    }
    
    requestType = validateRequestType(requestType);
    
    //optionally using the "pathPrefix" property which could be contributed through connectionInfo
    var portString = isValidPort(this.port) ? ":" + this.port : "";
    var encodeClassName = (this.className=="") ? "" : encodeURIComponent(this.className) + "/";
    var url = this.getURLPrefix() + encodeClassName + encodeURIComponent(methodName);

    var paramToSend = null;
    if (requestType == "GET" || requestType == "DELETE")
    {
      //url += encodeURIComponent(params) + "/";
      url += "?" + params;
    }
    else
    {
      paramToSend = params;
    }
    
    return [url, paramToSend];
  };
  
    /*
   * This function executes the given method with the specified parameters and then
   * notifies the callback when a response is received.
   * @param url the url to invoke
   * @param contentParam the parameter to pass through the content of the request (or null)
   * @param requestType must be one of: GET, POST, PUT, DELETE
   * @param callback An optioanl function with three parameters, the response object, the request's status (IE: 200) and the specified 'owner'
   *                 The object will be an array, which can contain string, numeric, JSON array or JSON object types.
   * @param hasResult true if a result from the server call is expected, false to ignore any result returned.
   *                  This is an optional parameter and defaults to 'true'
   * @param accept The string value to set for the Accept header of the HTTP request, or null to set as application/json
   * @return if callback in null then this function will return the result that would have 
   *         otherwise been passed to the callback
   */
  this.executeMethodURL = function(url, contentParam, requestType, callback, hasResult, accept) {
    if (hasResult == null)
    {
      hasResult = true;
    }
    
    requestType = validateRequestType(requestType);

    var request = getXmlHttpObject();
    // Eden: Send Cookies for CORS
    request.withCredentials = true;

    //async is only true if there is a callback that can be notified on completion
    var useCallback = (callback != null);
    request.open(requestType, url, useCallback);

    if (useCallback)
    {
      request.onreadystatechange = function() {
        if (request.readyState == 4)
        {
          //the callback will be notified the execution finished even if there is no expected result
          JSONResult = hasResult ? parseHTTPResponse(request) : null;
          callback(JSONResult, request.status, owner);
        }
      };
    }

    if(contentParam != null)
    {
      contentParam = JSON.stringify(contentParam);
    }

    request.setRequestHeader("Accept", (accept == null ? "application/json" : accept));
    request.setRequestHeader("Content-Type", "text/plain;charset=UTF-8");
    request.setRequestHeader("If-Modified-Since", "Mon, 1 Oct 1990 05:00:00 GMT");
    
    var sessId = getSessionID();
    if(sessId != null)
    {
      request.setRequestHeader("Pragma", "dssession=" + sessId);
    }
    if (this.authentication != null)
    {
      request.setRequestHeader("Authorization", "Basic " + this.authentication);
    }
    request.send(contentParam);

    //if a callback wasn't used then simply return the result.
    //otherwise, return nothing because this function will finish executing before
    //the server call returns, so the result text will be empty until it is passed to the callback
    if (hasResult && !useCallback)
    {
      return parseHTTPResponse(request);
    }
  };

  /*
   * This function executes the given method with the specified parameters and then
   * notifies the callback when a response is received.
   * @param methodName the name of the method in the class to invoke
   * @param requestType must be one of: GET, POST, PUT, DELETE
   * @param params an array of parameter values to pass into the method, or a single parameter value
   * @param callback An optioanl function with two parameters, the response object, the request's status (IE: 200) and the specified 'owner'
   *                 The object will be an array, which can contain string, numeric, JSON array or JSON object types.
   * @param hasResult true if a result from the server call is expected, false to ignore any result returned.
   *                  This is an optional parameter and defaults to 'true'
   * @param requestFilters JSON Object containing pairs of key/value filters to add to the request (filters such as ss.r, for example.)
   * @param accept The string value to set for the Accept header of the HTTP request, or null to set application/json
   * @return if callback in null then this function will return the result that would have 
   *         otherwise been passed to the callback
   */
  this.executeMethod = function(methodName, requestType, params, callback, hasResult, requestFilters, accept) {
    var url = this.getMethodURL(methodName, requestType, params, requestFilters);    
    return this.executeMethodURL(url[0], url[1], requestType, callback, hasResult, accept);
  };
  
  /*
   * Closes the session on the server with the ID held by $$SessionID$$
   */
  this.closeSession = function() {
    var sessId = getSessionID();
    if (sessId == null) {
      return false;
    }
    var url = this.getURLPrefix() + "CloseSession/";
    var result = this.executeMethodURL(url, null, "GET", null, true, null);
    
    setSessionData(null, null);
    
    return result; 
  };
}

