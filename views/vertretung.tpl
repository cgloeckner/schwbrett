<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>Unbenanntes Dokument</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
    <iframe id="current" width="100%" height=100% scrolling="no" align="top" border="0" frameborder="0" src=""> Ihr Browser unterstützt Inlineframes nicht oder zeigt sie in der derzeitigen Konfiguration nicht an. </iframe>

<script language="JavaScript" type="text/JavaScript">
var delay = 5000;

function showNext() {
    document.getElementById('current').src = '/vertretung/next/' + Date.now()
    setTimeout("showNext()", delay);
}

showNext();
</script>

</body>
</html>
