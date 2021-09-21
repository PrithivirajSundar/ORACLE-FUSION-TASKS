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
  <xsl:value-of select="substring(InstructionTotals/PaymentCount,1,15)" /> 
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
 
 <PmtInf>

 <PmtInfId>
 
  <xsl:value-of select="$instrid" /> 
  </PmtInfId>

  <PmtMtd>TRF</PmtMtd>

  <BtchBookg>F</BtchBookg>
 
 <NbOfTxs>
  
  <xsl:value-of select="substring(InstructionTotals/PaymentCount,1,15)" />
  </NbOfTxs>
 <CtrlSum>
  
  <xsl:value-of select="InstructionTotals/TotalPaymentAmount/Value" />
  </CtrlSum>
 
 <PmtTpInf>
 
    <InstrPrty>NORM</InstrPrty>
 </PmtTpInf>
 
 <ReqdExctnDt>
 
  <xsl:value-of select="OutboundPayment/PaymentDate" /> 
  </ReqdExctnDt>
 <Dbtr>
 <Nm>
  <xsl:value-of select="substring(InstructionGrouping/Payer/Name,1,140)" /> 
  </Nm>
 <PstlAdr>
 
 <Ctry>
  
  <xsl:value-of select="substring(OutboundPayment/BankAccount/BankAddress/Country,1,2)" /> 
  </Ctry>
 
  </PstlAdr>
  </Dbtr>
 
 <DbtrAcct>
 <Id>
  
  <Othr>
    <Id>
      <xsl:value-of select="substring(OutboundPayment/BankAccount/BankAccountNumber,1,34)" />
    </Id>
  </Othr>
  </Id>
 
 <Ccy>
   <xsl:value-of select="substring(OutboundPayment/BankAccount/BankAccountCurrency/Code,1,3)" /> 
 </Ccy>
 <Nm>
   <xsl:value-of select="substring(OutboundPayment/BankAccount/BankAccountName,1,70)" />  
 </Nm>
 </DbtrAcct>
 <DbtrAgt>
 <FinInstnId>
 
 <xsl:if test="not(OutboundPayment/PayeeBankAccount/SwiftCode='')">
 <BIC>
  <xsl:value-of select="OutboundPayment/PayeeBankAccount/SwiftCode" /> 
  </BIC>
  </xsl:if>

 

  <Nm>
  <xsl:value-of select="substring(OutboundPayment/BankAccount/BankAccountName,1,140)" />
  </Nm>
  <PstlAdr>

  <Ctry>

  <xsl:value-of select="substring(OutboundPayment/BankAccount/BankAddress/Country,1,2)" /> 
  </Ctry>
  </PstlAdr>
  </FinInstnId>
  </DbtrAgt>
  
 
  

 <CdtTrfTxInf>
 <PmtId>
 <InstrId>

  <xsl:value-of select="substring(OutboundPayment/PaymentNumber/CheckNumber,1,35)" /> 
  </InstrId>
 <EndToEndId>

  <xsl:value-of select="substring(OutboundPayment/PaymentNumber/CheckNumber,1,35)" /> 
 
  </EndToEndId>
  </PmtId>

 <Amt>
 <InstdAmt>
 <xsl:attribute name="Ccy">
  <xsl:value-of select="substring(OutboundPayment/PaymentAmount/Currency/Code,1,3)" /> 
  </xsl:attribute>
  <xsl:value-of select="format-number(OutboundPayment/PaymentAmount/Value, '##0.00')" /> 
  </InstdAmt>
  </Amt>

 

 <CdtrAgt>
 <FinInstnId>

 <xsl:if test="not(OutboundPayment/PayeeBankAccount/SwiftCode='')">
 <BIC>
  <xsl:value-of select="OutboundPayment/PayeeBankAccount/SwiftCode" /> 
  </BIC>
  </xsl:if>
 
  <ClrSysId>
  <Prtry>VNNCC</Prtry>
  </ClrSysId>
  <Nm>
    <xsl:value-of select="substring(OutboundPayment/PayeeBankAccount/BankAccountName,1,140)" />
  </Nm>

  <Ctry>
  <xsl:value-of select="substring(OutboundPayment/PayeeBankAccount/BankAddress/Country,1,2)" /> 
  </Ctry>

 </FinInstnId>
 </CdtrAgt>
 <Cdtr>
 <Nm>
 <xsl:value-of select="substring(OutboundPayment/PayeeBankAccount/BankAccountName,1,140)" />
 </Nm>
  <PstlAdr>
  <PstCd>
    <xsl:value-of select="substring(OutboundPayment/SupplierorParty/Address/PostalCode,1,16)" />
  </PstCd>
  <TwnNm>
    <xsl:value-of select="substring(OutboundPayment/SupplierorParty/Address/City,1,35)" />  
  </TwnNm>
 
  <Ctry>
  <xsl:value-of select="substring(OutboundPayment/SupplierorParty/Address/Country,1,2)" /> 
  </Ctry>
  <AdrLine> <xsl:value-of select="substring(OutboundPayment/SupplierorParty/Address/AddressLine1,1,70)" /> 
   <xsl:value-of select="substring(OutboundPayment/SupplierorParty/Address/AddressLine2,1,70)" /> 
  <xsl:value-of select="substring(OutboundPayment/SupplierorParty/Address/AddressLine3,1,70)" /> </AdrLine>
  
  </PstlAdr>

  </Cdtr> 
 <CdtrAcct>
 <Id>
  <Othr>
   <Id>
     <xsl:value-of select="substring(OutboundPayment/PayeeBankAccount/BankAccountNumber,1,34)" />
   </Id>
  </Othr>
  </Id>
  

  </CdtrAcct>

 <RmtInf>


  <Invcr>
  <Nm>
  <xsl:value-of select="substring(OutboundPayment/SupplierorParty/Name,1,140)" />
  </Nm>
  </Invcr>
  <Invcee>
  <Nm>
  <xsl:value-of select="substring(InstructionGrouping/Payer/Name,1,40)" />
  </Nm>
  </Invcee>
  </RmtInf>
  </CdtTrfTxInf>
  </PmtInf>
  </CstmrCdtTrfInitn> 
  </Document>
  </xsl:template>
  </xsl:stylesheet>
