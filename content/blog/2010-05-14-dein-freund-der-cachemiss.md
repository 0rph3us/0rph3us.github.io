---
title: Dein Freund der Cachemiss
author: Michael Rennecke
type: post
date: 2010-05-14T10:09:31+00:00
excerpt: |
  <p>
  Ich habe in meinen <a href="http://0rpheus.net/hpc/superlinearer-speedup">letzten Eintrag &uuml;ber Superlinearen Speedup</a> geschrieben. Caching Effekte lassen sich auch in sequenziellen Programmen ausnutzen. So kann man l&auml;sst sich die klassische Matrixmultiplikation um Gr&ouml;&szlig;enordnungen beschleunigen.
  </p>
  <p>
  Dazu muss man nur die Matrix B transponiert abspeichern. Wenn man jetzt duch die Spalten der Matrix B geht hat man eine h&ouml;here Lokalit&auml;t und damit weniger Cachemisses.
  </p>
url: /hpc/dein-freund-der-cachemiss
categories:
  - HPC
tags:
  - C++
  - Cache

---
Ich habe in meinen [letzten Eintrag &uuml;ber Superlinearen Speedup][1] geschrieben. Caching Effekte lassen sich auch in sequenziellen Programmen ausnutzen. So kann man l&auml;sst sich die klassische Matrixmultiplikation um Gr&ouml;&szlig;enordnungen beschleunigen. 

Dazu muss man nur die Matrix B transponiert abspeichern. Wenn man jetzt duch die Spalten der Matrix B geht hat man eine h&ouml;here Lokalit&auml;t und damit weniger Cachemisses. 

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="cpp" style="font-family:monospace;"><span style="color: #339900;">#include &lt;iostream&gt;</span>
<span style="color: #339900;">#include &lt;stdlib.h&gt;</span>
<span style="color: #339900;">#include &lt;time.h&gt;</span>
&nbsp;
<span style="color: #0000ff;">using</span> <span style="color: #0000ff;">namespace</span> std<span style="color: #008080;">;</span>
&nbsp;
<span style="color: #0000ff;">void</span> mul<span style="color: #008000;">&#40;</span><span style="color: #0000ff;">double</span> <span style="color: #000040;">*</span>A, <span style="color: #0000ff;">double</span> <span style="color: #000040;">*</span>B, <span style="color: #0000ff;">double</span> <span style="color: #000040;">*</span>C, <span style="color: #0000ff;">int</span> dim<span style="color: #008000;">&#41;</span>
<span style="color: #008000;">&#123;</span>
    <span style="color: #0000ff;">int</span> i, j, k<span style="color: #008080;">;</span>
    <span style="color: #0000ff;">double</span> s<span style="color: #008080;">;</span>
&nbsp;
    <span style="color: #0000ff;">for</span> <span style="color: #008000;">&#40;</span>i <span style="color: #000080;">=</span> <span style="color: #0000dd;"></span><span style="color: #008080;">;</span> i <span style="color: #000080;">&lt;</span> dim<span style="color: #008080;">;</span> i<span style="color: #000040;">++</span><span style="color: #008000;">&#41;</span><span style="color: #008000;">&#123;</span>
        <span style="color: #0000ff;">for</span> <span style="color: #008000;">&#40;</span>j <span style="color: #000080;">=</span> <span style="color: #0000dd;"></span><span style="color: #008080;">;</span> j <span style="color: #000080;">&lt;</span> dim<span style="color: #008080;">;</span> j<span style="color: #000040;">++</span><span style="color: #008000;">&#41;</span> <span style="color: #008000;">&#123;</span>
            s <span style="color: #000080;">=</span> <span style="color:#800080;">0.0</span><span style="color: #008080;">;</span>
            <span style="color: #0000ff;">for</span> <span style="color: #008000;">&#40;</span>k <span style="color: #000080;">=</span> <span style="color: #0000dd;"></span><span style="color: #008080;">;</span> k <span style="color: #000080;">&lt;</span> dim<span style="color: #008080;">;</span> <span style="color: #000040;">++</span>k<span style="color: #008000;">&#41;</span>
                s <span style="color: #000040;">+</span><span style="color: #000080;">=</span> A<span style="color: #008000;">&#91;</span>dim<span style="color: #000040;">*</span>i <span style="color: #000040;">+</span>k<span style="color: #008000;">&#93;</span> <span style="color: #000040;">*</span> B<span style="color: #008000;">&#91;</span>dim<span style="color: #000040;">*</span>k<span style="color: #000040;">+</span>j<span style="color: #008000;">&#93;</span><span style="color: #008080;">;</span>
