<?xml version="1.0" encoding="UTF-8"?>
<!--
This schematron uses business terms defined the CEN/EN16931-1 and is reproduced with permission from CEN. CEN bears no liability from the use of the content and implementation of this schematron and gives no warranties expressed or implied for any purpose.
 -->
<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:u="utils" schemaVersion="iso" queryBinding="xslt2" id="JP-PEPPOL">
  <title>Rules for PEPPOL BIS 3.0 Billing</title>
  <ns prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" />
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
  <ns prefix="qdt" uri="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2" />
  <ns prefix="udt" uri="urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2" />
  <ns prefix="cn" uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" />
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" />
  <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" prefix="ubl-creditnote"/>
  <ns uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" prefix="ubl-invoice"/>
  <ns uri="http://www.w3.org/2001/XMLSchema" prefix="xs"/>
  <ns uri="utils" prefix="u"/>
  <!-- Parameters -->
  <let name="profile" value="
      if (/*/cbc:ProfileID and matches(normalize-space(/*/cbc:ProfileID), 'urn:fdc:peppol.eu:2017:poacc:billing:([0-9]{2}):1.0')) then
        tokenize(normalize-space(/*/cbc:ProfileID), ':')[7]
      else
        'Unknown'"/>
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
            'XX'"/>
	<let name="customerCountry" value="
		if (/*/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)) then
		upper-case(normalize-space(/*/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)))
		else
		if (/*/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) then
		upper-case(normalize-space(/*/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))
		else
		'XX'"/>
	<!-- -->
	<let name="documentCurrencyCode" value="/*/cbc:DocumentCurrencyCode"/>
	<!-- Functions -->
	<function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:gln" as="xs:boolean">
		<param name="val"/>
		<variable name="length" select="string-length($val) - 1"/>
		<variable name="digits" select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)"/>
		<variable name="weightedSum" select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (1 + ((($i + 1) mod 2) * 2)))"/>
		<value-of select="(10 - ($weightedSum mod 10)) mod 10 = number(substring($val, $length + 1, 1))"/>
	</function>
	<function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:slack" as="xs:boolean">
		<param name="exp" as="xs:decimal"/>
		<param name="val" as="xs:decimal"/>
		<param name="slack" as="xs:decimal"/>
		<value-of select="xs:decimal($exp + $slack) &gt;= $val and xs:decimal($exp - $slack) &lt;= $val"/>
	</function>
	<function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:mod11" as="xs:boolean">
		<param name="val"/>
		<variable name="length" select="string-length($val) - 1"/>
		<variable name="digits" select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)"/>
		<variable name="weightedSum" select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (($i mod 6) + 2))"/>
		<value-of select="number($val) &gt; 0 and (11 - ($weightedSum mod 11)) mod 11 = number(substring($val, $length + 1, 1))"/>
	</function>

  <phase id="EN16931model_phase">
    <active pattern="UBL-model" />
  </phase>
    <phase id="EN16931syntax_phase">
    <active pattern="UBL-syntax" />
  </phase>
  <phase id="codelist_phase">
    <active pattern="Codesmodel" />
  </phase>
  <phase id="Empty_phase">
    <active pattern="Empty-element" />
  </phase>
  <phase id="JP_phase">
    <active pattern="JP" />
  </phase>
  
  <pattern id="UBL-model">
    <rule context="cac:AdditionalDocumentReference">
      <assert id="BR-52" flag="fatal" test="(cbc:ID) != ''">[BR-52]-Each Additional supporting document (BG-24) shall contain a Supporting document reference (BT-122).</assert>
    </rule>
    <rule context="/ubl-invoice:Invoice/cac:LegalMonetaryTotal/cbc:PayableAmount">
      <assert id="BR-CO-25" flag="fatal" test="((. > 0) and (exists(//cbc:DueDate) or exists(//cac:PaymentTerms/cbc:Note))) or (. &lt;= 0)">[BR-CO-25]-In case the Amount due for payment (BT-115) is positive, either the Payment due date (BT-9) or the Payment terms (BT-20) shall be present.</assert>
    </rule>
    <rule context="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID">
      <assert id="BR-63" flag="fatal" test="exists(@schemeID)">[BR-63]-The Buyer electronic address (BT-49) shall have a Scheme identifier.</assert>
    </rule>
    <rule context="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress">
      <assert id="BR-11" flag="fatal" test="(cac:Country/cbc:IdentificationCode) != ''">[BR-11]-The Buyer postal address shall contain a Buyer country code (BT-55).</assert>
    </rule>
    <rule context="cac:PaymentMeans/cac:CardAccount">
      <assert id="BR-51" flag="fatal" test="string-length(cbc:PrimaryAccountNumberID)>=4 and string-length(cbc:PrimaryAccountNumberID)&lt;=6">[BR-51]-The last 4 to 6 digits of the Payment card primary account number (BT-87) shall be present if Payment card information (BG-18) is provided in the Invoice.</assert>
    </rule>
    <rule context="cac:Delivery/cac:DeliveryLocation/cac:Address">
      <assert id="BR-57" flag="fatal" test="exists(cac:Country/cbc:IdentificationCode)">[BR-57]-Each Deliver to address (BG-15) shall contain a Deliver to country code (BT-80).</assert>
    </rule>
    <rule context="/ubl-invoice:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | /ubl-creditnote:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = false()]">
      <assert id="BR-31" flag="fatal" test="exists(cbc:Amount)">[BR-31]-Each Document level allowance (BG-20) shall have a Document level allowance amount (BT-92).</assert>
      <assert id="BR-32" flag="fatal" test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID)">[BR-32]-Each Document level allowance (BG-20) shall have a Document level allowance VAT category code (BT-95).</assert>
      <assert id="BR-33" flag="fatal" test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)">[BR-33]-Each Document level allowance (BG-20) shall have a Document level allowance reason (BT-97) or a Document level allowance reason code (BT-98).</assert>
      <assert id="BR-CO-05" flag="fatal" test="true()">[BR-CO-05]-Document level allowance reason code (BT-98) and Document level allowance reason (BT-97) shall indicate the same type of allowance.</assert>
      <assert id="BR-CO-21" flag="fatal" test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)">[BR-CO-21]-Each Document level allowance (BG-20) shall contain a Document level allowance reason (BT-97) or a Document level allowance reason code (BT-98), or both.</assert>
      <assert id="BR-DEC-01" flag="fatal" test="string-length(substring-after(cbc:Amount,'.'))&lt;=2">[BR-DEC-01]-The allowed maximum number of decimals for the Document level allowance amount (BT-92) is 2.</assert>
      <assert id="BR-DEC-02" flag="fatal" test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2">[BR-DEC-02]-The allowed maximum number of decimals for the Document level allowance base amount (BT-93) is 2.</assert>
    </rule>
    <rule context="/ubl-invoice:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = true()] | /ubl-creditnote:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = true()]">
      <assert id="BR-36" flag="fatal" test="exists(cbc:Amount)">[BR-36]-Each Document level charge (BG-21) shall have a Document level charge amount (BT-99).</assert>
      <assert id="BR-37" flag="fatal" test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID)">[BR-37]-Each Document level charge (BG-21) shall have a Document level charge VAT category code (BT-102).</assert>
      <assert id="BR-38" flag="fatal" test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)">[BR-38]-Each Document level charge (BG-21) shall have a Document level charge reason (BT-104) or a Document level charge reason code (BT-105).</assert>
      <assert id="BR-CO-06" flag="fatal" test="true()">[BR-CO-06]-Document level charge reason code (BT-105) and Document level charge reason (BT-104) shall indicate the same type of charge.</assert>
      <assert id="BR-CO-22" flag="fatal" test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)">[BR-CO-22]-Each Document level charge (BG-21) shall contain a Document level charge reason (BT-104) or a Document level charge reason code (BT-105), or both.</assert>
      <assert id="BR-DEC-05" flag="fatal" test="string-length(substring-after(cbc:Amount,'.'))&lt;=2">[BR-DEC-05]-The allowed maximum number of decimals for the Document level charge amount (BT-99) is 2.</assert>
      <assert id="BR-DEC-06" flag="fatal" test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2">[BR-DEC-06]-The allowed maximum number of decimals for the Document level charge base amount (BT-100) is 2.</assert>
    </rule>
    <rule context="cac:LegalMonetaryTotal">
      <assert id="BR-12" flag="fatal" test="exists(cbc:LineExtensionAmount)">[BR-12]-An Invoice shall have the Sum of Invoice line net amount (BT-106).</assert>
      <assert id="BR-13" flag="fatal" test="exists(cbc:TaxExclusiveAmount)">[BR-13]-An Invoice shall have the Invoice total amount without VAT (BT-109).</assert>
      <assert id="BR-14" flag="fatal" test="exists(cbc:TaxInclusiveAmount)">[BR-14]-An Invoice shall have the Invoice total amount with VAT (BT-112).</assert>
      <assert id="BR-15" flag="fatal" test="exists(cbc:PayableAmount)">[BR-15]-An Invoice shall have the Amount due for payment (BT-115).</assert>
      <assert id="BR-CO-10" flag="fatal" test="(xs:decimal(cbc:LineExtensionAmount) = xs:decimal(round(sum(//(cac:InvoiceLine|cac:CreditNoteLine)/xs:decimal(cbc:LineExtensionAmount)) * 10 * 10) div 100))">[BR-CO-10]-Sum of Invoice line net amount (BT-106) = Σ Invoice line net amount (BT-131).</assert>
      <assert id="BR-CO-11" flag="fatal" test="xs:decimal(cbc:AllowanceTotalAmount) = (round(sum(../cac:AllowanceCharge[cbc:ChargeIndicator=false()]/xs:decimal(cbc:Amount)) * 10 * 10) div 100) or  (not(cbc:AllowanceTotalAmount) and not(../cac:AllowanceCharge[cbc:ChargeIndicator=false()]))">[BR-CO-11]-Sum of allowances on document level (BT-107) = Σ Document level allowance amount (BT-92).</assert>
      <assert id="BR-CO-12" flag="fatal" test="xs:decimal(cbc:ChargeTotalAmount) = (round(sum(../cac:AllowanceCharge[cbc:ChargeIndicator=true()]/xs:decimal(cbc:Amount)) * 10 * 10) div 100) or (not(cbc:ChargeTotalAmount) and not(../cac:AllowanceCharge[cbc:ChargeIndicator=true()]))">[BR-CO-12]-Sum of charges on document level (BT-108) = Σ Document level charge amount (BT-99).</assert>
      <assert id="BR-CO-13" flag="fatal" test="((cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = round((xs:decimal(cbc:LineExtensionAmount) + xs:decimal(cbc:ChargeTotalAmount) - xs:decimal(cbc:AllowanceTotalAmount)) * 10 * 10) div 100 ))  or (not(cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = round((xs:decimal(cbc:LineExtensionAmount) - xs:decimal(cbc:AllowanceTotalAmount)) * 10 * 10 ) div 100)) or ((cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = round((xs:decimal(cbc:LineExtensionAmount) + xs:decimal(cbc:ChargeTotalAmount)) * 10 * 10 ) div 100)) or (not(cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = xs:decimal(cbc:LineExtensionAmount)))">[BR-CO-13]-Invoice total amount without VAT (BT-109) = Σ Invoice line net amount (BT-131) - Sum of allowances on document level (BT-107) + Sum of charges on document level (BT-108).</assert>
      <assert id="BR-CO-16" flag="fatal" test="(exists(cbc:PrepaidAmount) and not(exists(cbc:PayableRoundingAmount)) and (xs:decimal(cbc:PayableAmount) = (round((xs:decimal(cbc:TaxInclusiveAmount) - xs:decimal(cbc:PrepaidAmount)) * 10 * 10) div 100))) or (not(exists(cbc:PrepaidAmount)) and not(exists(cbc:PayableRoundingAmount)) and xs:decimal(cbc:PayableAmount) = xs:decimal(cbc:TaxInclusiveAmount)) or (exists(cbc:PrepaidAmount) and exists(cbc:PayableRoundingAmount) and ((round((xs:decimal(cbc:PayableAmount) - xs:decimal(cbc:PayableRoundingAmount)) * 10 * 10) div 100) = (round((xs:decimal(cbc:TaxInclusiveAmount) - xs:decimal(cbc:PrepaidAmount)) * 10 * 10) div 100))) or  (not(exists(cbc:PrepaidAmount)) and exists(cbc:PayableRoundingAmount) and ((round((xs:decimal(cbc:PayableAmount) - xs:decimal(cbc:PayableRoundingAmount)) * 10 * 10) div 100) = xs:decimal(cbc:TaxInclusiveAmount)))">[BR-CO-16]-Amount due for payment (BT-115) = Invoice total amount with VAT (BT-112) -Paid amount (BT-113) +Rounding amount (BT-114).</assert>
      <assert id="BR-DEC-09" flag="fatal" test="string-length(substring-after(cbc:LineExtensionAmount,'.'))&lt;=2">[BR-DEC-09]-The allowed maximum number of decimals for the Sum of Invoice line net amount (BT-106) is 2.</assert>
      <assert id="BR-DEC-10" flag="fatal" test="string-length(substring-after(cbc:AllowanceTotalAmount,'.'))&lt;=2">[BR-DEC-10]-The allowed maximum number of decimals for the Sum of allowanced on document level (BT-107) is 2.</assert>
      <assert id="BR-DEC-11" flag="fatal" test="string-length(substring-after(cbc:ChargeTotalAmount,'.'))&lt;=2">[BR-DEC-11]-The allowed maximum number of decimals for the Sum of charges on document level (BT-108) is 2.</assert>
      <assert id="BR-DEC-12" flag="fatal" test="string-length(substring-after(cbc:TaxExclusiveAmount,'.'))&lt;=2">[BR-DEC-12]-The allowed maximum number of decimals for the Invoice total amount without VAT (BT-109) is 2.</assert>
      <assert id="BR-DEC-14" flag="fatal" test="string-length(substring-after(cbc:TaxInclusiveAmount,'.'))&lt;=2">[BR-DEC-14]-The allowed maximum number of decimals for the Invoice total amount with VAT (BT-112) is 2.</assert>
      <assert id="BR-DEC-16" flag="fatal" test="string-length(substring-after(cbc:PrepaidAmount,'.'))&lt;=2">[BR-DEC-16]-The allowed maximum number of decimals for the Paid amount (BT-113) is 2.</assert>
      <assert id="BR-DEC-17" flag="fatal" test="string-length(substring-after(cbc:PayableRoundingAmount,'.'))&lt;=2">[BR-DEC-17]-The allowed maximum number of decimals for the Rounding amount (BT-114) is 2.</assert>
      <assert id="BR-DEC-18" flag="fatal" test="string-length(substring-after(cbc:PayableAmount,'.'))&lt;=2">[BR-DEC-18]-The allowed maximum number of decimals for the Amount due for payment (BT-115) is 2.? </assert>
    </rule>
    <rule context="/ubl-invoice:Invoice | /ubl-creditnote:CreditNote">
      <assert id="BR-01" flag="fatal" test="(cbc:CustomizationID) != ''">[BR-01]-An Invoice shall have a Specification identifier (BT-24).? ?</assert>
      <assert id="BR-02" flag="fatal" test="(cbc:ID) !=''">[BR-02]-An Invoice shall have an Invoice number (BT-1).</assert>
      <assert id="BR-03" flag="fatal" test="(cbc:IssueDate) !=''">[BR-03]-An Invoice shall have an Invoice issue date (BT-2).</assert>
      <assert id="BR-04" flag="fatal" test="(cbc:InvoiceTypeCode) !='' or (cbc:CreditNoteTypeCode) !=''">[BR-04]-An Invoice shall have an Invoice type code (BT-3).</assert>
      <assert id="BR-05" flag="fatal" test="(cbc:DocumentCurrencyCode) !=''">[BR-05]-An Invoice shall have an Invoice currency code (BT-5).</assert>
      <assert id="BR-06" flag="fatal" test="(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) !=''">[BR-06]-An Invoice shall contain the Seller name (BT-27).</assert>
      <assert id="BR-07" flag="fatal" test="(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) !=''">[BR-07]-An Invoice shall contain the Buyer name (BT-44).</assert>
      <assert id="BR-08" flag="fatal" test="exists(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress)">[BR-08]-An Invoice shall contain the Seller postal address. </assert>
      <assert id="BR-10" flag="fatal" test="exists(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress)">[BR-10]-An Invoice shall contain the Buyer postal address (BG-8).</assert>
      <assert id="BR-16" flag="fatal" test="exists(cac:InvoiceLine) or exists(cac:CreditNoteLine)">[BR-16]-An Invoice shall have at least one Invoice line (BG-25)</assert>
      <assert id="BR-53" flag="fatal" test="every $taxcurrency in cbc:TaxCurrencyCode satisfies exists(//cac:TaxTotal/cbc:TaxAmount[@currencyID=$taxcurrency])">[BR-53]-If the VAT accounting currency code (BT-6) is present, then the Invoice total VAT amount in accounting currency (BT-111) shall be provided.</assert>
      <assert id="BR-66" flag="fatal" test="count(cac:PaymentMeans/cac:CardAccount) &lt;= 1">[BR-66]-An Invoice shall contain maximum one Payment Card account (BG-18).</assert>
      <assert id="BR-67" flag="fatal" test="count(cac:PaymentMeans/cac:PaymentMandate) &lt;= 1">[BR-67]-An Invoice shall contain maximum one Payment Mandate (BG-19).</assert>
      <assert id="BR-AE-01" flag="fatal" test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE']))">[BR-AE-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Reverse charge" shall contain in the VAT Breakdown (BG-23) exactly one VAT category code (BT-118) equal with "VAT reverse charge".</assert>
      <assert id="BR-AE-02" flag="fatal" test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">[BR-AE-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Reverse charge" shall contain the Seller VAT Identifier (BT-31), the Seller Tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48) and/or the Buyer legal registration identifier (BT-47).</assert>
      <assert id="BR-AE-03" flag="fatal" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">[BR-AE-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Reverse charge" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48) and/or the Buyer legal registration identifier (BT-47).</assert>
      <assert id="BR-AE-04" flag="fatal" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">[BR-AE-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Reverse charge" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48) and/or the Buyer legal registration identifier (BT-47).</assert>
      <assert id="BR-CO-03" flag="fatal" test="(exists(cbc:TaxPointDate) and not(cac:InvoicePeriod/cbc:DescriptionCode)) or (not(cbc:TaxPointDate) and exists(cac:InvoicePeriod/cbc:DescriptionCode)) or (not(cbc:TaxPointDate) and not(cac:InvoicePeriod/cbc:DescriptionCode))">[BR-CO-03]-Value added tax point date (BT-7) and Value added tax point date code (BT-8) are mutually exclusive.</assert>
      <assert id="BR-CO-15" flag="fatal" test="every $Currency in cbc:DocumentCurrencyCode satisfies (count(//cac:TaxTotal/xs:decimal(cbc:TaxAmount[@currencyID=$Currency])) eq 1) and (cac:LegalMonetaryTotal/xs:decimal(cbc:TaxInclusiveAmount) = round( (cac:LegalMonetaryTotal/xs:decimal(cbc:TaxExclusiveAmount) + cac:TaxTotal/xs:decimal(cbc:TaxAmount[@currencyID=$Currency])) * 10 * 10) div 100)">[BR-CO-15]-Invoice total amount with VAT (BT-112) = Invoice total amount without VAT (BT-109) + Invoice total VAT amount (BT-110).</assert>
      <assert id="BR-CO-18" flag="fatal" test="exists(cac:TaxTotal/cac:TaxSubtotal)">[BR-CO-18]-An Invoice shall at least have one VAT breakdown group (BG-23).</assert>
      <assert id="BR-DEC-13" flag="fatal" test="(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode] and (string-length(substring-after(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode],'.'))&lt;=2)) or (not(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode]))">[BR-DEC-13]-The allowed maximum number of decimals for the Invoice total VAT amount (BT-110) is 2.</assert>
      <assert id="BR-DEC-15" flag="fatal" test="(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode] and (string-length(substring-after(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode],'.'))&lt;=2)) or (not(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode]))">[BR-DEC-15]-The allowed maximum number of decimals for the Invoice total VAT amount in accounting currency (BT-111) is 2.</assert>
      <assert id="BR-E-01" flag="fatal" test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']))">[BR-E-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Exempt from VAT" shall contain exactly one VAT breakdown (BG-23) with the VAT category code (BT-118) equal to "Exempt from VAT".</assert>
      <assert id="BR-E-02" flag="fatal" test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">[BR-E-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Exempt from VAT" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-E-03" flag="fatal" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">[BR-E-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Exempt from VAT" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-E-04" flag="fatal" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">[BR-E-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Exempt from VAT" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-G-01" flag="fatal" test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G']))">[BR-G-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Export outside the EU" shall contain in the VAT breakdown (BG-23) exactly one VAT category code (BT-118) equal with "Export outside the EU".</assert>
      <assert id="BR-G-02" flag="fatal" test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">[BR-G-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Export outside the EU" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-G-03" flag="fatal" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='G']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">[BR-G-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Export outside the EU" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-G-04" flag="fatal" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='G']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">[BR-G-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Export outside the EU" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-IC-01" flag="fatal" test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']))">[BR-IC-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Intra-community supply" shall contain in the VAT breakdown (BG-23) exactly one VAT category code (BT-118) equal with "Intra-community supply".</assert>
      <assert id="BR-IC-02" flag="fatal" test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])">[BR-IC-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Intra-community supply" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48).</assert>
      <assert id="BR-IC-03" flag="fatal" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">[BR-IC-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Intra-community supply" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48).</assert>
      <assert id="BR-IC-04" flag="fatal" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">[BR-IC-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Intra-community supply" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48).</assert>
      <assert id="BR-IC-11" flag="fatal" test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K'])  and (string-length(cac:Delivery/cbc:ActualDeliveryDate) > 1 or (cac:InvoicePeriod/*))) or (not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']))">[BR-IC-11]-In an Invoice with a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Intra-community supply" the Actual delivery date (BT-72) or the Invoicing period (BG-14) shall not be blank.</assert>
      <assert id="BR-IC-12" flag="fatal" test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']) and (string-length(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode) >1)) or (not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']))">[BR-IC-12]-In an Invoice with a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Intra-community supply" the Deliver to country code (BT-80) shall not be blank.</assert>
      <assert id="BR-IG-01" flag="fatal" test="((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])) > 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:ID = 'L']) > 0) or ((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])) = 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0)">[BR-IG-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "IGIC" shall contain in the VAT breakdown (BG-23) at least one VAT category code (BT-118) equal with "IGIC".</assert>
      <assert id="BR-IG-02" flag="fatal" test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">[BR-IG-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "IGIC" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-IG-03" flag="fatal" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">[BR-IG-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "IGIC" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-IG-04" flag="fatal" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[cbc:ID='L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">[BR-IG-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "IGIC" shall contain the Seller VAT Identifier (BT-31), the Seller Tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-IP-01" flag="fatal" test="((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])) > 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:ID = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) > 0) or ((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])) = 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0)">[BR-IP-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "IPSI" shall contain in the VAT breakdown (BG-23) at least one VAT category code (BT-118) equal with "IPSI".</assert>
      <assert id="BR-IP-02" flag="fatal" test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">[BR-IP-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "IPSI" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-IP-03" flag="fatal" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">[BR-IP-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "IPSI" shall contain the Seller VAT Identifier (BT-31), the Seller Tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-IP-04" flag="fatal" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">[BR-IP-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "IPSI" shall contain the Seller VAT Identifier (BT-31), the Seller Tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-O-01" flag="fatal" test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']))">[BR-O-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Not subject to VAT" shall contain exactly one VAT breakdown group (BG-23) with the VAT category code (BT-118) equal to "Not subject to VAT".</assert>
      <assert id="BR-O-02" flag="fatal" test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (not(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])">[BR-O-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Not subject to VAT" shall not contain the Seller VAT identifier (BT-31), the Seller tax representative VAT identifier (BT-63) or the Buyer VAT identifier (BT-48).</assert>
      <assert id="BR-O-03" flag="fatal" test="(exists((/ubl-invoice:Invoice|/ubl-creditnote:CreditNote)/cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (not(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists((/ubl-invoice:Invoice|/ubl-creditnote:CreditNote)/cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">[BR-O-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Not subject to VAT" shall not contain the Seller VAT identifier (BT-31), the Seller tax representative VAT identifier (BT-63) or the Buyer VAT identifier (BT-48).</assert>
      <assert id="BR-O-04" flag="fatal" test="(exists((/ubl-invoice:Invoice|/ubl-creditnote:CreditNote)/cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (not(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists((/ubl-invoice:Invoice|/ubl-creditnote:CreditNote)/cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">[BR-O-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Not subject to VAT" shall not contain the Seller VAT identifier (BT-31), the Seller tax representative VAT identifier (BT-63) or the Buyer VAT identifier (BT-48).</assert>
      <assert id="BR-O-11" flag="fatal" test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])">[BR-O-11]-An Invoice that contains a VAT breakdown group (BG-23) with a VAT category code (BT-118) "Not subject to VAT" shall not contain other VAT breakdown groups (BG-23).</assert>
      <assert id="BR-O-12" flag="fatal" test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])">[BR-O-12]-An Invoice that contains a VAT breakdown group (BG-23) with a VAT category code (BT-118) "Not subject to VAT" shall not contain an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is not "Not subject to VAT".</assert>
      <assert id="BR-O-13" flag="fatal" test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and count(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])">[BR-O-13]-An Invoice that contains a VAT breakdown group (BG-23) with a VAT category code (BT-118) "Not subject to VAT" shall not contain Document level allowances (BG-20) where Document level allowance VAT category code (BT-95) is not "Not subject to VAT".</assert>
      <assert id="BR-O-14" flag="fatal" test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and count(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])">[BR-O-14]-An Invoice that contains a VAT breakdown group (BG-23) with a VAT category code (BT-118) "Not subject to VAT" shall not contain Document level charges (BG-21) where Document level charge VAT category code (BT-102) is not "Not subject to VAT".</assert>
      <assert id="BR-S-01" flag="fatal" test="((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'])) > 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) > 0) or ((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'])) = 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) = 0)">[BR-S-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Standard rated" shall contain in the VAT breakdown (BG-23) at least one VAT category code (BT-118) equal with "Standard rated".</assert>
      <assert id="BR-S-02" flag="fatal" test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S']))">[BR-S-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Standard rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-S-03" flag="fatal" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">[BR-S-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Standard rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-S-04" flag="fatal" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">[BR-S-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Standard rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-Z-01" flag="fatal" test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']))">[BR-Z-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Zero rated" shall contain in the VAT breakdown (BG-23) exactly one VAT category code (BT-118) equal with "Zero rated".</assert>
      <assert id="BR-Z-02" flag="fatal" test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">[BR-Z-02]-An Invoice that contains an Invoice line where the Invoiced item VAT category code (BT-151) is "Zero rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-Z-03" flag="fatal" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">[BR-Z-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Zero rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-Z-04" flag="fatal" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID)or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">[BR-Z-04]-An Invoice that contains a Document level charge where the Document level charge VAT category code (BT-102) is "Zero rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-B-01" flag="fatal" test="(not(//cbc:IdentificationCode != 'IT') and (//cac:TaxCategory/cbc:ID ='B' or //cac:ClassifiedTaxCategory/cbc:ID = 'B')) or (not(//cac:TaxCategory/cbc:ID ='B' or //cac:ClassifiedTaxCategory/cbc:ID = 'B'))">[BR-B-01]-An Invoice where the VAT category code (BT-151, BT-95 or BT-102) is “Split payment” shall be a domestic Italian invoice.</assert>
      <assert id="BR-B-02" flag="fatal" test="((//cac:TaxCategory/cbc:ID ='B' or //cac:ClassifiedTaxCategory/cbc:ID = 'B') and (not(//cac:TaxCategory/cbc:ID ='S' or //cac:ClassifiedTaxCategory/cbc:ID = 'S'))) or (not(//cac:TaxCategory/cbc:ID ='B' or //cac:ClassifiedTaxCategory/cbc:ID = 'B'))">[BR-B-02]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is “Split payment" shall not contain an invoice line (BG-25), a Document level allowance (BG-20) or  a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is “Standard rated”.</assert>
    </rule>
    <rule context="cac:InvoiceLine | cac:CreditNoteLine">
      <assert id="BR-21" flag="fatal" test="(cbc:ID) != ''">[BR-21]-Each Invoice line (BG-25) shall have an Invoice line identifier (BT-126).</assert>
      <assert id="BR-22" flag="fatal" test="exists(cbc:InvoicedQuantity) or exists(cbc:CreditedQuantity)">[BR-22]-Each Invoice line (BG-25) shall have an Invoiced quantity (BT-129).</assert>
      <assert id="BR-23" flag="fatal" test="exists(cbc:InvoicedQuantity/@unitCode) or exists(cbc:CreditedQuantity/@unitCode)">[BR-23]-An Invoice line (BG-25) shall have an Invoiced quantity unit of measure code (BT-130).</assert>
      <assert id="BR-24" flag="fatal" test="exists(cbc:LineExtensionAmount)">[BR-24]-Each Invoice line (BG-25) shall have an Invoice line net amount (BT-131).</assert>
      <assert id="BR-25" flag="fatal" test="(cac:Item/cbc:Name) != ''">[BR-25]-Each Invoice line (BG-25) shall contain the Item name (BT-153).</assert>
      <assert id="BR-26" flag="fatal" test="exists(cac:Price/cbc:PriceAmount)">[BR-26]-Each Invoice line (BG-25) shall contain the Item net price (BT-146).</assert>
      <assert id="BR-27" flag="fatal" test="(cac:Price/cbc:PriceAmount) >= 0">[BR-27]-The Item net price (BT-146) shall NOT be negative.</assert>
      <assert id="BR-28" flag="fatal" test="(cac:Price/cac:AllowanceCharge/cbc:BaseAmount) >= 0 or not(exists(cac:Price/cac:AllowanceCharge/cbc:BaseAmount))">[BR-28]-The Item gross price (BT-148) shall NOT be negative.</assert>
      <assert id="BR-CO-04" flag="fatal" test="(cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/(normalize-space(upper-case(cbc:ID))='VAT')]/cbc:ID)">[BR-CO-04]-Each Invoice line (BG-25) shall be categorized with an Invoiced item VAT category code (BT-151).</assert>
      <assert id="BR-DEC-23" flag="fatal" test="string-length(substring-after(cbc:LineExtensionAmount,'.'))&lt;=2">[BR-DEC-23]-The allowed maximum number of decimals for the Invoice line net amount (BT-131) is 2.</assert>
    </rule>
    <rule context="//cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | //cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()]">
      <assert id="BR-41" flag="fatal" test="exists(cbc:Amount)">[BR-41]-Each Invoice line allowance (BG-27) shall have an Invoice line allowance amount (BT-136).</assert>
      <assert id="BR-42" flag="fatal" test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)">[BR-42]-Each Invoice line allowance (BG-27) shall have an Invoice line allowance reason (BT-139) or an Invoice line allowance reason code (BT-140).</assert>
      <assert id="BR-CO-07" flag="fatal" test="true()">[BR-CO-07]-Invoice line allowance reason code (BT-140) and Invoice line allowance reason (BT-139) shall indicate the same type of allowance reason.</assert>
      <assert id="BR-CO-23" flag="fatal" test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)">[BR-CO-23]-Each Invoice line allowance (BG-27) shall contain an Invoice line allowance reason (BT-139) or an Invoice line allowance reason code (BT-140), or both.</assert>
      <assert id="BR-DEC-24" flag="fatal" test="string-length(substring-after(cbc:Amount,'.'))&lt;=2">[BR-DEC-24]-The allowed maximum number of decimals for the Invoice line allowance amount (BT-136) is 2.</assert>
      <assert id="BR-DEC-25" flag="fatal" test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2">[BR-DEC-25]-The allowed maximum number of decimals for the Invoice line allowance base amount (BT-137) is 2.</assert>
    </rule>
    <rule context="//cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = true()] | //cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = true()]">
      <assert id="BR-43" flag="fatal" test="exists(cbc:Amount)">[BR-43]-Each Invoice line charge (BG-28) shall have an Invoice line charge amount (BT-141).</assert>
      <assert id="BR-44" flag="fatal" test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)">[BR-44]-Each Invoice line charge shall have an Invoice line charge reason or an invoice line allowance reason code. </assert>
      <assert id="BR-CO-08" flag="fatal" test="true()">[BR-CO-08]-Invoice line charge reason code (BT-145) and Invoice line charge reason (BT-144) shall indicate the same type of charge reason.</assert>
      <assert id="BR-CO-24" flag="fatal" test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)">[BR-CO-24]-Each Invoice line charge (BG-28) shall contain an Invoice line charge reason (BT-144) or an Invoice line charge reason code (BT-145), or both.</assert>
      <assert id="BR-DEC-27" flag="fatal" test="string-length(substring-after(cbc:Amount,'.'))&lt;=2">[BR-DEC-27]-The allowed maximum number of decimals for the Invoice line charge amount (BT-141) is 2.</assert>
      <assert id="BR-DEC-28" flag="fatal" test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2">[BR-DEC-28]-The allowed maximum number of decimals for the Invoice line charge base amount (BT-142) is 2.</assert>
    </rule>
    <rule context="cac:InvoiceLine/cac:InvoicePeriod | cac:CreditNoteLine/cac:InvoicePeriod">
      <assert id="BR-30" flag="fatal" test="(exists(cbc:EndDate) and exists(cbc:StartDate) and xs:date(cbc:EndDate) >= xs:date(cbc:StartDate)) or not(exists(cbc:StartDate)) or not(exists(cbc:EndDate))">[BR-30]-If both Invoice line period start date (BT-134) and Invoice line period end date (BT-135) are given then the Invoice line period end date (BT-135) shall be later or equal to the Invoice line period start date (BT-134).</assert>
      <assert id="BR-CO-20" flag="fatal" test="exists(cbc:StartDate) or exists(cbc:EndDate)">[BR-CO-20]-If Invoice line period (BG-26) is used, the Invoice line period start date (BT-134) or the Invoice line period end date (BT-135) shall be filled, or both.</assert>
    </rule>
    <rule context="cac:InvoicePeriod">
      <assert id="BR-29" flag="fatal" test="(exists(cbc:EndDate) and exists(cbc:StartDate) and xs:date(cbc:EndDate) >= xs:date(cbc:StartDate)) or not(exists(cbc:StartDate)) or not(exists(cbc:EndDate))">[BR-29]-If both Invoicing period start date (BT-73) and Invoicing period end date (BT-74) are given then the Invoicing period end date (BT-74) shall be later or equal to the Invoicing period start date (BT-73).</assert>
      <assert id="BR-CO-19" flag="fatal" test="exists(cbc:StartDate) or exists(cbc:EndDate) or (exists(cbc:DescriptionCode) and not(exists(cbc:StartDate)) and not(exists(cbc:EndDate)))">[BR-CO-19]-If Invoicing period (BG-14) is used, the Invoicing period start date (BT-73) or the Invoicing period end date (BT-74) shall be filled, or both.</assert>
    </rule>
    <rule context="//cac:AdditionalItemProperty">
      <assert id="BR-54" flag="fatal" test="exists(cbc:Name) and exists(cbc:Value)">[BR-54]-Each Item attribute (BG-32) shall contain an Item attribute name (BT-160) and an Item attribute value (BT-161).</assert>
    </rule>
    <rule context="cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode | cac:CreditNoteLine/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode">
      <assert id="BR-65" flag="fatal" test="exists(@listID)">[BR-65]-The Item classification identifier (BT-158) shall have a Scheme identifier.</assert>
    </rule>
    <rule context="cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:ID | cac:CreditNoteLine/cac:Item/cac:StandardItemIdentification/cbc:ID">
      <assert id="BR-64" flag="fatal" test="exists(@schemeID)">[BR-64]-The Item standard identifier (BT-157) shall have a Scheme identifier.</assert>
    </rule>
    <rule context="/ubl-invoice:Invoice/cbc:Note | /ubl-creditnote:CreditNote/cbc:Note">
      <assert id="BR-CL-08" flag="fatal" test="(contains(.,'#') and string-length(substring-before(substring-after(.,'#'),'#'))=3 and ( ( contains(' AAA AAB AAC AAD AAE AAF AAG AAI AAJ AAK AAL AAM AAN AAO AAP AAQ AAR AAS AAT AAU AAV AAW AAX AAY AAZ ABA ABB ABC ABD ABE ABF ABG ABH ABI ABJ ABK ABL ABM ABN ABO ABP ABQ ABR ABS ABT ABU ABV ABW ABX ABZ ACA ACB ACC ACD ACE ACF ACG ACH ACI ACJ ACK ACL ACM ACN ACO ACP ACQ ACR ACS ACT ACU ACV ACW ACX ACY ACZ ADA ADB ADC ADD ADE ADF ADG ADH ADI ADJ ADK ADL ADM ADN ADO ADP ADQ ADR ADS ADT ADU ADV ADW ADX ADY ADZ AEA AEB AEC AED AEE AEF AEG AEH AEI AEJ AEK AEL AEM AEN AEO AEP AEQ AER AES AET AEU AEV AEW AEX AEY AEZ AFA AFB AFC AFD AFE AFF AFG AFH AFI AFJ AFK AFL AFM AFN AFO AFP AFQ AFR AFS AFT AFU AFV AFW AFX AFY AFZ AGA AGB AGC AGD AGE AGF AGG AGH AGI AGJ AGK AGL AGM AGN AGO AGP AGQ AGR AGS AGT AGU AGV AGW AGX AGY AGZ AHA AHB AHC AHD AHE AHF AHG AHH AHI AHJ AHK AHL AHM AHN AHO AHP AHQ AHR AHS AHT AHU AHV AHW AHX AHY AHZ AIA AIB AIC AID AIE AIF AIG AIH AII AIJ AIK AIL AIM AIN AIO AIP AIQ AIR AIS AIT AIU AIV AIW AIX AIY AIZ AJA AJB ALC ALD ALE ALF ALG ALH ALI ALJ ALK ALL ALM ALN ALO ALP ALQ ARR ARS AUT AUU AUV AUW AUX AUY AUZ AVA AVB AVC AVD AVE AVF BAG BAH BAI BAJ BAK BAL BAM BAN BAO BAP BAQ BAR BAS BLC BLD BLE BLF BLG BLH BLI BLJ BLK BLL BLM BLN BLO BLP BLQ BLR BLS BLT BLU BLV BLW BLX BLY BLZ BMA BMB BMC BMD BME CCI CEX CHG CIP CLP CLR COI CUR CUS DAR DCL DEL DIN DOC DUT EUR FBC GBL GEN GS7 HAN HAZ ICN IIN IMI IND INS INV IRP ITR ITS LAN LIN LOI MCO MDH MKS ORI OSI PAC PAI PAY PKG PKT PMD PMT PRD PRF PRI PUR QIN QQD QUT RAH REG RET REV RQR SAF SIC SIN SLR SPA SPG SPH SPP SPT SRN SSR SUR TCA TDT TRA TRR TXD WHI ZZZ ',substring-before(substring-after(.,'#'),'#') ) ) )) or not(contains(.,'#')) or not(string-length(substring-before(substring-after(.,'#'),'#'))=3)">[BR-CL-08]-Invoiced note subject code shall be coded using UNCL4451</assert>
    </rule>
    <rule context="cac:PayeeParty">
      <assert id="BR-17" flag="fatal" test="exists(cac:PartyName/cbc:Name) and (not(cac:PartyName/cbc:Name = ../cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name) and not(cac:PartyIdentification/cbc:ID = ../cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID) )">[BR-17]-The Payee name (BT-59) shall be provided in the Invoice, if the Payee (BG-10) is different from the Seller (BG-4)</assert>
    </rule>
    <rule context="cac:PaymentMeans[cbc:PaymentMeansCode='30' or cbc:PaymentMeansCode='58']/cac:PayeeFinancialAccount">
      <assert id="BR-50" flag="fatal" test="(cbc:ID) != ''">[BR-50]-A Payment account identifier (BT-84) shall be present if Credit transfer (BG-17) information is provided in the Invoice.</assert>
    </rule>
    <rule context="cac:PaymentMeans">
      <assert id="BR-49" flag="fatal" test="exists(cbc:PaymentMeansCode)">[BR-49]-A Payment instruction (BG-16) shall specify the Payment means type code (BT-81).</assert>
      <assert id="BR-61" flag="fatal" test="(exists(cac:PayeeFinancialAccount/cbc:ID) and ((normalize-space(cbc:PaymentMeansCode) = '30') or (normalize-space(cbc:PaymentMeansCode) = '58') )) or ((normalize-space(cbc:PaymentMeansCode) != '30') and (normalize-space(cbc:PaymentMeansCode) != '58'))">[BR-61]-If the Payment means type code (BT-81) means SEPA credit transfer, Local credit transfer or Non-SEPA international credit transfer, the Payment account identifier (BT-84) shall be present.</assert>
    </rule>
    <rule context="cac:BillingReference">
      <assert id="BR-55" flag="fatal" test="exists(cac:InvoiceDocumentReference/cbc:ID)">[BR-55]-Each Preceding Invoice reference (BG-3) shall contain a Preceding Invoice reference (BT-25).</assert>
    </rule>
    <rule context="cac:AccountingSupplierParty">
      <assert id="BR-CO-26" flag="fatal" test="exists(cac:Party/cac:PartyTaxScheme[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:CompanyID) or exists(cac:Party/cac:PartyIdentification/cbc:ID) or exists(cac:Party/cac:PartyLegalEntity/cbc:CompanyID)">[BR-CO-26]-In order for the buyer to automatically identify a supplier, the Seller identifier (BT-29), the Seller legal registration identifier (BT-30) and/or the Seller VAT identifier (BT-31) shall be present.? </assert>
    </rule>
    <rule context="cac:AccountingSupplierParty/cac:Party/cbc:EndpointID">
      <assert id="BR-62" flag="fatal" test="exists(@schemeID)">[BR-62]-The Seller electronic address (BT-34) shall have a Scheme identifier.</assert>
    </rule>
    <rule context="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress">
      <assert id="BR-09" flag="fatal" test="(cac:Country/cbc:IdentificationCode) != ''">[BR-09]-The Seller postal address (BG-5) shall contain a Seller country code (BT-40).</assert>
    </rule>
    <rule context="cac:TaxRepresentativeParty">
      <assert id="BR-18" flag="fatal" test="(cac:PartyName/cbc:Name) != ''">[BR-18]-The Seller tax representative name (BT-62) shall be provided in the Invoice, if the Seller (BG-4) has a Seller tax representative party (BG-11)</assert>
      <assert id="BR-19" flag="fatal" test="exists(cac:PostalAddress)">[BR-19]-The Seller tax representative postal address (BG-12) shall be provided in the Invoice, if the Seller (BG-4) has a Seller tax representative party (BG-11).</assert>
      <assert id="BR-56" flag="fatal" test="exists(cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)">[BR-56]-Each Seller tax representative party (BG-11) shall have a Seller tax representative VAT identifier (BT-63).</assert>
    </rule>
    <rule context="cac:TaxRepresentativeParty/cac:PostalAddress">
      <assert id="BR-20" flag="fatal" test="(cac:Country/cbc:IdentificationCode) != ''">[BR-20]-The Seller tax representative postal address (BG-12) shall contain a Tax representative country code (BT-69), if the Seller (BG-4) has a Seller tax representative party (BG-11).</assert>
    </rule>
    <rule context="/ubl-invoice:Invoice/cac:TaxTotal | /ubl-creditnote:CreditNote/cac:TaxTotal">
      <assert id="BR-CO-14" flag="fatal" test="(xs:decimal(child::cbc:TaxAmount)= round((sum(cac:TaxSubtotal/xs:decimal(cbc:TaxAmount)) * 10 * 10)) div 100) or not(cac:TaxSubtotal)">[BR-CO-14]-Invoice total VAT amount (BT-110) = Σ VAT category tax amount (BT-117).</assert>
    </rule>
    <rule context="cac:TaxTotal/cac:TaxSubtotal">
      <assert id="BR-45" flag="fatal" test="exists(cbc:TaxableAmount)">[BR-45]-Each VAT breakdown (BG-23) shall have a VAT category taxable amount (BT-116).</assert>
      <assert id="BR-46" flag="fatal" test="exists(cbc:TaxAmount)">[BR-46]-Each VAT breakdown (BG-23) shall have a VAT category tax amount (BT-117).</assert>
      <assert id="BR-47" flag="fatal" test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID)">[BR-47]-Each VAT breakdown (BG-23) shall be defined through a VAT category code (BT-118).</assert>
      <assert id="BR-48" flag="fatal" test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:Percent) or (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/normalize-space(cbc:ID)='O')">[BR-48]-Each VAT breakdown (BG-23) shall have a VAT category rate (BT-119), except if the Invoice is not subject to VAT.</assert>
      <assert id="BR-CO-17" flag="fatal" test="(round(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent)) = 0 and (round(xs:decimal(cbc:TaxAmount)) = 0)) or (round(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent)) != 0 and ((abs(xs:decimal(cbc:TaxAmount)) - 1 &lt; round(abs(xs:decimal(cbc:TaxableAmount)) * (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) div 100) * 10 * 10) div 100 ) and (abs(xs:decimal(cbc:TaxAmount)) + 1 > round(abs(xs:decimal(cbc:TaxableAmount)) * (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) div 100) * 10 * 10) div 100 )))  or (not(exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent))) and (round(xs:decimal(cbc:TaxAmount)) = 0))">[BR-CO-17]-VAT category tax amount (BT-117) = VAT category taxable amount (BT-116) x (VAT category rate (BT-119) / 100), rounded to two decimals.</assert>
      <assert id="BR-DEC-19" flag="fatal" test="string-length(substring-after(cbc:TaxableAmount,'.'))&lt;=2">[BR-DEC-19]-The allowed maximum number of decimals for the VAT category taxable amount (BT-116) is 2.</assert>
      <assert id="BR-DEC-20" flag="fatal" test="string-length(substring-after(cbc:TaxAmount,'.'))&lt;=2">[BR-DEC-20]-The allowed maximum number of decimals for the VAT category tax amount (BT-117) is 2. ? ?</assert>
    </rule>
    <rule context="//cac:PartyTaxScheme[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-CO-09" flag="fatal" test="( contains( ' 1A AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH EL ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI YE YT ZA ZM ZW ',substring(cbc:CompanyID,1,2) ) )">[BR-CO-09]-The Seller VAT identifier (BT-31), the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48) shall have a prefix in accordance with ISO code ISO 3166-1 alpha-2 by which the country of issue may be identified. Nevertheless, Greece may use the prefix ‘EL’.</assert>
    </rule>
    <rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-AE-08" flag="fatal" test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:Amount)))))">[BR-AE-08]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Reverse charge" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Reverse charge".</assert>
      <assert id="BR-AE-09" flag="fatal" test="xs:decimal(../cbc:TaxAmount) = 0">[BR-AE-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Reverse charge" shall be 0 (zero).</assert>
      <assert id="BR-AE-10" flag="fatal" test="exists(cbc:TaxExemptionReason) or (exists(cbc:TaxExemptionReasonCode) )">[BR-AE-10]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "Reverse charge" shall have a VAT exemption reason code (BT-121), meaning "Reverse charge" or the VAT exemption reason text (BT-120) "Reverse charge" (or the equivalent standard text in another language).</assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-AE-06" flag="fatal" test="(xs:decimal(cbc:Percent) = 0)">[BR-AE-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Reverse charge" the Document level allowance VAT rate (BT-96) shall be 0 (zero).</assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-AE-07" flag="fatal" test="(xs:decimal(cbc:Percent) = 0)">[BR-AE-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Reverse charge" the Document level charge VAT rate (BT-103) shall be 0 (zero).</assert>
    </rule>
    <rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-AE-05" flag="fatal" test="(xs:decimal(cbc:Percent) = 0)">[BR-AE-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Reverse charge" the Invoiced item VAT rate (BT-152) shall be 0 (zero).</assert>
    </rule>
    <rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-E-08" flag="fatal" test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)))))">[BR-E-08]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Exempt from VAT" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Exempt from VAT".</assert>
      <assert id="BR-E-09" flag="fatal" test="xs:decimal(../cbc:TaxAmount) = 0">[BR-E-09]-The VAT category tax amount (BT-117) In a VAT breakdown (BG-23) where the VAT category code (BT-118) equals "Exempt from VAT" shall equal 0 (zero).</assert>
      <assert id="BR-E-10" flag="fatal" test="exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode)">[BR-E-10]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "Exempt from VAT" shall have a VAT exemption reason code (BT-121) or a VAT exemption reason text (BT-120).</assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-E-06" flag="fatal" test="(xs:decimal(cbc:Percent) = 0)">[BR-E-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Exempt from VAT", the Document level allowance VAT rate (BT-96) shall be 0 (zero).</assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-E-07" flag="fatal" test="(xs:decimal(cbc:Percent) = 0)">[BR-E-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Exempt from VAT", the Document level charge VAT rate (BT-103) shall be 0 (zero).</assert>
    </rule>
    <rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-E-05" flag="fatal" test="(xs:decimal(cbc:Percent) = 0)">[BR-E-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Exempt from VAT", the Invoiced item VAT rate (BT-152) shall be 0 (zero).</assert>
    </rule>
    <rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-G-08" flag="fatal" test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:Amount)))))">[BR-G-08]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Export outside the EU" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Export outside the EU".</assert>
      <assert id="BR-G-09" flag="fatal" test="xs:decimal(../cbc:TaxAmount) = 0">[BR-G-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Export outside the EU" shall be 0 (zero).</assert>
      <assert id="BR-G-10" flag="fatal" test="exists(cbc:TaxExemptionReason) or (exists(cbc:TaxExemptionReasonCode) )">[BR-G-10]-A VAT breakdown (BG-23) with the VAT Category code (BT-118) "Export outside the EU" shall have a VAT exemption reason code (BT-121), meaning "Export outside the EU" or the VAT exemption reason text (BT-120) "Export outside the EU" (or the equivalent standard text in another language).</assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-G-06" flag="fatal" test="(xs:decimal(cbc:Percent) = 0)">[BR-G-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Export outside the EU" the Document level allowance VAT rate (BT-96) shall be 0 (zero).</assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-G-07" flag="fatal" test="(xs:decimal(cbc:Percent) = 0)">[BR-G-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Export outside the EU" the Document level charge VAT rate (BT-103) shall be 0 (zero).</assert>
    </rule>
    <rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-G-05" flag="fatal" test="(xs:decimal(cbc:Percent) = 0)">[BR-G-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Export outside the EU" the Invoiced item VAT rate (BT-152) shall be 0 (zero).</assert>
    </rule>
    <rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-IC-08" flag="fatal" test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:Amount)))))">[BR-IC-08]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Intra-community supply" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Intra-community supply".</assert>
      <assert id="BR-IC-09" flag="fatal" test="xs:decimal(../cbc:TaxAmount) = 0">[BR-IC-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Intra-community supply" shall be 0 (zero).</assert>
      <assert id="BR-IC-10" flag="fatal" test="exists(cbc:TaxExemptionReason) or (exists(cbc:TaxExemptionReasonCode) )">[BR-IC-10]-A VAT breakdown (BG-23) with the VAT Category code (BT-118) "Intra-community supply" shall have a VAT exemption reason code (BT-121), meaning "Intra-community supply" or the VAT exemption reason text (BT-120) "Intra-community supply" (or the equivalent standard text in another language).</assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-IC-06" flag="fatal" test="(xs:decimal(cbc:Percent) = 0)">[BR-IC-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Intra-community supply" the Document level allowance VAT rate (BT-96) shall be 0 (zero).</assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-IC-07" flag="fatal" test="(xs:decimal(cbc:Percent) = 0)">[BR-IC-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Intra-community supply" the Document level charge VAT rate (BT-103) shall be 0 (zero).</assert>
    </rule>
    <rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-IC-05" flag="fatal" test="(xs:decimal(cbc:Percent) = 0)">[BR-IC-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Intracommunity supply" the Invoiced item VAT rate (BT-152) shall be 0 (zero).</assert>
    </rule>
    <rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-IG-08" flag="fatal" test="every $rate in xs:decimal(cbc:Percent) satisfies ((exists(//cac:InvoiceLine) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))) or (exists(//cac:CreditNoteLine) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))))">[BR-IG-08]-For each different value of VAT category rate (BT-119) where the VAT category code (BT-118) is "IGIC", the VAT category taxable amount (BT-116) in a VAT breakdown (BG-23) shall equal the sum of Invoice line net amounts (BT-131) plus the sum of document level charge amounts (BT-99) minus the sum of document level allowance amounts (BT-92) where the VAT category code (BT-151, BT-102, BT-95) is "IGIC" and the VAT rate (BT-152, BT-103, BT-96) equals the VAT category rate (BT-119).</assert>
      <assert id="BR-IG-09" flag="fatal" test="(abs(xs:decimal(../cbc:TaxAmount)) - 1 &lt;  round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 ) and (abs(xs:decimal(../cbc:TaxAmount)) + 1 >  round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 )">[BR-IG-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "IGIC" shall equal the VAT category taxable amount (BT-116) multiplied by the VAT category rate (BT-119).</assert>
      <assert id="BR-IG-10" flag="fatal" test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)">[BR-IG-10]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "IGIC" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).</assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-IG-06" flag="fatal" test="(cbc:Percent) >= 0">[BR-IG-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "IGIC" the Document level allowance VAT rate (BT-96) shall be 0 (zero) or greater than zero.</assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-IG-07" flag="fatal" test="(cbc:Percent) >= 0">[BR-IG-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "IGIC" the Document level charge VAT rate (BT-103) shall be 0 (zero) or greater than zero.</assert>
    </rule>
    <rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']| cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-IG-05" flag="fatal" test="(cbc:Percent) >= 0">[BR-IG-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "IGIC" the invoiced item VAT rate (BT-152) shall be 0 (zero) or greater than zero.</assert>
    </rule>
    <rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-IP-08" flag="fatal" test="every $rate in xs:decimal(cbc:Percent) satisfies ((exists(//cac:InvoiceLine) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))) or (exists(//cac:CreditNoteLine) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))))">[BR-IP-08]-For each different value of VAT category rate (BT-119) where the VAT category code (BT-118) is "IPSI", the VAT category taxable amount (BT-116) in a VAT breakdown (BG-23) shall equal the sum of Invoice line net amounts (BT-131) plus the sum of document level charge amounts (BT-99) minus the sum of document level allowance amounts (BT-92) where the VAT category code (BT-151, BT-102, BT-95) is "IPSI" and the VAT rate (BT-152, BT-103, BT-96) equals the VAT category rate (BT-119).</assert>
      <assert id="BR-IP-09" flag="fatal" test="(abs(xs:decimal(../cbc:TaxAmount)) - 1 &lt;  round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 ) and (abs(xs:decimal(../cbc:TaxAmount)) + 1 >  round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 )">[BR-IP-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "IPSI" shall equal the VAT category taxable amount (BT-116) multiplied by the VAT category rate (BT-119).</assert>
      <assert id="BR-IP-10" flag="fatal" test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)">[BR-IP-10]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "IPSI" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).</assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-IP-06" flag="fatal" test="(cbc:Percent) >= 0">[BR-IP-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "IPSI" the Document level allowance VAT rate (BT-96) shall be 0 (zero) or greater than zero.</assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-IP-07" flag="fatal" test="(cbc:Percent) >= 0">[BR-IP-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "IPSI" the Document level charge VAT rate (BT-103) shall be 0 (zero) or greater than zero.</assert>
    </rule>
    <rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']| cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-IP-05" flag="fatal" test="(cbc:Percent) >= 0">[BR-IP-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "IPSI" the Invoiced item VAT rate (BT-152) shall be 0 (zero) or greater than zero.</assert>
    </rule>
    <rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-O-08" flag="fatal" test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)))))">[BR-O-08]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is " Not subject to VAT" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Not subject to VAT".</assert>
      <assert id="BR-O-09" flag="fatal" test="xs:decimal(../cbc:TaxAmount) = 0">[BR-O-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Not subject to VAT" shall be 0 (zero).</assert>
      <assert id="BR-O-10" flag="fatal" test="exists(cbc:TaxExemptionReason) or (exists(cbc:TaxExemptionReasonCode) )">[BR-O-10]-A VAT breakdown (BG-23) with VAT Category code (BT-118) " Not subject to VAT" shall have a VAT exemption reason code (BT-121), meaning " Not subject to VAT" or a VAT exemption reason text (BT-120) " Not subject to VAT" (or the equivalent standard text in another language).</assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-O-06" flag="fatal" test="not(cbc:Percent)">[BR-O-06]-A Document level allowance (BG-20) where VAT category code (BT-95) is "Not subject to VAT" shall not contain a Document level allowance VAT rate (BT-96).</assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-O-07" flag="fatal" test="not(cbc:Percent)">[BR-O-07]-A Document level charge (BG-21) where the VAT category code (BT-102) is "Not subject to VAT" shall not contain a Document level charge VAT rate (BT-103).</assert>
    </rule>
    <rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-O-05" flag="fatal" test="not(cbc:Percent)">[BR-O-05]-An Invoice line (BG-25) where the VAT category code (BT-151) is "Not subject to VAT" shall not contain an Invoiced item VAT rate (BT-152).</assert>
    </rule>
    <rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-S-08" flag="fatal" test="every $rate in xs:decimal(cbc:Percent) satisfies (((exists(//cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate])) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))) or (exists(//cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate])) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))))))">[BR-S-08]-For each different value of VAT category rate (BT-119) where the VAT category code (BT-118) is "Standard rated", the VAT category taxable amount (BT-116) in a VAT breakdown (BG-23) shall equal the sum of Invoice line net amounts (BT-131) plus the sum of document level charge amounts (BT-99) minus the sum of document level allowance amounts (BT-92) where the VAT category code (BT-151, BT-102, BT-95) is "Standard rated" and the VAT rate (BT-152, BT-103, BT-96) equals the VAT category rate (BT-119).</assert>
      <assert id="BR-S-09" flag="fatal" test="(abs(xs:decimal(../cbc:TaxAmount)) - 1 &lt;  round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 ) and (abs(xs:decimal(../cbc:TaxAmount)) + 1 >  round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 )">[BR-S-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "Standard rated" shall equal the VAT category taxable amount (BT-116) multiplied by the VAT category rate (BT-119).</assert>
      <assert id="BR-S-10" flag="fatal" test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)">[BR-S-10]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "Standard rate" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).</assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-S-06" flag="fatal" test="(cbc:Percent) > 0">[BR-S-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Standard rated" the Document level allowance VAT rate (BT-96) shall be greater than zero.</assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-S-07" flag="fatal" test="(cbc:Percent) > 0">[BR-S-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Standard rated" the Document level charge VAT rate (BT-103) shall be greater than zero.? </assert>
    </rule>
    <rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-S-05" flag="fatal" test="(cbc:Percent) > 0">[BR-S-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Standard rated" the Invoiced item VAT rate (BT-152) shall be greater than zero.</assert>
    </rule>
    <rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-Z-08" flag="fatal" test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount)))))">[BR-Z-08]-In a VAT breakdown (BG-23) where VAT category code (BT-118) is "Zero rated" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amount (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Zero rated".</assert>
      <assert id="BR-Z-09" flag="fatal" test="xs:decimal(../cbc:TaxAmount) = 0">[BR-Z-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "Zero rated" shall equal 0 (zero).</assert>
      <assert id="BR-Z-10" flag="fatal" test="not((cbc:TaxExemptionReason) or (cbc:TaxExemptionReasonCode))">[BR-Z-10]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "Zero rated" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).</assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-Z-06" flag="fatal" test="(xs:decimal(cbc:Percent) = 0)">[BR-Z-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Zero rated" the Document level allowance VAT rate (BT-96) shall be 0 (zero).</assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-Z-07" flag="fatal" test="(xs:decimal(cbc:Percent) = 0)">[BR-Z-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Zero rated" the Document level charge VAT rate (BT-103) shall be 0 (zero).</assert>
    </rule>
    <rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-Z-05" flag="fatal" test="(xs:decimal(cbc:Percent) = 0)">[BR-Z-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Zero rated" the Invoiced item VAT rate (BT-152) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern id="UBL-syntax">
    <rule context="cac:AccountingSupplierParty/cac:Party">
      <assert id="UBL-SR-42" flag="fatal" test="(count(cac:PartyTaxScheme) &lt;= 2)">[UBL-SR-42]-Party tax scheme shall occur maximum twice in accounting supplier party</assert>
    </rule>
    <rule context="cac:AdditionalDocumentReference">
      <assert id="UBL-SR-33" flag="fatal" test="(count(cbc:DocumentDescription) &lt;= 1)">[UBL-SR-33]-Supporting document description shall occur maximum once</assert>
      <assert id="UBL-SR-43" flag="fatal" test="((cbc:DocumentTypeCode='130') or ((local-name(/*) = 'CreditNote') and (cbc:DocumentTypeCode='50')) or (not(cbc:ID/@scheme) and not(cbc:DocumentTypeCode)))">[UBL-SR-43]-Scheme identifier shall only be used for invoiced object (document type code with value 130)</assert>
    </rule>
    <rule context="//*[ends-with(name(), 'Amount') and not(ends-with(name(),'PriceAmount')) and not(ancestor::cac:Price/cac:AllowanceCharge)]">
      <assert id="UBL-DT-01" flag="fatal" test="string-length(substring-after(.,'.'))&lt;=2">[UBL-DT-01]-Amounts shall be decimal up to two fraction digits</assert>
    </rule>
    <rule context="//*[ends-with(name(), 'BinaryObject')]">
      <assert id="UBL-DT-06" flag="fatal" test="(@mimeCode)">[UBL-DT-06]-Binary object elements shall contain the mime code attribute</assert>
      <assert id="UBL-DT-07" flag="fatal" test="(@filename)">[UBL-DT-07]-Binary object elements shall contain the file name attribute</assert>
    </rule>
    <rule context="cac:Delivery">
      <assert id="UBL-SR-25" flag="fatal" test="(count(cac:DeliveryParty/cac:PartyName/cbc:Name) &lt;= 1)">[UBL-SR-25]-Deliver to party name shall occur maximum once</assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator = false()]">
      <assert id="UBL-SR-30" flag="fatal" test="(count(cbc:AllowanceChargeReason) &lt;= 1)">[UBL-SR-30]-Document level allowance reason shall occur maximum once</assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator = true()]">
      <assert id="UBL-SR-31" flag="fatal" test="(count(cbc:AllowanceChargeReason) &lt;= 1)">[UBL-SR-31]-Document level charge reason shall occur maximum once</assert>
    </rule>
    <rule context="/ubl-invoice:Invoice | /ubl-creditnote:CreditNote">
      <assert id="UBL-CR-001" flag="warning" test="not(ext:UBLExtensions)">[UBL-CR-001]-A UBL invoice should not include extensions</assert>
      <assert id="UBL-CR-002" flag="warning" test="not(cbc:UBLVersionID) or cbc:UBLVersionID = '2.1'">[UBL-CR-002]-A UBL invoice should not include the UBLVersionID or it should be 2.1</assert>
      <assert id="UBL-CR-003" flag="warning" test="not(cbc:ProfileExecutionID)">[UBL-CR-003]-A UBL invoice should not include the ProfileExecutionID </assert>
      <assert id="UBL-CR-004" flag="warning" test="not(cbc:CopyIndicator)">[UBL-CR-004]-A UBL invoice should not include the CopyIndicator </assert>
      <assert id="UBL-CR-005" flag="warning" test="not(cbc:UUID)">[UBL-CR-005]-A UBL invoice should not include the UUID </assert>
      <assert id="UBL-CR-006" flag="warning" test="not(cbc:IssueTime)">[UBL-CR-006]-A UBL invoice should not include the IssueTime </assert>
      <assert id="UBL-CR-007" flag="warning" test="not(cbc:PricingCurrencyCode)">[UBL-CR-007]-A UBL invoice should not include the PricingCurrencyCode</assert>
      <assert id="UBL-CR-008" flag="warning" test="not(cbc:PaymentCurrencyCode)">[UBL-CR-008]-A UBL invoice should not include the PaymentCurrencyCode</assert>
      <assert id="UBL-CR-009" flag="warning" test="not(cbc:PaymentAlternativeCurrencyCode)">[UBL-CR-009]-A UBL invoice should not include the PaymentAlternativeCurrencyCode</assert>
      <assert id="UBL-CR-010" flag="warning" test="not(cbc:AccountingCostCode)">[UBL-CR-010]-A UBL invoice should not include the AccountingCostCode</assert>
      <assert id="UBL-CR-011" flag="warning" test="not(cbc:LineCountNumeric)">[UBL-CR-011]-A UBL invoice should not include the LineCountNumeric</assert>
      <assert id="UBL-CR-012" flag="warning" test="not(cac:InvoicePeriod/cbc:StartTime)">[UBL-CR-012]-A UBL invoice should not include the InvoicePeriod StartTime</assert>
      <assert id="UBL-CR-013" flag="warning" test="not(cac:InvoicePeriod/cbc:EndTime)">[UBL-CR-013]-A UBL invoice should not include the InvoicePeriod EndTime</assert>
      <assert id="UBL-CR-014" flag="warning" test="not(cac:InvoicePeriod/cbc:DurationMeasure)">[UBL-CR-014]-A UBL invoice should not include the InvoicePeriod DurationMeasure</assert>
      <assert id="UBL-CR-015" flag="warning" test="not(cac:InvoicePeriod/cbc:Description)">[UBL-CR-015]-A UBL invoice should not include the InvoicePeriod Description</assert>
      <assert id="UBL-CR-016" flag="warning" test="not(cac:OrderReference/cbc:CopyIndicator)">[UBL-CR-016]-A UBL invoice should not include the OrderReference CopyIndicator</assert>
      <assert id="UBL-CR-017" flag="warning" test="not(cac:OrderReference/cbc:UUID)">[UBL-CR-017]-A UBL invoice should not include the OrderReference UUID</assert>
      <assert id="UBL-CR-018" flag="warning" test="not(cac:OrderReference/cbc:IssueDate)">[UBL-CR-018]-A UBL invoice should not include the OrderReference IssueDate</assert>
      <assert id="UBL-CR-019" flag="warning" test="not(cac:OrderReference/cbc:IssueTime)">[UBL-CR-019]-A UBL invoice should not include the OrderReference IssueTime</assert>
      <assert id="UBL-CR-020" flag="warning" test="not(cac:OrderReference/cbc:CustomerReference)">[UBL-CR-020]-A UBL invoice should not include the OrderReference CustomerReference</assert>
      <assert id="UBL-CR-021" flag="warning" test="not(cac:OrderReference/cbc:OrderTypeCode)">[UBL-CR-021]-A UBL invoice should not include the OrderReference OrderTypeCode</assert>
      <assert id="UBL-CR-022" flag="warning" test="not(cac:OrderReference/cbc:DocumentReference)">[UBL-CR-022]-A UBL invoice should not include the OrderReference DocumentReference</assert>
      <assert id="UBL-CR-023" flag="warning" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:CopyIndicator)">[UBL-CR-023]-A UBL invoice should not include the BillingReference CopyIndicator</assert>
      <assert id="UBL-CR-024" flag="warning" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:UUID)">[UBL-CR-024]-A UBL invoice should not include the BillingReference UUID</assert>
      <assert id="UBL-CR-025" flag="warning" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:IssueTime)">[UBL-CR-025]-A UBL invoice should not include the BillingReference IssueTime</assert>
      <assert id="UBL-CR-026" flag="warning" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentTypeCode)">[UBL-CR-026]-A UBL invoice should not include the BillingReference DocumentTypeCode</assert>
      <assert id="UBL-CR-027" flag="warning" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentType)">[UBL-CR-027]-A UBL invoice should not include the BillingReference DocumentType</assert>
      <assert id="UBL-CR-028" flag="warning" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:Xpath)">[UBL-CR-028]-A UBL invoice should not include the BillingReference Xpath</assert>
      <assert id="UBL-CR-029" flag="warning" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:LanguageID)">[UBL-CR-029]-A UBL invoice should not include the BillingReference LanguageID</assert>
      <assert id="UBL-CR-030" flag="warning" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:LocaleCode)">[UBL-CR-030]-A UBL invoice should not include the BillingReference LocaleCode</assert>
      <assert id="UBL-CR-031" flag="warning" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:VersionID)">[UBL-CR-031]-A UBL invoice should not include the BillingReference VersionID</assert>
      <assert id="UBL-CR-032" flag="warning" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentStatusCode)">[UBL-CR-032]-A UBL invoice should not include the BillingReference DocumentStatusCode</assert>
      <assert id="UBL-CR-033" flag="warning" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentDescription)">[UBL-CR-033]-A UBL invoice should not include the BillingReference DocumenDescription</assert>
      <assert id="UBL-CR-034" flag="warning" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cac:Attachment)">[UBL-CR-034]-A UBL invoice should not include the BillingReference Attachment</assert>
      <assert id="UBL-CR-035" flag="warning" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cac:ValidityPeriod)">[UBL-CR-035]-A UBL invoice should not include the BillingReference ValidityPeriod</assert>
      <assert id="UBL-CR-036" flag="warning" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cac:IssuerParty)">[UBL-CR-036]-A UBL invoice should not include the BillingReference IssuerParty</assert>
      <assert id="UBL-CR-037" flag="warning" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cac:ResultOfVerification)">[UBL-CR-037]-A UBL invoice should not include the BillingReference ResultOfVerification</assert>
      <assert id="UBL-CR-038" flag="warning" test="not(cac:BillingReference/cac:SelfBilledInvoiceDocumentReference)">[UBL-CR-038]-A UBL invoice should not include the BillingReference SelfBilledInvoiceDocumentReference</assert>
      <assert id="UBL-CR-039" flag="warning" test="not(cac:BillingReference/cac:CreditNoteDocumentReference)">[UBL-CR-039]-A UBL invoice should not include the BillingReference CreditNoteDocumentReference</assert>
      <assert id="UBL-CR-040" flag="warning" test="not(cac:BillingReference/cac:SelfBilledCreditNoteDocumentReference)">[UBL-CR-040]-A UBL invoice should not include the BillingReference SelfBilledCreditNoteDocumentReference</assert>
      <assert id="UBL-CR-041" flag="warning" test="not(cac:BillingReference/cac:DebitNoteDocumentReference)">[UBL-CR-041]-A UBL invoice should not include the BillingReference DebitNoteDocumentReference</assert>
      <assert id="UBL-CR-042" flag="warning" test="not(cac:BillingReference/cac:ReminderDocumentReference)">[UBL-CR-042]-A UBL invoice should not include the BillingReference ReminderDocumentReference</assert>
      <assert id="UBL-CR-043" flag="warning" test="not(cac:BillingReference/cac:AdditionalDocumentReference)">[UBL-CR-043]-A UBL invoice should not include the BillingReference AdditionalDocumentReference</assert>
      <assert id="UBL-CR-044" flag="warning" test="not(cac:BillingReference/cac:BillingReferenceLine)">[UBL-CR-044]-A UBL invoice should not include the BillingReference BillingReferenceLine</assert>
      <assert id="UBL-CR-045" flag="warning" test="not(cac:DespatchDocumentReference/cbc:CopyIndicator)">[UBL-CR-045]-A UBL invoice should not include the DespatchDocumentReference CopyIndicator</assert>
      <assert id="UBL-CR-046" flag="warning" test="not(cac:DespatchDocumentReference/cbc:UUID)">[UBL-CR-046]-A UBL invoice should not include the DespatchDocumentReference UUID</assert>
      <assert id="UBL-CR-047" flag="warning" test="not(cac:DespatchDocumentReference/cbc:IssueDate)">[UBL-CR-047]-A UBL invoice should not include the DespatchDocumentReference IssueDate</assert>
      <assert id="UBL-CR-048" flag="warning" test="not(cac:DespatchDocumentReference/cbc:IssueTime)">[UBL-CR-048]-A UBL invoice should not include the DespatchDocumentReference IssueTime</assert>
      <assert id="UBL-CR-049" flag="warning" test="not(cac:DespatchDocumentReference/cbc:DocumentTypeCode)">[UBL-CR-049]-A UBL invoice should not include the DespatchDocumentReference DocumentTypeCode</assert>
      <assert id="UBL-CR-050" flag="warning" test="not(cac:DespatchDocumentReference/cbc:DocumentType)">[UBL-CR-050]-A UBL invoice should not include the DespatchDocumentReference DocumentType</assert>
      <assert id="UBL-CR-051" flag="warning" test="not(cac:DespatchDocumentReference/cbc:Xpath)">[UBL-CR-051]-A UBL invoice should not include the DespatchDocumentReference Xpath</assert>
      <assert id="UBL-CR-052" flag="warning" test="not(cac:DespatchDocumentReference/cbc:LanguageID)">[UBL-CR-052]-A UBL invoice should not include the DespatchDocumentReference LanguageID</assert>
      <assert id="UBL-CR-053" flag="warning" test="not(cac:DespatchDocumentReference/cbc:LocaleCode)">[UBL-CR-053]-A UBL invoice should not include the DespatchDocumentReference LocaleCode</assert>
      <assert id="UBL-CR-054" flag="warning" test="not(cac:DespatchDocumentReference/cbc:VersionID)">[UBL-CR-054]-A UBL invoice should not include the DespatchDocumentReference VersionID</assert>
      <assert id="UBL-CR-055" flag="warning" test="not(cac:DespatchDocumentReference/cbc:DocumentStatusCode)">[UBL-CR-055]-A UBL invoice should not include the DespatchDocumentReference DocumentStatusCode</assert>
      <assert id="UBL-CR-056" flag="warning" test="not(cac:DespatchDocumentReference/cbc:DocumentDescription)">[UBL-CR-056]-A UBL invoice should not include the DespatchDocumentReference DocumentDescription</assert>
      <assert id="UBL-CR-057" flag="warning" test="not(cac:DespatchDocumentReference/cac:Attachment)">[UBL-CR-057]-A UBL invoice should not include the DespatchDocumentReference Attachment</assert>
      <assert id="UBL-CR-058" flag="warning" test="not(cac:DespatchDocumentReference/cac:ValidityPeriod)">[UBL-CR-058]-A UBL invoice should not include the DespatchDocumentReference ValidityPeriod</assert>
      <assert id="UBL-CR-059" flag="warning" test="not(cac:DespatchDocumentReference/cac:IssuerParty)">[UBL-CR-059]-A UBL invoice should not include the DespatchDocumentReference IssuerParty</assert>
      <assert id="UBL-CR-060" flag="warning" test="not(cac:DespatchDocumentReference/cac:ResultOfVerification)">[UBL-CR-060]-A UBL invoice should not include the DespatchDocumentReference ResultOfVerification</assert>
      <assert id="UBL-CR-061" flag="warning" test="not(cac:ReceiptDocumentReference/cbc:CopyIndicator)">[UBL-CR-061]-A UBL invoice should not include the ReceiptDocumentReference CopyIndicator</assert>
      <assert id="UBL-CR-062" flag="warning" test="not(cac:ReceiptDocumentReference/cbc:UUID)">[UBL-CR-062]-A UBL invoice should not include the ReceiptDocumentReference UUID</assert>
      <assert id="UBL-CR-063" flag="warning" test="not(cac:ReceiptDocumentReference/cbc:IssueDate)">[UBL-CR-063]-A UBL invoice should not include the ReceiptDocumentReference IssueDate</assert>
      <assert id="UBL-CR-064" flag="warning" test="not(cac:ReceiptDocumentReference/cbc:IssueTime)">[UBL-CR-064]-A UBL invoice should not include the ReceiptDocumentReference IssueTime</assert>
      <assert id="UBL-CR-065" flag="warning" test="not(cac:ReceiptDocumentReference/cbc:DocumentTypeCode)">[UBL-CR-065]-A UBL invoice should not include the ReceiptDocumentReference DocumentTypeCode</assert>
      <assert id="UBL-CR-066" flag="warning" test="not(cac:ReceiptDocumentReference/cbc:DocumentType)">[UBL-CR-066]-A UBL invoice should not include the ReceiptDocumentReference DocumentType</assert>
      <assert id="UBL-CR-067" flag="warning" test="not(cac:ReceiptDocumentReference/cbc:Xpath)">[UBL-CR-067]-A UBL invoice should not include the ReceiptDocumentReference Xpath</assert>
      <assert id="UBL-CR-068" flag="warning" test="not(cac:ReceiptDocumentReference/cbc:LanguageID)">[UBL-CR-068]-A UBL invoice should not include the ReceiptDocumentReference LanguageID</assert>
      <assert id="UBL-CR-069" flag="warning" test="not(cac:ReceiptDocumentReference/cbc:LocaleCode)">[UBL-CR-069]-A UBL invoice should not include the ReceiptDocumentReference LocaleCode</assert>
      <assert id="UBL-CR-070" flag="warning" test="not(cac:ReceiptDocumentReference/cbc:VersionID)">[UBL-CR-070]-A UBL invoice should not include the ReceiptDocumentReference VersionID</assert>
      <assert id="UBL-CR-071" flag="warning" test="not(cac:ReceiptDocumentReference/cbc:DocumentStatusCode)">[UBL-CR-071]-A UBL invoice should not include the ReceiptDocumentReference DocumentStatusCode</assert>
      <assert id="UBL-CR-072" flag="warning" test="not(cac:ReceiptDocumentReference/cbc:DocumentDescription)">[UBL-CR-072]-A UBL invoice should not include the ReceiptDocumentReference DocumentDescription</assert>
      <assert id="UBL-CR-073" flag="warning" test="not(cac:ReceiptDocumentReference/cac:Attachment)">[UBL-CR-073]-A UBL invoice should not include the ReceiptDocumentReference Attachment</assert>
      <assert id="UBL-CR-074" flag="warning" test="not(cac:ReceiptDocumentReference/cac:ValidityPeriod)">[UBL-CR-074]-A UBL invoice should not include the ReceiptDocumentReference ValidityPeriod</assert>
      <assert id="UBL-CR-075" flag="warning" test="not(cac:ReceiptDocumentReference/cac:IssuerParty)">[UBL-CR-075]-A UBL invoice should not include the ReceiptDocumentReference IssuerParty</assert>
      <assert id="UBL-CR-076" flag="warning" test="not(cac:ReceiptDocumentReference/cac:ResultOfVerification)">[UBL-CR-076]-A UBL invoice should not include the ReceiptDocumentReference ResultOfVerification</assert>
      <assert id="UBL-CR-077" flag="warning" test="not(cac:StatementDocumentReference)">[UBL-CR-077]-A UBL invoice should not include the StatementDocumentReference</assert>
      <assert id="UBL-CR-078" flag="warning" test="not(cac:OriginatorDocumentReference/cbc:CopyIndicator)">[UBL-CR-078]-A UBL invoice should not include the OriginatorDocumentReference CopyIndicator</assert>
      <assert id="UBL-CR-079" flag="warning" test="not(cac:OriginatorDocumentReference/cbc:UUID)">[UBL-CR-079]-A UBL invoice should not include the OriginatorDocumentReference UUID</assert>
      <assert id="UBL-CR-080" flag="warning" test="not(cac:OriginatorDocumentReference/cbc:IssueDate)">[UBL-CR-080]-A UBL invoice should not include the OriginatorDocumentReference IssueDate</assert>
      <assert id="UBL-CR-081" flag="warning" test="not(cac:OriginatorDocumentReference/cbc:IssueTime)">[UBL-CR-081]-A UBL invoice should not include the OriginatorDocumentReference IssueTime</assert>
      <assert id="UBL-CR-082" flag="warning" test="not(cac:OriginatorDocumentReference/cbc:DocumentTypeCode)">[UBL-CR-082]-A UBL invoice should not include the OriginatorDocumentReference DocumentTypeCode</assert>
      <assert id="UBL-CR-083" flag="warning" test="not(cac:OriginatorDocumentReference/cbc:DocumentType)">[UBL-CR-083]-A UBL invoice should not include the OriginatorDocumentReference DocumentType</assert>
      <assert id="UBL-CR-084" flag="warning" test="not(cac:OriginatorDocumentReference/cbc:Xpath)">[UBL-CR-084]-A UBL invoice should not include the OriginatorDocumentReference Xpath</assert>
      <assert id="UBL-CR-085" flag="warning" test="not(cac:OriginatorDocumentReference/cbc:LanguageID)">[UBL-CR-085]-A UBL invoice should not include the OriginatorDocumentReference LanguageID</assert>
      <assert id="UBL-CR-086" flag="warning" test="not(cac:OriginatorDocumentReference/cbc:LocaleCode)">[UBL-CR-086]-A UBL invoice should not include the OriginatorDocumentReference LocaleCode</assert>
      <assert id="UBL-CR-087" flag="warning" test="not(cac:OriginatorDocumentReference/cbc:VersionID)">[UBL-CR-087]-A UBL invoice should not include the OriginatorDocumentReference VersionID</assert>
      <assert id="UBL-CR-088" flag="warning" test="not(cac:OriginatorDocumentReference/cbc:DocumentStatusCode)">[UBL-CR-088]-A UBL invoice should not include the OriginatorDocumentReference DocumentStatusCode</assert>
      <assert id="UBL-CR-089" flag="warning" test="not(cac:OriginatorDocumentReference/cbc:DocumentDescription)">[UBL-CR-089]-A UBL invoice should not include the OriginatorDocumentReference DocumentDescription</assert>
      <assert id="UBL-CR-090" flag="warning" test="not(cac:OriginatorDocumentReference/cac:Attachment)">[UBL-CR-090]-A UBL invoice should not include the OriginatorDocumentReference Attachment</assert>
      <assert id="UBL-CR-091" flag="warning" test="not(cac:OriginatorDocumentReference/cac:ValidityPeriod)">[UBL-CR-091]-A UBL invoice should not include the OriginatorDocumentReference ValidityPeriod</assert>
      <assert id="UBL-CR-092" flag="warning" test="not(cac:OriginatorDocumentReference/cac:IssuerParty)">[UBL-CR-092]-A UBL invoice should not include the OriginatorDocumentReference IssuerParty</assert>
      <assert id="UBL-CR-093" flag="warning" test="not(cac:OriginatorDocumentReference/cac:ResultOfVerification)">[UBL-CR-093]-A UBL invoice should not include the OriginatorDocumentReference ResultOfVerification</assert>
      <assert id="UBL-CR-094" flag="warning" test="not(cac:ContractDocumentReference/cbc:CopyIndicator)">[UBL-CR-094]-A UBL invoice should not include the ContractDocumentReference CopyIndicator</assert>
      <assert id="UBL-CR-095" flag="warning" test="not(cac:ContractDocumentReference/cbc:UUID)">[UBL-CR-095]-A UBL invoice should not include the ContractDocumentReference UUID</assert>
      <assert id="UBL-CR-096" flag="warning" test="not(cac:ContractDocumentReference/cbc:IssueDate)">[UBL-CR-096]-A UBL invoice should not include the ContractDocumentReference IssueDate</assert>
      <assert id="UBL-CR-097" flag="warning" test="not(cac:ContractDocumentReference/cbc:IssueTime)">[UBL-CR-097]-A UBL invoice should not include the ContractDocumentReference IssueTime</assert>
      <assert id="UBL-CR-098" flag="warning" test="not(cac:ContractDocumentReference/cbc:DocumentTypeCode)">[UBL-CR-098]-A UBL invoice should not include the ContractDocumentReference DocumentTypeCode</assert>
      <assert id="UBL-CR-099" flag="warning" test="not(cac:ContractDocumentReference/cbc:DocumentType)">[UBL-CR-099]-A UBL invoice should not include the ContractDocumentReference DocumentType</assert>
      <assert id="UBL-CR-100" flag="warning" test="not(cac:ContractDocumentReference/cbc:Xpath)">[UBL-CR-100]-A UBL invoice should not include the ContractDocumentReference Xpath</assert>
      <assert id="UBL-CR-101" flag="warning" test="not(cac:ContractDocumentReference/cbc:LanguageID)">[UBL-CR-101]-A UBL invoice should not include the ContractDocumentReference LanguageID</assert>
      <assert id="UBL-CR-102" flag="warning" test="not(cac:ContractDocumentReference/cbc:LocaleCode)">[UBL-CR-102]-A UBL invoice should not include the ContractDocumentReference LocaleCode</assert>
      <assert id="UBL-CR-103" flag="warning" test="not(cac:ContractDocumentReference/cbc:VersionID)">[UBL-CR-103]-A UBL invoice should not include the ContractDocumentReference VersionID</assert>
      <assert id="UBL-CR-104" flag="warning" test="not(cac:ContractDocumentReference/cbc:DocumentStatusCode)">[UBL-CR-104]-A UBL invoice should not include the ContractDocumentReference DocumentStatusCode</assert>
      <assert id="UBL-CR-105" flag="warning" test="not(cac:ContractDocumentReference/cbc:DocumentDescription)">[UBL-CR-105]-A UBL invoice should not include the ContractDocumentReference DocumentDescription</assert>
      <assert id="UBL-CR-106" flag="warning" test="not(cac:ContractDocumentReference/cac:Attachment)">[UBL-CR-106]-A UBL invoice should not include the ContractDocumentReference Attachment</assert>
      <assert id="UBL-CR-107" flag="warning" test="not(cac:ContractDocumentReference/cac:ValidityPeriod)">[UBL-CR-107]-A UBL invoice should not include the ContractDocumentReference ValidityPeriod</assert>
      <assert id="UBL-CR-108" flag="warning" test="not(cac:ContractDocumentReference/cac:IssuerParty)">[UBL-CR-108]-A UBL invoice should not include the ContractDocumentReference IssuerParty</assert>
      <assert id="UBL-CR-109" flag="warning" test="not(cac:ContractDocumentReference/cac:ResultOfVerification)">[UBL-CR-109]-A UBL invoice should not include the ContractDocumentReference ResultOfVerification</assert>
      <assert id="UBL-CR-110" flag="warning" test="not(cac:AdditionalDocumentReference/cbc:CopyIndicator)">[UBL-CR-110]-A UBL invoice should not include the AdditionalDocumentReference CopyIndicator</assert>
      <assert id="UBL-CR-111" flag="warning" test="not(cac:AdditionalDocumentReference/cbc:UUID)">[UBL-CR-111]-A UBL invoice should not include the AdditionalDocumentReference UUID</assert>
      <assert id="UBL-CR-112" flag="warning" test="not(cac:AdditionalDocumentReference/cbc:IssueDate)">[UBL-CR-112]-A UBL invoice should not include the AdditionalDocumentReference IssueDate</assert>
      <assert id="UBL-CR-113" flag="warning" test="not(cac:AdditionalDocumentReference/cbc:IssueTime)">[UBL-CR-113]-A UBL invoice should not include the AdditionalDocumentReference IssueTime</assert>
      <assert id="UBL-CR-114" flag="warning" test="not(cac:AdditionalDocumentReference/cbc:DocumentType)">[UBL-CR-114]-A UBL invoice should not include the AdditionalDocumentReference DocumentType</assert>
      <assert id="UBL-CR-115" flag="warning" test="not(cac:AdditionalDocumentReference/cbc:Xpath)">[UBL-CR-115]-A UBL invoice should not include the AdditionalDocumentReference Xpath</assert>
      <assert id="UBL-CR-116" flag="warning" test="not(cac:AdditionalDocumentReference/cbc:LanguageID)">[UBL-CR-116]-A UBL invoice should not include the AdditionalDocumentReference LanguageID</assert>
      <assert id="UBL-CR-117" flag="warning" test="not(cac:AdditionalDocumentReference/cbc:LocaleCode)">[UBL-CR-117]-A UBL invoice should not include the AdditionalDocumentReference LocaleCode</assert>
      <assert id="UBL-CR-118" flag="warning" test="not(cac:AdditionalDocumentReference/cbc:VersionID)">[UBL-CR-118]-A UBL invoice should not include the AdditionalDocumentReference VersionID</assert>
      <assert id="UBL-CR-119" flag="warning" test="not(cac:AdditionalDocumentReference/cbc:DocumentStatusCode)">[UBL-CR-119]-A UBL invoice should not include the AdditionalDocumentReference DocumentStatusCode</assert>
      <assert id="UBL-CR-121" flag="warning" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:DocumentHash)">[UBL-CR-121]-A UBL invoice should not include the AdditionalDocumentReference Attachment External DocumentHash</assert>
      <assert id="UBL-CR-122" flag="warning" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:HashAlgorithmMethod)">[UBL-CR-122]-A UBL invoice should not include the AdditionalDocumentReference Attachment External HashAlgorithmMethod</assert>
      <assert id="UBL-CR-123" flag="warning" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:ExpiryDate)">[UBL-CR-123]-A UBL invoice should not include the AdditionalDocumentReference Attachment External ExpiryDate</assert>
      <assert id="UBL-CR-124" flag="warning" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:ExpiryTime)">[UBL-CR-124]-A UBL invoice should not include the AdditionalDocumentReference Attachment External ExpiryTime</assert>
      <assert id="UBL-CR-125" flag="warning" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:MimeCode)">[UBL-CR-125]-A UBL invoice should not include the AdditionalDocumentReference Attachment External MimeCode</assert>
      <assert id="UBL-CR-126" flag="warning" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:FormatCode)">[UBL-CR-126]-A UBL invoice should not include the AdditionalDocumentReference Attachment External FormatCode</assert>
      <assert id="UBL-CR-127" flag="warning" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:EncodingCode)">[UBL-CR-127]-A UBL invoice should not include the AdditionalDocumentReference Attachment External EncodingCode</assert>
      <assert id="UBL-CR-128" flag="warning" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:CharacterSetCode)">[UBL-CR-128]-A UBL invoice should not include the AdditionalDocumentReference Attachment External CharacterSetCode</assert>
      <assert id="UBL-CR-129" flag="warning" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:FileName)">[UBL-CR-129]-A UBL invoice should not include the AdditionalDocumentReference Attachment External FileName</assert>
      <assert id="UBL-CR-130" flag="warning" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:Description)">[UBL-CR-130]-A UBL invoice should not include the AdditionalDocumentReference Attachment External Descriprion</assert>
      <assert id="UBL-CR-131" flag="warning" test="not(cac:AdditionalDocumentReference/cac:ValidityPeriod)">[UBL-CR-131]-A UBL invoice should not include the AdditionalDocumentReference ValidityPeriod</assert>
      <assert id="UBL-CR-132" flag="warning" test="not(cac:AdditionalDocumentReference/cac:IssuerParty)">[UBL-CR-132]-A UBL invoice should not include the AdditionalDocumentReference IssuerParty</assert>
      <assert id="UBL-CR-133" flag="warning" test="not(cac:AdditionalDocumentReference/cac:ResultOfVerification)">[UBL-CR-133]-A UBL invoice should not include the AdditionalDocumentReference ResultOfVerification</assert>
      <assert id="UBL-CR-134" flag="warning" test="not(cac:ProjectReference/cbc:UUID)">[UBL-CR-134]-A UBL invoice should not include the ProjectReference UUID</assert>
      <assert id="UBL-CR-135" flag="warning" test="not(cac:ProjectReference/cbc:IssueDate)">[UBL-CR-135]-A UBL invoice should not include the ProjectReference IssueDate</assert>
      <assert id="UBL-CR-136" flag="warning" test="not(cac:ProjectReference/cac:WorkPhaseReference)">[UBL-CR-136]-A UBL invoice should not include the ProjectReference WorkPhaseReference</assert>
      <assert id="UBL-CR-137" flag="warning" test="not(cac:Signature)">[UBL-CR-137]-A UBL invoice should not include the Signature</assert>
      <assert id="UBL-CR-138" flag="warning" test="not(cac:AccountingSupplierParty/cbc:CustomerAssignedAccountID)">[UBL-CR-138]-A UBL invoice should not include the AccountingSupplierParty CustomerAssignedAccountID</assert>
      <assert id="UBL-CR-139" flag="warning" test="not(cac:AccountingSupplierParty/cbc:AdditionalAccountID)">[UBL-CR-139]-A UBL invoice should not include the AccountingSupplierParty AdditionalAccountID</assert>
      <assert id="UBL-CR-140" flag="warning" test="not(cac:AccountingSupplierParty/cbc:DataSendingCapability)">[UBL-CR-140]-A UBL invoice should not include the AccountingSupplierParty DataSendingCapability</assert>
      <assert id="UBL-CR-141" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cbc:MarkCareIndicator)">[UBL-CR-141]-A UBL invoice should not include the AccountingSupplierParty Party MarkCareIndicator</assert>
      <assert id="UBL-CR-142" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cbc:MarkAttentionIndicator)">[UBL-CR-142]-A UBL invoice should not include the AccountingSupplierParty Party MarkAttentionIndicator</assert>
      <assert id="UBL-CR-143" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cbc:WebsiteURI)">[UBL-CR-143]-A UBL invoice should not include the AccountingSupplierParty Party WebsiteURI</assert>
      <assert id="UBL-CR-144" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cbc:LogoReferenceID)">[UBL-CR-144]-A UBL invoice should not include the AccountingSupplierParty Party LogoReferenceID</assert>
      <assert id="UBL-CR-145" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cbc:IndustryClassificationCode)">[UBL-CR-145]-A UBL invoice should not include the AccountingSupplierParty Party IndustryClassificationCode</assert>
      <assert id="UBL-CR-146" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:Language)">[UBL-CR-146]-A UBL invoice should not include the AccountingSupplierParty Party Language</assert>
      <assert id="UBL-CR-147" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:ID)">[UBL-CR-147]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress ID</assert>
      <assert id="UBL-CR-148" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AddressTypeCode)">[UBL-CR-148]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress AddressTypeCode</assert>
      <assert id="UBL-CR-149" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AddressFormatCode)">[UBL-CR-149]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress AddressFormatCode</assert>
      <assert id="UBL-CR-150" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Postbox)">[UBL-CR-150]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress Postbox</assert>
      <assert id="UBL-CR-151" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Floor)">[UBL-CR-151]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress Floor</assert>
      <assert id="UBL-CR-152" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Room)">[UBL-CR-152]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress Room</assert>
      <assert id="UBL-CR-153" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:BlockName)">[UBL-CR-153]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress BlockName</assert>
      <assert id="UBL-CR-154" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:BuildingName)">[UBL-CR-154]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress BuildingName</assert>
      <assert id="UBL-CR-155" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:BuildingNumber)">[UBL-CR-155]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress BuildingNumber</assert>
      <assert id="UBL-CR-156" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:InhouseMail)">[UBL-CR-156]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress InhouseMail</assert>
      <assert id="UBL-CR-157" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Department)">[UBL-CR-157]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress Department</assert>
      <assert id="UBL-CR-158" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:MarkAttention)">[UBL-CR-158]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress MarkAttention</assert>
      <assert id="UBL-CR-159" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:MarkCare)">[UBL-CR-159]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress MarkCare</assert>
      <assert id="UBL-CR-160" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification)">[UBL-CR-160]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress PlotIdentification</assert>
      <assert id="UBL-CR-161" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName)">[UBL-CR-161]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress CitySubdivisionName</assert>
      <assert id="UBL-CR-162" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode)">[UBL-CR-162]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress CountrySubentityCode</assert>
      <assert id="UBL-CR-163" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Region)">[UBL-CR-163]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress Region</assert>
      <assert id="UBL-CR-164" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:District)">[UBL-CR-164]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress District</assert>
      <assert id="UBL-CR-165" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:TimezoneOffset)">[UBL-CR-165]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress TimezoneOffset</assert>
      <assert id="UBL-CR-166" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:Name)">[UBL-CR-166]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress Country Name</assert>
      <assert id="UBL-CR-167" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:LocationCoordinate)">[UBL-CR-167]-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress LocationCoordinate</assert>
      <assert id="UBL-CR-168" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PhysicalLocation)">[UBL-CR-168]-A UBL invoice should not include the AccountingSupplierParty Party PhysicalLocation</assert>
      <assert id="UBL-CR-169" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:RegistrationName)">[UBL-CR-169]-A UBL invoice should not include the AccountingSupplierParty Party PartyTaxScheme RegistrationName</assert>
      <assert id="UBL-CR-170" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:TaxLevelCode)">[UBL-CR-170]-A UBL invoice should not include the AccountingSupplierParty Party PartyTaxScheme TaxLevelCode</assert>
      <assert id="UBL-CR-171" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReasonCode)">[UBL-CR-171]-A UBL invoice should not include the AccountingSupplierParty Party PartyTaxScheme ExemptionReasonCode</assert>
      <assert id="UBL-CR-172" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReason)">[UBL-CR-172]-A UBL invoice should not include the AccountingSupplierParty Party PartyTaxScheme ExemptionReason</assert>
      <assert id="UBL-CR-173" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:RegistrationAddress)">[UBL-CR-173]-A UBL invoice should not include the AccountingSupplierParty Party PartyTaxScheme RegistrationAddress</assert>
      <assert id="UBL-CR-174" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:Name)">[UBL-CR-174]-A UBL invoice should not include the AccountingSupplierParty Party PartyTaxScheme TaxScheme Name</assert>
      <assert id="UBL-CR-175" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:TaxTypeCode)">[UBL-CR-175]-A UBL invoice should not include the AccountingSupplierParty Party PartyTaxScheme TaxScheme TaxTypeCode</assert>
      <assert id="UBL-CR-176" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:CurrencyCode)">[UBL-CR-176]-A UBL invoice should not include the AccountingSupplierParty Party PartyTaxScheme TaxScheme CurrencyCode</assert>
      <assert id="UBL-CR-177" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cac:JurisdictionRegionAddress)">[UBL-CR-177]-A UBL invoice should not include the AccountingSupplierParty Party PartyTaxScheme TaxScheme JurisdictionRegionAddress</assert>
      <assert id="UBL-CR-178" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationDate)">[UBL-CR-178]-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity RegistrationDate</assert>
      <assert id="UBL-CR-179" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationExpirationDate)">[UBL-CR-179]-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity RegistrationExpirationDate</assert>
      <assert id="UBL-CR-180" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLegalFormCode)">[UBL-CR-180]-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity CompanyLegalFormCode</assert>
      <assert id="UBL-CR-181" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:SoleProprietorshipIndicator)">[UBL-CR-181]-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity SoleProprietorshipIndicator</assert>
      <assert id="UBL-CR-182" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLiquidationStatusCode)">[UBL-CR-182]-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity CompanyLiquidationStatusCode</assert>
      <assert id="UBL-CR-183" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CorporationStockAmount)">[UBL-CR-183]-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity CorporationStockAmount</assert>
      <assert id="UBL-CR-184" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:FullyPaidSharesIndicator)">[UBL-CR-184]-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity FullyPaidSharesIndicator</assert>
      <assert id="UBL-CR-185" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress)">[UBL-CR-185]-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity RegistrationAddress</assert>
      <assert id="UBL-CR-186" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:CorporateRegistrationScheme)">[UBL-CR-186]-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity CorporateRegistrationScheme</assert>
      <assert id="UBL-CR-187" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:HeadOfficeParty)">[UBL-CR-187]-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity HeadOfficeParty</assert>
      <assert id="UBL-CR-188" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:ShareholderParty)">[UBL-CR-188]-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity ShareholderParty</assert>
      <assert id="UBL-CR-189" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:ID)">[UBL-CR-189]-A UBL invoice should not include the AccountingSupplierParty Party Contact ID</assert>
      <assert id="UBL-CR-190" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Telefax)">[UBL-CR-190]-A UBL invoice should not include the AccountingSupplierParty Party Contact Telefax</assert>
      <assert id="UBL-CR-191" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Note)">[UBL-CR-191]-A UBL invoice should not include the AccountingSupplierParty Party Contact Note</assert>
      <assert id="UBL-CR-192" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cac:OtherCommunication)">[UBL-CR-192]-A UBL invoice should not include the AccountingSupplierParty Party Contact OtherCommunication</assert>
      <assert id="UBL-CR-193" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:Person)">[UBL-CR-193]-A UBL invoice should not include the AccountingSupplierParty Party Person</assert>
      <assert id="UBL-CR-194" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:AgentParty)">[UBL-CR-194]-A UBL invoice should not include the AccountingSupplierParty Party AgentParty</assert>
      <assert id="UBL-CR-195" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:ServiceProviderParty)">[UBL-CR-195]-A UBL invoice should not include the AccountingSupplierParty Party ServiceProviderParty</assert>
      <assert id="UBL-CR-196" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PowerOfAttorney)">[UBL-CR-196]-A UBL invoice should not include the AccountingSupplierParty Party PowerOfAttorney</assert>
      <assert id="UBL-CR-197" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:FinancialAccount)">[UBL-CR-197]-A UBL invoice should not include the AccountingSupplierParty Party FinancialAccount</assert>
      <assert id="UBL-CR-198" flag="warning" test="not(cac:AccountingSupplierParty/cac:DespatchContact)">[UBL-CR-198]-A UBL invoice should not include the AccountingSupplierParty DespatchContact</assert>
      <assert id="UBL-CR-199" flag="warning" test="not(cac:AccountingSupplierParty/cac:AccountingContact)">[UBL-CR-199]-A UBL invoice should not include the AccountingSupplierParty AccountingContact</assert>
      <assert id="UBL-CR-200" flag="warning" test="not(cac:AccountingSupplierParty/cac:SellerContact)">[UBL-CR-200]-A UBL invoice should not include the AccountingSupplierParty SellerContact</assert>
      <assert id="UBL-CR-201" flag="warning" test="not(cac:AccountingCustomerParty/cbc:CustomerAssignedAccountID)">[UBL-CR-201]-A UBL invoice should not include the AccountingCustomerParty CustomerAssignedAccountID</assert>
      <assert id="UBL-CR-202" flag="warning" test="not(cac:AccountingCustomerParty/cbc:SupplierAssignedAccountID)">[UBL-CR-202]-A UBL invoice should not include the AccountingCustomerParty SupplierAssignedAccountID</assert>
      <assert id="UBL-CR-203" flag="warning" test="not(cac:AccountingCustomerParty/cbc:AdditionalAccountID)">[UBL-CR-203]-A UBL invoice should not include the AccountingCustomerParty AdditionalAccountID</assert>
      <assert id="UBL-CR-204" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cbc:MarkCareIndicator)">[UBL-CR-204]-A UBL invoice should not include the AccountingCustomerParty Party MarkCareIndicator</assert>
      <assert id="UBL-CR-205" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cbc:MarkAttentionIndicator)">[UBL-CR-205]-A UBL invoice should not include the AccountingCustomerParty Party MarkAttentionIndicator</assert>
      <assert id="UBL-CR-206" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cbc:WebsiteURI)">[UBL-CR-206]-A UBL invoice should not include the AccountingCustomerParty Party WebsiteURI</assert>
      <assert id="UBL-CR-207" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cbc:LogoReferenceID)">[UBL-CR-207]-A UBL invoice should not include the AccountingCustomerParty Party LogoReferenceID</assert>
      <assert id="UBL-CR-208" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cbc:IndustryClassificationCode)">[UBL-CR-208]-A UBL invoice should not include the AccountingCustomerParty Party IndustryClassificationCode</assert>
      <assert id="UBL-CR-209" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:Language)">[UBL-CR-209]-A UBL invoice should not include the AccountingCustomerParty Party Language</assert>
      <assert id="UBL-CR-210" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:ID)">[UBL-CR-210]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress ID</assert>
      <assert id="UBL-CR-211" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AddressTypeCode)">[UBL-CR-211]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress AddressTypeCode</assert>
      <assert id="UBL-CR-212" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AddressFormatCode)">[UBL-CR-212]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress AddressFormatCode</assert>
      <assert id="UBL-CR-213" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Postbox)">[UBL-CR-213]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress Postbox</assert>
      <assert id="UBL-CR-214" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Floor)">[UBL-CR-214]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress Floor</assert>
      <assert id="UBL-CR-215" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Room)">[UBL-CR-215]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress Room</assert>
      <assert id="UBL-CR-216" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:BlockName)">[UBL-CR-216]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress BlockName</assert>
      <assert id="UBL-CR-217" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:BuildingName)">[UBL-CR-217]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress BuildingName</assert>
      <assert id="UBL-CR-218" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:BuildingNumber)">[UBL-CR-218]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress BuildingNumber</assert>
      <assert id="UBL-CR-219" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:InhouseMail)">[UBL-CR-219]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress InhouseMail</assert>
      <assert id="UBL-CR-220" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Department)">[UBL-CR-220]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress Department</assert>
      <assert id="UBL-CR-221" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:MarkAttention)">[UBL-CR-221]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress MarkAttention</assert>
      <assert id="UBL-CR-222" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:MarkCare)">[UBL-CR-222]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress MarkCare</assert>
      <assert id="UBL-CR-223" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification)">[UBL-CR-223]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress PlotIdentification</assert>
      <assert id="UBL-CR-224" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName)">[UBL-CR-224]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress CitySubdivisionName</assert>
      <assert id="UBL-CR-225" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode)">[UBL-CR-225]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress CountrySubentityCode</assert>
      <assert id="UBL-CR-226" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Region)">[UBL-CR-226]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress Region</assert>
      <assert id="UBL-CR-227" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:District)">[UBL-CR-227]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress District</assert>
      <assert id="UBL-CR-228" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:TimezoneOffset)">[UBL-CR-228]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress TimezoneOffset</assert>
      <assert id="UBL-CR-229" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:Name)">[UBL-CR-229]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress Country Name</assert>
      <assert id="UBL-CR-230" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:LocationCoordinate)">[UBL-CR-230]-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress LocationCoordinate</assert>
      <assert id="UBL-CR-231" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PhysicalLocation)">[UBL-CR-231]-A UBL invoice should not include the AccountingCustomerParty Party PhysicalLocation</assert>
      <assert id="UBL-CR-232" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:RegistrationName)">[UBL-CR-232]-A UBL invoice should not include the AccountingCustomerParty Party PartyTaxScheme RegistrationName</assert>
      <assert id="UBL-CR-233" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:TaxLevelCode)">[UBL-CR-233]-A UBL invoice should not include the AccountingCustomerParty Party PartyTaxScheme TaxLevelCode</assert>
      <assert id="UBL-CR-234" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReasonCode)">[UBL-CR-234]-A UBL invoice should not include the AccountingCustomerParty Party PartyTaxScheme ExemptionReasonCode</assert>
      <assert id="UBL-CR-235" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReason)">[UBL-CR-235]-A UBL invoice should not include the AccountingCustomerParty Party PartyTaxScheme ExemptionReason</assert>
      <assert id="UBL-CR-236" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:RegistrationAddress)">[UBL-CR-236]-A UBL invoice should not include the AccountingCustomerParty Party PartyTaxScheme RegistrationAddress</assert>
      <assert id="UBL-CR-237" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:Name)">[UBL-CR-237]-A UBL invoice should not include the AccountingCustomerParty Party PartyTaxScheme TaxScheme Name</assert>
      <assert id="UBL-CR-238" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:TaxTypeCode)">[UBL-CR-238]-A UBL invoice should not include the AccountingCustomerParty Party PartyTaxScheme TaxScheme TaxTypeCode</assert>
      <assert id="UBL-CR-239" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:CurrencyCode)">[UBL-CR-239]-A UBL invoice should not include the AccountingCustomerParty Party PartyTaxScheme TaxScheme CurrencyCode</assert>
      <assert id="UBL-CR-240" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cac:JurisdictionRegionAddress)">[UBL-CR-240]-A UBL invoice should not include the AccountingCustomerParty Party PartyTaxScheme TaxScheme JurisdictionRegionAddress</assert>
      <assert id="UBL-CR-241" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationDate)">[UBL-CR-241]-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity RegistrationDate</assert>
      <assert id="UBL-CR-242" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationExpirationDate)">[UBL-CR-242]-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity RegistrationExpirationDate</assert>
      <assert id="UBL-CR-243" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLegalFormCode)">[UBL-CR-243]-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity CompanyLegalFormCode</assert>
      <assert id="UBL-CR-244" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLegalForm)">[UBL-CR-244]-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity CompanyLegalForm</assert>
      <assert id="UBL-CR-245" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:SoleProprietorshipIndicator)">[UBL-CR-245]-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity SoleProprietorshipIndicator</assert>
      <assert id="UBL-CR-246" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLiquidationStatusCode)">[UBL-CR-246]-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity CompanyLiquidationStatusCode</assert>
      <assert id="UBL-CR-247" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CorporationStockAmount)">[UBL-CR-247]-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity CorporationStockAmount</assert>
      <assert id="UBL-CR-248" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:FullyPaidSharesIndicator)">[UBL-CR-248]-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity FullyPaidSharesIndicator</assert>
      <assert id="UBL-CR-249" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress)">[UBL-CR-249]-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity RegistrationAddress</assert>
      <assert id="UBL-CR-250" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:CorporateRegistrationScheme)">[UBL-CR-250]-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity CorporateRegistrationScheme</assert>
      <assert id="UBL-CR-251" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:HeadOfficeParty)">[UBL-CR-251]-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity HeadOfficeParty</assert>
      <assert id="UBL-CR-252" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:ShareholderParty)">[UBL-CR-252]-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity ShareholderParty</assert>
      <assert id="UBL-CR-253" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:ID)">[UBL-CR-253]-A UBL invoice should not include the AccountingCustomerParty Party Contact ID</assert>
      <assert id="UBL-CR-254" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Telefax)">[UBL-CR-254]-A UBL invoice should not include the AccountingCustomerParty Party Contact Telefax</assert>
      <assert id="UBL-CR-255" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Note)">[UBL-CR-255]-A UBL invoice should not include the AccountingCustomerParty Party Contact Note</assert>
      <assert id="UBL-CR-256" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cac:OtherCommunication)">[UBL-CR-256]-A UBL invoice should not include the AccountingCustomerParty Party Contact OtherCommunication</assert>
      <assert id="UBL-CR-257" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:Person)">[UBL-CR-257]-A UBL invoice should not include the AccountingCustomerParty Party Person</assert>
      <assert id="UBL-CR-258" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:AgentParty)">[UBL-CR-258]-A UBL invoice should not include the AccountingCustomerParty Party AgentParty</assert>
      <assert id="UBL-CR-259" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:ServiceProviderParty)">[UBL-CR-259]-A UBL invoice should not include the AccountingCustomerParty Party ServiceProviderParty</assert>
      <assert id="UBL-CR-260" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PowerOfAttorney)">[UBL-CR-260]-A UBL invoice should not include the AccountingCustomerParty Party PowerOfAttorney</assert>
      <assert id="UBL-CR-261" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:FinancialAccount)">[UBL-CR-261]-A UBL invoice should not include the AccountingCustomerParty Party FinancialAccount</assert>
      <assert id="UBL-CR-262" flag="warning" test="not(cac:AccountingCustomerParty/cac:DeliveryContact)">[UBL-CR-262]-A UBL invoice should not include the AccountingCustomerParty DeliveryContact</assert>
      <assert id="UBL-CR-263" flag="warning" test="not(cac:AccountingCustomerParty/cac:AccountingContact)">[UBL-CR-263]-A UBL invoice should not include the AccountingCustomerParty AccountingContact</assert>
      <assert id="UBL-CR-264" flag="warning" test="not(cac:AccountingCustomerParty/cac:BuyerContact)">[UBL-CR-264]-A UBL invoice should not include the AccountingCustomerParty BuyerContact</assert>
      <assert id="UBL-CR-265" flag="warning" test="not(cac:PayeeParty/cbc:MarkCareIndicator)">[UBL-CR-265]-A UBL invoice should not include the PayeeParty MarkCareIndicator</assert>
      <assert id="UBL-CR-266" flag="warning" test="not(cac:PayeeParty/cbc:MarkAttentionIndicator)">[UBL-CR-266]-A UBL invoice should not include the PayeeParty MarkAttentionIndicator</assert>
      <assert id="UBL-CR-267" flag="warning" test="not(cac:PayeeParty/cbc:WebsiteURI)">[UBL-CR-267]-A UBL invoice should not include the PayeeParty WebsiteURI</assert>
      <assert id="UBL-CR-268" flag="warning" test="not(cac:PayeeParty/cbc:LogoReferenceID)">[UBL-CR-268]-A UBL invoice should not include the PayeeParty LogoReferenceID</assert>
      <assert id="UBL-CR-269" flag="warning" test="not(cac:PayeeParty/cbc:EndpointID)">[UBL-CR-269]-A UBL invoice should not include the PayeeParty EndpointID</assert>
      <assert id="UBL-CR-270" flag="warning" test="not(cac:PayeeParty/cbc:IndustryClassificationCode)">[UBL-CR-270]-A UBL invoice should not include the PayeeParty IndustryClassificationCode</assert>
      <assert id="UBL-CR-271" flag="warning" test="not(cac:PayeeParty/cac:Language)">[UBL-CR-271]-A UBL invoice should not include the PayeeParty Language</assert>
      <assert id="UBL-CR-272" flag="warning" test="not(cac:PayeeParty/cac:PostalAddress)">[UBL-CR-272]-A UBL invoice should not include the PayeeParty PostalAddress</assert>
      <assert id="UBL-CR-273" flag="warning" test="not(cac:PayeeParty/cac:PhysicalLocation)">[UBL-CR-273]-A UBL invoice should not include the PayeeParty PhysicalLocation</assert>
      <assert id="UBL-CR-274" flag="warning" test="not(cac:PayeeParty/cac:PartyTaxScheme)">[UBL-CR-274]-A UBL invoice should not include the PayeeParty PartyTaxScheme</assert>
      <assert id="UBL-CR-275" flag="warning" test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:RegistrationName)">[UBL-CR-275]-A UBL invoice should not include the PayeeParty PartyLegalEntity RegistrationName</assert>
      <assert id="UBL-CR-276" flag="warning" test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:RegistrationDate)">[UBL-CR-276]-A UBL invoice should not include the PayeeParty PartyLegalEntity RegistrationDate</assert>
      <assert id="UBL-CR-277" flag="warning" test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:RegistrationExpirationDate)">[UBL-CR-277]-A UBL invoice should not include the PayeeParty PartyLegalEntity RegistrationExpirationDate</assert>
      <assert id="UBL-CR-278" flag="warning" test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:CompanyLegalFormCode)">[UBL-CR-278]-A UBL invoice should not include the PayeeParty PartyLegalEntity CompanyLegalFormCode</assert>
      <assert id="UBL-CR-279" flag="warning" test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:CompanyLegalForm)">[UBL-CR-279]-A UBL invoice should not include the PayeeParty PartyLegalEntity CompanyLegalForm</assert>
      <assert id="UBL-CR-280" flag="warning" test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:SoleProprietorshipIndicator)">[UBL-CR-280]-A UBL invoice should not include the PayeeParty PartyLegalEntity SoleProprietorshipIndicator</assert>
      <assert id="UBL-CR-281" flag="warning" test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:CompanyLiquidationStatusCode)">[UBL-CR-281]-A UBL invoice should not include the PayeeParty PartyLegalEntity CompanyLiquidationStatusCode</assert>
      <assert id="UBL-CR-282" flag="warning" test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:CorporationStockAmount)">[UBL-CR-282]-A UBL invoice should not include the PayeeParty PartyLegalEntity CorporationStockAmount</assert>
      <assert id="UBL-CR-283" flag="warning" test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:FullyPaidSharesIndicator)">[UBL-CR-283]-A UBL invoice should not include the PayeeParty PartyLegalEntity FullyPaidSharesIndicator</assert>
      <assert id="UBL-CR-284" flag="warning" test="not(cac:PayeeParty/cac:PartyLegalEntity/cac:RegistrationAddress)">[UBL-CR-284]-A UBL invoice should not include the PayeeParty PartyLegalEntity RegistrationAddress</assert>
      <assert id="UBL-CR-285" flag="warning" test="not(cac:PayeeParty/cac:PartyLegalEntity/cac:CorporateRegistrationScheme)">[UBL-CR-285]-A UBL invoice should not include the PayeeParty PartyLegalEntity CorporateRegistrationScheme</assert>
      <assert id="UBL-CR-286" flag="warning" test="not(cac:PayeeParty/cac:PartyLegalEntity/cac:HeadOfficeParty)">[UBL-CR-286]-A UBL invoice should not include the PayeeParty PartyLegalEntity HeadOfficeParty</assert>
      <assert id="UBL-CR-287" flag="warning" test="not(cac:PayeeParty/cac:PartyLegalEntity/cac:ShareholderParty)">[UBL-CR-287]-A UBL invoice should not include the PayeeParty PartyLegalEntity ShareholderParty</assert>
      <assert id="UBL-CR-288" flag="warning" test="not(cac:PayeeParty/cac:Contact)">[UBL-CR-288]-A UBL invoice should not include the PayeeParty Contact</assert>
      <assert id="UBL-CR-289" flag="warning" test="not(cac:PayeeParty/cac:Person)">[UBL-CR-289]-A UBL invoice should not include the PayeeParty Person</assert>
      <assert id="UBL-CR-290" flag="warning" test="not(cac:PayeeParty/cac:AgentParty)">[UBL-CR-290]-A UBL invoice should not include the PayeeParty AgentParty</assert>
      <assert id="UBL-CR-291" flag="warning" test="not(cac:PayeeParty/cac:ServiceProviderParty)">[UBL-CR-291]-A UBL invoice should not include the PayeeParty ServiceProviderParty</assert>
      <assert id="UBL-CR-292" flag="warning" test="not(cac:PayeeParty/cac:PowerOfAttorney)">[UBL-CR-292]-A UBL invoice should not include the PayeeParty PowerOfAttorney</assert>
      <assert id="UBL-CR-293" flag="warning" test="not(cac:PayeeParty/cac:FinancialAccount)">[UBL-CR-293]-A UBL invoice should not include the PayeeParty FinancialAccount</assert>
      <assert id="UBL-CR-294" flag="warning" test="not(cac:BuyerCustomerParty)">[UBL-CR-294]-A UBL invoice should not include the BuyerCustomerParty</assert>
      <assert id="UBL-CR-295" flag="warning" test="not(cac:SellerSupplierParty)">[UBL-CR-295]-A UBL invoice should not include the SellerSupplierParty</assert>
      <assert id="UBL-CR-296" flag="warning" test="not(cac:TaxRepresentativeParty/cbc:MarkCareIndicator)">[UBL-CR-296]-A UBL invoice should not include the TaxRepresentativeParty MarkCareIndicator</assert>
      <assert id="UBL-CR-297" flag="warning" test="not(cac:TaxRepresentativeParty/cbc:MarkAttentionIndicator)">[UBL-CR-297]-A UBL invoice should not include the TaxRepresentativeParty MarkAttentionIndicator</assert>
      <assert id="UBL-CR-298" flag="warning" test="not(cac:TaxRepresentativeParty/cbc:WebsiteURI)">[UBL-CR-298]-A UBL invoice should not include the TaxRepresentativeParty WebsiteURI</assert>
      <assert id="UBL-CR-299" flag="warning" test="not(cac:TaxRepresentativeParty/cbc:LogoReferenceID)">[UBL-CR-299]-A UBL invoice should not include the TaxRepresentativeParty LogoReferenceID</assert>
      <assert id="UBL-CR-300" flag="warning" test="not(cac:TaxRepresentativeParty/cbc:EndpointID)">[UBL-CR-300]-A UBL invoice should not include the TaxRepresentativeParty EndpointID</assert>
      <assert id="UBL-CR-301" flag="warning" test="not(cac:TaxRepresentativeParty/cbc:IndustryClassificationCode)">[UBL-CR-301]-A UBL invoice should not include the TaxRepresentativeParty IndustryClassificationCode</assert>
      <assert id="UBL-CR-302" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PartyIdentification)">[UBL-CR-302]-A UBL invoice should not include the TaxRepresentativeParty PartyIdentification</assert>
      <assert id="UBL-CR-303" flag="warning" test="not(cac:TaxRepresentativeParty/cac:Language)">[UBL-CR-303]-A UBL invoice should not include the TaxRepresentativeParty Language</assert>
      <assert id="UBL-CR-304" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:ID)">[UBL-CR-304]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress ID</assert>
      <assert id="UBL-CR-305" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:AddressTypeCode)">[UBL-CR-305]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress AddressTypeCode</assert>
      <assert id="UBL-CR-306" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:AddressFormatCode)">[UBL-CR-306]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress AddressFormatCode</assert>
      <assert id="UBL-CR-307" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:Postbox)">[UBL-CR-307]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress Postbox</assert>
      <assert id="UBL-CR-308" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:Floor)">[UBL-CR-308]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress Floor</assert>
      <assert id="UBL-CR-309" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:Room)">[UBL-CR-309]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress Room</assert>
      <assert id="UBL-CR-310" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:BlockName)">[UBL-CR-310]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress BlockName</assert>
      <assert id="UBL-CR-311" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:BuildingName)">[UBL-CR-311]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress BuildingName</assert>
      <assert id="UBL-CR-312" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:BuildingNumber)">[UBL-CR-312]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress BuildingNumber</assert>
      <assert id="UBL-CR-313" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:InhouseMail)">[UBL-CR-313]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress InhouseMail</assert>
      <assert id="UBL-CR-314" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:Department)">[UBL-CR-314]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress Department</assert>
      <assert id="UBL-CR-315" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:MarkAttention)">[UBL-CR-315]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress MarkAttention</assert>
      <assert id="UBL-CR-316" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:MarkCare)">[UBL-CR-316]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress MarkCare</assert>
      <assert id="UBL-CR-317" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:PlotIdentification)">[UBL-CR-317]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress PlotIdentification</assert>
      <assert id="UBL-CR-318" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:CitySubdivisionName)">[UBL-CR-318]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress CitySubdivisionName</assert>
      <assert id="UBL-CR-319" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:CountrySubentityCode)">[UBL-CR-319]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress CountrySubentityCode</assert>
      <assert id="UBL-CR-320" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:Region)">[UBL-CR-320]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress Region</assert>
      <assert id="UBL-CR-321" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:District)">[UBL-CR-321]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress District</assert>
      <assert id="UBL-CR-322" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:TimezoneOffset)">[UBL-CR-322]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress TimezoneOffset</assert>
      <assert id="UBL-CR-323" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cac:Country/cbc:Name)">[UBL-CR-323]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress Country Name</assert>
      <assert id="UBL-CR-324" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cac:LocationCoordinate)">[UBL-CR-324]-A UBL invoice should not include the TaxRepresentativeParty PostalAddress LocationCoordinate</assert>
      <assert id="UBL-CR-325" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PhysicalLocation)">[UBL-CR-325]-A UBL invoice should not include the TaxRepresentativeParty PhysicalLocation</assert>
      <assert id="UBL-CR-326" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cbc:RegistrationName)">[UBL-CR-326]-A UBL invoice should not include the TaxRepresentativeParty PartyTaxScheme RegistrationName</assert>
      <assert id="UBL-CR-327" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cbc:TaxLevelCode)">[UBL-CR-327]-A UBL invoice should not include the TaxRepresentativeParty PartyTaxScheme TaxLevelCode</assert>
      <assert id="UBL-CR-328" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cbc:ExemptionReasonCode)">[UBL-CR-328]-A UBL invoice should not include the TaxRepresentativeParty PartyTaxScheme ExemptionReasonCode</assert>
      <assert id="UBL-CR-329" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cbc:ExemptionReason)">[UBL-CR-329]-A UBL invoice should not include the TaxRepresentativeParty PartyTaxScheme ExemptionReason</assert>
      <assert id="UBL-CR-330" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:RegistrationAddress)">[UBL-CR-330]-A UBL invoice should not include the TaxRepresentativeParty PartyTaxScheme RegistrationAddress</assert>
      <assert id="UBL-CR-331" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:Name)">[UBL-CR-331]-A UBL invoice should not include the TaxRepresentativeParty PartyTaxScheme TaxScheme Name</assert>
      <assert id="UBL-CR-332" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:TaxTypeCode)">[UBL-CR-332]-A UBL invoice should not include the TaxRepresentativeParty PartyTaxScheme TaxScheme TaxTypeCode</assert>
      <assert id="UBL-CR-333" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:CurrencyCode)">[UBL-CR-333]-A UBL invoice should not include the TaxRepresentativeParty PartyTaxScheme TaxScheme CurrencyCode</assert>
      <assert id="UBL-CR-334" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:TaxScheme/cac:JurisdictionRegionAddress)">[UBL-CR-334]-A UBL invoice should not include the TaxRepresentativeParty PartyTaxScheme TaxScheme JurisdictionRegionAddress</assert>
      <assert id="UBL-CR-335" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PartyLegalEntity)">[UBL-CR-335]-A UBL invoice should not include the TaxRepresentativeParty PartyLegalEntity</assert>
      <assert id="UBL-CR-336" flag="warning" test="not(cac:TaxRepresentativeParty/cac:Contact)">[UBL-CR-336]-A UBL invoice should not include the TaxRepresentativeParty Contact</assert>
      <assert id="UBL-CR-337" flag="warning" test="not(cac:TaxRepresentativeParty/cac:Person)">[UBL-CR-337]-A UBL invoice should not include the TaxRepresentativeParty Person</assert>
      <assert id="UBL-CR-338" flag="warning" test="not(cac:TaxRepresentativeParty/cac:AgentParty)">[UBL-CR-338]-A UBL invoice should not include the TaxRepresentativeParty AgentParty</assert>
      <assert id="UBL-CR-339" flag="warning" test="not(cac:TaxRepresentativeParty/cac:ServiceProviderParty)">[UBL-CR-339]-A UBL invoice should not include the TaxRepresentativeParty ServiceProviderParty</assert>
      <assert id="UBL-CR-340" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PowerOfAttorney)">[UBL-CR-340]-A UBL invoice should not include the TaxRepresentativeParty PowerOfAttorney</assert>
      <assert id="UBL-CR-341" flag="warning" test="not(cac:TaxRepresentativeParty/cac:FinancialAccount)">[UBL-CR-341]-A UBL invoice should not include the TaxRepresentativeParty FinancialAccount</assert>
      <assert id="UBL-CR-342" flag="warning" test="not(cac:Delivery/cbc:ID)">[UBL-CR-342]-A UBL invoice should not include the Delivery ID</assert>
      <assert id="UBL-CR-343" flag="warning" test="not(cac:Delivery/cbc:Quantity)">[UBL-CR-343]-A UBL invoice should not include the Delivery Quantity</assert>
      <assert id="UBL-CR-344" flag="warning" test="not(cac:Delivery/cbc:MinimumQuantity)">[UBL-CR-344]-A UBL invoice should not include the Delivery MinimumQuantity</assert>
      <assert id="UBL-CR-345" flag="warning" test="not(cac:Delivery/cbc:MaximumQuantity)">[UBL-CR-345]-A UBL invoice should not include the Delivery MaximumQuantity</assert>
      <assert id="UBL-CR-346" flag="warning" test="not(cac:Delivery/cbc:ActualDeliveryTime)">[UBL-CR-346]-A UBL invoice should not include the Delivery ActualDeliveryTime</assert>
      <assert id="UBL-CR-347" flag="warning" test="not(cac:Delivery/cbc:LatestDeliveryDate)">[UBL-CR-347]-A UBL invoice should not include the Delivery LatestDeliveryDate</assert>
      <assert id="UBL-CR-348" flag="warning" test="not(cac:Delivery/cbc:LatestDeliveryTime)">[UBL-CR-348]-A UBL invoice should not include the Delivery LatestDeliveryTime</assert>
      <assert id="UBL-CR-349" flag="warning" test="not(cac:Delivery/cbc:ReleaseID)">[UBL-CR-349]-A UBL invoice should not include the Delivery ReleaseID</assert>
      <assert id="UBL-CR-350" flag="warning" test="not(cac:Delivery/cbc:TrackingID)">[UBL-CR-350]-A UBL invoice should not include the Delivery TrackingID</assert>
      <assert id="UBL-CR-351" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cbc:Description)">[UBL-CR-351]-A UBL invoice should not include the Delivery DeliveryLocation Description</assert>
      <assert id="UBL-CR-352" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cbc:Conditions)">[UBL-CR-352]-A UBL invoice should not include the Delivery DeliveryLocation Conditions</assert>
      <assert id="UBL-CR-353" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentity)">[UBL-CR-353]-A UBL invoice should not include the Delivery DeliveryLocation CountrySubentity</assert>
      <assert id="UBL-CR-354" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentityCode)">[UBL-CR-354]-A UBL invoice should not include the Delivery DeliveryLocation CountrySubentityCode</assert>
      <assert id="UBL-CR-355" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cbc:LocationTypeCode)">[UBL-CR-355]-A UBL invoice should not include the Delivery DeliveryLocation LocationTypeCode</assert>
      <assert id="UBL-CR-356" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cbc:InformationURI)">[UBL-CR-356]-A UBL invoice should not include the Delivery DeliveryLocation InformationURI</assert>
      <assert id="UBL-CR-357" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cbc:Name)">[UBL-CR-357]-A UBL invoice should not include the Delivery DeliveryLocation Name</assert>
      <assert id="UBL-CR-358" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:ValidationPeriod)">[UBL-CR-358]-A UBL invoice should not include the Delivery DeliveryLocation ValidationPeriod</assert>
      <assert id="UBL-CR-359" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:ID)">[UBL-CR-359]-A UBL invoice should not include the Delivery DeliveryLocation Address ID</assert>
      <assert id="UBL-CR-360" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AddressTypeCode)">[UBL-CR-360]-A UBL invoice should not include the Delivery DeliveryLocation Address AddressTypeCode</assert>
      <assert id="UBL-CR-361" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AddressFormatCode)">[UBL-CR-361]-A UBL invoice should not include the Delivery DeliveryLocation Address AddressFormatCode</assert>
      <assert id="UBL-CR-362" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Postbox)">[UBL-CR-362]-A UBL invoice should not include the Delivery DeliveryLocation Address Postbox</assert>
      <assert id="UBL-CR-363" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Floor)">[UBL-CR-363]-A UBL invoice should not include the Delivery DeliveryLocation Address Floor</assert>
      <assert id="UBL-CR-364" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Room)">[UBL-CR-364]-A UBL invoice should not include the Delivery DeliveryLocation Address Room</assert>
      <assert id="UBL-CR-365" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:BlockName)">[UBL-CR-365]-A UBL invoice should not include the Delivery DeliveryLocation Address BlockName</assert>
      <assert id="UBL-CR-366" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:BuildingName)">[UBL-CR-366]-A UBL invoice should not include the Delivery DeliveryLocation Address BuildingName</assert>
      <assert id="UBL-CR-367" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:BuildingNumber)">[UBL-CR-367]-A UBL invoice should not include the Delivery DeliveryLocation Address BuildingNumber</assert>
      <assert id="UBL-CR-368" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:InhouseMail)">[UBL-CR-368]-A UBL invoice should not include the Delivery DeliveryLocation Address InhouseMail</assert>
      <assert id="UBL-CR-369" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Department)">[UBL-CR-369]-A UBL invoice should not include the Delivery DeliveryLocation Address Department</assert>
      <assert id="UBL-CR-370" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:MarkAttention)">[UBL-CR-370]-A UBL invoice should not include the Delivery DeliveryLocation Address MarkAttention</assert>
      <assert id="UBL-CR-371" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:MarkCare)">[UBL-CR-371]-A UBL invoice should not include the Delivery DeliveryLocation Address MarkCare</assert>
      <assert id="UBL-CR-372" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PlotIdentification)">[UBL-CR-372]-A UBL invoice should not include the Delivery DeliveryLocation Address PlotIdentification</assert>
      <assert id="UBL-CR-373" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CitySubdivisionName)">[UBL-CR-373]-A UBL invoice should not include the Delivery DeliveryLocation Address CitySubdivisionName</assert>
      <assert id="UBL-CR-374" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CountrySubentityCode)">[UBL-CR-374]-A UBL invoice should not include the Delivery DeliveryLocation Address CountrySubentityCode</assert>
      <assert id="UBL-CR-375" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Region)">[UBL-CR-375]-A UBL invoice should not include the Delivery DeliveryLocation Address Region</assert>
      <assert id="UBL-CR-376" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:District)">[UBL-CR-376]-A UBL invoice should not include the Delivery DeliveryLocation Address District</assert>
      <assert id="UBL-CR-377" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:TimezoneOffset)">[UBL-CR-377]-A UBL invoice should not include the Delivery DeliveryLocation Address TimezoneOffset</assert>
      <assert id="UBL-CR-378" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:Name)">[UBL-CR-378]-A UBL invoice should not include the Delivery DeliveryLocation Address Country Name</assert>
      <assert id="UBL-CR-379" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:LocationCoordinate)">[UBL-CR-379]-A UBL invoice should not include the Delivery DeliveryLocation Address LocationCoordinate</assert>
      <assert id="UBL-CR-380" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:SubsidiaryLocation)">[UBL-CR-380]-A UBL invoice should not include the Delivery DeliveryLocation SubsidiaryLocation</assert>
      <assert id="UBL-CR-381" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:LocationCoordinate)">[UBL-CR-381]-A UBL invoice should not include the Delivery DeliveryLocation LocationCoordinate</assert>
      <assert id="UBL-CR-382" flag="warning" test="not(cac:Delivery/cac:AlternativeDeliveryLocation)">[UBL-CR-382]-A UBL invoice should not include the Delivery AlternativeDeliveryLocation</assert>
      <assert id="UBL-CR-383" flag="warning" test="not(cac:Delivery/cac:RequestedDeliveryPeriod)">[UBL-CR-383]-A UBL invoice should not include the Delivery RequestedDeliveryPeriod</assert>
      <assert id="UBL-CR-384" flag="warning" test="not(cac:Delivery/cac:PromisedDeliveryPeriod)">[UBL-CR-384]-A UBL invoice should not include the Delivery PromisedDeliveryPeriod</assert>
      <assert id="UBL-CR-385" flag="warning" test="not(cac:Delivery/cac:CarrierParty)">[UBL-CR-385]-A UBL invoice should not include the Delivery CarrierParty</assert>
      <assert id="UBL-CR-386" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cbc:MarkCareIndicator)">[UBL-CR-386]-A UBL invoice should not include the DeliveryParty MarkCareIndicator</assert>
      <assert id="UBL-CR-387" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cbc:MarkAttentionIndicator)">[UBL-CR-387]-A UBL invoice should not include the DeliveryParty MarkAttentionIndicator</assert>
      <assert id="UBL-CR-388" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cbc:WebsiteURI)">[UBL-CR-388]-A UBL invoice should not include the DeliveryParty WebsiteURI</assert>
      <assert id="UBL-CR-389" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cbc:LogoReferenceID)">[UBL-CR-389]-A UBL invoice should not include the DeliveryParty LogoReferenceID</assert>
      <assert id="UBL-CR-390" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cbc:EndpointID)">[UBL-CR-390]-A UBL invoice should not include the DeliveryParty EndpointID</assert>
      <assert id="UBL-CR-391" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cbc:IndustryClassificationCode)">[UBL-CR-391]-A UBL invoice should not include the DeliveryParty IndustryClassificationCode</assert>
      <assert id="UBL-CR-392" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cac:PartyIdentification)">[UBL-CR-392]-A UBL invoice should not include the DeliveryParty PartyIdentification</assert>
      <assert id="UBL-CR-393" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cac:Language)">[UBL-CR-393]-A UBL invoice should not include the DeliveryParty Language</assert>
      <assert id="UBL-CR-394" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cac:PostalAddress)">[UBL-CR-394]-A UBL invoice should not include the DeliveryParty PostalAddress</assert>
      <assert id="UBL-CR-395" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cac:PhysicalLocation)">[UBL-CR-395]-A UBL invoice should not include the DeliveryParty PhysicalLocation</assert>
      <assert id="UBL-CR-396" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cac:PartyTaxScheme)">[UBL-CR-396]-A UBL invoice should not include the DeliveryParty PartyTaxScheme</assert>
      <assert id="UBL-CR-397" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cac:PartyLegalEntity)">[UBL-CR-397]-A UBL invoice should not include the DeliveryParty PartyLegalEntity</assert>
      <assert id="UBL-CR-398" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cac:Contact)">[UBL-CR-398]-A UBL invoice should not include the DeliveryParty Contact</assert>
      <assert id="UBL-CR-399" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cac:Person)">[UBL-CR-399]-A UBL invoice should not include the DeliveryParty Person</assert>
      <assert id="UBL-CR-400" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cac:AgentParty)">[UBL-CR-400]-A UBL invoice should not include the DeliveryParty AgentParty</assert>
      <assert id="UBL-CR-401" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cac:ServiceProviderParty)">[UBL-CR-401]-A UBL invoice should not include the DeliveryParty ServiceProviderParty</assert>
      <assert id="UBL-CR-402" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cac:PowerOfAttorney)">[UBL-CR-402]-A UBL invoice should not include the DeliveryParty PowerOfAttorney</assert>
      <assert id="UBL-CR-403" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cac:FinancialAccount)">[UBL-CR-403]-A UBL invoice should not include the DeliveryParty FinancialAccount</assert>
      <assert id="UBL-CR-404" flag="warning" test="not(cac:Delivery/cac:NotifyParty)">[UBL-CR-404]-A UBL invoice should not include the Delivery NotifyParty</assert>
      <assert id="UBL-CR-405" flag="warning" test="not(cac:Delivery/cac:Despatch)">[UBL-CR-405]-A UBL invoice should not include the Delivery Despatch</assert>
      <assert id="UBL-CR-406" flag="warning" test="not(cac:Delivery/cac:DeliveryTerms)">[UBL-CR-406]-A UBL invoice should not include the Delivery DeliveryTerms</assert>
      <assert id="UBL-CR-407" flag="warning" test="not(cac:Delivery/cac:MinimumDeliveryUnit)">[UBL-CR-407]-A UBL invoice should not include the Delivery MinimumDeliveryUnit</assert>
      <assert id="UBL-CR-408" flag="warning" test="not(cac:Delivery/cac:MaximumDeliveryUnit)">[UBL-CR-408]-A UBL invoice should not include the Delivery MaximumDeliveryUnit</assert>
      <assert id="UBL-CR-409" flag="warning" test="not(cac:Delivery/cac:Shipment)">[UBL-CR-409]-A UBL invoice should not include the Delivery Shipment</assert>
      <assert id="UBL-CR-410" flag="warning" test="not(cac:DeliveryTerms)">[UBL-CR-410]-A UBL invoice should not include the DeliveryTerms</assert>
      <assert id="UBL-CR-411" flag="warning" test="not(cac:PaymentMeans/cbc:ID)">[UBL-CR-411]-A UBL invoice should not include the PaymentMeans ID</assert>
      <assert id="UBL-CR-412" flag="warning" test="not(cac:PaymentMeans/cbc:PaymentDueDate) or ../ubl-creditnote:CreditNote">[UBL-CR-412]-A UBL invoice should not include the PaymentMeans PaymentDueDate</assert>
      <assert id="UBL-CR-413" flag="warning" test="not(cac:PaymentMeans/cbc:PaymentChannelCode)">[UBL-CR-413]-A UBL invoice should not include the PaymentMeans PaymentChannelCode</assert>
      <assert id="UBL-CR-414" flag="warning" test="not(cac:PaymentMeans/cbc:InstructionID)">[UBL-CR-414]-A UBL invoice should not include the PaymentMeans InstructionID</assert>
      <assert id="UBL-CR-415" flag="warning" test="not(cac:PaymentMeans/cac:CardAccount/cbc:CardTypeCode)">[UBL-CR-415]-A UBL invoice should not include the PaymentMeans CardAccount CardTypeCode</assert>
      <assert id="UBL-CR-416" flag="warning" test="not(cac:PaymentMeans/cac:CardAccount/cbc:ValidityStartDate)">[UBL-CR-416]-A UBL invoice should not include the PaymentMeans CardAccount ValidityStartDate</assert>
      <assert id="UBL-CR-417" flag="warning" test="not(cac:PaymentMeans/cac:CardAccount/cbc:ExpiryDate)">[UBL-CR-417]-A UBL invoice should not include the PaymentMeans CardAccount ExpiryDate</assert>
      <assert id="UBL-CR-418" flag="warning" test="not(cac:PaymentMeans/cac:CardAccount/cbc:IssuerID)">[UBL-CR-418]-A UBL invoice should not include the PaymentMeans CardAccount IssuerID</assert>
      <assert id="UBL-CR-419" flag="warning" test="not(cac:PaymentMeans/cac:CardAccount/cbc:IssuerNumberID)">[UBL-CR-419]-A UBL invoice should not include the PaymentMeans CardAccount IssuerNumberID</assert>
      <assert id="UBL-CR-420" flag="warning" test="not(cac:PaymentMeans/cac:CardAccount/cbc:CV2ID)">[UBL-CR-420]-A UBL invoice should not include the PaymentMeans CardAccount CV2ID</assert>
      <assert id="UBL-CR-421" flag="warning" test="not(cac:PaymentMeans/cac:CardAccount/cbc:CardChipCode)">[UBL-CR-421]-A UBL invoice should not include the PaymentMeans CardAccount CardChipCode</assert>
      <assert id="UBL-CR-422" flag="warning" test="not(cac:PaymentMeans/cac:CardAccount/cbc:ChipApplicationID)">[UBL-CR-422]-A UBL invoice should not include the PaymentMeans CardAccount ChipApplicationID</assert>
      <assert id="UBL-CR-424" flag="warning" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:AliasName)">[UBL-CR-424]-A UBL invoice should not include the PaymentMeans PayeeFinancialAccount AliasName</assert>
      <assert id="UBL-CR-425" flag="warning" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:AccountTypeCode)">[UBL-CR-425]-A UBL invoice should not include the PaymentMeans PayeeFinancialAccount AccountTypeCode</assert>
      <assert id="UBL-CR-426" flag="warning" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:AccountFormatCode)">[UBL-CR-426]-A UBL invoice should not include the PaymentMeans PayeeFinancialAccount AccountFormatCode</assert>
      <assert id="UBL-CR-427" flag="warning" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:CurrencyCode)">[UBL-CR-427]-A UBL invoice should not include the PaymentMeans PayeeFinancialAccount CurrencyCode</assert>
      <assert id="UBL-CR-428" flag="warning" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:PaymentNote)">[UBL-CR-428]-A UBL invoice should not include the PaymentMeans PayeeFinancialAccount PaymentNote</assert>
      <assert id="UBL-CR-429" flag="warning" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:Name)">[UBL-CR-429]-A UBL invoice should not include the PaymentMeans PayeeFinancialAccount FinancialInstitutionBranch Name</assert>
      <assert id="UBL-CR-430" flag="warning" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:Name)">[UBL-CR-430]-A UBL invoice should not include the PaymentMeans PayeeFinancialAccount FinancialInstitutionBranch FinancialInstitution Name</assert>
      <assert id="UBL-CR-431" flag="warning" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cac:Address)">[UBL-CR-431]-A UBL invoice should not include the PaymentMeans PayeeFinancialAccount FinancialInstitutionBranch FinancialInstitution Address</assert>
      <assert id="UBL-CR-432" flag="warning" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:Address)">[UBL-CR-432]-A UBL invoice should not include the PaymentMeans PayeeFinancialAccount FinancialInstitutionBranch Address</assert>
      <assert id="UBL-CR-433" flag="warning" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:Country)">[UBL-CR-433]-A UBL invoice should not include the PaymentMeans PayeeFinancialAccount Country</assert>
      <assert id="UBL-CR-434" flag="warning" test="not(cac:PaymentMeans/cac:CreditAccount)">[UBL-CR-434]-A UBL invoice should not include the PaymentMeans CreditAccount</assert>
      <assert id="UBL-CR-435" flag="warning" test="not(cac:PaymentMeans/cac:PaymentMandate/cbc:MandateTypeCode)">[UBL-CR-435]-A UBL invoice should not include the PaymentMeans PaymentMandate MandateTypeCode</assert>
      <assert id="UBL-CR-436" flag="warning" test="not(cac:PaymentMeans/cac:PaymentMandate/cbc:MaximumPaymentInstructionsNumeric)">[UBL-CR-436]-A UBL invoice should not include the PaymentMeans PaymentMandate MaximumPaymentInstructionsNumeric</assert>
      <assert id="UBL-CR-437" flag="warning" test="not(cac:PaymentMeans/cac:PaymentMandate/cbc:MaximumPaidAmount)">[UBL-CR-437]-A UBL invoice should not include the PaymentMeans PaymentMandate MaximumPaidAmount</assert>
      <assert id="UBL-CR-438" flag="warning" test="not(cac:PaymentMeans/cac:PaymentMandate/cbc:SignatureID)">[UBL-CR-438]-A UBL invoice should not include the PaymentMeans PaymentMandate SignatureID</assert>
      <assert id="UBL-CR-439" flag="warning" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerParty)">[UBL-CR-439]-A UBL invoice should not include the PaymentMeans PaymentMandate PayerParty</assert>
      <assert id="UBL-CR-440" flag="warning" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:Name)">[UBL-CR-440]-A UBL invoice should not include the PaymentMeans PaymentMandate PayerFinancialAccount Name</assert>
      <assert id="UBL-CR-441" flag="warning" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:AliasName)">[UBL-CR-441]-A UBL invoice should not include the PaymentMeans PaymentMandate PayerFinancialAccount AliasName</assert>
      <assert id="UBL-CR-442" flag="warning" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:AccountTypeCode)">[UBL-CR-442]-A UBL invoice should not include the PaymentMeans PaymentMandate PayerFinancialAccount AccountTypeCode</assert>
      <assert id="UBL-CR-443" flag="warning" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:AccountFormatCode)">[UBL-CR-443]-A UBL invoice should not include the PaymentMeans PaymentMandate PayerFinancialAccount AccountFormatCode</assert>
      <assert id="UBL-CR-444" flag="warning" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:CurrencyCode)">[UBL-CR-444]-A UBL invoice should not include the PaymentMeans PaymentMandate PayerFinancialAccount CurrencyCode</assert>
      <assert id="UBL-CR-445" flag="warning" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:PaymentNote)">[UBL-CR-445]-A UBL invoice should not include the PaymentMeans PaymentMandate PayerFinancialAccount PaymentNote</assert>
      <assert id="UBL-CR-446" flag="warning" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cac:FinancialInstitutionBranch)">[UBL-CR-446]-A UBL invoice should not include the PaymentMeans PaymentMandate PayerFinancialAccount FinancialInstitutionBranch</assert>
      <assert id="UBL-CR-447" flag="warning" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cac:Country)">[UBL-CR-447]-A UBL invoice should not include the PaymentMeans PaymentMandate PayerFinancialAccount Country</assert>
      <assert id="UBL-CR-448" flag="warning" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:ValidityPeriod)">[UBL-CR-448]-A UBL invoice should not include the PaymentMeans PaymentMandate ValidityPeriod</assert>
      <assert id="UBL-CR-449" flag="warning" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PaymentReversalPeriod)">[UBL-CR-449]-A UBL invoice should not include the PaymentMeans PaymentMandate PaymentReversalPeriod</assert>
      <assert id="UBL-CR-450" flag="warning" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:Clause)">[UBL-CR-450]-A UBL invoice should not include the PaymentMeans PaymentMandate Clause</assert>
      <assert id="UBL-CR-451" flag="warning" test="not(cac:PaymentMeans/cac:TradeFinancing)">[UBL-CR-451]-A UBL invoice should not include the PaymentMeans TradeFinancing</assert>
      <assert id="UBL-CR-452" flag="warning" test="not(cac:PaymentTerms/cbc:ID)">[UBL-CR-452]-A UBL invoice should not include the PaymentTerms ID</assert>
      <assert id="UBL-CR-453" flag="warning" test="not(cac:PaymentTerms/cbc:PaymentMeansID)">[UBL-CR-453]-A UBL invoice should not include the PaymentTerms PaymentMeansID</assert>
      <assert id="UBL-CR-454" flag="warning" test="not(cac:PaymentTerms/cbc:PrepaidPaymentReferenceID)">[UBL-CR-454]-A UBL invoice should not include the PaymentTerms PrepaidPaymentReferenceID</assert>
      <assert id="UBL-CR-455" flag="warning" test="not(cac:PaymentTerms/cbc:ReferenceEventCode)">[UBL-CR-455]-A UBL invoice should not include the PaymentTerms ReferenceEventCode</assert>
      <assert id="UBL-CR-456" flag="warning" test="not(cac:PaymentTerms/cbc:SettlementDiscountPercent)">[UBL-CR-456]-A UBL invoice should not include the PaymentTerms SettlementDiscountPercent</assert>
      <assert id="UBL-CR-457" flag="warning" test="not(cac:PaymentTerms/cbc:PenaltySurchargePercent)">[UBL-CR-457]-A UBL invoice should not include the PaymentTerms PenaltySurchargePercent</assert>
      <assert id="UBL-CR-458" flag="warning" test="not(cac:PaymentTerms/cbc:PaymentPercent)">[UBL-CR-458]-A UBL invoice should not include the PaymentTerms PaymentPercent</assert>
      <assert id="UBL-CR-459" flag="warning" test="not(cac:PaymentTerms/cbc:Amount)">[UBL-CR-459]-A UBL invoice should not include the PaymentTerms Amount</assert>
      <assert id="UBL-CR-460" flag="warning" test="not(cac:PaymentTerms/cbc:SettlementDiscountAmount)">[UBL-CR-460]-A UBL invoice should not include the PaymentTerms SettlementDiscountAmount</assert>
      <assert id="UBL-CR-461" flag="warning" test="not(cac:PaymentTerms/cbc:PenaltyAmount)">[UBL-CR-461]-A UBL invoice should not include the PaymentTerms PenaltyAmount</assert>
      <assert id="UBL-CR-462" flag="warning" test="not(cac:PaymentTerms/cbc:PaymentTermsDetailsURI)">[UBL-CR-462]-A UBL invoice should not include the PaymentTerms PaymentTermsDetailsURI</assert>
      <assert id="UBL-CR-463" flag="warning" test="not(cac:PaymentTerms/cbc:PaymentDueDate)">[UBL-CR-463]-A UBL invoice should not include the PaymentTerms PaymentDueDate</assert>
      <assert id="UBL-CR-464" flag="warning" test="not(cac:PaymentTerms/cbc:InstallmentDueDate)">[UBL-CR-464]-A UBL invoice should not include the PaymentTerms InstallmentDueDate</assert>
      <assert id="UBL-CR-465" flag="warning" test="not(cac:PaymentTerms/cbc:InvoicingPartyReference)">[UBL-CR-465]-A UBL invoice should not include the PaymentTerms InvoicingPartyReference</assert>
      <assert id="UBL-CR-466" flag="warning" test="not(cac:PaymentTerms/cac:SettlementPeriod)">[UBL-CR-466]-A UBL invoice should not include the PaymentTerms SettlementPeriod</assert>
      <assert id="UBL-CR-467" flag="warning" test="not(cac:PaymentTerms/cac:PenaltyPeriod)">[UBL-CR-467]-A UBL invoice should not include the PaymentTerms PenaltyPeriod</assert>
      <assert id="UBL-CR-468" flag="warning" test="not(cac:PaymentTerms/cac:ExchangeRate)">[UBL-CR-468]-A UBL invoice should not include the PaymentTerms ExchangeRate</assert>
      <assert id="UBL-CR-469" flag="warning" test="not(cac:PaymentTerms/cac:ValidityPeriod)">[UBL-CR-469]-A UBL invoice should not include the PaymentTerms ValidityPeriod</assert>
      <assert id="UBL-CR-470" flag="warning" test="not(cac:PrepaidPayment)">[UBL-CR-470]-A UBL invoice should not include the PrepaidPayment</assert>
      <assert id="UBL-CR-471" flag="warning" test="not(cac:AllowanceCharge/cbc:ID)">[UBL-CR-471]-A UBL invoice should not include the AllowanceCharge ID</assert>
      <assert id="UBL-CR-472" flag="warning" test="not(cac:AllowanceCharge/cbc:PrepaidIndicator)">[UBL-CR-472]-A UBL invoice should not include the AllowanceCharge PrepaidIndicator</assert>
      <assert id="UBL-CR-473" flag="warning" test="not(cac:AllowanceCharge/cbc:SequenceNumeric)">[UBL-CR-473]-A UBL invoice should not include the AllowanceCharge SequenceNumeric</assert>
      <assert id="UBL-CR-474" flag="warning" test="not(cac:AllowanceCharge/cbc:AccountingCostCode)">[UBL-CR-474]-A UBL invoice should not include the AllowanceCharge AccountingCostCode</assert>
      <assert id="UBL-CR-475" flag="warning" test="not(cac:AllowanceCharge/cbc:AccountingCost)">[UBL-CR-475]-A UBL invoice should not include the AllowanceCharge AccountingCost</assert>
      <assert id="UBL-CR-476" flag="warning" test="not(cac:AllowanceCharge/cbc:PerUnitAmount)">[UBL-CR-476]-A UBL invoice should not include the AllowanceCharge PerUnitAmount</assert>
      <assert id="UBL-CR-477" flag="warning" test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:Name)">[UBL-CR-477]-A UBL invoice should not include the AllowanceCharge TaxCategory Name</assert>
      <assert id="UBL-CR-478" flag="warning" test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:BaseUnitMeasure)">[UBL-CR-478]-A UBL invoice should not include the AllowanceCharge TaxCategory BaseUnitMeasure</assert>
      <assert id="UBL-CR-479" flag="warning" test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:PerUnitAmount)">[UBL-CR-479]-A UBL invoice should not include the AllowanceCharge TaxCategory PerUnitAmount</assert>
      <assert id="UBL-CR-480" flag="warning" test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReasonCode)">[UBL-CR-480]-A UBL invoice should not include the AllowanceCharge TaxCategory TaxExemptionReasonCode</assert>
      <assert id="UBL-CR-481" flag="warning" test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReason)">[UBL-CR-481]-A UBL invoice should not include the AllowanceCharge TaxCategory TaxExemptionReason</assert>
      <assert id="UBL-CR-482" flag="warning" test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:TierRange)">[UBL-CR-482]-A UBL invoice should not include the AllowanceCharge TaxCategory TierRange</assert>
      <assert id="UBL-CR-483" flag="warning" test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:TierRatePercent)">[UBL-CR-483]-A UBL invoice should not include the AllowanceCharge TaxCategory TierRatePercent</assert>
      <assert id="UBL-CR-484" flag="warning" test="not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:Name)">[UBL-CR-484]-A UBL invoice should not include the AllowanceCharge TaxCategory TaxScheme Name</assert>
      <assert id="UBL-CR-485" flag="warning" test="not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode)">[UBL-CR-485]-A UBL invoice should not include the AllowanceCharge TaxCategory TaxScheme TaxTypeCode</assert>
      <assert id="UBL-CR-486" flag="warning" test="not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode)">[UBL-CR-486]-A UBL invoice should not include the AllowanceCharge TaxCategory TaxScheme CurrencyCode</assert>
      <assert id="UBL-CR-487" flag="warning" test="not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cac:JurisdiccionRegionAddress)">[UBL-CR-487]-A UBL invoice should not include the AllowanceCharge TaxCategory TaxScheme JurisdiccionRegionAddress</assert>
      <assert id="UBL-CR-488" flag="warning" test="not(cac:AllowanceCharge/cac:TaxTotal)">[UBL-CR-488]-A UBL invoice should not include the AllowanceCharge TaxTotal</assert>
      <assert id="UBL-CR-489" flag="warning" test="not(cac:AllowanceCharge/cac:PaymentMeans)">[UBL-CR-489]-A UBL invoice should not include the AllowanceCharge PaymentMeans</assert>
      <assert id="UBL-CR-490" flag="warning" test="not(cac:TaxExchangeRate)">[UBL-CR-490]-A UBL invoice should not include the TaxExchangeRate</assert>
      <assert id="UBL-CR-491" flag="warning" test="not(cac:PricingExchangeRate)">[UBL-CR-491]-A UBL invoice should not include the PricingExchangeRate</assert>
      <assert id="UBL-CR-492" flag="warning" test="not(cac:PaymentExchangeRate)">[UBL-CR-492]-A UBL invoice should not include the PaymentExchangeRate</assert>
      <assert id="UBL-CR-493" flag="warning" test="not(cac:PaymentAlternativeExchangeRate)">[UBL-CR-493]-A UBL invoice should not include the PaymentAlternativeExchangeRate</assert>
      <assert id="UBL-CR-494" flag="warning" test="not(cac:TaxTotal/cbc:RoundingAmount)">[UBL-CR-494]-A UBL invoice should not include the TaxTotal RoundingAmount</assert>
      <assert id="UBL-CR-495" flag="warning" test="not(cac:TaxTotal/cbc:TaxEvidenceIndicator)">[UBL-CR-495]-A UBL invoice should not include the TaxTotal TaxEvidenceIndicator</assert>
      <assert id="UBL-CR-496" flag="warning" test="not(cac:TaxTotal/cbc:TaxIncludedIndicator)">[UBL-CR-496]-A UBL invoice should not include the TaxTotal TaxIncludedIndicator</assert>
      <assert id="UBL-CR-497" flag="warning" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:CalculationSequenceNumeric)">[UBL-CR-497]-A UBL invoice should not include the TaxTotal TaxSubtotal CalulationSequenceNumeric</assert>
      <assert id="UBL-CR-498" flag="warning" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:TransactionCurrencyTaxAmount)">[UBL-CR-498]-A UBL invoice should not include the TaxTotal TaxSubtotal TransactionCurrencyTaxAmount</assert>
      <assert id="UBL-CR-499" flag="warning" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:Percent)">[UBL-CR-499]-A UBL invoice should not include the TaxTotal TaxSubtotal Percent</assert>
      <assert id="UBL-CR-500" flag="warning" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:BaseUnitMeasure)">[UBL-CR-500]-A UBL invoice should not include the TaxTotal TaxSubtotal BaseUnitMeasure</assert>
      <assert id="UBL-CR-501" flag="warning" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:PerUnitAmount)">[UBL-CR-501]-A UBL invoice should not include the TaxTotal TaxSubtotal PerUnitAmount</assert>
      <assert id="UBL-CR-502" flag="warning" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:TierRange)">[UBL-CR-502]-A UBL invoice should not include the TaxTotal TaxSubtotal TierRange</assert>
      <assert id="UBL-CR-503" flag="warning" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:TierRatePercent)">[UBL-CR-503]-A UBL invoice should not include the TaxTotal TaxSubtotal TierRatePercent</assert>
      <assert id="UBL-CR-504" flag="warning" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:Name)">[UBL-CR-504]-A UBL invoice should not include the TaxTotal TaxSubtotal TaxCategory Name</assert>
      <assert id="UBL-CR-505" flag="warning" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:BaseUnitMeasure)">[UBL-CR-505]-A UBL invoice should not include the TaxTotal TaxSubtotal TaxCategory BaseUnitMeasure</assert>
      <assert id="UBL-CR-506" flag="warning" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:PerUnitAmount)">[UBL-CR-506]-A UBL invoice should not include the TaxTotal TaxSubtotal TaxCategory PerUnitAmount</assert>
      <assert id="UBL-CR-507" flag="warning" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TierRange)">[UBL-CR-507]-A UBL invoice should not include the TaxTotal TaxSubtotal TaxCategory TierRange</assert>
      <assert id="UBL-CR-508" flag="warning" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TierRatePercent)">[UBL-CR-508]-A UBL invoice should not include the TaxTotal TaxSubtotal TaxCategory TierRatePercent</assert>
      <assert id="UBL-CR-509" flag="warning" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:Name)">[UBL-CR-509]-A UBL invoice should not include the TaxTotal TaxSubtotal TaxCategory TaxScheme Name</assert>
      <assert id="UBL-CR-510" flag="warning" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode)">[UBL-CR-510]-A UBL invoice should not include the TaxTotal TaxSubtotal TaxCategory TaxScheme TaxTypeCode</assert>
      <assert id="UBL-CR-511" flag="warning" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode)">[UBL-CR-511]-A UBL invoice should not include the TaxTotal TaxSubtotal TaxCategory TaxScheme CurrencyCode</assert>
      <assert id="UBL-CR-512" flag="warning" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cac:JurisdiccionRegionAddress)">[UBL-CR-512]-A UBL invoice should not include the TaxTotal TaxSubtotal TaxCategory TaxScheme JurisdiccionRegionAddress</assert>
      <assert id="UBL-CR-513" flag="warning" test="not(cac:WithholdingTaxTotal)">[UBL-CR-513]-A UBL invoice should not include the WithholdingTaxTotal</assert>
      <assert id="UBL-CR-514" flag="warning" test="not(cac:LegalMonetaryTotal/cbc:PayableAlternativeAmount)">[UBL-CR-514]-A UBL invoice should not include the LegalMonetaryTotal PayableAlternativeAmount</assert>
      <assert id="UBL-CR-515" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cbc:UUID)">[UBL-CR-515]-A UBL invoice should not include the InvoiceLine UUID</assert>
      <assert id="UBL-CR-516" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cbc:TaxPointDate)">[UBL-CR-516]-A UBL invoice should not include the InvoiceLine TaxPointDate</assert>
      <assert id="UBL-CR-517" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cbc:AccountingCostCode)">[UBL-CR-517]-A UBL invoice should not include the InvoiceLine AccountingCostCode</assert>
      <assert id="UBL-CR-518" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cbc:PaymentPurposeCode)">[UBL-CR-518]-A UBL invoice should not include the InvoiceLine PaymentPurposeCode</assert>
      <assert id="UBL-CR-519" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cbc:FreeOfChargeIndicator)">[UBL-CR-519]-A UBL invoice should not include the InvoiceLine FreeOfChargeIndicator</assert>
      <assert id="UBL-CR-520" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:InvoicePeriod/cbc:StartTime)">[UBL-CR-520]-A UBL invoice should not include the InvoiceLine InvoicePeriod StartTime</assert>
      <assert id="UBL-CR-521" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:InvoicePeriod/cbc:EndTime)">[UBL-CR-521]-A UBL invoice should not include the InvoiceLine InvoicePeriod EndTime</assert>
      <assert id="UBL-CR-522" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:InvoicePeriod/cbc:DurationMeasure)">[UBL-CR-522]-A UBL invoice should not include the InvoiceLine InvoicePeriod DurationMeasure</assert>
      <assert id="UBL-CR-523" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:InvoicePeriod/cbc:DescriptionCode)">[UBL-CR-523]-A UBL invoice should not include the InvoiceLine InvoicePeriod DescriptionCode</assert>
      <assert id="UBL-CR-524" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:InvoicePeriod/cbc:Description)">[UBL-CR-524]-A UBL invoice should not include the InvoiceLine InvoicePeriod Description</assert>
      <assert id="UBL-CR-525" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:OrderLineReference/cbc:SalesOrderLineID)">[UBL-CR-525]-A UBL invoice should not include the InvoiceLine OrderLineReference SalesOrderLineID</assert>
      <assert id="UBL-CR-526" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:OrderLineReference/cbc:UUID)">[UBL-CR-526]-A UBL invoice should not include the InvoiceLine OrderLineReference UUID</assert>
      <assert id="UBL-CR-527" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:OrderLineReference/cbc:LineStatusCode)">[UBL-CR-527]-A UBL invoice should not include the InvoiceLine OrderLineReference LineStatusCode</assert>
      <assert id="UBL-CR-528" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:OrderLineReference/cac:OrderReference)">[UBL-CR-528]-A UBL invoice should not include the InvoiceLine OrderLineReference OrderReference</assert>
      <assert id="UBL-CR-529" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DespatchLineReference)">[UBL-CR-529]-A UBL invoice should not include the InvoiceLine DespatchLineReference</assert>
      <assert id="UBL-CR-530" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:ReceiptLineReference)">[UBL-CR-530]-A UBL invoice should not include the InvoiceLine ReceiptLineReference</assert>
      <assert id="UBL-CR-531" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:BillingReference)">[UBL-CR-531]-A UBL invoice should not include the InvoiceLine BillingReference</assert>
      <assert id="UBL-CR-532" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:CopyIndicator)">[UBL-CR-532]-A UBL invoice should not include the InvoiceLine DocumentReference CopyIndicator</assert>
      <assert id="UBL-CR-533" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:UUID)">[UBL-CR-533]-A UBL invoice should not include the InvoiceLine DocumentReference UUID</assert>
      <assert id="UBL-CR-534" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:IssueDate)">[UBL-CR-534]-A UBL invoice should not include the InvoiceLine DocumentReference IssueDate</assert>
      <assert id="UBL-CR-535" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:IssueTime)">[UBL-CR-535]-A UBL invoice should not include the InvoiceLine DocumentReference IssueTime</assert>
      <assert id="UBL-CR-537" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:DocumentType)">[UBL-CR-537]-A UBL invoice should not include the InvoiceLine DocumentReference DocumentType</assert>
      <assert id="UBL-CR-538" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:Xpath)">[UBL-CR-538]-A UBL invoice should not include the InvoiceLine DocumentReference Xpath</assert>
      <assert id="UBL-CR-539" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:LanguageID)">[UBL-CR-539]-A UBL invoice should not include the InvoiceLine DocumentReference LanguageID</assert>
      <assert id="UBL-CR-540" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:LocaleCode)">[UBL-CR-540]-A UBL invoice should not include the InvoiceLine DocumentReference LocaleCode</assert>
      <assert id="UBL-CR-541" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:VersionID)">[UBL-CR-541]-A UBL invoice should not include the InvoiceLine DocumentReference VersionID</assert>
      <assert id="UBL-CR-542" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:DocumentStatusCode)">[UBL-CR-542]-A UBL invoice should not include the InvoiceLine DocumentReference DocumentStatusCode</assert>
      <assert id="UBL-CR-543" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:DocumentDescription)">[UBL-CR-543]-A UBL invoice should not include the InvoiceLine DocumentReference DocumentDescription</assert>
      <assert id="UBL-CR-544" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cac:Attachment)">[UBL-CR-544]-A UBL invoice should not include the InvoiceLine DocumentReference Attachment</assert>
      <assert id="UBL-CR-545" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cac:ValidityPeriod)">[UBL-CR-545]-A UBL invoice should not include the InvoiceLine DocumentReference ValidityPeriod</assert>
      <assert id="UBL-CR-546" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cac:IssuerParty)">[UBL-CR-546]-A UBL invoice should not include the InvoiceLine DocumentReference IssuerParty</assert>
      <assert id="UBL-CR-547" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cac:ResultOfVerification)">[UBL-CR-547]-A UBL invoice should not include the InvoiceLine DocumentReference ResultOfVerification</assert>
      <assert id="UBL-CR-548" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:PricingReference)">[UBL-CR-548]-A UBL invoice should not include the InvoiceLine PricingReference</assert>
      <assert id="UBL-CR-549" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:OriginatorParty)">[UBL-CR-549]-A UBL invoice should not include the InvoiceLine OriginatorParty</assert>
      <assert id="UBL-CR-550" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Delivery)">[UBL-CR-550]-A UBL invoice should not include the InvoiceLine Delivery</assert>
      <assert id="UBL-CR-551" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:PaymentTerms)">[UBL-CR-551]-A UBL invoice should not include the InvoiceLine PaymentTerms</assert>
      <assert id="UBL-CR-552" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cbc:ID)">[UBL-CR-552]-A UBL invoice should not include the InvoiceLine AllowanceCharge ID</assert>
      <assert id="UBL-CR-553" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cbc:PrepaidIndicator)">[UBL-CR-553]-A UBL invoice should not include the InvoiceLine AllowanceCharge PrepaidIndicator</assert>
      <assert id="UBL-CR-554" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cbc:SequenceNumeric)">[UBL-CR-554]-A UBL invoice should not include the InvoiceLine AllowanceCharge SequenceNumeric</assert>
      <assert id="UBL-CR-555" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cbc:AccountingCostCode)">[UBL-CR-555]-A UBL invoice should not include the InvoiceLine AllowanceCharge AccountingCostCode</assert>
      <assert id="UBL-CR-556" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cbc:AccountingCost)">[UBL-CR-556]-A UBL invoice should not include the InvoiceLine AllowanceCharge AccountingCost</assert>
      <assert id="UBL-CR-557" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cbc:PerUnitAmount)">[UBL-CR-557]-A UBL invoice should not include the InvoiceLine AllowanceCharge PerUnitAmount</assert>
      <assert id="UBL-CR-558" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cac:TaxCategory)">[UBL-CR-558]-A UBL invoice should not include the InvoiceLine AllowanceCharge TaxCategory</assert>
      <assert id="UBL-CR-559" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cac:TaxTotal)">[UBL-CR-559]-A UBL invoice should not include the InvoiceLine AllowanceCharge TaxTotal</assert>
      <assert id="UBL-CR-560" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cac:PaymentMeans)">[UBL-CR-560]-A UBL invoice should not include the InvoiceLine AllowanceCharge PaymentMeans</assert>
      <assert id="UBL-CR-561" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:TaxTotal)">[UBL-CR-561]-A UBL invoice should not include the InvoiceLine TaxTotal</assert>
      <assert id="UBL-CR-562" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:WithholdingTaxTotal)">[UBL-CR-562]-A UBL invoice should not include the InvoiceLine WithholdingTaxTotal</assert>
      <assert id="UBL-CR-563" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cbc:PackQuantity)">[UBL-CR-563]-A UBL invoice should not include the InvoiceLine Item PackQuantity</assert>
      <assert id="UBL-CR-564" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cbc:PackSizeNumeric)">[UBL-CR-564]-A UBL invoice should not include the InvoiceLine Item PackSizeNumeric</assert>
      <assert id="UBL-CR-565" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cbc:CatalogueIndicator)">[UBL-CR-565]-A UBL invoice should not include the InvoiceLine Item CatalogueIndicator</assert>
      <assert id="UBL-CR-566" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cbc:HazardousRiskIndicator)">[UBL-CR-566]-A UBL invoice should not include the InvoiceLine Item HazardousRiskIndicator</assert>
      <assert id="UBL-CR-567" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cbc:AdditionalInformation)">[UBL-CR-567]-A UBL invoice should not include the InvoiceLine Item AdditionalInformation</assert>
      <assert id="UBL-CR-568" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cbc:Keyword)">[UBL-CR-568]-A UBL invoice should not include the InvoiceLine Item Keyword</assert>
      <assert id="UBL-CR-569" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cbc:BrandName)">[UBL-CR-569]-A UBL invoice should not include the InvoiceLine Item BrandName</assert>
      <assert id="UBL-CR-570" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cbc:ModelName)">[UBL-CR-570]-A UBL invoice should not include the InvoiceLine Item ModelName</assert>
      <assert id="UBL-CR-571" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:BuyersItemIdentification/cbc:ExtendedID)">[UBL-CR-571]-A UBL invoice should not include the InvoiceLine Item BuyersItemIdentification ExtendedID</assert>
      <assert id="UBL-CR-572" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:BuyersItemIdentification/cbc:BareCodeSymbologyID)">[UBL-CR-572]-A UBL invoice should not include the InvoiceLine Item BuyersItemIdentification BareCodeSymbologyID</assert>
      <assert id="UBL-CR-573" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:BuyersItemIdentification/cac:PhysicalAttribute)">[UBL-CR-573]-A UBL invoice should not include the InvoiceLine Item BuyersItemIdentification PhysicalAttribute</assert>
      <assert id="UBL-CR-574" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:BuyersItemIdentification/cac:MeasurementDimension)">[UBL-CR-574]-A UBL invoice should not include the InvoiceLine Item BuyersItemIdentification MeasurementDimension</assert>
      <assert id="UBL-CR-575" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:BuyersItemIdentification/cac:IssuerParty)">[UBL-CR-575]-A UBL invoice should not include the InvoiceLine Item BuyersItemIdentification IssuerParty</assert>
      <assert id="UBL-CR-576" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:SellersItemIdentification/cbc:ExtendedID)">[UBL-CR-576]-A UBL invoice should not include the InvoiceLine Item SellersItemIdentification ExtendedID</assert>
      <assert id="UBL-CR-577" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:SellersItemIdentification/cbc:BareCodeSymbologyID)">[UBL-CR-577]-A UBL invoice should not include the InvoiceLine Item SellersItemIdentification BareCodeSymbologyID</assert>
      <assert id="UBL-CR-578" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:SellersItemIdentification/cac:PhysicalAttribute)">[UBL-CR-578]-A UBL invoice should not include the InvoiceLine Item SellersItemIdentification PhysicalAttribute</assert>
      <assert id="UBL-CR-579" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:SellersItemIdentification/cac:MeasurementDimension)">[UBL-CR-579]-A UBL invoice should not include the InvoiceLine Item SellersItemIdentification MeasurementDimension</assert>
      <assert id="UBL-CR-580" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:SellersItemIdentification/cac:IssuerParty)">[UBL-CR-580]-A UBL invoice should not include the InvoiceLine Item SellersItemIdentification IssuerParty</assert>
      <assert id="UBL-CR-581" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ManufacturersItemIdentification)">[UBL-CR-581]-A UBL invoice should not include the InvoiceLine Item ManufacturersItemIdentification</assert>
      <assert id="UBL-CR-582" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:StandardItemIdentification/cbc:ExtendedID)">[UBL-CR-582]-A UBL invoice should not include the InvoiceLine Item StandardItemIdentification ExtendedID</assert>
      <assert id="UBL-CR-583" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:StandardItemIdentification/cbc:BareCodeSymbologyID)">[UBL-CR-583]-A UBL invoice should not include the InvoiceLine Item StandardItemIdentification BareCodeSymbologyID</assert>
      <assert id="UBL-CR-584" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:StandardItemIdentification/cac:PhysicalAttribute)">[UBL-CR-584]-A UBL invoice should not include the InvoiceLine Item StandardItemIdentification PhysicalAttribute</assert>
      <assert id="UBL-CR-585" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:StandardItemIdentification/cac:MeasurementDimension)">[UBL-CR-585]-A UBL invoice should not include the InvoiceLine Item StandardItemIdentification MeasurementDimension</assert>
      <assert id="UBL-CR-586" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:StandardItemIdentification/cac:IssuerParty)">[UBL-CR-586]-A UBL invoice should not include the InvoiceLine Item StandardItemIdentification IssuerParty</assert>
      <assert id="UBL-CR-587" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:CatalogueItemIdentification)">[UBL-CR-587]-A UBL invoice should not include the InvoiceLine Item CatalogueItemIdentification</assert>
      <assert id="UBL-CR-588" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemIdentification)">[UBL-CR-588]-A UBL invoice should not include the InvoiceLine Item AdditionalItemIdentification</assert>
      <assert id="UBL-CR-589" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:CatalogueDocumentReference)">[UBL-CR-589]-A UBL invoice should not include the InvoiceLine Item CatalogueDocumentReference</assert>
      <assert id="UBL-CR-590" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ItemSpecificationDocumentReference)">[UBL-CR-590]-A UBL invoice should not include the InvoiceLine Item ItemSpecificationDocumentReference</assert>
      <assert id="UBL-CR-591" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:OriginCountry/cbc:Name)">[UBL-CR-591]-A UBL invoice should not include the InvoiceLine Item OriginCountry Name</assert>
      <assert id="UBL-CR-592" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:CommodityClassification/cbc:NatureCode)">[UBL-CR-592]-A UBL invoice should not include the InvoiceLine Item CommodityClassification NatureCode</assert>
      <assert id="UBL-CR-593" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:CommodityClassification/cbc:CargoTypeCode)">[UBL-CR-593]-A UBL invoice should not include the InvoiceLine Item CommodityClassification CargoTypeCode</assert>
      <assert id="UBL-CR-594" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:CommodityClassification/cbc:CommodityCode)">[UBL-CR-594]-A UBL invoice should not include the InvoiceLine Item CommodityClassification CommodityCode</assert>
      <assert id="UBL-CR-595" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:TransactionConditions)">[UBL-CR-595]-A UBL invoice should not include the InvoiceLine Item TransactionConditions</assert>
      <assert id="UBL-CR-596" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:HazardousItem)">[UBL-CR-596]-A UBL invoice should not include the InvoiceLine Item HazardousItem</assert>
      <assert id="UBL-CR-597" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cbc:Name)">[UBL-CR-597]-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory Name</assert>
      <assert id="UBL-CR-598" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cbc:BaseUnitMeasure)">[UBL-CR-598]-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory BaseUnitMeasure</assert>
      <assert id="UBL-CR-599" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cbc:PerUnitAmount)">[UBL-CR-599]-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory PerUnitAmount</assert>
      <assert id="UBL-CR-600" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cbc:TaxExemptionReasonCode)">[UBL-CR-600]-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory TaxExemptionReasonCode</assert>
      <assert id="UBL-CR-601" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cbc:TaxExemptionReason)">[UBL-CR-601]-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory TaxExemptionReason</assert>
      <assert id="UBL-CR-602" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cbc:TierRange)">[UBL-CR-602]-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory TierRange</assert>
      <assert id="UBL-CR-603" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cbc:TierRatePercent)">[UBL-CR-603]-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory TierRatePercent</assert>
      <assert id="UBL-CR-604" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:Name)">[UBL-CR-604]-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory TaxScheme Name</assert>
      <assert id="UBL-CR-605" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:TaxTypeCode)">[UBL-CR-605]-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory TaxScheme TaxTypeCode</assert>
      <assert id="UBL-CR-606" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:CurrencyCode)">[UBL-CR-606]-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory TaxScheme CurrencyCode</assert>
      <assert id="UBL-CR-607" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cac:JurisdiccionRegionAddress)">[UBL-CR-607]-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory TaxScheme JurisdiccionRegionAddress</assert>
      <assert id="UBL-CR-608" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cbc:ID)">[UBL-CR-608]-A UBL invoice should not include the InvoiceLine Item AdditionalItemProperty ID</assert>
      <assert id="UBL-CR-609" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cbc:NameCode)">[UBL-CR-609]-A UBL invoice should not include the InvoiceLine Item AdditionalItemProperty NameCode</assert>
      <assert id="UBL-CR-610" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cbc:TestMethod)">[UBL-CR-610]-A UBL invoice should not include the InvoiceLine Item AdditionalItemProperty TestMethod</assert>
      <assert id="UBL-CR-611" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cbc:ValueQuantity)">[UBL-CR-611]-A UBL invoice should not include the InvoiceLine Item AdditionalItemProperty ValueQuantity</assert>
      <assert id="UBL-CR-612" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cbc:ValueQualifier)">[UBL-CR-612]-A UBL invoice should not include the InvoiceLine Item AdditionalItemProperty ValueQualifier</assert>
      <assert id="UBL-CR-613" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cbc:ImportanceCode)">[UBL-CR-613]-A UBL invoice should not include the InvoiceLine Item AdditionalItemProperty ImportanceCode</assert>
      <assert id="UBL-CR-614" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cbc:ListValue)">[UBL-CR-614]-A UBL invoice should not include the InvoiceLine Item AdditionalItemProperty ListValue</assert>
      <assert id="UBL-CR-615" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cac:UsabilityPeriod)">[UBL-CR-615]-A UBL invoice should not include the InvoiceLine Item AdditionalItemProperty UsabilityPeriod</assert>
      <assert id="UBL-CR-616" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cac:ItemPropertyGroup)">[UBL-CR-616]-A UBL invoice should not include the InvoiceLine Item AdditionalItemProperty ItemPropertyGroup</assert>
      <assert id="UBL-CR-617" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cac:RangeDimension)">[UBL-CR-617]-A UBL invoice should not include the InvoiceLine Item AdditionalItemProperty RangeDimension</assert>
      <assert id="UBL-CR-618" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cac:ItemPropertyRange)">[UBL-CR-618]-A UBL invoice should not include the InvoiceLine Item AdditionalItemProperty ItemPropertyRange</assert>
      <assert id="UBL-CR-619" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ManufacturerParty)">[UBL-CR-619]-A UBL invoice should not include the InvoiceLine Item ManufacturerParty</assert>
      <assert id="UBL-CR-620" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:InformationContentProviderParty)">[UBL-CR-620]-A UBL invoice should not include the InvoiceLine Item InformationContentProviderParty</assert>
      <assert id="UBL-CR-621" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:OriginAddress)">[UBL-CR-621]-A UBL invoice should not include the InvoiceLine Item OriginAddress</assert>
      <assert id="UBL-CR-622" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ItemInstance)">[UBL-CR-622]-A UBL invoice should not include the InvoiceLine Item ItemInstance</assert>
      <assert id="UBL-CR-623" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Certificate)">[UBL-CR-623]-A UBL invoice should not include the InvoiceLine Item Certificate</assert>
      <assert id="UBL-CR-624" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Dimension)">[UBL-CR-624]-A UBL invoice should not include the InvoiceLine Item Dimension</assert>
      <assert id="UBL-CR-625" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cbc:PriceChangeReason)">[UBL-CR-625]-A UBL invoice should not include the InvoiceLine Item Price PriceChangeReason</assert>
      <assert id="UBL-CR-626" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cbc:PriceTypeCode)">[UBL-CR-626]-A UBL invoice should not include the InvoiceLine Item Price PriceTypeCode</assert>
      <assert id="UBL-CR-627" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cbc:PriceType)">[UBL-CR-627]-A UBL invoice should not include the InvoiceLine Item Price PriceType</assert>
      <assert id="UBL-CR-628" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cbc:OrderableUnitFactorRate)">[UBL-CR-628]-A UBL invoice should not include the InvoiceLine Item Price OrderableUnitFactorRate</assert>
      <assert id="UBL-CR-629" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cbc:ValidityPeriod)">[UBL-CR-629]-A UBL invoice should not include the InvoiceLine Item Price ValidityPeriod</assert>
      <assert id="UBL-CR-630" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cbc:PriceList)">[UBL-CR-630]-A UBL invoice should not include the InvoiceLine Item Price PriceList</assert>
      <assert id="UBL-CR-631" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cbc:OrderableUnitFactorRate)">[UBL-CR-631]-A UBL invoice should not include the InvoiceLine Item Price OrderableUnitFactorRate</assert>
      <assert id="UBL-CR-632" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cac:AllowanceCharge/cbc:ID)">[UBL-CR-632]-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge ID</assert>
      <assert id="UBL-CR-633" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode)">[UBL-CR-633]-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge AllowanceChargeReasonCode</assert>
      <assert id="UBL-CR-634" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cac:AllowanceCharge/cbc:AllowanceChargeReason)">[UBL-CR-634]-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge AllowanceChargeReason</assert>
      <assert id="UBL-CR-635" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cac:AllowanceCharge/cbc:MultiplierFactorNumeric)">[UBL-CR-635]-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge MultiplierFactorNumeric</assert>
      <assert id="UBL-CR-636" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cac:AllowanceCharge/cbc:PrepaidIndicator)">[UBL-CR-636]-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge PrepaidIndicator</assert>
      <assert id="UBL-CR-637" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cac:AllowanceCharge/cbc:SequenceNumeric)">[UBL-CR-637]-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge SequenceNumeric</assert>
      <assert id="UBL-CR-638" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cac:AllowanceCharge/cbc:AccountingCostCode)">[UBL-CR-638]-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge AccountingCostCode</assert>
      <assert id="UBL-CR-639" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cac:AllowanceCharge/cbc:AccountingCost)">[UBL-CR-639]-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge AccountingCost</assert>
      <assert id="UBL-CR-640" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cac:AllowanceCharge/cbc:PerUnitAmount)">[UBL-CR-640]-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge PerUnitAmount</assert>
      <assert id="UBL-CR-641" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cac:AllowanceCharge/cac:TaxCategory)">[UBL-CR-641]-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge TaxCategory</assert>
      <assert id="UBL-CR-642" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cac:AllowanceCharge/cac:TaxTotal)">[UBL-CR-642]-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge TaxTotal</assert>
      <assert id="UBL-CR-643" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cac:AllowanceCharge/cac:PaymentMeans)">[UBL-CR-643]-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge PaymentMeans</assert>
      <assert id="UBL-CR-644" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cac:PricingExchangeRate)">[UBL-CR-644]-A UBL invoice should not include the InvoiceLine Item Price PricingExchangeRate</assert>
      <assert id="UBL-CR-645" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DeliveryTerms)">[UBL-CR-645]-A UBL invoice should not include the InvoiceLine DeliveryTerms</assert>
      <assert id="UBL-CR-646" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:SubInvoiceLine)">[UBL-CR-646]-A UBL invoice should not include the InvoiceLine SubInvoiceLine</assert>
      <assert id="UBL-CR-647" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:ItemPriceExtension)">[UBL-CR-647]-A UBL invoice should not include the InvoiceLine ItemPriceExtension</assert>
      <assert id="UBL-CR-648" flag="warning" test="not(cbc:CustomizationID/@schemeID)">[UBL-CR-648]-A UBL invoice should not include the CustomizationID scheme identifier</assert>
      <assert id="UBL-CR-649" flag="warning" test="not(cbc:ProfileID/@schemeID)">[UBL-CR-649]-A UBL invoice should not include the ProfileID scheme identifier</assert>
      <assert id="UBL-CR-650" flag="warning" test="not(cbc:ID/@schemeID)">[UBL-CR-650]-A UBL invoice shall not include the Invoice ID scheme identifier</assert>
      <assert id="UBL-CR-651" flag="warning" test="not(cbc:SalesOrderID/@schemeID)">[UBL-CR-651]-A UBL invoice should not include the SalesOrderID scheme identifier</assert>
      <assert id="UBL-CR-652" flag="warning" test="not(//cac:PartyTaxScheme/cbc:CompanyID/@schemeID)">[UBL-CR-652]-A UBL invoice should not include the PartyTaxScheme CompanyID scheme identifier</assert>
      <assert id="UBL-CR-653" flag="warning" test="not(cac:PaymentMeans/cbc:PaymentID/@schemeID)">[UBL-CR-653]-A UBL invoice should not include the PaymentID scheme identifier</assert>
      <assert id="UBL-CR-654" flag="warning" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:ID/@schemeID)">[UBL-CR-654]-A UBL invoice should not include the PayeeFinancialAccount scheme identifier</assert>
      <assert id="UBL-CR-655" flag="warning" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID/@schemeID)">[UBL-CR-655]-A UBL invoice shall not include the FinancialInstitutionBranch ID scheme identifier</assert>
      <assert id="UBL-CR-656" flag="warning" test="not(cbc:InvoiceTypeCode/@listID)">[UBL-CR-656]-A UBL invoice should not include the InvoiceTypeCode listID</assert>
      <assert id="UBL-CR-657" flag="warning" test="not(cbc:DocumentCurrencyCode/@listID)">[UBL-CR-657]-A UBL invoice should not include the DocumentCurrencyCode listID</assert>
      <assert id="UBL-CR-658" flag="warning" test="not(cbc:TaxCurrencyCode/@listID)">[UBL-CR-658]-A UBL invoice should not include the TaxCurrencyCode listID</assert>
      <assert id="UBL-CR-659" flag="warning" test="not(cac:AdditionalDocumentReference/cbc:DocumentTypeCode/@listID)">[UBL-CR-659]-A UBL invoice shall not include the AdditionalDocumentReference DocumentTypeCode listID</assert>
      <assert id="UBL-CR-660" flag="warning" test="not(//cac:Country/cbc:IdentificationCode/@listID)">[UBL-CR-660]-A UBL invoice should not include the Country Identification code listID</assert>
      <assert id="UBL-CR-661" flag="warning" test="not(cac:PaymentMeans/cbc:PaymentMeansCode/@listID)">[UBL-CR-661]-A UBL invoice should not include the PaymentMeansCode listID</assert>
      <assert id="UBL-CR-662" flag="warning" test="not(//cbc:AllowanceChargeReasonCode/@listID)">[UBL-CR-662]-A UBL invoice should not include the AllowanceChargeReasonCode listID</assert>
      <assert id="UBL-CR-663" flag="warning" test="not(//@unitCodeListID)">[UBL-CR-663]-A UBL invoice should not include the unitCodeListID</assert>
      <assert id="UBL-CR-664" flag="warning" test="not(//cac:FinancialInstitution)">[UBL-CR-664]-A UBL invoice should not include the FinancialInstitutionBranch FinancialInstitution</assert>
      <assert id="UBL-CR-665" flag="warning" test="not(//cac:AdditionalDocumentReference[cbc:DocumentTypeCode  != '130' or not(cbc:DocumentTypeCode)]/cbc:ID/@schemeID)">[UBL-CR-665]-A UBL invoice should not include the AdditionalDocumentReference ID schemeID unless the ID equals '130'</assert>
      <assert id="UBL-CR-666" flag="fatal" test="not(//cac:AdditionalDocumentReference[cbc:DocumentTypeCode  = '130']/cac:Attachment)">[UBL-CR-666]-A UBL invoice shall not include an AdditionalDocumentReference simultaneously referring an Invoice Object Identifier and an Attachment</assert>
      <assert id="UBL-CR-667" flag="warning" test="not(//cac:BuyersItemIdentification/cbc:ID/@schemeID)">[UBL-CR-667]-A UBL invoice should not include a Buyer Item Identification schemeID</assert>
      <assert id="UBL-CR-668" flag="warning" test="not(//cac:SellersItemIdentification/cbc:ID/@schemeID)">[UBL-CR-668]-A UBL invoice should not include a Sellers Item Identification schemeID</assert>
      <assert id="UBL-CR-669" flag="warning" test="not(//cac:Price/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode)">[UBL-CR-669]-A UBL invoice should not include a Price Allowance Reason Code</assert>
      <assert id="UBL-CR-670" flag="warning" test="not(//cac:Price/cac:AllowanceCharge/cbc:AllowanceChargeReason)">[UBL-CR-670]-A UBL invoice should not include a Price Allowance Reason</assert>
      <assert id="UBL-CR-671" flag="warning" test="not(//cac:Price/cac:AllowanceCharge/cbc:MultiplierFactorNumeric)">[UBL-CR-671]-A UBL invoice should not include a Price Allowance Multiplier Factor</assert>
      <assert id="UBL-CR-672" flag="warning" test="not(cbc:CreditNoteTypeCode/@listID)">[UBL-CR-672]-A UBL credit note should not include the CreditNoteTypeCode listID</assert>
      <assert id="UBL-CR-673" flag="fatal" test="not(//cac:AdditionalDocumentReference[cbc:DocumentTypeCode  = '130']/cbc:DocumentDescription)">[UBL-CR-673]-A UBL invoice shall not include an AdditionalDocumentReference simultaneously referring an Invoice Object Identifier and an Document Description</assert>
      <assert id="UBL-CR-674" flag="warning" test="not(//cbc:PrimaryAccountNumber/@schemeID)">[UBL-CR-674]-A UBL invoice should not include the PrimaryAccountNumber schemeID</assert>
      <assert id="UBL-CR-675" flag="warning" test="not(//cac:CardAccount/cbc:NetworkID/@schemeID)">[UBL-CR-675]-A UBL invoice should not include the NetworkID schemeID</assert>
      <assert id="UBL-CR-676" flag="warning" test="not(//cac:PaymentMandate/cbc:ID/@schemeID)">[UBL-CR-676]-A UBL invoice should not include the PaymentMandate/ID schemeID</assert>
      <assert id="UBL-CR-677" flag="warning" test="not(//cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID/@schemeID)">[UBL-CR-677]-A UBL invoice should not include the PayerFinancialAccount/ID schemeID</assert>
      <assert id="UBL-CR-678" flag="warning" test="not(//cac:TaxCategory/cbc:ID/@schemeID)">[UBL-CR-678]-A UBL invoice should not include the TaxCategory/ID schemeID</assert>
      <assert id="UBL-CR-679" flag="warning" test="not(//cac:ClassifiedTaxCategory/cbc:ID/@schemeID)">[UBL-CR-679]-A UBL invoice should not include the ClassifiedTaxCategory/ID schemeID</assert>
      <assert id="UBL-CR-680" flag="warning" test="not(//cac:PaymentMeans/cac:PayerFinancialAccount)">[UBL-CR-680]-A UBL invoice should not include the PaymentMeans/PayerFinancialAccount</assert>
      <assert id="UBL-DT-08" flag="warning" test="not(//@schemeName)">[UBL-DT-08]-Scheme name attribute should not be present</assert>
      <assert id="UBL-DT-09" flag="warning" test="not(//@schemeAgencyName)">[UBL-DT-09]-Scheme agency name attribute should not be present</assert>
      <assert id="UBL-DT-10" flag="warning" test="not(//@schemeDataURI)">[UBL-DT-10]-Scheme data uri attribute should not be present</assert>
      <assert id="UBL-DT-11" flag="warning" test="not(//@schemeURI)">[UBL-DT-11]-Scheme uri attribute should not be present</assert>
      <assert id="UBL-DT-12" flag="warning" test="not(//@format)">[UBL-DT-12]-Format attribute should not be present</assert>
      <assert id="UBL-DT-13" flag="warning" test="not(//@unitCodeListIdentifier)">[UBL-DT-13]-Unit code list identifier attribute should not be present</assert>
      <assert id="UBL-DT-14" flag="warning" test="not(//@unitCodeListAgencyIdentifier)">[UBL-DT-14]-Unit code list agency identifier attribute should not be present</assert>
      <assert id="UBL-DT-15" flag="warning" test="not(//@unitCodeListAgencyName)">[UBL-DT-15]-Unit code list agency name attribute should not be present</assert>
      <assert id="UBL-DT-16" flag="warning" test="not(//@listAgencyName)">[UBL-DT-16]-List agency name attribute should not be present</assert>
      <assert id="UBL-DT-17" flag="warning" test="not(//@listName)">[UBL-DT-17]-List name attribute should not be present</assert>
      <assert id="UBL-DT-18" flag="warning" test="count(//@name) - count(//cbc:PaymentMeansCode/@name) &lt;= 0">[UBL-DT-18]-Name attribute should not be present</assert>
      <assert id="UBL-DT-19" flag="warning" test="not(//@languageID)">[UBL-DT-19]-Language identifier attribute should not be present</assert>
      <assert id="UBL-DT-20" flag="warning" test="not(//@listURI)">[UBL-DT-20]-List uri attribute should not be present</assert>
      <assert id="UBL-DT-21" flag="warning" test="not(//@listSchemeURI)">[UBL-DT-21]-List scheme uri attribute should not be present</assert>
      <assert id="UBL-DT-22" flag="warning" test="not(//@languageLocaleID)">[UBL-DT-22]-Language local identifier attribute should not be present</assert>
      <assert id="UBL-DT-23" flag="warning" test="not(//@uri)">[UBL-DT-23]-Uri attribute should not be present</assert>
      <assert id="UBL-DT-24" flag="warning" test="not(//@currencyCodeListVersionID)">[UBL-DT-24]-Currency code list version id should not be present</assert>
      <assert id="UBL-DT-25" flag="warning" test="not(//@characterSetCode)">[UBL-DT-25]-CharacterSetCode attribute should not be present</assert>
      <assert id="UBL-DT-26" flag="warning" test="not(//@encodingCode)">[UBL-DT-26]-EncodingCode attribute should not be present</assert>
      <assert id="UBL-DT-27" flag="warning" test="not(//@schemeAgencyID)">[UBL-DT-27]-Scheme Agency ID attribute should not be present</assert>
      <assert id="UBL-DT-28" flag="warning" test="not(//@listAgencyID)">[UBL-DT-28]-List Agency ID attribute should not be present</assert>
      <assert id="UBL-SR-01" flag="fatal" test="(count(cac:ContractDocumentReference/cbc:ID) &lt;= 1)">[UBL-SR-01]-Contract identifier shall occur maximum once.</assert>
      <assert id="UBL-SR-02" flag="fatal" test="(count(cac:ReceiptDocumentReference/cbc:ID) &lt;= 1)">[UBL-SR-02]-Receive advice identifier shall occur maximum once</assert>
      <assert id="UBL-SR-03" flag="fatal" test="(count(cac:DespatchDocumentReference/cbc:ID) &lt;= 1)">[UBL-SR-03]-Despatch advice identifier shall occur maximum once</assert>
      <assert id="UBL-SR-04" flag="fatal" test="(count(cac:AdditionalDocumentReference[cbc:DocumentTypeCode='130']/cbc:ID) &lt;= 1)">[UBL-SR-04]-Invoice object identifier shall occur maximum once</assert>
      <assert id="UBL-SR-05" flag="fatal" test="(count(cac:PaymentTerms/cbc:Note) &lt;= 1)">[UBL-SR-05]-Payment terms shall occur maximum once</assert>
      <assert id="UBL-SR-06" flag="fatal" test="(count(cac:InvoiceDocumentReference) &lt;= 1)">[UBL-SR-06]-Preceding invoice reference shall occur maximum once</assert>
      <assert id="UBL-SR-08" flag="fatal" test="(count(cac:InvoicePeriod) &lt;= 1)">[UBL-SR-08]-Invoice period shall occur maximum once</assert>
      <assert id="UBL-SR-09" flag="fatal" test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) &lt;= 1)">[UBL-SR-09]-Seller name shall occur maximum once</assert>
      <assert id="UBL-SR-10" flag="fatal" test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name) &lt;= 1)">[UBL-SR-10]-Seller trader name shall occur maximum once</assert>
      <assert id="UBL-SR-11" flag="fatal" test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID) &lt;= 1)">[UBL-SR-11]-Seller legal registration identifier shall occur maximum once</assert>
      <assert id="UBL-SR-12" flag="fatal" test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/upper-case(cbc:ID)='VAT']/cbc:CompanyID) &lt;= 1)">[UBL-SR-12]-Seller VAT identifier shall occur maximum once</assert>
      <assert id="UBL-SR-13" flag="fatal" test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/upper-case(cbc:ID)!='VAT']/cbc:CompanyID) &lt;= 1)">[UBL-SR-13]-Seller tax registration shall occur maximum once</assert>
      <assert id="UBL-SR-14" flag="fatal" test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLegalForm) &lt;= 1)">[UBL-SR-14]-Seller additional legal information shall occur maximum once</assert>
      <assert id="UBL-SR-15" flag="fatal" test="(count(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) &lt;= 1)">[UBL-SR-15]-Buyer name shall occur maximum once</assert>
      <assert id="UBL-SR-16" flag="fatal" test="(count(cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID) &lt;= 1)">[UBL-SR-16]-Buyer identifier shall occur maximum once</assert>
      <assert id="UBL-SR-17" flag="fatal" test="(count(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID) &lt;= 1)">[UBL-SR-17]-Buyer legal registration identifier shall occur maximum once</assert>
      <assert id="UBL-SR-18" flag="fatal" test="(count(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/upper-case(cbc:ID)='VAT']/cbc:CompanyID) &lt;= 1)">[UBL-SR-18]-Buyer VAT identifier shall occur maximum once</assert>
      <assert id="UBL-SR-24" flag="fatal" test="(count(cac:Delivery) &lt;= 1)">[UBL-SR-24]-Deliver to information shall occur maximum once</assert>
      <assert id="UBL-SR-29" flag="fatal" test="(count(//cac:PartyIdentification/cbc:ID[upper-case(@schemeID) = 'SEPA']) &lt;= 1)">[UBL-SR-29]-Bank creditor reference shall occur maximum once</assert>
      <assert id="UBL-SR-39" flag="fatal" test="(count(cac:ProjectReference/cbc:ID) &lt;= 1)">[UBL-SR-39]-Project reference shall occur maximum once.</assert>
      <assert id="UBL-SR-40" flag="fatal" test="(count(cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name) &lt;= 1)">[UBL-SR-40]-Buyer trade name shall occur maximum once</assert>
      <assert id="UBL-SR-44" flag="fatal" test="count(//cbc:PaymentID[not(preceding::cbc:PaymentID/. = .)]) &lt;= 1">[UBL-SR-44]-Payment ID shall occur maximum once</assert>
      <assert id="UBL-SR-45" flag="fatal" test="(count(cac:PaymentMeans/cbc:PaymentDueDate) &lt;=1)">[UBL-SR-45]-Due Date shall occur maximum once</assert>
      <assert id="UBL-SR-46" flag="fatal" test="(count(cac:PaymentMeans/cbc:PaymentMeansCode/@name) &lt;=1)">[UBL-SR-46]-Payment means text shall occur maximum once</assert>
      <assert id="UBL-SR-47" flag="fatal" test="count(//cbc:PaymentMeansCode[not(preceding::cbc:PaymentMeansCode/. = .)]) &lt;= 1">[UBL-SR-47]-When there are more than one payment means code, they shall be equal</assert>
      <assert id="UBL-SR-49" flag="fatal" test="(count(cac:InvoicePeriod/cbc:DescriptionCode) &lt;=1)">[UBL-SR-49]-Value tax point date shall occur maximum once</assert>
    </rule>
    <rule context="cac:InvoiceLine | cac:CreditNoteLine">
      <assert id="UBL-SR-34" flag="fatal" test="(count(cbc:Note) &lt;= 1)">[UBL-SR-34]-Invoice line note shall occur maximum once</assert>
      <assert id="UBL-SR-35" flag="fatal" test="(count(cac:OrderLineReference/cbc:LineID) &lt;= 1)">[UBL-SR-35]-Referenced purchase order line identifier shall occur maximum once</assert>
      <assert id="UBL-SR-36" flag="fatal" test="(count(cac:InvoicePeriod) &lt;= 1)">[UBL-SR-36]-Invoice line period shall occur maximum once</assert>
      <assert id="UBL-SR-37" flag="fatal" test="(count(cac:Price/cac:AllowanceCharge/cbc:Amount) &lt;= 1)">[UBL-SR-37]-Item price discount shall occur maximum once</assert>
      <assert id="UBL-SR-38" flag="fatal" test="(count(cac:Item/cac:ClassifiedTaxCategory/cbc:TaxExemptionReason) &lt;= 1)">[UBL-SR-38]-Invoiced item VAT exemption reason text shall occur maximum once</assert>
      <assert id="UBL-SR-48" flag="fatal" test="count(cac:Item/cac:ClassifiedTaxCategory) = 1">[UBL-SR-48]-Invoice lines shall have one and only one classified tax category.</assert>
      <assert id="UBL-SR-50" flag="fatal" test="count(cac:Item/cbc:Description) &lt;= 1">[UBL-SR-50]-Item description shall occur maximum once</assert>
    </rule>
    <rule context="cac:PayeeParty">
      <assert id="UBL-SR-19" flag="fatal" test="(count(cac:PartyName/cbc:Name) &lt;= 1) and ((cac:PartyName/cbc:Name) != (../cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName))">[UBL-SR-19]-Payee name shall occur maximum once, if the Payee is different from the Seller</assert>
      <assert id="UBL-SR-20" flag="fatal" test="(count(cac:PartyIdentification/cbc:ID[upper-case(@schemeID) != 'SEPA']) &lt;= 1) and ((cac:PartyName/cbc:Name) != (../cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName))">[UBL-SR-20]-Payee identifier shall occur maximum once, if the Payee is different from the Seller</assert>
      <assert id="UBL-SR-21" flag="fatal" test="(count(cac:PartyLegalEntity/cbc:CompanyID) &lt;= 1) and ((cac:PartyName/cbc:Name) != (../cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName))">[UBL-SR-21]-Payee legal registration identifier shall occur maximum once, if the Payee is different from the Seller</assert>
    </rule>
    <rule context="cac:PaymentMeans">
      <assert id="UBL-SR-26" flag="fatal" test="(count(cbc:PaymentID) &lt;= 1)">[UBL-SR-26]-Payment reference shall occur maximum once</assert>
      <assert id="UBL-SR-27" flag="fatal" test="(count(cbc:InstructionNote) &lt;= 1)">[UBL-SR-27]-Payment means text shall occur maximum once</assert>
      <assert id="UBL-SR-28" flag="fatal" test="(count(cac:PaymentMandate/cbc:ID) &lt;= 1)">[UBL-SR-28]-Mandate reference identifier shall occur maximum once</assert>
    </rule>
    <rule context="cac:BillingReference">
      <assert id="UBL-SR-07" flag="fatal" test="(cac:InvoiceDocumentReference/cbc:ID)">[UBL-SR-07]-If there is a preceding invoice reference, the preceding invoice number shall be present</assert>
    </rule>
    <rule context="cac:TaxRepresentativeParty">
      <assert id="UBL-SR-22" flag="fatal" test="(count(cac:Party/cac:PartyName/cbc:Name) &lt;= 1)">[UBL-SR-22]-Seller tax representative name shall occur maximum once, if the Seller has a tax representative</assert>
      <assert id="UBL-SR-23" flag="fatal" test="(count(cac:Party/cac:PartyTaxScheme/cbc:CompanyID) &lt;= 1)">[UBL-SR-23]-Seller tax representative VAT identifier shall occur maximum once, if the Seller has a tax representative</assert>
    </rule>
    <rule context="cac:TaxSubtotal">
      <assert id="UBL-SR-32" flag="fatal" test="(count(cac:TaxCategory/cbc:TaxExemptionReason) &lt;= 1)">[UBL-SR-32]-VAT exemption reason text shall occur maximum once</assert>
    </rule>
  </pattern>
  <pattern id="Codesmodel">
    <rule flag="fatal" context="cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode">
      <assert id="BR-CL-01" flag="fatal" test="(self::cbc:InvoiceTypeCode and ((not(contains(normalize-space(.), ' ')) and contains(' 80 82 84 130 202 203 204 211 295 325 326 380 383 384 385 386 387 388 389 390 393 394 395 456 457 527 575 623 633 751 780 935 ', concat(' ', normalize-space(.), ' '))))) or (self::cbc:CreditNoteTypeCode and ((not(contains(normalize-space(.), ' ')) and contains(' 81 83 261 262 296 308 381 396 420 458 532 ', concat(' ', normalize-space(.), ' ')))))">[BR-CL-01]-The document type code MUST be coded by the invoice and credit note related code lists of UNTDID 1001.</assert>
    </rule>
    <rule flag="fatal" context="cbc:Amount | cbc:BaseAmount | cbc:PriceAmount | cbc:TaxAmount | cbc:TaxableAmount | cbc:LineExtensionAmount | cbc:TaxExclusiveAmount | cbc:TaxInclusiveAmount | cbc:AllowanceTotalAmount | cbc:ChargeTotalAmount | cbc:PrepaidAmount | cbc:PayableRoundingAmount | cbc:PayableAmount">
      <assert id="BR-CL-03" flag="fatal" test="((not(contains(normalize-space(@currencyID), ' ')) and contains(' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL ', concat(' ', normalize-space(@currencyID), ' '))))">[BR-CL-03]-currencyID MUST be coded using ISO code list 4217 alpha-3</assert>
    </rule>
    <rule flag="fatal" context="cbc:DocumentCurrencyCode">
      <assert id="BR-CL-04" flag="fatal" test="((not(contains(normalize-space(.), ' ')) and contains(' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL ', concat(' ', normalize-space(.), ' '))))">[BR-CL-04]-Invoice currency code MUST be coded using ISO code list 4217 alpha-3</assert>
    </rule>
    <rule flag="fatal" context="cbc:TaxCurrencyCode">
      <assert id="BR-CL-05" flag="fatal" test="((not(contains(normalize-space(.), ' ')) and contains(' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL ', concat(' ', normalize-space(.), ' '))))">[BR-CL-05]-Tax currency code MUST be coded using ISO code list 4217 alpha-3</assert>
    </rule>
    <rule flag="fatal" context="cac:InvoicePeriod/cbc:DescriptionCode">
      <assert id="BR-CL-06" flag="fatal" test="((not(contains(normalize-space(.), ' ')) and contains(' 3 35 432 ', concat(' ', normalize-space(.), ' '))))">[BR-CL-06]-Value added tax point date code MUST be coded using a restriction of UNTDID 2005.</assert>
    </rule>
    <rule flag="fatal" context="cac:AdditionalDocumentReference[cbc:DocumentTypeCode = '130']/cbc:ID[@schemeID] | cac:DocumentReference[cbc:DocumentTypeCode = '130']/cbc:ID[@schemeID]">
      <assert id="BR-CL-07" flag="fatal" test="((not(contains(normalize-space(@schemeID), ' ')) and contains(' AAA AAB AAC AAD AAE AAF AAG AAH AAI AAJ AAK AAL AAM AAN AAO AAP AAQ AAR AAS AAT AAU AAV AAW AAX AAY AAZ ABA ABB ABC ABD ABE ABF ABG ABH ABI ABJ ABK ABL ABM ABN ABO ABP ABQ ABR ABS ABT ABU ABV ABW ABX ABY ABZ AC ACA ACB ACC ACD ACE ACF ACG ACH ACI ACJ ACK ACL ACN ACO ACP ACQ ACR ACT ACU ACV ACW ACX ACY ACZ ADA ADB ADC ADD ADE ADF ADG ADI ADJ ADK ADL ADM ADN ADO ADP ADQ ADT ADU ADV ADW ADX ADY ADZ AE AEA AEB AEC AED AEE AEF AEG AEH AEI AEJ AEK AEL AEM AEN AEO AEP AEQ AER AES AET AEU AEV AEW AEX AEY AEZ AF AFA AFB AFC AFD AFE AFF AFG AFH AFI AFJ AFK AFL AFM AFN AFO AFP AFQ AFR AFS AFT AFU AFV AFW AFX AFY AFZ AGA AGB AGC AGD AGE AGF AGG AGH AGI AGJ AGK AGL AGM AGN AGO AGP AGQ AGR AGS AGT AGU AGV AGW AGX AGY AGZ AHA AHB AHC AHD AHE AHF AHG AHH AHI AHJ AHK AHL AHM AHN AHO AHP AHQ AHR AHS AHT AHU AHV AHX AHY AHZ AIA AIB AIC AID AIE AIF AIG AIH AII AIJ AIK AIL AIM AIN AIO AIP AIQ AIR AIS AIT AIU AIV AIW AIX AIY AIZ AJA AJB AJC AJD AJE AJF AJG AJH AJI AJJ AJK AJL AJM AJN AJO AJP AJQ AJR AJS AJT AJU AJV AJW AJX AJY AJZ AKA AKB AKC AKD AKE AKF AKG AKH AKI AKJ AKK AKL AKM AKN AKO AKP AKQ AKR AKS AKT AKU AKV AKW AKX AKY AKZ ALA ALB ALC ALD ALE ALF ALG ALH ALI ALJ ALK ALL ALM ALN ALO ALP ALQ ALR ALS ALT ALU ALV ALW ALX ALY ALZ AMA AMB AMC AMD AME AMF AMG AMH AMI AMJ AMK AML AMM AMN AMO AMP AMQ AMR AMS AMT AMU AMV AMW AMX AMY AMZ ANA ANB ANC AND ANE ANF ANG ANH ANI ANJ ANK ANL ANM ANN ANO ANP ANQ ANR ANS ANT ANU ANV ANW ANX ANY AOA AOD AOE AOF AOG AOH AOI AOJ AOK AOL AOM AON AOO AOP AOQ AOR AOS AOT AOU AOV AOW AOX AOY AOZ AP APA APB APC APD APE APF APG APH API APJ APK APL APM APN APO APP APQ APR APS APT APU APV APW APX APY APZ AQA AQB AQC AQD AQE AQF AQG AQH AQI AQJ AQK AQL AQM AQN AQO AQP AQQ AQR AQS AQT AQU AQV AQW AQX AQY AQZ ARA ARB ARC ARD ARE ARF ARG ARH ARI ARJ ARK ARL ARM ARN ARO ARP ARQ ARR ARS ART ARU ARV ARW ARX ARY ARZ ASA ASB ASC ASD ASE ASF ASG ASH ASI ASJ ASK ASL ASM ASN ASO ASP ASQ ASR ASS AST ASU ASV ASW ASX ASY ASZ ATA ATB ATC ATD ATE ATF ATG ATH ATI ATJ ATK ATL ATM ATN ATO ATP ATQ ATR ATS ATT ATU ATV ATW ATX ATY ATZ AU AUA AUB AUC AUD AUE AUF AUG AUH AUI AUJ AUK AUL AUM AUN AUO AUP AUQ AUR AUS AUT AUU AUV AUW AUX AUY AUZ AV AVA AVB AVC AVD AVE AVF AVG AVH AVI AVJ AVK AVL AVM AVN AVO AVP AVQ AVR AVS AVT AVU AVV AVW AVX AVY AVZ AWA AWB AWC AWD AWE AWF AWG AWH AWI AWJ AWK AWL AWM AWN AWO AWP AWQ AWR AWS AWT AWU AWV AWW AWX AWY AWZ AXA AXB AXC AXD AXE AXF AXG AXH AXI AXJ AXK AXL AXM AXN AXO AXP AXQ AXR AXS BA BC BD BE BH BM BN BO BR BT BTP BW CAS CAT CAU CAV CAW CAX CAY CAZ CBA CBB CD CEC CED CFE CFF CFO CG CH CK CKN CM CMR CN CNO COF CP CR CRN CS CST CT CU CV CW CZ DA DAN DB DI DL DM DQ DR EA EB ED EE EEP EI EN EQ ER ERN ET EX FC FF FI FLW FN FO FS FT FV FX GA GC GD GDN GN HS HWB IA IB ICA ICE ICO II IL INB INN INO IP IS IT IV JB JE LA LAN LAR LB LC LI LO LRC LS MA MB MF MG MH MR MRN MS MSS MWB NA NF OH OI ON OP OR PB PC PD PE PF PI PK PL POR PP PQ PR PS PW PY RA RC RCN RE REN RF RR RT SA SB SD SE SEA SF SH SI SM SN SP SQ SRN SS STA SW SZ TB TCR TE TF TI TIN TL TN TP UAR UC UCN UN UO URI VA VC VGR VM VN VON VOR VP VR VS VT VV WE WM WN WR WS WY XA XC XP ZZZ ', concat(' ', normalize-space(@schemeID), ' '))))">[BR-CL-07]-Object identifier identification scheme identifier MUST be coded using a restriction of UNTDID 1153.</assert>
    </rule>
    <rule flag="fatal" context="cac:PartyIdentification/cbc:ID[@schemeID]">
      <assert id="BR-CL-10" flag="fatal" test="((not(contains(normalize-space(@schemeID), ' ')) and contains(' 0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213 ', concat(' ', normalize-space(@schemeID), ' '))))  or ((not(contains(normalize-space(@schemeID), ' ')) and contains(' SEPA ', concat(' ', normalize-space(@schemeID), ' '))) and ((ancestor::cac:AccountingSupplierParty) or (ancestor::cac:PayeeParty)))">[BR-CL-10]-Any identifier identification scheme identifier MUST be coded using one of the ISO 6523 ICD list.</assert>
    </rule>
    <rule flag="fatal" context="cac:PartyLegalEntity/cbc:CompanyID[@schemeID]">
      <assert id="BR-CL-11" flag="fatal" test="((not(contains(normalize-space(@schemeID), ' ')) and contains(' 0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213 ', concat(' ', normalize-space(@schemeID), ' '))))">[BR-CL-11]-Any registration identifier identification scheme identifier MUST be coded using one of the ISO 6523 ICD list.</assert>
    </rule>
    <rule flag="fatal" context="cac:CommodityClassification/cbc:ItemClassificationCode[@listID]">
      <assert id="BR-CL-13" flag="fatal" test="((not(contains(normalize-space(@listID), ' ')) and contains(' AA AB AC AD AE AF AG AH AI AJ AK AL AM AN AO AP AQ AR AS AT AU AV AW AX AY AZ BA BB BC BD BE BF BG BH BI BJ BK BL BM BN BO BP BQ BR BS BT BU BV BW BX BY BZ CC CG CL CR CV DR DW EC EF EN FS GB GN GS HS IB IN IS IT IZ MA MF MN MP NB ON PD PL PO PV QS RC RN RU RY SA SG SK SN SRS SRT SRU SRV SRW SRX SRY SRZ SS SSA SSB SSC SSD SSE SSF SSG SSH SSI SSJ SSK SSL SSM SSN SSO SSP SSQ SSR SSS SST SSU SSV SSW SSX SSY SSZ ST STA STB STC STD STE STF STG STH STI STJ STK STL STM STN STO STP STQ STR STS STT STU STV STW STX STY STZ SUA SUB SUC SUD SUE SUF SUG SUH SUI SUJ SUK SUL SUM TG TSN TSO TSP TSQ TSR TSS TST TSU UA UP VN VP VS VX ZZZ ', concat(' ', normalize-space(@listID), ' '))))">[BR-CL-13]-Item classification identifier identification scheme identifier MUST be
      coded using one of the UNTDID 7143 list.</assert>
    </rule>
    <rule flag="fatal" context="cac:Country/cbc:IdentificationCode">
      <assert id="BR-CL-14" flag="fatal" test="((not(contains(normalize-space(.), ' ')) and contains(' 1A AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI YE YT ZA ZM ZW ', concat(' ', normalize-space(.), ' '))))">[BR-CL-14]-Country codes in an invoice MUST be coded using ISO code list 3166-1</assert>
    </rule>
    <rule flag="fatal" context="cac:OriginCountry/cbc:IdentificationCode">
      <assert id="BR-CL-15" flag="fatal" test="((not(contains(normalize-space(.), ' ')) and contains(' 1A AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI YE YT ZA ZM ZW ', concat(' ', normalize-space(.), ' '))))">[BR-CL-15]-Country codes in an invoice MUST be coded using ISO code list 3166-1</assert>
    </rule>
    <rule flag="fatal" context="cac:PaymentMeans/cbc:PaymentMeansCode">
      <assert id="BR-CL-16" flag="fatal" test="( ( not(contains(normalize-space(.),' ')) and contains( ' 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 74 75 76 77 78 91 92 93 94 95 96 97 ZZZ ',concat(' ',normalize-space(.),' ') ) ) )">[BR-CL-16]-Payment means in an invoice MUST be coded using UNCL4461 code list</assert>
    </rule>
    <rule flag="fatal" context="cac:TaxCategory/cbc:ID">
      <assert id="BR-CL-17" flag="fatal" test="( ( not(contains(normalize-space(.),' ')) and contains( ' AE L M E S Z G O K B ',concat(' ',normalize-space(.),' ') ) ) )">[BR-CL-17]-Invoice tax categories MUST be coded using UNCL5305 code list</assert>
    </rule>
    <rule flag="fatal" context="cac:ClassifiedTaxCategory/cbc:ID">
      <assert id="BR-CL-18" flag="fatal" test="( ( not(contains(normalize-space(.),' ')) and contains( ' AE L M E S Z G O K B ',concat(' ',normalize-space(.),' ') ) ) )">[BR-CL-18]-Invoice tax categories MUST be coded using UNCL5305 code list</assert>
    </rule>
    <rule flag="fatal" context="cac:AllowanceCharge[cbc:ChargeIndicator = false()]/cbc:AllowanceChargeReasonCode">
      <assert id="BR-CL-19" flag="fatal" test="((not(contains(normalize-space(.), ' ')) and contains(' 41 42 60 62 63 64 65 66 67 68 70 71 88 95 100 102 103 104 ', concat(' ', normalize-space(.), ' '))))">[BR-CL-19]-Coded allowance reasons MUST belong to the UNCL 5189 code list</assert>
    </rule>
    <rule flag="fatal" context="cac:AllowanceCharge[cbc:ChargeIndicator = true()]/cbc:AllowanceChargeReasonCode">
      <assert id="BR-CL-20" flag="fatal" test="((not(contains(normalize-space(.), ' ')) and contains(' AA AAA AAC AAD AAE AAF AAH AAI AAS AAT AAV AAY AAZ ABA ABB ABC ABD ABF ABK ABL ABN ABR ABS ABT ABU ACF ACG ACH ACI ACJ ACK ACL ACM ACS ADC ADE ADJ ADK ADL ADM ADN ADO ADP ADQ ADR ADT ADW ADY ADZ AEA AEB AEC AED AEF AEH AEI AEJ AEK AEL AEM AEN AEO AEP AES AET AEU AEV AEW AEX AEY AEZ AJ AU CA CAB CAD CAE CAF CAI CAJ CAK CAL CAM CAN CAO CAP CAQ CAR CAS CAT CAU CAV CAW CAX CAY CAZ CD CG CS CT DAB DAD DAC DAF DAG DAH DAI DAJ DAK DAL DAM DAN DAO DAP DAQ DL EG EP ER FAA FAB FAC FC FH FI GAA HAA HD HH IAA IAB ID IF IR IS KO L1 LA LAA LAB LF MAE MI ML NAA OA PA PAA PC PL RAB RAC RAD RAF RE RF RH RV SA SAA SAD SAE SAI SG SH SM SU TAB TAC TT TV V1 V2 WH XAA YY ZZZ ', concat(' ', normalize-space(.), ' '))))">[BR-CL-20]-Coded charge reasons MUST belong to the UNCL 7161 code list</assert>
    </rule>
    <rule flag="fatal" context="cac:StandardItemIdentification/cbc:ID[@schemeID]">
      <assert id="BR-CL-21" flag="fatal" test="((not(contains(normalize-space(@schemeID), ' ')) and contains(' 0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213 ', concat(' ', normalize-space(@schemeID), ' '))))">[BR-CL-21]-Item standard identifier scheme identifier MUST belong to the ISO 6523 ICD code list</assert>
    </rule>
    <rule flag="fatal" context="cbc:TaxExemptionReasonCode">
      <assert id="BR-CL-22" flag="fatal" test="((not(contains(normalize-space(.), ' ')) and contains(' VATEX-EU-79-C VATEX-EU-132 VATEX-EU-132-1A VATEX-EU-132-1B VATEX-EU-132-1C VATEX-EU-132-1D VATEX-EU-132-1E VATEX-EU-132-1F VATEX-EU-132-1G VATEX-EU-132-1H VATEX-EU-132-1I VATEX-EU-132-1J VATEX-EU-132-1K VATEX-EU-132-1L VATEX-EU-132-1M VATEX-EU-132-1N VATEX-EU-132-1O VATEX-EU-132-1P VATEX-EU-132-1Q VATEX-EU-143 VATEX-EU-143-1A VATEX-EU-143-1B VATEX-EU-143-1C VATEX-EU-143-1D VATEX-EU-143-1E VATEX-EU-143-1F VATEX-EU-143-1FA VATEX-EU-143-1G VATEX-EU-143-1H VATEX-EU-143-1I VATEX-EU-143-1J VATEX-EU-143-1K VATEX-EU-143-1L VATEX-EU-309 VATEX-EU-148 VATEX-EU-148-A VATEX-EU-148-B VATEX-EU-148-C VATEX-EU-148-D VATEX-EU-148-E VATEX-EU-148-F VATEX-EU-148-G VATEX-EU-151 VATEX-EU-151-1A VATEX-EU-151-1AA VATEX-EU-151-1B VATEX-EU-151-1C VATEX-EU-151-1D VATEX-EU-151-1E VATEX-EU-G VATEX-EU-O VATEX-EU-IC VATEX-EU-AE VATEX-EU-D VATEX-EU-F VATEX-EU-I VATEX-EU-J ', concat(' ', normalize-space(upper-case(.)), ' '))))">[BR-CL-22]-Tax exemption reason code identifier scheme identifier MUST belong to the CEF VATEX code list</assert>
    </rule>
    <rule flag="fatal" context="cbc:InvoicedQuantity[@unitCode] | cbc:BaseQuantity[@unitCode] | cbc:CreditedQuantity[@unitCode]">
      <assert id="BR-CL-23" flag="fatal" test="((not(contains(normalize-space(@unitCode), ' ')) and contains(' 10 11 13 14 15 20 21 22 23 24 25 27 28 33 34 35 37 38 40 41 56 57 58 59 60 61 74 77 80 81 85 87 89 91 1I 2A 2B 2C 2G 2H 2I 2J 2K 2L 2M 2N 2P 2Q 2R 2U 2X 2Y 2Z 3B 3C 4C 4G 4H 4K 4L 4M 4N 4O 4P 4Q 4R 4T 4U 4W 4X 5A 5B 5E 5J A10 A11 A12 A13 A14 A15 A16 A17 A18 A19 A2 A20 A21 A22 A23 A24 A26 A27 A28 A29 A3 A30 A31 A32 A33 A34 A35 A36 A37 A38 A39 A4 A40 A41 A42 A43 A44 A45 A47 A48 A49 A5 A53 A54 A55 A56 A59 A6 A68 A69 A7 A70 A71 A73 A74 A75 A76 A8 A84 A85 A86 A87 A88 A89 A9 A90 A91 A93 A94 A95 A96 A97 A98 A99 AA AB ACR ACT AD AE AH AI AK AL AMH AMP ANN APZ AQ AS ASM ASU ATM AWG AY AZ B1 B10 B11 B12 B13 B14 B15 B16 B17 B18 B19 B20 B21 B22 B23 B24 B25 B26 B27 B28 B29 B3 B30 B31 B32 B33 B34 B35 B4 B41 B42 B43 B44 B45 B46 B47 B48 B49 B50 B52 B53 B54 B55 B56 B57 B58 B59 B60 B61 B62 B63 B64 B66 B67 B68 B69 B7 B70 B71 B72 B73 B74 B75 B76 B77 B78 B79 B8 B80 B81 B82 B83 B84 B85 B86 B87 B88 B89 B90 B91 B92 B93 B94 B95 B96 B97 B98 B99 BAR BB BFT BHP BIL BLD BLL BP BPM BQL BTU BUA BUI C0 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19 C20 C21 C22 C23 C24 C25 C26 C27 C28 C29 C3 C30 C31 C32 C33 C34 C35 C36 C37 C38 C39 C40 C41 C42 C43 C44 C45 C46 C47 C48 C49 C50 C51 C52 C53 C54 C55 C56 C57 C58 C59 C60 C61 C62 C63 C64 C65 C66 C67 C68 C69 C7 C70 C71 C72 C73 C74 C75 C76 C78 C79 C8 C80 C81 C82 C83 C84 C85 C86 C87 C88 C89 C9 C90 C91 C92 C93 C94 C95 C96 C97 C99 CCT CDL CEL CEN CG CGM CKG CLF CLT CMK CMQ CMT CNP CNT COU CTG CTM CTN CUR CWA CWI D03 D04 D1 D10 D11 D12 D13 D15 D16 D17 D18 D19 D2 D20 D21 D22 D23 D24 D25 D26 D27 D29 D30 D31 D32 D33 D34 D36 D41 D42 D43 D44 D45 D46 D47 D48 D49 D5 D50 D51 D52 D53 D54 D55 D56 D57 D58 D59 D6 D60 D61 D62 D63 D65 D68 D69 D73 D74 D77 D78 D80 D81 D82 D83 D85 D86 D87 D88 D89 D91 D93 D94 D95 DAA DAD DAY DB DBM DBW DD DEC DG DJ DLT DMA DMK DMO DMQ DMT DN DPC DPR DPT DRA DRI DRL DT DTN DWT DZN DZP E01 E07 E08 E09 E10 E12 E14 E15 E16 E17 E18 E19 E20 E21 E22 E23 E25 E27 E28 E30 E31 E32 E33 E34 E35 E36 E37 E38 E39 E4 E40 E41 E42 E43 E44 E45 E46 E47 E48 E49 E50 E51 E52 E53 E54 E55 E56 E57 E58 E59 E60 E61 E62 E63 E64 E65 E66 E67 E68 E69 E70 E71 E72 E73 E74 E75 E76 E77 E78 E79 E80 E81 E82 E83 E84 E85 E86 E87 E88 E89 E90 E91 E92 E93 E94 E95 E96 E97 E98 E99 EA EB EQ F01 F02 F03 F04 F05 F06 F07 F08 F10 F11 F12 F13 F14 F15 F16 F17 F18 F19 F20 F21 F22 F23 F24 F25 F26 F27 F28 F29 F30 F31 F32 F33 F34 F35 F36 F37 F38 F39 F40 F41 F42 F43 F44 F45 F46 F47 F48 F49 F50 F51 F52 F53 F54 F55 F56 F57 F58 F59 F60 F61 F62 F63 F64 F65 F66 F67 F68 F69 F70 F71 F72 F73 F74 F75 F76 F77 F78 F79 F80 F81 F82 F83 F84 F85 F86 F87 F88 F89 F90 F91 F92 F93 F94 F95 F96 F97 F98 F99 FAH FAR FBM FC FF FH FIT FL FNU FOT FP FR FS FTK FTQ G01 G04 G05 G06 G08 G09 G10 G11 G12 G13 G14 G15 G16 G17 G18 G19 G2 G20 G21 G23 G24 G25 G26 G27 G28 G29 G3 G30 G31 G32 G33 G34 G35 G36 G37 G38 G39 G40 G41 G42 G43 G44 G45 G46 G47 G48 G49 G50 G51 G52 G53 G54 G55 G56 G57 G58 G59 G60 G61 G62 G63 G64 G65 G66 G67 G68 G69 G70 G71 G72 G73 G74 G75 G76 G77 G78 G79 G80 G81 G82 G83 G84 G85 G86 G87 G88 G89 G90 G91 G92 G93 G94 G95 G96 G97 G98 G99 GB GBQ GDW GE GF GFI GGR GIA GIC GII GIP GJ GL GLD GLI GLL GM GO GP GQ GRM GRN GRO GV GWH H03 H04 H05 H06 H07 H08 H09 H10 H11 H12 H13 H14 H15 H16 H18 H19 H20 H21 H22 H23 H24 H25 H26 H27 H28 H29 H30 H31 H32 H33 H34 H35 H36 H37 H38 H39 H40 H41 H42 H43 H44 H45 H46 H47 H48 H49 H50 H51 H52 H53 H54 H55 H56 H57 H58 H59 H60 H61 H62 H63 H64 H65 H66 H67 H68 H69 H70 H71 H72 H73 H74 H75 H76 H77 H79 H80 H81 H82 H83 H84 H85 H87 H88 H89 H90 H91 H92 H93 H94 H95 H96 H98 H99 HA HAD HBA HBX HC HDW HEA HGM HH HIU HKM HLT HM HMO HMQ HMT HPA HTZ HUR HWE IA IE INH INK INQ ISD IU IUG IV J10 J12 J13 J14 J15 J16 J17 J18 J19 J2 J20 J21 J22 J23 J24 J25 J26 J27 J28 J29 J30 J31 J32 J33 J34 J35 J36 J38 J39 J40 J41 J42 J43 J44 J45 J46 J47 J48 J49 J50 J51 J52 J53 J54 J55 J56 J57 J58 J59 J60 J61 J62 J63 J64 J65 J66 J67 J68 J69 J70 J71 J72 J73 J74 J75 J76 J78 J79 J81 J82 J83 J84 J85 J87 J90 J91 J92 J93 J95 J96 J97 J98 J99 JE JK JM JNT JOU JPS JWL K1 K10 K11 K12 K13 K14 K15 K16 K17 K18 K19 K2 K20 K21 K22 K23 K26 K27 K28 K3 K30 K31 K32 K33 K34 K35 K36 K37 K38 K39 K40 K41 K42 K43 K45 K46 K47 K48 K49 K50 K51 K52 K53 K54 K55 K58 K59 K6 K60 K61 K62 K63 K64 K65 K66 K67 K68 K69 K70 K71 K73 K74 K75 K76 K77 K78 K79 K80 K81 K82 K83 K84 K85 K86 K87 K88 K89 K90 K91 K92 K93 K94 K95 K96 K97 K98 K99 KA KAT KB KBA KCC KDW KEL KGM KGS KHY KHZ KI KIC KIP KJ KJO KL KLK KLX KMA KMH KMK KMQ KMT KNI KNM KNS KNT KO KPA KPH KPO KPP KR KSD KSH KT KTN KUR KVA KVR KVT KW KWH KWN KWO KWS KWT KWY KX L10 L11 L12 L13 L14 L15 L16 L17 L18 L19 L2 L20 L21 L23 L24 L25 L26 L27 L28 L29 L30 L31 L32 L33 L34 L35 L36 L37 L38 L39 L40 L41 L42 L43 L44 L45 L46 L47 L48 L49 L50 L51 L52 L53 L54 L55 L56 L57 L58 L59 L60 L63 L64 L65 L66 L67 L68 L69 L70 L71 L72 L73 L74 L75 L76 L77 L78 L79 L80 L81 L82 L83 L84 L85 L86 L87 L88 L89 L90 L91 L92 L93 L94 L95 L96 L98 L99 LA LAC LBR LBT LD LEF LF LH LK LM LN LO LP LPA LR LS LTN LTR LUB LUM LUX LY M1 M10 M11 M12 M13 M14 M15 M16 M17 M18 M19 M20 M21 M22 M23 M24 M25 M26 M27 M29 M30 M31 M32 M33 M34 M35 M36 M37 M38 M39 M4 M40 M41 M42 M43 M44 M45 M46 M47 M48 M49 M5 M50 M51 M52 M53 M55 M56 M57 M58 M59 M60 M61 M62 M63 M64 M65 M66 M67 M68 M69 M7 M70 M71 M72 M73 M74 M75 M76 M77 M78 M79 M80 M81 M82 M83 M84 M85 M86 M87 M88 M89 M9 M90 M91 M92 M93 M94 M95 M96 M97 M98 M99 MAH MAL MAM MAR MAW MBE MBF MBR MC MCU MD MGM MHZ MIK MIL MIN MIO MIU MKD MKM MKW MLD MLT MMK MMQ MMT MND MNJ MON MPA MQD MQH MQM MQS MQW MRD MRM MRW MSK MTK MTQ MTR MTS MTZ MVA MWH N1 N10 N11 N12 N13 N14 N15 N16 N17 N18 N19 N20 N21 N22 N23 N24 N25 N26 N27 N28 N29 N3 N30 N31 N32 N33 N34 N35 N36 N37 N38 N39 N40 N41 N42 N43 N44 N45 N46 N47 N48 N49 N50 N51 N52 N53 N54 N55 N56 N57 N58 N59 N60 N61 N62 N63 N64 N65 N66 N67 N68 N69 N70 N71 N72 N73 N74 N75 N76 N77 N78 N79 N80 N81 N82 N83 N84 N85 N86 N87 N88 N89 N90 N91 N92 N93 N94 N95 N96 N97 N98 N99 NA NAR NCL NEW NF NIL NIU NL NM3 NMI NMP NPT NT NTU NU NX OA ODE ODG ODK ODM OHM ON ONZ OPM OT OZA OZI P1 P10 P11 P12 P13 P14 P15 P16 P17 P18 P19 P2 P20 P21 P22 P23 P24 P25 P26 P27 P28 P29 P30 P31 P32 P33 P34 P35 P36 P37 P38 P39 P40 P41 P42 P43 P44 P45 P46 P47 P48 P49 P5 P50 P51 P52 P53 P54 P55 P56 P57 P58 P59 P60 P61 P62 P63 P64 P65 P66 P67 P68 P69 P70 P71 P72 P73 P74 P75 P76 P77 P78 P79 P80 P81 P82 P83 P84 P85 P86 P87 P88 P89 P90 P91 P92 P93 P94 P95 P96 P97 P98 P99 PAL PD PFL PGL PI PLA PO PQ PR PS PTD PTI PTL PTN Q10 Q11 Q12 Q13 Q14 Q15 Q16 Q17 Q18 Q19 Q20 Q21 Q22 Q23 Q24 Q25 Q26 Q27 Q28 Q29 Q3 Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q37 Q38 Q39 Q40 Q41 Q42 QA QAN QB QR QTD QTI QTL QTR R1 R9 RH RM ROM RP RPM RPS RT S3 S4 SAN SCO SCR SEC SET SG SIE SM3 SMI SQ SQR SR STC STI STK STL STN STW SW SX SYR T0 T3 TAH TAN TI TIC TIP TKM TMS TNE TP TPI TPR TQD TRL TST TTS U1 U2 UB UC VA VLT VP W2 WA WB WCD WE WEB WEE WG WHR WM WSD WTT X1 YDK YDQ YRD Z11 Z9 ZP ZZ X1A X1B X1D X1F X1G X1W X2C X3A X3H X43 X44 X4A X4B X4C X4D X4F X4G X4H X5H X5L X5M X6H X6P X7A X7B X8A X8B X8C XAA XAB XAC XAD XAE XAF XAG XAH XAI XAJ XAL XAM XAP XAT XAV XB4 XBA XBB XBC XBD XBE XBF XBG XBH XBI XBJ XBK XBL XBM XBN XBO XBP XBQ XBR XBS XBT XBU XBV XBW XBX XBY XBZ XCA XCB XCC XCD XCE XCF XCG XCH XCI XCJ XCK XCL XCM XCN XCO XCP XCQ XCR XCS XCT XCU XCV XCW XCX XCY XCZ XDA XDB XDC XDG XDH XDI XDJ XDK XDL XDM XDN XDP XDR XDS XDT XDU XDV XDW XDX XDY XEC XED XEE XEF XEG XEH XEI XEN XFB XFC XFD XFE XFI XFL XFO XFP XFR XFT XFW XFX XGB XGI XGL XGR XGU XGY XGZ XHA XHB XHC XHG XHN XHR XIA XIB XIC XID XIE XIF XIG XIH XIK XIL XIN XIZ XJB XJC XJG XJR XJT XJY XKG XKI XLE XLG XLT XLU XLV XLZ XMA XMB XMC XME XMR XMS XMT XMW XMX XNA XNE XNF XNG XNS XNT XNU XNV XO1 XO2 XO3 XO4 XO5 XO6 XO7 XO8 XO9 XOA XOB XOC XOD XOE XOF XOG XOH XOI XOJ XOK XOL XOM XON XOP XOQ XOR XOS XOT XOU XOV XOW XOX XOY XOZ XP1 XP2 XP3 XP4 XPA XPB XPC XPD XPE XPF XPG XPH XPI XPJ XPK XPL XPN XPO XPP XPR XPT XPU XPV XPX XPY XPZ XQA XQB XQC XQD XQF XQG XQH XQJ XQK XQL XQM XQN XQP XQQ XQR XQS XRD XRG XRJ XRK XRL XRO XRT XRZ XSA XSB XSC XSD XSE XSH XSI XSK XSL XSM XSO XSP XSS XST XSU XSV XSW XSX XSY XSZ XT1 XTB XTC XTD XTE XTG XTI XTK XTL XTN XTO XTR XTS XTT XTU XTV XTW XTY XTZ XUC XUN XVA XVG XVI XVK XVL XVN XVO XVP XVQ XVR XVS XVY XWA XWB XWC XWD XWF XWG XWH XWJ XWK XWL XWM XWN XWP XWQ XWR XWS XWT XWU XWV XWW XWX XWY XWZ XXA XXB XXC XXD XXF XXG XXH XXJ XXK XYA XYB XYC XYD XYF XYG XYH XYJ XYK XYL XYM XYN XYP XYQ XYR XYS XYT XYV XYW XYX XYY XYZ XZA XZB XZC XZD XZF XZG XZH XZJ XZK XZL XZM XZN XZP XZQ XZR XZS XZT XZU XZV XZW XZX XZY XZZ ', concat(' ', normalize-space(@unitCode), ' '))))">[BR-CL-23]-Unit code MUST be coded according to the UN/ECE Recommendation 20 with
      Rec 21 extension</assert>
    </rule>
    <rule flag="fatal" context="cbc:EmbeddedDocumentBinaryObject[@mimeCode]">
      <assert id="BR-CL-24" flag="fatal" test="((@mimeCode = 'application/pdf' or @mimeCode = 'image/png' or @mimeCode = 'image/jpeg' or @mimeCode = 'text/csv' or @mimeCode = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or @mimeCode = 'application/vnd.oasis.opendocument.spreadsheet'))">[BR-CL-24]-For Mime code in attribute use MIMEMediaType.</assert>
    </rule>
    <rule flag="fatal" context="cbc:EndpointID[@schemeID]">
      <assert id="BR-CL-25" flag="fatal" test="((not(contains(normalize-space(@schemeID), ' ')) and contains(' 0002 0007 0009 0037 0060 0088 0096 0097 0106 0130 0135 0142 0151 0183 0184 0190 0191 0192 0193 0194 0195 0196 0198 0199 0200 0201 0202 0203 0204 0208 0209 0210 0211 0212 0213 9901 9902 9904 9905 9906 9907 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9955 9957 AN AQ AS AU EM ', concat(' ', normalize-space(@schemeID), ' '))))">[BR-CL-25]-Endpoint identifier scheme identifier MUST belong to the CEF EAS code list</assert>
    </rule>
    <rule flag="fatal" context="cac:DeliveryLocation/cbc:ID[@schemeID]">
      <assert id="BR-CL-26" flag="fatal" test="((not(contains(normalize-space(@schemeID), ' ')) and contains(' 0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213 ', concat(' ', normalize-space(@schemeID), ' '))))">[BR-CL-26]-Delivery location identifier scheme identifier MUST belong to the ISO 6523 ICD code list</assert>
    </rule>
  </pattern>


	<!-- Empty elements -->
	<pattern id="Empty-element">
		<rule context="//*[not(*) and not(normalize-space())]">
			<assert id="PEPPOL-EN16931-R008" test="false()" flag="fatal">Document MUST not contain empty elements.</assert>
		</rule> 
	</pattern>
	<!--
    Transaction rules

    R00X - Document level
    R01X - Accounting customer
    R02X - Accounting supplier
    R04X - Allowance/Charge (document and line)
    R05X - Tax
    R06X - Payment
    R08X - Additonal document reference
    R1XX - Line level
    R11X - Invoice period
  -->
  <pattern>
    <!-- Document level -->
    <rule context="ubl-creditnote:CreditNote | ubl-invoice:Invoice">
      <assert id="PEPPOL-EN16931-R001" test="cbc:ProfileID" flag="fatal">Business process MUST be provided.</assert>
      <assert id="PEPPOL-EN16931-R007" test="$profile != 'Unknown'" flag="fatal">Business process MUST be in the format 'urn:fdc:peppol.eu:2017:poacc:billing:NN:1.0' where NN indicates the process number.</assert>
      <assert id="PEPPOL-EN16931-R002" test="count(cbc:Note) &lt;= 1" flag="fatal">No more than one note is allowed on document level.</assert>
      <assert id="PEPPOL-EN16931-R003" test="cbc:BuyerReference or cac:OrderReference/cbc:ID" flag="fatal">A buyer reference or purchase order reference MUST be provided.</assert>
      <assert id="PEPPOL-EN16931-R004" test="starts-with(normalize-space(cbc:CustomizationID/text()), 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0')" flag="fatal">Specification identifier MUST have the value 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0'.</assert>
      <assert id="PEPPOL-EN16931-R053" test="count(cac:TaxTotal[cac:TaxSubtotal]) = 1" flag="fatal">Only one tax total with tax subtotals MUST be provided.</assert>
      <assert id="PEPPOL-EN16931-R054" test="count(cac:TaxTotal[not(cac:TaxSubtotal)]) = (if (cbc:TaxCurrencyCode) then 1 else 0)" flag="fatal">Only one tax total without tax subtotals MUST be provided when tax currency code is provided.</assert>
      <assert id="PEPPOL-EN16931-R055" test="not(cbc:TaxCurrencyCode) or (cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:TaxCurrencyCode)] &lt;= 0 and cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:DocumentCurrencyCode)] &lt;= 0) or (cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:TaxCurrencyCode)] &gt;= 0 and cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:DocumentCurrencyCode)] &gt;= 0) " flag="fatal">Invoice total VAT amount and Invoice total VAT amount in accounting currency MUST have the same operational sign</assert>
      <assert id="PEPPOL-EN16931-R006" test="(count(cac:AdditionalDocumentReference[cbc:DocumentTypeCode='130']) &lt;= 1)" flag="fatal">Only one invoiced object is allowed on document level</assert>
      <assert id="PEPPOL-EN16931-R080" test="(count(cac:AdditionalDocumentReference[cbc:DocumentTypeCode='50']) &lt;= 1)" flag="fatal">Only one project reference is allowed on document level</assert>
    </rule>
    <rule context="cbc:TaxCurrencyCode">
      <assert id="PEPPOL-EN16931-R005" test="not(normalize-space(text()) = normalize-space(../cbc:DocumentCurrencyCode/text()))" flag="fatal">VAT accounting currency code MUST be different from invoice currency code when provided.</assert>
    </rule>
    <!-- Accounting customer -->
    <rule context="cac:AccountingCustomerParty/cac:Party">
      <assert id="PEPPOL-EN16931-R010" test="cbc:EndpointID" flag="fatal">Buyer electronic address MUST be provided</assert>
    </rule>
    <!-- Accounting supplier -->
    <rule context="cac:AccountingSupplierParty/cac:Party">
      <assert id="PEPPOL-EN16931-R020" test="cbc:EndpointID" flag="fatal">Seller electronic address MUST be provided</assert>
    </rule>
    <!-- Allowance/Charge (document level/line level) -->
    <rule context="ubl-invoice:Invoice/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | ubl-invoice:Invoice/cac:InvoiceLine/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | ubl-creditnote:CreditNote/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | ubl-creditnote:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)]">
      <assert id="PEPPOL-EN16931-R041" test="false()" flag="fatal">Allowance/charge base amount MUST be provided when allowance/charge percentage is provided.</assert>
    </rule>
    <rule context="ubl-invoice:Invoice/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | ubl-invoice:Invoice/cac:InvoiceLine/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | ubl-creditnote:CreditNote/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | ubl-creditnote:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount]">
      <assert id="PEPPOL-EN16931-R042" test="false()" flag="fatal">Allowance/charge percentage MUST be provided when allowance/charge base amount is provided.</assert>
    </rule>
    <rule context="ubl-invoice:Invoice/cac:AllowanceCharge | ubl-invoice:Invoice/cac:InvoiceLine/cac:AllowanceCharge | ubl-creditnote:CreditNote/cac:AllowanceCharge | ubl-creditnote:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge">
      <assert id="PEPPOL-EN16931-R040" test="
          not(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or u:slack(if (cbc:Amount) then
            cbc:Amount
          else
            0, (xs:decimal(cbc:BaseAmount) * xs:decimal(cbc:MultiplierFactorNumeric)) div 100, 0.02)" flag="fatal">Allowance/charge amount must equal base amount * percentage/100 if base amount and percentage exists</assert>
      <assert id="PEPPOL-EN16931-R043" test="normalize-space(cbc:ChargeIndicator/text()) = 'true' or normalize-space(cbc:ChargeIndicator/text()) = 'false'" flag="fatal">Allowance/charge ChargeIndicator value MUST equal 'true' or 'false'</assert>
    </rule>
    <!-- Payment -->
    <rule context="
        cac:PaymentMeans[some $code in tokenize('49 59', '\s')
          satisfies normalize-space(cbc:PaymentMeansCode) = $code]">
      <assert id="PEPPOL-EN16931-R061" test="cac:PaymentMandate/cbc:ID" flag="fatal">Mandate reference MUST be provided for direct debit.</assert>
    </rule>
    <!-- Currency -->
    <rule context="cbc:Amount | cbc:BaseAmount | cbc:PriceAmount | cac:TaxTotal[cac:TaxSubtotal]/cbc:TaxAmount | cbc:TaxableAmount | cbc:LineExtensionAmount | cbc:TaxExclusiveAmount | cbc:TaxInclusiveAmount | cbc:AllowanceTotalAmount | cbc:ChargeTotalAmount | cbc:PrepaidAmount | cbc:PayableRoundingAmount | cbc:PayableAmount">
      <assert id="PEPPOL-EN16931-R051" test="@currencyID = $documentCurrencyCode" flag="fatal">All currencyID attributes must have the same value as the invoice currency code (BT-5), except for the invoice total VAT amount in accounting currency (BT-111).</assert>
    </rule>
    <!-- Line level - invoice period -->
    <rule context="ubl-invoice:Invoice[cac:InvoicePeriod/cbc:StartDate]/cac:InvoiceLine/cac:InvoicePeriod/cbc:StartDate | ubl-creditnote:CreditNote[cac:InvoicePeriod/cbc:StartDate]/cac:CreditNoteLine/cac:InvoicePeriod/cbc:StartDate">
      <assert id="PEPPOL-EN16931-R110" test="xs:date(text()) &gt;= xs:date(../../../cac:InvoicePeriod/cbc:StartDate)" flag="fatal">Start date of line period MUST be within invoice period.</assert>
    </rule>
    <rule context="ubl-invoice:Invoice[cac:InvoicePeriod/cbc:EndDate]/cac:InvoiceLine/cac:InvoicePeriod/cbc:EndDate | ubl-creditnote:CreditNote[cac:InvoicePeriod/cbc:EndDate]/cac:CreditNoteLine/cac:InvoicePeriod/cbc:EndDate">
      <assert id="PEPPOL-EN16931-R111" test="xs:date(text()) &lt;= xs:date(../../../cac:InvoicePeriod/cbc:EndDate)" flag="fatal">End date of line period MUST be within invoice period.</assert>
    </rule>
    <!-- Line level - line extension amount -->
    <rule context="cac:InvoiceLine | cac:CreditNoteLine">
      <let name="lineExtensionAmount" value="
          if (cbc:LineExtensionAmount) then
            xs:decimal(cbc:LineExtensionAmount)
          else
            0"/>
      <let name="quantity" value="
          if (/ubl-invoice:Invoice) then
            (if (cbc:InvoicedQuantity) then
              xs:decimal(cbc:InvoicedQuantity)
            else
              1)
          else
            (if (cbc:CreditedQuantity) then
              xs:decimal(cbc:CreditedQuantity)
            else
              1)"/>
      <let name="priceAmount" value="
          if (cac:Price/cbc:PriceAmount) then
            xs:decimal(cac:Price/cbc:PriceAmount)
          else
            0"/>
      <let name="baseQuantity" value="
          if (cac:Price/cbc:BaseQuantity and xs:decimal(cac:Price/cbc:BaseQuantity) != 0) then
            xs:decimal(cac:Price/cbc:BaseQuantity)
          else
            1"/>
      <let name="allowancesTotal" value="
          if (cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'false']) then
            round(sum(cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'false']/cbc:Amount/xs:decimal(.)) * 10 * 10) div 100
          else
            0"/>
      <let name="chargesTotal" value="
          if (cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'true']) then
            round(sum(cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'true']/cbc:Amount/xs:decimal(.)) * 10 * 10) div 100
          else
            0"/>
      <assert id="PEPPOL-EN16931-R120" test="u:slack($lineExtensionAmount, ($quantity * ($priceAmount div $baseQuantity)) + $chargesTotal - $allowancesTotal, 0.02)" flag="fatal">Invoice line net amount MUST equal (Invoiced quantity * (Item net price/item price base quantity) + Sum of invoice line charge amount - sum of invoice line allowance amount</assert>
      <assert id="PEPPOL-EN16931-R121" test="not(cac:Price/cbc:BaseQuantity) or xs:decimal(cac:Price/cbc:BaseQuantity) &gt; 0" flag="fatal">Base quantity MUST be a positive number above zero.</assert>
      <assert id="PEPPOL-EN16931-R100" test="(count(cac:DocumentReference) &lt;= 1)" flag="fatal">Only one invoiced object is allowed pr line</assert>
      <assert id="PEPPOL-EN16931-R101" test="(not(cac:DocumentReference) or (cac:DocumentReference/cbc:DocumentTypeCode='130'))" flag="fatal">Element Document reference can only be used for Invoice line object</assert>
    </rule>
    <!-- Allowance (price level) -->
    <rule context="cac:Price/cac:AllowanceCharge">
      <assert id="PEPPOL-EN16931-R044" test="normalize-space(cbc:ChargeIndicator) = 'false'" flag="fatal">Charge on price level is NOT allowed. Only value 'false' allowed.</assert>
      <assert id="PEPPOL-EN16931-R046" test="not(cbc:BaseAmount) or xs:decimal(../cbc:PriceAmount) = xs:decimal(cbc:BaseAmount) - xs:decimal(cbc:Amount)" flag="fatal">Item net price MUST equal (Gross price - Allowance amount) when gross price is provided.</assert>
    </rule>
    <!-- Price -->
    <rule context="cac:Price/cbc:BaseQuantity[@unitCode]">
      <let name="hasQuantity" value="../../cbc:InvoicedQuantity or ../../cbc:CreditedQuantity"/>
      <let name="quantity" value="
          if (/ubl-invoice:Invoice) then
            ../../cbc:InvoicedQuantity
          else
            ../../cbc:CreditedQuantity"/>
      <assert id="PEPPOL-EN16931-R130" test="not($hasQuantity) or @unitCode = $quantity/@unitCode" flag="fatal">Unit code of price base quantity MUST be same as invoiced quantity.</assert>
    </rule>
    <!-- Validation of ICD -->
    <rule context="cbc:EndpointID[@schemeID = '0088'] | cac:PartyIdentification/cbc:ID[@schemeID = '0088'] | cbc:CompanyID[@schemeID = '0088']">
      <assert id="PEPPOL-COMMON-R040" test="matches(normalize-space(), '^[0-9]+$') and u:gln(normalize-space())" flag="fatal">GLN must have a valid format according to GS1 rules.</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '0192'] | cac:PartyIdentification/cbc:ID[@schemeID = '0192'] | cbc:CompanyID[@schemeID = '0192']">
      <assert id="PEPPOL-COMMON-R041" test="matches(normalize-space(), '^[0-9]{9}$') and u:mod11(normalize-space())" flag="fatal">Norwegian organization number MUST be stated in the correct format.</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = '0184'] | cac:PartyIdentification/cbc:ID[@schemeID = '0184'] | cbc:CompanyID[@schemeID = '0184']">
      <assert id="PEPPOL-COMMON-R042" test="(string-length(text()) = 10) and (substring(text(), 1, 2) = 'DK') and (string-length(translate(substring(text(), 3, 8), '1234567890', '')) = 0)" flag="fatal">Danish organization number (CVR) MUST be stated in the correct format.</assert>
    </rule>
  </pattern>
  <!-- National rules -->
  <!-- JAPAN -->
  <pattern id="JP">
    <rule context="/ubl-invoice:Invoice[cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'JP' ]">
      <!-- VAT Number Rules -->
      <assert id="JP-R-001" test="matches(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID),'^T[0-9]{13}$')" flag="fatal">For the Japanese Suppliers, the VAT must start with 'T' and must be 13 digits.</assert>
      <!-- cac:LegalMonetaryTotal -->
      <assert id="JP-R-002" test="xs:decimal(cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount) = xs:decimal(cac:LegalMonetaryTotal/cbc:LineExtensionAmount) + xs:decimal(cac:LegalMonetaryTotal/cbc:LineExtensionAmount)" flag="fatal">[JP-R-002]- </assert>
      <!-- Amount Representation Rules -->
      <assert id="JP-BR-DEC-05" test="not(exists(cac:AllowanceCharge[cbc:ChargeIndicator=true()])) or (matches(normalize-space(cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cbc:Amount),'^[1-9][0-9]*$'))" flag="fatal">[JP-BR-DEC-05]- the Document level charge amount (BT-99)  shall be integer.</assert>
      <!-- VAT Category TaxTotal Amount Rounding Rules -->
      <assert id="JP-BR-CO-17" test="(
  round(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/xs:decimal(cbc:Percent)) != 0 
  and (
    xs:decimal(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount) &gt;= floor(xs:decimal(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount) * (cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/xs:decimal(cbc:Percent) div 100)))
  and (
    xs:decimal(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount) &lt;= ceiling(xs:decimal(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount) * (cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/xs:decimal(cbc:Percent) div 100)))
)" flag="fatal">[JP-BR-CO-17]-VAT category tax amount (BT-117) = VAT category taxable amount (BT-116) x (VAT category rate (BT-119) / 100), rounded to integer. The rounded result amount SHALL be between the floor and the ceiling.</assert>
    </rule>
  </pattern>
  <!-- NORWAY -->
  <pattern>
    <rule context="cac:AccountingSupplierParty/cac:Party[$supplierCountry = 'NO']">
      <assert id="NO-R-002" test="normalize-space(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'TAX']/cbc:CompanyID) = 'Foretaksregisteret'" flag="warning">For Norwegian suppliers, most invoice issuers are required to append "Foretaksregisteret" to their
        invoice. "Dersom selger er aksjeselskap, allmennaksjeselskap eller filial av utenlandsk
        selskap skal også ordet «Foretaksregisteret» fremgå av salgsdokumentet, jf.
        foretaksregisterloven § 10-2."</assert>
      <assert id="NO-R-001" test="cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/substring(cbc:CompanyID, 1, 2)='NO' and matches(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/substring(cbc:CompanyID,3), '^[0-9]{9}MVA$')
          and u:mod11(substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID, 3, 9)) or not(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/substring(cbc:CompanyID, 1, 2)='NO')" flag="fatal">For Norwegian suppliers, a VAT number MUST be the country code prefix NO followed by a valid Norwegian organization number (nine numbers) followed by the letters MVA.</assert>
    </rule>
  </pattern>
  <!-- DENMARK -->
  <pattern>
    <let name="DKSupplierCountry" value="concat(ubl-creditnote:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode, ubl-invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)"/>
    <let name="DKCustomerCountry" value="concat(ubl-creditnote:CreditNote/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode, ubl-invoice:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)"/>
    <!-- Document level -->
    <rule context="ubl-creditnote:CreditNote[$DKSupplierCountry = 'DK'] | ubl-invoice:Invoice[$DKSupplierCountry = 'DK']">
      <assert id="DK-R-002" test="(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID/text()) != '')" flag="fatal">Danish suppliers MUST provide legal entity (CVR-number)</assert>
      <assert id="DK-R-014" test="not(((boolean(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID))
							   and (normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID/@schemeID) != '0184'))
						)" flag="fatal">For Danish Suppliers it is mandatory to specify schemeID as "0184" (DK CVR-number) when PartyLegalEntity/CompanyID is used for AccountingSupplierParty</assert>
      <assert id="DK-R-015" test="not((normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[1]/cac:TaxScheme/cbc:ID/text()) = 'VAT')
						and not ((string-length(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[1]/cbc:CompanyID/text()) = 10)
								 and (substring(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[1]/cbc:CompanyID/text(), 1, 2) = 'DK')
								 and (string-length(translate(substring(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[1]/cbc:CompanyID/text(), 3, 8), '1234567890', '')) = 0))
						or
						(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[2]/cac:TaxScheme/cbc:ID/text()) = 'VAT')
						and not ((string-length(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[2]/cbc:CompanyID/text()) = 10)
								 and (substring(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[2]/cbc:CompanyID/text(), 1, 2) = 'DK')
								 and (string-length(translate(substring(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[2]/cbc:CompanyID/text(), 3, 8), '1234567890', '')) = 0))
						)" flag="fatal">For Danish Suppliers, if specified, AccountingSupplierParty/PartyTaxScheme/CompanyID (DK VAT number) must start with DK followed by 8 digits</assert>
      <assert id="DK-R-016" test="not((boolean(/ubl-creditnote:CreditNote) and ($DKCustomerCountry = 'DK'))
						and (number(cac:LegalMonetaryTotal/cbc:PayableAmount/text()) &lt; 0)
						)" flag="fatal">For Danish Suppliers, a Credit note cannot have a negative total (PayableAmount)</assert>
    </rule>
    <rule context="ubl-creditnote:CreditNote[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification | ubl-creditnote:CreditNote[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification | ubl-invoice:Invoice[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification | ubl-invoice:Invoice[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification">
      <assert id="DK-R-013" test="not((boolean(cbc:ID))
						 and (normalize-space(cbc:ID/@schemeID) = '')
						)" flag="fatal">For Danish Suppliers it is mandatory to use schemeID when PartyIdentification/ID is used for AccountingCustomerParty or AccountingSupplierParty</assert>
    </rule>
    <rule context="ubl-invoice:Invoice[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:PaymentMeans">
      <assert id="DK-R-005" test="contains(' 1 10 31 42 48 49 50 58 59 93 97 ', concat(' ', cbc:PaymentMeansCode, ' '))" flag="fatal">For Danish suppliers the following Payment means codes are allowed: 1, 10, 31, 42, 48, 49, 50, 58, 59, 93 and 97</assert>
      <assert id="DK-R-006" test="not(((cbc:PaymentMeansCode = '31') or (cbc:PaymentMeansCode = '42'))
						and not((normalize-space(cac:PayeeFinancialAccount/cbc:ID/text()) != '') and (normalize-space(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID/text()) != ''))
						)" flag="fatal">For Danish suppliers bank account and registration account is mandatory if payment means is 31 or 42</assert>
      <assert id="DK-R-007" test="not((cbc:PaymentMeansCode = '49')
						and not((normalize-space(cac:PaymentMandate/cbc:ID/text()) != '')
							   and (normalize-space(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID/text()) != ''))
						)" flag="fatal">For Danish suppliers PaymentMandate/ID and PayerFinancialAccount/ID are mandatory when payment means is 49</assert>
      <assert id="DK-R-008" test="not((cbc:PaymentMeansCode = '50')
						and not(((substring(cbc:PaymentID, 1, 3) = '01#')
								  or (substring(cbc:PaymentID, 1, 3) = '04#')
								  or (substring(cbc:PaymentID, 1, 3) = '15#'))
								and (string-length(cac:PayeeFinancialAccount/cbc:ID/text()) = 7)
								)
						)" flag="fatal">For Danish Suppliers PaymentID is mandatory and MUST start with 01#, 04# or 15# (kortartkode), and PayeeFinancialAccount/ID (Giro kontonummer) is mandatory and must be 7 characters long, when payment means equals 50 (Giro)</assert>
      <assert id="DK-R-009" test="not((cbc:PaymentMeansCode = '50')
						and ((substring(cbc:PaymentID, 1, 3) = '04#')
							  or (substring(cbc:PaymentID, 1, 3)  = '15#'))
						and not(string-length(cbc:PaymentID) = 19)
						)" flag="fatal">For Danish Suppliers if the PaymentID is prefixed with 04# or 15# the 16 digits instruction Id must be added to the PaymentID eg. "04#1234567890123456" when Payment means equals 50 (Giro)</assert>
      <assert id="DK-R-010" test="not((cbc:PaymentMeansCode = '93')
						and not(((substring(cbc:PaymentID, 1, 3) = '71#')
								  or (substring(cbc:PaymentID, 1, 3) = '73#')
								  or (substring(cbc:PaymentID, 1, 3) = '75#'))
								and (string-length(cac:PayeeFinancialAccount/cbc:ID/text()) = 8)
								)
						)" flag="fatal">For Danish Suppliers the PaymentID is mandatory and MUST start with 71#, 73# or 75# (kortartkode) and PayeeFinancialAccount/ID (Kreditornummer) is mandatory and must be exactly 8 characters long, when Payment means equals 93 (FIK)</assert>
      <assert id="DK-R-011" test="not((cbc:PaymentMeansCode = '93')
						and ((substring(cbc:PaymentID, 1, 3) = '71#')
							  or (substring(cbc:PaymentID, 1, 3)  = '75#'))
						and not((string-length(cbc:PaymentID) = 18)
							  or (string-length(cbc:PaymentID) = 19))
						)" flag="fatal">For Danish Suppliers if the PaymentID is prefixed with 71# or 75# the 15-16 digits instruction Id must be added to the PaymentID eg. "71#1234567890123456" when payment Method equals 93 (FIK)</assert>
    </rule>
    <!-- Line level -->
    <rule context="ubl-creditnote:CreditNote[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:CreditNoteLine | ubl-invoice:Invoice[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:InvoiceLine">
      <assert id="DK-R-003" test="not((cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listID = 'TST')
						and not((cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listVersionID = '19.05.01')
							   or (cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listVersionID = '19.0501')
							   )
						)" flag="warning">If ItemClassification is provided from Danish suppliers, UNSPSC version 19.0501 should be used.</assert>
    </rule>
    <!-- Mix level -->
    <rule context="cac:AllowanceCharge[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']">
      <assert id="DK-R-004" test="not((cbc:AllowanceChargeReasonCode = 'ZZZ')
						and not((string-length(normalize-space(cbc:AllowanceChargeReason/text())) = 4)
								and (number(cbc:AllowanceChargeReason) &gt;= 0)
								and (number(cbc:AllowanceChargeReason) &lt;= 9999))
						)" flag="fatal">When specifying non-VAT Taxes, Danish suppliers MUST use the AllowanceChargeReasonCode="ZZZ" and the 4-digit Tax category MUST be specified in 'AllowanceChargeReason'</assert>
    </rule>
  </pattern>
  <!-- ITALY -->
  <pattern>
    <rule context="cac:AccountingSupplierParty/cac:Party[$supplierCountry = 'IT']/cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) != 'VAT']">
      <assert id="IT-R-001" test="matches(normalize-space(cbc:CompanyID),'^[A-Z0-9]{11,16}$')" flag="fatal">[IT-R-001] BT-32 (Seller tax registration identifier) - For Italian suppliers BT-32 minimum length 11 and maximum length shall be 16.  Per i fornitori italiani il BT-32 deve avere una lunghezza tra 11 e 16 caratteri</assert>
    </rule>
    <rule context="cac:AccountingSupplierParty/cac:Party[$supplierCountry = 'IT']">
      <assert id="IT-R-002" test="cac:PostalAddress/cbc:StreetName" flag="fatal">[IT-R-002] BT-35 (Seller address line 1) - Italian suppliers MUST provide the postal address line 1 - I fornitori italiani devono indicare l'indirizzo postale.</assert>
      <assert id="IT-R-003" test="cac:PostalAddress/cbc:CityName" flag="fatal">[IT-R-003] BT-37 (Seller city) - Italian suppliers MUST provide the postal address city - I fornitori italiani devono indicare la città di residenza.</assert>
      <assert id="IT-R-004" test="cac:PostalAddress/cbc:PostalZone" flag="fatal">">[IT-R-004] BT-38 (Seller post code) - Italian suppliers MUST provide the postal address post code - I fornitori italiani devono indicare il CAP di residenza.</assert>
    </rule>
  </pattern>
  <!-- SWEDEN -->
  <pattern>
    <rule context="//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2) = 'SE']">
      <assert id="SE-R-001" test="string-length(normalize-space(cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID)) = 14" flag="fatal">For Swedish suppliers, Swedish VAT-numbers must consist of 14 characters.</assert>
      <assert id="SE-R-002" test="string(number(substring(cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID, 3, 12))) != 'NaN'" flag="fatal">For Swedish suppliers, the Swedish VAT-numbers must have the trailing 12 characters in numeric form</assert>
    </rule>
    <rule context="//cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity[../cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and cbc:CompanyID]">
      <assert id="SE-R-003" test="string(number(cbc:CompanyID)) != 'NaN'" flag="warning">Swedish organisation numbers should be numeric.</assert>
      <assert id="SE-R-004" test="string-length(normalize-space(cbc:CompanyID)) = 10" flag="warning">Swedish organisation numbers consist of 10 characters.</assert>
    </rule>
    <rule context="//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and exists(cac:PartyLegalEntity/cbc:CompanyID)]/cac:PartyTaxScheme[normalize-space(upper-case(cac:TaxScheme/cbc:ID)) != 'VAT']/cbc:CompanyID">
      <assert id="SE-R-005" test="normalize-space(upper-case(.)) = 'GODKÄND FÖR F-SKATT'" flag="fatal">For Swedish suppliers, when using Seller tax registration identifier, 'Godkänd för F-skatt' must be stated</assert>
    </rule>
    <rule context="//cac:TaxCategory[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2) = 'SE'] and cbc:ID = 'S'] | //cac:ClassifiedTaxCategory[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2) = 'SE'] and cbc:ID = 'S']">
      <assert id="SE-R-006" test="number(cbc:Percent) = 25 or number(cbc:Percent) = 12 or number(cbc:Percent) = 6" flag="fatal">For Swedish suppliers, only standard VAT rate of 6, 12 or 25 are used</assert>
    </rule>
    <rule context="//cac:PaymentMeans[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and normalize-space(cbc:PaymentMeansCode) = '30' and normalize-space(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID) = 'SE:PLUSGIRO']/cac:PayeeFinancialAccount/cbc:ID">
      <assert id="SE-R-007" test="string(number(normalize-space(.))) != 'NaN'" flag="warning">For Swedish suppliers using Plusgiro, the Account ID must be numeric </assert>
      <assert id="SE-R-010" test="string-length(normalize-space(.)) &gt;= 2 and string-length(normalize-space(.)) &lt;= 8" flag="warning">For Swedish suppliers using Plusgiro, the Account ID must have 2-8 characters</assert>
    </rule>
    <rule context="//cac:PaymentMeans[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and normalize-space(cbc:PaymentMeansCode) = '30' and normalize-space(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID) = 'SE:BANKGIRO']/cac:PayeeFinancialAccount/cbc:ID">
      <assert id="SE-R-008" test="string(number(normalize-space(.))) != 'NaN'" flag="warning">For Swedish suppliers using Bankgiro, the Account ID must be numeric </assert>
      <assert id="SE-R-009" test="string-length(normalize-space(.)) = 7 or string-length(normalize-space(.)) = 8" flag="warning">For Swedish suppliers using Bankgiro, the Account ID must have 7-8 characters</assert>
    </rule>
    <rule context="//cac:PaymentMeans[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and (cbc:PaymentMeansCode = normalize-space('50') or cbc:PaymentMeansCode = normalize-space('56'))]">
      <assert id="SE-R-011" test="false()" flag="warning">For Swedish suppliers using Swedish Bankgiro or Plusgiro, the proper way to indicate this is to use Code 30 for PaymentMeans and FinancialInstitutionBranch ID with code SE:BANKGIRO or SE:PLUSGIRO</assert>
    </rule>
    <rule context="//cac:PaymentMeans[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE']  and //cac:AccountingCustomerParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and (cbc:PaymentMeansCode = normalize-space('31'))]">
      <assert id="SE-R-012" test="false()" flag="warning">For domestic transactions between Swedish trading partners, credit transfer should be indicated by PaymentMeansCode="30"</assert>
    </rule>
  </pattern>

	<!-- GREECE -->
	<!-- General functions and variable for Greek Rules -->
	<function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:TinVerification" as="xs:boolean">
		<param name="val" as="xs:string"/>
		<variable name="digits" select="
			for $ch in string-to-codepoints($val)
			return codepoints-to-string($ch)"/>
		<variable name="checksum" select="
			(number($digits[8])*2) +
			(number($digits[7])*4) +
			(number($digits[6])*8) +
			(number($digits[5])*16) +
			(number($digits[4])*32) +
			(number($digits[3])*64) +
			(number($digits[2])*128) +
			(number($digits[1])*256) "/>
		<value-of select="($checksum  mod 11) mod 10 = number($digits[9])"/>
	</function>

	<let name="isGreekSender" value="($supplierCountry ='GR') or ($supplierCountry ='EL')"/>
	<let name="isGreekReceiver" value="($customerCountry ='GR') or ($customerCountry ='EL')"/>
	<let name="isGreekSenderandReceiver" value="$isGreekSender and $isGreekReceiver"/>
  <!-- Test only accounting Supplier Country -->
  <let name="accountingSupplierCountry" value="
    if (/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)) then
    upper-case(normalize-space(/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)))
    else
    if (/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) then
    upper-case(normalize-space(/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))
    else
    'XX'"/>

  <!-- Sender Rules -->
	<pattern>
		<let name="dateRegExp" value="'^(0?[1-9]|[12][0-9]|3[01])[-\\/ ]?(0?[1-9]|1[0-2])[-\\/ ]?(19|20)[0-9]{2}'"/>
		<let name="greekDocumentType" value="tokenize('1.1 1.2 1.3 1.4 1.5 1.6 2.1 2.2 2.3 2.4 3.1 3.2 4 5.1 5.2 6.1 6.2 7.1 8.1 8.2 11.1 11.2 11.3 11.4 11.5','\s')"/>
	  <let name="tokenizedUblIssueDate" value="tokenize(/*/cbc:IssueDate,'-')"/>
	  

		<!-- Invoice ID -->
	  <rule context="/ubl-invoice:Invoice/cbc:ID[$isGreekSender] | /ubl-creditnote:CreditNote/cbc:ID[$isGreekSender]">
			<let name="IdSegments" value="tokenize(.,'\|')"/>
			<assert id="GR-R-001-1" test="count($IdSegments) = 6" flag="fatal"> When the Supplier is Greek, the Invoice Id should consist of 6 segments</assert>
			<assert id="GR-R-001-2" test="string-length(normalize-space($IdSegments[1])) = 9 
			                              and u:TinVerification($IdSegments[1])
			                              and ($IdSegments[1] = /*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 3, 9)
			                              or $IdSegments[1] = /*/cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 3, 9) )" 
			                              flag="fatal">When the Supplier is Greek, the Invoice Id first segment must be a valid TIN Number and match either the Supplier's or the Tax Representative's Tin Number</assert>
		  <let name="tokenizedIdDate" value="tokenize($IdSegments[2],'/')"/>
		  <assert id="GR-R-001-3" test="string-length(normalize-space($IdSegments[2]))>0 
			                              and matches($IdSegments[2],$dateRegExp)
			                              and ($tokenizedIdDate[1] = $tokenizedUblIssueDate[3] 
			                                and $tokenizedIdDate[2] = $tokenizedUblIssueDate[2]
			                                and $tokenizedIdDate[3] = $tokenizedUblIssueDate[1])" flag="fatal">When the Supplier is Greek, the Invoice Id second segment must be a valid Date that matches the invoice Issue Date</assert>
			<assert id="GR-R-001-4" test="string-length(normalize-space($IdSegments[3]))>0 and string(number($IdSegments[3])) != 'NaN' and xs:integer($IdSegments[3]) >= 0" flag="fatal">When Supplier is Greek, the Invoice Id third segment must be a positive integer</assert>
			<assert id="GR-R-001-5" test="string-length(normalize-space($IdSegments[4]))>0 and (some $c in $greekDocumentType satisfies $IdSegments[4] = $c)" flag="fatal">When Supplier is Greek, the Invoice Id in the fourth segment must be a valid greek document type</assert>
			<assert id="GR-R-001-6" test="string-length($IdSegments[5]) > 0 " flag="fatal">When Supplier is Greek, the Invoice Id fifth segment must not be empty</assert>
			<assert id="GR-R-001-7" test="string-length($IdSegments[6]) > 0 " flag="fatal">When Supplier is Greek, the Invoice Id sixth segment must not be empty</assert>
		  
		</rule>

		<rule context="cac:AccountingSupplierParty[$isGreekSender]/cac:Party">
			<!-- Supplier Name Mandatory -->
			<assert id="GR-R-002" test="string-length(./cac:PartyName/cbc:Name)>0" flag="fatal">Greek Suppliers must provide their full name as they are registered in the  Greek Business Registry (G.E.MH.) as a legal entity or in the Tax Registry as a natural person </assert>

			<!-- Tax Representative Mandatory -->
			<assert id="GR-R-007-1" test="
				count(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID) = 1 or
				count(/ubl-invoice:Invoice/cac:TaxRepresentativeParty) = 1" flag="fatal">When greek supplier does not have a VAT number, the tax representative must be present</assert>
		</rule>

		<!-- Tax Representative Rules -->
		<rule context="cac:TaxRepresentativeParty[$isGreekSender]">
			<assert id="GR-R-007-2" test="string-length(normalize-space(cac:PartyName/cbc:Name))>0" flag="fatal">If the Greek Suppliers do not have Greek VAT they must provide the full name of their tax representative in Greece</assert>
			<assert id="GR-R-007-3" test="count(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID)=1 and
				substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID,1,2) = 'EL' and
				u:TinVerification(substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID,3))" flag="fatal">If the Greek Suppliers do not have Greek VAT, they must provide the VAT number of their tax representative</assert>
		</rule>


		<!-- VAT Number Rules -->
		<rule context="cac:AccountingSupplierParty[$isGreekSender]/cac:Party/cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID">
			<assert id="GR-R-003" test="substring(.,1,2) = 'EL' and u:TinVerification(substring(.,3))" flag="fatal">For the Greek Suppliers, the VAT must start with 'EL' and must be a valid TIN number</assert>
		</rule>

		<!-- Document Reference Rules (existence of MARK and Invoice Verification URL) -->
		<rule context="/ubl-invoice:Invoice[$isGreekSender] | /ubl-creditnote:CreditNote[$isGreekSender]">
			<!-- ΜARK Rules -->
			<assert id="GR-R-004-1" test="count(cac:AdditionalDocumentReference[cbc:DocumentDescription = '##M.AR.K##'])=1" flag="fatal"> When Supplier is Greek, there must be one MARK Number</assert>
			<assert id="GR-S-008-1" flag="warning" test="count(cac:AdditionalDocumentReference[cbc:DocumentDescription = '##INVOICE-URL##'])=1"> When Supplier is Greek, there should be one invoice url</assert>
			<assert id="GR-R-008-2" test="(count(cac:AdditionalDocumentReference[cbc:DocumentDescription = '##INVOICE-URL##']) = 0 ) or (count(cac:AdditionalDocumentReference[cbc:DocumentDescription = '##INVOICE-URL##']) = 1 )"  flag="fatal"> When Supplier is Greek, there should be no more than one invoice url</assert>
		</rule>

		<!-- MARK Rules -->
		<rule context="cac:AdditionalDocumentReference[$isGreekSender and cbc:DocumentDescription = '##M.AR.K##']/cbc:ID">
			<assert id="GR-R-004-2" test="matches(.,'^[1-9]([0-9]*)')" flag="fatal"> When Supplier is Greek, the MARK Number must be a positive integer</assert>
		</rule>

		<!-- Invoice Verification URL Rules -->
		<rule context="cac:AdditionalDocumentReference[$isGreekSender and cbc:DocumentDescription = '##INVOICE-URL##']">
			<assert id="GR-R-008-3" test="string-length(normalize-space(cac:Attachment/cac:ExternalReference/cbc:URI))>0" flag="fatal">When Supplier is Greek and the INVOICE URL Document reference exists, the External Reference URI should be present</assert>
		</rule>

		<!-- Customer Name Mandatory -->
		<rule context="cac:AccountingCustomerParty[$isGreekSender]/cac:Party">
			<assert id="GR-R-005" test="string-length(./cac:PartyName/cbc:Name)>0" flag="fatal">Greek Suppliers must provide the full name of the buyer</assert>
		</rule>

		<!-- Endpoint Rules -->
	  <rule context="cac:AccountingSupplierParty/cac:Party[$accountingSupplierCountry='GR' or $accountingSupplierCountry='EL']/cbc:EndpointID">
	    <assert id="GR-R-009" test="./@schemeID='9933' and u:TinVerification(.)" flag="fatal">Greek suppliers that send an invoice through the PEPPOL network must use a correct TIN number as an electronic address according to PEPPOL Electronic Address Identifier scheme (schemeID 9933).</assert>
		</rule>

	</pattern>

	<!-- Greek Sender and Greek Receiver rules -->
	<pattern>
		<!-- VAT Number Rules -->
	  <rule context="cac:AccountingCustomerParty[$isGreekSenderandReceiver]/cac:Party">
			<assert id="GR-R-006" test="count(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID)=1 and
				                        substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID,1,2) = 'EL' and
				                        u:TinVerification(substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID,3))" flag="fatal">Greek Suppliers must provide the VAT number of the buyer, if the buyer is Greek </assert>
		</rule>

		<!-- Endpoint Rules -->
		<rule context="cac:AccountingCustomerParty[$isGreekSenderandReceiver]/cac:Party/cbc:EndpointID">
		  <assert id="GR-R-010" test="./@schemeID='9933' and u:TinVerification(.)" flag="fatal">Greek Suppliers that send an invoice through the PEPPOL network to a greek buyer must use a correct TIN number as an electronic address according to PEPPOL Electronic Address Identifier scheme (SchemeID 9933)</assert>
		</rule>
	</pattern>

  	<!-- ICELAND -->
  
	<pattern>
		<let name="SupplierCountry" value="concat(ubl-creditnote:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode, ubl-invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)"/>
		<let name="CustomerCountry" value="concat(ubl-creditnote:CreditNote/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode, ubl-invoice:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)"/>

		<rule context="ubl-creditnote:CreditNote[$SupplierCountry = 'IS'] | ubl-invoice:Invoice[$SupplierCountry = 'IS']">

			<assert 
				id="IS-R-001"
				test="( ( not(contains(normalize-space(cbc:InvoiceTypeCode),' ')) and contains( ' 380 381 ',concat(' ',normalize-space(cbc:InvoiceTypeCode),' ') ) ) ) or ( ( not(contains(normalize-space(cbc:CreditNoteTypeCode),' ')) and contains( ' 380 381 ',concat(' ',normalize-space(cbc:CreditNoteTypeCode),' ') ) ) )"
				flag="warning">[IS-R-001]-If seller is icelandic then invoice type should be 380 or 381 — Ef seljandi er íslenskur þá ætti gerð reiknings (BT-3) að vera sölureikningur (380) eða kreditreikningur (381).</assert>

			<assert 
				id="IS-R-002"
				test="exists(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID) and cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID/@schemeID = '0196'"
				flag="fatal">[IS-R-002]-If seller is icelandic then it shall contain sellers legal id — Ef seljandi er íslenskur þá skal reikningur innihalda íslenska kennitölu seljanda (BT-30).</assert>

			<assert 
				id="IS-R-003"
				test="exists(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName) and exists(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone)"
				flag="fatal">[IS-R-003]-If seller is icelandic then it shall contain his address with street name and zip code — Ef seljandi er íslenskur þá skal heimilisfang seljanda innihalda götuheiti og póstnúmer (BT-35 og BT-38).</assert>

			<assert 
				id="IS-R-006"
				test="exists(cac:PaymentMeans[cbc:PaymentMeansCode = '9']/cac:PayeeFinancialAccount/cbc:ID) 
					  and string-length(normalize-space(cac:PaymentMeans[cbc:PaymentMeansCode = '9']/cac:PayeeFinancialAccount/cbc:ID)) = 12
					  or not(exists(cac:PaymentMeans[cbc:PaymentMeansCode = '9']))"
				flag="fatal">[IS-R-006]-If seller is icelandic and payment means code is 9 then a 12 digit account id must exist  — Ef seljandi er íslenskur og greiðslumáti (BT-81) er millifærsla (kóti 9) þá skal koma fram 12 stafa reikningnúmer (BT-84)</assert>

			<assert 
				id="IS-R-007"
				test="exists(cac:PaymentMeans[cbc:PaymentMeansCode = '42']/cac:PayeeFinancialAccount/cbc:ID) 
					  and string-length(normalize-space(cac:PaymentMeans[cbc:PaymentMeansCode = '42']/cac:PayeeFinancialAccount/cbc:ID)) = 12
					  or not(exists(cac:PaymentMeans[cbc:PaymentMeansCode = '42']))"
				flag="fatal">[IS-R-007]-If seller is icelandic and payment means code is 42 then a 12 digit account id must exist  — Ef seljandi er íslenskur og greiðslumáti (BT-81) er millifærsla (kóti 42) þá skal koma fram 12 stafa reikningnúmer (BT-84)</assert>
				
			<assert 
				id="IS-R-008"
				test="(exists(cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']) and string-length(cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']/cbc:ID) = 10 and (string(cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']/cbc:ID) castable as xs:date)) or not(exists(cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']))"
				flag="fatal">[IS-R-008]-If seller is icelandic and invoice contains supporting description EINDAGI then the id form must be YYYY-MM-DD — Ef seljandi er íslenskur þá skal eindagi (BT-122, DocumentDescription = EINDAGI) vera á forminu YYYY-MM-DD.</assert>

			<assert 
				id="IS-R-009"
				test="(exists(cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']) and exists(cbc:DueDate)) or not(exists(cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']))"
				flag="fatal">[IS-R-009]-If seller is icelandic and invoice contains supporting description EINDAGI invoice must have due date — Ef seljandi er íslenskur þá skal reikningur sem inniheldur eindaga (BT-122, DocumentDescription = EINDAGI) einnig hafa gjalddaga (BT-9).</assert>

			<assert 
				id="IS-R-010"
				test="(exists(cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']) and (cbc:DueDate) &lt;= (cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']/cbc:ID)) or not(exists(cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']))"
				flag="fatal">[IS-R-010]-If seller is icelandic and invoice contains supporting description EINDAGI the id date must be same or later than due date — Ef seljandi er íslenskur þá skal eindagi (BT-122, DocumentDescription = EINDAGI) skal vera sami eða síðar en gjalddagi (BT-9) ef eindagi er til staðar.</assert>

		</rule>
		
		<rule context="ubl-creditnote:CreditNote[$SupplierCountry = 'IS' and $CustomerCountry = 'IS']/cac:AccountingCustomerParty | ubl-invoice:Invoice[$SupplierCountry = 'IS' and $CustomerCountry = 'IS']/cac:AccountingCustomerParty">

			<assert 
				id="IS-R-004"
				test="exists(cac:Party/cac:PartyLegalEntity/cbc:CompanyID) and cac:Party/cac:PartyLegalEntity/cbc:CompanyID/@schemeID = '0196'"
				flag="fatal">[IS-R-004]-If seller and buyer are icelandic then the invoice shall contain the buyers icelandic legal identifier — Ef seljandi og kaupandi eru íslenskir þá skal reikningurinn innihalda íslenska kennitölu kaupanda (BT-47).</assert>

			<assert 
				id="IS-R-005"
				test="exists(cac:Party/cac:PostalAddress/cbc:StreetName) and exists(cac:Party/cac:PostalAddress/cbc:PostalZone)"
				flag="fatal">[IS-R-005]-If seller and buyer are icelandic then the invoice shall contain the buyers address with street name and zip code  — Ef seljandi og kaupandi eru íslenskir þá skal heimilisfang kaupanda innihalda götuheiti og póstnúmer (BT-50 og BT-53)</assert>
		
		</rule>
	</pattern>
  
  <!-- Restricted code lists and formatting -->
  <pattern>
    <let name="ISO3166" value="tokenize('AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW 1A XI', '\s')"/>
    <let name="ISO4217" value="tokenize('AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STN SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL', '\s')"/>
    <let name="MIMECODE" value="tokenize('application/pdf image/png image/jpeg text/csv application/vnd.openxmlformats-officedocument.spreadsheetml.sheet application/vnd.oasis.opendocument.spreadsheet', '\s')"/>
    <let name="UNCL2005" value="tokenize('3 35 432', '\s')"/>
    <let name="UNCL5189" value="tokenize('41 42 60 62 63 64 65 66 67 68 70 71 88 95 100 102 103 104 105', '\s')"/>
    <let name="UNCL7161" value="tokenize('AA AAA AAC AAD AAE AAF AAH AAI AAS AAT AAV AAY AAZ ABA ABB ABC ABD ABF ABK ABL ABN ABR ABS ABT ABU ACF ACG ACH ACI ACJ ACK ACL ACM ACS ADC ADE ADJ ADK ADL ADM ADN ADO ADP ADQ ADR ADT ADW ADY ADZ AEA AEB AEC AED AEF AEH AEI AEJ AEK AEL AEM AEN AEO AEP AES AET AEU AEV AEW AEX AEY AEZ AJ AU CA CAB CAD CAE CAF CAI CAJ CAK CAL CAM CAN CAO CAP CAQ CAR CAS CAT CAU CAV CAW CAX CAY CAZ CD CG CS CT DAB DAC DAD DAF DAG DAH DAI DAJ DAK DAL DAM DAN DAO DAP DAQ DL EG EP ER FAA FAB FAC FC FH FI GAA HAA HD HH IAA IAB ID IF IR IS KO L1 LA LAA LAB LF MAE MI ML NAA OA PA PAA PC PL RAB RAC RAD RAF RE RF RH RV SA SAA SAD SAE SAI SG SH SM SU TAB TAC TT TV V1 V2 WH XAA YY ZZZ', '\s')"/>
    <let name="UNCL5305" value="tokenize('AE E S Z G O K L M', '\s')"/>
    <let name="eaid" value="tokenize('0002 0007 0009 0037 0060 0088 0096 0097 0106 0130 0135 0142 0151 0183 0184 0188 0190 0191 0192 0193 0195 0196 0198 0199 0200 0201 0202 0204 0208 0209 0210 0211 0212 0213 9901 9906 9907 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9955 9957', '\s')"/>
    <rule context="cbc:EmbeddedDocumentBinaryObject[@mimeCode]">
      <assert id="PEPPOL-EN16931-CL001" test="
          some $code in $MIMECODE
            satisfies @mimeCode = $code" flag="fatal">Mime code must be according to subset of IANA code list.</assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator = 'false']/cbc:AllowanceChargeReasonCode">
      <assert id="PEPPOL-EN16931-CL002" test="
          some $code in $UNCL5189
            satisfies normalize-space(text()) = $code" flag="fatal">Reason code MUST be according to subset of UNCL 5189 D.16B.</assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator = 'true']/cbc:AllowanceChargeReasonCode">
      <assert id="PEPPOL-EN16931-CL003" test="
          some $code in $UNCL7161
            satisfies normalize-space(text()) = $code" flag="fatal">Reason code MUST be according to UNCL 7161 D.16B.</assert>
    </rule>
    <rule context="cac:InvoicePeriod/cbc:DescriptionCode">
      <assert id="PEPPOL-EN16931-CL006" test="
          some $code in $UNCL2005
            satisfies normalize-space(text()) = $code" flag="fatal">Invoice period description code must be according to UNCL 2005 D.16B.</assert>
    </rule>
    <rule context="cbc:Amount | cbc:BaseAmount | cbc:PriceAmount | cbc:TaxAmount | cbc:TaxableAmount | cbc:LineExtensionAmount | cbc:TaxExclusiveAmount | cbc:TaxInclusiveAmount | cbc:AllowanceTotalAmount | cbc:ChargeTotalAmount | cbc:PrepaidAmount | cbc:PayableRoundingAmount | cbc:PayableAmount">
      <assert id="PEPPOL-EN16931-CL007" test="
          some $code in $ISO4217
            satisfies @currencyID = $code" flag="fatal">Currency code must be according to ISO 4217:2005</assert>
    </rule>
    <rule context="cbc:InvoiceTypeCode">
      <assert id="PEPPOL-EN16931-P0100" test="
          $profile != '01' or (some $code in tokenize('380 383 386 393 82 80 84 395 575 623 780', '\s')
            satisfies normalize-space(text()) = $code)" flag="fatal">Invoice type code MUST be set according to the profile.</assert>
    </rule>
    <rule context="cbc:CreditNoteTypeCode">
      <assert id="PEPPOL-EN16931-P0101" test="
          $profile != '01' or (some $code in tokenize('381 396 81 83 532', '\s')
            satisfies normalize-space(text()) = $code)" flag="fatal">Credit note type code MUST be set according to the profile.</assert>
    </rule>
    <rule context="cbc:IssueDate | cbc:DueDate | cbc:TaxPointDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate">
      <assert id="PEPPOL-EN16931-F001" test="string-length(text()) = 10 and (string(.) castable as xs:date)" flag="fatal">A date
        MUST be formatted YYYY-MM-DD.</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID]">
      <assert id="PEPPOL-EN16931-CL008" test="
        some $code in $eaid
        satisfies @schemeID = $code" flag="fatal">Electronic address identifier scheme must be from the codelist "Electronic Address Identifier Scheme"</assert>
    </rule>
    <rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-G']">
      <assert id="PEPPOL-EN16931-P0104" test="normalize-space(cbc:ID)='G'" flag="fatal">Tax Category G MUST be used when exemption reason code is VATEX-EU-G</assert>
    </rule>
    <rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-O']">
      <assert id="PEPPOL-EN16931-P0105" test="normalize-space(cbc:ID)='O'" flag="fatal">Tax Category O MUST be used when exemption reason code is VATEX-EU-O</assert>
    </rule>
    <rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-IC']">
      <assert id="PEPPOL-EN16931-P0106" test="normalize-space(cbc:ID)='K'" flag="fatal">Tax Category K MUST be used when exemption reason code is VATEX-EU-IC</assert>
    </rule>
    <rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-AE']">
      <assert id="PEPPOL-EN16931-P0107" test="normalize-space(cbc:ID)='AE'" flag="fatal">Tax Category AE MUST be used when exemption reason code is VATEX-EU-AE</assert>
    </rule>
    <rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-D']">
      <assert id="PEPPOL-EN16931-P0108" test="normalize-space(cbc:ID)='E'" flag="fatal">Tax Category E MUST be used when exemption reason code is VATEX-EU-D</assert>
    </rule>
    <rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-F']">
      <assert id="PEPPOL-EN16931-P0109" test="normalize-space(cbc:ID)='E'" flag="fatal">Tax Category E MUST be used when exemption reason code is VATEX-EU-F</assert>
    </rule>
    <rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-I']">
      <assert id="PEPPOL-EN16931-P0110" test="normalize-space(cbc:ID)='E'" flag="fatal">Tax Category E MUST be used when exemption reason code is VATEX-EU-I</assert>
    </rule>
    <rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-J']">
      <assert id="PEPPOL-EN16931-P0111" test="normalize-space(cbc:ID)='E'" flag="fatal">Tax Category E MUST be used when exemption reason code is VATEX-EU-J</assert>
    </rule>
  </pattern>
</schema>
