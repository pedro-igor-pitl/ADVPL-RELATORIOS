#include "Totvs.ch"
#include "Protheus.ch"
#include "rwmake.ch"

/*/{Protheus.doc} ULTIMAS_COMPRAS
Relatorio de Relação de baixa(Titulos Baixados).
@type function
@version 1.0
@author Pedro Igor
@since 19/11/2025
/*/
User Function ULTIMAS_COMPRAS()

	Local oReport

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:= ReportDef()
	oReport:PrintDialog()

	oReport	:=	Nil
	FreeObj(oReport)

Return ()


/*/{Protheus.doc} ReportDef
Determinação da seção que serão impressas no relatório
@type function
@version 1.0
@author Pedro Igor
@since 19/11/2025
/*/
Static Function ReportDef()

	Local oReport as Object
	Local oiSec1 as Object
	Local oBreak

	Pergunte("ULTIMASCOM",.F.)

	oReport:= TReport():New("ULTIMAS_COMPRAS","Ultimas Compras","ULTIMASCOMPRAS", {|oReport| PrintReport(oReport)},"Ultimas Compras por Fornecedor")
	oReport:SetLandscape()
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:SetEnvironment(2)


	//Definicoes da fonte utilizada
	oReport:SetLineHeight(30)
	oReport:nFontBody := 8


	oiSec1 := TRSection():New(oReport,"Ultimas Compras",{"QRY"})

	oiSec1:SetAutoSize(.T.)
	TRCell():New(oiSec1,"D1_FILIAL"		,"QRY"/*Tabela*/,"Filial"			, "@!",  20,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT"/*cAlign*/,/*lLineBreak*/,"LEFT"/*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/,/*lAutoSize*/.F.)
	TRCell():New(oiSec1,"D1_DOC"		,"QRY"/*Tabela*/,"Num. Documento"	, "@!", 9,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT"/*cAlign*/,/*lLineBreak*/,"LEFT"/*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/,/*lAutoSize*/.F.)
	TRCell():New(oiSec1,"A2_COD"  	,"QRY"/*Tabela*/,"Cod. Fornecedor"		, "@!", 10	,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT"/*cAlign*/,/*lLineBreak*/,"LEFT"/*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/,/*lAutoSize*/.F.)
	TRCell():New(oiSec1,"A2_NOME"		,"QRY"/*Tabela*/,"Nome Fornecedor"	    	, "@!", 10 	,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT"/*cAlign*/,/*lLineBreak*/,"LEFT"/*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/,/*lAutoSize*/.F.)
	TRCell():New(oiSec1,"D1_COD"		,"QRY"/*Tabela*/,"Cod. Produto"			, "@!", 10		,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT"/*cAlign*/,/*lLineBreak*/,"LEFT"/*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/,/*lAutoSize*/.F.)
	TRCell():New(oiSec1,"B1_DESC"		,"QRY"/*Tabela*/,"Desc. Produto"			, "@!", 20		,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT"/*cAlign*/,/*lLineBreak*/,"LEFT"/*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/,/*lAutoSize*/.F.)
	TRCell():New(oiSec1,"D1_TOTAL"		,"QRY"/*Tabela*/,"Vlr Total"			,PesqPict("SD1","D1_TOTAL"    ,18),TamSX3("D1_TOTAL")[1],/*lPixel*/,/*{|| cValToChar(Stod(QRY->E2_VENCTO)) }*/,"LEFT"/*cAlign*/,/*lLineBreak*/,"LEFT"/*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/,/*lAutoSize*/.F.)
	TRCell():New(oiSec1,"D1_EMISSAO"		,"QRY"/*Tabela*/,"Data Emissão"			, "@D",TamSX3("D1_EMISSAO")[1],/*lPixel*/,{|| SToD(QRY->D1_EMISSAO)},"LEFT"/*cAlign*/,/*lLineBreak*/,"LEFT"/*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/,/*lAutoSize*/.F.)

Return(oReport)



/*/{Protheus.doc} nomeStaticFunction
	Montagem da query para impressao do relatorio
	@type  Function Static
	@author Pedro Igor
	@since 19/11/2025
/*/
Static Function PrintReport(oReport)
	Local cDB := TCGetDB()
	Local cQuery
	Local oSection1 := oReport:Section(1)

	cQuery :=   "SELECT SD1.D1_FILIAL, SD1.D1_DOC, SA2.A2_COD, SA2.A2_NOME, SD1.D1_COD, SB1.B1_DESC, SD1.D1_TOTAL, SD1.D1_EMISSAO "
	cQuery +=   "FROM SD1990 AS SD1 "
	cQuery +=   "INNER JOIN SA2990 AS SA2 ON SA2.A2_COD = SD1.D1_FORNECE "
	cQuery +=   "INNER JOIN SB1990 AS SB1 ON SB1.B1_COD = SD1.D1_COD "
	cQuery +=   "WHERE (SA2.D_E_L_E_T_ = '' AND SD1.D_E_L_E_T_ = '') AND (SB1.B1_COD LIKE '%"+ Alltrim(mv_par01) + "%') "
	cQuery +=   "ORDER BY SA2.A2_COD, SD1.D1_TOTAL ASC "

	cQuery := ChangeQuery(cQuery)
	MPSysOpenQuery(cQuery,"QRY")

	// Percorre a Secao 2
	QRY->(dbGoTop())

	If !QRY->(Eof())

		oReport:IncMeter()
		oSection1:init()

		While QRY->(!Eof())


			If oReport:Cancel()
				Exit
			EndIf

			oSection1:PrintLine()
			oReport:IncMeter()

			QRY->(DbSkip())
		EndDo

		oSection1:Finish()

	EndIf

	oReport:EndPage()

Return