&nbsp;
            C<span style="color: #008000;">&#91;</span>dim<span style="color: #000040;">*</span>i<span style="color: #000040;">+</span>j<span style="color: #008000;">&#93;</span> <span style="color: #000080;">=</span> s<span style="color: #008080;">;</span>
        <span style="color: #008000;">&#125;</span>
    <span style="color: #008000;">&#125;</span>
<span style="color: #008000;">&#125;</span>
&nbsp;
<span style="color: #0000ff;">void</span> transpose<span style="color: #008000;">&#40;</span><span style="color: #0000ff;">double</span> <span style="color: #000040;">*</span>A, <span style="color: #0000ff;">int</span> dim<span style="color: #008000;">&#41;</span><span style="color: #008000;">&#123;</span>
&nbsp;
        <span style="color: #0000ff;">int</span> i,j<span style="color: #008080;">;</span>
        <span style="color: #0000ff;">double</span> tmp<span style="color: #008080;">;</span>
&nbsp;
    <span style="color: #0000ff;">for</span> <span style="color: #008000;">&#40;</span>i <span style="color: #000080;">=</span> <span style="color: #0000dd;"></span><span style="color: #008080;">;</span> i <span style="color: #000080;">&lt;</span> dim<span style="color: #008080;">;</span> i<span style="color: #000040;">++</span><span style="color: #008000;">&#41;</span><span style="color: #008000;">&#123;</span>
        <span style="color: #0000ff;">for</span> <span style="color: #008000;">&#40;</span>j <span style="color: #000080;">=</span> i<span style="color: #008080;">;</span> j <span style="color: #000080;">&lt;</span> dim<span style="color: #008080;">;</span> j<span style="color: #000040;">++</span><span style="color: #008000;">&#41;</span><span style="color: #008000;">&#123;</span>
            tmp <span style="color: #000080;">=</span> A<span style="color: #008000;">&#91;</span>dim<span style="color: #000040;">*</span>i<span style="color: #000040;">+</span>j<span style="color: #008000;">&#93;</span><span style="color: #008080;">;</span>
            A<span style="color: #008000;">&#91;</span>dim<span style="color: #000040;">*</span>i<span style="color: #000040;">+</span>j<span style="color: #008000;">&#93;</span> <span style="color: #000080;">=</span>A<span style="color: #008000;">&#91;</span>dim<span style="color: #000040;">*</span>j<span style="color: #000040;">+</span>i<span style="color: #008000;">&#93;</span><span style="color: #008080;">;</span>
            A<span style="color: #008000;">&#91;</span>dim<span style="color: #000040;">*</span>j<span style="color: #000040;">+</span>i<span style="color: #008000;">&#93;</span> <span style="color: #000080;">=</span> tmp<span style="color: #008080;">;</span>
        <span style="color: #008000;">&#125;</span>
    <span style="color: #008000;">&#125;</span>
&nbsp;
<span style="color: #008000;">&#125;</span>
&nbsp;
<span style="color: #0000ff;">void</span> mulfast<span style="color: #008000;">&#40;</span><span style="color: #0000ff;">double</span> <span style="color: #000040;">*</span>A, <span style="color: #0000ff;">double</span> <span style="color: #000040;">*</span>B, <span style="color: #0000ff;">double</span> <span style="color: #000040;">*</span>C, <span style="color: #0000ff;">int</span> dim<span style="color: #008000;">&#41;</span>
<span style="color: #008000;">&#123;</span>
    <span style="color: #0000ff;">int</span> i, j, k<span style="color: #008080;">;</span>
    <span style="color: #0000ff;">double</span> s<span style="color: #008080;">;</span>
