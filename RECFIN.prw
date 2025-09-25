#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
/*/{Protheus.doc} RECFIN
Recibo Financeiro
@type user function
@author gabriel.nobre@triade.inf.br
@since 09/09/2025
@version 1
/*/
User Function RECIBOTST
	LOCAL oDlg := NIL

	PRIVATE cTitulo := "Impressão - Recibo de Pagamento"
	PRIVATE oPrn    := NIL
	PRIVATE oFont1  := NIL
	PRIVATE oFont2  := NIL
	PRIVATE oFont3  := NIL
	PRIVATE oFont4  := NIL
	PRIVATE oFont5  := NIL
	PRIVATE oFont6  := NIL
	PRIVATE oFont7  := NIL
	Private nLastKey := 0


	DEFINE FONT oFont1 NAME "Times New Roman" SIZE 0,20 BOLD OF oPrn
	DEFINE FONT oFont2 NAME "Times New Roman" SIZE 0,16 BOLD OF oPrn   // 0,18
	DEFINE FONT oFont3 NAME "Times New Roman" SIZE 0,14 OF oPrn
	DEFINE FONT oFont4 NAME "Times New Roman" SIZE 0,13 OF oPrn
	DEFINE FONT oFont5 NAME "Times New Roman" SIZE 0,08 OF oPrn
	DEFINE FONT oFont6 NAME "Arial" 		  SIZE 0,11 OF oPrn
	DEFINE FONT oFont7 NAME "Courier New" BOLD

	nLastKey  := IIf(LastKey() == 27,27,nLastKey)

	If nLastKey == 27
		Return
	Endif

	oPrn := TMSPrinter():New(cTitulo)
	oPrn:Setup()
	oPrn:SetPortrait() //SetLandsCape()
	oPrn:StartPage()
	Recibo()
	oPrn:EndPage()
	oPrn:End()
	oPrn:Preview()
Return
/*/{Protheus.doc} RECFIN
Recibo Financeiro
@type user function
@author julio.sio@totvs.com.br
@since 09/09/2025
@version 1
/*/
STATIC FUNCTION Recibo()
	Local nLin := 0050
	Local nLin2 := 0500
	Local aFieldSM0 	:= {"M0_CODFIL","M0_NOMECOM","M0_CGC"}

	aSM0Data := FWSM0Util():GetSM0Data(, SE1->E1_FILIAL, aFieldSM0)

	DbSelectArea("SA1")
	DBSetOrder(1)
	DbSeek (xFilial("SA1") + SE1->E1_CLIENTE + SE1->E1_LOJA)

	oPrn:Say(nLin,0050,OemToAnsi("                                           T E R M O   D E   R E C I B O"),oFont1)
	nLin += 00020

	oPrn:Say(nLin,0050,OemToAnsi("                                           __________________________"),oFont1)

	nLin += 00200

	oPrn:Say(nLin,0050,OemToAnsi("Empresa: "+aSM0Data[1][2]+" - " + Alltrim(aSM0Data[2][2])),oFont2)
	nLin += 00100

	oPrn:Say(nLin,0050,OemToAnsi("CNPJ: " + Transform(aSM0Data[3][2],"@R 99.999.999/9999-99")),oFont2)

	nLin += 00100


	oPrn:Say(nLin,0050,OemToAnsi("Declaro pelo presente que recebí o valor abaixo nos termos abaixo  mencionados,"),oFont2)
	nLin += 00100

	oPrn:Say(nLin,0050,OemToAnsi("dando-se a plena quitação do título:"),oFont2)
	nLin += 00100


	oPrn:Say(nLin,0050,OemToAnsi("Cliente: " + SA1->A1_NOME),oFont2)
	nLin += 00100

	oPrn:Say(nLin,0050,OemToAnsi("CNPJ/CPF: " + AllTrim(Transform(SA1->A1_CGC, "@R 99.999.999/9999-99"))),oFont2)

	nLin += 00100

	oPrn:Say(nLin,0050,OemToAnsi("Número do Título: "  + SE1->E1_NUM),oFont2)
	nLin += 00100

	oPrn:Say(nLin,0050,OemToAnsi("Data da baixa: "  + DtoC(SE1->E1_BAIXA)),oFont2)

	nLin += 00100

	oPrn:Say(nLin,0050,OemToAnsi("Valor Recebido: R$ " +Alltrim(Transform(SE1->(E1_VALOR-E1_SALDO),"@E 99,999,999.99"))),oFont2)

	nLin += 00100 // Adiciona uma linha antes de imprimir o extenso

	oPrn:Say(nLin,0050,OemToAnsi(Extenso(SE1->E1_VALOR)),oFont2)
	nLin += 00200
	dbSelectArea("SE5")
	dbSetOrder(7)
	dbSeek(xFilial("SE5") + SE1->(E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO + E1_CLIENTE + E1_LOJA))
	oPrn:Say(nLin,0050,OemToAnsi("Valor Original: R$ " +Alltrim(Transform(SE1->E1_VALOR,"@E 99,999,999.99"))),oFont2)
	nLin += 00100 // Adiciona uma linha antes de imprimir o extenso
	oPrn:Say(nLin,0050,OemToAnsi("Saldo do Titulo: R$ " +Alltrim(Transform(SE1->E1_SALDO,"@E 99,999,999.99"))),oFont2)
	nLin += 00100 // Adiciona uma linha antes de imprimir o extenso

	oPrn:Say(nLin,0050,OemToAnsi("Dados bancários:" ),oFont2)
	nLin += 00100

	oPrn:Say(nLin,0050,OemToAnsi("Banco: " + SE5->E5_BANCO),oFont2)
	nLin += 00100

	oPrn:Say(nLin,0050,OemToAnsi("Agência: " + SE5->E5_AGENCIA),oFont2)
	nLin += 00100

	oPrn:Say(nLin,0050,OemToAnsi("Conta: " + SE5->E5_CONTA),oFont2)
	nLin += 00100
	nLin += 00200

	_cDtExp   := Padr(AllTrim(Str(Day(dDataBase)))+" de "+MesExtenso(Month(dDataBase))+" de "+Str(Year(dDataBase),4),60)

	oPrn:Say(nLin,1200,"Várzea Grande,  "+_cDtExp,oFont3)

	nLin += 0300
	oPrn:Say(nLin,1200,"________________________________",oFont3)

	nLin += 0100
	oPrn:Say(nLin,1200,Alltrim(SA3->A3_NOME),oFont3)

	nLin += 0100
	nLin2 += 0790

Return
