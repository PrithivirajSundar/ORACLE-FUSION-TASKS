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
 <CstmrCdtTrfInitn>
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
 <Nm>
 
  <xsl:value-of select="InstructionGrouping/Payer/LegalEntityName" /> 
 
  </Nm>
 
  </InitgPty>
  </GrpHdr>
 <xsl:for-each select="OutboundPayment[count(. | key('contacts-by-LogicalGroupReference', LogicalGrouping/LogicalGroupReference)[1]) = 1]">
  <xsl:sort select="LogicalGrouping/LogicalGroupReference" /> 

 <PmtInf>

 <PmtInfId>
 
  <xsl:value-of select="$instrid" /> 
  </PmtInfId>

  <PmtMtd>

  </PmtMtd> 

  <BtchBookg>F</BtchBookg>
 
 <NbOfTxs>
  
  <xsl:value-of select="InstructionTotals/PaymentCount" />
  </NbOfTxs>
 <CtrlSum>
  
  <xsl:va;ue-of select="InstructionTotals/TotalPaymentAmount/Value" />
  </CtrlSum>
 
 <PmtTpInf>
 
    <InstrPrty>NORM</InstrPrty>
 
 <ReqdExctnDt>
 
  <xsl:value-of select="OutboundPayment/PaymentDate" /> 
  </ReqdExctnDt>
 <Dbtr>
 <Nm>
  <xsl:value-of select="InstructionGrouping/Payer/Name" /> 
  </Nm>
 <PstlAdr>
 
 <Ctry>
  
  <xsl:value-of select="BankAccount/BankAddress/Country" /> 
  </Ctry>
 
  </PstlAdr>
 
 <DbtrAcct>
 <Id>
  
  <Othr>
    <Id>
      <xsl:value-of select="OutboundPayment/BankAccount/BankAccountNumber" />
    </Id>
  </Othr>
 
 <Ccy>
   <xsl:value-of select="BankAccount/BankAccountCurrency/Code" /> 
 </Ccy>
 </DbtrAcct>
 <DbtrAgt>
 <FinInstnId>
 
 <BIC>
  <xsl:value-of select="InstructionGrouping/BankAccount/SwiftCode" /> 
  </BIC>

 </FinInstnId>

  <Nm>

  <xsl:value-of select="OutboundPayment/BankAccount/BankAccountName" />
  </Nm>
  <PstlAdr>

  <Ctry>

  <xsl:value-of select="BankAccount/BankAddress/Country" /> 
  </Ctry>
  </PstlAdr>
 
  <ChrgBr>
  <xsl:choose>
   <xsl:when test="(BankCharges/BankChargeBearer/Code='BEN') <!-- or (BankCharges/BankChargeBearer/Code='PAYEE_PAYS_EXPRESS')"> -->
   <xsl:text>CRED</xsl:text> 
   </xsl:when>
   <xsl:when test="(BankCharges/BankChargeBearer/Code='OUR')">
   <xsl:text>DEBT</xsl:text> 
   </xsl:when>
   <xsl:when test="(BankCharges/BankChargeBearer/Code='SHA')">
   <xsl:text>SHAR</xsl:text> 
   </xsl:when>

  </xsl:choose>
  </ChrgBr> 

 <CdtTrfTxInf>
 <PmtId>
 <InstrId>

  <xsl:value-of select="OutboundPayment/PaymentNumber/CheckNumber" /> 
  </InstrId>
 <EndToEndId>

  <xsl:value-of select="OutboundPayment/PaymentNumber/CheckNumber)" /> 
 
  </EndToEndId>
  </PmtId>

 <Amt>
 <InstdAmt>
 <xsl:attribute name="Ccy">
  <xsl:value-of select="OutboundPayment/PaymentAmount/Currency/Code" /> 
  </xsl:attribute>
  <xsl:value-of select="format-number(OutboundPayment/PaymentAmount/Value, '##0.00')" /> 
  </InstdAmt>
  </Amt>
  <xsl:if test="not(PaymentMethod/PaymentMethodFormatValue='CHK')">
  <xsl:if test="(/OutboundPaymentInstruction/PaymentProcessProfile/LogicalGrouping/GroupByBankChargeBearer='N')">
  <xsl:if test="not(BankCharges/BankChargeBearer/Code='')">
  <ChrgBr>
  <xsl:choose>
   <xsl:when test="(BankCharges/BankChargeBearer/Code='BEN') <!-- or (BankCharges/BankChargeBearer/Code='PAYEE_PAYS_EXPRESS')"> -->
   <xsl:text>CRED</xsl:text> 
   </xsl:when>
   <xsl:when test="(BankCharges/BankChargeBearer/Code='OUR')">
   <xsl:text>DEBT</xsl:text> 
   </xsl:when>
   <xsl:when test="(BankCharges/BankChargeBearer/Code='SHA')">
   <xsl:text>SHAR</xsl:text> 
   </xsl:when>

  </xsl:choose>
  </ChrgBr> 

 <CdtrAgt>
 <FinInstnId>

 <BIC>
  <xsl:value-of select="PayeeBankAccount/SwiftCode" /> 
  </BIC>
 
  <ClrSysId>
  <Prtry>VNNCC</Prtry>
  </ClrSysId>
  <Nm>
    <xsl:value-of select="OutboundPayment/PayeeBankAccount/BankName" />
  </Nm>

  <Ctry>
  <xsl:value-of select="PayeeBankAccount/BankAddress/Country" /> 
  </Ctry>
  <AdrLine> <xsl:value-of select="BankAddress/AddressLine1" /> </AdrLine>
  <AdrLine> <xsl:value-of select="BankAddress/AddressLine2" /> </AdrLine>
  <AdrLine> <xsl:value-of select="BankAddress/AddressLine3" /> </AdrLine>

 <Cdtr>
 <Nm>

  <xls:value-of select="PayeeBankAccount/BankAccountName" />
  </Nm>
  <PstlAdr>

  <PstCd>

  <xsl:value-of select="SupplierorParty/Address/PostalCode" />
  </PstCd>
  <TwnNm>

   <xsl:value-of select="SupplierorParty/Address/City" />  
  </TwnNm>
 
  <Ctry>
  <xsl:value-of select="SupplierorParty/Address/Country" /> 
  </Ctry>
  <AdrLine> <xsl:value-of select="BankAddress/AddressLine1" /> </AdrLine>
  <AdrLine> <xsl:value-of select="BankAddress/AddressLine2" /> </AdrLine>
  <AdrLine> <xsl:value-of select="BankAddress/AddressLine3" /> </AdrLine>
  </PstlAdr>

  </Cdtr> 
 <CdtrAcct>
 <Id>

  <IBAN>
  <xsl:value-of select="OutboundPayment/PayeeBankAccount/IBANNumber" /> 
  </IBAN>

  <Othr>
   <Id>
     <xsl:value-of select="OutboundPayment/PayeeBankAccount/BankAccountNumber" />
   </Id>
  </Othr>

  </CdtrAcct>

 <RmtInf>

 <Ustrd>
 <xls:value-of select="NVL((PaymentReasonComments,1,35),Supplier Payments)" />
 </Ustrd>

 </RmtInf>

  
  <Invcr>
  <Nm>
  <xsl:value-of select="SupplierorParty/Name" />
  </NM>
  </Invcr>
  <Invcee>
  <Nm>
  <xsl:value-of select="InstructionGrouping/Payer/Name" />
  </NM>
  </Invcee>
  </CstmrCdtTrfInitn> 
  </Document>
  </xsl:template>
  </xsl:stylesheet>
