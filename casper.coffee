## Setup
##########################################################################

utils  = require("utils")
casper = require("casper").create
  clientScripts: [
    "includes/jquery.min.js",
    "includes/app.js",
    "includes/jquery.cookie.js"
  ]
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

casper.start "#{testhost}"

casper.waitForSelector '.btn'

casper.then ->	
 @evaluate ->
   console.log 'Clicking to button'
   $('button[ng-click="login()"]').click()

casper.waitForSelector 'div.modal-dialog.popup-login'

casper.then ->
  @click('button[ng-click="login()"]')

#casper.waitUntilVisible '.modal-title'

casper.then ->
  @capture 'page.png'

casper.run ->
  @echo("Done!").exit()
