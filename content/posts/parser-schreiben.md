---
type: post
title: "Parser schreiben"
date: 2023-03-20
description: ""
author: "Michael Rennecke"
categories:
 - programmieren
tags:
 - python
---

Ein Bekannter hat sein Leid geklagt, dass er komische Daten parsen und verarbeiten muss. Als er mir
das Problem geschildert hat, wusste ich sofort, dass man das nicht sinnvoll mit [regulären Ausdrücken]
lösen kann - bzw. ich möchte das nicht. Ich habe schnell gesagt, da muss man mit einer [Grammatik] ran.

ich habe mir ein paar Beispiele geben lassen und habe mich ran gesetzt. In der Uni habe ich mit [Eli]
gearbeitet, das Tool was schon damals "angestaubt", also habe ich nach einer Alternative in [python] gesucht.
Die weitere Verarbeitung sollte in python geschehen. Dabei bin ich auf [lark] gestoßen. Das schöne ist,
dass sich lark von der Idee her wie Eli angefühlt hat.

Die Daten sehen wie folgt aus:

```text
_645734223_(
    _73462: Powerdata(
        State: Motorstatus(
            Error: False,
            Warning: False,
            OK: True,
            upm: 4563,
            State: 0,
            ErrorCode: 0,
            pressure: 10.9
        ),
        Pistons: 12,
        chargers: 2,
        voltage: -14.2
    ),
    crankshaftCount: 2,
    fluxkompensator: 45
)
```

```text
1345.5
```

Das ganze kann natürlich noch verschachtelt sein. Das ganze sollte in ein [JSON] umgewandelt werden,
damit man es weiter verwarbeiten kann.

```python
from lark import (
    Lark,
    Transformer,
)
import json

parser = Lark(r"""
?value  : klass
       | SIGNED_INT -> int
       | SIGNED_FLOAT  -> float
       | "True"  -> true
       | "False" -> false

pair   : string ":" value

klass  : string "(" pair ("," pair)* ")"

string : CNAME

start  : value

%import common.CNAME
%import common.SIGNED_FLOAT
%import common.SIGNED_INT

%import common.WS
%ignore WS
""", start='start', parser='lalr')


class AstToDict(Transformer):

    def string(self, s):
        (s,) = s
        return s[0:]

    def float(self, n):
        (n,) = n
        return float(n)

    def int(self, n):
        (n,) = n
        return int(n)

    def klass(self, k):
        name = k[0]
        return {"01_name": name[0:], "02_data": dict(k[1:]),}

    def start(self, s):
        (s,) = s
        if isinstance(s, float):
            return {"awesome_float": s}
        elif isinstance(s, int):
            return {"awesome_int": s}
        return s

    pair = tuple

    true = lambda self, _: True
    false = lambda self, _: False


text1 = '''
_645734223_(
    _73462: Powerdata(
        State: Motorstatus(
            Error: False,
            Warning: False,
            OK: True,
            upm: 4563,
            State: 0,
            ErrorCode: 0,
            pressure: 10.9
        ),
        Pistons: 12,
        chargers: 2,
        voltage: -14.2
    ),
    crankshaftCount: 2,
    fluxkompensator: 45
)'''

text2='2'

print(json.dumps(AstToDict().transform(parser.parse(text1)), sort_keys=True, indent=4))
print(json.dumps(AstToDict().transform(parser.parse(text2)), sort_keys=True, indent=4))
```

Der Code ist nicht besonders schön, er soll die Anwendung nur veranschaulichen.

## Fazit

Ich muss sagen, dass es das erste mal in meinem beruflichen Leben ist, dass ich eine Grammatik geschrieben habe.
Ich finde, dass man solche Probleme mit einem "richtigen" Parser sehr elegant lösen kann. Die Suche nach lark und
das Lesen der Doku hat länger gedauert, wie die gesamte Implementierung. Wenn jemand Lust hat, kann er das ganze
mit regulären Ausdrücken und Schleifen und/oder Rekursion implementieren. Die Herausforderung an dieser Sprache ist,
dass wir keine Spezifikation haben. Änderungen sind in der Grammatik schnell eingefügt und man muss nicht den ganzen
Code umschreiben.

Ich habe die Aufgabe auch mal [ChatGPT] gestellt. Die Lösung hat mäßig funktioniert und bestand aus viel verschachtelten
Code. Natürlich wurden intensiv regulären Ausdrücke verwendet. Da die Sprache [kontextfrei] ist, wird man sie nicht
sinnvoll mit regulären Ausdrücken parsen können.

Die Theorie zum Compilerbau ist sinnvoll, insbesondere wenn man sich in solchen Situationen daran erinnert.

[regulären Ausdrücken]: https://de.wikipedia.org/wiki/Regul%C3%A4rer_Ausdruck
[Grammatik]: https://de.wikipedia.org/wiki/Formale_Grammatik
[Eli]: https://eli-project.sourceforge.net/
[python]: https://www.python.org/
[lark]: https://lark-parser.readthedocs.io/en/latest/
[JSON]: https://www.json.org/json-de.html
[ChatGPT]: https://openai.com/blog/chatgpt
[kontextfrei]: https://de.wikipedia.org/wiki/Kontextfreie_Sprache
