## Setup
##########################################################################

utils  = require("utils")
casper = require("casper").create
  verbose: true
  logLevel: "debug"
  exitOnError: true
  safeLogs: true
  viewportSize:
    width: 1024
    height: 768

testhost   = "http://iqoption.com"

casper
.log("Using testhost: #{testhost}", "info")

casper.options.onWaitTimeout = -> 
  @capture 'timeout.png'

casper.on "page.error", (msg, trace) -> 
  @echo "Error:    " + msg, "ERROR"
  @echo "file:     " + trace[0].file, "WARNING"
  @echo "line:     " + trace[0].line, "WARNING"
  @echo "function: " + trace[0]["function"], "WARNING"
  errors.push msg

#casper.on "resource.requested", (resource) ->
#  for obj of resource.headers
#    name = resource.headers[obj].name
#    value = resource.headers[obj].value
#    @echo value  if name is "User-Agent"

casper.on 'remote.message', (msg) ->
  @echo 'remote message caught: ' + msg

casper.userAgent('Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)');

casper.start "#{testhost}", ->
  @.waitForSelector '.btn'
  @.thenClick 'button[ng-click="login()"]'
  @.then ->
    @.waitForSelector 'div.modal-dialog.popup-login'
  @.then ->
    @capture 'page.png'

casper.run ->
  @echo("Done!").exit()
