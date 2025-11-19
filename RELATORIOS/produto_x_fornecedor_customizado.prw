#include 'Totvs.ch'
#include 'Protheus.ch'
#include 'rwmake.ch'

/*/{Protheus.doc} PRODUTO_X_FORNECEDOR_CUSTOMIZADO  ||  PRODxFORN
   ======================================================================
        ▒▒▒  RELATÓRIO DE RELAÇÃO DE PRODUTOS POR FORNECEDOR  ▒▒▒
   ======================================================================

   @type      function
   @version   1.0
   @author    Pedro Igor
   @since     19/11/2025

   ======================================================================
/*/

User Function PRODxFORN()

	Local oReport

	oReport:=  ReportDef()
	oReport:PrintDialog()

	oReport:=	Nil

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

	//Pergunte("PRODXFORN", .F.)

	//Criação do objeto relatório
	oReport:=  TReport():New("PRODXFORN", "Produtos por Fornecedor", "PRODXFORN", {|oReport| PrintReport(oReport)}, "Relação de Produtos por Fornecedor")
	oReport:SetLandscape()
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:SetEnvironment(2)
	oReport:SetLineHeight(30)
	oReport:nFontBody := 8

	//Definição da seção do relatório
	oiSec1:=TRSection():New(oReport, "Produtos por Fornecedor", {"QRY"})
	oiSec1:SetAutoSize(.T.)

	//Definição das colunas do relatório
	TRCell():New(oiSec1,"A5_PRODUTO"		,"QRY"/*Tabela*/,"Produto"			, PesqPict("SA5", "A5_PRODUTO", 15),  TamSX3("A5_PRODUTO")[1],/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT"/*cAlign*/,/*lLineBreak*/,"LEFT"/*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/,/*lAutoSize*/.F.)
	TRCell():New(oiSec1,"A5_NOMPROD"		,"QRY"/*Tabela*/,"Nome do Produto"	, PesqPict("SA5", "A5_NOMPROD", 50), TamSX3("A5_NOMPROD")[1],/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT"/*cAlign*/,/*lLineBreak*/,"LEFT"/*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/,/*lAutoSize*/.F.)
	TRCell():New(oiSec1,"A5_FORNECE"  	,"QRY"/*Tabela*/,"Fornecedor"		, PesqPict("SA5", "A5_FORNECE", 6), TamSX3("A5_FORNECE")[1],/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT"/*cAlign*/,/*lLineBreak*/,"LEFT"/*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/,/*lAutoSize*/.F.)
	TRCell():New(oiSec1,"A5_LOJA"		,"QRY"/*Tabela*/,"Loja Fornecedor"	    	, PesqPict("SA5", "A5_LOJA", 2), TamSX3("A5_LOJA")[1],/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT"/*cAlign*/,/*lLineBreak*/,"LEFT"/*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/,/*lAutoSize*/.F.)
	TRCell():New(oiSec1,"A5_NOMEFOR"		,"QRY"/*Tabela*/,"Nome do Fornecedor"			, PesqPict("SA5", "A5_NOMEFOR"), TamSX3("A5_NOMEFOR")[1],/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT"/*cAlign*/,/*lLineBreak*/,"LEFT"/*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/,/*lAutoSize*/.F.)

Return (oReport)

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
	cQuery := "SELECT SA5.A5_PRODUTO, SA5.A5_NOMPROD, SA5.A5_FORNECE, SA5.A5_LOJA, SA5.A5_NOMEFOR FROM SA5990 AS SA5 "
	cQuery += "INNER JOIN SB1990 AS SB1 ON SB1.B1_COD = SA5.A5_PRODUTO "
	cQuery += "WHERE SB1.D_E_L_E_T_ = '' AND SA5.D_E_L_E_T_ = '' AND SB1.B1_GRUPO = '" + Alltrim(MV_PAR01) + "'"

	cQuery := ChangeQuery(cQuery)
	MPSysOpenQuery(cQuery, "QRY")

	QRY->(dbGoTop())

	if !QRY->(Eof())
		oReport:IncMeter()
		oSection1:init()

		while QRY->(!Eof())

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
