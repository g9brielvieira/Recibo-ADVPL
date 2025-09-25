
#include "protheus.ch"
#include "totvs.ch"

User Function zzLog()
Local nResultado
Local nResultado2
Local nResultado3
Local nNumero1
Local nNumero2

nNumero1 := 20
nNumero2 := 30

nResultado := nNumero1 + nNumero2
nResultado2 := nNumero1 * nNumero2
nResultado3 := nNumero1 / nNumero2

MsgInfo("O resultado dá soma é: " +  (nResultado), "Resultado da Soma")
MsgInfo("O resultado da multiplicação é: " + (nResultado2), "Resultado da Multiplicação")
MsgInfo("O resultado da divisão é: " +  (nResultado3), "Resultado da Divisão")

Return