&nbsp;
    transpose<span style="color: #008000;">&#40;</span>B, dim<span style="color: #008000;">&#41;</span><span style="color: #008080;">;</span>
&nbsp;
    <span style="color: #0000ff;">for</span> <span style="color: #008000;">&#40;</span>i <span style="color: #000080;">=</span> <span style="color: #0000dd;"></span><span style="color: #008080;">;</span> i <span style="color: #000080;">&lt;</span> dim<span style="color: #008080;">;</span> <span style="color: #000040;">++</span>i<span style="color: #008000;">&#41;</span><span style="color: #008000;">&#123;</span>
        <span style="color: #0000ff;">for</span> <span style="color: #008000;">&#40;</span>j <span style="color: #000080;">=</span> <span style="color: #0000dd;"></span><span style="color: #008080;">;</span> j <span style="color: #000080;">&lt;</span> dim<span style="color: #008080;">;</span> <span style="color: #000040;">++</span>j<span style="color: #008000;">&#41;</span> <span style="color: #008000;">&#123;</span>
            s <span style="color: #000080;">=</span> <span style="color:#800080;">0.0</span><span style="color: #008080;">;</span>
            <span style="color: #0000ff;">for</span> <span style="color: #008000;">&#40;</span>k <span style="color: #000080;">=</span> <span style="color: #0000dd;"></span><span style="color: #008080;">;</span> k <span style="color: #000080;">&lt;</span> dim<span style="color: #008080;">;</span> <span style="color: #000040;">++</span>k<span style="color: #008000;">&#41;</span>
                <span style="color: #666666;">// B is transposed !!</span>
                s <span style="color: #000040;">+</span><span style="color: #000080;">=</span> A<span style="color: #008000;">&#91;</span>dim<span style="color: #000040;">*</span>i <span style="color: #000040;">+</span>k<span style="color: #008000;">&#93;</span> <span style="color: #000040;">*</span> B<span style="color: #008000;">&#91;</span>dim<span style="color: #000040;">*</span>j<span style="color: #000040;">+</span>k<span style="color: #008000;">&#93;</span><span style="color: #008080;">;</span>
&nbsp;
            C<span style="color: #008000;">&#91;</span>dim<span style="color: #000040;">*</span>i<span style="color: #000040;">+</span>j<span style="color: #008000;">&#93;</span> <span style="color: #000080;">=</span> s<span style="color: #008080;">;</span>
        <span style="color: #008000;">&#125;</span>
    <span style="color: #008000;">&#125;</span>
&nbsp;
    transpose<span style="color: #008000;">&#40;</span>B, dim<span style="color: #008000;">&#41;</span><span style="color: #008080;">;</span>
<span style="color: #008000;">&#125;</span>
&nbsp;
<span style="color: #0000ff;">int</span> main<span style="color: #008000;">&#40;</span><span style="color: #008000;">&#41;</span><span style="color: #008000;">&#123;</span>
&nbsp;
    <span style="color: #0000ff;">int</span> dim <span style="color: #000080;">=</span> <span style="color: #0000dd;">1024</span><span style="color: #008080;">;</span>
    <span style="color: #0000ff;">clock_t</span> start, end<span style="color: #008080;">;</span>
