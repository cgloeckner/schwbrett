<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>Unbenanntes Dokument</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    
    <link rel="stylesheet" type="text/css" href="/static/normalize.css">
    <link rel="stylesheet" type="text/css" href="/static/layout.css">
</head>

<body>

%handleNone = lambda n: n.text if n is not None and n.text is not None else '---'

%checkAenderung = lambda n, k: ' class="geaendert"' if n is not None and n.text is not None and k in n.attrib else ''

<h2>Vertretungsplan für {{node.data.find('kopf/titel').text}}</h2>
<!--
<p>{{node.data.find('kopf/datum').text}} Uhr, {{node.data.find('kopf/schulname').text}}</p>
<table class="kopf">
    <tr>
        <th>Abwesende Lehrer:</th>
        <td>{{handleNone(node.data.find('kopf/kopfinfo/abwesendl'))}}</td>
    </tr>
    <tr>
        <th>Abwesende Klassen:</th> 
        <td>{{handleNone(node.data.find('kopf/kopfinfo/abwesendk'))}}</td>
    </tr>
    <tr>
        <th>Lehrer mit Änderungen:</th> 
        <td>{{handleNone(node.data.find('kopf/kopfinfo/aenderungl'))}}</td>
    </tr>
    <tr>
        <th>Klassen mit Änderungen:</th> 
        <td>{{handleNone(node.data.find('kopf/kopfinfo/aenderungk'))}}</td>
    </tr>
</table>
//-->

<h3>Geänderte Unterrichtsstunden: 
%if node.num_pages > 1:
<span>(Seite {{node.page_index+1}} von {{node.num_pages}})</span>
%end

<table class="plan">
    <tr>
        <th class="kurs">Klasse/Kurs</th>
        <th class="stunde">St.</th>
        <th class="fach">Fach</th>
        <th class="lehrer">Lehrer</th>
        <th class="raum">Raum</th>
        <th class="info">Info</th>
    </tr>
%for i, aktion in enumerate(node.data.find('haupt')):
	%p = i // page_size
	%if p == node.page_index:
	<tr>
		<td>{{handleNone(aktion.find('klasse'))}}</td>
		<td>{{handleNone(aktion.find('stunde'))}}</td>
		%css = checkAenderung(aktion.find('fach'), 'fageaendert')
		<td{{!css}}>{{handleNone(aktion.find('fach'))}}</td>
		%css = checkAenderung(aktion.find('lehrer'), 'legeaendert')
		<td{{!css}}>{{handleNone(aktion.find('lehrer'))}}</td>
		%css = checkAenderung(aktion.find('raum'), 'rageaendert')
		<td{{!css}}>{{handleNone(aktion.find('raum'))}}</td>
		<td>{{handleNone(aktion.find('info'))}}</td>
	</tr>
	%end
%end
</table>

%aufsichten = node.data.find('aufsichten')
%zeilen = list()
%if aufsichten is not None:
    %tmp = aufsichten.find('aufsichtzeile')
    %if tmp is not None:
        %for elem in tmp:
            %zeilen.append(elem)
        %end
    %end
%end

<!--
%if len(zeilen) > 0:
<h3>Geänderte Aufsichten:</h3>
<ul>
    %for elem in zeilen:
    <li>{{elem.text}}</li>
    %end
</ul>
%end
//-->

%fuss = node.data.find('fuss')
%zeilen = list()
%if fuss is not None:
    %tmp = fuss.find('fusszeile')
    %if tmp is not None:
        %for elem in tmp:
            %zeilen.append(elem)
        %end
    %end
%end

%if len(zeilen) > 0:
<h3>Hinweise:</h3>
<ul>
    %for elem in zeilen:
    <li>{{elem.text}}</li>
    %end
</ul>
%end

</body>
</html>
