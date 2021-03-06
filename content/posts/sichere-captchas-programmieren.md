---
title:  „Sichere“ Captchas programmieren
author: Michael Rennecke
type: post
date: 2010-08-18T12:34:59+00:00
categories:
  - programmieren
  - sonstiges
  - Tools
tags:
  - captcha
  - hack
  - php
  - Security
  - xhtml

---
Man möchte manchmal Teile seiner Seite mittels Captchas schützen. Es gibt zahlreiche fertige Varianten, auch für wordpress. Diese haben fast immer den Nachteil, dass sie [JavaScript][1], [Flash][2], oder [Sessions][3] benutzen. Persönlich habe ich eine Abneigung gegen [JavaScript][1] und [Flash][2]. [Sessions][3] lassen sich nicht immer nachträglich nutzen und man erzeugt serverseitig etwas Last. Fakt ist, dass ich keine Sessions mag! Das schlimmste an fertigen Captcha-Lösungen ist der zum Teil invalide html-Code. Ich möchte validen [xhtml 1.0 strict][4]-Code haben und das Captcha sollte in mein Design passen. Wenn man die ganzen Anforderungen erfüllt haben möchte, so muss man wohl oder übel sein Captcha selbst programmieren. 

## Wie komme ich zum sicheren Captcha

Wenn ich auf Sessions verzichten möchte, so muss ich die Lösung des Captcha mit auf die Seite schreiben. Das kann man in einen _nicht sichtbaren_ Feld machen. Damit man dieses Feld nicht so einfach auslesen kann, schreibt man einen [Hash][5] hinein bzw. man verschlüsselt den Inhalt. 

{{< highlight php >}}
<?php

define(KEY, "Ich bin ein Key");
define(IV, "KlyV6gxG3MOPzlfuj8azF6sKKTnsdsiN58i0zjHA0EU=");

function Crypt($plaintext){
    $td = mcrypt_module_open('rijndael-256', '', 'ofb', '');

    $iv = base64_decode(IV);
    $ks = mcrypt_enc_get_key_size($td);

     /* Create key */
    $key = substr(md5(KEY), 0, $ks);

    /* Intialize encryption */
    mcrypt_generic_init($td, $key, $iv);

    /* Encrypt data */
    $encrypted = mcrypt_generic($td, $plaintext);

    /* Terminate decryption handle and close module */
    mcrypt_generic_deinit($td);
    mcrypt_module_close($td);

    return base64_encode($encrypted);
}

function Decrypt($chiffre){
    $td = mcrypt_module_open('rijndael-256', '', 'ofb', '');

    $iv = base64_decode(IV);
    $ks = mcrypt_enc_get_key_size($td);

     /* Create key */
    $key = substr(md5(KEY), 0, $ks);

    $chiffre = base64_decode($chiffre);
    mcrypt_generic_init($td, $key, $iv);
    $plaintext = mdecrypt_generic($td, $chiffre);

    mcrypt_generic_deinit($td);
    mcrypt_module_close($td);

    return $plaintext;
}

function draw_captcha_form(){
    .....

    $time = time() + 60*30;
    $captchaSolution = "Test"
    echo "\t\n\tBitte Captcha lösen<br/>\n";
    // erzeuge ein Captcha
    echo "\t\n";
    echo "\t" . '<input name="captvalue" id="captvalue" value="" size="40" tabindex="4" type="text"/>' . "\n";
    echo "\t" . '<input name="captcha" value="'. Crypt($time . "~" . $captchaSolution . "~" . $REMOTE_ADDR) . '" type="hidden"/>' . "\n";
}

function check_post($) {
    ....

    $captcha = $_POST['captvalue'];
    list($timeOld, $secret, $addr) = explode('~',Decrypt($_POST['captcha']));
    
    ....

    if($timeOld <= time()){
            echo "Deine Zeit ist abgelaufen";
            return;
    }
    if($addr != $REMOTE_ADDR){
            echo "Falsche IP";
            return;
    }
    if($secret != $captcha){
            echo "Falsches Captcha";
            return;
    }

    .....
}
?>
{{< /highlight >}}


Mit diesen Ideen kann man sich nun sein eigenes Captcha zusammen bauen. Ich generiere z.B. Matheaufgaben.

 [1]: http://de.wikipedia.org/wiki/JavaScript
 [2]: http://www.adobe.com/support/documentation/de/flash/
 [3]: http://www.w3.org/TR/WD-session-id
 [4]: http://www.w3.org/TR/xhtml1/
 [5]: http://burtleburtle.net/bob/hash/index.html
