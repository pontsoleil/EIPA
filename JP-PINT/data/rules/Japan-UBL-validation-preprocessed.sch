<!--

            Copyright (C) 2020-2023 OpenPEPPOL AISBL

            Licensed under the Apache License, Version 2.0 (the "License");
            you may not use this file except in compliance with the License.
            You may obtain a copy of the License at

                    http://www.apache.org/licenses/LICENSE-2.0

            Unless required by applicable law or agreed to in writing, software
            distributed under the License is distributed on an "AS IS" BASIS,
            WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
            See the License for the specific language governing permissions and
            limitations under the License.

-->
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <ns prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" />
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
  <ns prefix="qdt" uri="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2" />
  <ns prefix="udt" uri="urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2" />
  <ns prefix="cn" uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" />
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" />
  <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema" />
  <phase id="Japanmodel_phase">
    <active pattern="UBL-model" />
  </phase>
  <phase id="codelist_phase">
    <active pattern="Codesmodel" />
  </phase>
  <pattern id="UBL-model">
    <rule context="/ubl:Invoice[cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'JP' ]/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="jp-br-01" flag="fatal" test="matches(normalize-space(cbc:CompanyID),'^T[0-9]{13}$')">
      [jp-br-01]- For the Japanese Suppliers, the Tax identifier must start with 'T' and must be 13 digits.
      </assert>
      <assert id="jp-s-01" flag="fatal" test="
      (
        (count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'])) > 0 and 
        count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) > 0
      ) or 
      (
        (count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'])) = 0 and 
        count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) = 0
      )">
        [jp-s-01]-An Invoice that contains an Invoice line (ibg-25), a Document level allowance (ibg-20) or a Document level charge (ibg-21) where the Consumption Tax category code (ibt-151, ibt-095 or ibt-102) is "Standard rated" shall contain in the Consumption Tax breakdown (ibg-23) at least one Consumption Tax category code (ibt-118) equal with "Standard rated".
      </assert>
      <assert id="jp-s-02" flag="fatal" test="
      (
        exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and 
        (
          exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or 
          exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)
        )
      ) or 
      not(
        exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'])
      )">
        [jp-s-02]-An Invoice that contains an Invoice line (ibg-25) where the Invoiced item Consumption Tax category code (ibt-151) is "Standard rated" shall contain the Seller Consumption Tax Identifier (ibt-031), the Seller tax registration identifier (ibt-032) and/or the Seller tax representative Consumption Tax identifier (ibt-063).
      </assert>
      <assert id="jp-s-03" flag="fatal" test="
      (
        exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and 
        (
          exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or 
          exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)
        )
      ) or 
      not(
        exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])
      )">
        [jp-s-03]-An Invoice that contains a Document level allowance (ibg-20) where the Document level allowance Consumption Tax category code (ibt-095) is "Standard rated" shall contain the Seller Consumption Tax Identifier (ibt-031), the Seller tax registration identifier (ibt-032) and/or the Seller tax representative Consumption Tax identifier (ibt-063).
      </assert>
      <assert id="jp-s-04" flag="fatal" test="
      (
        exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and 
        (
          exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or 
          exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)
        )
      ) or 
      not(
        exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])
      )">
        [jp-s-04]-An Invoice that contains a Document level charge (ibg-21) where the Document level charge Consumption Tax category code (ibt-$1) is "Standard rated" shall contain the Seller Consumption Tax Identifier (ibt-031), the Seller tax registration identifier (ibt-032) and/or the Seller tax representative Consumption Tax identifier (ibt-063).
      </assert>
    </rule>
    <rule context="/ubl:Invoice[cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'JP' ]">
      <assert id="jp-br-co-01" flag="fatal" test="
      (
        cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/xs:decimal(cbc:Percent)) != 0 and 
        xs:decimal(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount) &gt;= floor(xs:decimal(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount) * (cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/xs:decimal(cbc:Percent) div 100))
      ) and 
      (
        xs:decimal(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount) &lt;= ceiling(xs:decimal(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount) * (cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/xs:decimal(cbc:Percent) div 100))
      )">
        [jp-br-co-01]-Consumption Tax category tax amount (ibt-117) = Consumption Tax category taxable amount (ibt-116) x (Consumption Tax category rate (ibt-119) / 100), rounded to integer. The rounded result amount SHALL be between the floor and the ceiling.
      </assert>
    </rule>
    <rule context="ubl:Invoice/*[local-name()!='InvoiceLine']/*[@currencyID='JPY'] | ubl:Invoice/*[local-name()!='InvoiceLine']/*/*[@currencyID='JPY'] | //cac:InvoiceLine/cbc:LineExtensionAmount[@currencyID='JPY']">
      <assert id="jp-br-02" flag="fatal" test="matches(normalize-space(.),'^-?(0|[1-9][0-9]*)$')">
        [jp-br-02]- Amount shall be integer.
      </assert>
    </rule>
    <rule context="/ubl:Invoice[cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'JP' ]/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="jp-s-08" flag="fatal" test="
        every $rate in xs:decimal(cbc:Percent) satisfies (
          (
            (
              exists(//cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]) or 
              exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate])
            ) and 
            (
              (
                ../xs:decimal(cbc:TaxableAmount - 1) &lt; (
                  sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount)) + 
                  sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - 
                  sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))
                )
              ) and 
              (
                ../xs:decimal(cbc:TaxableAmount + 1) &gt; (
                  sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount)) + 
                  sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - 
                  sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))
                )
              )
            )
          ) or 
          (
            exists(//cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]) or 
            exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID) = 'S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate])
          ) and 
          (
            (
              ../xs:decimal(cbc:TaxableAmount - 1) &lt; (
                sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + 
                sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - 
                sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))
              )
            ) and 
            (
              ../xs:decimal(cbc:TaxableAmount + 1) &gt; (
                sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + 
                sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - 
                sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))
              )
            )
          )
        )">
        [jp-s-08]-For each different value of Consumption Tax category rate (ibt-119) where the Consumption Tax category code (ibt-118) is "Standard rated", the Consumption Tax category taxable amount (ibt-116) in a Consumption Tax breakdown (ibg-23) shall equal the sum of Invoice line net amounts (ibt-131) plus the sum of document level charge amounts (ibt-099) minus the sum of document level allowance amounts (ibt-092) where the Consumption Tax category code (ibt-151, ibt-102, ibt-095) is "Standard rated" and the Consumption Tax rate (ibt-152, ibt-103, ibt-096) equals the Consumption Tax category rate (ibt-119).
      </assert>
      <assert id="jp-s-09" flag="fatal" test="
      (
        abs(xs:decimal(../cbc:TaxAmount)) - 1 &lt; 
        round(
          (abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10
        ) div 100 
      ) and 
      (
        abs(xs:decimal(../cbc:TaxAmount)) + 1&gt; 
        round(
          (abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10
        ) div 100 
      )">
        [jp-s-09]-The Consumption Tax category tax amount (ibt-117) in a Consumption Tax breakdown (ibg-23) where Consumption Tax category code (ibt-118) is "Standard rated" shall equal the Consumption Tax category taxable amount (ibt-116) multiplied by the Consumption Tax category rate (ibt-119).
      </assert>
      <assert id="jp-s-10" flag="fatal" test="
        not(cbc:TaxExemptionReason) and 
        not(cbc:TaxExemptionReasonCode)">
        [jp-s-10]-A Consumption Tax breakdown (ibg-23) with Consumption Tax Category code (ibt-118) "Standard rate" shall not have a Consumption Tax exemption reason code (ibt-121) or Consumption Tax exemption reason text (ibt-120).
      </assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="jp-s-06" flag="fatal" test="(cbc:Percent) > 0">
        [jp-s-06]-In a Document level allowance (ibg-20) where the Document level allowance Consumption Tax category code (ibt-095) is "Standard rated" the Document level allowance Consumption Tax rate (ibt-096) shall be greater than zero.
      </assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="jp-s-07" flag="fatal" test="(cbc:Percent) > 0">
        [jp-s-07]-In a Document level charge (ibg-21) where the Document level charge Consumption Tax category code (ibt-102) is "Standard rated" the Document level charge Consumption Tax rate (ibt-103) shall be greater than zero.
      </assert>
    </rule>
    <rule context="/ubl:Invoice[cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'JP' ]/cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | 
    /cn:CreditNote[cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'JP' ]cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="jp-s-05" flag="fatal" test="(cbc:Percent) > 0">[jp-s-05]-In an Invoice line (ibg-25) where the Invoiced item Consumption Tax category code (ibt-151) is "Standard rated" the Invoiced item Consumption Tax rate (ibt-152) shall be greater than zero.</assert>
    </rule>
  </pattern>
  <pattern id="Codesmodel">
    <rule flag="fatal" context="cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode">
      <assert id="jp-cl-01" flag="fatal" test="
      (
        self::cbc:InvoiceTypeCode and 
        (
          (
            not(contains(normalize-space(.), ' ')) and 
            contains(' 80 82 84 380 383 386 393 395 575 623 780 ', concat(' ', normalize-space(.), ' '))
          )
        )
      ) or 
      (
        self::cbc:CreditNoteTypeCode and 
        (
          (
            not(contains(normalize-space(.), ' ')) and 
            contains(' 81 83 381 396 532 ', concat(' ', normalize-space(.), ' '))
          )
        )
      )">
        [jp-cl-01]-The document type code MUST be coded by the Japanese invoice and Japanese credit note related code lists of UNTDID 1001.</assert>
    </rule>
    <rule flag="fatal" context="cac:PaymentMeans/cbc:PaymentMeansCode">
      <assert id="jp-cl-02" flag="fatal" test="
      (
        (
          not(contains(normalize-space(.),' ')) and 
          contains( ' 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 70 74 75 76 77 78 91 92 93 94 95 96 97 ZZZ Z01 Z02 ',concat(' ',normalize-space(.),' ') )
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
        [jp-cl-03]- Japanese invoice tax categories MUST be coded using UNCL5305 code list</assert>
    </rule>
    <rule flag="fatal" context="cbc:TaxExemptionReasonCode">
      <assert id="jp-cl-04" flag="fatal" test="
      (
        (
          not(contains(normalize-space(.), ' ')) and 
          contains(' ZZZ ', concat(' ', normalize-space(upper-case(.)), ' '))
        )
      )">
        [jp-cl-04]-Tax exemption reason code identifier scheme identifier MUST belong to the ????
      </assert>
    </rule>
  </pattern>
</schema>
