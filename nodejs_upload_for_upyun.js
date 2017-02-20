var http = require('http');
var util = require('util');
var crypto = require('crypto');
// 请换成你们的bucket
var BUCKET = '';
// 请换成你们的操纵员密码
var SECRET = '';
// 请换成你们的操作员
var OPERATOR = '';
function md5(str) {
  return crypto.createHash('MD5').update(str).digest('hex').toLowerCase();
}
function getSignature1(saveKey, policy) {
  var needSignedStr = policy + '&' + SECRET;
  return md5(needSignedStr);
}
function base64(s){
  return new Buffer(s).toString('base64');
}
function getSignature(saveKey, policy) {
  var password = md5(SECRET);
  var needSignedStr =
    'POST'
    + '&'
    + '/' + BUCKET
    + '&'
    + policy;
  console.log(needSignedStr);
  return crypto.
    createHmac('sha1', password).
    update(needSignedStr)
    .digest('base64');

}

http.createServer(function (req, res) {
  var saveKey = "/43143214.png";

  var opts = {

    'save-key': saveKey,
    'bucket': BUCKET,
    'expiration': parseInt((new Date()).getTime() / 1000) + 300
  };
  // signature = response.body.result.utoken;
  var policy = base64(JSON.stringify(opts));
  var signature = getSignature(saveKey, policy);
  console.log('policy', policy);
  console.log(opts);
  res.writeHead(200, {
    'content-type': 'text/html'
  });
  var form_tpl = '<form action="http://v0.api.upyun.com/%s" enctype="multipart/form-data" method="POST">' +
    '<input type="file" id="file" name="file">' +
    '<input type="hidden" id="policy" name="policy" value=%s>' +
    '<input type="hidden" id="authorization" name="authorization" value="UPYUN %s:%s">' +
    '<input type="submit" value="upload">' +
    '</form>';
  var form_html = util.format(form_tpl, BUCKET, policy, OPERATOR, signature);
  res.end(form_html);

}).listen(8080, '127.0.0.1');
