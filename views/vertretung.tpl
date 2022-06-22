<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>Unbenanntes Dokument</title>
	<script src="/static/jquery-3.6.0.min.js"></script>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body onload="showNext()">
    <iframe id="plan" width="100%" height=100% scrolling="no" align="top" border="0" frameborder="0" src=""> Ihr Browser unterstützt Inlineframes nicht oder zeigt sie in der derzeitigen Konfiguration nicht an. </iframe>

<script language="JavaScript" type="text/JavaScript">

function showNext() {
    var container = document.getElementById('plan')
    container.src = '/vertretung/next/' + Date.now()
    container.onload = function(event) {
        var body = container.contentDocument.body.innerHTML

        // count lines in loaded plan
        var lines = body.match(new RegExp('<tr>', 'gi')).length
        // calculate duration based on lines
        var delay = lines * 500
        if (lines < 4) {
            delay = 2500
        }
        
        setTimeout("showNext()", delay)
    }
}
</script>

</body>
</html>
