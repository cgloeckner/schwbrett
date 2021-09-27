<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>Unbenanntes Dokument</title>
	<script src="https://code.jquery.com/jquery-3.3.1.js"></script>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
    <img id="current" src="" width=auto height=100%  alt=""><br>

<script language="JavaScript" type="text/JavaScript">
var delay = 5000;

function showNext() {
    document.getElementById('current').src = '/diashow/next/' + Date.now()
    setTimeout("showNext()", delay);
}

showNext();
</script>

</body>
</html>
