<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>Unbenanntes Dokument</title>
	<script src="/static/jquery-3.6.0.min.js"></script>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
    <img id="dia" src="" width=auto height=100%  alt=""><br>

<script language="JavaScript" type="text/JavaScript">

function showNext() {
    var dia = document.getElementById('dia')
    dia.src = '/diashow/next/' + Date.now()
    setTimeout("showNext()", 5000)
}

showNext();
</script>

</body>
</html>
