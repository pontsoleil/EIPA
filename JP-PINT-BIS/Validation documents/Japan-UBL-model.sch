<pattern xmlns="http://purl.oclc.org/dsdl/schematron" id="Japanese-UBL-model">
  <!--
    Document level
  -->
  <rule context="
    cbc:IssueDate | 
    cbc:DueDate | 
    cbc:TaxPointDate | 
    cbc:StartDate | 
    cbc:EndDate | 
    cbc:ActualDeliveryDate
  ">
    <!-- JP-17 -->
    <assert id="PEPPOL-EN16931-F001" flag="fatal" test="
      string-length(text()) = 10 and 
      string(.) castable as xs:date
    ">
      [PEPPOL-EN16931-F001 (JP-17)]-A date MUST be formatted YYYY-MM-DD.
    </assert>
  </rule>
  <rule context="
    ubl:Invoice/*[local-name()!='InvoiceLine']/*[@currencyID='JPY'] |
    ubl:Invoice/*[local-name()!='InvoiceLine']/*/*[@currencyID='JPY'] |
    ubl:Invoice/cac:InvoiceLine/cbc:LineExtensionAmount[@currencyID='JPY'] |
    cn:CreditNote/*[local-name()!='CreditNoteLine']/*[@currencyID='JPY'] |
    cn:CreditNote/*[local-name()!='CreditNoteLine']/*/*[@currencyID='JPY'] |
    cn:CreditNote/cac:CreditNoteLine/cbc:LineExtensionAmount[@currencyID='JPY']
  ">
    <assert id="jp-br-02" flag="fatal" test="
      matches(normalize-space(.),'^-?[1-9][0-9]*$')
    ">
      [jp-br-02]- Amount shall be integer.
    </assert>
  </rule>
  <rule context="cbc:TaxCurrencyCode">
    <!-- JP-03 -->
    <assert id="PEPPOL-EN16931-R005" flag="fatal" test="
      not(normalize-space(text()) = normalize-space(../cbc:DocumentCurrencyCode/text()))
    ">
    [PEPPOL-EN16931-R005]-VAT accounting currency code MUST be different from invoice currency code when provided.
    </assert>
  </rule>
  <!--
    Accounting supplier
  -->
  <rule context="ubl:Invoice[cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode='JP']/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cn:CreditNote[cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode='JP']/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
    <assert id="jp-br-01" flag="fatal" test="
      matches(normalize-space(cbc:CompanyID),'^T[0-9]{13}$')
    ">
      [jp-br-01]- For the Japanese Suppliers, the Tax identifier must start with 'T' and must be 13 digits.
    </assert>
  </rule>
  <!--
    Accounting customer
  -->
  <!--
    Period
  -->
  <rule context="ubl:Invoice | cn:CreditNote">
    <assert id="jp-br-03" flag="fatal" test="
      (
        not(exists(cac:InvoicePeriod))
      ) or (
        exists(cac:InvoicePeriod) or
        exists(cac:InvoiceLine/cac:InvoicePeriod) or
        exists(cac:CredotNoteLine/cac:InvoicePeriod)
      )
    ">
      [jp-br-03]-An Invoice shall have INVOICE PERIOD (ibg-14) or INVOICE LINE PERIOD (ibg-26)
    </assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoicePeriod |
      cn:CreditNote/cac:InvoicePeriod">
    <!-- JP-18 -->
    <assert id="jp-br-co-03" flag="fatal" test="
      exists(cbc:StartDate) and exists(cbc:EndDate)
    ">
      [jp-br-co-03]-If INVOICING PERIOD (ibg-14) is used, both the Invoicing period start date (ibt-073) and the Invoicing period end date (ibt-074) shall be filled.
    </assert>
  </rule>
  <rule context="ubl:Invoice | cn:CreditNote">
    <!-- JP-16 -->
    <assert id="jp-br-05" flag="fatal" test="
      exists(cac:InvoicePeriod) or 
      exists(cac:InvoiceLine/cac:InvoicePeriod) or
      exists(cac:CreditNoteLine/cac:InvoicePeriod)
    ">
      [jp-br-05]-An Invoice shall have “Invoice period” (ibg-14) or “Invoice line period” (ibg-26).
    </assert>
  </rule>
  <!--
    Line level - period
  -->
  <rule context="cac:InvoiceLine/cac:InvoicePeriod |
      cac:CreditNoteLine/cac:InvoicePeriod">
    <!-- JP-19 -->
    <assert id="jp-br-co-04" flag="fatal" test="
      exists(cbc:StartDate) and exists(cbc:EndDate)
    ">
    [jp-br-co-04]-If INVOICE LINE PERIOD (ibg-26) is used, both the Invoice line period start date (ibt-134) and the Invoice line period end date (ibt-135) shall be filled.
    </assert>
  </rule>
  <rule context="ubl:Invoice[cac:InvoicePeriod/cbc:StartDate]/cac:InvoiceLine/cac:InvoicePeriod/cbc:StartDate |
      cn:CreditNote[cac:InvoicePeriod/cbc:StartDate]/cac:CreditNoteLine/cac:InvoicePeriod/cbc:StartDate">
    <assert id="PEPPOL-EN16931-R110" flag="fatal" test="
      xs:date(text()) &gt;= xs:date(../../../cac:InvoicePeriod/cbc:StartDate)
    ">
    [PEPPOL-EN16931-R110 (JP-20)]-Start date of line period MUST be within invoice period.
    </assert>
  </rule>
  <rule context="ubl:Invoice[cac:InvoicePeriod/cbc:EndDate]/cac:InvoiceLine/cac:InvoicePeriod/cbc:EndDate |
      cn:CreditNote[cac:InvoicePeriod/cbc:EndDate]/cac:CreditNoteLine/cac:InvoicePeriod/cbc:EndDate">
    <assert id="PEPPOL-EN16931-R111" flag="fatal" test="
      xs:date(text()) &gt;= xs:date(../../../cac:InvoicePeriod/cbc:StartDate) and
      xs:date(text()) &lt;= xs:date(../../../cac:InvoicePeriod/cbc:EndDate)
    ">
    [PEPPOL-EN16931-R111 (JP-20)]-End date of line period MUST be within invoice period.</assert>
  </rule>
  <!--
    Allowance/Charge (document and line)
  -->
  <rule context="ubl:Invoice/cac:AllowanceCharge | cn:CreditNote/cac:AllowanceCharge">
    <assert id="_jp-br-05" flag="fatal" test="
      exists(.[cbc:ChargeIndicator=false()]/cac:TaxCategory/cbc:ID[normalize-space(.)='S' or normalize-space(.)='AA']) and
      xs:decimal(.[cbc:ChargeIndicator=false()]/cac:TaxCategory/cbc:Percent) &gt; 0
    ">
    [_jp-br-05]-In a DOCUMENT LEVEL ALLOWANE (ibg-20) where the Document level allowance consumption tax category code (ibt-095) is either "Standard rate" or "Reduced rate" the Document level allowance TAX rate (ibt-096) shall be greater than zero.
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
  <rule context="ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = false()]">
    <!-- JP-04 -->
    <assert id="BR-32" flag="fatal" test="
      exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID)
    ">
    [BR-32 (JP-04)]-Each Document level allowance (BG-20) shall have a Document level allowance VAT category code (BT-95).
    </assert>
  </rule>
  <rule context="ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = true()] | cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = true()]">
    <!-- JP-05 -->
    <assert id="BR-37" flag="fatal" test="
      exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID)
    ">
    [BR-37]-Each Document level charge (BG-21) shall have a Document level charge VAT category code (BT-102).
    </assert>
  </rule>
  <!--
    Allowance (price level)
  -->
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
  <rule context="ubl:Invoice/cac:InvoiceLine | cn:CreditNote/cac:CreditNoteLine">
    <!-- JP-06 -->
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
  <!--
    TAX
  -->
  <rule context="ubl:Invoice[cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode='JP'] | 
      cn:CreditNote[cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode='JP']">
    <assert id="jp-br-co-01" flag="fatal" test="
      (
        round(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/xs:decimal(cbc:Percent)) != 0 and
        (
          xs:decimal(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount) &gt;=
          floor(xs:decimal(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount) * (cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/xs:decimal(cbc:Percent) div 100))
        ) and
        xs:decimal(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount) &lt;=
        ceiling(xs:decimal(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount) * (cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/xs:decimal(cbc:Percent) div 100))
      )
    ">
    [jp-br-co-01]-Consumption Tax category tax amount (BT-117) = Consumption Tax category taxable amount (BT-116) x (Consumption Tax category rate (BT-119) / 100), rounded to integer. The rounded result amount SHALL be between the floor and the ceiling.
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
      )
    ">
    [BR-48]-Each VAT breakdown (BG-23) shall have a VAT category rate (BT-119), except if the Invoice is Outside of scope of VAT.
    </assert>
    <!-- JP-10 -->
    <assert id="JP-10" flag="fatal" test="
      exists(cac:TaxCategory/cac:TaxScheme/cbc:ID)
    ">
    [JP-10]-Tax breakdown (ibg-23) shall hove Tax scheme (ibt-118-1).
    </assert>
  </rule>
  <!--
    Line TAX
  -->
  <rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='S' or normalize-space(cbc:ID)='AA'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] |
      cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='S' or normalize-space(cbc:ID)='AA'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
    <assert id="jp-br-co-02" flag="fatal" test="
      xs:decimal(cbc:Percent) &gt; 0
    ">
    [jp-br-co-02]-In an Invoice line (BG-25) where the Invoiced item Consumption Tax category code (BT-151) is "Standard rated" or "Reduced tate" the Invoiced item Consumption Tax rate (BT-152) shall be greater than zero.
    </assert>
  </rule>
  <!-- S: Standard rate -->
  <rule context="ubl:Invoice | cn:CreditNote">
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
      )
    ">
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
        not(
          exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='S'])
        )
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
  <rule context="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'][../cbc:TaxAmount/@currencyID='JPY']">
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
      )
    ">
    [jp-s-09]-The Consumption Tax category tax amount (BT-117) in a Consumption Tax breakdown (BG-23) where Consumption Tax category code (BT-118) is "Standard rated" shall equal the Consumption Tax category taxable amount (BT-116) multiplied by the Consumption Tax category rate (BT-119).
    </assert>
    <assert id="jp-s-10" flag="fatal" test="
      not(cbc:TaxExemptionReason) and
      not(cbc:TaxExemptionReasonCode)
    ">
    [jp-s-10]-A Consumption Tax breakdown (BG-23) with Consumption Tax Category code (BT-118) "Standard rate" shall not have a Consumption Tax exemption reason code (BT-121) or Consumption Tax exemption reason text (BT-120).
    </assert>    
  </rule>
  <!-- AA: Reduced rate -->
  <rule context="ubl:Invoice | cn:CreditNote">
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
  <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='AA'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
    <assert id="jp-aa-06" flag="fatal" test="
      xs:decimal(cbc:Percent) &gt; 0
    ">
    [jp-aa-06]-In a Document level allowance (BG-20) where the Document level allowance Consumption Tax category code (BT-95) is "Reduced rated" the Document level allowance Consumption Tax rate (BT-96) shall be greater than zero.
    </assert>
  </rule>
  <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='AA'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
    <assert id="jp-aa-07" flag="fatal" test="
      xs:decimal(cbc:Percent) &gt; 0
    ">
    [jp-aa-07]-In a Document level charge (BG-21) where the Document level charge Consumption Tax category code (BT-102) is "Reduced rated" the Document level charge Consumption Tax rate (BT-103) shall be greater than zero.
    </assert>
  </rule>
  <rule context="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID)='AA'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'][../cbc:TaxAmount/@currencyID='JPY']">
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
  <rule context="ubl:Invoice | cn:CreditNote">
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
      )
    ">
    [BR-E-01 (JP-27)]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Exempt from VAT" shall contain exactly one VAT breakdown (BG-23) with the VAT category code (BT-118) equal to "Exempt from VAT".
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
      )
    ">
    [BR-G-01 (JP-30)]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Export outside the EU" shall contain in the VAT breakdown (BG-23) exactly one VAT category code (BT-118) equal with "Export outside the EU".
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
      )
    ">
    [BR-O-01 (JP-33)]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Outside of scope of VAT" shall contain exactly one VAT breakdown group (BG-23) with the VAT category code (BT-118) equal to "Outside of scope of VAT".
    </assert>
  </rule>
  <!-- E: Exempt from VAT -->
  <rule context="//cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | 
      cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
    <assert id="BR-E-05" flag="fatal" test="
      xs:decimal(cbc:Percent) = 0
    ">
    [BR-E-05 (JP-28)]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Exempt from VAT", the Invoiced item VAT rate (BT-152) shall be 0 (zero).</assert>
  </rule>
  <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
    <assert id="BR-E-06" flag="fatal" test="
      xs:decimal(cbc:Percent) = 0
    ">
    [BR-E-06 (JP-28)]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Exempt from VAT", the Document level allowance VAT rate (BT-96) shall be 0 (zero).
    </assert>
  </rule>
  <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
    <assert id="BR-E-07" flag="fatal" test="
      xs:decimal(cbc:Percent) = 0
    ">
    [BR-E-07 (JP-28)]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Exempt from VAT", the Document level charge VAT rate (BT-103) shall be 0 (zero).
    </assert>
  </rule>
  <rule context="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
    <assert id="BR-E-09" flag="fatal" test="
      xs:decimal(../cbc:TaxAmount) = 0
    ">
    [BR-E-09 (JP-29)]-The VAT category tax amount (BT-117) In a VAT breakdown (BG-23) where the VAT category code (BT-118) equals "Exempt from VAT" shall equal 0 (zero).</assert>
  </rule>
  <!-- G: Export outside the EU" -->
  <rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | 
      cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
    <assert id="BR-G-05" flag="fatal" test="
      xs:decimal(cbc:Percent) = 0
    ">
    [BR-G-05 (JP-31)]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Export outside the EU" the Invoiced item VAT rate (BT-152) shall be 0 (zero).
    </assert>
  </rule>
  <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
    <assert id="BR-G-06" flag="fatal" test="
      xs:decimal(cbc:Percent) = 0
    ">
    [BR-G-06 (JP-31)]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Export outside the EU" the Document level allowance VAT rate (BT-96) shall be 0 (zero).
    </assert>
  </rule>
  <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
    <assert id="BR-G-07" flag="fatal" test="
      xs:decimal(cbc:Percent) = 0
    ">
    [BR-G-07 (JP-31)]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Export outside the EU" the Document level charge VAT rate (BT-103) shall be 0 (zero).
    </assert>
  </rule>
  <rule context="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
    <assert id="BR-G-09" flag="fatal" test="
      xs:decimal(../cbc:TaxAmount) = 0
    ">
    [BR-G-09 (JP-32)]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Export outside the EU" shall be 0 (zero).
    </assert>
  </rule>
  <!-- O: Outside of scope of VAT -->
  <rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | 
      cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
    <assert id="BR-O-05" flag="fatal" test="
      not(cbc:Percent)
    ">
    [BR-O-05 (JP-34)]-An Invoice line (BG-25) where the VAT category code (BT-151) is "Outside of scope of VAT" shall not contain an Invoiced item VAT rate (BT-152).
    </assert>
  </rule>
  <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
    <assert id="BR-O-06" flag="fatal" test="
      not(cbc:Percent)
    ">
    [BR-O-06 (JP-34)]-A Document level allowance (BG-20) where VAT category code (BT-95) is "Outside of scope of VAT" shall not contain a Document level allowance VAT rate (BT-96).
    </assert>
  </rule>
  <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
    <assert id="BR-O-07" flag="fatal" test="
    not(cbc:Percent)
    ">
    [BR-O-07 (JP-34)]-A Document level charge (BG-21) where the VAT category code (BT-102) is "Outside of scope of VAT" shall not contain a Document level charge VAT rate (BT-103).
    </assert>
  </rule>
  <rule context="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
    <assert id="BR-O-09" flag="fatal" test="
      xs:decimal(../cbc:TaxAmount) = 0
    ">
    [BR-O-09(JP-35)]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Outside of scope of VAT" shall be 0 (zero).
    </assert>
  </rule>
  <!-- Document total -->
  <rule context="ubl:Invoice | cn:CreditNote">
    <assert id="jp-ibr-53" flag="fatal" test="
      every $taxcurrency in cbc:TaxCurrencyCode satisfies (
        exists(//cac:TaxTotal/cbc:TaxAmount[@currencyID=$taxcurrency])
      )
    ">
    [jp-ibr-53]-If the Tax accounting currency code (ibt-006) is present, then the Invoice total Tax amount in accounting currency (ibt-111) shall be provided.
    </assert>
    <assert id="jp-ibr-co-15" flag="fatal" test="
      (
        not(exists(cac:LegalMonetaryTotal/xs:decimal(cbc:TaxInclusiveAmount[@currencyID='JPY'])))
      ) or (
        cac:LegalMonetaryTotal/xs:decimal(cbc:TaxInclusiveAmount[@currencyID='JPY']) = 
        cac:LegalMonetaryTotal/xs:decimal(cbc:TaxExclusiveAmount[@currencyID='JPY']) + cac:TaxTotal/xs:decimal(cbc:TaxAmount[@currencyID='JPY'])
      )
    ">
    [jp-ibr-co-15]-Invoice total amount with Tax (ibt-112) = Invoice total amount without Tax (ibt-109) + Invoice total Tax amount (ibt-110).
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
      )
    ">
    [ibr-co-25]-In case the Amount due for payment (ibt-115) is positive, either the Payment due date (ibt-009) or the Payment terms (ibt-020) shall be present.
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
      )
    ">
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
      )
    ">
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
      )
    ">
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
      )
    ">
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
      )
    ">
    [ibr-co-16]-Amount due for payment (ibt-115) = Invoice total amount with Tax (ibt-112) - Paid amount (ibt-113) + Rounding amount (ibt-114).
    </assert>
  </rule>
  <!-- Payment -->
  <!-- Additonal document reference -->
  <!-- Line level -->
  <rule context="ubl:InvoiceLine">
    <!-- JP-06 -->
    <assert id="BR-CO-04" flag="fatal" test="
      cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/(normalize-space(upper-case(cbc:ID))='VAT')]/cbc:ID
    ">
    [BR-CO-04]-Each Invoice line (BG-25) shall be categorized with an Invoiced item VAT category code (BT-151).
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
      if (ubl:Invoice) then
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
  <!-- Price -->
  <rule context="cac:Price/cbc:BaseQuantity[@unitCode]">
    <let name="hasQuantity" value="
      exists(../../cbc:InvoicedQuantity) or exists(../../cbc:CreditedQuantity)
    "/>
    <let name="quantity" value="
      if (../../cbc:InvoicedQuantity) then ../../cbc:InvoicedQuantity else ../../cbc:CreditedQuantity
    "/>
    <assert id="PEPPOL-EN16931-R130" flag="fatal" test="
      not($hasQuantity) or @unitCode = $quantity/@unitCode
    ">
      [EPPOL-EN16931-R130]-Unit code of price base quantity MUST be same as invoiced quantity.
    </assert>
  </rule>

