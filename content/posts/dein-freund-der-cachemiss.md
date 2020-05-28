---
title: Dein Freund der Cachemiss
author: Michael Rennecke
type: post
date: 2010-05-14T10:09:31+00:00
categories:
  - HPC
tags:
  - C++
  - Cache

---
Ich habe in meinen [letzten Eintrag &uuml;ber Superlinearen Speedup][1] geschrieben. Caching Effekte lassen sich auch in sequenziellen Programmen ausnutzen. So kann man lässt sich die klassische Matrixmultiplikation um Größenordnungen beschleunigen.

Dazu muss man nur die Matrix B transponiert abspeichern. Wenn man jetzt duch die Spalten der Matrix B geht hat man eine h&ouml;here Lokalit&auml;t und damit weniger Cachemisses. 

{{< highlight cpp >}}
#include <iostream>
#include <stdlib.h>
#include <time.h>
 
using namespace std;
 
void mul(double *A, double *B, double *C, int dim) {
    int i, j, k;
    double s;
 
    for (i = ; i < dim; i++){
        for (j = ; j < dim; j++) {
            s = 0.0;
            for (k = ; k < dim; ++k)
                s += A[dim*i +k] * B[dim*k+j];
 
            C[dim*i+j] = s;
        }
    }
}
 
void transpose(double *A, int dim) {
        int i,j;
        double tmp;
 
    for (i = ; i < dim; i++){
        for (j = i; j < dim; j++){
            tmp = A[dim*i+j];
            A[dim*i+j] =A[dim*j+i];
            A[dim*j+i] = tmp;
        }
    }
 
}
 
void mulfast(double *A, double *B, double *C, int dim) {
    int i, j, k;
    double s;
 
    transpose(B, dim);
 
    for (i = ; i < dim; ++i){
        for (j = ; j < dim; ++j) {
            s = 0.0;
            for (k = ; k < dim; ++k)
                // B is transposed !!
                s += A[dim*i +k] * B[dim*j+k];
 
            C[dim*i+j] = s;
        }
    }
 
    transpose(B, dim);
}
 
int main(){
    int dim = 1024;
    clock_t start, end;
 
    double* A = (double*) calloc(dim* dim, sizeof(double));
    double* B = (double*) calloc(dim* dim, sizeof(double));
    double* C = (double*) calloc(dim* dim, sizeof(double));
 
    start = clock();
    mul(A,B,C, dim);
    end = clock();
    cout << "normal implementation: " << (end-start) / CLOCKS_PER_SEC << " seconds" << endl;
 
    start = clock();
    mulfast(A,B,C, dim);
    end = clock();
    cout << "fast implementation: " << (end-start) / CLOCKS_PER_SEC << " seconds" << endl;
 
    return ;
}
{{< /highlight >}}

 [1]: {{< ref "superlinearer-speedup.md" >}}