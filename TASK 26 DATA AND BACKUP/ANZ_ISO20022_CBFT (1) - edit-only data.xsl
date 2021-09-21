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
		<xsl:value-of select="PaymentInstructionInfo/InstructionCreationDate" />
  </CreDtTm>
 <NbOfTxs>
  <xsl:value-of select="InstructionTotals/PaymentCount" /> 
  </NbOfTxs>
 <CtrlSum>
	<xsl:value-of select="format-number(sum(InstructionTotals/TotalPaymentAmount/Value), '##0.00')"/>
  </CtrlSum>
 <InitgPty>
 <Id>
 <OrgId>
 <BICOrBEI>
  <xsl:value-of select="InstructionGrouping/BankAccount/SwiftCode" />
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
 <SvcLvl>
  </SvcLvl>
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
  <xsl:value-of select="Payer/Address/Country" /> 
  <xsl:value-of select="BankAccount/BankAddress/Country" />
  </Ctry>
  </PstlAdr>
 <Id>
 <OrgId>
 <Othr>
 <Id>
  <xsl:value-of select="../InstructionGrouping/BankAccount/SwiftCode" />
  </Id>
  </Othr>
  </OrgId>
  </Id>
 </Dbtr>
 <DbtrAcct>
 <Id>
  <Othr>
    <Id>
      <xsl:value-of select="BankAccount/BankAccountNumber" />
    </Id>
  </Othr>
 </Id>
 <Ccy>
   <xsl:value-of select="BankAccount/BankAccountCurrency/Code" /> 
 </Ccy>
 </DbtrAcct>
 <DbtrAgt>
 <FinInstnId>
 <BIC>
  <xsl:value-of select="../InstructionGrouping/BankAccount/SwiftCode" /> 
  </BIC>
  <PstlAdr>
  <Ctry>
  <xsl:value-of select="BankAccount/BankAddress/Country" /> 
  </Ctry>
  </PstlAdr>
 </FinInstnId>
  </DbtrAgt>
  <UltmtDbtr>
 </UltmtDbtr>
 <CdtTrfTxInf>
 <PmtId>
 <InstrId>
  <xsl:value-of select="PaymentNumber/CheckNumber" /> 
  </InstrId>
 <EndToEndId>
  <xsl:value-of select="substring(PaymentNumber/CheckNumber, 0, 16)" /> 
  </EndToEndId>
  </PmtId>
 <Amt>
 <InstdAmt>
 <xsl:attribute name="Ccy">
  <xsl:value-of select="PaymentAmount/Currency/Code" /> 
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
  <xsl:value-of select="substring(SupplierorParty/Name, 0, 35) " /> 
  </Nm>
  <PstlAdr>
  <PstCd>
  <xsl:value-of select="substring(SupplierorParty/Address/PostalCode, 0, 8)" /> 
  </PstCd>
  <Ctry>
  <xsl:value-of select="SupplierorParty/Address/Country" /> 
  </Ctry>
  <AdrLine>
  <xsl:value-of select="SupplierorParty/Address/AddressLine1" />
  <xsl:value-of select="SupplierorParty/Address/AddressLine2" />
  <xsl:value-of select="SupplierorParty/Address/AddressLine3" />
  </AdrLine>
  </PstlAdr>
  </Cdtr>
 <RltdRmtInf>
 <RmtLctnMtd>POST</RmtLctnMtd>
 <xsl:if test="not(Payee/RemitAddressDeliveryMethod4='')">
 <RmtLctnElctrncAdr>
 <xsl:value-of select="Payee/RemitAddressEmail" />
 </RmtLctnElctrncAdr>
 </xsl:if>
 <RmtLctnPstlAdr>
 <Nm>
 <xsl:value-of select="SupplierorParty/Name" />
 </Nm>
 <Adr>
 <PstCd>
 <xsl:value-of select="supplierorParty/Address/PostalCode" />
 </PstCd>
 <Ctry>
 <xsl:value-of select="supplierorParty/Address/Country" />
 </Ctry>
 <AdrLine>
 <xsl:value-of select="supplierorParty/Address/AddressLine1" />
 <xsl:value-of select="supplierorParty/Address/AddressLine2" />
 <xsl:value-of select="supplierorParty/Address/AddressLine3" />
 </AdrLine>
 </Adr>
 </RmtLctnPstlAdr>
 </RltdRmtInf>
 <RmtInf>
<xsl:for-each select="DocumentPayable">
<Ustrd>
<xsl:text>Invoice Number:</xsl:text>
<xsl:value-of select="DocumentNumber/ReferenceNumber" />
<xsl:text>Invoice Date:</xsl:text>
<xsl:value-of select="DocumentDate" />
<xsl:text>Invoice Total Amount:</xsl:text>
<xsl:value-of select="format-number(TotalDocumentAmount/Value, '##0.00')" /> 
<xsl:text>Invoice Currency:</xsl:text>
<xsl:value-of select="TotalDocumentAmount/Currency/Code" /> 
<xsl:text>Payment Amount:</xsl:text>
<xsl:value-of select="PaymentAmount/Value" /> 
</Ustrd>
</xsl:for-each>
 <Strd>
 <Invcr>
 <Nm>
 <xsl:value-of select="SupplierorParty/Name" />
 </Nm>
 </Invcr>
 <Invcee>
 <Nm>
 <xsl:value-of select="../InstructionGrouping/Payer/Name" />
 </Nm>
 </Invcee>
  </Strd>
  </RmtInf>
  </PmtInf>
  </xsl:for-each>
  </Document>
  </xsl:template>
  </xsl:stylesheet>