</pattern>
<?xml version="1.0" encoding="UTF-8"?>
<pattern id="JP-Codesmodel">
  <rule context="cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode">
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
      )
    ">
      [jp-cl-01]-The document type code MUST be coded by the Japanese invoice and Japanese credit note related code lists of UNTDID 1001.
    </assert>
  </rule>
  <rule context="cac:PaymentMeans/cbc:PaymentMeansCode">
    <assert id="jp-cl-02" flag="fatal" test="
      (
        (
          not(contains(normalize-space(.),' ')) and
          contains( ' 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 70 74 75 76 77 78 91 92 93 94 95 96 97 ZZZ Z01 Z02 ',concat(' ',normalize-space(.),' '))
        )
      )
    ">
    [jp-cl-02]-Payment means in a Japanese invoice MUST be coded using a restricted version of the UNCL4461 code list (adding Z01 and Z02)
    </assert>
  </rule>
  <rule context="cac:TaxCategory/cbc:ID | cac:ClassifiedTaxCategory/cbc:ID">
    <assert id="jp-cl-03" flag="fatal" test="
      (
        (
          not(contains(normalize-space(.),' ')) and
          contains( ' AA S Z G O E ',concat(' ',normalize-space(.),' '))
        )
      )
    ">
      [jp-cl-03]- Japanese invoice tax categories MUST be coded using UNCL5305 code list
    </assert>
  </rule>  
  <rule context="cbc:TaxExemptionReasonCode">
    <assert id="jp-cl-04" flag="fatal" test="
      (
        (
          not(contains(normalize-space(.), ' ')) and
          contains(' ZZZ ', concat(' ', normalize-space(upper-case(.)), ' '))
        )
      )
    ">
      [jp-cl-04]-Tax exemption reason code identifier scheme identifier MUST belong to the ????</assert>
  </rule>
  <!-- Validation of ICD -->
  <rule context="cbc:EndpointID[@schemeID = '0088'] |
      cac:PartyIdentification/cbc:ID[@schemeID = '0088'] |
      cbc:CompanyID[@schemeID = '0088']">
    <assert id="PEPPOL-COMMON-R040" flag="fatal" test="
      matches(normalize-space(), '^[0-9]+$') and 
      u:gln(normalize-space())
    ">
      [PEPPOL-COMMON-R040(JP-36)]-GLN must have a valid format according to GS1 rules.</assert>
  </rule>
</pattern>
