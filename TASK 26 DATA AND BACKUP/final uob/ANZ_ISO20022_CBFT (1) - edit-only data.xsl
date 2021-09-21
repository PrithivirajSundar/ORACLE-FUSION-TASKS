<?xml version='1.0' encoding='utf-8'?>
 <!--   $Header: fusionapps/fin/iby/bipub/shared/runFormat/reports/DisbursementPaymentFileFormats/ISO20022CGI.xsl /st_fusionapps_pt-v2mib/4 2018/04/04 07:35:17 jswirsky Exp $   
  --> 
 <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output omit-xml-declaration="no" /> 
  <xsl:output method="xml" /> 
  <xsl:key name="contacts-by-LogicalGroupReference" match="OutboundPayment" use="LogicalGrouping/LogicalGroupReference" /> 
 <xsl:template match="OutboundPaymentInstruction">
 <Document xmlns="urn:iso:std:iso:20022:tech:xsd:pain.001.001.03" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <xsl:variable name="instrid" select="PaymentInstructionInfo/InstructionReferenceNumber" /> 
 <GrpHdr>
 <MsgId>
  <xsl:value-of select="$instrid" /> 
  </MsgId>
  <CreDtTm>
		<xsl:value-of select="substring(PaymentInstructionInfo/InstructionCreationDate,1,19)" />
  </CreDtTm>
 <NbOfTxs>
  <xsl:value-of select="substring(InstructionTotals/PaymentCount,1,15)" /> 
  </NbOfTxs>
 <CtrlSum>
	<xsl:value-of select="substring(format-number(InstructionTotals/TotalPaymentAmount/Value, '##0.00'),1,18)" />
  </CtrlSum>
 <InitgPty>
 <Id>
 <OrgId>
 <BICOrBEI>
  <xsl:value-of select="substring(InstructionGrouping/BankAccount/SwiftCode,1,11)" />
 </BICOrBEI>
  </OrgId>
  </Id>
  </InitgPty>
  </GrpHdr>
  <xsl:for-each select="OutboundPayment">
  <PmtInf>
 <PmtInfId>
  <xsl:value-of select="$instrid" /> 
  </PmtInfId>
  <PmtMtd>CHK
  </PmtMtd> 
 <PmtTpInf>
  <LclInstrm>
  <Prtry>CCGQ</Prtry>
  </LclInstrm>
 <ReqdExctnDt>
  <xsl:value-of select="PaymentDate" /> 
  </ReqdExctnDt>
 <Dbtr>
 <Nm>The Ascott Ltd
  </Nm>
 <PstlAdr>
 <Ctry>
  <xsl:value-of select="substring(BankAccount/BankAddress/Country,1,2)" />
  </Ctry>
  </PstlAdr>
 <Id>
 <OrgId>
 <Othr>
 <Id>
  <xsl:value-of select="substring(../InstructionGrouping/BankAccount/SwiftCode,1,35)" />
  </Id>
  </Othr>
  </OrgId>
  </Id>
 </Dbtr>
 <DbtrAcct>
 <Id>
  <Othr>
    <Id>
      <xsl:value-of select="substring(BankAccount/BankAccountNumber,1,34)" />
    </Id>
  </Othr>
 </Id>
 <Ccy>
   <xsl:value-of select="substring(BankAccount/BankAccountCurrency/Code,1,3)" /> 
 </Ccy>
 </DbtrAcct>
 <DbtrAgt>
 <FinInstnId>
 <BIC>
  <xsl:value-of select="substring(../InstructionGrouping/BankAccount/SwiftCode,1,11)" /> 
  </BIC>
  <PstlAdr>
  <Ctry>
  <xsl:value-of select="substring(BankAccount/BankAddress/Country,1,2)" /> 
  </Ctry>
  </PstlAdr>
 </FinInstnId>
  </DbtrAgt>
 <CdtTrfTxInf>
 <PmtId>
 <InstrId>
  <xsl:value-of select="substring(PaymentNumber/CheckNumber,1,35)" /> 
  </InstrId>
 <EndToEndId>
  <xsl:value-of select="substring(PaymentNumber/CheckNumber,1,35)" /> 
  </EndToEndId>
  </PmtId>
 <Amt>
 <InstdAmt>
 <xsl:attribute name="Ccy">
  <xsl:value-of select="substring(PaymentAmount/Currency/Code,1,18)" /> 
  </xsl:attribute>
  <xsl:value-of select="format-number(PaymentAmount/Value, '##0.00')" /> 
  </InstdAmt>
  </Amt>
 <ChqInstr>
 <DlvryMtd>
 <Cd>MLCD</Cd>
 </DlvryMtd>
 </ChqInstr>
  <PstlAdr>
 <Cdtr>
 <Nm>
  <xsl:value-of select="substring(SupplierorParty/Name,1,140) " /> 
  </Nm>
  <PstlAdr>
  <PstCd>
  <xsl:value-of select="substring(SupplierorParty/Address/PostalCode,1,16)" /> 
  </PstCd>
  <Ctry>
  <xsl:value-of select="substring(SupplierorParty/Address/Country,1,2)" /> 
  </Ctry>
  <xsl:if test="not(SupplierorParty/Address/AddressLine1='')">
  <AdrLine><xsl:value-of select="substring(SupplierorParty/Address/AddressLine1,1,70)" /> </AdrLine>
  </xsl:if>
  <xsl:if test="not(SupplierorParty/Address/AddressLine2='')">
  <AdrLine><xsl:value-of select="substring(SupplierorParty/Address/AddressLine2,1,70)" /> </AdrLine>
  </xsl:if>
  <xsl:if test="not(SupplierorParty/Address/AddressLine3='')">
  <AdrLine><xsl:value-of select="substring(SupplierorParty/Address/AddressLine3,1,70)" /> </AdrLine>
  </xsl:if>
  </PstlAdr>
  </Cdtr>
 <RltdRmtInf>
 <RmtLctnMtd>POST</RmtLctnMtd>
 <RmtLctnPstlAdr>
 <Nm>
 <xsl:value-of select="substring(SupplierorParty/Name,1,140)" />
 </Nm>
 <Adr>
 <PstCd>
 <xsl:value-of select="substring(SupplierorParty/Address/PostalCode,1,16)" />
 </PstCd>
 <Ctry>
 <xsl:value-of select="substring(SupplierorParty/Address/Country,1,2)" />
 </Ctry>
  <xsl:if test="not(SupplierorParty/Address/AddressLine1='')">
  <AdrLine><xsl:value-of select="substring(SupplierorParty/Address/AddressLine1,1,70)" /> </AdrLine> 
  </xsl:if>
  <xsl:if test="not(SupplierorParty/Address/AddressLine2='')">
  <AdrLine><xsl:value-of select="substring(SupplierorParty/Address/AddressLine2,1,70)" /> </AdrLine>
  </xsl:if>
  <xsl:if test="not(SupplierorParty/Address/AddressLine3='')">
  <AdrLine><xsl:value-of select="substring(SupplierorParty/Address/AddressLine3,1,70)" /> </AdrLine>
  </xsl:if>
 </Adr>
 </RmtLctnPstlAdr>
 </RltdRmtInf>
 <RmtInf>