&nbsp;
    <span style="color: #0000ff;">double</span><span style="color: #000040;">*</span> A <span style="color: #000080;">=</span> <span style="color: #008000;">&#40;</span><span style="color: #0000ff;">double</span><span style="color: #000040;">*</span><span style="color: #008000;">&#41;</span> <span style="color: #0000dd;">calloc</span><span style="color: #008000;">&#40;</span>dim<span style="color: #000040;">*</span> dim, <span style="color: #0000dd;">sizeof</span><span style="color: #008000;">&#40;</span><span style="color: #0000ff;">double</span><span style="color: #008000;">&#41;</span><span style="color: #008000;">&#41;</span><span style="color: #008080;">;</span>
    <span style="color: #0000ff;">double</span><span style="color: #000040;">*</span> B <span style="color: #000080;">=</span> <span style="color: #008000;">&#40;</span><span style="color: #0000ff;">double</span><span style="color: #000040;">*</span><span style="color: #008000;">&#41;</span> <span style="color: #0000dd;">calloc</span><span style="color: #008000;">&#40;</span>dim<span style="color: #000040;">*</span> dim, <span style="color: #0000dd;">sizeof</span><span style="color: #008000;">&#40;</span><span style="color: #0000ff;">double</span><span style="color: #008000;">&#41;</span><span style="color: #008000;">&#41;</span><span style="color: #008080;">;</span>
    <span style="color: #0000ff;">double</span><span style="color: #000040;">*</span> C <span style="color: #000080;">=</span> <span style="color: #008000;">&#40;</span><span style="color: #0000ff;">double</span><span style="color: #000040;">*</span><span style="color: #008000;">&#41;</span> <span style="color: #0000dd;">calloc</span><span style="color: #008000;">&#40;</span>dim<span style="color: #000040;">*</span> dim, <span style="color: #0000dd;">sizeof</span><span style="color: #008000;">&#40;</span><span style="color: #0000ff;">double</span><span style="color: #008000;">&#41;</span><span style="color: #008000;">&#41;</span><span style="color: #008080;">;</span>
&nbsp;
    start <span style="color: #000080;">=</span> <span style="color: #0000dd;">clock</span><span style="color: #008000;">&#40;</span><span style="color: #008000;">&#41;</span><span style="color: #008080;">;</span>
    mul<span style="color: #008000;">&#40;</span>A,B,C, dim<span style="color: #008000;">&#41;</span><span style="color: #008080;">;</span>
    end <span style="color: #000080;">=</span> <span style="color: #0000dd;">clock</span><span style="color: #008000;">&#40;</span><span style="color: #008000;">&#41;</span><span style="color: #008080;">;</span>
    <span style="color: #0000dd;">cout</span> <span style="color: #000080;">&lt;&lt;</span> <span style="color: #FF0000;">"normal implementation: "</span> <span style="color: #000080;">&lt;&lt;</span> <span style="color: #008000;">&#40;</span>end<span style="color: #000040;">-</span>start<span style="color: #008000;">&#41;</span> <span style="color: #000040;">/</span> <span style="color: #0000ff;">CLOCKS_PER_SEC</span> <span style="color: #000080;">&lt;&lt;</span> <span style="color: #FF0000;">" seconds"</span> <span style="color: #000080;">&lt;&lt;</span> endl<span style="color: #008080;">;</span>
&nbsp;
    start <span style="color: #000080;">=</span> <span style="color: #0000dd;">clock</span><span style="color: #008000;">&#40;</span><span style="color: #008000;">&#41;</span><span style="color: #008080;">;</span>
    mulfast<span style="color: #008000;">&#40;</span>A,B,C, dim<span style="color: #008000;">&#41;</span><span style="color: #008080;">;</span>
    end <span style="color: #000080;">=</span> <span style="color: #0000dd;">clock</span><span style="color: #008000;">&#40;</span><span style="color: #008000;">&#41;</span><span style="color: #008080;">;</span>
    <span style="color: #0000dd;">cout</span> <span style="color: #000080;">&lt;&lt;</span> <span style="color: #FF0000;">"fast implementation: "</span> <span style="color: #000080;">&lt;&lt;</span> <span style="color: #008000;">&#40;</span>end<span style="color: #000040;">-</span>start<span style="color: #008000;">&#41;</span> <span style="color: #000040;">/</span> <span style="color: #0000ff;">CLOCKS_PER_SEC</span> <span style="color: #000080;">&lt;&lt;</span> <span style="color: #FF0000;">" seconds"</span> <span style="color: #000080;">&lt;&lt;</span> endl<span style="color: #008080;">;</span>
&nbsp;
    <span style="color: #0000ff;">return</span> <span style="color: #0000dd;"></span><span style="color: #008080;">;</span>
<span style="color: #008000;">&#125;</span></pre>
      </td>
    </tr>
  </table>
</div>

 [1]: http://0rpheus.net/hpc/superlinearer-speedup