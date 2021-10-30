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
  <!-- Parameters -->
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
	<!-- -->
	<let name="documentCurrencyCode" value="/*/cbc:DocumentCurrencyCode"/>
	<let name="taxCurrencyCode" value="/*/cbc:TaxCurrencyCode"/>
	<!-- Functions -->
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
    (
      10 - ($weightedSum mod 10)) mod 10 = number(substring($val, $length + 1, 1)
    )"/>
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
 <!--
	<function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:mod11" as="xs:boolean">
		<param name="val"/>
		<variable name="length" select="string-length($val) - 1"/>
		<variable name="digits" select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)"/>
		<variable name="weightedSum" select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (($i mod 6) + 2))"/>
		<value-of select="
    number($val) &gt; 0 and 
    (11 - ($weightedSum mod 11)) mod 
    11 = number(substring($val, $length + 1, 1))
  "/>
	</function>
-->
  <phase id="UBL_phase">
    <active pattern="UBL-syntax"/>
  </phase>

  <phase id="Japanmodel_phase">
    <active pattern="JP-UBL-model"/>
  </phase>
  <phase id="Japanese_codelist_phase">
    <active pattern="JP-Codesmodel"/>
  </phase>  

  <phase id="PINTmodel_phase">
    <active pattern="UBL-model"/>
  </phase>
  <phase id="codelist_phase">
    <active pattern="Codesmodel"/>
  </phase>

  <pattern id="JP-UBL-model">
    <!-- JP-03 -->
    <rule context="cbc:TaxCurrencyCode">
      <assert id="PEPPOL-EN16931-R005" flag="fatal" test="
      not(normalize-space(text()) = normalize-space(../cbc:DocumentCurrencyCode/text()))
      ">[PEPPOL-EN16931-R005]-VAT accounting currency code MUST be different from invoice currency code when provided.
      </assert>
    </rule>
    <!-- JP-04 -->
    <rule context="/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = false()]">
      <assert id="BR-32" flag="fatal" test="
      exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID)
      ">
      [BR-32]-Each Document level allowance (BG-20) shall have a Document level allowance VAT category code (BT-95).
      </assert>
    </rule>
    <!-- JP-05 -->
    <rule context="/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = true()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = true()]">
      <assert id="BR-37" flag="fatal" test="
      exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID)
      ">
      [BR-37]-Each Document level charge (BG-21) shall have a Document level charge VAT category code (BT-102).
      </assert>
    </rule>
    <!-- JP-06 -->
    <rule context="ubl:InvoiceLine">
      <assert id="BR-CO-04" flag="fatal" test="
      (
        cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/(normalize-space(upper-case(cbc:ID))='VAT')]/cbc:ID
      )">
      [BR-CO-04]-Each Invoice line (BG-25) shall be categorized with an Invoiced item VAT category code (BT-151).
      </assert>
    </rule>
    <rule context="cac:TaxTotal/cac:TaxSubtotal">
      <!-- JP-07 -->
      <assert id="BR-45" flag="fatal" test="
      exists(cbc:TaxableAmount)
      ">
      [BR-45]-Each VAT breakdown (BG-23) shall have a VAT category taxable amount (BT-116).
      </assert>
      <assert id="BR-46" flag="fatal" test="
      exists(cbc:TaxAmount)
      ">
      [BR-46]-Each VAT breakdown (BG-23) shall have a VAT category tax amount (BT-117).
      </assert>
      <!-- JP-08 -->
      <assert id="BR-47" flag="fatal" test="
      exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID)
      ">
      [BR-47]-Each VAT breakdown (BG-23) shall be defined through a VAT category code (BT-118).
      </assert>
      <!-- JP-09 -->
      <assert id="BR-48" flag="fatal" test="
      exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:Percent) or 
      (
        cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/normalize-space(cbc:ID)='O'
      )">
      [BR-48]-Each VAT breakdown (BG-23) shall have a VAT category rate (BT-119), except if the Invoice is Outside of scope of VAT.
      </assert>
      <!-- JP-10 -->
      <assert id="JP-10" flag="fatal" test="
      exists(cac:TaxCategory/cac:TaxScheme/cbc:ID)
      ">
      [JP-10]-Tax breakdown (ibg-23) shall hove Tax scheme (ibt-118-1).
      </assert>
    </rule>
    <rule context="/ubl:Invoice | /cn:CreditNote">
      <!-- JP-16 -->
      <assert id="JP-16" flag="fatal" test="
      exists(cac:InvoicePeriod) or 
      exists(cac:InvoiceLine/cac:InvoicePeriod)
      ">
      [JP-16]-An Invoice shall have “Invoice period” (ibg-14) or “Invoice line period” (ibg-26).
      </assert>
    </rule>
    <rule context="cbc:IssueDate | cbc:DueDate | cbc:TaxPointDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate">
      <!-- JP-17 -->
      <assert id="PEPPOL-EN16931-F001" flag="fatal" test="
      string-length(text()) = 10 and 
      (
        string(.) castable as xs:date
      )">
      [PEPPOL-EN16931-F001(JP-17)]-A date MUST be formatted YYYY-MM-DD.
      </assert>
    </rule>
    <!-- Line level - invoice period -->
    <rule context="ubl:Invoice[cac:InvoicePeriod/cbc:StartDate]/cac:InvoiceLine/cac:InvoicePeriod/cbc:StartDate | cn:CreditNote[cac:InvoicePeriod/cbc:StartDate]/cac:CreditNoteLine/cac:InvoicePeriod/cbc:StartDate">
      <assert id="PEPPOL-EN16931-R110" flag="fatal" test="
      xs:date(text()) &gt;= xs:date(../../../cac:InvoicePeriod/cbc:StartDate)
      ">
      [PEPPOL-EN16931-R110(JP-20)]-Start date of line period MUST be within invoice period.
      </assert>
    </rule>
    <rule context="ubl:Invoice[cac:InvoicePeriod/cbc:EndDate]/cac:InvoiceLine/cac:InvoicePeriod/cbc:EndDate | cn:CreditNote[cac:InvoicePeriod/cbc:EndDate]/cac:CreditNoteLine/cac:InvoicePeriod/cbc:EndDate">
      <assert id="PEPPOL-EN16931-R111" flag="fatal" test="
      xs:date(text()) &lt;= xs:date(../../../cac:InvoicePeriod/cbc:EndDate)
      ">
      [PEPPOL-EN16931-R111(JP-20)]-End date of line period MUST be within invoice period.</assert>
    </rule>
    <!-- Allowance (price level) -->
    <rule context="cac:Price/cac:AllowanceCharge">
      <assert id="PEPPOL-EN16931-R044" flag="fatal" test="
      normalize-space(cbc:ChargeIndicator) = 'false'
      ">
      [PEPPOL-EN16931-R044]-Charge on price level is NOT allowed. Only value 'false' allowed.
      </assert>
      <assert id="PEPPOL-EN16931-R046" flag="fatal" test="
      not(cbc:BaseAmount) or 
      xs:decimal(../cbc:PriceAmount) = xs:decimal(cbc:BaseAmount) - xs:decimal(cbc:Amount)
      ">
      [PEPPOL-EN16931-R046 (JP-21)]-Item net price MUST equal (Gross price - Allowance amount) when gross price is provided.</assert>
    </rule>
    <!-- Price -->
    <rule context="cac:Price/cbc:BaseQuantity[@unitCode]">
      <let name="hasQuantity" value="
      ../../cbc:InvoicedQuantity or 
      ../../cbc:CreditedQuantity
      "/>
      <let name="quantity" value="
      if (/ubl:Invoice) then
        ../../cbc:InvoicedQuantity
      else
        ../../cbc:CreditedQuantity
      "/>
      <assert id="PEPPOL-EN16931-R130" flag="fatal" test="
      not($hasQuantity) or 
      @unitCode = $quantity/@unitCode
      ">
      [EPPOL-EN16931-R130]-Unit code of price base quantity MUST be same as invoiced quantity.
      </assert>
    </rule>
    <!-- Line level - line extension amount -->
    <rule context="cac:InvoiceLine | cac:CreditNoteLine">
      <let name="lineExtensionAmountJPY" value="
      if (cbc:LineExtensionAmount[@currencyID='JPY']) then
        xs:decimal(cbc:LineExtensionAmount)
      else
        0
      "/>
      <let name="lineExtensionAmount" value="
      if (cbc:LineExtensionAmount[not(@currencyID='JPY')]) then
        xs:decimal(cbc:LineExtensionAmount)
      else
        0
      "/>
      <let name="quantity" value="
      if (/ubl:Invoice) then
        (if (cbc:InvoicedQuantity) then
          xs:decimal(cbc:InvoicedQuantity)
        else
          1)
      else
        (if (cbc:CreditedQuantity) then
          xs:decimal(cbc:CreditedQuantity)
        else
          1)
      "/>
      <let name="priceAmountJPY" value="
      if (cac:Price/cbc:PriceAmount[@currencyID='JPY']) then
        xs:decimal(cac:Price/cbc:PriceAmount)
      else
        0
      "/>
      <let name="priceAmount" value="
      if (cac:Price/cbc:PriceAmount[not(@currencyID='JPY')]) then
        xs:decimal(cac:Price/cbc:PriceAmount)
      else
        0
      "/>
      <let name="baseQuantity" value="
      if (cac:Price/cbc:BaseQuantity and xs:decimal(cac:Price/cbc:BaseQuantity) != 0) then
        xs:decimal(cac:Price/cbc:BaseQuantity)
      else
        1
      "/>
      <let name="allowancesTotalJPY" value="
      if (cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator)='false'][@currencyID='JPY']) then
        sum(cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator)='false']/cbc:Amount/xs:decimal(.))
      else
        0
      "/>
      <let name="allowancesTotal" value="
      if (cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator)='false'][not(@currencyID='JPY')]) then
        round(sum(cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator)='false']/cbc:Amount/xs:decimal(.)) * 10 * 10) div 100
      else
        0
      "/>
      <let name="chargesTotalJPY" value="
      if (cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator)='true'][@currencyID='JPY']) then
        round(sum(cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator)='true']/cbc:Amount/xs:decimal(.)) * 10 * 10) div 100
      else
        0
      "/>
      <let name="chargesTotal" value="
      if (cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator)='true'][not(@currencyID='JPY')]) then
        round(sum(cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator)='true']/cbc:Amount/xs:decimal(.)) * 10 * 10) div 100
      else
        0
      "/>
      <assert id="PEPPOL-EN16931-R120" flag="fatal" test="
      (
        u:slack($lineExtensionAmountJPY, ($quantity * ($priceAmountJPY div $baseQuantity)) + $chargesTotalJPY - $allowancesTotalJPY, 0)
      ) or (
        u:slack($lineExtensionAmount, ($quantity * ($priceAmount div $baseQuantity)) + $chargesTotal - $allowancesTotal, 0.02)
      )
      ">
      [PEPPOL-EN16931-R120 (JP-22)]-Invoice line net amount MUST equal (Invoiced quantity * (Item net price/item price base quantity) + Sum of invoice line charge amount - sum of invoice line allowance amount
      </assert>
      <assert id="PEPPOL-EN16931-R121" flag="fatal" test="
      not(cac:Price/cbc:BaseQuantity) or 
      xs:decimal(cac:Price/cbc:BaseQuantity) &gt; 0
      ">
      [PEPPOL-EN16931-R121]-Base quantity MUST be a positive number above zero.
      </assert>
      <!--
      <assert id="PEPPOL-EN16931-R100" test="(count(cac:DocumentReference) &lt;= 1)" flag="fatal">Only one invoiced object is allowed pr line</assert>
      <assert id="PEPPOL-EN16931-R101" test="(not(cac:DocumentReference) or (cac:DocumentReference/cbc:DocumentTypeCode='130'))" flag="fatal">Element Document reference can only be used for Invoice line object</assert>
      -->
    </rule>
    <rule context="/ubl:Invoice[cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode='JP']/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | /cn:CreditNote[cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode='JP']/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="jp-br-01" flag="fatal" test="
      matches(normalize-space(cbc:CompanyID),'^T[0-9]{13}$')
      ">
      [jp-br-01]- For the Japanese Suppliers, the Tax identifier must start with 'T' and must be 13 digits.
      </assert>
    </rule>
    <rule context="/ubl:Invoice/*[local-name()!='InvoiceLine']/*[@currencyID='JPY'] |
      /ubl:Invoice/*[local-name()!='InvoiceLine']/*/*[@currencyID='JPY'] |
      /ubl:Invoice/cac:InvoiceLine/cbc:LineExtensionAmount[@currencyID='JPY'] |
      /cn:CreditNote/*[local-name()!='CreditNoteLine']/*[@currencyID='JPY'] |
      /cn:CreditNote/*[local-name()!='CreditNoteLine']/*/*[@currencyID='JPY'] |
      /cn:CreditNote/cac:CreditNoteLine/cbc:LineExtensionAmount[@currencyID='JPY']">
      <assert id="jp-br-02" flag="fatal" test="
      matches(normalize-space(.),'^-?[1-9][0-9]*$')
      ">
      [jp-br-02]- Amount shall be integer.
      </assert>
    </rule>
    <rule context="/ubl:Invoice | /cn:CreditNote">
      <assert id="jp-br-03" flag="fatal" test="
      (
        not(exists(cac:InvoicePeriod))
      ) or (
        exists(cac:InvoicePeriod) or
        exists(cac:InvoiceLine/cac:InvoicePeriod) or
        exists(cac:CredotNoteLine/cac:InvoicePeriod)
      )
      ">[jp-br-03]-An Invoice shall have INVOICE PERIOD (ibg-14) or INVOICE LINE PERIOD (ibg-26)
      </assert>
    </rule>
    <!-- JP-06 -->
    <rule context="/ubl:Invoice/cac:InvoiceLine | /cn:CreditNote/cac:CreditNoteLine">
      <assert id="jp-br-04" flag="fatal" test="
      (
        count(cac:AllowanceCharge[cbc:ChargeIndicator=false()]) = 0
      ) or (
        count(cac:AllowanceCharge[cbc:ChargeIndicator=false()]) &gt;= 1 and
        exists(cac:Item/cac:ClassifiedTaxcategory/cbc:ID) and
        exists(cac:Item/cac:ClassifiedTaxcategory/cbc:Percent)
      )
      ">
      [jp-br-04]-INVOICE LINE ALLOWANCES shall be categorized by Invoiced item TAX category code (ibt-151) and Invoiced item TAX rate (ibt-152)
      </assert>
    </rule>
    <rule context="/ubl:Invoice/cac:AllowanceCharge | /cn:CreditNote/cac:AllowanceCharge">
      <assert id="jp-br-05" flag="fatal" test="
      exists(.[cbc:ChargeIndicator=false()]/cac:TaxCategory/cbc:ID[normalize-space(.)='S' or normalize-space(.)='AA']) and
      xs:decimal(.[cbc:ChargeIndicator=false()]/cac:TaxCategory/cbc:Percent) &gt; 0
      ">
      [jp-br-05]-In a DOCUMENT LEVEL ALLOWANE (ibg-20) where the Document level allowance consumption tax category code (ibt-095) is either "Standard rate" or "Reduced rate" the Document level allowance TAX rate (ibt-096) shall be greater than zero.
      </assert>
      <assert id="jp-br-06" flag="fatal" test="
      exists(.[cbc:ChargeIndicator=true()]/cac:TaxCategory/cbc:ID[normalize-space(.)='S' or normalize-space(.)='AA']) and
      xs:decimal(.[cbc:ChargeIndicator=true()]/cac:TaxCategory/cbc:Percent) &gt; 0
      ">
      [jp-br-06]-In a DOCUMENT LEVEL CHARGE (ibg-21) where the document level charge consumption tax category code (ibt-102) is either "Standard rate" or "Reduced rate" the document level charge TAX rate (ibt-103) shall be greater than zero.
      </assert>
      <!-- JP-04 -->
      <assert id="jp-br-07" flag="fatal" test="
      exists(.[cbc:ChargeIndicator=false()]) and
      exists(.[cbc:ChargeIndicator=false()]/cac:TaxCategory/cbc:ID) and
      exists(.[cbc:ChargeIndicator=false()]/cac:TaxCategory/cbc:Percent)
      ">
      [jp-br-07]-In a DOCUMENT LEVEL ALLOWANE (ibg-20) shall be categorized by the document level allowance TAX category code (ibt-095) and the document level TAX rate (ibt-096).
      </assert>
      <!-- JP-05 -->
      <assert id="jp-br-08" flag="fatal" test="
      exists(.[cbc:ChargeIndicator=true()]) and
      exists(.[cbc:ChargeIndicator=true()]/cac:TaxCategory/cbc:ID) and
      exists(.[cbc:ChargeIndicator=true()]/cac:TaxCategory/cbc:Percent)
      ">
      [jp-br-08]-In a DOCUMENT LEVEL CHARGE (ibg-21) shall be categorized by the document level charge TAX category code (ibt-102) and the document level charge TAX rate (ibt-103).
      </assert>
    </rule>
    <rule context="/ubl:Invoice[cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode='JP'] | /cn:CreditNote[cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode='JP']">
      <assert id="jp-br-co-01" flag="fatal" test="
      (
        round(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/xs:decimal(cbc:Percent)) != 0 and
        (
          xs:decimal(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount) &gt;=
          floor(xs:decimal(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount) * (cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/xs:decimal(cbc:Percent) div 100))
        ) and
        xs:decimal(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount) &lt;=
        ceiling(xs:decimal(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount) * (cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/xs:decimal(cbc:Percent) div 100))
      )">
      [jp-br-co-01]-Consumption Tax category tax amount (BT-117) = Consumption Tax category taxable amount (BT-116) x (Consumption Tax category rate (BT-119) / 100), rounded to integer. The rounded result amount SHALL be between the floor and the ceiling.
      </assert>
    </rule>
    <rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory [normalize-space(cbc:ID)='S' or normalize-space(cbc:ID)='AA'] [cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] |
        cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory [normalize-space(cbc:ID)='S' or normalize-space(cbc:ID)='AA'] [cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="jp-br-co-02" flag="fatal" test="
      xs:decimal(cbc:Percent) &gt; 0
      ">
      [jp-br-co-02]-In an Invoice line (BG-25) where the Invoiced item Consumption Tax category code (BT-151) is "Standard rated" or "Reduced tate" the Invoiced item Consumption Tax rate (BT-152) shall be greater than zero.
      </assert>
    </rule>
    <rule context="/ubl:Invoice/cac:InvoicePeriod | /cn:CreditNote/cac:InvoicePeriod">
      <!-- JP-18 -->
      <assert id="jp-br-co-03" flag="fatal" test="
      exists(cbc:StartDate) and exists(cbc:EndDate)
      ">
      [jp-br-co-03]-If INVOICING PERIOD (ibg-14) is used, both the Invoicing period start date (ibt-073) and the Invoicing period end date (ibt-074) shall be filled.
      </assert>
    </rule>
    <rule context="cac:InvoiceLine/cac:InvoicePeriod | cac:CreditNoteLine/cac:InvoicePeriod">
      <!-- JP-19 -->
      <assert id="jp-br-co-04" flag="fatal" test="
      exists(cbc:StartDate) and exists(cbc:EndDate)
      ">
      [jp-br-co-04]-If INVOICE LINE PERIOD (ibg26) is used, both the Invoice line period start date (ibt-134) and the Invoice line period end date (ibt-135) shall be filled.
      </assert>
    </rule>
    <!-- Standard rate -->
    <rule context="/ubl:Invoice | /cn:CreditNote">
      <assert id="jp-s-01" flag="fatal" test="
      (
        (
          count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID)='S']) +
          count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='S'])
        ) &gt; 0 and
        count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID)='S']) &gt; 0
      ) or (
        (
          count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID)='S']) +
          count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='S'])
        ) = 0 and
        count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID)='S']) = 0
      )">
      <!-- Stabdard rate -->
      [jp-s-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the Consumption Tax category code (BT-151, BT-95 or BT-102) is "Standard rated" shall contain in the Consumption Tax breakdown (BG-23) at least one Consumption Tax category code (BT-118) equal with "Standard rated".
      </assert>
      <assert id="jp-s-02" flag="fatal" test="
      (
        exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and
        (
          exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or
          exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID))='VAT')]/cbc:CompanyID)
        )
      ) or
        not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='S']))
      ">
      [jp-s-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item Consumption Tax category code (BT-151) is "Standard rated" shall contain the Seller Consumption Tax Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative Consumption Tax identifier (BT-63).
      </assert>
      <assert id="jp-s-03" flag="fatal" test="
      (
        exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and
        (
          exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or
          exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID))='VAT')]/cbc:CompanyID)
        )
      ) or
        not(
          exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])
        )
      ">
      [jp-s-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance Consumption Tax category code (BT-95) is "Standard rated" shall contain the Seller Consumption Tax Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative Consumption Tax identifier (BT-63).
      </assert>
      <assert id="jp-s-04" flag="fatal" test="
      (
        exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and
        (
          exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or
          exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID))='VAT')]/cbc:CompanyID)
        )
      ) or
        not(
          exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])
        )
      ">
      [jp-s-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge Consumption Tax category code (BT-102) is "Standard rated" shall contain the Seller Consumption Tax Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative Consumption Tax identifier (BT-63).
      </assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="jp-s-06" flag="fatal" test="
      (cbc:Percent) &gt; 0
      ">
      [jp-s-06]-In a Document level allowance (BG-20) where the Document level allowance Consumption Tax category code (BT-95) is "Standard rated" the Document level allowance Consumption Tax rate (BT-96) shall be greater than zero.
      </assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="jp-s-07" flag="fatal" test="
      (cbc:Percent) &gt; 0
      ">
      [jp-s-07]-In a Document level charge (BG-21) where the Document level charge Consumption Tax category code (BT-102) is "Standard rated" the Document level charge Consumption Tax rate (BT-103) shall be greater than zero.
      </assert>
    </rule>
    <rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'][../cbc:TaxAmount/@currencyID='JPY']">
      <assert id="jp-s-08" flag="fatal" test="
      every $rate in xs:decimal(cbc:Percent) satisfies (
        (
          not(exists(//cac:InvoiceLine/cac:Item[cbc:LineExtensionAmount/@currencyID='JPY'][cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent)=$rate])) and
          not(exists(//cac:AllowanceCharge[cbc:Amount/@currencyID='JPY'][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent)=$rate]))
        ) or (
          (
            exists(//cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent)=$rate]) or
            exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent)=$rate])
          ) and (
            (
              xs:decimal(../cbc:TaxableAmount) - 1 &lt;
              (
                sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent)=$rate]/xs:decimal(cbc:LineExtensionAmount)) +
                sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent)=$rate]/xs:decimal(cbc:Amount)) -
                sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent)=$rate]/xs:decimal(cbc:Amount))
              )
            ) and (
              xs:decimal(../cbc:TaxableAmount) + 1 &gt;
              (
                sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent)=$rate]/xs:decimal(cbc:LineExtensionAmount)) +
                sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent)=$rate]/xs:decimal(cbc:Amount)) -
                sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent)=$rate]/xs:decimal(cbc:Amount))
              )
            )
          )
        ) or (
          (
            exists(//cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent)=$rate]) or
            exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent)=$rate])
          ) and (
            (
              xs:decimal(../cbc:TaxableAmount) - 1 &lt;
              (
                sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent)=$rate]/xs:decimal(cbc:LineExtensionAmount)) +
                sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent)=$rate]/xs:decimal(cbc:Amount)) -
                sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent)=$rate]/xs:decimal(cbc:Amount))
              )
            ) and (
              xs:decimal(../cbc:TaxableAmount) + 1 &gt;
              (
                sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent)=$rate]/xs:decimal(cbc:LineExtensionAmount)) +
                sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent)=$rate]/xs:decimal(cbc:Amount)) -
                sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent)=$rate]/xs:decimal(cbc:Amount))
              )
            )
          )
        )
      )">
      [jp-s-08]-For each different value of Consumption Tax category rate (BT-119) where the Consumption Tax category code (BT-118) is "Standard rated", the Consumption Tax category taxable amount (BT-116) in a Consumption Tax breakdown (BG-23) shall equal the sum of Invoice line net amounts (BT-131) plus the sum of document level charge amounts (BT-99) minus the sum of document level allowance amounts (BT-92) where the Consumption Tax category code (BT-151, BT-102, BT-95) is "Standard rated" and the Consumption Tax rate (BT-152, BT-103, BT-96) equals the Consumption Tax category rate (BT-119).
      </assert>      
      <assert id="jp-s-09" flag="fatal" test="
      (
        (
          xs:decimal(../cbc:TaxAmount[@currencyID='JPY']) &lt;=
          ceiling(xs:decimal(../cbc:TaxableAmount[@currencyID='JPY']) * xs:decimal(cbc:Percent) div 100)
        ) and (
          xs:decimal(../cbc:TaxAmount[@currencyID='JPY']) &gt;=
          floor(xs:decimal(../cbc:TaxableAmount[@currencyID='JPY']) * xs:decimal(cbc:Percent) div 100)
        )
      ) or (
        (
          abs(xs:decimal(../cbc:TaxAmount[not(@currencyID='JPY')])) - 1 &lt;  
          round(abs(xs:decimal(../cbc:TaxableAmount[not(@currencyID='JPY')]) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100
        ) and (
          abs(xs:decimal(../cbc:TaxAmount[not(@currencyID='JPY')])) + 1 &gt;
          round(abs(xs:decimal(../cbc:TaxableAmount[not(@currencyID='JPY')]) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100
        )
      )">
      [jp-s-09]-The Consumption Tax category tax amount (BT-117) in a Consumption Tax breakdown (BG-23) where Consumption Tax category code (BT-118) is "Standard rated" shall equal the Consumption Tax category taxable amount (BT-116) multiplied by the Consumption Tax category rate (BT-119).
      </assert>
      <assert id="jp-s-10" flag="fatal" test="
      not(cbc:TaxExemptionReason) and
      not(cbc:TaxExemptionReasonCode)
      ">
      [jp-s-10]-A Consumption Tax breakdown (BG-23) with Consumption Tax Category code (BT-118) "Standard rate" shall not have a Consumption Tax exemption reason code (BT-121) or Consumption Tax exemption reason text (BT-120).
      </assert>    
    </rule>
    <!-- Reduced rate -->
    <rule context="/ubl:Invoice | /cn:CreditNote">
      <assert id="jp-aa-01" flag="fatal" test="
      (
        (
          count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID)='AA']) +
          count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='AA'])
        ) &gt; 0 and
        count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID)='AA']) &gt; 0
      ) or (
        (
          count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID)='AA']) +
          count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='AA'])
        ) = 0 and
        count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID)='AA']) = 0
      )
      ">
      [jp-aa-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the Consumption Tax category code (BT-151, BT-95 or BT-102) is "Standard rated" shall contain in the Consumption Tax breakdown (BG-23) at least one Consumption Tax category code (BT-118) equal with "Standard rated".
      </assert>
      <assert id="jp-aa-02" flag="fatal" test="
      (
        exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='AA'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and
        (
          exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or
          exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID))='VAT')]/cbc:CompanyID)
        )
      ) or
        not(
          exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='AA'])
        )
      ">
      [jp-aa-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item Consumption Tax category code (BT-151) is "Standard rated" shall contain the Seller Consumption Tax Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative Consumption Tax identifier (BT-63).
      </assert>
      <assert id="jp-aa-03" flag="fatal" test="
        (
          exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='AA'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and
          (
            exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or
            exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID))='VAT')]/cbc:CompanyID)
          )
        ) or
          not(
            exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='AA'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])
          )
      ">
      [jp-aa-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance Consumption Tax category code (BT-95) is "Standard rated" shall contain the Seller Consumption Tax Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative Consumption Tax identifier (BT-63).
      </assert>
      <assert id="jp-aa-04" flag="fatal" test="
        (
          exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='AA'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and
          (
            exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or
            exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID))='VAT')]/cbc:CompanyID)
          )
        ) or
          not(
            exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='AA'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])
          )
      ">
      [jp-aa-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge Consumption Tax category code (BT-102) is "Standard rated" shall contain the Seller Consumption Tax Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative Consumption Tax identifier (BT-63).
      </assert>
    </rule>
    <rule context="//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='AA'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="jp-aa-06" flag="fatal" test="
      xs:decimal(cbc:Percent) &gt; 0
      ">
      [jp-aa-06]-In a Document level allowance (BG-20) where the Document level allowance Consumption Tax category code (BT-95) is "Reduced rated" the Document level allowance Consumption Tax rate (BT-96) shall be greater than zero.
      </assert>
    </rule>
    <rule context="//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='AA'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="jp-aa-07" flag="fatal" test="
      xs:decimal(cbc:Percent) &gt; 0
      ">
      [jp-aa-07]-In a Document level charge (BG-21) where the Document level charge Consumption Tax category code (BT-102) is "Reduced rated" the Document level charge Consumption Tax rate (BT-103) shall be greater than zero.
      </assert>
    </rule>
    <rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID)='AA'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'][../cbc:TaxAmount/@currencyID='JPY']">
      <assert id="jp-aa-08" flag="fatal" test="
        every $rate in xs:decimal(cbc:Percent) satisfies (
        (
          not(exists(//cac:InvoiceLine/cac:Item[cbc:LineExtensionAmount/@currencyID='JPY'][cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='AA'][cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent)=$rate])) and
          not(exists(//cac:AllowanceCharge[cbc:Amount/@currencyID='JPY'][cac:TaxCategory/normalize-space(cbc:ID)='AA'][cac:TaxCategory/xs:decimal(cbc:Percent)=$rate]))
        ) or (
          (
            exists(//cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='AA'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent)=$rate]) or
            exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='AA'][cac:TaxCategory/xs:decimal(cbc:Percent)=$rate])
          ) and (
            xs:decimal(../cbc:TaxableAmount) =
              sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='AA'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent)=$rate]/xs:decimal(cbc:LineExtensionAmount)) +
              sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='AA'][cac:TaxCategory/xs:decimal(cbc:Percent)=$rate]/xs:decimal(cbc:Amount)) -
              sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='AA'][cac:TaxCategory/xs:decimal(cbc:Percent)=$rate]/xs:decimal(cbc:Amount))
          )
        ) or (
          (
            exists(//cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='AA'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent)=$rate]) or
            exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='AA'][cac:TaxCategory/xs:decimal(cbc:Percent)=$rate])
          ) and (
            xs:decimal(../cbc:TaxableAmount) =
              sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='AA'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent)=$rate]/xs:decimal(cbc:LineExtensionAmount)) +
              sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='AA'][cac:TaxCategory/xs:decimal(cbc:Percent)=$rate]/xs:decimal(cbc:Amount)) -
              sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='AA'][cac:TaxCategory/xs:decimal(cbc:Percent)=$rate]/xs:decimal(cbc:Amount))
          )
        )
      )">
      [jp-aa-08]-For each different value of Consumption Tax category rate (BT-119) where the Consumption Tax category code (BT-118) is "Reduced rated", the Consumption Tax category taxable amount (BT-116) in a Consumption Tax breakdown (BG-23) shall equal the sum of Invoice line net amounts (BT-131) plus the sum of document level charge amounts (BT-99) minus the sum of document level allowance amounts (BT-92) where the Consumption Tax category code (BT-151, BT-102, BT-95) is "Standard rated" and the Consumption Tax rate (BT-152, BT-103, BT-96) equals the Consumption Tax category rate (BT-119).
      </assert>      
      <assert id="jp-aa-09" flag="fatal" test="
      (
        (
          xs:decimal(../cbc:TaxAmount[@currencyID='JPY']) &lt;=
          ceiling(xs:decimal(../cbc:TaxableAmount[@currencyID='JPY']) * xs:decimal(cbc:Percent) div 100)
        ) and (
          xs:decimal(../cbc:TaxAmount[@currencyID='JPY']) &gt;=
          floor(xs:decimal(../cbc:TaxableAmount[@currencyID='JPY']) * xs:decimal(cbc:Percent) div 100)
        )
      ) or (
        (
          abs(xs:decimal(../cbc:TaxAmount[not(@currencyID='JPY')])) - 1 &lt;  
          round((abs(xs:decimal(../cbc:TaxableAmount[not(@currencyID='JPY')])) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100
        ) and (
          abs(xs:decimal(../cbc:TaxAmount[not(@currencyID='JPY')])) + 1 &gt;
          round((abs(xs:decimal(../cbc:TaxableAmount[not(@currencyID='JPY')])) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100
        )
      )
      ">
      [jp-aa-09]-The Consumption Tax category tax amount (BT-117) in a Consumption Tax breakdown (BG-23) where Consumption Tax category code (BT-118) is "Reduced rated" shall equal the Consumption Tax category taxable amount (BT-116) multiplied by the Consumption Tax category rate (BT-119).
      </assert>
      <assert id="jp-aa-10" flag="fatal" test="
      not(cbc:TaxExemptionReason) and
      not(cbc:TaxExemptionReasonCode)
      ">
      [jp-aa-10]-A Consumption Tax breakdown (BG-23) with Consumption Tax Category code (BT-118) "Reduced rate" shall not have a Consumption Tax exemption reason code (BT-121) or Consumption Tax exemption reason text (BT-120).
      </assert>
    </rule>
    <rule context="/ubl:Invoice | /cn:CreditNote">
      <!-- E: Exempt from VAT -->
      <assert id="BR-E-01" flag="fatal" test="
      (
        (
          exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.)='E']) or 
          exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.)='E'])
        ) and (
          count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.)='E']) = 1
        )
      ) or (
        not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.)='E']) and
        not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.)='E'])
      )">
      [BR-E-01(JP-27)]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Exempt from VAT" shall contain exactly one VAT breakdown (BG-23) with the VAT category code (BT-118) equal to "Exempt from VAT".
      </assert>
      <!-- G: Export outside the EU" -->
      <assert id="BR-G-01" flag="fatal" test="
      (
        (
          exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.)='G']) or
          exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.)='G'])
        ) and (
          count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.)='G']) = 1
        )
      ) or (
        not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.)='G']) and 
        not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.)='G'])
      )">
      [BR-G-01(JP-30)]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Export outside the EU" shall contain in the VAT breakdown (BG-23) exactly one VAT category code (BT-118) equal with "Export outside the EU".
      </assert>
      <!-- O: Outside of scope of VAT -->
      <assert id="BR-O-01" flag="fatal" test="
      (
        (
          exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.)='O']) or 
          exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.)='O'])
        ) and (
          count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.)='O']) = 1
        )
      ) or (
        not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.)='O']) and
        not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.)='O'])
      )">
      [BR-O-01(JP-33)]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Outside of scope of VAT" shall contain exactly one VAT breakdown group (BG-23) with the VAT category code (BT-118) equal to "Outside of scope of VAT".
      </assert>
    </rule>
    <!-- E: Exempt from VAT -->
    <rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | 
        cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-E-05" flag="fatal" test="
      xs:decimal(cbc:Percent) = 0
      ">
      [BR-E-05(JP-28)]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Exempt from VAT", the Invoiced item VAT rate (BT-152) shall be 0 (zero).</assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-E-06" flag="fatal" test="
      xs:decimal(cbc:Percent) = 0
      ">
      [BR-E-06(JP-28)]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Exempt from VAT", the Document level allowance VAT rate (BT-96) shall be 0 (zero).
      </assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-E-07" flag="fatal" test="
      xs:decimal(cbc:Percent) = 0
      ">
      [BR-E-07(JP-28)]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Exempt from VAT", the Document level charge VAT rate (BT-103) shall be 0 (zero).
      </assert>
    </rule>
    <rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-E-09" flag="fatal" test="
      xs:decimal(../cbc:TaxAmount) = 0
      ">
      [BR-E-09(JP-29)]-The VAT category tax amount (BT-117) In a VAT breakdown (BG-23) where the VAT category code (BT-118) equals "Exempt from VAT" shall equal 0 (zero).</assert>
    </rule>
    <!-- G: Export outside the EU" -->
    <rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | 
        cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-G-05" flag="fatal" test="
      xs:decimal(cbc:Percent) = 0
      ">
      [BR-G-05(JP-31)]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Export outside the EU" the Invoiced item VAT rate (BT-152) shall be 0 (zero).
      </assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-G-06" flag="fatal" test="
      xs:decimal(cbc:Percent) = 0
      ">
      [BR-G-06(JP-31)]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Export outside the EU" the Document level allowance VAT rate (BT-96) shall be 0 (zero).
      </assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-G-07" flag="fatal" test="
      xs:decimal(cbc:Percent) = 0
      ">
      [BR-G-07(JP-31)]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Export outside the EU" the Document level charge VAT rate (BT-103) shall be 0 (zero).
      </assert>
    </rule>
    <rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-G-09" flag="fatal" test="
      xs:decimal(../cbc:TaxAmount) = 0
      ">
      [BR-G-09(JP-32)]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Export outside the EU" shall be 0 (zero).
      </assert>
    </rule>
    <!-- O: Outside of scope of VAT -->
    <rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | 
        cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-O-05" flag="fatal" test="
      not(cbc:Percent)
      ">[BR-O-05(JP-34)]-An Invoice line (BG-25) where the VAT category code (BT-151) is "Outside of scope of VAT" shall not contain an Invoiced item VAT rate (BT-152).
      </assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-O-06" flag="fatal" test="
      not(cbc:Percent)
      ">[BR-O-06(JP-34)]-A Document level allowance (BG-20) where VAT category code (BT-95) is "Outside of scope of VAT" shall not contain a Document level allowance VAT rate (BT-96).
      </assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-O-07" flag="fatal" test="
      not(cbc:Percent)
      ">
      [BR-O-07(JP-34)]-A Document level charge (BG-21) where the VAT category code (BT-102) is "Outside of scope of VAT" shall not contain a Document level charge VAT rate (BT-103).
      </assert>
    </rule>
    <rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="BR-O-09" flag="fatal" test="
      xs:decimal(../cbc:TaxAmount) = 0
      ">
      [BR-O-09(JP-35)]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Outside of scope of VAT" shall be 0 (zero).
      </assert>
    </rule>

  </pattern>

  <pattern id="JP-Codesmodel">

    <rule flag="fatal" context="cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode">
      <assert id="jp-cl-01" flag="fatal" test="
      (
        self::cbc:InvoiceTypeCode and (
          (
            not(contains(normalize-space(.), ' ')) and
            contains(' 80 82 84 380 383 386 393 395 575 623 780 ', concat(' ', normalize-space(.), ' '))
          )
        )
      ) or (
        self::cbc:CreditNoteTypeCode and (
          (
            not(contains(normalize-space(.), ' ')) and
            contains(' 81 83 381 396 532 ', concat(' ', normalize-space(.), ' '))
          )
        )
      )">
      [jp-cl-01]-The document type code MUST be coded by the Japanese invoice and Japanese credit note related code lists of UNTDID 1001.
      </assert>
    </rule>
    <rule flag="fatal" context="cac:PaymentMeans/cbc:PaymentMeansCode">
      <assert id="jp-cl-02" flag="fatal" test="
      (
        (
          not(contains(normalize-space(.),' ')) and
          contains( ' 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 70 74 75 76 77 78 91 92 93 94 95 96 97 ZZZ Z01 Z02 ',concat(' ',normalize-space(.),' '))
        )
      )">
      [jp-cl-02]-Payment means in a Japanese invoice MUST be coded using a restricted version of the UNCL4461 code list (adding Z01 and Z02)
      </assert>
    </rule>
    <rule flag="fatal" context="cac:TaxCategory/cbc:ID | cac:ClassifiedTaxCategory/cbc:ID">
      <assert id="jp-cl-03" flag="fatal" test="
      (
        (
          not(contains(normalize-space(.),' ')) and
          contains( ' AA S Z G O E ',concat(' ',normalize-space(.),' '))
        )
      )">
      [jp-cl-03]- Japanese invoice tax categories MUST be coded using UNCL5305 code list
      </assert>
    </rule>  
    <rule flag="fatal" context="cbc:TaxExemptionReasonCode">
      <assert id="jp-cl-04" flag="fatal" test="
      (
        (
          not(contains(normalize-space(.), ' ')) and
          contains(' ZZZ ', concat(' ', normalize-space(upper-case(.)), ' '))
        )
      )">
      [jp-cl-04]-Tax exemption reason code identifier scheme identifier MUST belong to the ????</assert>
    </rule>

    <rule context="/ubl:Invoice | cn:CreditNote">
      <assert id="jp-ibr-53" flag="fatal" test="
      every $taxcurrency in cbc:TaxCurrencyCode satisfies (
        exists(//cac:TaxTotal/cbc:TaxAmount[@currencyID=$taxcurrency])
      )">
      [jp-ibr-53]-If the Tax accounting currency code (ibt-006) is present, then the Invoice total Tax amount in accounting currency (ibt-111) shall be provided.
      </assert>
      <assert id="jp-ibr-co-15" flag="fatal" test="
      (
        not(exists(cac:LegalMonetaryTotal/xs:decimal(cbc:TaxInclusiveAmount[@currencyID='JPY'])))
      ) or (
        cac:LegalMonetaryTotal/xs:decimal(cbc:TaxInclusiveAmount[@currencyID='JPY']) = 
        cac:LegalMonetaryTotal/xs:decimal(cbc:TaxExclusiveAmount[@currencyID='JPY']) + cac:TaxTotal/xs:decimal(cbc:TaxAmount[@currencyID='JPY'])
      )">
      [jp-ibr-co-15]-Invoice total amount with Tax (ibt-112) = Invoice total amount without Tax (ibt-109) + Invoice total Tax amount (ibt-110).
      </assert>
    </rule>

    <!-- Validation of ICD -->
    <rule context="cbc:EndpointID[@schemeID = '0088'] | cac:PartyIdentification/cbc:ID[@schemeID = '0088'] | cbc:CompanyID[@schemeID = '0088']">
      <assert id="PEPPOL-COMMON-R040" flag="fatal" test="
      matches(normalize-space(), '^[0-9]+$') and 
      u:gln(normalize-space())
      ">[PEPPOL-COMMON-R040(JP-36)]-GLN must have a valid format according to GS1 rules.</assert>
    </rule>

  </pattern>

  <pattern id="UBL-model">

    <rule context="cac:AdditionalDocumentReference">
      <assert id="ibr-52" flag="fatal" test="
      (cbc:ID) != ''
      ">
      [ibr-52]-Each Additional supporting document (ibg-24) shall contain a Supporting document reference (ibt-122).
      </assert>
    </rule>
    <rule context="cac:LegalMonetaryTotal/cbc:PayableAmount">
      <assert id="ibr-67" flag="fatal" test="
      string-length(substring-after(., '.')) &lt;= 2
      ">
      [ibr-67]-Invoice amount due for payment (ibt-115) shall have no more than 2 decimals.
      </assert>
      <assert id="ibr-co-25" flag="fatal" test="
      (
        (
          . &gt; 0
        ) and (
          exists(//cbc:DueDate) or
          exists(//cac:PaymentTerms/cbc:Note)
        )
      ) or (
        . &lt;= 0
      )">
      [ibr-co-25]-In case the Amount due for payment (ibt-115) is positive, either the Payment due date (ibt-009) or the Payment terms (ibt-020) shall be present.
      </assert>
    </rule>
    <!-- Accounting supplier -->
    <rule context="cac:AccountingSupplierParty/cac:Party">
      <assert id="PEPPOL-EN16931-R020" flag="fatal" test="
      cbc:EndpointID
      ">
      [PEPPOL-EN16931-R020(JP-47)]-Seller electronic address (ibt-034) MUST be provided
      </assert>
      <assert id="ibr-6a" flag="fatal" test="
      exists(cbc:EndpointID/@schemeID)
      ">
      [ibr-6a]-The Seller electronic address (ibt-034) shall have a Scheme identifier.
      </assert>
      <assert id="ibr-06" flag="fatal" test="
      (cac:PartyLegalEntity/cbc:RegistrationName) !=''
      ">
      [ibr-06]-An Invoice shall contain the Seller name (ibt-027).
      </assert>
      <assert id="ibr-08" flag="fatal" test="
      exists(cac:PostalAddress)
      ">
      [ibr-08]-An Invoice shall contain the Seller postal address (ibg-05).
      </assert>
    </rule>    
    <!-- Accounting customer -->
    <rule context="cac:AccountingCustomerParty/cac:Party">
      <assert id="PEPPOL-EN16931-R010" flag="fatal" test="
      cbc:EndpointID
      ">
      [PEPPOL-EN16931-R010(JP-46)]-Buyer electronic address MUST be provided
      </assert>
      <assert id="ibr-63" flag="fatal" test="
      exists(cbc:EndpointID/@schemeID)
      ">
      [ibr-63]-The Buyer electronic address (ibt-049) shall have a Scheme identifier.
      </assert>
      <assert id="ibr-07" flag="fatal" test="
      (cac:PartyLegalEntity/cbc:RegistrationName) != ''
      ">
      [ibr-07]-An Invoice shall contain the Buyer name (ibt-044).
      </assert>
      <assert id="ibr-10" flag="fatal" test="
      exists(cac:PostalAddress)
      ">
      [ibr-10]-An Invoice shall contain the Buyer postal address (ibg-08).
      </assert>
    </rule>
    <rule context="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID">

    </rule>
    <rule context="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress">
      <assert id="ibr-11" flag="fatal" test="
      exists(cac:Country/cbc:IdentificationCode)
      ">
      [ibr-11]-The Buyer postal address (ibg-08) shall contain a Buyer country code (ibt-055).
      </assert>
    </rule>
    <rule context="cac:Delivery/cac:DeliveryLocation/cac:Address">
      <assert id="ibr-57" flag="fatal" test="
      exists(cac:Country/cbc:IdentificationCode)
      ">
      [ibr-57]-Each Deliver to address (ibg-15) shall contain a Deliver to country code (ibt-080).
      </assert>
    </rule>
    <rule context="/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = false()] |
        /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = false()]">
      <assert id="ibr-31" flag="fatal" test="
      exists(cbc:Amount)
      ">
      [ibr-31]-Each Document level allowance (ibg-20) shall have a Document level allowance amount (ibt-092).
      </assert>
      <assert id="ibr-33" flag="fatal" test="
      exists(cbc:AllowanceChargeReason) or 
      exists(cbc:AllowanceChargeReasonCode)
      ">
      [ibr-33]-Each Document level allowance (ibg-20) shall have a Document level allowance reason (ibt-097) or a Document level allowance reason code (ibt-098).
      </assert>
      <!--      <assert id="ibr-co-05" flag="fatal" test="true()">[ibr-co-05]-Document level allowance reason code (ibt-098) and Document level allowance reason (ibt-097) shall indicate the same type of allowance.</assert>
      -->
      <assert id="ibr-co-21" flag="fatal" test="
      exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)
      ">
      [ibr-co-21]-Each Document level allowance (ibg-20) shall contain a Document level allowance reason (ibt-097) or a Document level allowance reason code (ibt-098), or both.
      </assert>
    </rule>
    <rule context="/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = true()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = true()]">
      <assert id="ibr-36" flag="fatal" test="
      exists(cbc:Amount)
      ">
      [ibr-36]-Each Document level charge (ibg-21) shall have a Document level charge amount (ibt-099).
      </assert>
      <assert id="ibr-38" flag="fatal" test="
      exists(cbc:AllowanceChargeReason) or 
      exists(cbc:AllowanceChargeReasonCode)
      ">
      [ibr-38]-Each Document level charge (ibg-21) shall have a Document level charge reason (ibt-104) or a Document level charge reason code (ibt-105).
      </assert>
      <!--      <assert id="ibr-co-06" flag="fatal" test="true()">[ibr-co-06]-Document level charge reason code (ibt-105) and Document level charge reason (ibt-104) shall indicate the same type of charge.</assert>
      -->
      <assert id="ibr-co-22" flag="fatal" test="
      exists(cbc:AllowanceChargeReason) or 
      exists(cbc:AllowanceChargeReasonCode)
      ">
      [ibr-co-22]-Each Document level charge (ibg-21) shall contain a Document level charge reason (ibt-104) or a Document level charge reason code (ibt-105), or both.
      </assert>
    </rule>
    <rule context="cac:LegalMonetaryTotal">
      <assert id="ibr-12" flag="fatal" test="
      exists(cbc:LineExtensionAmount)
      ">
      [ibr-12]-An Invoice shall have the Sum of Invoice line net amount (ibt-106).
      </assert>
      <assert id="ibr-13" flag="fatal" test="
      exists(cbc:TaxExclusiveAmount)
      ">
      [ibr-13]-An Invoice shall have the Invoice total amount without Tax (ibt-109).
      </assert>
      <assert id="ibr-14" flag="fatal" test="
      exists(cbc:TaxInclusiveAmount)
      ">
      [ibr-14]-An Invoice shall have the Invoice total amount with Tax (ibt-112).
      </assert>
      <assert id="ibr-15" flag="fatal" test="
      exists(cbc:PayableAmount)
      ">
      [ibr-15]-An Invoice shall have the Amount due for payment (ibt-115).
      </assert>
      <assert id="ibr-co-10" flag="fatal" test="
      (
        xs:decimal(cbc:LineExtensionAmount[@currencyID='JPY']) =
        sum(//(cac:InvoiceLine|cac:CreditNoteLine)/xs:decimal(cbc:LineExtensionAmount[@currencyID='JPY']))
      ) or (
        xs:decimal(cbc:LineExtensionAmount[not(@currencyID='JPY')]) =
        round(sum(//(cac:InvoiceLine|cac:CreditNoteLine)/xs:decimal(cbc:LineExtensionAmount[not(@currencyID='JPY')])) * 10 * 10) div 100
      )">
      [ibr-co-10]-Sum of Invoice line net amount (ibt-106) = Σ Invoice line net amount (ibt-131).
      </assert>
      <assert id="ibr-co-11" flag="fatal" test="
      (
        xs:decimal(cbc:AllowanceTotalAmount[@currencyID='JPY']) =
        sum(../cac:AllowanceCharge[cbc:ChargeIndicator=false()]/xs:decimal(cbc:Amount[@currencyID='JPY']))
      ) or (
        xs:decimal(cbc:AllowanceTotalAmount[not(@currencyID='JPY')]) =
        round(sum(../cac:AllowanceCharge[cbc:ChargeIndicator=false()]/xs:decimal(cbc:Amount[not(@currencyID='JPY')])) * 10 * 10) div 100
      ) or (
        not(cbc:AllowanceTotalAmount) and
        not(../cac:AllowanceCharge[cbc:ChargeIndicator=false()])
      )">
      [ibr-co-11]-Sum of allowances on document level (ibt-107) = Σ Document level allowance amount (ibt-092).
      </assert>
      <assert id="ibr-co-12" flag="fatal" test="
      (
        xs:decimal(cbc:ChargeTotalAmount[@currencyID='JPY']) =
        sum(../cac:AllowanceCharge[cbc:ChargeIndicator=true()]/xs:decimal(cbc:Amount[@currencyID='JPY']))
      ) or
      (
        xs:decimal(cbc:ChargeTotalAmount[not(@currencyID='JPY')]) =
        round(sum(../cac:AllowanceCharge[cbc:ChargeIndicator=true()]/xs:decimal(cbc:Amount[not(@currencyID='JPY')])) * 10 * 10) div 100
      ) or (
        not(cbc:ChargeTotalAmount) and
        not(../cac:AllowanceCharge[cbc:ChargeIndicator=true()])
      )">
      [ibr-co-12]-Sum of charges on document level (ibt-108) = Σ Document level charge amount (ibt-099).
      </assert>
      <assert id="ibr-co-13" flag="fatal" test="
      (
        (cbc:ChargeTotalAmount[@currencyID='JPY']) and
        (cbc:AllowanceTotalAmount[@currencyID='JPY']) and
        (
          xs:decimal(cbc:TaxExclusiveAmount[@currencyID='JPY']) =
          xs:decimal(cbc:LineExtensionAmount[@currencyID='JPY']) +
          xs:decimal(cbc:ChargeTotalAmount[@currencyID='JPY']) -
          xs:decimal(cbc:AllowanceTotalAmount[@currencyID='JPY'])
        )
      ) or (
        not(cbc:ChargeTotalAmount[@currencyID='JPY']) and
        (cbc:AllowanceTotalAmount[@currencyID='JPY']) and
        (
          xs:decimal(cbc:TaxExclusiveAmount[@currencyID='JPY']) =
          xs:decimal(cbc:LineExtensionAmount[@currencyID='JPY']) -
          xs:decimal(cbc:AllowanceTotalAmount[@currencyID='JPY'])
        )
      ) or (
        (cbc:ChargeTotalAmount[@currencyID='JPY']) and
        not(cbc:AllowanceTotalAmount[@currencyID='JPY']) and
        (
          xs:decimal(cbc:TaxExclusiveAmount[@currencyID='JPY']) =
          xs:decimal(cbc:LineExtensionAmount[@currencyID='JPY']) +
          xs:decimal(cbc:ChargeTotalAmount[@currencyID='JPY'])
        )
      ) or (
        (cbc:ChargeTotalAmount[not(@currencyID='JPY')]) and
        (cbc:AllowanceTotalAmount[not(@currencyID='JPY')]) and
        (
          xs:decimal(cbc:TaxExclusiveAmount[not(@currencyID='JPY')]) =
          round(
            (
              xs:decimal(cbc:LineExtensionAmount[not(@currencyID='JPY')]) +
              xs:decimal(cbc:ChargeTotalAmount[not(@currencyID='JPY')]) -
              xs:decimal(cbc:AllowanceTotalAmount[not(@currencyID='JPY')])
            ) * 10 * 10
          ) div 100
        )
      ) or (
        not(cbc:ChargeTotalAmount[not(@currencyID='JPY')]) and
        (cbc:AllowanceTotalAmount[not(@currencyID='JPY')]) and
        (
          xs:decimal(cbc:TaxExclusiveAmount[not(@currencyID='JPY')]) =
          round(
            (
              xs:decimal(cbc:LineExtensionAmount[not(@currencyID='JPY')]) -
              xs:decimal(cbc:AllowanceTotalAmount[not(@currencyID='JPY')])
            ) * 10 * 10
          ) div 100
        )
      ) or (
        (cbc:ChargeTotalAmount[not(@currencyID='JPY')]) and
        not(cbc:AllowanceTotalAmount[not(@currencyID='JPY')]) and
        (
          xs:decimal(cbc:TaxExclusiveAmount[not(@currencyID='JPY')]) =
          round(
            (
              xs:decimal(cbc:LineExtensionAmount[not(@currencyID='JPY')]) +
              xs:decimal(cbc:ChargeTotalAmount[not(@currencyID='JPY')])
            ) * 10 * 10
          ) div 100
        )
      ) or (
        not(cbc:ChargeTotalAmount) and
        not(cbc:AllowanceTotalAmount)
        and (
          xs:decimal(cbc:TaxExclusiveAmount) =
          xs:decimal(cbc:LineExtensionAmount)
        )
      )">
      [ibr-co-13]-Invoice total amount without Tax (ibt-109) = Σ Invoice line net amount (ibt-131) - Sum of allowances on document level (ibt-107) + Sum of charges on document level (ibt-108).
      </assert>
      <assert id="ibr-co-16" flag="fatal" test="
      (
        not(xs:decimal(cbc:PrepaidAmount)) and
        not(xs:decimal(cbc:PayableRoundingAmount)) and
        xs:decimal(cbc:PayableAmount) = xs:decimal(cbc:TaxInclusiveAmount)
      ) or (
        xs:decimal(cbc:PrepaidAmount[@currencyID='JPY']) and
        not(xs:decimal(cbc:PayableRoundingAmount[@currencyID='JPY'])) and
        (
          xs:decimal(cbc:PayableAmount[@currencyID='JPY']) =
          xs:decimal(cbc:TaxInclusiveAmount[@currencyID='JPY']) - xs:decimal(cbc:PrepaidAmount[@currencyID='JPY'])
        )
      ) or (
        xs:decimal(cbc:PrepaidAmount[not(@currencyID='JPY')]) and
        not(xs:decimal(cbc:PayableRoundingAmount[not(@currencyID='JPY')])) and
        (
          xs:decimal(cbc:PayableAmount[not(@currencyID='JPY')]) =
          round(
            (
              xs:decimal(cbc:TaxInclusiveAmount[not(@currencyID='JPY')]) - xs:decimal(cbc:PrepaidAmount[not(@currencyID='JPY')])
            ) * 10 * 10
          ) div 100
        )
      ) or (
        xs:decimal(cbc:PrepaidAmount[not(@currencyID='JPY')]) and
        xs:decimal(cbc:PayableRoundingAmount[not(@currencyID='JPY')]) and
        (
          (
            round(
              (
                xs:decimal(cbc:PayableAmount[not(@currencyID='JPY')]) - xs:decimal(cbc:PayableRoundingAmount[not(@currencyID='JPY')])
              ) * 10 * 10
            ) div 100
          ) = (
            round(
              (
                xs:decimal(cbc:TaxInclusiveAmount[not(@currencyID='JPY')]) - xs:decimal(cbc:PrepaidAmount[not(@currencyID='JPY')])
              ) * 10 * 10
            ) div 100
          )
        )
      ) or (
        not(xs:decimal(cbc:PrepaidAmount[not(@currencyID='JPY')])) and
        xs:decimal(cbc:PayableRoundingAmount[not(@currencyID='JPY')]) and
        (
          (
            round(
              (
                xs:decimal(cbc:PayableAmount[not(@currencyID='JPY')]) - xs:decimal(cbc:PayableRoundingAmount[not(@currencyID='JPY')])
              ) * 10 * 10
            ) div 100
          ) =
          xs:decimal(cbc:TaxInclusiveAmount[not(@currencyID='JPY')])
        )
      )">
      [ibr-co-16]-Amount due for payment (ibt-115) = Invoice total amount with Tax (ibt-112) - Paid amount (ibt-113) + Rounding amount (ibt-114).
      </assert>

    </rule>

    <rule context="/ubl:Invoice | /cn:CreditNote">
      <assert id="ibr-01" flag="fatal" test="
      (cbc:CustomizationID) != ''
      ">
      [ibr-01]-An Invoice shall have a Specification identifier (ibt-024).
      </assert>
      <assert id="ibr-02" flag="fatal" test="
      (cbc:ID) !=''
      ">
      [ibr-02]-An Invoice shall have an Invoice number (ibt-001).
      </assert>
      <assert id="ibr-03" flag="fatal" test="
      (cbc:IssueDate) !=''
      ">
      [ibr-03]-An Invoice shall have an Invoice issue date (ibt-002).
      </assert>
      <assert id="ibr-04" flag="fatal" test="
      (cbc:InvoiceTypeCode) !='' or
      (cbc:CreditNoteTypeCode) !=''
      ">
      [ibr-04]-An Invoice shall have an Invoice type code (ibt-003).
      </assert>
      <assert id="ibr-05" flag="fatal" test="
      (cbc:DocumentCurrencyCode) !=''
      ">
      [ibr-05]-An Invoice shall have an Invoice currency code (ibt-005).
      </assert>
      
      <assert id="ibr-16" flag="fatal" test="
      exists(cac:InvoiceLine) or
      exists(cac:CreditNoteLine)
      ">
      [ibr-16]-An Invoice shall have at least one Invoice line (ibg-25)
      </assert>
      <assert id="ibr-53" flag="fatal" test="
      every $taxcurrency in cbc:TaxCurrencyCode satisfies (
        exists(//cac:TaxTotal/cbc:TaxAmount[@currencyID=$taxcurrency])
      )">
      [ibr-53]-If the Tax accounting currency code (ibt-006) is present, then the Invoice total Tax amount in accounting currency (ibt-111) shall be provided.
      </assert>
      <assert id="ibr-co-15" flag="fatal" test="
      every $Currency in cbc:DocumentCurrencyCode satisfies (
        cac:LegalMonetaryTotal/xs:decimal(cbc:TaxInclusiveAmount) = round( (cac:LegalMonetaryTotal/xs:decimal(cbc:TaxExclusiveAmount) + cac:TaxTotal/xs:decimal(cbc:TaxAmount[@currencyID=$Currency])) * 10 * 10) div 100
      )">
      [ibr-co-15]-Invoice total amount with Tax (ibt-112) = Invoice total amount without Tax (ibt-109) + Invoice total Tax amount (ibt-110).
      </assert>
    </rule>
    <rule context="cac:InvoiceLine | cac:CreditNoteLine">
      <assert id="ibr-21" flag="fatal" test="
      (cbc:ID) != ''
      ">
      [ibr-21]-Each Invoice line (ibg-25) shall have an Invoice line identifier (ibt-126).
      </assert>
      <assert id="ibr-22" flag="fatal" test="
      exists(cbc:InvoicedQuantity) or
      exists(cbc:CreditedQuantity)
      ">
      [ibr-22]-Each Invoice line (ibg-25) shall have an Invoiced quantity (ibt-129).
      </assert>
      <assert id="ibr-23" flag="fatal" test="
      exists(cbc:InvoicedQuantity/@unitCode) or
      exists(cbc:CreditedQuantity/@unitCode)
      ">
      [ibr-23]-An Invoice line (ibg-25) shall have an Invoiced quantity unit of measure code (ibt-130).
      </assert>
      <assert id="ibr-24" flag="fatal" test="
      exists(cbc:LineExtensionAmount)
      ">
      [ibr-24]-Each Invoice line (ibg-25) shall have an Invoice line net amount (ibt-131).
      </assert>
      <assert id="ibr-25" flag="fatal" test="
      (cac:Item/cbc:Name) != ''
      ">
      [ibr-25]-Each Invoice line (ibg-25) shall contain the Item name (ibt-153).
      </assert>
      <assert id="ibr-26" flag="fatal" test="
      exists(cac:Price/cbc:PriceAmount)
      ">
      [ibr-26]-Each Invoice line (ibg-25) shall contain the Item net price (ibt-146).
      </assert>
      <assert id="ibr-27" flag="fatal" test="
      (cac:Price/cbc:PriceAmount) &gt;= 0
      ">
      [ibr-27]-The Item net price (ibt-146) shall NOT be negative.
      </assert>
      <assert id="ibr-28" flag="fatal" test="
      (cac:Price/cac:AllowanceCharge/cbc:BaseAmount) &gt;= 0 or 
      not(exists(cac:Price/cac:AllowanceCharge/cbc:BaseAmount))
      ">
      [ibr-28]-The Item gross price (ibt-148) shall NOT be negative.
      </assert>
    </rule>
    <rule context="//cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | //cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()]">
      <assert id="ibr-41" flag="fatal" test="
      exists(cbc:Amount)
      ">
      [ibr-41]-Each Invoice line allowance (ibg-27) shall have an Invoice line allowance amount (ibt-136).
      </assert>
      <assert id="ibr-42" flag="fatal" test="
      exists(cbc:AllowanceChargeReason) or 
      exists(cbc:AllowanceChargeReasonCode)
      ">
      [ibr-42]-Each Invoice line allowance (ibg-27) shall have an Invoice line allowance reason (ibt-139) or an Invoice line allowance reason code (ibt-140).
      </assert>
      <!--      <assert id="ibr-co-07" flag="fatal" test="true()">[ibr-co-07]-When both Invoice line allowance reason code (ibt-140) and Invoice line allowance reason (ibt-139) the definition of the code is normative.</assert>
      -->
    </rule>
    <rule context="//cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = true()] | //cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = true()]">
      <assert id="ibr-43" flag="fatal" test="
      exists(cbc:Amount)
      ">
      [ibr-43]-Each Invoice line charge (ibg-28) shall have an Invoice line charge amount (ibt-141).
      </assert>
      <assert id="ibr-44" flag="fatal" test="
      exists(cbc:AllowanceChargeReason) or 
      exists(cbc:AllowanceChargeReasonCode)
      ">
      [ibr-44]-Each Invoice line charge (ibg-28) shall have an Invoice line charge reason (ibt-144) or an invoice line allowance reason code (ibt-145).
      </assert>
      <!--      <assert id="ibr-co-08" flag="fatal" test="true()">[ibr-co-08]-When both Invoice line charge reason code (ibt-145) and Invoice line charge reason (ibt-144) the definition of the code is normative.</assert>
      -->
      <assert id="ibr-co-24" flag="fatal" test="
      exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)
      ">
      [ibr-co-24]-Each Invoice line charge (ibg-28) shall contain an Invoice line charge reason (ibt-144) or an Invoice line charge reason code (ibt-145), or both.
      </assert>
    </rule>
    <rule context="cac:InvoiceLine/cac:InvoicePeriod | cac:CreditNoteLine/cac:InvoicePeriod">
      <assert id="ibr-30" flag="fatal" test="
      (
        exists(cbc:EndDate) and
        exists(cbc:StartDate) and
        xs:date(cbc:EndDate) &gt;= xs:date(cbc:StartDate)
      ) or
      not(
        exists(cbc:StartDate)
      ) or
      not(
        exists(cbc:EndDate)
      )
      ">
      [ibr-30]-If both Invoice line period start date (ibt-134) and Invoice line period end date (ibt-135) are given then the Invoice line period end date (ibt-135) shall be later or equal to the Invoice line period start date (ibt-134).
      </assert>
      <assert id="ibr-co-20" flag="fatal" test="
      exists(cbc:StartDate) or exists(cbc:EndDate)
      ">
      [ibr-co-20]-If Invoice line period (ibg-26) is used, the Invoice line period start date (ibt-134) or the Invoice line period end date (ibt-135) shall be filled, or both.
      </assert>
    </rule>

    <rule context="cac:InvoicePeriod">
      <assert id="ibr-29" flag="fatal" test="(exists(cbc:EndDate) and exists(cbc:StartDate) and xs:date(cbc:EndDate) &gt;= xs:date(cbc:StartDate)) or not(exists(cbc:StartDate)) or not(exists(cbc:EndDate))">[ibr-29]-If both Invoicing period start date (ibt-073) and Invoicing period end date (ibt-074) are given then the Invoicing period end date (ibt-074) shall be later or equal to the Invoicing period start date (ibt-073).</assert>
      <assert id="ibr-co-19" flag="fatal" test="
      exists(cbc:StartDate) or
      exists(cbc:EndDate) or
      (
        exists(cbc:DescriptionCode) and
        not(
          exists(cbc:StartDate)
        ) and
        not(
          exists(cbc:EndDate)
        )
      )
      ">
      [ibr-co-19]-If Invoicing period (ibg-14) is used, the Invoicing period start date (ibt-073) or the Invoicing period end date (ibt-074) shall be filled, or both.
      </assert>
    </rule>
    <rule context="//cac:AdditionalItemProperty">
      <assert id="ibr-54" flag="fatal" test="
      exists(cbc:Name) and exists(cbc:Value)
      ">
      [ibr-54]-Each Item attribute (ibg-32) shall contain an Item attribute name (ibt-160) and an Item attribute value (ibt-161).
      </assert>
    </rule>
    <rule context="cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode | cac:CreditNoteLine/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode">
      <assert id="ibr-65" flag="fatal" test="
      exists(@listID)
      ">
      [ibr-65]-The Item classification identifier (ibt-158) shall have a Scheme identifier.
      </assert>
    </rule>
    <rule context="cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:ID | cac:CreditNoteLine/cac:Item/cac:StandardItemIdentification/cbc:ID">
      <assert id="ibr-64" flag="fatal" test="
      exists(@schemeID)
      ">
      [ibr-64]-The Item standard identifier (ibt-157) shall have a Scheme identifier.
      </assert>
    </rule>
    <rule context="cac:PayeeParty">
      <assert id="ibr-17" flag="fatal" test="
      exists(cac:PartyName/cbc:Name) and
      (
        not(
          cac:PartyName/cbc:Name = ../cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name
        ) and
        not(
          cac:PartyIdentification/cbc:ID = ../cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID
        )
      )">
      [ibr-17]-The Payee name (ibt-059) shall be provided in the Invoice, if the Payee (ibg-10) is different from the Seller (ibg-04).
      </assert>
    </rule>
    <rule context="cac:PaymentMeans">
      <assert id="ibr-49" flag="fatal" test="
      exists(cbc:PaymentMeansCode)
      ">
      [ibr-49]-A Payment instruction (ibg-16) shall specify the Payment means type code (ibt-081).
      </assert>
    </rule>
    <rule context="cac:BillingReference">
      <assert id="ibr-55" flag="fatal" test="
      exists(cac:InvoiceDocumentReference/cbc:ID)
      ">
      [ibr-55]-Each Preceding Invoice reference (ibg-03) shall contain a Preceding Invoice reference (ibt-025).
      </assert>
    </rule>
    <rule context="cac:AccountingSupplierParty">
      <assert id="ibr-co-26" flag="fatal" test="
      exists(cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or 
      exists(cac:Party/cac:PartyIdentification/cbc:ID) or 
      exists(cac:Party/cac:PartyLegalEntity/cbc:CompanyID)
      ">
      [ibr-co-26]-In order for the buyer to automatically identify a supplier, the Seller identifier (ibt-029), the Seller legal registration identifier (ibt-030) and/or the Seller Tax identifier (ibt-031) shall be present.
      </assert>
    </rule>
    <rule context="cac:AccountingSupplierParty/cac:Party/cbc:EndpointID">
      <assert id="ibr-62" flag="fatal" test="
      exists(@schemeID)
      ">
      [ibr-62]-The Seller electronic address (ibt-034) shall have a Scheme identifier.
      </assert>
    </rule>
    <rule context="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress">
      <assert id="ibr-09" flag="fatal" test="
      (cac:Country/cbc:IdentificationCode) != ''
      ">
      [ibr-09]-The Seller postal address (ibg-05) shall contain a Seller country code (ibt-040).
      </assert>
    </rule>
    <rule context="cac:TaxRepresentativeParty">
      <assert id="ibr-18" flag="fatal" test="
      (cac:PartyName/cbc:Name) != ''
      ">
      [ibr-18]-The Seller tax representative name (ibt-062) shall be provided in the Invoice, if the Seller (ibg-04) has a Seller tax representative party (ibg-11)
      </assert>
      <assert id="ibr-19" flag="fatal" test="
      exists(cac:PostalAddress)
      ">
      [ibr-19]-The Seller tax representative postal address (ibg-12) shall be provided in the Invoice, if the Seller (ibg-04) has a Seller tax representative party (ibg-11).
      </assert>
      <assert id="ibr-56" flag="fatal" test="
      exists(cac:PartyTaxScheme/cbc:CompanyID)
      ">
      [ibr-56]-Each Seller tax representative party (ibg-11) shall have a Seller tax representative Tax identifier (ibt-063).
      </assert>
    </rule>
    <rule context="cac:TaxRepresentativeParty/cac:PostalAddress">
      <assert id="ibr-20" flag="fatal" test="
      (cac:Country/cbc:IdentificationCode) != ''
      ">
      [ibr-20]-The Seller tax representative postal address (ibg-12) shall contain a Tax representative country code (ibt-069), if the Seller (ibg-04) has a Seller tax representative party (ibg-11).
      </assert>
    </rule>
    <rule context="/ubl:Invoice/cac:TaxTotal | /cn:CreditNote/cac:Taxtotal">
      <assert id="ibr-co-14" flag="fatal" test="
      (
        xs:decimal(child::cbc:TaxAmount[@currencyID='JPY']) =
        sum(cac:TaxSubtotal/xs:decimal(cbc:TaxAmount[@currencyID='JPY']))
      ) or (
        xs:decimal(child::cbc:TaxAmount[not(@currencyID='JPY')]) =
        round(
          (
            sum(cac:TaxSubtotal/xs:decimal(cbc:TaxAmount[not(@currencyID='JPY')])) * 10 * 10
          )
        ) div 100
      ) or 
      not(
        cac:TaxSubtotal
      )">
      [ibr-co-14]-Invoice total Tax amount (ibt-110) = Σ Tax category tax amount (ibt-117).
      </assert>
    </rule>
  </pattern>

  <pattern id="Codesmodel">
    <let name="UNTDID1001_INVOICE" value="tokenize('80 82 84 380 383 386 393 395 575 623 780', '\s')"/>
    <let name="UNTDID1001_CREDITNOTE" value="tokenize('81 83 381 396 532', '\s')"/>
    <let name="UNTDID1153" value="tokenize('AAA AAB AAC AAD AAE AAF AAG AAH AAI AAJ AAK AAL AAM AAN AAO AAP AAQ AAR AAS AAT AAU AAV AAW AAX AAY AAZ ABA ABB ABC ABD ABE ABF ABG ABH ABI ABJ ABK ABL ABM ABN ABO ABP ABQ ABR ABS ABT ABU ABV ABW ABX ABY ABZ AC ACA ACB ACC ACD ACE ACF ACG ACH ACI ACJ ACK ACL ACN ACO ACP ACQ ACR ACT ACU ACV ACW ACX ACY ACZ ADA ADB ADC ADD ADE ADF ADG ADI ADJ ADK ADL ADM ADN ADO ADP ADQ ADT ADU ADV ADW ADX ADY ADZ AE AEA AEB AEC AED AEE AEF AEG AEH AEI AEJ AEK AEL AEM AEN AEO AEP AEQ AER AES AET AEU AEV AEW AEX AEY AEZ AF AFA AFB AFC AFD AFE AFF AFG AFH AFI AFJ AFK AFL AFM AFN AFO AFP AFQ AFR AFS AFT AFU AFV AFW AFX AFY AFZ AGA AGB AGC AGD AGE AGF AGG AGH AGI AGJ AGK AGL AGM AGN AGO AGP AGQ AGR AGS AGT AGU AGV AGW AGX AGY AGZ AHA AHB AHC AHD AHE AHF AHG AHH AHI AHJ AHK AHL AHM AHN AHO AHP AHQ AHR AHS AHT AHU AHV AHX AHY AHZ AIA AIB AIC AID AIE AIF AIG AIH AII AIJ AIK AIL AIM AIN AIO AIP AIQ AIR AIS AIT AIU AIV AIW AIX AIY AIZ AJA AJB AJC AJD AJE AJF AJG AJH AJI AJJ AJK AJL AJM AJN AJO AJP AJQ AJR AJS AJT AJU AJV AJW AJX AJY AJZ AKA AKB AKC AKD AKE AKF AKG AKH AKI AKJ AKK AKL AKM AKN AKO AKP AKQ AKR AKS AKT AKU AKV AKW AKX AKY AKZ ALA ALB ALC ALD ALE ALF ALG ALH ALI ALJ ALK ALL ALM ALN ALO ALP ALQ ALR ALS ALT ALU ALV ALW ALX ALY ALZ AMA AMB AMC AMD AME AMF AMG AMH AMI AMJ AMK AML AMM AMN AMO AMP AMQ AMR AMS AMT AMU AMV AMW AMX AMY AMZ ANA ANB ANC AND ANE ANF ANG ANH ANI ANJ ANK ANL ANM ANN ANO ANP ANQ ANR ANS ANT ANU ANV ANW ANX ANY AOA AOD AOE AOF AOG AOH AOI AOJ AOK AOL AOM AON AOO AOP AOQ AOR AOS AOT AOU AOV AOW AOX AOY AOZ AP APA APB APC APD APE APF APG APH API APJ APK APL APM APN APO APP APQ APR APS APT APU APV APW APX APY APZ AQA AQB AQC AQD AQE AQF AQG AQH AQI AQJ AQK AQL AQM AQN AQO AQP AQQ AQR AQS AQT AQU AQV AQW AQX AQY AQZ ARA ARB ARC ARD ARE ARF ARG ARH ARI ARJ ARK ARL ARM ARN ARO ARP ARQ ARR ARS ART ARU ARV ARW ARX ARY ARZ ASA ASB ASC ASD ASE ASF ASG ASH ASI ASJ ASK ASL ASM ASN ASO ASP ASQ ASR ASS AST ASU ASV ASW ASX ASY ASZ ATA ATB ATC ATD ATE ATF ATG ATH ATI ATJ ATK ATL ATM ATN ATO ATP ATQ ATR ATS ATT ATU ATV ATW ATX ATY ATZ AU AUA AUB AUC AUD AUE AUF AUG AUH AUI AUJ AUK AUL AUM AUN AUO AUP AUQ AUR AUS AUT AUU AUV AUW AUX AUY AUZ AV AVA AVB AVC AVD AVE AVF AVG AVH AVI AVJ AVK AVL AVM AVN AVO AVP AVQ AVR AVS AVT AVU AVV AVW AVX AVY AVZ AWA AWB AWC AWD AWE AWF AWG AWH AWI AWJ AWK AWL AWM AWN AWO AWP AWQ AWR AWS AWT AWU AWV AWW AWX AWY AWZ AXA AXB AXC AXD AXE AXF AXG AXH AXI AXJ AXK AXL AXM AXN AXO AXP AXQ AXR AXS BA BC BD BE BH BM BN BO BR BT BTP BW CAS CAT CAU CAV CAW CAX CAY CAZ CBA CBB CD CEC CED CFE CFF CFO CG CH CK CKN CM CMR CN CNO COF CP CR CRN CS CST CT CU CV CW CZ DA DAN DB DI DL DM DQ DR EA EB ED EE EEP EI EN EQ ER ERN ET EX FC FF FI FLW FN FO FS FT FV FX GA GC GD GDN GN HS HWB IA IB ICA ICE ICO II IL INB INN INO IP IS IT IV JB JE LA LAN LAR LB LC LI LO LRC LS MA MB MF MG MH MR MRN MS MSS MWB NA NF OH OI ON OP OR PB PC PD PE PF PI PK PL POR PP PQ PR PS PW PY RA RC RCN RE REN RF RR RT SA SB SD SE SEA SF SH SI SM SN SP SQ SRN SS STA SW SZ TB TCR TE TF TI TIN TL TN TP UAR UC UCN UN UO URI VA VC VGR VM VN VON VOR VP VR VS VT VV WE WM WN WR WS WY XA XC XP ZZZ', '\s')"/>
    <let name="UNTDID7143" value="tokenize('AA AB AC AD AE AF AG AH AI AJ AK AL AM AN AO AP AQ AR AS AT AU AV AW AX AY AZ BA BB BC BD BE BF BG BH BI BJ BK BL BM BN BO BP BQ BR BS BT BU BV BW BX BY BZ CC CG CL CR CV DR DW EC EF EN FS GB GN GS HS IB IN IS IT IZ MA MF MN MP NB ON PD PL PO PV QS RC RN RU RY SA SG SK SN SRS SRT SRU SRV SRW SRX SRY SRZ SS SSA SSB SSC SSD SSE SSF SSG SSH SSI SSJ SSK SSL SSM SSN SSO SSP SSQ SSR SSS SST SSU SSV SSW SSX SSY SSZ ST STA STB STC STD STE STF STG STH STI STJ STK STL STM STN STO STP STQ STR STS STT STU STV STW STX STY STZ SUA SUB SUC SUD SUE SUF SUG SUH SUI SUJ SUK SUL SUM TG TSN TSO TSP TSQ TSR TSS TST TSU UA UP VN VP VS VX ZZZ', '\s')"/>
    <let name="ISO3166" value="tokenize('AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW 1A XI', '\s')"/>
    <let name="ISO4217" value="tokenize('AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STN SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL', '\s')"/>
    <let name="ISO6523" value="tokenize('0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213', '\s')"/>
    <let name="MIMECODE" value="tokenize('application/pdf image/png image/jpeg text/csv application/vnd.openxmlformats-officedocument.spreadsheetml.sheet application/vnd.oasis.opendocument.spreadsheet', '\s')"/>
    <let name="UNCL2005" value="tokenize('3 35 432', '\s')"/>
    <let name="UNCL4461" value="tokenize('1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 70 74 75 76 77 78 91 92 93 94 95 96 97 ZZZ Z01 Z02', '\s')"/>
    <let name="UNCL5189" value="tokenize('41 42 60 62 63 64 65 66 67 68 70 71 88 95 100 102 103 104 105', '\s')"/>
    <let name="UNCL5305" value="tokenize('AA AE E S Z G O K L M', '\s')"/>
    <let name="UNCL7161" value="tokenize('AA AAA AAC AAD AAE AAF AAH AAI AAS AAT AAV AAY AAZ ABA ABB ABC ABD ABF ABK ABL ABN ABR ABS ABT ABU ACF ACG ACH ACI ACJ ACK ACL ACM ACS ADC ADE ADJ ADK ADL ADM ADN ADO ADP ADQ ADR ADT ADW ADY ADZ AEA AEB AEC AED AEF AEH AEI AEJ AEK AEL AEM AEN AEO AEP AES AET AEU AEV AEW AEX AEY AEZ AJ AU CA CAB CAD CAE CAF CAI CAJ CAK CAL CAM CAN CAO CAP CAQ CAR CAS CAT CAU CAV CAW CAX CAY CAZ CD CG CS CT DAB DAC DAD DAF DAG DAH DAI DAJ DAK DAL DAM DAN DAO DAP DAQ DL EG EP ER FAA FAB FAC FC FH FI GAA HAA HD HH IAA IAB ID IF IR IS KO L1 LA LAA LAB LF MAE MI ML NAA OA PA PAA PC PL RAB RAC RAD RAF RE RF RH RV SA SAA SAD SAE SAI SG SH SM SU TAB TAC TT TV V1 V2 WH XAA YY ZZZ', '\s')"/>
    <let name="UNECE_REC20" value="tokenize('10 11 13 14 15 20 21 22 23 24 25 27 28 33 34 35 37 38 40 41 56 57 58 59 60 61 64 66 74 76 77 78 80 81 84 85 87 89 91 1I 2A 2B 2C 2G 2H 2I 2J 2K 2L 2M 2N 2P 2Q 2R 2U 2X 2Y 2Z 3B 3C 4C 4G 4H 4K 4L 4M 4N 4O 4P 4Q 4R 4T 4U 4W 4X 5A 5B 5E 5J A1 A10 A11 A12 A13 A14 A15 A16 A17 A18 A19 A2 A20 A21 A22 A23 A24 A25 A26 A27 A28 A29 A3 A30 A31 A32 A33 A34 A35 A36 A37 A38 A39 A4 A40 A41 A42 A43 A44 A45 A47 A48 A49 A5 A50 A51 A52 A53 A54 A55 A56 A57 A58 A59 A6 A60 A61 A62 A63 A64 A65 A66 A67 A68 A69 A7 A70 A71 A73 A74 A75 A76 A77 A78 A79 A8 A80 A81 A82 A83 A84 A85 A86 A87 A88 A89 A9 A90 A91 A93 A94 A95 A96 A97 A98 A99 AA AB ACR ACT AD AE AH AI AK AL AMH AMP ANN APZ AQ ARE AS ASM ASU ATM ATT AY AZ B1 B10 B11 B12 B13 B14 B15 B16 B17 B18 B19 B20 B21 B22 B23 B24 B25 B26 B27 B28 B29 B3 B30 B31 B32 B33 B34 B35 B36 B37 B38 B39 B4 B40 B41 B42 B43 B44 B45 B46 B47 B48 B49 B50 B51 B52 B53 B54 B55 B56 B57 B58 B59 B60 B61 B62 B63 B64 B65 B66 B67 B68 B69 B7 B70 B71 B72 B73 B74 B75 B76 B77 B78 B79 B8 B80 B81 B82 B83 B84 B85 B86 B87 B88 B89 B90 B91 B92 B93 B94 B95 B96 B97 B98 B99 BAR BB BFT BHP BIL BLD BLL BP BQL BTU BUA BUI C0 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19 C20 C21 C22 C23 C24 C25 C26 C27 C28 C29 C3 C30 C31 C32 C33 C34 C35 C36 C37 C38 C39 C40 C41 C42 C43 C44 C45 C46 C47 C48 C49 C50 C51 C52 C53 C54 C55 C56 C57 C58 C59 C60 C61 C62 C63 C64 C65 C66 C67 C68 C69 C7 C70 C71 C72 C73 C74 C75 C76 C78 C79 C8 C80 C81 C82 C83 C84 C85 C86 C87 C88 C89 C9 C90 C91 C92 C93 C94 C95 C96 C97 C99 CCT CDL CEL CEN CG CGM CKG CLF CLT CMK CMQ CMT CNP CNT COU CTG CTM CTN CUR CWA CWI D03 D04 D1 D10 D11 D12 D13 D15 D16 D17 D18 D19 D2 D20 D21 D22 D23 D24 D25 D26 D27 D29 D30 D31 D32 D33 D34 D35 D36 D37 D38 D39 D41 D42 D43 D44 D45 D46 D47 D48 D49 D5 D50 D51 D52 D53 D54 D55 D56 D57 D58 D59 D6 D60 D61 D62 D63 D65 D68 D69 D70 D71 D72 D73 D74 D75 D76 D77 D78 D80 D81 D82 D83 D85 D86 D87 D88 D89 D9 D91 D93 D94 D95 DAA DAD DAY DB DD DEC DG DJ DLT DMA DMK DMO DMQ DMT DN DPC DPR DPT DRA DRI DRL DT DTN DU DWT DX DZN DZP E01 E07 E08 E09 E10 E11 E12 E14 E15 E16 E17 E18 E19 E20 E21 E22 E23 E25 E27 E28 E30 E31 E32 E33 E34 E35 E36 E37 E38 E39 E4 E40 E41 E42 E43 E44 E45 E46 E47 E48 E49 E50 E51 E52 E53 E54 E55 E56 E57 E58 E59 E60 E61 E62 E63 E64 E65 E66 E67 E68 E69 E70 E71 E72 E73 E74 E75 E76 E77 E78 E79 E80 E81 E82 E83 E84 E85 E86 E87 E88 E89 E90 E91 E92 E93 E94 E95 E96 E97 E98 E99 EA EB EQ F01 F02 F03 F04 F05 F06 F07 F08 F10 F11 F12 F13 F14 F15 F16 F17 F18 F19 F20 F21 F22 F23 F24 F25 F26 F27 F28 F29 F30 F31 F32 F33 F34 F35 F36 F37 F38 F39 F40 F41 F42 F43 F44 F45 F46 F47 F48 F49 F50 F51 F52 F53 F54 F55 F56 F57 F58 F59 F60 F61 F62 F63 F64 F65 F66 F67 F68 F69 F70 F71 F72 F73 F74 F75 F76 F77 F78 F79 F80 F81 F82 F83 F84 F85 F86 F87 F88 F89 F90 F91 F92 F93 F94 F95 F96 F97 F98 F99 FAH FAR FBM FC FF FH FIT FL FOT FP FR FS FTK FTQ G01 G04 G05 G06 G08 G09 G10 G11 G12 G13 G14 G15 G16 G17 G18 G19 G2 G20 G21 G23 G24 G25 G26 G27 G28 G29 G3 G30 G31 G32 G33 G34 G35 G36 G37 G38 G39 G40 G41 G42 G43 G44 G45 G46 G47 G48 G49 G50 G51 G52 G53 G54 G55 G56 G57 G58 G59 G60 G61 G62 G63 G64 G65 G66 G67 G68 G69 G70 G71 G72 G73 G74 G75 G76 G77 G78 G79 G80 G81 G82 G83 G84 G85 G86 G87 G88 G89 G90 G91 G92 G93 G94 G95 G96 G97 G98 G99 GB GBQ GDW GE GF GFI GGR GIA GIC GII GIP GJ GL GLD GLI GLL GM GO GP GQ GRM GRN GRO GRT GT GV GWH H03 H04 H05 H06 H07 H08 H09 H10 H11 H12 H13 H14 H15 H16 H18 H19 H20 H21 H22 H23 H24 H25 H26 H27 H28 H29 H30 H31 H32 H33 H34 H35 H36 H37 H38 H39 H40 H41 H42 H43 H44 H45 H46 H47 H48 H49 H50 H51 H52 H53 H54 H55 H56 H57 H58 H59 H60 H61 H62 H63 H64 H65 H66 H67 H68 H69 H70 H71 H72 H73 H74 H75 H76 H77 H78 H79 H80 H81 H82 H83 H84 H85 H87 H88 H89 H90 H91 H92 H93 H94 H95 H96 H98 H99 HA HAR HBA HBX HC HDW HEA HGM HH HIU HJ HKM HLT HM HMQ HMT HN HP HPA HTZ HUR IA IE INH INK INQ ISD IU IV J10 J12 J13 J14 J15 J16 J17 J18 J19 J2 J20 J21 J22 J23 J24 J25 J26 J27 J28 J29 J30 J31 J32 J33 J34 J35 J36 J38 J39 J40 J41 J42 J43 J44 J45 J46 J47 J48 J49 J50 J51 J52 J53 J54 J55 J56 J57 J58 J59 J60 J61 J62 J63 J64 J65 J66 J67 J68 J69 J70 J71 J72 J73 J74 J75 J76 J78 J79 J81 J82 J83 J84 J85 J87 J89 J90 J91 J92 J93 J94 J95 J96 J97 J98 J99 JE JK JM JNT JOU JPS JWL K1 K10 K11 K12 K13 K14 K15 K16 K17 K18 K19 K2 K20 K21 K22 K23 K24 K25 K26 K27 K28 K3 K30 K31 K32 K33 K34 K35 K36 K37 K38 K39 K40 K41 K42 K43 K45 K46 K47 K48 K49 K5 K50 K51 K52 K53 K54 K55 K58 K59 K6 K60 K61 K62 K63 K64 K65 K66 K67 K68 K69 K70 K71 K73 K74 K75 K76 K77 K78 K79 K80 K81 K82 K83 K84 K85 K86 K87 K88 K89 K90 K91 K92 K93 K94 K95 K96 K97 K98 K99 KA KAT KB KBA KCC KDW KEL KGM KGS KHY KHZ KI KIC KIP KJ KJO KL KLK KLX KMA KMH KMK KMQ KMT KNI KNS KNT KO KPA KPH KPO KPP KR KSD KSH KT KTN KUR KVA KVR KVT KW KWH KWO KWT KX L10 L11 L12 L13 L14 L15 L16 L17 L18 L19 L2 L20 L21 L23 L24 L25 L26 L27 L28 L29 L30 L31 L32 L33 L34 L35 L36 L37 L38 L39 L40 L41 L42 L43 L44 L45 L46 L47 L48 L49 L50 L51 L52 L53 L54 L55 L56 L57 L58 L59 L60 L63 L64 L65 L66 L67 L68 L69 L70 L71 L72 L73 L74 L75 L76 L77 L78 L79 L80 L81 L82 L83 L84 L85 L86 L87 L88 L89 L90 L91 L92 L93 L94 L95 L96 L98 L99 LA LAC LBR LBT LD LEF LF LH LK LM LN LO LP LPA LR LS LTN LTR LUB LUM LUX LY M1 M10 M11 M12 M13 M14 M15 M16 M17 M18 M19 M20 M21 M22 M23 M24 M25 M26 M27 M29 M30 M31 M32 M33 M34 M35 M36 M37 M38 M39 M4 M40 M41 M42 M43 M44 M45 M46 M47 M48 M49 M5 M50 M51 M52 M53 M55 M56 M57 M58 M59 M60 M61 M62 M63 M64 M65 M66 M67 M68 M69 M7 M70 M71 M72 M73 M74 M75 M76 M77 M78 M79 M80 M81 M82 M83 M84 M85 M86 M87 M88 M89 M9 M90 M91 M92 M93 M94 M95 M96 M97 M98 M99 MAH MAL MAM MAR MAW MBE MBF MBR MC MCU MD MGM MHZ MIK MIL MIN MIO MIU MLD MLT MMK MMQ MMT MND MON MPA MQH MQS MSK MTK MTQ MTR MTS MVA MWH N1 N10 N11 N12 N13 N14 N15 N16 N17 N18 N19 N20 N21 N22 N23 N24 N25 N26 N27 N28 N29 N3 N30 N31 N32 N33 N34 N35 N36 N37 N38 N39 N40 N41 N42 N43 N44 N45 N46 N47 N48 N49 N50 N51 N52 N53 N54 N55 N56 N57 N58 N59 N60 N61 N62 N63 N64 N65 N66 N67 N68 N69 N70 N71 N72 N73 N74 N75 N76 N77 N78 N79 N80 N81 N82 N83 N84 N85 N86 N87 N88 N89 N90 N91 N92 N93 N94 N95 N96 N97 N98 N99 NA NAR NCL NEW NF NIL NIU NL NMI NMP NPR NPT NQ NR NT NTT NU NX OA ODE OHM ON ONZ OT OZ OZA OZI P1 P10 P11 P12 P13 P14 P15 P16 P17 P18 P19 P2 P20 P21 P22 P23 P24 P25 P26 P27 P28 P29 P30 P31 P32 P33 P34 P35 P36 P37 P38 P39 P40 P41 P42 P43 P44 P45 P46 P47 P48 P49 P5 P50 P51 P52 P53 P54 P55 P56 P57 P58 P59 P60 P61 P62 P63 P64 P65 P66 P67 P68 P69 P70 P71 P72 P73 P74 P75 P76 P77 P78 P79 P80 P81 P82 P83 P84 P85 P86 P87 P88 P89 P90 P91 P92 P93 P94 P95 P96 P97 P98 P99 PAL PD PFL PGL PI PLA PO PQ PR PS PT PTD PTI PTL Q10 Q11 Q12 Q13 Q14 Q15 Q16 Q17 Q18 Q19 Q20 Q21 Q22 Q23 Q24 Q25 Q26 Q27 Q28 Q3 QA QAN QB QR QT QTD QTI QTL QTR R1 R9 RH RM ROM RP RPM RPS RT S3 S4 SAN SCO SCR SEC SET SG SHT SIE SMI SQ SQR SR STC STI STK STL STN STW SW SX SYR T0 T3 TAH TAN TI TIC TIP TKM TMS TNE TP TPR TQD TRL TST TTS U1 U2 UA UB UC VA VLT VP W2 WA WB WCD WE WEB WEE WG WHR WM WSD WTT WW X1 YDK YDQ YRD Z11 ZP ZZ X43 X44 X1A X1B X1D X1F X1G X1W X2C X3A X3H X4A X4B X4C X4D X4F X4G X4H X5H X5L X5M X6H X6P X7A X7B X8A X8B X8C XAA XAB XAC XAD XAE XAF XAG XAH XAI XAJ XAL XAM XAP XAT XAV XB4 XBA XBB XBC XBD XBE XBF XBG XBH XBI XBJ XBK XBL XBM XBN XBO XBP XBQ XBR XBS XBT XBU XBV XBW XBX XBY XBZ XCA XCB XCC XCD XCE XCF XCG XCH XCI XCJ XCK XCL XCM XCN XCO XCP XCQ XCR XCS XCT XCU XCV XCW XCX XCY XCZ XDA XDB XDC XDG XDH XDI XDJ XDK XDL XDM XDN XDP XDR XDS XDT XDU XDV XDW XDX XDY XEC XED XEE XEF XEG XEH XEI XEN XFB XFC XFD XFE XFI XFL XFO XFP XFR XFT XFW XFX XGB XGI XGL XGR XGU XGY XGZ XHA XHB XHC XHG XHN XHR XIA XIB XIC XID XIE XIF XIG XIH XIK XIL XIN XIZ XJB XJC XJG XJR XJT XJY XKG XKI XLE XLG XLT XLU XLV XLZ XMA XMB XMC XME XMR XMS XMT XMW XMX XNA XNE XNF XNG XNS XNT XNU XNV XOA XOB XOC XOD XOE XOF XOK XOT XOU XP2 XPA XPB XPC XPD XPE XPF XPG XPH XPI XPJ XPK XPL XPN XPO XPP XPR XPT XPU XPV XPX XPY XPZ XQA XQB XQC XQD XQF XQG XQH XQJ XQK XQL XQM XQN XQP XQQ XQR XQS XRD XRG XRJ XRK XRL XRO XRT XRZ XSA XSB XSC XSD XSE XSH XSI XSK XSL XSM XSO XSP XSS XST XSU XSV XSW XSY XSZ XT1 XTB XTC XTD XTE XTG XTI XTK XTL XTN XTO XTR XTS XTT XTU XTV XTW XTY XTZ XUC XUN XVA XVG XVI XVK XVL XVN XVO XVP XVQ XVR XVS XVY XWA XWB XWC XWD XWF XWG XWH XWJ XWK XWL XWM XWN XWP XWQ XWR XWS XWT XWU XWV XWW XWX XWY XWZ XXA XXB XXC XXD XXF XXG XXH XXJ XXK XYA XYB XYC XYD XYF XYG XYH XYJ XYK XYL XYM XYN XYP XYQ XYR XYS XYT XYV XYW XYX XYY XYZ XZA XZB XZC XZD XZF XZG XZH XZJ XZK XZL XZM XZN XZP XZQ XZR XZS XZT XZU XZV XZW XZX XZY XZZ', '\s')"/>
    <let name="EAID" value="tokenize('0002 0007 0009 0037 0060 0088 0096 0097 0106 0130 0135 0142 0151 0183 0184 0190 0191 0192 0193 0195 0196 0198 0199 0200 0201 0202 0204 0208 0209 0210 0211 0212 0213 9901 9906 9907 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9955 9957', '\s')"/>
    <let name="CEF_EAS" value="tokenize('0002 0007 0009 0037 0060 0088 0096 0097 0106 0130 0135 0142 0147 0151 0170 0183 0184 0188 0190 0191 0192 0193 0194 0195 0196 0198 0199 0200 0201 0202 0203 0204 0208 0209 0210 0211 0212 0213 9901 9902 9904 9905 9906 9907 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9955 9957 AN AQ AS AU EM', '\s')"/>
    <rule context="cbc:InvoiceTypeCode">
      <assert id="ibr-cl-01_PEPPOL-EN16931-P0100" flag="fatal" test="
      some $code in $UNTDID1001_INVOICE satisfies normalize-space(text()) = $code
      ">
      [ibr-cl-01][PEPPOL-EN16931-P0100]-Invoice type code MUST be coded by the invoice related code lists of UNTDID 1001.</assert>
    </rule>
    <rule context="cbc:CreditNoteTypeCode">
      <assert id="ibr-cl-01_PEPPOL-EN16931-P0101" flag="fatal" test="
      some $code in $UNTDID1001_CREDITNOTE satisfies normalize-space(text()) = $code
      ">
      [ibr-cl-01][PEPPOL-EN16931-P0101]-Credit note type code MUST be coded by the credit note related code lists of UNTDID 1001.</assert>
    </rule>
    <rule flag="fatal" context="cbc:Amount | cbc:BaseAmount | cbc:PriceAmount | cbc:TaxAmount | cbc:TaxableAmount | cbc:LineExtensionAmount | cbc:TaxExclusiveAmount | cbc:TaxInclusiveAmount | cbc:AllowanceTotalAmount | cbc:ChargeTotalAmount | cbc:PrepaidAmount | cbc:PayableRoundingAmount | cbc:PayableAmount">
      <assert id="br-cl-03" flag="fatal" test="
        some $code in $ISO4217 satisfies normalize-space(@currencyID) = $code
      ">
      [ibr-cl-03][PEPPOL-EN16931-CL007]-currencyID MUST be coded using ISO code list 4217 alpha-3.
      </assert>
    </rule>
    <rule flag="fatal" context="cbc:DocumentCurrencyCode">
      <assert id="ibr-cl-04" flag="fatal" test="
        some $code in $ISO4217 satisfies normalize-space(text()) = $code
       ">
      [ibr-cl-04]-Invoice currency code MUST be coded using ISO code list 4217 alpha-3
      </assert>
    </rule>
    <rule flag="fatal" context="cbc:TaxCurrencyCode">
      <assert id="ibr-cl-05" flag="fatal" test="
        some $code in $ISO4217 satisfies normalize-space(text()) = $code
       ">
      [ibr-cl-05]-Tax currency code MUST be coded using ISO code list 4217 alpha-3
      </assert>
    </rule>
    <rule flag="fatal" context="cac:AdditionalDocumentReference[cbc:DocumentTypeCode = '130']/cbc:ID[@schemeID] |
        cac:DocumentReference[cbc:DocumentTypeCode = '130']/cbc:ID[@schemeID]">
      <assert id="ibr-cl-07" flag="fatal" test="
        some $code in $UNTDID1153 satisfies normalize-space(@schemeID) = $code
      ">
      [ibr-cl-07]-Object identifier identification scheme MUST be coded using a restriction of UNTDID 1153.
      </assert>
    </rule>

    <rule flag="fatal" context="cac:PartyIdentification/cbc:ID[@schemeID]">
      <assert id="ibr-cl-10" flag="fatal" test="
      (
        some $code in $ISO6523 satisfies normalize-space(@schemeID) = $code
      ) or (
        (
          not(contains(normalize-space(@schemeID), ' ')) and
          contains(' SEPA ', concat(' ', normalize-space(@schemeID), ' '))
        ) and (
          (ancestor::cac:AccountingSupplierParty) or
          (ancestor::cac:PayeeParty)
        )
      )
      ">
      [ibr-cl-10]-Any identifier identification scheme MUST be coded using one of the ISO 6523 ICD list.
      </assert>
    </rule>
    <rule flag="fatal" context="cac:PartyLegalEntity/cbc:CompanyID[@schemeID]">
      <assert id="ibr-cl-11" flag="fatal" test="
      some $code in $ISO6523 satisfies normalize-space(@schemeID) = $code
      ">
      [ibr-cl-11]-Any registration identifier identification scheme MUST be coded using one of the ISO 6523 ICD list.
      </assert>
    </rule>
    <rule flag="fatal" context="cac:CommodityClassification/cbc:ItemClassificationCode[@listID]">
      <assert id="ibr-cl-13" flag="fatal" test="
      some $code in $UNTDID7143 satisfies normalize-space(@listID) = $code
      ">
      [ibr-cl-13]-Item classification identifier identification scheme MUST be coded using one of the UNTDID 7143 list.
      </assert>
    </rule>
    <rule flag="fatal" context="cac:Country/cbc:IdentificationCode">
      <assert id="ibr-cl-14" flag="fatal" test="
      some $code in $ISO3166 satisfies normalize-space(text()) = $code
      ">
      [ibr-cl-14]-Country codes in an invoice MUST be coded using ISO code list 3166-1
      </assert>
    </rule>
    <rule flag="fatal" context="cac:OriginCountry/cbc:IdentificationCode">
      <assert id="ibr-cl-15" flag="fatal" test="
      some $code in $ISO3166 satisfies normalize-space(text()) = $code
      ">
      [ibr-cl-15]-Origin country codes in an invoice MUST be coded using ISO code list 3166-1
      </assert>
    </rule>
    <rule flag="fatal" context="cac:PaymentMeans/cbc:PaymentMeansCode">
      <assert id="ibr-cl-16" flag="fatal" test="
      some $code in $UNCL4461 satisfies normalize-space(text()) = $code
      ">
      [ibr-cl-16]-Payment means in an invoice MUST be coded using UNCL4461 code list (adding Z01 and Z02)
      </assert>
    </rule>
    <rule flag="fatal" context="cac:AllowanceCharge[cbc:ChargeIndicator = false()]/cbc:AllowanceChargeReasonCode">
      <assert id="ibr-cl-19" flag="fatal" test="
      some $code in $UNCL5189 satisfies normalize-space(text()) = $code
      ">
      [ibr-cl-19]-Coded allowance reasons MUST belong to the UNCL 5189 code list
      </assert>
    </rule>
    <rule flag="fatal" context="cac:AllowanceCharge[cbc:ChargeIndicator = true()]/cbc:AllowanceChargeReasonCode">
      <assert id="ibr-cl-20" flag="fatal" test="
      some $code in $UNCL7161 satisfies normalize-space(text()) = $code
      ">
      [ibr-cl-20]-Coded charge reasons MUST belong to the UNCL 7161 code list
      </assert>
    </rule>
    <rule flag="fatal" context="cac:StandardItemIdentification/cbc:ID[@schemeID]">
      <assert id="ibr-cl-21" flag="fatal" test="
      some $code in $ISO6523 satisfies normalize-space(@schemeID) = $code
      ">
      [ibr-cl-21]-Item standard identifier scheme identifier MUST belong to the ISO 6523 ICD list.
      </assert>
    </rule>
    <rule flag="fatal" context="cbc:InvoicedQuantity[@unitCode] | cbc:BaseQuantity[@unitCode]">
      <assert id="ibr-cl-23" flag="fatal" test="
      some $code in $UNECE_REC20 satisfies normalize-space(@unitCode) = $code
      ">
      [ibr-cl-23]-Unit code MUST be coded according to the UN/ECE Recommendation 20 with Rec 21 extension
      </assert>
    </rule>
    <rule flag="fatal" context="cbc:EmbeddedDocumentBinaryObject[@mimeCode]">
      <assert id="ibr-cl-24" flag="fatal" test="
      some $code in $MIMECODE satisfies normalize-space(@mimeCode) = $code
      ">
      [ibr-cl-24][EN16931-CL001(JP-37)]-Mime code must be according to subset of IANA code list.
      </assert>
    </rule>
    <rule flag="fatal" context="cbc:EndpointID[@schemeID]">
      <assert id="ibr-cl-25" flag="fatal" test="
      some $code in $CEF_EAS satisfies normalize-space(@schemeID) = $code
      ">
      [ibr-cl-25]-Endpoint identifier scheme identifier MUST belong to the CEF EAS code list
      </assert>
    </rule>
    <rule flag="fatal" context="cac:DeliveryLocation/cbc:ID[@schemeID]">
      <assert id="ibr-cl-26" flag="fatal" test="
        some $code in $ISO6523 satisfies normalize-space(@schemeID) = $code
      ">
      <!--<assert id="ibr-cl-26" flag="fatal" test="
      (
        (
          not(contains(normalize-space(@schemeID), ' ')) and
          contains(' 0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213 ', concat(' ', normalize-space(@schemeID), ' '))
        )
      )">-->
      [ibr-cl-26]-Delivery location identifier scheme identifier MUST belong to the ISO 6523 ICD code list
      </assert>
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
      <assert id="UBL-DT-01" flag="fatal" test="string-length(substring-after(.,'.'))&lt;=2">[UBL-DT-01]-warning-Amounts shall be decimal up to two fraction digits</assert>
    </rule>
    <rule context="//*[ends-with(name(), 'BinaryObject')]">
      <assert id="UBL-DT-06" flag="fatal" test="(@mimeCode)">[UBL-DT-06]-warning-Binary object elements shall contain the mime code attribute</assert>
      <assert id="UBL-DT-07" flag="fatal" test="(@filename)">[UBL-DT-07]-warning-Binary object elements shall contain the file name attribute</assert>
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
    <rule context="/ubl:Invoice | /cn:CreditNote">
      <assert id="UBL-CR-001" flag="warning" test="not(ext:UBLExtensions)">[UBL-CR-001]-warning-A UBL invoice should not include extensions</assert>
      <assert id="UBL-CR-002" flag="warning" test="not(cbc:UBLVersionID) or cbc:UBLVersionID = '2.1'">[UBL-CR-002]-warning-A UBL invoice should not include the UBLVersionID or it should be 2.1</assert>
      <assert id="UBL-CR-003" flag="warning" test="not(cbc:ProfileExecutionID)">[UBL-CR-003]-warning-A UBL invoice should not include the ProfileExecutionID </assert>
      <assert id="UBL-CR-004" flag="warning" test="not(cbc:CopyIndicator)">[UBL-CR-004]-warning-A UBL invoice should not include the CopyIndicator </assert>
      <assert id="UBL-CR-005" flag="warning" test="not(cbc:UUID)">[UBL-CR-005]-warning-A UBL invoice should not include the UUID </assert>
      <assert id="UBL-CR-006" flag="warning" test="not(cbc:IssueTime)">[UBL-CR-006]-warning-A UBL invoice should not include the IssueTime </assert>
      <assert id="UBL-CR-007" flag="warning" test="not(cbc:PricingCurrencyCode)">[UBL-CR-007]-warning-A UBL invoice should not include the PricingCurrencyCode</assert>
      <assert id="UBL-CR-008" flag="warning" test="not(cbc:PaymentCurrencyCode)">[UBL-CR-008]-warning-A UBL invoice should not include the PaymentCurrencyCode</assert>
      <assert id="UBL-CR-009" flag="warning" test="not(cbc:PaymentAlternativeCurrencyCode)">[UBL-CR-009]-warning-A UBL invoice should not include the PaymentAlternativeCurrencyCode</assert>
      <assert id="UBL-CR-010" flag="warning" test="not(cbc:AccountingCostCode)">[UBL-CR-010]-warning-A UBL invoice should not include the AccountingCostCode</assert>
      <assert id="UBL-CR-011" flag="warning" test="not(cbc:LineCountNumeric)">[UBL-CR-011]-warning-A UBL invoice should not include the LineCountNumeric</assert>
      <assert id="UBL-CR-012" flag="warning" test="not(cac:InvoicePeriod/cbc:StartTime)">[UBL-CR-012]-warning-A UBL invoice should not include the InvoicePeriod StartTime</assert>
      <assert id="UBL-CR-013" flag="warning" test="not(cac:InvoicePeriod/cbc:EndTime)">[UBL-CR-013]-warning-A UBL invoice should not include the InvoicePeriod EndTime</assert>
      <assert id="UBL-CR-014" flag="warning" test="not(cac:InvoicePeriod/cbc:DurationMeasure)">[UBL-CR-014]-warning-A UBL invoice should not include the InvoicePeriod DurationMeasure</assert>
      <assert id="UBL-CR-015" flag="warning" test="not(cac:InvoicePeriod/cbc:Description)">[UBL-CR-015]-warning-A UBL invoice should not include the InvoicePeriod Description</assert>
      <assert id="UBL-CR-016" flag="warning" test="not(cac:OrderReference/cbc:CopyIndicator)">[UBL-CR-016]-warning-A UBL invoice should not include the OrderReference CopyIndicator</assert>
      <assert id="UBL-CR-017" flag="warning" test="not(cac:OrderReference/cbc:UUID)">[UBL-CR-017]-warning-A UBL invoice should not include the OrderReference UUID</assert>
      <assert id="UBL-CR-018" flag="warning" test="not(cac:OrderReference/cbc:IssueDate)">[UBL-CR-018]-warning-A UBL invoice should not include the OrderReference IssueDate</assert>
      <assert id="UBL-CR-019" flag="warning" test="not(cac:OrderReference/cbc:IssueTime)">[UBL-CR-019]-warning-A UBL invoice should not include the OrderReference IssueTime</assert>
      <assert id="UBL-CR-020" flag="warning" test="not(cac:OrderReference/cbc:CustomerReference)">[UBL-CR-020]-warning-A UBL invoice should not include the OrderReference CustomerReference</assert>
      <assert id="UBL-CR-021" flag="warning" test="not(cac:OrderReference/cbc:OrderTypeCode)">[UBL-CR-021]-warning-A UBL invoice should not include the OrderReference OrderTypeCode</assert>
      <assert id="UBL-CR-022" flag="warning" test="not(cac:OrderReference/cac:DocumentReference)">[UBL-CR-022]-warning-A UBL invoice should not include the OrderReference DocumentReference</assert>
      <!--<assert id="UBL-CR-022" flag="warning" test="not(cac:OrderReference/cbc:DocumentReference)">[UBL-CR-022]-warning-A UBL invoice should not include the OrderReference DocumentReference</assert>-->
      <assert id="UBL-CR-023" flag="warning" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:CopyIndicator)">[UBL-CR-023]-warning-A UBL invoice should not include the BillingReference CopyIndicator</assert>
      <assert id="UBL-CR-024" flag="warning" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:UUID)">[UBL-CR-024]-warning-A UBL invoice should not include the BillingReference UUID</assert>
      <assert id="UBL-CR-025" flag="warning" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:IssueTime)">[UBL-CR-025]-warning-A UBL invoice should not include the BillingReference IssueTime</assert>
      <assert id="UBL-CR-026" flag="warning" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentTypeCode)">[UBL-CR-026]-warning-A UBL invoice should not include the BillingReference DocumentTypeCode</assert>
      <assert id="UBL-CR-027" flag="warning" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentType)">[UBL-CR-027]-warning-A UBL invoice should not include the BillingReference DocumentType</assert>
      <assert id="UBL-CR-028" flag="warning" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:XPath)">[UBL-CR-028]-warning-A UBL invoice should not include the BillingReference XPath</assert>
      <!--<assert id="UBL-CR-028" flag="warning" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:Xpath)">[UBL-CR-028]-warning-A UBL invoice should not include the BillingReference Xpath</assert>-->
      <assert id="UBL-CR-029" flag="warning" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:LanguageID)">[UBL-CR-029]-warning-A UBL invoice should not include the BillingReference LanguageID</assert>
      <assert id="UBL-CR-030" flag="warning" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:LocaleCode)">[UBL-CR-030]-warning-A UBL invoice should not include the BillingReference LocaleCode</assert>
      <assert id="UBL-CR-031" flag="warning" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:VersionID)">[UBL-CR-031]-warning-A UBL invoice should not include the BillingReference VersionID</assert>
      <assert id="UBL-CR-032" flag="warning" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentStatusCode)">[UBL-CR-032]-warning-A UBL invoice should not include the BillingReference DocumentStatusCode</assert>
      <assert id="UBL-CR-033" flag="warning" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentDescription)">[UBL-CR-033]-warning-A UBL invoice should not include the BillingReference DocumenDescription</assert>
      <assert id="UBL-CR-034" flag="warning" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cac:Attachment)">[UBL-CR-034]-warning-A UBL invoice should not include the BillingReference Attachment</assert>
      <assert id="UBL-CR-035" flag="warning" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cac:ValidityPeriod)">[UBL-CR-035]-warning-A UBL invoice should not include the BillingReference ValidityPeriod</assert>
      <assert id="UBL-CR-036" flag="warning" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cac:IssuerParty)">[UBL-CR-036]-warning-A UBL invoice should not include the BillingReference IssuerParty</assert>
      <assert id="UBL-CR-037" flag="warning" test="not(cac:BillingReference/cac:InvoiceDocumentReference/cac:ResultOfVerification)">[UBL-CR-037]-warning-A UBL invoice should not include the BillingReference ResultOfVerification</assert>
      <assert id="UBL-CR-038" flag="warning" test="not(cac:BillingReference/cac:SelfBilledInvoiceDocumentReference)">[UBL-CR-038]-warning-A UBL invoice should not include the BillingReference SelfBilledInvoiceDocumentReference</assert>
      <assert id="UBL-CR-039" flag="warning" test="not(cac:BillingReference/cac:CreditNoteDocumentReference)">[UBL-CR-039]-warning-A UBL invoice should not include the BillingReference CreditNoteDocumentReference</assert>
      <assert id="UBL-CR-040" flag="warning" test="not(cac:BillingReference/cac:SelfBilledCreditNoteDocumentReference)">[UBL-CR-040]-warning-A UBL invoice should not include the BillingReference SelfBilledCreditNoteDocumentReference</assert>
      <assert id="UBL-CR-041" flag="warning" test="not(cac:BillingReference/cac:DebitNoteDocumentReference)">[UBL-CR-041]-warning-A UBL invoice should not include the BillingReference DebitNoteDocumentReference</assert>
      <assert id="UBL-CR-042" flag="warning" test="not(cac:BillingReference/cac:ReminderDocumentReference)">[UBL-CR-042]-warning-A UBL invoice should not include the BillingReference ReminderDocumentReference</assert>
      <assert id="UBL-CR-043" flag="warning" test="not(cac:BillingReference/cac:AdditionalDocumentReference)">[UBL-CR-043]-warning-A UBL invoice should not include the BillingReference AdditionalDocumentReference</assert>
      <assert id="UBL-CR-044" flag="warning" test="not(cac:BillingReference/cac:BillingReferenceLine)">[UBL-CR-044]-warning-A UBL invoice should not include the BillingReference BillingReferenceLine</assert>
      <assert id="UBL-CR-045" flag="warning" test="not(cac:DespatchDocumentReference/cbc:CopyIndicator)">[UBL-CR-045]-warning-A UBL invoice should not include the DespatchDocumentReference CopyIndicator</assert>
      <assert id="UBL-CR-046" flag="warning" test="not(cac:DespatchDocumentReference/cbc:UUID)">[UBL-CR-046]-warning-A UBL invoice should not include the DespatchDocumentReference UUID</assert>
      <assert id="UBL-CR-047" flag="warning" test="not(cac:DespatchDocumentReference/cbc:IssueDate)">[UBL-CR-047]-warning-A UBL invoice should not include the DespatchDocumentReference IssueDate</assert>
      <assert id="UBL-CR-048" flag="warning" test="not(cac:DespatchDocumentReference/cbc:IssueTime)">[UBL-CR-048]-warning-A UBL invoice should not include the DespatchDocumentReference IssueTime</assert>
      <assert id="UBL-CR-049" flag="warning" test="not(cac:DespatchDocumentReference/cbc:DocumentTypeCode)">[UBL-CR-049]-warning-A UBL invoice should not include the DespatchDocumentReference DocumentTypeCode</assert>
      <assert id="UBL-CR-050" flag="warning" test="not(cac:DespatchDocumentReference/cbc:DocumentType)">[UBL-CR-050]-warning-A UBL invoice should not include the DespatchDocumentReference DocumentType</assert>
      <assert id="UBL-CR-051" flag="warning" test="not(cac:DespatchDocumentReference/cbc:XPath)">[UBL-CR-051]-warning-A UBL invoice should not include the DespatchDocumentReference XPath</assert>
      <!--<assert id="UBL-CR-051" flag="warning" test="not(cac:DespatchDocumentReference/cbc:Xpath)">[UBL-CR-051]-warning-A UBL invoice should not include the DespatchDocumentReference Xpath</assert>-->
      <assert id="UBL-CR-052" flag="warning" test="not(cac:DespatchDocumentReference/cbc:LanguageID)">[UBL-CR-052]-warning-A UBL invoice should not include the DespatchDocumentReference LanguageID</assert>
      <assert id="UBL-CR-053" flag="warning" test="not(cac:DespatchDocumentReference/cbc:LocaleCode)">[UBL-CR-053]-warning-A UBL invoice should not include the DespatchDocumentReference LocaleCode</assert>
      <assert id="UBL-CR-054" flag="warning" test="not(cac:DespatchDocumentReference/cbc:VersionID)">[UBL-CR-054]-warning-A UBL invoice should not include the DespatchDocumentReference VersionID</assert>
      <assert id="UBL-CR-055" flag="warning" test="not(cac:DespatchDocumentReference/cbc:DocumentStatusCode)">[UBL-CR-055]-warning-A UBL invoice should not include the DespatchDocumentReference DocumentStatusCode</assert>
      <assert id="UBL-CR-056" flag="warning" test="not(cac:DespatchDocumentReference/cbc:DocumentDescription)">[UBL-CR-056]-warning-A UBL invoice should not include the DespatchDocumentReference DocumentDescription</assert>
      <assert id="UBL-CR-057" flag="warning" test="not(cac:DespatchDocumentReference/cac:Attachment)">[UBL-CR-057]-warning-A UBL invoice should not include the DespatchDocumentReference Attachment</assert>
      <assert id="UBL-CR-058" flag="warning" test="not(cac:DespatchDocumentReference/cac:ValidityPeriod)">[UBL-CR-058]-warning-A UBL invoice should not include the DespatchDocumentReference ValidityPeriod</assert>
      <assert id="UBL-CR-059" flag="warning" test="not(cac:DespatchDocumentReference/cac:IssuerParty)">[UBL-CR-059]-warning-A UBL invoice should not include the DespatchDocumentReference IssuerParty</assert>
      <assert id="UBL-CR-060" flag="warning" test="not(cac:DespatchDocumentReference/cac:ResultOfVerification)">[UBL-CR-060]-warning-A UBL invoice should not include the DespatchDocumentReference ResultOfVerification</assert>
      <assert id="UBL-CR-061" flag="warning" test="not(cac:ReceiptDocumentReference/cbc:CopyIndicator)">[UBL-CR-061]-warning-A UBL invoice should not include the ReceiptDocumentReference CopyIndicator</assert>
      <assert id="UBL-CR-062" flag="warning" test="not(cac:ReceiptDocumentReference/cbc:UUID)">[UBL-CR-062]-warning-A UBL invoice should not include the ReceiptDocumentReference UUID</assert>
      <assert id="UBL-CR-063" flag="warning" test="not(cac:ReceiptDocumentReference/cbc:IssueDate)">[UBL-CR-063]-warning-A UBL invoice should not include the ReceiptDocumentReference IssueDate</assert>
      <assert id="UBL-CR-064" flag="warning" test="not(cac:ReceiptDocumentReference/cbc:IssueTime)">[UBL-CR-064]-warning-A UBL invoice should not include the ReceiptDocumentReference IssueTime</assert>
      <assert id="UBL-CR-065" flag="warning" test="not(cac:ReceiptDocumentReference/cbc:DocumentTypeCode)">[UBL-CR-065]-warning-A UBL invoice should not include the ReceiptDocumentReference DocumentTypeCode</assert>
      <assert id="UBL-CR-066" flag="warning" test="not(cac:ReceiptDocumentReference/cbc:DocumentType)">[UBL-CR-066]-warning-A UBL invoice should not include the ReceiptDocumentReference DocumentType</assert>
      <assert id="UBL-CR-067" flag="warning" test="not(cac:ReceiptDocumentReference/cbc:XPath)">[UBL-CR-067]-warning-A UBL invoice should not include the ReceiptDocumentReference XPath</assert>
      <!--<assert id="UBL-CR-067" flag="warning" test="not(cac:ReceiptDocumentReference/cbc:Xpath)">[UBL-CR-067]-warning-A UBL invoice should not include the ReceiptDocumentReference Xpath</assert>-->
      <assert id="UBL-CR-068" flag="warning" test="not(cac:ReceiptDocumentReference/cbc:LanguageID)">[UBL-CR-068]-warning-A UBL invoice should not include the ReceiptDocumentReference LanguageID</assert>
      <assert id="UBL-CR-069" flag="warning" test="not(cac:ReceiptDocumentReference/cbc:LocaleCode)">[UBL-CR-069]-warning-A UBL invoice should not include the ReceiptDocumentReference LocaleCode</assert>
      <assert id="UBL-CR-070" flag="warning" test="not(cac:ReceiptDocumentReference/cbc:VersionID)">[UBL-CR-070]-warning-A UBL invoice should not include the ReceiptDocumentReference VersionID</assert>
      <assert id="UBL-CR-071" flag="warning" test="not(cac:ReceiptDocumentReference/cbc:DocumentStatusCode)">[UBL-CR-071]-warning-A UBL invoice should not include the ReceiptDocumentReference DocumentStatusCode</assert>
      <assert id="UBL-CR-072" flag="warning" test="not(cac:ReceiptDocumentReference/cbc:DocumentDescription)">[UBL-CR-072]-warning-A UBL invoice should not include the ReceiptDocumentReference DocumentDescription</assert>
      <assert id="UBL-CR-073" flag="warning" test="not(cac:ReceiptDocumentReference/cac:Attachment)">[UBL-CR-073]-warning-A UBL invoice should not include the ReceiptDocumentReference Attachment</assert>
      <assert id="UBL-CR-074" flag="warning" test="not(cac:ReceiptDocumentReference/cac:ValidityPeriod)">[UBL-CR-074]-warning-A UBL invoice should not include the ReceiptDocumentReference ValidityPeriod</assert>
      <assert id="UBL-CR-075" flag="warning" test="not(cac:ReceiptDocumentReference/cac:IssuerParty)">[UBL-CR-075]-warning-A UBL invoice should not include the ReceiptDocumentReference IssuerParty</assert>
      <assert id="UBL-CR-076" flag="warning" test="not(cac:ReceiptDocumentReference/cac:ResultOfVerification)">[UBL-CR-076]-warning-A UBL invoice should not include the ReceiptDocumentReference ResultOfVerification</assert>
      <assert id="UBL-CR-077" flag="warning" test="not(cac:StatementDocumentReference)">[UBL-CR-077]-warning-A UBL invoice should not include the StatementDocumentReference</assert>
      <assert id="UBL-CR-078" flag="warning" test="not(cac:OriginatorDocumentReference/cbc:CopyIndicator)">[UBL-CR-078]-warning-A UBL invoice should not include the OriginatorDocumentReference CopyIndicator</assert>
      <assert id="UBL-CR-079" flag="warning" test="not(cac:OriginatorDocumentReference/cbc:UUID)">[UBL-CR-079]-warning-A UBL invoice should not include the OriginatorDocumentReference UUID</assert>
      <assert id="UBL-CR-080" flag="warning" test="not(cac:OriginatorDocumentReference/cbc:IssueDate)">[UBL-CR-080]-warning-A UBL invoice should not include the OriginatorDocumentReference IssueDate</assert>
      <assert id="UBL-CR-081" flag="warning" test="not(cac:OriginatorDocumentReference/cbc:IssueTime)">[UBL-CR-081]-warning-A UBL invoice should not include the OriginatorDocumentReference IssueTime</assert>
      <assert id="UBL-CR-082" flag="warning" test="not(cac:OriginatorDocumentReference/cbc:DocumentTypeCode)">[UBL-CR-082]-warning-A UBL invoice should not include the OriginatorDocumentReference DocumentTypeCode</assert>
      <assert id="UBL-CR-083" flag="warning" test="not(cac:OriginatorDocumentReference/cbc:DocumentType)">[UBL-CR-083]-warning-A UBL invoice should not include the OriginatorDocumentReference DocumentType</assert>
      <assert id="UBL-CR-084" flag="warning" test="not(cac:OriginatorDocumentReference/cbc:XPath)">[UBL-CR-084]-warning-A UBL invoice should not include the OriginatorDocumentReference XPath</assert>
      <!--<assert id="UBL-CR-084" flag="warning" test="not(cac:OriginatorDocumentReference/cbc:Xpath)">[UBL-CR-084]-warning-A UBL invoice should not include the OriginatorDocumentReference Xpath</assert>-->
      <assert id="UBL-CR-085" flag="warning" test="not(cac:OriginatorDocumentReference/cbc:LanguageID)">[UBL-CR-085]-warning-A UBL invoice should not include the OriginatorDocumentReference LanguageID</assert>
      <assert id="UBL-CR-086" flag="warning" test="not(cac:OriginatorDocumentReference/cbc:LocaleCode)">[UBL-CR-086]-warning-A UBL invoice should not include the OriginatorDocumentReference LocaleCode</assert>
      <assert id="UBL-CR-087" flag="warning" test="not(cac:OriginatorDocumentReference/cbc:VersionID)">[UBL-CR-087]-warning-A UBL invoice should not include the OriginatorDocumentReference VersionID</assert>
      <assert id="UBL-CR-088" flag="warning" test="not(cac:OriginatorDocumentReference/cbc:DocumentStatusCode)">[UBL-CR-088]-warning-A UBL invoice should not include the OriginatorDocumentReference DocumentStatusCode</assert>
      <assert id="UBL-CR-089" flag="warning" test="not(cac:OriginatorDocumentReference/cbc:DocumentDescription)">[UBL-CR-089]-warning-A UBL invoice should not include the OriginatorDocumentReference DocumentDescription</assert>
      <assert id="UBL-CR-090" flag="warning" test="not(cac:OriginatorDocumentReference/cac:Attachment)">[UBL-CR-090]-warning-A UBL invoice should not include the OriginatorDocumentReference Attachment</assert>
      <assert id="UBL-CR-091" flag="warning" test="not(cac:OriginatorDocumentReference/cac:ValidityPeriod)">[UBL-CR-091]-warning-A UBL invoice should not include the OriginatorDocumentReference ValidityPeriod</assert>
      <assert id="UBL-CR-092" flag="warning" test="not(cac:OriginatorDocumentReference/cac:IssuerParty)">[UBL-CR-092]-warning-A UBL invoice should not include the OriginatorDocumentReference IssuerParty</assert>
      <assert id="UBL-CR-093" flag="warning" test="not(cac:OriginatorDocumentReference/cac:ResultOfVerification)">[UBL-CR-093]-warning-A UBL invoice should not include the OriginatorDocumentReference ResultOfVerification</assert>
      <assert id="UBL-CR-094" flag="warning" test="not(cac:ContractDocumentReference/cbc:CopyIndicator)">[UBL-CR-094]-warning-A UBL invoice should not include the ContractDocumentReference CopyIndicator</assert>
      <assert id="UBL-CR-095" flag="warning" test="not(cac:ContractDocumentReference/cbc:UUID)">[UBL-CR-095]-warning-A UBL invoice should not include the ContractDocumentReference UUID</assert>
      <assert id="UBL-CR-096" flag="warning" test="not(cac:ContractDocumentReference/cbc:IssueDate)">[UBL-CR-096]-warning-A UBL invoice should not include the ContractDocumentReference IssueDate</assert>
      <assert id="UBL-CR-097" flag="warning" test="not(cac:ContractDocumentReference/cbc:IssueTime)">[UBL-CR-097]-warning-A UBL invoice should not include the ContractDocumentReference IssueTime</assert>
      <assert id="UBL-CR-098" flag="warning" test="not(cac:ContractDocumentReference/cbc:DocumentTypeCode)">[UBL-CR-098]-warning-A UBL invoice should not include the ContractDocumentReference DocumentTypeCode</assert>
      <assert id="UBL-CR-099" flag="warning" test="not(cac:ContractDocumentReference/cbc:DocumentType)">[UBL-CR-099]-warning-A UBL invoice should not include the ContractDocumentReference DocumentType</assert>
      <assert id="UBL-CR-100" flag="warning" test="not(cac:ContractDocumentReference/cbc:XPath)">[UBL-CR-100]-warning-A UBL invoice should not include the ContractDocumentReference XPath</assert>
      <!--<assert id="UBL-CR-100" flag="warning" test="not(cac:ContractDocumentReference/cbc:Xpath)">[UBL-CR-100]-warning-A UBL invoice should not include the ContractDocumentReference Xpath</assert>-->
      <assert id="UBL-CR-101" flag="warning" test="not(cac:ContractDocumentReference/cbc:LanguageID)">[UBL-CR-101]-warning-A UBL invoice should not include the ContractDocumentReference LanguageID</assert>
      <assert id="UBL-CR-102" flag="warning" test="not(cac:ContractDocumentReference/cbc:LocaleCode)">[UBL-CR-102]-warning-A UBL invoice should not include the ContractDocumentReference LocaleCode</assert>
      <assert id="UBL-CR-103" flag="warning" test="not(cac:ContractDocumentReference/cbc:VersionID)">[UBL-CR-103]-warning-A UBL invoice should not include the ContractDocumentReference VersionID</assert>
      <assert id="UBL-CR-104" flag="warning" test="not(cac:ContractDocumentReference/cbc:DocumentStatusCode)">[UBL-CR-104]-warning-A UBL invoice should not include the ContractDocumentReference DocumentStatusCode</assert>
      <assert id="UBL-CR-105" flag="warning" test="not(cac:ContractDocumentReference/cbc:DocumentDescription)">[UBL-CR-105]-warning-A UBL invoice should not include the ContractDocumentReference DocumentDescription</assert>
      <assert id="UBL-CR-106" flag="warning" test="not(cac:ContractDocumentReference/cac:Attachment)">[UBL-CR-106]-warning-A UBL invoice should not include the ContractDocumentReference Attachment</assert>
      <assert id="UBL-CR-107" flag="warning" test="not(cac:ContractDocumentReference/cac:ValidityPeriod)">[UBL-CR-107]-warning-A UBL invoice should not include the ContractDocumentReference ValidityPeriod</assert>
      <assert id="UBL-CR-108" flag="warning" test="not(cac:ContractDocumentReference/cac:IssuerParty)">[UBL-CR-108]-warning-A UBL invoice should not include the ContractDocumentReference IssuerParty</assert>
      <assert id="UBL-CR-109" flag="warning" test="not(cac:ContractDocumentReference/cac:ResultOfVerification)">[UBL-CR-109]-warning-A UBL invoice should not include the ContractDocumentReference ResultOfVerification</assert>
      <assert id="UBL-CR-110" flag="warning" test="not(cac:AdditionalDocumentReference/cbc:CopyIndicator)">[UBL-CR-110]-warning-A UBL invoice should not include the AdditionalDocumentReference CopyIndicator</assert>
      <assert id="UBL-CR-111" flag="warning" test="not(cac:AdditionalDocumentReference/cbc:UUID)">[UBL-CR-111]-warning-A UBL invoice should not include the AdditionalDocumentReference UUID</assert>
      <assert id="UBL-CR-112" flag="warning" test="not(cac:AdditionalDocumentReference/cbc:IssueDate)">[UBL-CR-112]-warning-A UBL invoice should not include the AdditionalDocumentReference IssueDate</assert>
      <assert id="UBL-CR-113" flag="warning" test="not(cac:AdditionalDocumentReference/cbc:IssueTime)">[UBL-CR-113]-warning-A UBL invoice should not include the AdditionalDocumentReference IssueTime</assert>
      <assert id="UBL-CR-114" flag="warning" test="not(cac:AdditionalDocumentReference/cbc:DocumentType)">[UBL-CR-114]-warning-A UBL invoice should not include the AdditionalDocumentReference DocumentType</assert>
      <assert id="UBL-CR-115" flag="warning" test="not(cac:AdditionalDocumentReference/cbc:XPath)">[UBL-CR-115]-warning-A UBL invoice should not include the AdditionalDocumentReference XPath</assert>
      <!--<assert id="UBL-CR-115" flag="warning" test="not(cac:AdditionalDocumentReference/cbc:Xpath)">[UBL-CR-115]-warning-A UBL invoice should not include the AdditionalDocumentReference Xpath</assert>-->
      <assert id="UBL-CR-116" flag="warning" test="not(cac:AdditionalDocumentReference/cbc:LanguageID)">[UBL-CR-116]-warning-A UBL invoice should not include the AdditionalDocumentReference LanguageID</assert>
      <assert id="UBL-CR-117" flag="warning" test="not(cac:AdditionalDocumentReference/cbc:LocaleCode)">[UBL-CR-117]-warning-A UBL invoice should not include the AdditionalDocumentReference LocaleCode</assert>
      <assert id="UBL-CR-118" flag="warning" test="not(cac:AdditionalDocumentReference/cbc:VersionID)">[UBL-CR-118]-warning-A UBL invoice should not include the AdditionalDocumentReference VersionID</assert>
      <assert id="UBL-CR-119" flag="warning" test="not(cac:AdditionalDocumentReference/cbc:DocumentStatusCode)">[UBL-CR-119]-warning-A UBL invoice should not include the AdditionalDocumentReference DocumentStatusCode</assert>
      <assert id="UBL-CR-121" flag="warning" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:DocumentHash)">[UBL-CR-121]-warning-A UBL invoice should not include the AdditionalDocumentReference Attachment External DocumentHash</assert>
      <assert id="UBL-CR-122" flag="warning" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:HashAlgorithmMethod)">[UBL-CR-122]-warning-A UBL invoice should not include the AdditionalDocumentReference Attachment External HashAlgorithmMethod</assert>
      <assert id="UBL-CR-123" flag="warning" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:ExpiryDate)">[UBL-CR-123]-warning-A UBL invoice should not include the AdditionalDocumentReference Attachment External ExpiryDate</assert>
      <assert id="UBL-CR-124" flag="warning" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:ExpiryTime)">[UBL-CR-124]-warning-A UBL invoice should not include the AdditionalDocumentReference Attachment External ExpiryTime</assert>
      <assert id="UBL-CR-125" flag="warning" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:MimeCode)">[UBL-CR-125]-warning-A UBL invoice should not include the AdditionalDocumentReference Attachment External MimeCode</assert>
      <assert id="UBL-CR-126" flag="warning" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:FormatCode)">[UBL-CR-126]-warning-A UBL invoice should not include the AdditionalDocumentReference Attachment External FormatCode</assert>
      <assert id="UBL-CR-127" flag="warning" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:EncodingCode)">[UBL-CR-127]-warning-A UBL invoice should not include the AdditionalDocumentReference Attachment External EncodingCode</assert>
      <assert id="UBL-CR-128" flag="warning" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:CharacterSetCode)">[UBL-CR-128]-warning-A UBL invoice should not include the AdditionalDocumentReference Attachment External CharacterSetCode</assert>
      <assert id="UBL-CR-129" flag="warning" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:FileName)">[UBL-CR-129]-warning-A UBL invoice should not include the AdditionalDocumentReference Attachment External FileName</assert>
      <assert id="UBL-CR-130" flag="warning" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:Description)">[UBL-CR-130]-warning-A UBL invoice should not include the AdditionalDocumentReference Attachment External Descriprion</assert>
      <assert id="UBL-CR-131" flag="warning" test="not(cac:AdditionalDocumentReference/cac:ValidityPeriod)">[UBL-CR-131]-warning-A UBL invoice should not include the AdditionalDocumentReference ValidityPeriod</assert>
      <assert id="UBL-CR-132" flag="warning" test="not(cac:AdditionalDocumentReference/cac:IssuerParty)">[UBL-CR-132]-warning-A UBL invoice should not include the AdditionalDocumentReference IssuerParty</assert>
      <assert id="UBL-CR-133" flag="warning" test="not(cac:AdditionalDocumentReference/cac:ResultOfVerification)">[UBL-CR-133]-warning-A UBL invoice should not include the AdditionalDocumentReference ResultOfVerification</assert>
      <assert id="UBL-CR-134" flag="warning" test="not(cac:ProjectReference/cbc:UUID)">[UBL-CR-134]-warning-A UBL invoice should not include the ProjectReference UUID</assert>
      <assert id="UBL-CR-135" flag="warning" test="not(cac:ProjectReference/cbc:IssueDate)">[UBL-CR-135]-warning-A UBL invoice should not include the ProjectReference IssueDate</assert>
      <assert id="UBL-CR-136" flag="warning" test="not(cac:ProjectReference/cac:WorkPhaseReference)">[UBL-CR-136]-warning-A UBL invoice should not include the ProjectReference WorkPhaseReference</assert>
      <assert id="UBL-CR-137" flag="warning" test="not(cac:Signature)">[UBL-CR-137]-warning-A UBL invoice should not include the Signature</assert>
      <assert id="UBL-CR-138" flag="warning" test="not(cac:AccountingSupplierParty/cbc:CustomerAssignedAccountID)">[UBL-CR-138]-warning-A UBL invoice should not include the AccountingSupplierParty CustomerAssignedAccountID</assert>
      <assert id="UBL-CR-139" flag="warning" test="not(cac:AccountingSupplierParty/cbc:AdditionalAccountID)">[UBL-CR-139]-warning-A UBL invoice should not include the AccountingSupplierParty AdditionalAccountID</assert>
      <assert id="UBL-CR-140" flag="warning" test="not(cac:AccountingSupplierParty/cbc:DataSendingCapability)">[UBL-CR-140]-warning-A UBL invoice should not include the AccountingSupplierParty DataSendingCapability</assert>
      <assert id="UBL-CR-141" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cbc:MarkCareIndicator)">[UBL-CR-141]-warning-A UBL invoice should not include the AccountingSupplierParty Party MarkCareIndicator</assert>
      <assert id="UBL-CR-142" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cbc:MarkAttentionIndicator)">[UBL-CR-142]-warning-A UBL invoice should not include the AccountingSupplierParty Party MarkAttentionIndicator</assert>
      <assert id="UBL-CR-143" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cbc:WebsiteURI)">[UBL-CR-143]-warning-A UBL invoice should not include the AccountingSupplierParty Party WebsiteURI</assert>
      <assert id="UBL-CR-144" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cbc:LogoReferenceID)">[UBL-CR-144]-warning-A UBL invoice should not include the AccountingSupplierParty Party LogoReferenceID</assert>
      <assert id="UBL-CR-145" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cbc:IndustryClassificationCode)">[UBL-CR-145]-warning-A UBL invoice should not include the AccountingSupplierParty Party IndustryClassificationCode</assert>
      <assert id="UBL-CR-146" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:Language)">[UBL-CR-146]-warning-A UBL invoice should not include the AccountingSupplierParty Party Language</assert>
      <assert id="UBL-CR-147" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:ID)">[UBL-CR-147]-warning-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress ID</assert>
      <assert id="UBL-CR-148" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AddressTypeCode)">[UBL-CR-148]-warning-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress AddressTypeCode</assert>
      <assert id="UBL-CR-149" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AddressFormatCode)">[UBL-CR-149]-warning-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress AddressFormatCode</assert>
      <assert id="UBL-CR-150" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Postbox)">[UBL-CR-150]-warning-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress Postbox</assert>
      <assert id="UBL-CR-151" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Floor)">[UBL-CR-151]-warning-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress Floor</assert>
      <assert id="UBL-CR-152" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Room)">[UBL-CR-152]-warning-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress Room</assert>
      <assert id="UBL-CR-153" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:BlockName)">[UBL-CR-153]-warning-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress BlockName</assert>
      <assert id="UBL-CR-154" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:BuildingName)">[UBL-CR-154]-warning-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress BuildingName</assert>
      <assert id="UBL-CR-155" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:BuildingNumber)">[UBL-CR-155]-warning-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress BuildingNumber</assert>
      <assert id="UBL-CR-156" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:InhouseMail)">[UBL-CR-156]-warning-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress InhouseMail</assert>
      <assert id="UBL-CR-157" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Department)">[UBL-CR-157]-warning-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress Department</assert>
      <assert id="UBL-CR-158" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:MarkAttention)">[UBL-CR-158]-warning-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress MarkAttention</assert>
      <assert id="UBL-CR-159" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:MarkCare)">[UBL-CR-159]-warning-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress MarkCare</assert>
      <assert id="UBL-CR-160" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification)">[UBL-CR-160]-warning-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress PlotIdentification</assert>
      <assert id="UBL-CR-161" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName)">[UBL-CR-161]-warning-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress CitySubdivisionName</assert>
      <assert id="UBL-CR-162" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode)">[UBL-CR-162]-warning-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress CountrySubentityCode</assert>
      <assert id="UBL-CR-163" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Region)">[UBL-CR-163]-warning-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress Region</assert>
      <assert id="UBL-CR-164" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:District)">[UBL-CR-164]-warning-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress District</assert>
      <assert id="UBL-CR-165" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:TimezoneOffset)">[UBL-CR-165]-warning-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress TimezoneOffset</assert>
      <assert id="UBL-CR-166" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:Name)">[UBL-CR-166]-warning-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress Country Name</assert>
      <assert id="UBL-CR-167" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:LocationCoordinate)">[UBL-CR-167]-warning-A UBL invoice should not include the AccountingSupplierParty Party PostalAddress LocationCoordinate</assert>
      <assert id="UBL-CR-168" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PhysicalLocation)">[UBL-CR-168]-warning-A UBL invoice should not include the AccountingSupplierParty Party PhysicalLocation</assert>
      <assert id="UBL-CR-169" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:RegistrationName)">[UBL-CR-169]-warning-A UBL invoice should not include the AccountingSupplierParty Party PartyTaxScheme RegistrationName</assert>
      <assert id="UBL-CR-170" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:TaxLevelCode)">[UBL-CR-170]-warning-A UBL invoice should not include the AccountingSupplierParty Party PartyTaxScheme TaxLevelCode</assert>
      <assert id="UBL-CR-171" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReasonCode)">[UBL-CR-171]-warning-A UBL invoice should not include the AccountingSupplierParty Party PartyTaxScheme ExemptionReasonCode</assert>
      <assert id="UBL-CR-172" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReason)">[UBL-CR-172]-warning-A UBL invoice should not include the AccountingSupplierParty Party PartyTaxScheme ExemptionReason</assert>
      <assert id="UBL-CR-173" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:RegistrationAddress)">[UBL-CR-173]-warning-A UBL invoice should not include the AccountingSupplierParty Party PartyTaxScheme RegistrationAddress</assert>
      <assert id="UBL-CR-174" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:Name)">[UBL-CR-174]-warning-A UBL invoice should not include the AccountingSupplierParty Party PartyTaxScheme TaxScheme Name</assert>
      <assert id="UBL-CR-175" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:TaxTypeCode)">[UBL-CR-175]-warning-A UBL invoice should not include the AccountingSupplierParty Party PartyTaxScheme TaxScheme TaxTypeCode</assert>
      <assert id="UBL-CR-176" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:CurrencyCode)">[UBL-CR-176]-warning-A UBL invoice should not include the AccountingSupplierParty Party PartyTaxScheme TaxScheme CurrencyCode</assert>
      <assert id="UBL-CR-177" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cac:JurisdictionRegionAddress)">[UBL-CR-177]-warning-A UBL invoice should not include the AccountingSupplierParty Party PartyTaxScheme TaxScheme JurisdictionRegionAddress</assert>
      <assert id="UBL-CR-178" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationDate)">[UBL-CR-178]-warning-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity RegistrationDate</assert>
      <assert id="UBL-CR-179" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationExpirationDate)">[UBL-CR-179]-warning-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity RegistrationExpirationDate</assert>
      <assert id="UBL-CR-180" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLegalFormCode)">[UBL-CR-180]-warning-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity CompanyLegalFormCode</assert>
      <assert id="UBL-CR-181" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:SoleProprietorshipIndicator)">[UBL-CR-181]-warning-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity SoleProprietorshipIndicator</assert>
      <assert id="UBL-CR-182" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLiquidationStatusCode)">[UBL-CR-182]-warning-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity CompanyLiquidationStatusCode</assert>
      <assert id="UBL-CR-183" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CorporateStockAmount)">[UBL-CR-183]-warning-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity CorporationStockAmount</assert>
      <!--<assert id="UBL-CR-183" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CorporationStockAmount)">[UBL-CR-183]-warning-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity CorporationStockAmount</assert>-->
      <assert id="UBL-CR-184" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:FullyPaidSharesIndicator)">[UBL-CR-184]-warning-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity FullyPaidSharesIndicator</assert>
      <assert id="UBL-CR-185" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress)">[UBL-CR-185]-warning-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity RegistrationAddress</assert>
      <assert id="UBL-CR-186" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:CorporateRegistrationScheme)">[UBL-CR-186]-warning-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity CorporateRegistrationScheme</assert>
      <assert id="UBL-CR-187" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:HeadOfficeParty)">[UBL-CR-187]-warning-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity HeadOfficeParty</assert>
      <assert id="UBL-CR-188" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:ShareholderParty)">[UBL-CR-188]-warning-A UBL invoice should not include the AccountingSupplierParty Party PartyLegalEntity ShareholderParty</assert>
      <assert id="UBL-CR-189" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:ID)">[UBL-CR-189]-warning-A UBL invoice should not include the AccountingSupplierParty Party Contact ID</assert>
      <assert id="UBL-CR-190" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Telefax)">[UBL-CR-190]-warning-A UBL invoice should not include the AccountingSupplierParty Party Contact Telefax</assert>
      <assert id="UBL-CR-191" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Note)">[UBL-CR-191]-warning-A UBL invoice should not include the AccountingSupplierParty Party Contact Note</assert>
      <assert id="UBL-CR-192" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cac:OtherCommunication)">[UBL-CR-192]-warning-A UBL invoice should not include the AccountingSupplierParty Party Contact OtherCommunication</assert>
      <assert id="UBL-CR-193" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:Person)">[UBL-CR-193]-warning-A UBL invoice should not include the AccountingSupplierParty Party Person</assert>
      <assert id="UBL-CR-194" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:AgentParty)">[UBL-CR-194]-warning-A UBL invoice should not include the AccountingSupplierParty Party AgentParty</assert>
      <assert id="UBL-CR-195" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:ServiceProviderParty)">[UBL-CR-195]-warning-A UBL invoice should not include the AccountingSupplierParty Party ServiceProviderParty</assert>
      <assert id="UBL-CR-196" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:PowerOfAttorney)">[UBL-CR-196]-warning-A UBL invoice should not include the AccountingSupplierParty Party PowerOfAttorney</assert>
      <assert id="UBL-CR-197" flag="warning" test="not(cac:AccountingSupplierParty/cac:Party/cac:FinancialAccount)">[UBL-CR-197]-warning-A UBL invoice should not include the AccountingSupplierParty Party FinancialAccount</assert>
      <assert id="UBL-CR-198" flag="warning" test="not(cac:AccountingSupplierParty/cac:DespatchContact)">[UBL-CR-198]-warning-A UBL invoice should not include the AccountingSupplierParty DespatchContact</assert>
      <assert id="UBL-CR-199" flag="warning" test="not(cac:AccountingSupplierParty/cac:AccountingContact)">[UBL-CR-199]-warning-A UBL invoice should not include the AccountingSupplierParty AccountingContact</assert>
      <assert id="UBL-CR-200" flag="warning" test="not(cac:AccountingSupplierParty/cac:SellerContact)">[UBL-CR-200]-warning-A UBL invoice should not include the AccountingSupplierParty SellerContact</assert>
      <assert id="UBL-CR-201" flag="warning" test="not(cac:AccountingCustomerParty/cbc:CustomerAssignedAccountID)">[UBL-CR-201]-warning-A UBL invoice should not include the AccountingCustomerParty CustomerAssignedAccountID</assert>
      <assert id="UBL-CR-202" flag="warning" test="not(cac:AccountingCustomerParty/cbc:SupplierAssignedAccountID)">[UBL-CR-202]-warning-A UBL invoice should not include the AccountingCustomerParty SupplierAssignedAccountID</assert>
      <assert id="UBL-CR-203" flag="warning" test="not(cac:AccountingCustomerParty/cbc:AdditionalAccountID)">[UBL-CR-203]-warning-A UBL invoice should not include the AccountingCustomerParty AdditionalAccountID</assert>
      <assert id="UBL-CR-204" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cbc:MarkCareIndicator)">[UBL-CR-204]-warning-A UBL invoice should not include the AccountingCustomerParty Party MarkCareIndicator</assert>
      <assert id="UBL-CR-205" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cbc:MarkAttentionIndicator)">[UBL-CR-205]-warning-A UBL invoice should not include the AccountingCustomerParty Party MarkAttentionIndicator</assert>
      <assert id="UBL-CR-206" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cbc:WebsiteURI)">[UBL-CR-206]-warning-A UBL invoice should not include the AccountingCustomerParty Party WebsiteURI</assert>
      <assert id="UBL-CR-207" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cbc:LogoReferenceID)">[UBL-CR-207]-warning-A UBL invoice should not include the AccountingCustomerParty Party LogoReferenceID</assert>
      <assert id="UBL-CR-208" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cbc:IndustryClassificationCode)">[UBL-CR-208]-warning-A UBL invoice should not include the AccountingCustomerParty Party IndustryClassificationCode</assert>
      <assert id="UBL-CR-209" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:Language)">[UBL-CR-209]-warning-A UBL invoice should not include the AccountingCustomerParty Party Language</assert>
      <assert id="UBL-CR-210" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:ID)">[UBL-CR-210]-warning-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress ID</assert>
      <assert id="UBL-CR-211" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AddressTypeCode)">[UBL-CR-211]-warning-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress AddressTypeCode</assert>
      <assert id="UBL-CR-212" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AddressFormatCode)">[UBL-CR-212]-warning-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress AddressFormatCode</assert>
      <assert id="UBL-CR-213" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Postbox)">[UBL-CR-213]-warning-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress Postbox</assert>
      <assert id="UBL-CR-214" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Floor)">[UBL-CR-214]-warning-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress Floor</assert>
      <assert id="UBL-CR-215" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Room)">[UBL-CR-215]-warning-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress Room</assert>
      <assert id="UBL-CR-216" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:BlockName)">[UBL-CR-216]-warning-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress BlockName</assert>
      <assert id="UBL-CR-217" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:BuildingName)">[UBL-CR-217]-warning-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress BuildingName</assert>
      <assert id="UBL-CR-218" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:BuildingNumber)">[UBL-CR-218]-warning-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress BuildingNumber</assert>
      <assert id="UBL-CR-219" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:InhouseMail)">[UBL-CR-219]-warning-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress InhouseMail</assert>
      <assert id="UBL-CR-220" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Department)">[UBL-CR-220]-warning-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress Department</assert>
      <assert id="UBL-CR-221" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:MarkAttention)">[UBL-CR-221]-warning-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress MarkAttention</assert>
      <assert id="UBL-CR-222" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:MarkCare)">[UBL-CR-222]-warning-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress MarkCare</assert>
      <assert id="UBL-CR-223" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification)">[UBL-CR-223]-warning-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress PlotIdentification</assert>
      <assert id="UBL-CR-224" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName)">[UBL-CR-224]-warning-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress CitySubdivisionName</assert>
      <assert id="UBL-CR-225" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode)">[UBL-CR-225]-warning-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress CountrySubentityCode</assert>
      <assert id="UBL-CR-226" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Region)">[UBL-CR-226]-warning-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress Region</assert>
      <assert id="UBL-CR-227" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:District)">[UBL-CR-227]-warning-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress District</assert>
      <assert id="UBL-CR-228" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:TimezoneOffset)">[UBL-CR-228]-warning-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress TimezoneOffset</assert>
      <assert id="UBL-CR-229" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:Name)">[UBL-CR-229]-warning-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress Country Name</assert>
      <assert id="UBL-CR-230" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:LocationCoordinate)">[UBL-CR-230]-warning-A UBL invoice should not include the AccountingCustomerParty Party PostalAddress LocationCoordinate</assert>
      <assert id="UBL-CR-231" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PhysicalLocation)">[UBL-CR-231]-warning-A UBL invoice should not include the AccountingCustomerParty Party PhysicalLocation</assert>
      <assert id="UBL-CR-232" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:RegistrationName)">[UBL-CR-232]-warning-A UBL invoice should not include the AccountingCustomerParty Party PartyTaxScheme RegistrationName</assert>
      <assert id="UBL-CR-233" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:TaxLevelCode)">[UBL-CR-233]-warning-A UBL invoice should not include the AccountingCustomerParty Party PartyTaxScheme TaxLevelCode</assert>
      <assert id="UBL-CR-234" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReasonCode)">[UBL-CR-234]-warning-A UBL invoice should not include the AccountingCustomerParty Party PartyTaxScheme ExemptionReasonCode</assert>
      <assert id="UBL-CR-235" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReason)">[UBL-CR-235]-warning-A UBL invoice should not include the AccountingCustomerParty Party PartyTaxScheme ExemptionReason</assert>
      <assert id="UBL-CR-236" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:RegistrationAddress)">[UBL-CR-236]-warning-A UBL invoice should not include the AccountingCustomerParty Party PartyTaxScheme RegistrationAddress</assert>
      <assert id="UBL-CR-237" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:Name)">[UBL-CR-237]-warning-A UBL invoice should not include the AccountingCustomerParty Party PartyTaxScheme TaxScheme Name</assert>
      <assert id="UBL-CR-238" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:TaxTypeCode)">[UBL-CR-238]-warning-A UBL invoice should not include the AccountingCustomerParty Party PartyTaxScheme TaxScheme TaxTypeCode</assert>
      <assert id="UBL-CR-239" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:CurrencyCode)">[UBL-CR-239]-warning-A UBL invoice should not include the AccountingCustomerParty Party PartyTaxScheme TaxScheme CurrencyCode</assert>
      <assert id="UBL-CR-240" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cac:JurisdictionRegionAddress)">[UBL-CR-240]-warning-A UBL invoice should not include the AccountingCustomerParty Party PartyTaxScheme TaxScheme JurisdictionRegionAddress</assert>
      <assert id="UBL-CR-241" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationDate)">[UBL-CR-241]-warning-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity RegistrationDate</assert>
      <assert id="UBL-CR-242" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationExpirationDate)">[UBL-CR-242]-warning-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity RegistrationExpirationDate</assert>
      <assert id="UBL-CR-243" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLegalFormCode)">[UBL-CR-243]-warning-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity CompanyLegalFormCode</assert>
      <assert id="UBL-CR-244" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLegalForm)">[UBL-CR-244]-warning-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity CompanyLegalForm</assert>
      <assert id="UBL-CR-245" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:SoleProprietorshipIndicator)">[UBL-CR-245]-warning-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity SoleProprietorshipIndicator</assert>
      <assert id="UBL-CR-246" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLiquidationStatusCode)">[UBL-CR-246]-warning-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity CompanyLiquidationStatusCode</assert>
      <assert id="UBL-CR-247" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CorporateStockAmount)">[UBL-CR-247]-warning-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity CorporationStockAmount</assert>
      <!--<assert id="UBL-CR-247" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CorporationStockAmount)">[UBL-CR-247]-warning-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity CorporationStockAmount</assert>-->
      <assert id="UBL-CR-248" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:FullyPaidSharesIndicator)">[UBL-CR-248]-warning-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity FullyPaidSharesIndicator</assert>
      <assert id="UBL-CR-249" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress)">[UBL-CR-249]-warning-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity RegistrationAddress</assert>
      <assert id="UBL-CR-250" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:CorporateRegistrationScheme)">[UBL-CR-250]-warning-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity CorporateRegistrationScheme</assert>
      <assert id="UBL-CR-251" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:HeadOfficeParty)">[UBL-CR-251]-warning-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity HeadOfficeParty</assert>
      <assert id="UBL-CR-252" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:ShareholderParty)">[UBL-CR-252]-warning-A UBL invoice should not include the AccountingCustomerParty Party PartyLegalEntity ShareholderParty</assert>
      <assert id="UBL-CR-253" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:ID)">[UBL-CR-253]-warning-A UBL invoice should not include the AccountingCustomerParty Party Contact ID</assert>
      <assert id="UBL-CR-254" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Telefax)">[UBL-CR-254]-warning-A UBL invoice should not include the AccountingCustomerParty Party Contact Telefax</assert>
      <assert id="UBL-CR-255" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Note)">[UBL-CR-255]-warning-A UBL invoice should not include the AccountingCustomerParty Party Contact Note</assert>
      <assert id="UBL-CR-256" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cac:OtherCommunication)">[UBL-CR-256]-warning-A UBL invoice should not include the AccountingCustomerParty Party Contact OtherCommunication</assert>
      <assert id="UBL-CR-257" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:Person)">[UBL-CR-257]-warning-A UBL invoice should not include the AccountingCustomerParty Party Person</assert>
      <assert id="UBL-CR-258" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:AgentParty)">[UBL-CR-258]-warning-A UBL invoice should not include the AccountingCustomerParty Party AgentParty</assert>
      <assert id="UBL-CR-259" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:ServiceProviderParty)">[UBL-CR-259]-warning-A UBL invoice should not include the AccountingCustomerParty Party ServiceProviderParty</assert>
      <assert id="UBL-CR-260" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:PowerOfAttorney)">[UBL-CR-260]-warning-A UBL invoice should not include the AccountingCustomerParty Party PowerOfAttorney</assert>
      <assert id="UBL-CR-261" flag="warning" test="not(cac:AccountingCustomerParty/cac:Party/cac:FinancialAccount)">[UBL-CR-261]-warning-A UBL invoice should not include the AccountingCustomerParty Party FinancialAccount</assert>
      <assert id="UBL-CR-262" flag="warning" test="not(cac:AccountingCustomerParty/cac:DeliveryContact)">[UBL-CR-262]-warning-A UBL invoice should not include the AccountingCustomerParty DeliveryContact</assert>
      <assert id="UBL-CR-263" flag="warning" test="not(cac:AccountingCustomerParty/cac:AccountingContact)">[UBL-CR-263]-warning-A UBL invoice should not include the AccountingCustomerParty AccountingContact</assert>
      <assert id="UBL-CR-264" flag="warning" test="not(cac:AccountingCustomerParty/cac:BuyerContact)">[UBL-CR-264]-warning-A UBL invoice should not include the AccountingCustomerParty BuyerContact</assert>
      <assert id="UBL-CR-265" flag="warning" test="not(cac:PayeeParty/cbc:MarkCareIndicator)">[UBL-CR-265]-warning-A UBL invoice should not include the PayeeParty MarkCareIndicator</assert>
      <assert id="UBL-CR-266" flag="warning" test="not(cac:PayeeParty/cbc:MarkAttentionIndicator)">[UBL-CR-266]-warning-A UBL invoice should not include the PayeeParty MarkAttentionIndicator</assert>
      <assert id="UBL-CR-267" flag="warning" test="not(cac:PayeeParty/cbc:WebsiteURI)">[UBL-CR-267]-warning-A UBL invoice should not include the PayeeParty WebsiteURI</assert>
      <assert id="UBL-CR-268" flag="warning" test="not(cac:PayeeParty/cbc:LogoReferenceID)">[UBL-CR-268]-warning-A UBL invoice should not include the PayeeParty LogoReferenceID</assert>
      <assert id="UBL-CR-269" flag="warning" test="not(cac:PayeeParty/cbc:EndpointID)">[UBL-CR-269]-warning-A UBL invoice should not include the PayeeParty EndpointID</assert>
      <assert id="UBL-CR-270" flag="warning" test="not(cac:PayeeParty/cbc:IndustryClassificationCode)">[UBL-CR-270]-warning-A UBL invoice should not include the PayeeParty IndustryClassificationCode</assert>
      <assert id="UBL-CR-271" flag="warning" test="not(cac:PayeeParty/cac:Language)">[UBL-CR-271]-warning-A UBL invoice should not include the PayeeParty Language</assert>
      <assert id="UBL-CR-272" flag="warning" test="not(cac:PayeeParty/cac:PostalAddress)">[UBL-CR-272]-warning-A UBL invoice should not include the PayeeParty PostalAddress</assert>
      <assert id="UBL-CR-273" flag="warning" test="not(cac:PayeeParty/cac:PhysicalLocation)">[UBL-CR-273]-warning-A UBL invoice should not include the PayeeParty PhysicalLocation</assert>
      <assert id="UBL-CR-274" flag="warning" test="not(cac:PayeeParty/cac:PartyTaxScheme)">[UBL-CR-274]-warning-A UBL invoice should not include the PayeeParty PartyTaxScheme</assert>
      <assert id="UBL-CR-275" flag="warning" test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:RegistrationName)">[UBL-CR-275]-warning-A UBL invoice should not include the PayeeParty PartyLegalEntity RegistrationName</assert>
      <assert id="UBL-CR-276" flag="warning" test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:RegistrationDate)">[UBL-CR-276]-warning-A UBL invoice should not include the PayeeParty PartyLegalEntity RegistrationDate</assert>
      <assert id="UBL-CR-277" flag="warning" test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:RegistrationExpirationDate)">[UBL-CR-277]-warning-A UBL invoice should not include the PayeeParty PartyLegalEntity RegistrationExpirationDate</assert>
      <assert id="UBL-CR-278" flag="warning" test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:CompanyLegalFormCode)">[UBL-CR-278]-warning-A UBL invoice should not include the PayeeParty PartyLegalEntity CompanyLegalFormCode</assert>
      <assert id="UBL-CR-279" flag="warning" test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:CompanyLegalForm)">[UBL-CR-279]-warning-A UBL invoice should not include the PayeeParty PartyLegalEntity CompanyLegalForm</assert>
      <assert id="UBL-CR-280" flag="warning" test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:SoleProprietorshipIndicator)">[UBL-CR-280]-warning-A UBL invoice should not include the PayeeParty PartyLegalEntity SoleProprietorshipIndicator</assert>
      <assert id="UBL-CR-281" flag="warning" test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:CompanyLiquidationStatusCode)">[UBL-CR-281]-warning-A UBL invoice should not include the PayeeParty PartyLegalEntity CompanyLiquidationStatusCode</assert>
      <assert id="UBL-CR-282" flag="warning" test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:CorporateStockAmount)">[UBL-CR-282]-warning-A UBL invoice should not include the PayeeParty PartyLegalEntity CorporationStockAmount</assert>
      <!--<assert id="UBL-CR-282" flag="warning" test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:CorporationStockAmount)">[UBL-CR-282]-warning-A UBL invoice should not include the PayeeParty PartyLegalEntity CorporationStockAmount</assert>-->
      <assert id="UBL-CR-283" flag="warning" test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:FullyPaidSharesIndicator)">[UBL-CR-283]-warning-A UBL invoice should not include the PayeeParty PartyLegalEntity FullyPaidSharesIndicator</assert>
      <assert id="UBL-CR-284" flag="warning" test="not(cac:PayeeParty/cac:PartyLegalEntity/cac:RegistrationAddress)">[UBL-CR-284]-warning-A UBL invoice should not include the PayeeParty PartyLegalEntity RegistrationAddress</assert>
      <assert id="UBL-CR-285" flag="warning" test="not(cac:PayeeParty/cac:PartyLegalEntity/cac:CorporateRegistrationScheme)">[UBL-CR-285]-warning-A UBL invoice should not include the PayeeParty PartyLegalEntity CorporateRegistrationScheme</assert>
      <assert id="UBL-CR-286" flag="warning" test="not(cac:PayeeParty/cac:PartyLegalEntity/cac:HeadOfficeParty)">[UBL-CR-286]-warning-A UBL invoice should not include the PayeeParty PartyLegalEntity HeadOfficeParty</assert>
      <assert id="UBL-CR-287" flag="warning" test="not(cac:PayeeParty/cac:PartyLegalEntity/cac:ShareholderParty)">[UBL-CR-287]-warning-A UBL invoice should not include the PayeeParty PartyLegalEntity ShareholderParty</assert>
      <assert id="UBL-CR-288" flag="warning" test="not(cac:PayeeParty/cac:Contact)">[UBL-CR-288]-warning-A UBL invoice should not include the PayeeParty Contact</assert>
      <assert id="UBL-CR-289" flag="warning" test="not(cac:PayeeParty/cac:Person)">[UBL-CR-289]-warning-A UBL invoice should not include the PayeeParty Person</assert>
      <assert id="UBL-CR-290" flag="warning" test="not(cac:PayeeParty/cac:AgentParty)">[UBL-CR-290]-warning-A UBL invoice should not include the PayeeParty AgentParty</assert>
      <assert id="UBL-CR-291" flag="warning" test="not(cac:PayeeParty/cac:ServiceProviderParty)">[UBL-CR-291]-warning-A UBL invoice should not include the PayeeParty ServiceProviderParty</assert>
      <assert id="UBL-CR-292" flag="warning" test="not(cac:PayeeParty/cac:PowerOfAttorney)">[UBL-CR-292]-warning-A UBL invoice should not include the PayeeParty PowerOfAttorney</assert>
      <assert id="UBL-CR-293" flag="warning" test="not(cac:PayeeParty/cac:FinancialAccount)">[UBL-CR-293]-warning-A UBL invoice should not include the PayeeParty FinancialAccount</assert>
      <assert id="UBL-CR-294" flag="warning" test="not(cac:BuyerCustomerParty)">[UBL-CR-294]-warning-A UBL invoice should not include the BuyerCustomerParty</assert>
      <assert id="UBL-CR-295" flag="warning" test="not(cac:SellerSupplierParty)">[UBL-CR-295]-warning-A UBL invoice should not include the SellerSupplierParty</assert>
      <assert id="UBL-CR-296" flag="warning" test="not(cac:TaxRepresentativeParty/cbc:MarkCareIndicator)">[UBL-CR-296]-warning-A UBL invoice should not include the TaxRepresentativeParty MarkCareIndicator</assert>
      <assert id="UBL-CR-297" flag="warning" test="not(cac:TaxRepresentativeParty/cbc:MarkAttentionIndicator)">[UBL-CR-297]-warning-A UBL invoice should not include the TaxRepresentativeParty MarkAttentionIndicator</assert>
      <assert id="UBL-CR-298" flag="warning" test="not(cac:TaxRepresentativeParty/cbc:WebsiteURI)">[UBL-CR-298]-warning-A UBL invoice should not include the TaxRepresentativeParty WebsiteURI</assert>
      <assert id="UBL-CR-299" flag="warning" test="not(cac:TaxRepresentativeParty/cbc:LogoReferenceID)">[UBL-CR-299]-warning-A UBL invoice should not include the TaxRepresentativeParty LogoReferenceID</assert>
      <assert id="UBL-CR-300" flag="warning" test="not(cac:TaxRepresentativeParty/cbc:EndpointID)">[UBL-CR-300]-warning-A UBL invoice should not include the TaxRepresentativeParty EndpointID</assert>
      <assert id="UBL-CR-301" flag="warning" test="not(cac:TaxRepresentativeParty/cbc:IndustryClassificationCode)">[UBL-CR-301]-warning-A UBL invoice should not include the TaxRepresentativeParty IndustryClassificationCode</assert>
      <assert id="UBL-CR-302" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PartyIdentification)">[UBL-CR-302]-warning-A UBL invoice should not include the TaxRepresentativeParty PartyIdentification</assert>
      <assert id="UBL-CR-303" flag="warning" test="not(cac:TaxRepresentativeParty/cac:Language)">[UBL-CR-303]-warning-A UBL invoice should not include the TaxRepresentativeParty Language</assert>
      <assert id="UBL-CR-304" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:ID)">[UBL-CR-304]-warning-A UBL invoice should not include the TaxRepresentativeParty PostalAddress ID</assert>
      <assert id="UBL-CR-305" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:AddressTypeCode)">[UBL-CR-305]-warning-A UBL invoice should not include the TaxRepresentativeParty PostalAddress AddressTypeCode</assert>
      <assert id="UBL-CR-306" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:AddressFormatCode)">[UBL-CR-306]-warning-A UBL invoice should not include the TaxRepresentativeParty PostalAddress AddressFormatCode</assert>
      <assert id="UBL-CR-307" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:Postbox)">[UBL-CR-307]-warning-A UBL invoice should not include the TaxRepresentativeParty PostalAddress Postbox</assert>
      <assert id="UBL-CR-308" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:Floor)">[UBL-CR-308]-warning-A UBL invoice should not include the TaxRepresentativeParty PostalAddress Floor</assert>
      <assert id="UBL-CR-309" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:Room)">[UBL-CR-309]-warning-A UBL invoice should not include the TaxRepresentativeParty PostalAddress Room</assert>
      <assert id="UBL-CR-310" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:BlockName)">[UBL-CR-310]-warning-A UBL invoice should not include the TaxRepresentativeParty PostalAddress BlockName</assert>
      <assert id="UBL-CR-311" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:BuildingName)">[UBL-CR-311]-warning-A UBL invoice should not include the TaxRepresentativeParty PostalAddress BuildingName</assert>
      <assert id="UBL-CR-312" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:BuildingNumber)">[UBL-CR-312]-warning-A UBL invoice should not include the TaxRepresentativeParty PostalAddress BuildingNumber</assert>
      <assert id="UBL-CR-313" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:InhouseMail)">[UBL-CR-313]-warning-A UBL invoice should not include the TaxRepresentativeParty PostalAddress InhouseMail</assert>
      <assert id="UBL-CR-314" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:Department)">[UBL-CR-314]-warning-A UBL invoice should not include the TaxRepresentativeParty PostalAddress Department</assert>
      <assert id="UBL-CR-315" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:MarkAttention)">[UBL-CR-315]-warning-A UBL invoice should not include the TaxRepresentativeParty PostalAddress MarkAttention</assert>
      <assert id="UBL-CR-316" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:MarkCare)">[UBL-CR-316]-warning-A UBL invoice should not include the TaxRepresentativeParty PostalAddress MarkCare</assert>
      <assert id="UBL-CR-317" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:PlotIdentification)">[UBL-CR-317]-warning-A UBL invoice should not include the TaxRepresentativeParty PostalAddress PlotIdentification</assert>
      <assert id="UBL-CR-318" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:CitySubdivisionName)">[UBL-CR-318]-warning-A UBL invoice should not include the TaxRepresentativeParty PostalAddress CitySubdivisionName</assert>
      <assert id="UBL-CR-319" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:CountrySubentityCode)">[UBL-CR-319]-warning-A UBL invoice should not include the TaxRepresentativeParty PostalAddress CountrySubentityCode</assert>
      <assert id="UBL-CR-320" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:Region)">[UBL-CR-320]-warning-A UBL invoice should not include the TaxRepresentativeParty PostalAddress Region</assert>
      <assert id="UBL-CR-321" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:District)">[UBL-CR-321]-warning-A UBL invoice should not include the TaxRepresentativeParty PostalAddress District</assert>
      <assert id="UBL-CR-322" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:TimezoneOffset)">[UBL-CR-322]-warning-A UBL invoice should not include the TaxRepresentativeParty PostalAddress TimezoneOffset</assert>
      <assert id="UBL-CR-323" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cac:Country/cbc:Name)">[UBL-CR-323]-warning-A UBL invoice should not include the TaxRepresentativeParty PostalAddress Country Name</assert>
      <assert id="UBL-CR-324" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PostalAddress/cac:LocationCoordinate)">[UBL-CR-324]-warning-A UBL invoice should not include the TaxRepresentativeParty PostalAddress LocationCoordinate</assert>
      <assert id="UBL-CR-325" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PhysicalLocation)">[UBL-CR-325]-warning-A UBL invoice should not include the TaxRepresentativeParty PhysicalLocation</assert>
      <assert id="UBL-CR-326" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cbc:RegistrationName)">[UBL-CR-326]-warning-A UBL invoice should not include the TaxRepresentativeParty PartyTaxScheme RegistrationName</assert>
      <assert id="UBL-CR-327" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cbc:TaxLevelCode)">[UBL-CR-327]-warning-A UBL invoice should not include the TaxRepresentativeParty PartyTaxScheme TaxLevelCode</assert>
      <assert id="UBL-CR-328" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cbc:ExemptionReasonCode)">[UBL-CR-328]-warning-A UBL invoice should not include the TaxRepresentativeParty PartyTaxScheme ExemptionReasonCode</assert>
      <assert id="UBL-CR-329" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cbc:ExemptionReason)">[UBL-CR-329]-warning-A UBL invoice should not include the TaxRepresentativeParty PartyTaxScheme ExemptionReason</assert>
      <assert id="UBL-CR-330" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:RegistrationAddress)">[UBL-CR-330]-warning-A UBL invoice should not include the TaxRepresentativeParty PartyTaxScheme RegistrationAddress</assert>
      <assert id="UBL-CR-331" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:Name)">[UBL-CR-331]-warning-A UBL invoice should not include the TaxRepresentativeParty PartyTaxScheme TaxScheme Name</assert>
      <assert id="UBL-CR-332" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:TaxTypeCode)">[UBL-CR-332]-warning-A UBL invoice should not include the TaxRepresentativeParty PartyTaxScheme TaxScheme TaxTypeCode</assert>
      <assert id="UBL-CR-333" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:CurrencyCode)">[UBL-CR-333]-warning-A UBL invoice should not include the TaxRepresentativeParty PartyTaxScheme TaxScheme CurrencyCode</assert>
      <assert id="UBL-CR-334" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:TaxScheme/cac:JurisdictionRegionAddress)">[UBL-CR-334]-warning-A UBL invoice should not include the TaxRepresentativeParty PartyTaxScheme TaxScheme JurisdictionRegionAddress</assert>
      <assert id="UBL-CR-335" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PartyLegalEntity)">[UBL-CR-335]-warning-A UBL invoice should not include the TaxRepresentativeParty PartyLegalEntity</assert>
      <assert id="UBL-CR-336" flag="warning" test="not(cac:TaxRepresentativeParty/cac:Contact)">[UBL-CR-336]-warning-A UBL invoice should not include the TaxRepresentativeParty Contact</assert>
      <assert id="UBL-CR-337" flag="warning" test="not(cac:TaxRepresentativeParty/cac:Person)">[UBL-CR-337]-warning-A UBL invoice should not include the TaxRepresentativeParty Person</assert>
      <assert id="UBL-CR-338" flag="warning" test="not(cac:TaxRepresentativeParty/cac:AgentParty)">[UBL-CR-338]-warning-A UBL invoice should not include the TaxRepresentativeParty AgentParty</assert>
      <assert id="UBL-CR-339" flag="warning" test="not(cac:TaxRepresentativeParty/cac:ServiceProviderParty)">[UBL-CR-339]-warning-A UBL invoice should not include the TaxRepresentativeParty ServiceProviderParty</assert>
      <assert id="UBL-CR-340" flag="warning" test="not(cac:TaxRepresentativeParty/cac:PowerOfAttorney)">[UBL-CR-340]-warning-A UBL invoice should not include the TaxRepresentativeParty PowerOfAttorney</assert>
      <assert id="UBL-CR-341" flag="warning" test="not(cac:TaxRepresentativeParty/cac:FinancialAccount)">[UBL-CR-341]-warning-A UBL invoice should not include the TaxRepresentativeParty FinancialAccount</assert>
      <assert id="UBL-CR-342" flag="warning" test="not(cac:Delivery/cbc:ID)">[UBL-CR-342]-warning-A UBL invoice should not include the Delivery ID</assert>
      <assert id="UBL-CR-343" flag="warning" test="not(cac:Delivery/cbc:Quantity)">[UBL-CR-343]-warning-A UBL invoice should not include the Delivery Quantity</assert>
      <assert id="UBL-CR-344" flag="warning" test="not(cac:Delivery/cbc:MinimumQuantity)">[UBL-CR-344]-warning-A UBL invoice should not include the Delivery MinimumQuantity</assert>
      <assert id="UBL-CR-345" flag="warning" test="not(cac:Delivery/cbc:MaximumQuantity)">[UBL-CR-345]-warning-A UBL invoice should not include the Delivery MaximumQuantity</assert>
      <assert id="UBL-CR-346" flag="warning" test="not(cac:Delivery/cbc:ActualDeliveryTime)">[UBL-CR-346]-warning-A UBL invoice should not include the Delivery ActualDeliveryTime</assert>
      <assert id="UBL-CR-347" flag="warning" test="not(cac:Delivery/cbc:LatestDeliveryDate)">[UBL-CR-347]-warning-A UBL invoice should not include the Delivery LatestDeliveryDate</assert>
      <assert id="UBL-CR-348" flag="warning" test="not(cac:Delivery/cbc:LatestDeliveryTime)">[UBL-CR-348]-warning-A UBL invoice should not include the Delivery LatestDeliveryTime</assert>
      <assert id="UBL-CR-349" flag="warning" test="not(cac:Delivery/cbc:ReleaseID)">[UBL-CR-349]-warning-A UBL invoice should not include the Delivery ReleaseID</assert>
      <assert id="UBL-CR-350" flag="warning" test="not(cac:Delivery/cbc:TrackingID)">[UBL-CR-350]-warning-A UBL invoice should not include the Delivery TrackingID</assert>
      <assert id="UBL-CR-351" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cbc:Description)">[UBL-CR-351]-warning-A UBL invoice should not include the Delivery DeliveryLocation Description</assert>
      <assert id="UBL-CR-352" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cbc:Conditions)">[UBL-CR-352]-warning-A UBL invoice should not include the Delivery DeliveryLocation Conditions</assert>
      <assert id="UBL-CR-353" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentity)">[UBL-CR-353]-warning-A UBL invoice should not include the Delivery DeliveryLocation CountrySubentity</assert>
      <assert id="UBL-CR-354" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentityCode)">[UBL-CR-354]-warning-A UBL invoice should not include the Delivery DeliveryLocation CountrySubentityCode</assert>
      <assert id="UBL-CR-355" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cbc:LocationTypeCode)">[UBL-CR-355]-warning-A UBL invoice should not include the Delivery DeliveryLocation LocationTypeCode</assert>
      <assert id="UBL-CR-356" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cbc:InformationURI)">[UBL-CR-356]-warning-A UBL invoice should not include the Delivery DeliveryLocation InformationURI</assert>
      <assert id="UBL-CR-357" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cbc:Name)">[UBL-CR-357]-warning-A UBL invoice should not include the Delivery DeliveryLocation Name</assert>
      <assert id="UBL-CR-358" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:ValidityPeriod)">[UBL-CR-358]-warning-A UBL invoice should not include the Delivery DeliveryLocation ValidationPeriod</assert>
      <!--assert id="UBL-CR-358" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:ValidationPeriod)">[UBL-CR-358]-warning-A UBL invoice should not include the Delivery DeliveryLocation ValidationPeriod</assert>-->
      <assert id="UBL-CR-359" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:ID)">[UBL-CR-359]-warning-A UBL invoice should not include the Delivery DeliveryLocation Address ID</assert>
      <assert id="UBL-CR-360" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AddressTypeCode)">[UBL-CR-360]-warning-A UBL invoice should not include the Delivery DeliveryLocation Address AddressTypeCode</assert>
      <assert id="UBL-CR-361" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AddressFormatCode)">[UBL-CR-361]-warning-A UBL invoice should not include the Delivery DeliveryLocation Address AddressFormatCode</assert>
      <assert id="UBL-CR-362" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Postbox)">[UBL-CR-362]-warning-A UBL invoice should not include the Delivery DeliveryLocation Address Postbox</assert>
      <assert id="UBL-CR-363" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Floor)">[UBL-CR-363]-warning-A UBL invoice should not include the Delivery DeliveryLocation Address Floor</assert>
      <assert id="UBL-CR-364" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Room)">[UBL-CR-364]-warning-A UBL invoice should not include the Delivery DeliveryLocation Address Room</assert>
      <assert id="UBL-CR-365" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:BlockName)">[UBL-CR-365]-warning-A UBL invoice should not include the Delivery DeliveryLocation Address BlockName</assert>
      <assert id="UBL-CR-366" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:BuildingName)">[UBL-CR-366]-warning-A UBL invoice should not include the Delivery DeliveryLocation Address BuildingName</assert>
      <assert id="UBL-CR-367" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:BuildingNumber)">[UBL-CR-367]-warning-A UBL invoice should not include the Delivery DeliveryLocation Address BuildingNumber</assert>
      <assert id="UBL-CR-368" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:InhouseMail)">[UBL-CR-368]-warning-A UBL invoice should not include the Delivery DeliveryLocation Address InhouseMail</assert>
      <assert id="UBL-CR-369" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Department)">[UBL-CR-369]-warning-A UBL invoice should not include the Delivery DeliveryLocation Address Department</assert>
      <assert id="UBL-CR-370" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:MarkAttention)">[UBL-CR-370]-warning-A UBL invoice should not include the Delivery DeliveryLocation Address MarkAttention</assert>
      <assert id="UBL-CR-371" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:MarkCare)">[UBL-CR-371]-warning-A UBL invoice should not include the Delivery DeliveryLocation Address MarkCare</assert>
      <assert id="UBL-CR-372" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PlotIdentification)">[UBL-CR-372]-warning-A UBL invoice should not include the Delivery DeliveryLocation Address PlotIdentification</assert>
      <assert id="UBL-CR-373" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CitySubdivisionName)">[UBL-CR-373]-warning-A UBL invoice should not include the Delivery DeliveryLocation Address CitySubdivisionName</assert>
      <assert id="UBL-CR-374" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CountrySubentityCode)">[UBL-CR-374]-warning-A UBL invoice should not include the Delivery DeliveryLocation Address CountrySubentityCode</assert>
      <assert id="UBL-CR-375" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Region)">[UBL-CR-375]-warning-A UBL invoice should not include the Delivery DeliveryLocation Address Region</assert>
      <assert id="UBL-CR-376" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:District)">[UBL-CR-376]-warning-A UBL invoice should not include the Delivery DeliveryLocation Address District</assert>
      <assert id="UBL-CR-377" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:TimezoneOffset)">[UBL-CR-377]-warning-A UBL invoice should not include the Delivery DeliveryLocation Address TimezoneOffset</assert>
      <assert id="UBL-CR-378" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:Name)">[UBL-CR-378]-warning-A UBL invoice should not include the Delivery DeliveryLocation Address Country Name</assert>
      <assert id="UBL-CR-379" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:LocationCoordinate)">[UBL-CR-379]-warning-A UBL invoice should not include the Delivery DeliveryLocation Address LocationCoordinate</assert>
      <assert id="UBL-CR-380" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:SubsidiaryLocation)">[UBL-CR-380]-warning-A UBL invoice should not include the Delivery DeliveryLocation SubsidiaryLocation</assert>
      <assert id="UBL-CR-381" flag="warning" test="not(cac:Delivery/cac:DeliveryLocation/cac:LocationCoordinate)">[UBL-CR-381]-warning-A UBL invoice should not include the Delivery DeliveryLocation LocationCoordinate</assert>
      <assert id="UBL-CR-382" flag="warning" test="not(cac:Delivery/cac:AlternativeDeliveryLocation)">[UBL-CR-382]-warning-A UBL invoice should not include the Delivery AlternativeDeliveryLocation</assert>
      <assert id="UBL-CR-383" flag="warning" test="not(cac:Delivery/cac:RequestedDeliveryPeriod)">[UBL-CR-383]-warning-A UBL invoice should not include the Delivery RequestedDeliveryPeriod</assert>
      <assert id="UBL-CR-384" flag="warning" test="not(cac:Delivery/cac:EstimatedDeliveryPeriod)">[UBL-CR-384]-warning-A UBL invoice should not include the Delivery PromisedDeliveryPeriod</assert>
      <!--<assert id="UBL-CR-384" flag="warning" test="not(cac:Delivery/cac:PromisedDeliveryPeriod)">[UBL-CR-384]-warning-A UBL invoice should not include the Delivery PromisedDeliveryPeriod</assert>-->
      <assert id="UBL-CR-385" flag="warning" test="not(cac:Delivery/cac:CarrierParty)">[UBL-CR-385]-warning-A UBL invoice should not include the Delivery CarrierParty</assert>
      <assert id="UBL-CR-386" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cbc:MarkCareIndicator)">[UBL-CR-386]-warning-A UBL invoice should not include the DeliveryParty MarkCareIndicator</assert>
      <assert id="UBL-CR-387" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cbc:MarkAttentionIndicator)">[UBL-CR-387]-warning-A UBL invoice should not include the DeliveryParty MarkAttentionIndicator</assert>
      <assert id="UBL-CR-388" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cbc:WebsiteURI)">[UBL-CR-388]-warning-A UBL invoice should not include the DeliveryParty WebsiteURI</assert>
      <assert id="UBL-CR-389" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cbc:LogoReferenceID)">[UBL-CR-389]-warning-A UBL invoice should not include the DeliveryParty LogoReferenceID</assert>
      <assert id="UBL-CR-390" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cbc:EndpointID)">[UBL-CR-390]-warning-A UBL invoice should not include the DeliveryParty EndpointID</assert>
      <assert id="UBL-CR-391" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cbc:IndustryClassificationCode)">[UBL-CR-391]-warning-A UBL invoice should not include the DeliveryParty IndustryClassificationCode</assert>
      <assert id="UBL-CR-392" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cac:PartyIdentification)">[UBL-CR-392]-warning-A UBL invoice should not include the DeliveryParty PartyIdentification</assert>
      <assert id="UBL-CR-393" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cac:Language)">[UBL-CR-393]-warning-A UBL invoice should not include the DeliveryParty Language</assert>
      <assert id="UBL-CR-394" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cac:PostalAddress)">[UBL-CR-394]-warning-A UBL invoice should not include the DeliveryParty PostalAddress</assert>
      <assert id="UBL-CR-395" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cac:PhysicalLocation)">[UBL-CR-395]-warning-A UBL invoice should not include the DeliveryParty PhysicalLocation</assert>
      <assert id="UBL-CR-396" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cac:PartyTaxScheme)">[UBL-CR-396]-warning-A UBL invoice should not include the DeliveryParty PartyTaxScheme</assert>
      <assert id="UBL-CR-397" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cac:PartyLegalEntity)">[UBL-CR-397]-warning-A UBL invoice should not include the DeliveryParty PartyLegalEntity</assert>
      <assert id="UBL-CR-398" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cac:Contact)">[UBL-CR-398]-warning-A UBL invoice should not include the DeliveryParty Contact</assert>
      <assert id="UBL-CR-399" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cac:Person)">[UBL-CR-399]-warning-A UBL invoice should not include the DeliveryParty Person</assert>
      <assert id="UBL-CR-400" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cac:AgentParty)">[UBL-CR-400]-warning-A UBL invoice should not include the DeliveryParty AgentParty</assert>
      <assert id="UBL-CR-401" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cac:ServiceProviderParty)">[UBL-CR-401]-warning-A UBL invoice should not include the DeliveryParty ServiceProviderParty</assert>
      <assert id="UBL-CR-402" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cac:PowerOfAttorney)">[UBL-CR-402]-warning-A UBL invoice should not include the DeliveryParty PowerOfAttorney</assert>
      <assert id="UBL-CR-403" flag="warning" test="not(cac:Delivery/cac:DeliveryParty/cac:FinancialAccount)">[UBL-CR-403]-warning-A UBL invoice should not include the DeliveryParty FinancialAccount</assert>
      <assert id="UBL-CR-404" flag="warning" test="not(cac:Delivery/cac:NotifyParty)">[UBL-CR-404]-warning-A UBL invoice should not include the Delivery NotifyParty</assert>
      <assert id="UBL-CR-405" flag="warning" test="not(cac:Delivery/cac:Despatch)">[UBL-CR-405]-warning-A UBL invoice should not include the Delivery Despatch</assert>
      <assert id="UBL-CR-406" flag="warning" test="not(cac:Delivery/cac:DeliveryTerms)">[UBL-CR-406]-warning-A UBL invoice should not include the Delivery DeliveryTerms</assert>
      <assert id="UBL-CR-407" flag="warning" test="not(cac:Delivery/cac:MinimumDeliveryUnit)">[UBL-CR-407]-warning-A UBL invoice should not include the Delivery MinimumDeliveryUnit</assert>
      <assert id="UBL-CR-408" flag="warning" test="not(cac:Delivery/cac:MaximumDeliveryUnit)">[UBL-CR-408]-warning-A UBL invoice should not include the Delivery MaximumDeliveryUnit</assert>
      <assert id="UBL-CR-409" flag="warning" test="not(cac:Delivery/cac:Shipment)">[UBL-CR-409]-warning-A UBL invoice should not include the Delivery Shipment</assert>
      <assert id="UBL-CR-410" flag="warning" test="not(cac:DeliveryTerms)">[UBL-CR-410]-warning-A UBL invoice should not include the DeliveryTerms</assert>
      <assert id="UBL-CR-411" flag="warning" test="not(cac:PaymentMeans/cbc:ID)">[UBL-CR-411]-warning-A UBL invoice should not include the PaymentMeans ID</assert>
      <assert id="UBL-CR-412" flag="warning" test="not(cac:PaymentMeans/cbc:PaymentDueDate) or ../cn:CreditNote">[UBL-CR-412]-warning-A UBL invoice should not include the PaymentMeans PaymentDueDate</assert>
      <assert id="UBL-CR-413" flag="warning" test="not(cac:PaymentMeans/cbc:PaymentChannelCode)">[UBL-CR-413]-warning-A UBL invoice should not include the PaymentMeans PaymentChannelCode</assert>
      <assert id="UBL-CR-414" flag="warning" test="not(cac:PaymentMeans/cbc:InstructionNote)">[UBL-CR-414]-warning-A UBL invoice should not include the PaymentMeans InstructionNote</assert>
      <!--<assert id="UBL-CR-414" flag="warning" test="not(cac:PaymentMeans/cbc:InstructionID)">[UBL-CR-414]-warning-A UBL invoice should not include the PaymentMeans InstructionID</assert>-->
      <assert id="UBL-CR-415" flag="warning" test="not(cac:PaymentMeans/cac:CardAccount/cbc:CardTypeCode)">[UBL-CR-415]-warning-A UBL invoice should not include the PaymentMeans CardAccount CardTypeCode</assert>
      <assert id="UBL-CR-416" flag="warning" test="not(cac:PaymentMeans/cac:CardAccount/cbc:ValidityStartDate)">[UBL-CR-416]-warning-A UBL invoice should not include the PaymentMeans CardAccount ValidityStartDate</assert>
      <assert id="UBL-CR-417" flag="warning" test="not(cac:PaymentMeans/cac:CardAccount/cbc:ExpiryDate)">[UBL-CR-417]-warning-A UBL invoice should not include the PaymentMeans CardAccount ExpiryDate</assert>
      <assert id="UBL-CR-418" flag="warning" test="not(cac:PaymentMeans/cac:CardAccount/cbc:IssuerID)">[UBL-CR-418]-warning-A UBL invoice should not include the PaymentMeans CardAccount IssuerID</assert>
      <assert id="UBL-CR-419" flag="warning" test="not(cac:PaymentMeans/cac:CardAccount/cbc:IssueNumberID)">[UBL-CR-419]-warning-A UBL invoice should not include the PaymentMeans CardAccount IssueNumberID</assert>
      <!--<assert id="UBL-CR-419" flag="warning" test="not(cac:PaymentMeans/cac:CardAccount/cbc:IssuerNumberID)">[UBL-CR-419]-warning-A UBL invoice should not include the PaymentMeans CardAccount IssuerNumberID</assert>-->
      <assert id="UBL-CR-420" flag="warning" test="not(cac:PaymentMeans/cac:CardAccount/cbc:CV2ID)">[UBL-CR-420]-warning-A UBL invoice should not include the PaymentMeans CardAccount CV2ID</assert>
      <assert id="UBL-CR-421" flag="warning" test="not(cac:PaymentMeans/cac:CardAccount/cbc:CardChipCode)">[UBL-CR-421]-warning-A UBL invoice should not include the PaymentMeans CardAccount CardChipCode</assert>
      <assert id="UBL-CR-422" flag="warning" test="not(cac:PaymentMeans/cac:CardAccount/cbc:ChipApplicationID)">[UBL-CR-422]-warning-A UBL invoice should not include the PaymentMeans CardAccount ChipApplicationID</assert>
      <assert id="UBL-CR-424" flag="warning" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:AliasName)">[UBL-CR-424]-warning-A UBL invoice should not include the PaymentMeans PayeeFinancialAccount AliasName</assert>
      <assert id="UBL-CR-425" flag="warning" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:AccountTypeCode)">[UBL-CR-425]-warning-A UBL invoice should not include the PaymentMeans PayeeFinancialAccount AccountTypeCode</assert>
      <assert id="UBL-CR-426" flag="warning" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:AccountFormatCode)">[UBL-CR-426]-warning-A UBL invoice should not include the PaymentMeans PayeeFinancialAccount AccountFormatCode</assert>
      <assert id="UBL-CR-427" flag="warning" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:CurrencyCode)">[UBL-CR-427]-warning-A UBL invoice should not include the PaymentMeans PayeeFinancialAccount CurrencyCode</assert>
      <assert id="UBL-CR-428" flag="warning" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:PaymentNote)">[UBL-CR-428]-warning-A UBL invoice should not include the PaymentMeans PayeeFinancialAccount PaymentNote</assert>
      <assert id="UBL-CR-429" flag="warning" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:Name)">[UBL-CR-429]-warning-A UBL invoice should not include the PaymentMeans PayeeFinancialAccount FinancialInstitutionBranch Name</assert>
      <assert id="UBL-CR-430" flag="warning" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:Name)">[UBL-CR-430]-warning-A UBL invoice should not include the PaymentMeans PayeeFinancialAccount FinancialInstitutionBranch FinancialInstitution Name</assert>
      <assert id="UBL-CR-431" flag="warning" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cac:Address)">[UBL-CR-431]-warning-A UBL invoice should not include the PaymentMeans PayeeFinancialAccount FinancialInstitutionBranch FinancialInstitution Address</assert>
      <assert id="UBL-CR-432" flag="warning" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:Address)">[UBL-CR-432]-warning-A UBL invoice should not include the PaymentMeans PayeeFinancialAccount FinancialInstitutionBranch Address</assert>
      <assert id="UBL-CR-433" flag="warning" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:Country)">[UBL-CR-433]-warning-A UBL invoice should not include the PaymentMeans PayeeFinancialAccount Country</assert>
      <assert id="UBL-CR-434" flag="warning" test="not(cac:PaymentMeans/cac:CreditAccount)">[UBL-CR-434]-warning-A UBL invoice should not include the PaymentMeans CreditAccount</assert>
      <assert id="UBL-CR-435" flag="warning" test="not(cac:PaymentMeans/cac:PaymentMandate/cbc:MandateTypeCode)">[UBL-CR-435]-warning-A UBL invoice should not include the PaymentMeans PaymentMandate MandateTypeCode</assert>
      <assert id="UBL-CR-436" flag="warning" test="not(cac:PaymentMeans/cac:PaymentMandate/cbc:MaximumPaymentInstructionsNumeric)">[UBL-CR-436]-warning-A UBL invoice should not include the PaymentMeans PaymentMandate MaximumPaymentInstructionsNumeric</assert>
      <assert id="UBL-CR-437" flag="warning" test="not(cac:PaymentMeans/cac:PaymentMandate/cbc:MaximumPaidAmount)">[UBL-CR-437]-warning-A UBL invoice should not include the PaymentMeans PaymentMandate MaximumPaidAmount</assert>
      <assert id="UBL-CR-438" flag="warning" test="not(cac:PaymentMeans/cac:PaymentMandate/cbc:SignatureID)">[UBL-CR-438]-warning-A UBL invoice should not include the PaymentMeans PaymentMandate SignatureID</assert>
      <assert id="UBL-CR-439" flag="warning" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerParty)">[UBL-CR-439]-warning-A UBL invoice should not include the PaymentMeans PaymentMandate PayerParty</assert>
      <assert id="UBL-CR-440" flag="warning" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:Name)">[UBL-CR-440]-warning-A UBL invoice should not include the PaymentMeans PaymentMandate PayerFinancialAccount Name</assert>
      <assert id="UBL-CR-441" flag="warning" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:AliasName)">[UBL-CR-441]-warning-A UBL invoice should not include the PaymentMeans PaymentMandate PayerFinancialAccount AliasName</assert>
      <assert id="UBL-CR-442" flag="warning" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:AccountTypeCode)">[UBL-CR-442]-warning-A UBL invoice should not include the PaymentMeans PaymentMandate PayerFinancialAccount AccountTypeCode</assert>
      <assert id="UBL-CR-443" flag="warning" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:AccountFormatCode)">[UBL-CR-443]-warning-A UBL invoice should not include the PaymentMeans PaymentMandate PayerFinancialAccount AccountFormatCode</assert>
      <assert id="UBL-CR-444" flag="warning" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:CurrencyCode)">[UBL-CR-444]-warning-A UBL invoice should not include the PaymentMeans PaymentMandate PayerFinancialAccount CurrencyCode</assert>
      <assert id="UBL-CR-445" flag="warning" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:PaymentNote)">[UBL-CR-445]-warning-A UBL invoice should not include the PaymentMeans PaymentMandate PayerFinancialAccount PaymentNote</assert>
      <assert id="UBL-CR-446" flag="warning" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cac:FinancialInstitutionBranch)">[UBL-CR-446]-warning-A UBL invoice should not include the PaymentMeans PaymentMandate PayerFinancialAccount FinancialInstitutionBranch</assert>
      <assert id="UBL-CR-447" flag="warning" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cac:Country)">[UBL-CR-447]-warning-A UBL invoice should not include the PaymentMeans PaymentMandate PayerFinancialAccount Country</assert>
      <assert id="UBL-CR-448" flag="warning" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:ValidityPeriod)">[UBL-CR-448]-warning-A UBL invoice should not include the PaymentMeans PaymentMandate ValidityPeriod</assert>
      <assert id="UBL-CR-449" flag="warning" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:PaymentReversalPeriod)">[UBL-CR-449]-warning-A UBL invoice should not include the PaymentMeans PaymentMandate PaymentReversalPeriod</assert>
      <assert id="UBL-CR-450" flag="warning" test="not(cac:PaymentMeans/cac:PaymentMandate/cac:Clause)">[UBL-CR-450]-warning-A UBL invoice should not include the PaymentMeans PaymentMandate Clause</assert>
      <assert id="UBL-CR-451" flag="warning" test="not(cac:PaymentMeans/cac:TradeFinancing)">[UBL-CR-451]-warning-A UBL invoice should not include the PaymentMeans TradeFinancing</assert>
      <assert id="UBL-CR-452" flag="warning" test="not(cac:PaymentTerms/cbc:ID)">[UBL-CR-452]-warning-A UBL invoice should not include the PaymentTerms ID</assert>
      <assert id="UBL-CR-453" flag="warning" test="not(cac:PaymentTerms/cbc:PaymentMeansID)">[UBL-CR-453]-warning-A UBL invoice should not include the PaymentTerms PaymentMeansID</assert>
      <assert id="UBL-CR-454" flag="warning" test="not(cac:PaymentTerms/cbc:PrepaidPaymentReferenceID)">[UBL-CR-454]-warning-A UBL invoice should not include the PaymentTerms PrepaidPaymentReferenceID</assert>
      <assert id="UBL-CR-455" flag="warning" test="not(cac:PaymentTerms/cbc:ReferenceEventCode)">[UBL-CR-455]-warning-A UBL invoice should not include the PaymentTerms ReferenceEventCode</assert>
      <assert id="UBL-CR-456" flag="warning" test="not(cac:PaymentTerms/cbc:SettlementDiscountPercent)">[UBL-CR-456]-warning-A UBL invoice should not include the PaymentTerms SettlementDiscountPercent</assert>
      <assert id="UBL-CR-457" flag="warning" test="not(cac:PaymentTerms/cbc:PenaltySurchargePercent)">[UBL-CR-457]-warning-A UBL invoice should not include the PaymentTerms PenaltySurchargePercent</assert>
      <assert id="UBL-CR-458" flag="warning" test="not(cac:PaymentTerms/cbc:PaymentPercent)">[UBL-CR-458]-warning-A UBL invoice should not include the PaymentTerms PaymentPercent</assert>
      <assert id="UBL-CR-459" flag="warning" test="not(cac:PaymentTerms/cbc:Amount)">[UBL-CR-459]-warning-A UBL invoice should not include the PaymentTerms Amount</assert>
      <assert id="UBL-CR-460" flag="warning" test="not(cac:PaymentTerms/cbc:SettlementDiscountAmount)">[UBL-CR-460]-warning-A UBL invoice should not include the PaymentTerms SettlementDiscountAmount</assert>
      <assert id="UBL-CR-461" flag="warning" test="not(cac:PaymentTerms/cbc:PenaltyAmount)">[UBL-CR-461]-warning-A UBL invoice should not include the PaymentTerms PenaltyAmount</assert>
      <assert id="UBL-CR-462" flag="warning" test="not(cac:PaymentTerms/cbc:PaymentTermsDetailsURI)">[UBL-CR-462]-warning-A UBL invoice should not include the PaymentTerms PaymentTermsDetailsURI</assert>
      <assert id="UBL-CR-463" flag="warning" test="not(cac:PaymentTerms/cbc:PaymentDueDate)">[UBL-CR-463]-warning-A UBL invoice should not include the PaymentTerms PaymentDueDate</assert>
      <assert id="UBL-CR-464" flag="warning" test="not(cac:PaymentTerms/cbc:InstallmentDueDate)">[UBL-CR-464]-warning-A UBL invoice should not include the PaymentTerms InstallmentDueDate</assert>
      <assert id="UBL-CR-465" flag="warning" test="not(cac:PaymentTerms/cbc:InvoicingPartyReference)">[UBL-CR-465]-warning-A UBL invoice should not include the PaymentTerms InvoicingPartyReference</assert>
      <assert id="UBL-CR-466" flag="warning" test="not(cac:PaymentTerms/cac:SettlementPeriod)">[UBL-CR-466]-warning-A UBL invoice should not include the PaymentTerms SettlementPeriod</assert>
      <assert id="UBL-CR-467" flag="warning" test="not(cac:PaymentTerms/cac:PenaltyPeriod)">[UBL-CR-467]-warning-A UBL invoice should not include the PaymentTerms PenaltyPeriod</assert>
      <assert id="UBL-CR-468" flag="warning" test="not(cac:PaymentTerms/cac:ExchangeRate)">[UBL-CR-468]-warning-A UBL invoice should not include the PaymentTerms ExchangeRate</assert>
      <assert id="UBL-CR-469" flag="warning" test="not(cac:PaymentTerms/cac:ValidityPeriod)">[UBL-CR-469]-warning-A UBL invoice should not include the PaymentTerms ValidityPeriod</assert>
      <assert id="UBL-CR-470" flag="warning" test="not(cac:PrepaidPayment)">[UBL-CR-470]-warning-A UBL invoice should not include the PrepaidPayment</assert>
      <assert id="UBL-CR-471" flag="warning" test="not(cac:AllowanceCharge/cbc:ID)">[UBL-CR-471]-warning-A UBL invoice should not include the AllowanceCharge ID</assert>
      <assert id="UBL-CR-472" flag="warning" test="not(cac:AllowanceCharge/cbc:PrepaidIndicator)">[UBL-CR-472]-warning-A UBL invoice should not include the AllowanceCharge PrepaidIndicator</assert>
      <assert id="UBL-CR-473" flag="warning" test="not(cac:AllowanceCharge/cbc:SequenceNumeric)">[UBL-CR-473]-warning-A UBL invoice should not include the AllowanceCharge SequenceNumeric</assert>
      <assert id="UBL-CR-474" flag="warning" test="not(cac:AllowanceCharge/cbc:AccountingCostCode)">[UBL-CR-474]-warning-A UBL invoice should not include the AllowanceCharge AccountingCostCode</assert>
      <assert id="UBL-CR-475" flag="warning" test="not(cac:AllowanceCharge/cbc:AccountingCost)">[UBL-CR-475]-warning-A UBL invoice should not include the AllowanceCharge AccountingCost</assert>
      <assert id="UBL-CR-476" flag="warning" test="not(cac:AllowanceCharge/cbc:PerUnitAmount)">[UBL-CR-476]-warning-A UBL invoice should not include the AllowanceCharge PerUnitAmount</assert>
      <assert id="UBL-CR-477" flag="warning" test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:Name)">[UBL-CR-477]-warning-A UBL invoice should not include the AllowanceCharge TaxCategory Name</assert>
      <assert id="UBL-CR-478" flag="warning" test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:BaseUnitMeasure)">[UBL-CR-478]-warning-A UBL invoice should not include the AllowanceCharge TaxCategory BaseUnitMeasure</assert>
      <assert id="UBL-CR-479" flag="warning" test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:PerUnitAmount)">[UBL-CR-479]-warning-A UBL invoice should not include the AllowanceCharge TaxCategory PerUnitAmount</assert>
      <assert id="UBL-CR-480" flag="warning" test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReasonCode)">[UBL-CR-480]-warning-A UBL invoice should not include the AllowanceCharge TaxCategory TaxExemptionReasonCode</assert>
      <assert id="UBL-CR-481" flag="warning" test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReason)">[UBL-CR-481]-warning-A UBL invoice should not include the AllowanceCharge TaxCategory TaxExemptionReason</assert>
      <assert id="UBL-CR-482" flag="warning" test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:TierRange)">[UBL-CR-482]-warning-A UBL invoice should not include the AllowanceCharge TaxCategory TierRange</assert>
      <assert id="UBL-CR-483" flag="warning" test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:TierRatePercent)">[UBL-CR-483]-warning-A UBL invoice should not include the AllowanceCharge TaxCategory TierRatePercent</assert>
      <assert id="UBL-CR-484" flag="warning" test="not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:Name)">[UBL-CR-484]-warning-A UBL invoice should not include the AllowanceCharge TaxCategory TaxScheme Name</assert>
      <assert id="UBL-CR-485" flag="warning" test="not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode)">[UBL-CR-485]-warning-A UBL invoice should not include the AllowanceCharge TaxCategory TaxScheme TaxTypeCode</assert>
      <assert id="UBL-CR-486" flag="warning" test="not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode)">[UBL-CR-486]-warning-A UBL invoice should not include the AllowanceCharge TaxCategory TaxScheme CurrencyCode</assert>
      <assert id="UBL-CR-487" flag="warning" test="not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress)">[UBL-CR-487]-warning-A UBL invoice should not include the AllowanceCharge TaxCategory TaxScheme JurisdictionRegionAddress</assert>
      <!--      <assert id="UBL-CR-487" flag="warning" test="not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cac:JurisdiccionRegionAddress)">[UBL-CR-487]-warning-A UBL invoice should not include the AllowanceCharge TaxCategory TaxScheme JurisdiccionRegionAddress</assert>-->
      <assert id="UBL-CR-488" flag="warning" test="not(cac:AllowanceCharge/cac:TaxTotal)">[UBL-CR-488]-warning-A UBL invoice should not include the AllowanceCharge TaxTotal</assert>
      <assert id="UBL-CR-489" flag="warning" test="not(cac:AllowanceCharge/cac:PaymentMeans)">[UBL-CR-489]-warning-A UBL invoice should not include the AllowanceCharge PaymentMeans</assert>
      <assert id="UBL-CR-490" flag="warning" test="not(cac:TaxExchangeRate)">[UBL-CR-490]-warning-A UBL invoice should not include the TaxExchangeRate</assert>
      <assert id="UBL-CR-491" flag="warning" test="not(cac:PricingExchangeRate)">[UBL-CR-491]-warning-A UBL invoice should not include the PricingExchangeRate</assert>
      <assert id="UBL-CR-492" flag="warning" test="not(cac:PaymentExchangeRate)">[UBL-CR-492]-warning-A UBL invoice should not include the PaymentExchangeRate</assert>
      <assert id="UBL-CR-493" flag="warning" test="not(cac:PaymentAlternativeExchangeRate)">[UBL-CR-493]-warning-A UBL invoice should not include the PaymentAlternativeExchangeRate</assert>
      <assert id="UBL-CR-494" flag="warning" test="not(cac:TaxTotal/cbc:RoundingAmount)">[UBL-CR-494]-warning-A UBL invoice should not include the TaxTotal RoundingAmount</assert>
      <assert id="UBL-CR-495" flag="warning" test="not(cac:TaxTotal/cbc:TaxEvidenceIndicator)">[UBL-CR-495]-warning-A UBL invoice should not include the TaxTotal TaxEvidenceIndicator</assert>
      <assert id="UBL-CR-496" flag="warning" test="not(cac:TaxTotal/cbc:TaxIncludedIndicator)">[UBL-CR-496]-warning-A UBL invoice should not include the TaxTotal TaxIncludedIndicator</assert>
      <assert id="UBL-CR-497" flag="warning" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:CalculationSequenceNumeric)">[UBL-CR-497]-warning-A UBL invoice should not include the TaxTotal TaxSubtotal CalulationSequenceNumeric</assert>
      <assert id="UBL-CR-498" flag="warning" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:TransactionCurrencyTaxAmount)">[UBL-CR-498]-warning-A UBL invoice should not include the TaxTotal TaxSubtotal TransactionCurrencyTaxAmount</assert>
      <assert id="UBL-CR-499" flag="warning" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:Percent)">[UBL-CR-499]-warning-A UBL invoice should not include the TaxTotal TaxSubtotal Percent</assert>
      <assert id="UBL-CR-500" flag="warning" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:BaseUnitMeasure)">[UBL-CR-500]-warning-A UBL invoice should not include the TaxTotal TaxSubtotal BaseUnitMeasure</assert>
      <assert id="UBL-CR-501" flag="warning" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:PerUnitAmount)">[UBL-CR-501]-warning-A UBL invoice should not include the TaxTotal TaxSubtotal PerUnitAmount</assert>
      <assert id="UBL-CR-502" flag="warning" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:TierRange)">[UBL-CR-502]-warning-A UBL invoice should not include the TaxTotal TaxSubtotal TierRange</assert>
      <assert id="UBL-CR-503" flag="warning" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:TierRatePercent)">[UBL-CR-503]-warning-A UBL invoice should not include the TaxTotal TaxSubtotal TierRatePercent</assert>
      <assert id="UBL-CR-504" flag="warning" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:Name)">[UBL-CR-504]-warning-A UBL invoice should not include the TaxTotal TaxSubtotal TaxCategory Name</assert>
      <assert id="UBL-CR-505" flag="warning" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:BaseUnitMeasure)">[UBL-CR-505]-warning-A UBL invoice should not include the TaxTotal TaxSubtotal TaxCategory BaseUnitMeasure</assert>
      <assert id="UBL-CR-506" flag="warning" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:PerUnitAmount)">[UBL-CR-506]-warning-A UBL invoice should not include the TaxTotal TaxSubtotal TaxCategory PerUnitAmount</assert>
      <assert id="UBL-CR-507" flag="warning" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TierRange)">[UBL-CR-507]-warning-A UBL invoice should not include the TaxTotal TaxSubtotal TaxCategory TierRange</assert>
      <assert id="UBL-CR-508" flag="warning" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TierRatePercent)">[UBL-CR-508]-warning-A UBL invoice should not include the TaxTotal TaxSubtotal TaxCategory TierRatePercent</assert>
      <assert id="UBL-CR-509" flag="warning" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:Name)">[UBL-CR-509]-warning-A UBL invoice should not include the TaxTotal TaxSubtotal TaxCategory TaxScheme Name</assert>
      <assert id="UBL-CR-510" flag="warning" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode)">[UBL-CR-510]-warning-A UBL invoice should not include the TaxTotal TaxSubtotal TaxCategory TaxScheme TaxTypeCode</assert>
      <assert id="UBL-CR-511" flag="warning" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode)">[UBL-CR-511]-warning-A UBL invoice should not include the TaxTotal TaxSubtotal TaxCategory TaxScheme CurrencyCode</assert>
      <assert id="UBL-CR-512" flag="warning" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress)">[UBL-CR-512]-warning-A UBL invoice should not include the TaxTotal TaxSubtotal TaxCategory TaxScheme JurisdictionRegionAddress</assert>
      <!--<assert id="UBL-CR-512" flag="warning" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cac:JurisdiccionRegionAddress)">[UBL-CR-512]-warning-A UBL invoice should not include the TaxTotal TaxSubtotal TaxCategory TaxScheme JurisdiccionRegionAddress</assert>-->
      <assert id="UBL-CR-513" flag="warning" test="not(cac:WithholdingTaxTotal)">[UBL-CR-513]-warning-A UBL invoice should not include the WithholdingTaxTotal</assert>
      <assert id="UBL-CR-514" flag="warning" test="not(cac:LegalMonetaryTotal/cbc:PayableAlternativeAmount)">[UBL-CR-514]-warning-A UBL invoice should not include the LegalMonetaryTotal PayableAlternativeAmount</assert>
      <assert id="UBL-CR-515" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cbc:UUID)">[UBL-CR-515]-warning-A UBL invoice should not include the InvoiceLine UUID</assert>
      <assert id="UBL-CR-516" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cbc:TaxPointDate)">[UBL-CR-516]-warning-A UBL invoice should not include the InvoiceLine TaxPointDate</assert>
      <assert id="UBL-CR-517" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cbc:AccountingCostCode)">[UBL-CR-517]-warning-A UBL invoice should not include the InvoiceLine AccountingCostCode</assert>
      <assert id="UBL-CR-518" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cbc:PaymentPurposeCode)">[UBL-CR-518]-warning-A UBL invoice should not include the InvoiceLine PaymentPurposeCode</assert>
      <assert id="UBL-CR-519" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cbc:FreeOfChargeIndicator)">[UBL-CR-519]-warning-A UBL invoice should not include the InvoiceLine FreeOfChargeIndicator</assert>
      <assert id="UBL-CR-520" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:InvoicePeriod/cbc:StartTime)">[UBL-CR-520]-warning-A UBL invoice should not include the InvoiceLine InvoicePeriod StartTime</assert>
      <assert id="UBL-CR-521" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:InvoicePeriod/cbc:EndTime)">[UBL-CR-521]-warning-A UBL invoice should not include the InvoiceLine InvoicePeriod EndTime</assert>
      <assert id="UBL-CR-522" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:InvoicePeriod/cbc:DurationMeasure)">[UBL-CR-522]-warning-A UBL invoice should not include the InvoiceLine InvoicePeriod DurationMeasure</assert>
      <assert id="UBL-CR-523" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:InvoicePeriod/cbc:DescriptionCode)">[UBL-CR-523]-warning-A UBL invoice should not include the InvoiceLine InvoicePeriod DescriptionCode</assert>
      <assert id="UBL-CR-524" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:InvoicePeriod/cbc:Description)">[UBL-CR-524]-warning-A UBL invoice should not include the InvoiceLine InvoicePeriod Description</assert>
      <assert id="UBL-CR-525" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:OrderLineReference/cbc:SalesOrderLineID)">[UBL-CR-525]-warning-A UBL invoice should not include the InvoiceLine OrderLineReference SalesOrderLineID</assert>
      <assert id="UBL-CR-526" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:OrderLineReference/cbc:UUID)">[UBL-CR-526]-warning-A UBL invoice should not include the InvoiceLine OrderLineReference UUID</assert>
      <assert id="UBL-CR-527" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:OrderLineReference/cbc:LineStatusCode)">[UBL-CR-527]-warning-A UBL invoice should not include the InvoiceLine OrderLineReference LineStatusCode</assert>
      <assert id="UBL-CR-528" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:OrderLineReference/cac:OrderReference)">[UBL-CR-528]-warning-A UBL invoice should not include the InvoiceLine OrderLineReference OrderReference</assert>
      <assert id="UBL-CR-529" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DespatchLineReference)">[UBL-CR-529]-warning-A UBL invoice should not include the InvoiceLine DespatchLineReference</assert>
      <assert id="UBL-CR-530" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:ReceiptLineReference)">[UBL-CR-530]-warning-A UBL invoice should not include the InvoiceLine ReceiptLineReference</assert>
      <assert id="UBL-CR-531" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:BillingReference)">[UBL-CR-531]-warning-A UBL invoice should not include the InvoiceLine BillingReference</assert>
      <assert id="UBL-CR-532" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:CopyIndicator)">[UBL-CR-532]-warning-A UBL invoice should not include the InvoiceLine DocumentReference CopyIndicator</assert>
      <assert id="UBL-CR-533" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:UUID)">[UBL-CR-533]-warning-A UBL invoice should not include the InvoiceLine DocumentReference UUID</assert>
      <assert id="UBL-CR-534" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:IssueDate)">[UBL-CR-534]-warning-A UBL invoice should not include the InvoiceLine DocumentReference IssueDate</assert>
      <assert id="UBL-CR-535" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:IssueTime)">[UBL-CR-535]-warning-A UBL invoice should not include the InvoiceLine DocumentReference IssueTime</assert>
      <assert id="UBL-CR-537" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:DocumentType)">[UBL-CR-537]-warning-A UBL invoice should not include the InvoiceLine DocumentReference DocumentType</assert>
      <assert id="UBL-CR-538" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:Xpath)">[UBL-CR-538]-warning-A UBL invoice should not include the InvoiceLine DocumentReference XPath</assert>
      <!--assert id="UBL-CR-538" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:Xpath)">[UBL-CR-538]-warning-A UBL invoice should not include the InvoiceLine DocumentReference Xpath</assert>-->
      <assert id="UBL-CR-539" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:LanguageID)">[UBL-CR-539]-warning-A UBL invoice should not include the InvoiceLine DocumentReference LanguageID</assert>
      <assert id="UBL-CR-540" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:LocaleCode)">[UBL-CR-540]-warning-A UBL invoice should not include the InvoiceLine DocumentReference LocaleCode</assert>
      <assert id="UBL-CR-541" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:VersionID)">[UBL-CR-541]-warning-A UBL invoice should not include the InvoiceLine DocumentReference VersionID</assert>
      <assert id="UBL-CR-542" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:DocumentStatusCode)">[UBL-CR-542]-warning-A UBL invoice should not include the InvoiceLine DocumentReference DocumentStatusCode</assert>
      <assert id="UBL-CR-543" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cbc:DocumentDescription)">[UBL-CR-543]-warning-A UBL invoice should not include the InvoiceLine DocumentReference DocumentDescription</assert>
      <assert id="UBL-CR-544" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cac:Attachment)">[UBL-CR-544]-warning-A UBL invoice should not include the InvoiceLine DocumentReference Attachment</assert>
      <assert id="UBL-CR-545" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cac:ValidityPeriod)">[UBL-CR-545]-warning-A UBL invoice should not include the InvoiceLine DocumentReference ValidityPeriod</assert>
      <assert id="UBL-CR-546" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cac:IssuerParty)">[UBL-CR-546]-warning-A UBL invoice should not include the InvoiceLine DocumentReference IssuerParty</assert>
      <assert id="UBL-CR-547" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DocumentReference/cac:ResultOfVerification)">[UBL-CR-547]-warning-A UBL invoice should not include the InvoiceLine DocumentReference ResultOfVerification</assert>
      <assert id="UBL-CR-548" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:PricingReference)">[UBL-CR-548]-warning-A UBL invoice should not include the InvoiceLine PricingReference</assert>
      <assert id="UBL-CR-549" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:OriginatorParty)">[UBL-CR-549]-warning-A UBL invoice should not include the InvoiceLine OriginatorParty</assert>
      <assert id="UBL-CR-550" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Delivery)">[UBL-CR-550]-warning-A UBL invoice should not include the InvoiceLine Delivery</assert>
      <assert id="UBL-CR-551" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:PaymentTerms)">[UBL-CR-551]-warning-A UBL invoice should not include the InvoiceLine PaymentTerms</assert>
      <assert id="UBL-CR-552" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cbc:ID)">[UBL-CR-552]-warning-A UBL invoice should not include the InvoiceLine AllowanceCharge ID</assert>
      <assert id="UBL-CR-553" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cbc:PrepaidIndicator)">[UBL-CR-553]-warning-A UBL invoice should not include the InvoiceLine AllowanceCharge PrepaidIndicator</assert>
      <assert id="UBL-CR-554" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cbc:SequenceNumeric)">[UBL-CR-554]-warning-A UBL invoice should not include the InvoiceLine AllowanceCharge SequenceNumeric</assert>
      <assert id="UBL-CR-555" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cbc:AccountingCostCode)">[UBL-CR-555]-warning-A UBL invoice should not include the InvoiceLine AllowanceCharge AccountingCostCode</assert>
      <assert id="UBL-CR-556" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cbc:AccountingCost)">[UBL-CR-556]-warning-A UBL invoice should not include the InvoiceLine AllowanceCharge AccountingCost</assert>
      <assert id="UBL-CR-557" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cbc:PerUnitAmount)">[UBL-CR-557]-warning-A UBL invoice should not include the InvoiceLine AllowanceCharge PerUnitAmount</assert>
      <assert id="UBL-CR-558" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cac:TaxCategory)">[UBL-CR-558]-warning-A UBL invoice should not include the InvoiceLine AllowanceCharge TaxCategory</assert>
      <assert id="UBL-CR-559" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cac:TaxTotal)">[UBL-CR-559]-warning-A UBL invoice should not include the InvoiceLine AllowanceCharge TaxTotal</assert>
      <assert id="UBL-CR-560" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:AllowanceCharge/cac:PaymentMeans)">[UBL-CR-560]-warning-A UBL invoice should not include the InvoiceLine AllowanceCharge PaymentMeans</assert>
      <assert id="UBL-CR-561" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:TaxTotal)">[UBL-CR-561]-warning-A UBL invoice should not include the InvoiceLine TaxTotal</assert>
      <assert id="UBL-CR-562" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:WithholdingTaxTotal)">[UBL-CR-562]-warning-A UBL invoice should not include the InvoiceLine WithholdingTaxTotal</assert>
      <assert id="UBL-CR-563" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cbc:PackQuantity)">[UBL-CR-563]-warning-A UBL invoice should not include the InvoiceLine Item PackQuantity</assert>
      <assert id="UBL-CR-564" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cbc:PackSizeNumeric)">[UBL-CR-564]-warning-A UBL invoice should not include the InvoiceLine Item PackSizeNumeric</assert>
      <assert id="UBL-CR-565" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cbc:CatalogueIndicator)">[UBL-CR-565]-warning-A UBL invoice should not include the InvoiceLine Item CatalogueIndicator</assert>
      <assert id="UBL-CR-566" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cbc:HazardousRiskIndicator)">[UBL-CR-566]-warning-A UBL invoice should not include the InvoiceLine Item HazardousRiskIndicator</assert>
      <assert id="UBL-CR-567" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cbc:AdditionalInformation)">[UBL-CR-567]-warning-A UBL invoice should not include the InvoiceLine Item AdditionalInformation</assert>
      <assert id="UBL-CR-568" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cbc:Keyword)">[UBL-CR-568]-warning-A UBL invoice should not include the InvoiceLine Item Keyword</assert>
      <assert id="UBL-CR-569" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cbc:BrandName)">[UBL-CR-569]-warning-A UBL invoice should not include the InvoiceLine Item BrandName</assert>
      <assert id="UBL-CR-570" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cbc:ModelName)">[UBL-CR-570]-warning-A UBL invoice should not include the InvoiceLine Item ModelName</assert>
      <assert id="UBL-CR-571" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:BuyersItemIdentification/cbc:ExtendedID)">[UBL-CR-571]-warning-A UBL invoice should not include the InvoiceLine Item BuyersItemIdentification ExtendedID</assert>
      <assert id="UBL-CR-572" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:BuyersItemIdentification/cbc:BarcodeSymbologyID)">[UBL-CR-572]-warning-A UBL invoice should not include the InvoiceLine Item BuyersItemIdentification BarcodeSymbologyID</assert>
      <!--<assert id="UBL-CR-572" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:BuyersItemIdentification/cbc:BareCodeSymbologyID)">[UBL-CR-572]-warning-A UBL invoice should not include the InvoiceLine Item BuyersItemIdentification BareCodeSymbologyID</assert>-->
      <assert id="UBL-CR-573" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:BuyersItemIdentification/cac:PhysicalAttribute)">[UBL-CR-573]-warning-A UBL invoice should not include the InvoiceLine Item BuyersItemIdentification PhysicalAttribute</assert>
      <assert id="UBL-CR-574" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:BuyersItemIdentification/cac:MeasurementDimension)">[UBL-CR-574]-warning-A UBL invoice should not include the InvoiceLine Item BuyersItemIdentification MeasurementDimension</assert>
      <assert id="UBL-CR-575" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:BuyersItemIdentification/cac:IssuerParty)">[UBL-CR-575]-warning-A UBL invoice should not include the InvoiceLine Item BuyersItemIdentification IssuerParty</assert>
      <assert id="UBL-CR-576" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:SellersItemIdentification/cbc:ExtendedID)">[UBL-CR-576]-warning-A UBL invoice should not include the InvoiceLine Item SellersItemIdentification ExtendedID</assert>
      <assert id="UBL-CR-577" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:SellersItemIdentification/cbc:BarcodeSymbologyID)">[UBL-CR-577]-warning-A UBL invoice should not include the InvoiceLine Item SellersItemIdentification BarcodeSymbologyID</assert>
      <!--<assert id="UBL-CR-577" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:SellersItemIdentification/cbc:BareCodeSymbologyID)">[UBL-CR-577]-warning-A UBL invoice should not include the InvoiceLine Item SellersItemIdentification BareCodeSymbologyID</assert>-->
      <assert id="UBL-CR-578" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:SellersItemIdentification/cac:PhysicalAttribute)">[UBL-CR-578]-warning-A UBL invoice should not include the InvoiceLine Item SellersItemIdentification PhysicalAttribute</assert>
      <assert id="UBL-CR-579" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:SellersItemIdentification/cac:MeasurementDimension)">[UBL-CR-579]-warning-A UBL invoice should not include the InvoiceLine Item SellersItemIdentification MeasurementDimension</assert>
      <assert id="UBL-CR-580" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:SellersItemIdentification/cac:IssuerParty)">[UBL-CR-580]-warning-A UBL invoice should not include the InvoiceLine Item SellersItemIdentification IssuerParty</assert>
      <assert id="UBL-CR-581" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ManufacturersItemIdentification)">[UBL-CR-581]-warning-A UBL invoice should not include the InvoiceLine Item ManufacturersItemIdentification</assert>
      <assert id="UBL-CR-582" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:StandardItemIdentification/cbc:ExtendedID)">[UBL-CR-582]-warning-A UBL invoice should not include the InvoiceLine Item StandardItemIdentification ExtendedID</assert>
      <assert id="UBL-CR-583" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:StandardItemIdentification/cbc:BarcodeSymbologyID)">[UBL-CR-583]-warning-A UBL invoice should not include the InvoiceLine Item StandardItemIdentification BarcodeSymbologyID</assert>
      <!--<assert id="UBL-CR-583" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:StandardItemIdentification/cbc:BareCodeSymbologyID)">[UBL-CR-583]-warning-A UBL invoice should not include the InvoiceLine Item StandardItemIdentification BareCodeSymbologyID</assert>-->
      <assert id="UBL-CR-584" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:StandardItemIdentification/cac:PhysicalAttribute)">[UBL-CR-584]-warning-A UBL invoice should not include the InvoiceLine Item StandardItemIdentification PhysicalAttribute</assert>
      <assert id="UBL-CR-585" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:StandardItemIdentification/cac:MeasurementDimension)">[UBL-CR-585]-warning-A UBL invoice should not include the InvoiceLine Item StandardItemIdentification MeasurementDimension</assert>
      <assert id="UBL-CR-586" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:StandardItemIdentification/cac:IssuerParty)">[UBL-CR-586]-warning-A UBL invoice should not include the InvoiceLine Item StandardItemIdentification IssuerParty</assert>
      <assert id="UBL-CR-587" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:CatalogueItemIdentification)">[UBL-CR-587]-warning-A UBL invoice should not include the InvoiceLine Item CatalogueItemIdentification</assert>
      <assert id="UBL-CR-588" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemIdentification)">[UBL-CR-588]-warning-A UBL invoice should not include the InvoiceLine Item AdditionalItemIdentification</assert>
      <assert id="UBL-CR-589" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:CatalogueDocumentReference)">[UBL-CR-589]-warning-A UBL invoice should not include the InvoiceLine Item CatalogueDocumentReference</assert>
      <assert id="UBL-CR-590" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ItemSpecificationDocumentReference)">[UBL-CR-590]-warning-A UBL invoice should not include the InvoiceLine Item ItemSpecificationDocumentReference</assert>
      <assert id="UBL-CR-591" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:OriginCountry/cbc:Name)">[UBL-CR-591]-warning-A UBL invoice should not include the InvoiceLine Item OriginCountry Name</assert>
      <assert id="UBL-CR-592" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:CommodityClassification/cbc:NatureCode)">[UBL-CR-592]-warning-A UBL invoice should not include the InvoiceLine Item CommodityClassification NatureCode</assert>
      <assert id="UBL-CR-593" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:CommodityClassification/cbc:CargoTypeCode)">[UBL-CR-593]-warning-A UBL invoice should not include the InvoiceLine Item CommodityClassification CargoTypeCode</assert>
      <assert id="UBL-CR-594" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:CommodityClassification/cbc:CommodityCode)">[UBL-CR-594]-warning-A UBL invoice should not include the InvoiceLine Item CommodityClassification CommodityCode</assert>
      <assert id="UBL-CR-595" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:TransactionConditions)">[UBL-CR-595]-warning-A UBL invoice should not include the InvoiceLine Item TransactionConditions</assert>
      <assert id="UBL-CR-596" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:HazardousItem)">[UBL-CR-596]-warning-A UBL invoice should not include the InvoiceLine Item HazardousItem</assert>
      <assert id="UBL-CR-597" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cbc:Name)">[UBL-CR-597]-warning-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory Name</assert>
      <assert id="UBL-CR-598" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cbc:BaseUnitMeasure)">[UBL-CR-598]-warning-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory BaseUnitMeasure</assert>
      <assert id="UBL-CR-599" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cbc:PerUnitAmount)">[UBL-CR-599]-warning-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory PerUnitAmount</assert>
      <assert id="UBL-CR-600" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cbc:TaxExemptionReasonCode)">[UBL-CR-600]-warning-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory TaxExemptionReasonCode</assert>
      <assert id="UBL-CR-601" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cbc:TaxExemptionReason)">[UBL-CR-601]-warning-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory TaxExemptionReason</assert>
      <assert id="UBL-CR-602" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cbc:TierRange)">[UBL-CR-602]-warning-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory TierRange</assert>
      <assert id="UBL-CR-603" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cbc:TierRatePercent)">[UBL-CR-603]-warning-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory TierRatePercent</assert>
      <assert id="UBL-CR-604" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:Name)">[UBL-CR-604]-warning-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory TaxScheme Name</assert>
      <assert id="UBL-CR-605" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:TaxTypeCode)">[UBL-CR-605]-warning-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory TaxScheme TaxTypeCode</assert>
      <assert id="UBL-CR-606" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:CurrencyCode)">[UBL-CR-606]-warning-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory TaxScheme CurrencyCode</assert>
      <assert id="UBL-CR-607" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress)">[UBL-CR-607]-warning-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory TaxScheme JurisdictionRegionAddress</assert>
      <!--<assert id="UBL-CR-607" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cac:JurisdiccionRegionAddress)">[UBL-CR-607]-warning-A UBL invoice should not include the InvoiceLine Item ClassifiedTaxCategory TaxScheme JurisdiccionRegionAddress</assert>-->
      <assert id="UBL-CR-608" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cbc:ID)">[UBL-CR-608]-warning-A UBL invoice should not include the InvoiceLine Item AdditionalItemProperty ID</assert>
      <assert id="UBL-CR-609" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cbc:NameCode)">[UBL-CR-609]-warning-A UBL invoice should not include the InvoiceLine Item AdditionalItemProperty NameCode</assert>
      <assert id="UBL-CR-610" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cbc:TestMethod)">[UBL-CR-610]-warning-A UBL invoice should not include the InvoiceLine Item AdditionalItemProperty TestMethod</assert>
      <assert id="UBL-CR-611" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cbc:ValueQuantity)">[UBL-CR-611]-warning-A UBL invoice should not include the InvoiceLine Item AdditionalItemProperty ValueQuantity</assert>
      <assert id="UBL-CR-612" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cbc:ValueQualifier)">[UBL-CR-612]-warning-A UBL invoice should not include the InvoiceLine Item AdditionalItemProperty ValueQualifier</assert>
      <assert id="UBL-CR-613" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cbc:ImportanceCode)">[UBL-CR-613]-warning-A UBL invoice should not include the InvoiceLine Item AdditionalItemProperty ImportanceCode</assert>
      <assert id="UBL-CR-614" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cbc:ListValue)">[UBL-CR-614]-warning-A UBL invoice should not include the InvoiceLine Item AdditionalItemProperty ListValue</assert>
      <assert id="UBL-CR-615" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cac:UsabilityPeriod)">[UBL-CR-615]-warning-A UBL invoice should not include the InvoiceLine Item AdditionalItemProperty UsabilityPeriod</assert>
      <assert id="UBL-CR-616" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cac:ItemPropertyGroup)">[UBL-CR-616]-warning-A UBL invoice should not include the InvoiceLine Item AdditionalItemProperty ItemPropertyGroup</assert>
      <assert id="UBL-CR-617" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cac:RangeDimension)">[UBL-CR-617]-warning-A UBL invoice should not include the InvoiceLine Item AdditionalItemProperty RangeDimension</assert>
      <assert id="UBL-CR-618" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty/cac:ItemPropertyRange)">[UBL-CR-618]-warning-A UBL invoice should not include the InvoiceLine Item AdditionalItemProperty ItemPropertyRange</assert>
      <assert id="UBL-CR-619" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ManufacturerParty)">[UBL-CR-619]-warning-A UBL invoice should not include the InvoiceLine Item ManufacturerParty</assert>
      <assert id="UBL-CR-620" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:InformationContentProviderParty)">[UBL-CR-620]-warning-A UBL invoice should not include the InvoiceLine Item InformationContentProviderParty</assert>
      <assert id="UBL-CR-621" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:OriginAddress)">[UBL-CR-621]-warning-A UBL invoice should not include the InvoiceLine Item OriginAddress</assert>
      <assert id="UBL-CR-622" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:ItemInstance)">[UBL-CR-622]-warning-A UBL invoice should not include the InvoiceLine Item ItemInstance</assert>
      <assert id="UBL-CR-623" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Certificate)">[UBL-CR-623]-warning-A UBL invoice should not include the InvoiceLine Item Certificate</assert>
      <assert id="UBL-CR-624" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Dimension)">[UBL-CR-624]-warning-A UBL invoice should not include the InvoiceLine Item Dimension</assert>
      <assert id="UBL-CR-625" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cbc:PriceChangeReason)">[UBL-CR-625]-warning-A UBL invoice should not include the InvoiceLine Price PriceChangeReason</assert>
      <assert id="UBL-CR-626" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cbc:PriceTypeCode)">[UBL-CR-626]-warning-A UBL invoice should not include the InvoiceLine Price PriceTypeCode</assert>
      <assert id="UBL-CR-627" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cbc:PriceType)">[UBL-CR-627]-warning-A UBL invoice should not include the InvoiceLine Price PriceType</assert>
      <assert id="UBL-CR-628" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cbc:OrderableUnitFactorRate)">[UBL-CR-628]-warning-A UBL invoice should not include the InvoiceLine Price OrderableUnitFactorRate</assert>
      <assert id="UBL-CR-629" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cbc:ValidityPeriod)">[UBL-CR-629]-warning-A UBL invoice should not include the InvoiceLine Price ValidityPeriod</assert>
      <assert id="UBL-CR-630" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cbc:PriceList)">[UBL-CR-630]-warning-A UBL invoice should not include the InvoiceLine Price PriceList</assert>
      <assert id="UBL-CR-631" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cbc:OrderableUnitFactorRate)">[UBL-CR-631]-warning-A UBL invoice should not include the InvoiceLine Price OrderableUnitFactorRate</assert>
      <assert id="UBL-CR-632" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cbc:ID)">[UBL-CR-632]-warning-A UBL invoice should not include the InvoiceLine Price AllowanceCharge ID</assert>
      <assert id="UBL-CR-633" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode)">[UBL-CR-633]-warning-A UBL invoice should not include the InvoiceLine Price AllowanceCharge AllowanceChargeReasonCode</assert>
      <assert id="UBL-CR-634" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cbc:AllowanceChargeReason)">[UBL-CR-634]-warning-A UBL invoice should not include the InvoiceLine Price AllowanceCharge AllowanceChargeReason</assert>
      <assert id="UBL-CR-635" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cbc:MultiplierFactorNumeric)">[UBL-CR-635]-warning-A UBL invoice should not include the InvoiceLine Price AllowanceCharge MultiplierFactorNumeric</assert>
      <assert id="UBL-CR-636" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cbc:PrepaidIndicator)">[UBL-CR-636]-warning-A UBL invoice should not include the InvoiceLine Price AllowanceCharge PrepaidIndicator</assert>
      <assert id="UBL-CR-637" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cbc:SequenceNumeric)">[UBL-CR-637]-warning-A UBL invoice should not include the InvoiceLine Price AllowanceCharge SequenceNumeric</assert>
      <assert id="UBL-CR-638" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cbc:AccountingCostCode)">[UBL-CR-638]-warning-A UBL invoice should not include the InvoiceLine Price AllowanceCharge AccountingCostCode</assert>
      <assert id="UBL-CR-639" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cbc:AccountingCost)">[UBL-CR-639]-warning-A UBL invoice should not include the InvoiceLine Price AllowanceCharge AccountingCost</assert>
      <assert id="UBL-CR-640" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cbc:PerUnitAmount)">[UBL-CR-640]-warning-A UBL invoice should not include the InvoiceLine Price AllowanceCharge PerUnitAmount</assert>
      <assert id="UBL-CR-641" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cac:TaxCategory)">[UBL-CR-641]-warning-A UBL invoice should not include the InvoiceLine Price AllowanceCharge TaxCategory</assert>
      <assert id="UBL-CR-642" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cac:TaxTotal)">[UBL-CR-642]-warning-A UBL invoice should not include the InvoiceLine Price AllowanceCharge TaxTotal</assert>
      <assert id="UBL-CR-643" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:AllowanceCharge/cac:PaymentMeans)">[UBL-CR-643]-warning-A UBL invoice should not include the InvoiceLine Price AllowanceCharge PaymentMeans</assert>
      <assert id="UBL-CR-644" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Price/cac:PricingExchangeRate)">[UBL-CR-644]-warning-A UBL invoice should not include the InvoiceLine Price PricingExchangeRate</assert>
      <!--
      <assert id="UBL-CR-625" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cbc:PriceChangeReason)">[UBL-CR-625]-warning-A UBL invoice should not include the InvoiceLine Item Price PriceChangeReason</assert>
      <assert id="UBL-CR-626" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cbc:PriceTypeCode)">[UBL-CR-626]-warning-A UBL invoice should not include the InvoiceLine Item Price PriceTypeCode</assert>
      <assert id="UBL-CR-627" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cbc:PriceType)">[UBL-CR-627]-warning-A UBL invoice should not include the InvoiceLine Item Price PriceType</assert>
      <assert id="UBL-CR-628" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cbc:OrderableUnitFactorRate)">[UBL-CR-628]-warning-A UBL invoice should not include the InvoiceLine Item Price OrderableUnitFactorRate</assert>
      <assert id="UBL-CR-629" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cbc:ValidityPeriod)">[UBL-CR-629]-warning-A UBL invoice should not include the InvoiceLine Item Price ValidityPeriod</assert>
      <assert id="UBL-CR-630" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cbc:PriceList)">[UBL-CR-630]-warning-A UBL invoice should not include the InvoiceLine Item Price PriceList</assert>
      <assert id="UBL-CR-631" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cbc:OrderableUnitFactorRate)">[UBL-CR-631]-warning-A UBL invoice should not include the InvoiceLine Item Price OrderableUnitFactorRate</assert>
      <assert id="UBL-CR-632" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cac:AllowanceCharge/cbc:ID)">[UBL-CR-632]-warning-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge ID</assert>
      <assert id="UBL-CR-633" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode)">[UBL-CR-633]-warning-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge AllowanceChargeReasonCode</assert>
      <assert id="UBL-CR-634" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cac:AllowanceCharge/cbc:AllowanceChargeReason)">[UBL-CR-634]-warning-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge AllowanceChargeReason</assert>
      <assert id="UBL-CR-635" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cac:AllowanceCharge/cbc:MultiplierFactorNumeric)">[UBL-CR-635]-warning-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge MultiplierFactorNumeric</assert>
      <assert id="UBL-CR-636" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cac:AllowanceCharge/cbc:PrepaidIndicator)">[UBL-CR-636]-warning-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge PrepaidIndicator</assert>
      <assert id="UBL-CR-637" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cac:AllowanceCharge/cbc:SequenceNumeric)">[UBL-CR-637]-warning-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge SequenceNumeric</assert>
      <assert id="UBL-CR-638" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cac:AllowanceCharge/cbc:AccountingCostCode)">[UBL-CR-638]-warning-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge AccountingCostCode</assert>
      <assert id="UBL-CR-639" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cac:AllowanceCharge/cbc:AccountingCost)">[UBL-CR-639]-warning-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge AccountingCost</assert>
      <assert id="UBL-CR-640" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cac:AllowanceCharge/cbc:PerUnitAmount)">[UBL-CR-640]-warning-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge PerUnitAmount</assert>
      <assert id="UBL-CR-641" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cac:AllowanceCharge/cac:TaxCategory)">[UBL-CR-641]-warning-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge TaxCategory</assert>
      <assert id="UBL-CR-642" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cac:AllowanceCharge/cac:TaxTotal)">[UBL-CR-642]-warning-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge TaxTotal</assert>
      <assert id="UBL-CR-643" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cac:AllowanceCharge/cac:PaymentMeans)">[UBL-CR-643]-warning-A UBL invoice should not include the InvoiceLine Item Price AllowanceCharge PaymentMeans</assert>
      <assert id="UBL-CR-644" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:Item/cac:Price/cac:PricingExchangeRate)">[UBL-CR-644]-warning-A UBL invoice should not include the InvoiceLine Item Price PricingExchangeRate</assert>
      -->
      <assert id="UBL-CR-645" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:DeliveryTerms)">[UBL-CR-645]-warning-A UBL invoice should not include the InvoiceLine DeliveryTerms</assert>
      <assert id="UBL-CR-646" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:SubInvoiceLine)">[UBL-CR-646]-warning-A UBL invoice should not include the InvoiceLine SubInvoiceLine</assert>
      <assert id="UBL-CR-647" flag="warning" test="not((cac:InvoiceLine|cac:CreditNoteLine)/cac:ItemPriceExtension)">[UBL-CR-647]-warning-A UBL invoice should not include the InvoiceLine ItemPriceExtension</assert>
      <assert id="UBL-CR-648" flag="warning" test="not(cbc:CustomizationID/@schemeID)">[UBL-CR-648]-warning-A UBL invoice should not include the CustomizationID scheme identifier</assert>
      <assert id="UBL-CR-649" flag="warning" test="not(cbc:ProfileID/@schemeID)">[UBL-CR-649]-warning-A UBL invoice should not include the ProfileID scheme identifier</assert>
      <assert id="UBL-CR-650" flag="warning" test="not(cbc:ID/@schemeID)">[UBL-CR-650]-warning-A UBL invoice shall not include the Invoice ID scheme identifier</assert>
      <assert id="UBL-CR-651" flag="warning" test="not(cbc:SalesOrderID/@schemeID)">[UBL-CR-651]-warning-A UBL invoice should not include the SalesOrderID scheme identifier</assert>
      <assert id="UBL-CR-652" flag="warning" test="not(//cac:PartyTaxScheme/cbc:CompanyID/@schemeID)">[UBL-CR-652]-warning-A UBL invoice should not include the PartyTaxScheme CompanyID scheme identifier</assert>
      <assert id="UBL-CR-653" flag="warning" test="not(cac:PaymentMeans/cbc:PaymentID/@schemeID)">[UBL-CR-653]-warning-A UBL invoice should not include the PaymentID scheme identifier</assert>
      <assert id="UBL-CR-654" flag="warning" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:ID/@schemeID)">[UBL-CR-654]-warning-A UBL invoice should not include the PayeeFinancialAccount scheme identifier</assert>
      <assert id="UBL-CR-655" flag="warning" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID/@schemeID)">[UBL-CR-655]-warning-A UBL invoice shall not include the FinancialInstitutionBranch ID scheme identifier</assert>
      <assert id="UBL-CR-656" flag="warning" test="not(cbc:InvoiceTypeCode/@listID)">[UBL-CR-656]-warning-A UBL invoice should not include the InvoiceTypeCode listID</assert>
      <assert id="UBL-CR-657" flag="warning" test="not(cbc:DocumentCurrencyCode/@listID)">[UBL-CR-657]-warning-A UBL invoice should not include the DocumentCurrencyCode listID</assert>
      <assert id="UBL-CR-658" flag="warning" test="not(cbc:TaxCurrencyCode/@listID)">[UBL-CR-658]-warning-A UBL invoice should not include the TaxCurrencyCode listID</assert>
      <assert id="UBL-CR-659" flag="warning" test="not(cac:AdditionalDocumentReference/cbc:DocumentTypeCode/@listID)">[UBL-CR-659]-warning-A UBL invoice shall not include the AdditionalDocumentReference DocumentTypeCode listID</assert>
      <assert id="UBL-CR-660" flag="warning" test="not(//cac:Country/cbc:IdentificationCode/@listID)">[UBL-CR-660]-warning-A UBL invoice should not include the Country Identification code listID</assert>
      <assert id="UBL-CR-661" flag="warning" test="not(cac:PaymentMeans/cbc:PaymentMeansCode/@listID)">[UBL-CR-661]-warning-A UBL invoice should not include the PaymentMeansCode listID</assert>
      <assert id="UBL-CR-662" flag="warning" test="not(//cbc:AllowanceChargeReasonCode/@listID)">[UBL-CR-662]-warning-A UBL invoice should not include the AllowanceChargeReasonCode listID</assert>
      <assert id="UBL-CR-663" flag="warning" test="not(//@unitCodeListID)">[UBL-CR-663]-warning-A UBL invoice should not include the unitCodeListID</assert>
      <assert id="UBL-CR-664" flag="warning" test="not(//cac:FinancialInstitution)">[UBL-CR-664]-warning-A UBL invoice should not include the FinancialInstitutionBranch FinancialInstitution</assert>
      <assert id="UBL-CR-665" flag="warning" test="not(//cac:AdditionalDocumentReference[cbc:DocumentTypeCode  != '130' or not(cbc:DocumentTypeCode)]/cbc:ID/@schemeID)">[UBL-CR-665]-warning-A UBL invoice should not include the AdditionalDocumentReference ID schemeID unless the ID equals '130'</assert>
      <assert id="UBL-CR-666" flag="fatal" test="not(//cac:AdditionalDocumentReference[cbc:DocumentTypeCode  = '130']/cac:Attachment)">[UBL-CR-666]-warning-A UBL invoice shall not include an AdditionalDocumentReference simultaneously referring an Invoice Object Identifier and an Attachment</assert>
      <assert id="UBL-CR-667" flag="warning" test="not(//cac:BuyersItemIdentification/cbc:ID/@schemeID)">[UBL-CR-667]-warning-A UBL invoice should not include a Buyer Item Identification schemeID</assert>
      <assert id="UBL-CR-668" flag="warning" test="not(//cac:SellersItemIdentification/cbc:ID/@schemeID)">[UBL-CR-668]-warning-A UBL invoice should not include a Sellers Item Identification schemeID</assert>
      <assert id="UBL-CR-669" flag="warning" test="not(//cac:Price/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode)">[UBL-CR-669]-warning-A UBL invoice should not include a Price Allowance Reason Code</assert>
      <assert id="UBL-CR-670" flag="warning" test="not(//cac:Price/cac:AllowanceCharge/cbc:AllowanceChargeReason)">[UBL-CR-670]-warning-A UBL invoice should not include a Price Allowance Reason</assert>
      <assert id="UBL-CR-671" flag="warning" test="not(//cac:Price/cac:AllowanceCharge/cbc:MultiplierFactorNumeric)">[UBL-CR-671]-warning-A UBL invoice should not include a Price Allowance Multiplier Factor</assert>
      <assert id="UBL-CR-672" flag="warning" test="not(cbc:CreditNoteTypeCode/@listID)">[UBL-CR-672]-warning-A UBL credit note should not include the CreditNoteTypeCode listID</assert>
      <assert id="UBL-CR-673" flag="fatal" test="not(//cac:AdditionalDocumentReference[cbc:DocumentTypeCode  = '130']/cbc:DocumentDescription)">[UBL-CR-673]-warning-A UBL invoice shall not include an AdditionalDocumentReference simultaneously referring an Invoice Object Identifier and an Document Description</assert>
      <assert id="UBL-CR-674" flag="warning" test="not(//cbc:PrimaryAccountNumber/@schemeID)">[UBL-CR-674]-warning-A UBL invoice should not include the PrimaryAccountNumber schemeID</assert>
      <assert id="UBL-CR-675" flag="warning" test="not(//cac:CardAccount/cbc:NetworkID/@schemeID)">[UBL-CR-675]-warning-A UBL invoice should not include the NetworkID schemeID</assert>
      <assert id="UBL-CR-676" flag="warning" test="not(//cac:PaymentMandate/cbc:ID/@schemeID)">[UBL-CR-676]-warning-A UBL invoice should not include the PaymentMandate/ID schemeID</assert>
      <assert id="UBL-CR-677" flag="warning" test="not(//cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID/@schemeID)">[UBL-CR-677]-warning-A UBL invoice should not include the PayerFinancialAccount/ID schemeID</assert>
      <assert id="UBL-CR-678" flag="warning" test="not(//cac:TaxCategory/cbc:ID/@schemeID)">[UBL-CR-678]-warning-A UBL invoice should not include the TaxCategory/ID schemeID</assert>
      <assert id="UBL-CR-679" flag="warning" test="not(//cac:ClassifiedTaxCategory/cbc:ID/@schemeID)">[UBL-CR-679]-warning-A UBL invoice should not include the ClassifiedTaxCategory/ID schemeID</assert>
      <assert id="UBL-CR-680" flag="warning" test="not(//cac:PaymentMeans/cac:PayerFinancialAccount)">[UBL-CR-680]-warning-A UBL invoice should not include the PaymentMeans/PayerFinancialAccount</assert>
      <assert id="UBL-DT-08" flag="warning" test="not(//@schemeName)">[UBL-DT-08]-warning-Scheme name attribute should not be present</assert>
      <assert id="UBL-DT-09" flag="warning" test="not(//@schemeAgencyName)">[UBL-DT-09]-warning-Scheme agency name attribute should not be present</assert>
      <assert id="UBL-DT-10" flag="warning" test="not(//@schemeDataURI)">[UBL-DT-10]-warning-Scheme data uri attribute should not be present</assert>
      <assert id="UBL-DT-11" flag="warning" test="not(//@schemeURI)">[UBL-DT-11]-warning-Scheme uri attribute should not be present</assert>
      <assert id="UBL-DT-12" flag="warning" test="not(//@format)">[UBL-DT-12]-warning-Format attribute should not be present</assert>
      <assert id="UBL-DT-13" flag="warning" test="not(//@unitCodeListIdentifier)">[UBL-DT-13]-warning-Unit code list identifier attribute should not be present</assert>
      <assert id="UBL-DT-14" flag="warning" test="not(//@unitCodeListAgencyIdentifier)">[UBL-DT-14]-warning-Unit code list agency identifier attribute should not be present</assert>
      <assert id="UBL-DT-15" flag="warning" test="not(//@unitCodeListAgencyName)">[UBL-DT-15]-warning-Unit code list agency name attribute should not be present</assert>
      <assert id="UBL-DT-16" flag="warning" test="not(//@listAgencyName)">[UBL-DT-16]-warning-List agency name attribute should not be present</assert>
      <assert id="UBL-DT-17" flag="warning" test="not(//@listName)">[UBL-DT-17]-warning-List name attribute should not be present</assert>
      <assert id="UBL-DT-18" flag="warning" test="count(//@name) - count(//cbc:PaymentMeansCode/@name) &lt;= 0">[UBL-DT-18]-warning-Name attribute should not be present</assert>
      <assert id="UBL-DT-19" flag="warning" test="not(//@languageID)">[UBL-DT-19]-warning-Language identifier attribute should not be present</assert>
      <assert id="UBL-DT-20" flag="warning" test="not(//@listURI)">[UBL-DT-20]-warning-List uri attribute should not be present</assert>
      <assert id="UBL-DT-21" flag="warning" test="not(//@listSchemeURI)">[UBL-DT-21]-warning-List scheme uri attribute should not be present</assert>
      <assert id="UBL-DT-22" flag="warning" test="not(//@languageLocaleID)">[UBL-DT-22]-warning-Language local identifier attribute should not be present</assert>
      <assert id="UBL-DT-23" flag="warning" test="not(//@uri)">[UBL-DT-23]-warning-Uri attribute should not be present</assert>
      <assert id="UBL-DT-24" flag="warning" test="not(//@currencyCodeListVersionID)">[UBL-DT-24]-warning-Currency code list version id should not be present</assert>
      <assert id="UBL-DT-25" flag="warning" test="not(//@characterSetCode)">[UBL-DT-25]-warning-CharacterSetCode attribute should not be present</assert>
      <assert id="UBL-DT-26" flag="warning" test="not(//@encodingCode)">[UBL-DT-26]-warning-EncodingCode attribute should not be present</assert>
      <assert id="UBL-DT-27" flag="warning" test="not(//@schemeAgencyID)">[UBL-DT-27]-warning-Scheme Agency ID attribute should not be present</assert>
      <assert id="UBL-DT-28" flag="warning" test="not(//@listAgencyID)">[UBL-DT-28]-warning-List Agency ID attribute should not be present</assert>
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

</schema>