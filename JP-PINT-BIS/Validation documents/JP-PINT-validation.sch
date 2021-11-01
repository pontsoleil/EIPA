<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <ns prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
  <ns prefix="qdt" uri="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2"/>
  <ns prefix="udt" uri="urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2"/>
  <ns prefix="cn" uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"/>
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"/>
  <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
  <ns prefix="u" uri="utils"/>
  <!--
<schema
  xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" 
  xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" 
  xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" 
  xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:u="utils"
  xmlns="http://purl.oclc.org/dsdl/schematron" 
  queryBinding="xslt2">-->
  <!-- ========================= -->
  
  <include href="../../../Documents/GitHub/EIPA/JP-PINT-BIS/Validation documents/Japan-UBL-model.sch"/>
  <include href="../../../Documents/GitHub/EIPA/JP-PINT-BIS/Validation documents/Japan-Codesmode.sch "/>
  
  <include href="../../../Documents/GitHub/EIPA/JP-PINT-BIS/Validation documents/PINT-UBL-model.sch"/>
  <include href="../../../Documents/GitHub/EIPA/JP-PINT-BIS/Validation documents/PINT-Codesmodel.sch"/>
  
  <include href="../../../Documents/GitHub/EIPA/JP-PINT-BIS/Validation documents/UBL-syntax.sch"/>
  
  <phase id="UBL-phase">
    <active pattern="UBL-syntax"/>
  </phase>
  
  <phase id="JP-model_phase">
    <active pattern="JP-UBL-model"/>
  </phase>
  <phase id="JP-codelist-phase">
    <active pattern="JP-Codesmodel"/>
  </phase>  
  
  <phase id="PINT-model-phase">
    <active pattern="PINT-UBL-model"/>
  </phase>
  <phase id="PINT-codelist-phase">
    <active pattern="PINT-Codesmodel"/>
  </phase>
  
  <!--

    Parameters
    
  -->
  <let name="profile" value="
    if (/*/cbc:ProfileID and 
    matches(normalize-space(/*/cbc:ProfileID), 'urn:fdc:peppol.eu:2017:poacc:billing:([0-9]{2}):1.0')) then
    tokenize(normalize-space(/*/cbc:ProfileID), ':')[7]
    else
    'Unknown'
    "/>
  <let name="supplierCountry" value="
    if (/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)) then
    upper-case(normalize-space(/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)))
    else
    if (/*/cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)) then
    upper-case(normalize-space(/*/cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)))
    else
    if (/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) then
    upper-case(normalize-space(/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))
    else
    'XX'
    "/>
  <let name="customerCountry" value="
    if (/*/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)) then
    upper-case(normalize-space(/*/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)))
    else
    if (/*/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) then
    upper-case(normalize-space(/*/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))
    else
    'XX'
    "/>
  <let name="documentCurrencyCode" value="
    /*/cbc:DocumentCurrencyCode
    "/>
  <let name="taxCurrencyCode" value="
    /*/cbc:TaxCurrencyCode
    "/>
  <!--

    Functions

  -->
  <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:gln" as="xs:boolean">
    <param name="val"/>
    <variable name="length" select="
      string-length($val) - 1
      "/>
    <variable name="digits" select="
      reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)
      "/>
    <variable name="weightedSum" select="
      sum(
      for $i in (0 to $length - 1) 
      return $digits[$i + 1] * (1 + ((($i + 1) mod 2) * 2))
      )
      "/>
    <value-of select="
      (10 - ($weightedSum mod 10)) mod 10 = number(substring($val, $length + 1, 1))
      "/>
  </function>
  <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:slack" as="xs:boolean">
    <param name="exp" as="xs:decimal"/>
    <param name="val" as="xs:decimal"/>
    <param name="slack" as="xs:decimal"/>
    <value-of select="
      xs:decimal($exp + $slack) &gt;= $val and 
      xs:decimal($exp - $slack) &lt;= $val
      "/>
  </function>
  
</schema>