<xsl:for-each select="DocumentPayable">
<Ustrd>H1:Invoice Number Invoice Date Invoice Total Amount Invoice Currency Payment Amount</Ustrd>
<Ustrd>3:
<xsl:text> </xsl:text>
<xsl:value-of select="DocumentNumber/ReferenceNumber" />
<xsl:text> </xsl:text>
<xsl:value-of select="DocumentDate" />
<xsl:text> </xsl:text>
<xsl:value-of select="format-number(TotalDocumentAmount/Value, '##0.00')" /> 
<xsl:text> </xsl:text>
<xsl:value-of select="TotalDocumentAmount/Currency/Code" /> 
<xsl:text> </xsl:text>
<xsl:value-of select="PaymentAmount/Value" /> 
</Ustrd>
</xsl:for-each>
 <Strd>
 <Invcr>
 <Nm>
 <xsl:value-of select="substring(SupplierorParty/Name,1,140)" />
 </Nm>
 </Invcr>
 <Invcee>
 <Nm>
 <xsl:value-of select="substring(../InstructionGrouping/Payer/Name,1,140)" />
 </Nm>
 </Invcee>
  </Strd>
  </RmtInf>
  </PstlAdr>
  </CdtTrfTxInf>
  </PmtTpInf>
  </PmtInf>
  </xsl:for-each>
  </Document>
  </xsl:template>
  </xsl:stylesheet>
