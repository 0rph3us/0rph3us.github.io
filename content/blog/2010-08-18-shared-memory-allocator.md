---
title: Shared memory Allocator mit der STL
author: Michael Rennecke
type: post
date: 2010-08-18T17:10:30+00:00
url: /programmieren/shared-memory-allocator
wp_jd_wp:
  - http://0rpheus.net/?p=3802
wp_jd_target:
  - http://0rpheus.net/?p=3802
categories:
  - Programmieren
tags:
  - allocator
  - boost
  - C++
  - Shared Memory
  - STL

---
Ich habe mich die letzten Tage mit der [STL][1] herungeärgert. Ich wollte einen Allocator schreiben, welcher mir die STL-Container in ein Shared Memory Segment legt. Ich habe es nicht wirklich hinbekommen. Inzwischen weiß ich, dass es die Leute von [boost][2] auch nicht hinbekommen haben. Aus diesem Grund werde ich nun [boost][2] benutzen und hoffen, dass die Performance nicht zu schlecht (unter [Windows][3]) ist. Das geheimnis ist, dass man die Container nach implementiert und die Implementierung kommt arbeitet korrekt in einem Shared Memory Segment.

 [1]: http://www.cplusplus.com/reference/stl/
 [2]: http://www.boost.org/
 [3]: http://www.microsoft.com/germany/windows/