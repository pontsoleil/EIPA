<!--
     
     Licensed under MIT License
     
-->
<!-- Schematron binding rules edited by Sambuichi Professional Engineers Office -->
<!-- Data binding to UBL syntax for JP-model -->
<!-- Timestamp: 2021-11-01 14:25:00 +0900 -->
<pattern xmlns="http://purl.oclc.org/dsdl/schematron" is-a="JP-model" id="JP-PINT-model">
  <!-- Japanese ruleset -->
  <param name="jp-br-01" value="matches(normalize-space(cac:Party/cac:PartyTaxScheme/cbc:CompanyID),'^T[0-9]{13}$')"/>
  <param name="jp-br-02" value="matches(normalize-space(.),'^-?[1-9][0-9]*$')"/>
  <param name="jp-br-03" value="exists(cac:TaxScheme[normalize-space(upper-case(cbc:ID))='VAT'])"/>
  <param name="jp-br-04" value="exists(cac:Party/cac:PartyTaxScheme/cbc:CompanyID)"/>
  <param name="jp-br-05" value="(
      exists(cac:InvoicePeriod) or
      exists(cac:InvoiceLine/cac:InvoicePeriod) or
      exists(cac:CredotNoteLine/cac:InvoicePeriod)
    )"/>
  <param name="jp-br-06" value="exists(cbc:StartDate) and exists(cbc:EndDate)"/>
  <param name="jp-br-07" value="exists(cbc:StartDate) and exists(cbc:EndDate)"/>
  <param name="jp-br-08" value="
    (
      xs:date(cbc:StartDate) &gt;= xs:date(../../cac:InvoicePeriod/cbc:StartDate)
    ) and (
      xs:date(cbc:EndDate) &lt;= xs:date(../../cac:InvoicePeriod/cbc:EndDate)
    )
  "/>
  <!-- jp-(s|aa)-08
  <param name="jp-br-09a" value="
    (
      exists(cbc:ChargeTotalAmount[@currencyID='JPY']) and
      exists(cbc:AllowanceTotalAmount[@currencyID='JPY']) and
      (
        xs:decimal(cbc:TaxExclusiveAmount[@currencyID='JPY']) =
        sum(cbc:LineExtensionAmount[@currencyID='JPY']) +
        xs:decimal(cbc:ChargeTotalAmount[@currencyID='JPY']) -
        xs:decimal(cbc:AllowanceTotalAmount[@currencyID='JPY'])
      )
    ) or (
      not(cbc:ChargeTotalAmount[@currencyID='JPY']) and
      exists(cbc:AllowanceTotalAmount[@currencyID='JPY']) and
      (
        xs:decimal(cbc:TaxExclusiveAmount[@currencyID='JPY']) =
        sum(cbc:LineExtensionAmount[@currencyID='JPY']) -
        xs:decimal(cbc:AllowanceTotalAmount[@currencyID='JPY'])
      )
    ) or (
      exists(cbc:ChargeTotalAmount[@currencyID='JPY']) and
      not(cbc:AllowanceTotalAmount[@currencyID='JPY']) and
      (
        xs:decimal(cbc:TaxExclusiveAmount[@currencyID='JPY']) =
        sum(cbc:LineExtensionAmount[@currencyID='JPY']) +
        xs:decimal(cbc:ChargeTotalAmount[@currencyID='JPY'])
      )
    ) or (
      not(cbc:ChargeTotalAmount) and
      not(cbc:AllowanceTotalAmount)
      and (
        xs:decimal(cbc:TaxExclusiveAmount) =
        sum(cbc:LineExtensionAmount)
      )
    )
  "/>
  -->
  <param name="jp-br-09" value="
    not(cbc:LineExtensionAmount[@currencyID='JPY']) 
    or (
      xs:decimal(cbc:LineExtensionAmountexists[@currencyID='JPY']) = 
      xs:decimal(cbc:InvoicedQuantity) * (
        xs:decimal(cac:Price/cbc:PriceAmount[@currencyID='JPY']) div xs:decimal(cac:Price/cbc:BaseQuantity)
      ) -
      sum(cac:AllowanceCharge[cbc:ChargeIndicator='false']/cbc:Amount[@currencyID='JPY']/xs:decimal(.)) +
      sum(cac:AllowanceCharge[cbc:ChargeIndicator='true']/cbc:Amount[@currencyID='JPY']/xs:decimal(.))
    )
  "/>
  <param name="jp-br-32" value="exists(cac:TaxCategory/cbc:ID) and exists(/cac:TaxCategory/cbc:Percent)"/>
  <param name="jp-br-33" value="exists(cac:TaxCategory/cbc:ID) and exists(/cac:TaxCategory/cbc:Percent)"/>
  <param name="jp-br-37" value="exists(cac:TaxCategory/cbc:ID) and exists(/cac:TaxCategory/cbc:Percent)"/>
  <param name="jp-br-38" value="exists(cac:TaxCategory/cbc:ID) and exists(/cac:TaxCategory/cbc:Percent)"/>
  <param name="jp-br-45" value="exists(cbc:TaxableAmount)"/>
  <param name="jp-br-46" value="exists(cbc:TaxAmount)"/>
  <param name="jp-br-47" value="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID)"/>
  <param name="jp-br-48" value="
    exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:Percent) or 
    (
      some $code in tokenize('O E G', '\s') satisfies cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/normalize-space(cbc:ID)=$code
    )
  "/>
  <param name="jp-br-co-01" value="
    (
      xs:decimal(child::cbc:TaxAmount[@currencyID='JPY']) =
      sum(cac:TaxSubtotal/xs:decimal(cbc:TaxAmount[@currencyID='JPY']))
    )
  "/>
  <param name="jp-br-co-02" value="
    every $taxcurrency in cbc:TaxCurrencyCode satisfies exists(//cac:TaxTotal/cbc:TaxAmount[@currencyID=$taxcurrency])
  "/>
  <param name="jp-br-co-03" value="not(.) or ./text() = 'JPY'"/>
  <param name="jp-br-co-04" value="exists(cac:ClassifiedTaxCategory/cbc:ID) and exists(cac:ClassifiedTaxCategory/cbc:Percent)"/>
  
  <!-- Tax rules-->
  <param name="jp-s-01" value="
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
  "/>
  <param name="jp-s-02" value="
    (
      exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and
      (
        exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or
        exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID))='VAT')]/cbc:CompanyID)
      )
    ) or
      not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='S']))
  "/>
  <param name="jp-s-03" value="
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
  "/>
  <param name="jp-s-04" value="
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
  "/>  
  <param name="jp-s-05" value="
    cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) &gt; 0 or 
    cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) &gt; 0
  "/>
  <param name="jp-s-06" value="
    cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) &gt; 0
  "/>
  <param name="jp-s-07" value="
    cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) &gt; 0
  "/>
  <param name="jp-s-08" value="
    (
      exists(.[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'][../cbc:TaxAmount/@currencyID='JPY'])
    ) and (
      every $rate in xs:decimal(cbc:Percent) satisfies (
        (
          not(exists(//cac:InvoiceLine/cac:Item[cbc:LineExtensionAmount/@currencyID='JPY'][cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent)=$rate])) and
          not(exists(//cac:AllowanceCharge[cbc:Amount/@currencyID='JPY'][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent)=$rate]))
        ) or (
          (
            exists(//cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent)=$rate]) or
            exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent)=$rate])
          ) and (
            xs:decimal(../cbc:TaxableAmount) =
            (
              sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent)=$rate]/xs:decimal(cbc:LineExtensionAmount[@currencyID='JPY'])) +
              sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent)=$rate]/xs:decimal(cbc:Amount[@currencyID='JPY'])) -
              sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent)=$rate]/xs:decimal(cbc:Amount[@currencyID='JPY']))
            )
          )
        )
      )
    )
  "/>
  <param name="jp-s-09" value="
    (
      (
        xs:decimal(../cbc:TaxAmount[@currencyID='JPY']) &lt;=
        ceiling(xs:decimal(../cbc:TaxableAmount[@currencyID='JPY']) * xs:decimal(cbc:Percent) div 100)
      ) and (
        xs:decimal(../cbc:TaxAmount[@currencyID='JPY']) &gt;=
        floor(xs:decimal(../cbc:TaxableAmount[@currencyID='JPY']) * xs:decimal(cbc:Percent) div 100)
      )
    )
  "/>
  <param name="jp-s-10" value="
    not(cbc:TaxExemptionReason) or
    not(cbc:TaxExemptionReasonCode)
  "/>
  <param name="jp-aa-01" value="
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
  "/>
  <param name="jp-aa-02" value="
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
  "/>
  <param name="jp-aa-03" value="
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
  "/>
  <param name="jp-aa-04" value="
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
  "/>
  <param name="jp-aa-05" value="
    cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='AA'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) &gt; 0 or 
    cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='AA'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) &gt; 0
  "/>
  <param name="jp-aa-06" value="
    cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='AA'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) &gt; 0
  "/>
  <param name="jp-aa-07" value="
    cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='AA'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) &gt; 0
  "/>
  <param name="jp-aa-08" value="
    (
      exists(.[normalize-space(cbc:ID)='AA'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'][../cbc:TaxAmount/@currencyID='JPY'])

    ) and (
      every $rate in xs:decimal(cbc:Percent) satisfies (
        (
          not(exists(//cac:InvoiceLine/cac:Item[cbc:LineExtensionAmount/@currencyID='JPY'][cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='AA'][cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent)=$rate])) and
          not(exists(//cac:AllowanceCharge[cbc:Amount/@currencyID='JPY'][cac:TaxCategory/normalize-space(cbc:ID)='AA'][cac:TaxCategory/xs:decimal(cbc:Percent)=$rate]))
        ) or (
          (
            exists(//cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='AA'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent)=$rate]) or
            exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='AA'][cac:TaxCategory/xs:decimal(cbc:Percent)=$rate])
          ) and (
            xs:decimal(../cbc:TaxableAmount[@currencyID='JPY']) =
            (
              sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='AA'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent)=$rate]/xs:decimal(cbc:LineExtensionAmount[@currencyID='JPY'])) +
              sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='AA'][cac:TaxCategory/xs:decimal(cbc:Percent)=$rate]/xs:decimal(cbc:Amount[@currencyID='JPY'])) -
              sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='AA'][cac:TaxCategory/xs:decimal(cbc:Percent)=$rate]/xs:decimal(cbc:Amount[@currencyID='JPY']))
            )
          )
        )
      )
    )
  "/>
  <param name="jp-aa-09" value="
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
  "/>
  <param name="jp-aa-10" value="
    not(cbc:TaxExemptionReason) or
    not(cbc:TaxExemptionReasonCode)
  "/>
  <param name="jp-e-01" value="
    (
      (
        count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID)='E']) +
        count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='E'])
      ) &gt; 0 and
      count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID)='E']) = 1
    ) or (
      (
        count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID)='E']) +
        count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='E'])
      ) = 0 and
      count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID)='E']) = 0
    )
  "/>
  <param name="jp-e-05" value="
    cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) = 0 and 
    cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) = 0
  "/>
  <param name="jp-e-06" value="
    cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) = 0
  "/>
  <param name="jp-e-07" value="
    cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent)  = 0
  "/>
  <param name="jp-e-09" value="
    xs:decimal(../cbc:TaxAmount[@currencyID='JPY']) = 0
  "/>
  <param name="jp-g-01" value="
    (
      (
        count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID)='G']) +
        count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='G'])
      ) &gt; 0 and
      count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID)='G']) = 1
    ) or (
      (
        count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID)='G']) +
        count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='G'])
      ) = 0 and
      count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID)='G']) = 0
    )
  "/>
  <param name="jp-g-05" value="
    cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) = 0 and 
    cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) = 0
  "/>
  <param name="jp-g-06" value="
    cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) = 0
  "/>
  <param name="jp-g-07" value="
    cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent)  = 0
  "/>
  <param name="jp-g-09" value="
    xs:decimal(../cbc:TaxAmount[@currencyID='JPY']) = 0
  "/>
  <param name="jp-o-01" value="
    (
      (
        count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID)='O']) +
        count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='O'])
      ) &gt; 0 and
      count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID)='O']) = 1
    ) or (
      (
        count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID)='O']) +
        count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='O'])
      ) = 0 and
      count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID)='O']) = 0
    )
  "/>
  <param name="jp-o-05" value="
    cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) = 0 and 
    cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) = 0
  "/>
  <param name="jp-o-06" value="
    cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) = 0
  "/>
  <param name="jp-o-07" value="
    cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent)  = 0
  "/>
  <param name="jp-o-09" value="
    xs:decimal(../cbc:TaxAmount[@currencyID='JPY']) = 0
  "/>

  <param name="Invoice" value="/ubl:Invoice | /cn:CreditNote"/>
  <param name="Date" value="cbc:IssueDate | cbc:DueDate | cbc:TaxPointDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate"/>
  <param name="Amount_data_type" value="//*[ends-with(name(), 'Amount') and not(ends-with(name(),'PriceAmount')) and not(ancestor::cac:Price/cac:AllowanceCharge)]"/>
  <param name="Price_data_type" value="//*[ends-with(name(), 'PriceAmount')]"/>
  <param name="Quantity_data_type" value="//*[ends-with(name(), 'Quantity')]"/>
  <param name="Percent_data_type" value="//*[ends-with(name(), 'Rate')]"/>
  <param name="Code_data_type" value="//*[ends-with(name(), 'Code')]"/>
  <param name="Binary_object_data_type" value="//*[ends-with(name(), 'BinaryObject')]"/>
  
  <param name="Tax_currencycode" value="cbc:TaxCurrencyCode"/>
  <param name="Invoice_Period" value="cac:InvoicePeriod"/>
  <param name="Document_totals" value="cac:LegalMonetaryTotal"/>
  <param name="Amount_due" value="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:PayableAmount "/>
  
  <param name="Seller" value="cac:AccountingSupplierParty"/>
  <param name="Accounting_supplier_party" value="cac:AccountingSupplierParty/cac:Party"/>
  <param name="Seller_electronic_address" value="cac:AccountingSupplierParty/cac:Party/cbc:EndpointID"/>
  <param name="Seller_postal_address" value="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress"/>
  <param name="Buyer_postal_address" value="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress"/>
  <param name="Deliver_to_address" value="cac:Delivery/cac:DeliveryLocation/cac:Address"/>
  <param name="Buyer_electronic_address" value="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID"/>
  <param name="VAT_identifiers " value="//cac:PartyTaxScheme[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"/>
  <param name="Tax_identifiers" value="//cac:PartyTaxScheme"/>
  <param name="Payee_Financial_Account" value="cac:PaymentMeans[cbc:PaymentMeansCode='30' or cbc:PaymentMeansCode='58']/cac:PayeeFinancialAccount"/>
  <param name="Payee" value="cac:PayeeParty"/>
  <param name="Tax_Representative_postal_address" value="cac:TaxRepresentativeParty/cac:PostalAddress"/>
  <param name="Tax_Representative" value="cac:TaxRepresentativeParty"/>
  <param name="Preceding_Invoice" value="cac:BillingReference"/>
  <param name="Payment_instructions" value="cac:PaymentMeans"/>
  <param name="Card_information" value="cac:PaymentMeans/cac:CardAccount"/>
  <param name="Additional_supporting_documents" value="cac:AdditionalDocumentReference"/>
  <param name="Embedded_Document_Binary_Object" value="cbc:EmbeddedDocumentBinaryObject"/>
  <param name="Document_level_allowances" value="/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator=false()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator=false()]"/>
  <param name="Document_level_charges" value="/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator=true()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator=true()]"/>
  <param name="Deliver_to" value="cac:Delivery"/>
  
  <param name="Invoice_Line" value="cac:InvoiceLine | cac:CreditNoteLine"/>
  <param name="Invoice_Line_Period" value="cac:InvoiceLine/cac:InvoicePeriod | cac:CreditNoteLine/cac:InvoicePeriod"/> 
  <param name="Invoice_line_allowances" value="//cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator=false()] | //cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator=false()]"/>
  <param name="Invoice_line_charges" value="//cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator=true()] | //cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator=true()]"/>
  <param name="Item_attributes" value="//cac:AdditionalItemProperty"/>
  
  <param name="Item_standard_identifier" value="cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:ID | cac:CreditNoteLine/cac:Item/cac:StandardItemIdentification/cbc:ID"/>
  <param name="Item_classification_identifier" value="cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode | cac:CreditNoteLine/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode "/>
  <param name="Note" value="/ubl:Invoice/cbc:Note | /cn:CreditNote/cbc:Note"/>
  <param name="Percent" value="(//cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent | //cac:AllowanceCharge/cac:TaxCategory/cbc:Percent)"/>
  
  <param name="Tax_Total" value="/ubl:Invoice/cac:TaxTotal | /cn:CreditNote/cac:Taxtotal"/>
  <param name="Tax_breakdown" value="cac:TaxTotal/cac:TaxSubtotal"/>
  <param name="Tax_S_breakdown_category" value="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'][../cbc:TaxAmount/@currencyID='JPY']"/>
  <param name="Tax_S_Allowance" value="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"/>
  <param name="Tax_S_Charge" value="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"/>
  <param name="Tax_S_Line" value="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"/>
  <param name="Tax_S" value="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"/>
  <param name="Tax_AA_breakdown_category" value="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID)='AA'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'][../cbc:TaxAmount/@currencyID='JPY']"/>
  <param name="Tax_AA_Allowance" value="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='AA'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"/>
  <param name="Tax_AA_Charge" value="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='AA'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"/>
  <param name="Tax_AA_Line" value="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='AA'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='AA'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"/>
  <param name="Tax_AA" value="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID)='AA'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"/>
  <param name="Tax_E_breakdown_category" value="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'][../cbc:TaxAmount/@currencyID='JPY']"/>
  <param name="Tax_E_Allowance" value="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"/>
  <param name="Tax_E_Charge" value="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"/>
  <param name="Tax_E_Line" value="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"/>
  <param name="Tax_E" value="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"/>
  <param name="Tax_G_breakdown_category" value="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'][../cbc:TaxAmount/@currencyID='JPY']"/>
  <param name="Tax_G_Allowance" value="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"/>
  <param name="Tax_G_Charge" value="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"/>
  <param name="Tax_G_Line" value="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"/>
  <param name="Tax_G" value="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"/>
  <param name="Tax_O_breakdown_category" value="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'][../cbc:TaxAmount/@currencyID='JPY']"/>
  <param name="Tax_O_Allowance" value="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"/>
  <param name="Tax_O_Charge" value="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"/>
  <param name="Tax_O_Line" value="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"/>
  <param name="Tax_O" value="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']"/>
</pattern>