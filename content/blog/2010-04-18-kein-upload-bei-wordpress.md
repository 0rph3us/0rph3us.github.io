---
title: Kein Upload bei WordPress
author: Michael Rennecke
type: post
date: 2010-04-18T08:19:09+00:00
categories:
  - sonstiges
tags:
  - hack
  - mime-Type
  - problem
  - upload
  - wordpress

---
[Martin][1] hat mich darauf  aufmerksam gemacht, dass bei wordpress die Upload-Funktion für Dateien nicht funktioniert. Also habe ich es promt ausprobiert und siehe da es ging bei mir auch nicht. Die Fehlermeldung **Fehler beim Upload der ausgewählten Datei**. das hilft einen gar nicht weiter. Die Ursache war, dass man per default in wordpress nur bekannte Dateien hinzufügen darf. Also habe ich in der Datei <tt>wp-inludes/functions.php</tt> die [mime-Typen][2] etwas editiert:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="php" style="font-family:monospace;"><span style="color: #000000; font-weight: bold;">function</span> get_allowed_mime_types<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
	static <span style="color: #000088;">$mimes</span> <span style="color: #339933;">=</span> <span style="color: #009900; font-weight: bold;">false</span><span style="color: #339933;">;</span>
&nbsp;
	<span style="color: #b1b100;">if</span> <span style="color: #009900;">&#40;</span> <span style="color: #339933;">!</span><span style="color: #000088;">$mimes</span> <span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
		<span style="color: #666666; font-style: italic;">// Accepted MIME types are set here as PCRE unless provided</span>
		<span style="color: #000088;">$mimes</span> <span style="color: #339933;">=</span> apply_filters<span style="color: #009900;">&#40;</span> <span style="color: #0000ff;">'upload_mimes'</span><span style="color: #339933;">,</span> <span style="color: #990000;">array</span><span style="color: #009900;">&#40;</span>
		<span style="color: #0000ff;">'jpg|jpeg|jpe'</span> <span style="color: #339933;">=&gt;</span> <span style="color: #0000ff;">'image/jpeg'</span><span style="color: #339933;">,</span>
                <span style="color: #339933;">...</span>
                <span style="color: #0000ff;">'odf'</span> <span style="color: #339933;">=&gt;</span> <span style="color: #0000ff;">'application/vnd.oasis.opendocument.formula'</span><span style="color: #339933;">,</span>
		<span style="color: #0000ff;">'.*'</span> <span style="color: #339933;">=&gt;</span> <span style="color: #0000ff;">'text/plain'</span><span style="color: #339933;">,</span> <span style="color: #666666; font-style: italic;">// hinzugefügt</span>
		<span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
	<span style="color: #009900;">&#125;</span>
&nbsp;
	<span style="color: #b1b100;">return</span> <span style="color: #000088;">$mimes</span><span style="color: #339933;">;</span>
<span style="color: #009900;">&#125;</span></pre>
      </td>
    </tr>
  </table>
</div>

 [1]: https://blog.binfalse.de/
 [2]: http://www.iana.org/assignments/media-types/index.html