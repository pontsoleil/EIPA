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
  <phase id="Japanmodel_phase">
    <active pattern="UBL-model"/>
  </phase>
  <phase id="codelist_phase">
    <active pattern="Codesmodel"/>
  </phase>
  <pattern id="UBL-model">
    <rule context="/ubl:Invoice[cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode='JP' ]/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='CT']">
      <assert id="jp-br-01" flag="fatal" test="matches(normalize-space(cbc:CompanyID),'^T[0-9]{13}$')">[jp-br-01]- For the Japanese Suppliers, the Tax identifier must start with 'T' and must be 13 digits.</assert>
      <assert id="jp-s-01" flag="fatal" test="((count(//cac:AllowanceCharge/cac:TaxCategory[cbc:ID/normalize-space(.)='S']) + count(//cac:ClassifiedTaxCategory[cbc:ID/normalize-space(.)='S'])) &gt; 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:ID/normalize-space(.)='S']) &gt; 0) or ((count(//cac:AllowanceCharge/cac:TaxCategory[cbc:ID/normalize-space(.)='S']) + count(//cac:ClassifiedTaxCategory[cbc:ID/normalize-space(.)='S'])) = 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:ID/normalize-space(.)='S']) = 0)">[jp-s-01]-An Invoice that contains an Invoice line (IBG-25), a Document level allowance (IBG-20) or a Document level charge (IBG-21) where the Consumption Tax category code (IBT-151, IBT-95 or BT-102) is "Standard rated" shall contain in the Consumption Tax breakdown (IBG-23) at least one Consumption Tax category code (IBT-118) equal with "Standard rated".</assert>
      <assert id="jp-s-01aa" flag="fatal" test="((count(//cac:AllowanceCharge/cac:TaxCategory[cbc:ID/normalize-space(.)='AA']) + count(//cac:ClassifiedTaxCategory[cbc:ID/normalize-space(.)='AA'])) &gt; 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:ID/normalize-space(.)='AA']) &gt; 0) or ((count(//cac:AllowanceCharge/cac:TaxCategory[cbc:ID/normalize-space(.)='AA']) + count(//cac:ClassifiedTaxCategory[cbc:ID/normalize-space(.)='AA'])) = 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:ID/normalize-space(.)='AA']) = 0)">[jp-s-01aa]-An Invoice that contains an Invoice line (IBG-25), a Document level allowance (IBG-20) or a Document level charge (IBG-21) where the Consumption Tax category code (IBT-151, IBT-95 or BT-102) is "Standard rated" shall contain in the Consumption Tax breakdown (IBG-23) at least one Consumption Tax category code (IBT-118) equal with "Standard rated".</assert>
      <assert id="jp-s-02" flag="fatal" test="(exists(//cac:ClassifiedTaxCategory[cbc:ID/normalize-space(.)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID))">[jp-s-02]-An Invoice that contains an Invoice line (IBG-25) where the Invoiced item Consumption Tax category code (IBT-151) is "Standard rated" shall contain the Seller Consumption Tax Identifier (IBT-31), the Seller tax registration identifier (IBT-32) and/or the Seller tax representative Consumption Tax identifier (IBT-63).</assert>
      <assert id="jp-s-02aa" flag="fatal" test="(exists(//cac:ClassifiedTaxCategory[cbc:ID/normalize-space(.)='AA'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID))='VAT')]/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[cbc:ID/normalize-space(.)='S']))">[jp-s-02]-An Invoice that contains an Invoice line (IBG-25) where the Invoiced item Consumption Tax category code (IBT-151) is "Standard rated" shall contain the Seller Consumption Tax Identifier (IBT-31), the Seller tax registration identifier (IBT-32) and/or the Seller tax representative Consumption Tax identifier (IBT-63).</assert>
      <assert id="jp-s-03" flag="fatal" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[cbc:ID/normalize-space(.)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID))='VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[cbc:ID/normalize-space(.)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">[jp-s-03]-An Invoice that contains a Document level allowance (IBG-20) where the Document level allowance Consumption Tax category code (IBT-95) is "Standard rated" shall contain the Seller Consumption Tax Identifier (IBT-31), the Seller tax registration identifier (IBT-32) and/or the Seller tax representative Consumption Tax identifier (IBT-63).</assert>
      <assert id="jp-s-04" flag="fatal" test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[cbc:ID/normalize-space(.)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID))='VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[cbc:ID/normalize-space(.)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">[jp-s-04]-An Invoice that contains a Document level charge (IBG-21) where the Document level charge Consumption Tax category code (IBT-102) is "Standard rated" shall contain the Seller Consumption Tax Identifier (IBT-31), the Seller tax registration identifier (IBT-32) and/or the Seller tax representative Consumption Tax identifier (IBT-63).</assert>
    </rule>
    <rule context="/ubl:Invoice[cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode='JP' ]">
      <assert id="jp-br-co-01" flag="fatal" test="(     round(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/xs:decimal(cbc:Percent)) != 0 and (     xs:decimal(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount) &gt;= floor(xs:decimal(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount) * (cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/xs:decimal(cbc:Percent) div 100)))     and (     xs:decimal(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount) &lt;= ceiling(xs:decimal(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount) * (cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/xs:decimal(cbc:Percent) div 100)))     )">[jp-br-co-01]-Consumption Tax category tax amount (IBT-117) = Consumption Tax category taxable amount (IBT-116) x (Consumption Tax category rate (IBT-119) / 100), rounded to integer. The rounded result amount SHALL be between the floor and the ceiling.</assert>
    </rule>
    <rule context="ubl:Invoice/*[local-name()!='InvoiceLine']/*[@currencyID='JPY'] | ubl:Invoice/*[local-name()!='InvoiceLine']/*/*[@currencyID='JPY'] | //cac:InvoiceLine/cbc:LineExtensionAmount[@currencyID='JPY']">
      <assert id="jp-br-02" flag="fatal" test="matches(normalize-space(.),'^-?[1-9][0-9]*$')">[jp-br-02]- Amount shall be integer.</assert>
    </rule>
    <rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[cbc:ID/normalize-space(.)='S' or cbc:ID/normalize-space(.)='AA'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[cbc:ID/normalize-space(.)='S' or cbc:ID/normalize-space(.)='AA'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="jp-s-05" flag="fatal" test="(cbc:Percent) &gt; 0">[jp-s-05]-In an Invoice line (IBG-25) where the Invoiced item Consumption Tax category code (IBT-151) is "Standard rated" or "Reduced rate" the Invoiced item Consumption Tax rate (IBT-152) shall be greater than zero.</assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[cbc:ID/normalize-space(.)='S' or cbc:ID/normalize-space(.)='AA'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="jp-s-06" flag="fatal" test="(cbc:Percent) &gt; 0">[jp-s-06]-In a Document level allowance (IBG-20) where the Document level allowance Consumption Tax category code (IBT-95) is "Standard rated" or "Reduced rate" the Document level allowance Consumption Tax rate (IBT-96) shall be greater than zero.</assert>
    </rule>
    <rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[cbc:ID/normalize-space(.)='S' or cbc:ID/normalize-space(.)='AA'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="jp-s-07" flag="fatal" test="(cbc:Percent) &gt; 0">[jp-s-07]-In a Document level charge (IBG-21) where the Document level charge Consumption Tax category code (IBT-102) is "Standard rated" or "Reduced rate" the Document level charge Consumption Tax rate (IBT-103) shall be greater than zero.  </assert>
    </rule>
    <rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:ID/normalize-space(.)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="jp-s-08s" flag="fatal" test="every $rate in xs:decimal(cbc:Percent) satisfies (
        (
			exists(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/cbc:ID/normalize-space(.)='S'][cac:Item/cac:ClassifiedTaxCategory/cbc:Percent/xs:decimal(.)=$rate]/cbc:LineExtensionAmount/xs:decimal(.)) or
			exists(../../../cac:AllowanceCharge[cac:TaxCategory/cbc:ID/normalize-space(.)='S'][cac:TaxCategory/cbc:Percent/xs:decimal(.)=$rate])
        ) and (
			../cbc:TaxableAmount/xs:decimal(.) = sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/cbc:ID/normalize-space(.)='S'][cac:Item/cac:ClassifiedTaxCategory/cbc:Percent/xs:decimal(.)=$rate]/cbc:LineExtensionAmount/xs:decimal(.)) +
			sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/cbc:ID/normalize-space(.)='S'][cac:TaxCategory/cbc:Percent/xs:decimal(.)=$rate]/cbc:Amount/xs:decimal(.)) - 
			sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/cbc:ID/normalize-space(.)='S'][cac:TaxCategory/cbc:Percent/xs:decimal(.)=$rate]/cbc:Amount/xs:decimal(.))
        )
      )">
        [jp-s-08s]-For each different value of Consumption Tax category rate (IBT-119) where the Consumption Tax category code (IBT-118) is "Standard rated", the Consumption Tax category taxable amount (IBT-116) in a Consumption Tax breakdown (IBG-23) shall equal the sum of Invoice line net amounts (IBT-131) plus the sum of document level charge amounts (IBT-99) minus the sum of document level allowance amounts (IBT-92) where the Consumption Tax category code (IBT-151, IBT-102, IBT-95) is "Standard rated" and the Consumption Tax rate (IBT-152, IBT-103, IBT-96) equals the Consumption Tax category rate (IBT-119).
      </assert>
      <assert id="jp-s-09s" flag="fatal" test="
          ../cbc:TaxAmount/xs:decimal(.) &lt;= ceiling(../cbc:TaxableAmount/xs:decimal(.) * (xs:decimal(cbc:Percent) div 100)) and
          ../cbc:TaxAmount/xs:decimal(.) &gt;= floor(../cbc:TaxableAmount/xs:decimal(.) * (xs:decimal(cbc:Percent) div 100))">
        [jp-s-09s]-The Consumption Tax category tax amount (IBT-117) in a Consumption Tax breakdown (IBG-23) where Consumption Tax category code (IBT-118) is "Standard rated" shall equal the Consumption Tax category taxable amount (IBT-116) multiplied by the Consumption Tax category rate (IBT-119).
      </assert>
    </rule>
	<rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:ID/normalize-space(.)='AA'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
      <assert id="jp-s-08aa" flag="fatal" test="every $rate in xs:decimal(cbc:Percent) satisfies (
        (
			exists(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/cbc:ID/normalize-space(.)='AA'][cac:Item/cac:ClassifiedTaxCategory/cbc:Percent/xs:decimal(.)=$rate]/cbc:LineExtensionAmount/xs:decimal(.)) or
			exists(../../../cac:AllowanceCharge[cac:TaxCategory/cbc:ID/normalize-space(.)='AA'][cac:TaxCategory/cbc:Percent/xs:decimal(.)=$rate])
        ) and (
			../cbc:TaxableAmount/xs:decimal(.) = sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/cbc:ID/normalize-space(.)='AA'][cac:Item/cac:ClassifiedTaxCategory/cbc:Percent/xs:decimal(.)=$rate]/cbc:LineExtensionAmount/xs:decimal(.)) +
			sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/cbc:ID/normalize-space(.)='AA'][cac:TaxCategory/cbc:Percent/xs:decimal(.)=$rate]/cbc:Amount/xs:decimal(.)) - 
			sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/cbc:ID/normalize-space(.)='AA'][cac:TaxCategory/cbc:Percent/xs:decimal(.)=$rate]/cbc:Amount/xs:decimal(.))
        )
      )">
        [jp-s-08aa]-For each different value of Consumption Tax category rate (IBT-119) where the Consumption Tax category code (IBT-118) is "Standard rated", the Consumption Tax category taxable amount (IBT-116) in a Consumption Tax breakdown (IBG-23) shall equal the sum of Invoice line net amounts (IBT-131) plus the sum of document level charge amounts (IBT-99) minus the sum of document level allowance amounts (IBT-92) where the Consumption Tax category code (IBT-151, IBT-102, IBT-95) is "Standard rated" and the Consumption Tax rate (IBT-152, IBT-103, IBT-96) equals the Consumption Tax category rate (IBT-119).
      </assert>
      <assert id="jp-s-09aa" flag="fatal" test="
          ../cbc:TaxAmount/xs:decimal(.) &lt;= ceiling(../cbc:TaxableAmount/xs:decimal(.) * (xs:decimal(cbc:Percent) div 100)) and
          ../cbc:TaxAmount/xs:decimal(.) &gt;= floor(../cbc:TaxableAmount/xs:decimal(.) * (xs:decimal(cbc:Percent) div 100))">
        [jp-s-09aa]-The Consumption Tax category tax amount (IBT-117) in a Consumption Tax breakdown (IBG-23) where Consumption Tax category code (IBT-118) is "Standard rated" shall equal the Consumption Tax category taxable amount (IBT-116) multiplied by the Consumption Tax category rate (IBT-119).
      </assert>
    </rule>
    <rule context="cac:LegalMonetaryTotal">
      <assert id="ibr-12" flag="fatal" test="exists(cbc:LineExtensionAmount)">[ibr-12]-An Invoice shall have the Sum of Invoice line net amount (iIBT-106).</assert>
      <assert id="ibr-13" flag="fatal" test="exists(cbc:TaxExclusiveAmount)">[ibr-13]-An Invoice shall have the Invoice total amount without Tax (iIBT-109).</assert>
      <assert id="ibr-14" flag="fatal" test="exists(cbc:TaxInclusiveAmount)">[ibr-14]-An Invoice shall have the Invoice total amount with Tax (iIBT-112).</assert>
      <assert id="ibr-15" flag="fatal" test="exists(cbc:PayableAmount)">[ibr-15]-An Invoice shall have the Amount due for payment (iIBT-115).</assert>
      <assert id="ibr-co-10" flag="fatal" test="(cbc:LineExtensionAmount/xs:decimal(.) = sum(//(cac:InvoiceLine|cac:CreditNoteLine)/cbc:LineExtensionAmount/xs:decimal(.)))">
      [ibr-co-10]-Sum of Invoice line net amount (iIBT-106) = Σ Invoice line net amount (iIBT-131).
      </assert>
      <assert id="ibr-co-11" flag="fatal" test="cbc:AllowanceTotalAmount/xs:decimal(.) = sum(../cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cbc:Amount/xs:decimal(.)) or
		(not(cbc:AllowanceTotalAmount) and not(../cac:AllowanceCharge[cbc:ChargeIndicator=false()]))">
		[ibr-co-11]-Sum of allowances on document level (iIBT-107) = Σ Document level allowance amount (iIBT-092).
		</assert>
		<assert id="ibr-co-12" flag="fatal" test="cbc:ChargeTotalAmount/xs:decimal(.) = sum(../cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cbc:Amount/xs:decimal(.)) or 
		(not(cbc:ChargeTotalAmount) and not(../cac:AllowanceCharge[cbc:ChargeIndicator=true()]))">
		[ibr-co-12]-Sum of charges on document level (iIBT-108) = Σ Document level charge amount (iIBT-099).
		</assert>
      <assert id="ibr-co-13" flag="fatal" test="((cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = cbc:LineExtensionAmount/xs:decimal(.) + xs:decimal(cbc:ChargeTotalAmount) - xs:decimal(cbc:AllowanceTotalAmount)))  or (not(cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = cbc:LineExtensionAmount/xs:decimal(.) - xs:decimal(cbc:AllowanceTotalAmount))) or ((cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = cbc:LineExtensionAmount/xs:decimal(.) + xs:decimal(cbc:ChargeTotalAmount))) or (not(cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = cbc:LineExtensionAmount/xs:decimal(.)))">[ibr-co-13]-Invoice total amount without Tax (iIBT-109) = Σ Invoice line net amount (iIBT-131) - Sum of allowances on document level (iIBT-107) + Sum of charges on document level (iIBT-108).</assert>
      <assert id="ibr-co-16" flag="fatal" test="(xs:decimal(cbc:PrepaidAmount) and not(xs:decimal(cbc:PayableRoundingAmount)) and (xs:decimal(cbc:PayableAmount) = xs:decimal(cbc:TaxInclusiveAmount) - xs:decimal(cbc:PrepaidAmount))) or (not(xs:decimal(cbc:PrepaidAmount)) and not(xs:decimal(cbc:PayableRoundingAmount)) and xs:decimal(cbc:PayableAmount) = xs:decimal(cbc:TaxInclusiveAmount)) or (xs:decimal(cbc:PrepaidAmount) and xs:decimal(cbc:PayableRoundingAmount) and ((xs:decimal(cbc:PayableAmount) - xs:decimal(cbc:PayableRoundingAmount)) = xs:decimal(cbc:TaxInclusiveAmount) - xs:decimal(cbc:PrepaidAmount))) or (not(xs:decimal(cbc:PrepaidAmount)) and xs:decimal(cbc:PayableRoundingAmount) and ((xs:decimal(cbc:PayableAmount) - xs:decimal(cbc:PayableRoundingAmount)) = xs:decimal(cbc:TaxInclusiveAmount)))">[ibr-co-16]-Amount due for payment (iIBT-115) = Invoice total amount with Tax (iIBT-112) - Paid amount (iIBT-113) + Rounding amount (iIBT-114).</assert>
    </rule>
  </pattern>
  <pattern id="Codesmodel">
    <rule flag="fatal" context="cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode">
      <assert id="jp-cl-01" flag="fatal" test="(self::cbc:InvoiceTypeCode and ((not(contains(normalize-space(.), ' ')) and contains(' 80 82 84 380 383 386 393 395 575 623 780 ', concat(' ', normalize-space(.), ' '))))) or (self::cbc:CreditNoteTypeCode and ((not(contains(normalize-space(.), ' ')) and contains(' 81 83 381 396 532 ', concat(' ', normalize-space(.), ' ')))))">[jp-cl-01]-The document type code MUST be coded by the Japanese invoice and Japanese credit note related code lists of UNTDID 1001.</assert>
    </rule>
    <rule flag="fatal" context="cac:PaymentMeans/cbc:PaymentMeansCode">
      <assert id="jp-cl-02" flag="fatal" test="( ( not(contains(normalize-space(.),' ')) and contains( ' 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 70 74 75 76 77 78 91 92 93 94 95 96 97 ZZZ Z01 Z02 ',concat(' ',normalize-space(.),' ') ) ) )">[jp-cl-02]-Payment means in a Japanese invoice MUST be coded using a restricted version of the UNCL4461 code list (adding Z01 and Z02)</assert>
    </rule>
    <rule flag="fatal" context="cac:TaxCategory/cbc:ID | cac:ClassifiedTaxCategory/cbc:ID">
      <assert id="jp-cl-03" flag="fatal" test="( ( not(contains(normalize-space(.),' ')) and contains( ' AA S Z G O E ',concat(' ',normalize-space(.),' ') ) ) )">[jp-cl-03]- Japanese invoice tax categories MUST be coded using UNCL5305 code list</assert>
    </rule>
    <rule flag="fatal" context="cbc:TaxExemptionReasonCode">
      <assert id="jp-cl-04" flag="fatal" test="((not(contains(normalize-space(.), ' ')) and contains(' ZZZ ', concat(' ', normalize-space(upper-case(.)), ' '))))">[jp-cl-04]-Tax exemption reason code identifier scheme identifier MUST belong to the ????</assert>
    </rule>
  </pattern>
</schema>