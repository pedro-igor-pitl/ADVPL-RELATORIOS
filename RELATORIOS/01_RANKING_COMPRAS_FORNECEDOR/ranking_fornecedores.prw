#include "Totvs.ch"
#include "Protheus.ch"
#include "rwmake.ch"

/*/{Protheus.doc} ranking_fornecedores
Relatorio de Ranking de Fornecedores que mais compraram.
@type function
@version 1.0
@author Pedro Igor
@since 17/11/2025
/*/
User Function RANKFORN()
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
@since 17/11/2025
/*/
Static Function ReportDef()

	Local oReport as Object
	Local oiSec1 as Object
	Local oBreak

	//Pergunte("BNRFI02AV",.F.)

	oReport:= TReport():New("RANKFORN","Ranking de Fornecedores","RANKFORN", {|oReport| PrintReport(oReport)},"Ranking de Fornecedores que mais compraram")
	oReport:SetLandscape()
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:SetEnvironment(2)


	//Definicoes da fonte utilizada
	oReport:SetLineHeight(30)
	oReport:nFontBody := 8


	oiSec1 := TRSection():New(oReport,"Ranking de Fornecedores",{"QRY"})

	oiSec1:SetAutoSize(.T.)
	TRCell():New(oiSec1,"RANKING"		,"QRY"/*Tabela*/,"RANKING"			, "@!",  10,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT"/*cAlign*/,/*lLineBreak*/,"LEFT"/*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/,/*lAutoSize*/.F.)
	TRCell():New(oiSec1,"COD_FORNECEDOR"		,"QRY"/*Tabela*/,"COD_FORNECEDOR"			, "@!",  20,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT"/*cAlign*/,/*lLineBreak*/,"LEFT"/*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/,/*lAutoSize*/.F.)
	TRCell():New(oiSec1,"NOME_FORNECEDOR"		,"QRY"/*Tabela*/,"NOME_FORNECEDOR"	, "@!", 9,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT"/*cAlign*/,/*lLineBreak*/,"LEFT"/*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/,/*lAutoSize*/.F.)
	TRCell():New(oiSec1,"TOTAL_COMPRADO"  	,"QRY"/*Tabela*/,"TOTAL_COMPRADO"		, PesqPict("SD1","D1_TOTAL"  ,18), 3	,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT"/*cAlign*/,/*lLineBreak*/,"LEFT"/*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/,/*lAutoSize*/.F.)

	//oBreak := Trbreak():New(oiSec1, oiSec1:Cell("COD_FORNECEDOR"),{||"Ranking Fornecedor"}, .F.)

	//TRFunction():New(oiSec1:Cell("COD_FORNECEDOR")  	 				,"","CONT", oBreak,"","@!",,.f.,.f.,.f.,oiSec1,,,)
Return(oReport)



/*/{Protheus.doc} nomeStaticFunction
	Montagem da query para impressao do relatorio
	@type  Function Static
	@author Pedro Igor
	@since 17/11/2025
/*/
Static Function PrintReport(oReport)
	Local cDB := TCGetDB()
	Local cQuery
	Local oSection1 := oReport:Section(1)


	cQuery := ""
	cQuery += " SELECT " + ;
		"ROW_NUMBER() OVER (ORDER BY SUM(SD1.D1_TOTAL) DESC) AS RANKING, " + ;
		"    SA2.A2_COD        AS COD_FORNECEDOR, " + ;
		"    SA2.A2_NOME       AS NOME_FORNECEDOR, " + ;
		"    SUM(SD1.D1_TOTAL) AS TOTAL_COMPRADO " + ;
		" FROM " + RetSqlName("SA2") + " SA2 " + ;
		" INNER JOIN " + RetSqlName("SD1") + " SD1 " + ;
		"        ON SA2.A2_COD = SD1.D1_FORNECE " + ;
		"       AND SD1.D_E_L_E_T_ = '' " + ;
		"       AND SA2.D_E_L_E_T_ = '' " + ;
		" GROUP BY " + ;
		"    SA2.A2_COD, " + ;
		"    SA2.A2_NOME " + ;
		" ORDER BY TOTAL_COMPRADO DESC "

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
