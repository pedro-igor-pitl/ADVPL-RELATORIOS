#include "Totvs.ch"
#include "Protheus.ch"
#include "rwmake.ch"

/*/{Protheus.doc} ranking_fornecedores
Relatorio de Ranking de Fornecedores que mais compraram.
@type function
@version 1.0
@author Pedro Igor
@since 17/11/2025
@Uso Pedro Igor
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
@Uso Concret
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
	TRCell():New(oiSec1,"COD_FORNECEDOR"		,"QRY"/*Tabela*/,"COD_FORNECEDOR"			, "@!",  20,/*lPixel*/,/*{|| code-block de impressao }*/,"CENTER"/*cAlign*/,/*lLineBreak*/,"CENTER"/*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/,/*lAutoSize*/.F.)
	//TRCell():New(oiSec1,"FILIAL"		,"QRY"/*Tabela*/,"Filial"			, "@!", 45,/*lPixel*/,{||Posicione("SM0",1,QRY->M0_FILIAL,"M0_FILIAL") },"CENTER"/*cAlign*/,/*lLineBreak*/,"CENTER"/*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/,/*lAutoSize*/.F.)
	TRCell():New(oiSec1,"NOME_FORNECEDOR"		,"QRY"/*Tabela*/,"NOME_FORNECEDOR"	, "@!", 9,/*lPixel*/,/*{|| code-block de impressao }*/,"CENTER"/*cAlign*/,/*lLineBreak*/,"CENTER"/*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/,/*lAutoSize*/.F.)
	TRCell():New(oiSec1,"TOTAL_COMPRADO"  	,"QRY"/*Tabela*/,"TOTAL_COMPRADO"		, PesqPict("SD1","D1_TOTAL"  ,18), 3	,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT"/*cAlign*/,/*lLineBreak*/,"LEFT"/*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/,/*lAutoSize*/.F.)
	//TRCell():New(oiSec1,"E2_TIPO"		,"QRY"/*Tabela*/,"Tipo"	    	, PesqPict("SE2","E2_TIPO" ,18), 3 	,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT"/*cAlign*/,/*lLineBreak*/,"LEFT"/*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/,/*lAutoSize*/.F.)
	//TRCell():New(oiSec1,"E2_FORNECE"		,"QRY"/*Tabela*/,"CliFor"			, PesqPict("SE2","E2_FORNECE"    ,18), 6		,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT"/*cAlign*/,/*lLineBreak*/,"LEFT"/*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/,/*lAutoSize*/.F.)
	//TRCell():New(oiSec1,"E2_NOMFOR"		,"QRY"/*Tabela*/,"Nome Forn"			, PesqPict("SE2","E2_NOMFOR"    ,18), 20		,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT"/*cAlign*/,/*lLineBreak*/,"LEFT"/*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/,/*lAutoSize*/.F.)
	//TRCell():New(oiSec1,"E2_VENCTO"		,"QRY"/*Tabela*/,"Vencimento"			, PesqPict("SE2","E2_VENCTO"    ,18), 13	,/*lPixel*/,{|| cValToChar(Stod(QRY->E2_VENCTO)) },"LEFT"/*cAlign*/,/*lLineBreak*/,"LEFT"/*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/,/*lAutoSize*/.F.)
	//TRCell():New(oiSec1,"E2_VALOR"		,"QRY"/*Tabela*/,"Vlr Bruto"			, PesqPict("SE2","E2_VALOR"    ,18), 16		,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT"/*cAlign*/,/*lLineBreak*/,"LEFT"/*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/,/*lAutoSize*/.F.)
	//TRCell():New(oiSec1,"E2_VALLIQ"		,"QRY"/*Tabela*/,"Vlr Baixado"			, PesqPict("SE2","E2_VALLIQ"    ,18), 16		,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT"/*cAlign*/,/*lLineBreak*/,"LEFT"/*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/,/*lAutoSize*/.F.)
	//TRCell():New(oiSec1,"E2_SALDO"		,"QRY"/*Tabela*/,"Saldo em Aberto"			, PesqPict("SE2","E2_SALDO"    ,18), 16		,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT"/*cAlign*/,/*lLineBreak*/,"LEFT"/*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/,/*lAutoSize*/.F.)
	//TRCell():New(oiSec1,"E2_BAIXA"		,"QRY"/*Tabela*/,"Dt Baixa"			, PesqPict("SE2","E2_BAIXA"    ,18),13		,/*lPixel*/,{|| cValToChar(Stod(QRY->E2_BAIXA)) },"LEFT"/*cAlign*/,/*lLineBreak*/,"LEFT"/*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/,/*lAutoSize*/.F.)
	//TRCell():New(oiSec1,"E2_NATUREZ"		,"QRY"/*Tabela*/,"Natureza"			, PesqPict("SE2","E2_NATUREZ"    ,18), 20		,/*lPixel*/,{|| Posicione("SED",1,xFilial("SE4")+QRY->E2_NATUREZ,"ED_DESCRIC")},"LEFT"/*cAlign*/,/*lLineBreak*/,"LEFT"/*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/,/*lAutoSize*/.F.)
	//TRCell():New(oiSec1,"E2_CCUSTO"		,"QRY"/*Tabela*/,"C.Custo"			, PesqPict("SE2","E2_CCUSTO"    ,18), 15		,/*lPixel*/,{|| Posicione("CTT",1,xFilial("CTT")+QRY->E2_CCUSTO,"CTT_DESC01")},"LEFT"/*cAlign*/,/*lLineBreak*/,"LEFT"/*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/,/*lAutoSize*/.F.)
	//TRCell():New(oiSec1,"E2_HIST"		,"QRY"/*Tabela*/,"Historico"			, PesqPict("SE2","E2_HIST"    ,18),15,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT"/*cAlign*/,/*lLineBreak*/,"LEFT"/*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/,/*lAutoSize*/.F.)
	//TRFunction():New(oiSec1:Cell("Vlr Baixado")	,NIL, "SUM"   ,/*oBreak*/,"Total de Vlr Baixado", "@E 999,999,999",{|| oiSec1:Cell("Vlr Baixado"):GetValue(.T.) 	},.T.,.F.)
	//TRFunction():New(oiSec1:Cell("Saldo em Aberto")	,NIL, "SUM"   ,/*oBreak*/,"Total de Saldo em abertos", "@E 999,999,999",{|| oiSec1:Cell("Saldo em Aberto"):GetValue(.T.) 	},.T.,.F.)

	//oBreak := Trbreak():New(oiSec1, oiSec1:Cell("CliFor"),{||"Total Fornecedor"}, .F.)
	//TRFunction():New(oiSec1:Cell("Vlr Bruto")  	 				,"","SUM", oBreak,"","@E 999,999,999.99",,.f.,.f.,.f.,oiSec1,,,)
	//TRFunction():New(oiSec1:Cell("Vlr Baixado")  	 				,"","SUM", oBreak,"","@E 999,999,999.99",,.f.,.f.,.f.,oiSec1,,,)
	//TRFunction():New(oiSec1:Cell("Saldo em Aberto")  	 				,"","SUM", oBreak,"","@E 999,999,999.99",,.f.,.f.,.f.,oiSec1,,,)


	//oiSec1:Cell("Vlr Bruto"):SetAlign("RIGHT")
	//oiSec1:Cell("Vlr Baixado"):SetAlign("RIGHT")
	//oiSec1:Cell("Saldo em Aberto"):SetAlign("RIGHT")
Return(oReport)



/*/{Protheus.doc} nomeStaticFunction
	Montagem da query para impressao do relatorio
	@type  Function Static
	@author Amarilson Ribeiro
	@since 26/08/2025
	@Uso BENEL
/*/
Static Function PrintReport(oReport)
	Local cDB := TCGetDB()
	Local cQuery
	Local oSection1 := oReport:Section(1)


	cQuery := ""
	cQuery += " SELECT " + ;
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
