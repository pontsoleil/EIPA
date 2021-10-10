<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:u="utils" schemaVersion="iso" queryBinding="xslt2">
	<title>Rules for Peppol international invoice adapted to JP specification</title>
	<ns prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
	<ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
	<ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
	<ns prefix="qdt" uri="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2"/>
	<ns prefix="udt" uri="urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2"/>
	<ns prefix="cn" uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"/>
	<ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"/>
	<ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
	<!-- Parameters -->
	<let name="supplierCountry" value="
		if  (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)
			then upper-case(normalize-space(//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))
		else 'XX'"/>
	<let name="buyerCountry" value="
		if (//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) 
			then upper-case(normalize-space(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))
		else 'XX'"/>
	<let name="documentCurrencyCode" value="
		if (//cbc:DocumentCurrencyCode)
			then //cbc:DocumentCurrencyCode/normalize-space(.)
		else 'None'"/>
	<let name="taxCurrencyCode" value="
		if (//cbc:TaxCurrencyCode)
			then //cbc:TaxCurrencyCode/normalize-space(.)
		else if (//cbc:DocumentCurrencyCode)
			then //cbc:DocumentCurrencyCode/normalize-space(.)
		else 'None'"/>
		
	<!-- functions -->
	<function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:slack" as="xs:boolean">
		<param name="exp" as="xs:decimal"/>
		<param name="val" as="xs:decimal"/>
		<param name="slack" as="xs:decimal"/>
		<value-of select="xs:decimal($exp + $slack) &gt;= $val and xs:decimal($exp - $slack) &lt;= $val"/>
	</function>
	
	<phase id="Japanmodel_phase">
		<active pattern="UBL-model"/>
	</phase>
	
	<phase id="codelist_phase">
		<active pattern="Codesmodel"/>
	</phase>
	
	<pattern id="UBL-model">
		
		<rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID/normalize-space(.)='VAT']">
			<assert id="jp-br-01" flag="fatal" test="matches(cbc:CompanyID/normalize-space(.),'^T[0-9]{13}$')">
				[jp-br-01]- For the Japanese Suppliers, the Tax identifier must start with 'T' and must be 13 digits.
			</assert>	
			<assert id="jp-s-01S" flag="fatal" test="(
					(count(//cac:AllowanceCharge/cac:TaxCategory[cbc:ID/normalize-space(.)='S']) + count(//cac:ClassifiedTaxCategory[cbc:ID/normalize-space(.)='S'])) &gt; 0 and 
					count(//cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:ID/normalize-space(.)='S']) &gt; 0
				) or (
					(count(//cac:AllowanceCharge/cac:TaxCategory[cbc:ID/normalize-space(.)='S']) + count(//cac:ClassifiedTaxCategory[cbc:ID/normalize-space(.)='S'])) = 0 and 
					count(//cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:ID/normalize-space(.)='S']) = 0
				)">
				[jp-s-01S]-An Invoice that contains an Invoice line (IBG-25), a Document level allowance (IBG-20) or a Document level charge (IBG-21) where the Consumption Tax category code (IBT-151, IBT-95 or BT-102) is "Standard rated" shall contain in the Consumption Tax breakdown (IBG-23) at least one Consumption Tax category code (IBT-118) equal with "Standard rated".
			</assert>
			<assert id="jp-s-01AA" flag="fatal" test="(
					(count(//cac:AllowanceCharge/cac:TaxCategory[cbc:ID/normalize-space(.)='AA']) + count(//cac:ClassifiedTaxCategory[cbc:ID/normalize-space(.)='AA'])) &gt; 0 and 
					count(//cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:ID/normalize-space(.)='AA']) &gt; 0
				) or (
					(count(//cac:AllowanceCharge/cac:TaxCategory[cbc:ID/normalize-space(.)='AA']) + count(//cac:ClassifiedTaxCategory[cbc:ID/normalize-space(.)='AA'])) = 0 and 
					count(//cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:ID/normalize-space(.)='AA']) = 0
				)">
				[jp-s-01AA]-An Invoice that contains an Invoice line (IBG-25), a Document level allowance (IBG-20) or a Document level charge (IBG-21) where the Consumption Tax category code (IBT-151, IBT-95 or BT-102) is "Reduced rated" shall contain in the Consumption Tax breakdown (IBG-23) at least one Consumption Tax category code (IBT-118) equal with "Reduced rated".
			</assert>
			<assert id="jp-s-02s" flag="fatal" test="
				(exists(//cac:ClassifiedTaxCategory[cbc:ID/normalize-space(.)='S'][cac:TaxScheme/cbc:ID/normalize-space(.)='VAT']) and 
					exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID))">
				[jp-s-02s]-An Invoice that contains an Invoice line (IBG-25) where the Invoiced item Consumption Tax category code (IBT-151) is "Standard rated" shall contain the Seller Consumption Tax Identifier (IBT-31).
			</assert>
			<assert id="jp-s-02aa" flag="fatal" test="
				(exists(//cac:ClassifiedTaxCategory[cbc:ID/normalize-space(.)='AA'][cac:TaxScheme/cbc:ID/normalize-space(.)='VAT']) and 
					(exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or 
						exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(cbc:ID/normalize-space(.)='VAT')]/cbc:CompanyID))
				) or not(exists(//cac:ClassifiedTaxCategory[cbc:ID/normalize-space(.)='S']))">
				[jp-s-02aa]-An Invoice that contains an Invoice line (IBG-25) where the Invoiced item Consumption Tax category code (IBT-151) is "Standard rated" or "Reduced rate" shall contain the Seller Consumption Tax Identifier (IBT-31).
			</assert>
			<assert id="jp-s-03" flag="fatal" test="
				(
					exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[cbc:ID/normalize-space(.)='S' or cbc:ID/normalize-space(.)='AA'][cac:TaxScheme/cbc:ID/normalize-space(.)='VAT']) and 
					(
						exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or 
						exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(cbc:ID/normalize-space(.)='VAT')]/cbc:CompanyID)
					)
				) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[cbc:ID/normalize-space(.)='S' or cbc:ID/normalize-space(.)='AA'][cac:TaxScheme/cbc:ID/normalize-space(.)='VAT'])
				)">
				[jp-s-03]-An Invoice that contains a Document level allowance (IBG-20) where the Document level allowance Consumption Tax category code (IBT-95) is "Reduced rated" shall contain the Seller Consumption Tax Identifier (IBT-31), the Seller tax registration identifier (IBT-32) and/or the Seller tax representative Consumption Tax identifier (IBT-63).
			</assert>
			<assert id="jp-s-04" flag="fatal" test="
				(
					exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[cbc:ID/normalize-space(.)='S' or cbc:ID/normalize-space(.)='AA'][cac:TaxScheme/cbc:ID/normalize-space(.)='VAT']) and
					(
						exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or
						exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(cbc:ID/normalize-space(.)='VAT')]/cbc:CompanyID)
					)
				) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[cbc:ID/normalize-space(.)='S' or cbc:ID/normalize-space(.)='AA'][cac:TaxScheme/cbc:ID/normalize-space(.)='VAT'])
				)">
				[jp-s-04]-An Invoice that contains a Document level charge (IBG-21) where the Document level charge Consumption Tax category code (IBT-102) is "Reduced rated" shall contain the Seller Consumption Tax Identifier (IBT-31), the Seller tax registration identifier (IBT-32) and/or the Seller tax representative Consumption Tax identifier (IBT-63).
			</assert>
		</rule>
		
		<rule context="/ubl:Invoice/cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[cbc:ID/normalize-space(.)='S' or cbc:ID/normalize-space(.)='AA'][cac:TaxScheme/cbc:ID/normalize-space(.)='VAT'] | //cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[cbc:ID/normalize-space(.)='S' or cbc:ID/normalize-space(.)='AA'][cac:TaxScheme/cbc:ID/normalize-space(.)='VAT']">
			<assert id="jp-s-05" flag="fatal" test="(cbc:Percent) &gt; 0">
				[jp-s-05]-In an Invoice line (IBG-25) where the Invoiced item Consumption Tax category code (IBT-151) is "Standard rated" or "Reduced rate" the Invoiced item Consumption Tax rate (IBT-152) shall be greater than zero.
			</assert>
		</rule>
		<rule context="/ubl:Invoice">
			<assert id="jp-s-p6a" test="exists(cac:InvoicePeriod) or exists(cac:InvoiceLine/cac:InvoicePeriod)">
				[jp-s-p6a]-An Invoice shall have “INVOICE PERIOD”（ibg-14）or “INVOICE LIEN PERIOD”（ibg-26).
			</assert>
		</rule>

		<rule context="cac:InvoicePeriod">
			<assert id="ibr-29" flag="fatal" test="(exists(cbc:EndDate) and exists(cbc:StartDate) and xs:date(cbc:EndDate) >= xs:date(cbc:StartDate)) or not(exists(cbc:StartDate)) or not(exists(cbc:EndDate))">
				[ibr-29]-If both Invoicing period start date (iibt-073) and Invoicing period end date (iibt-074) are given then the Invoicing period end date (iibt-074) shall be later or equal to the Invoicing period start date (iibt-073).
			</assert>
			<assert id="ibr-co-19" flag="fatal" test="exists(cbc:StartDate) or exists(cbc:EndDate) or (exists(cbc:DescriptionCode) and not(exists(cbc:StartDate)) and not(exists(cbc:EndDate)))">
				[ibr-co-19]-If Invoicing period (ibg-14) is used, the Invoicing period start date (iibt-073) or the Invoicing period end date (iibt-074) shall be filled, or both.
			</assert>
			<assert id="jp-s-p6c" flag="fatal" test="exists(cbc:StartDate) and exists(cbc:EndDate)">
				[jp-s-p6c]-If Invoicing period (ibg-14) is used, both the Invoicing period start date (iibt-073) and the Invoicing period end date (iibt-074) shall be filled.
			</assert>
		</rule>

		<rule context="/ubl:Invoice/cac:InvoiceLine">
			<assert id="ibr-co-p3" flag="fatal" test="exists(cac:Item/cac:ClassifiedTaxCategory/cbc:ID) and exists(cac:Item/cac:ClassifiedTaxCategory/cbc:Percent)">
				[ibr-co-p3]-"INVOICE LINE ALLOWANCES"（ibg-27）shall be categorized by "Invoiced item TAX category code" （ibt-151）and "Invoiced item TAX rate" (ibt-152).
			</assert>
		</rule>
		
		<rule context="cac:InvoiceLine/cac:InvoicePeriod | cac:CreditNoteLine/cac:InvoicePeriod">
			<assert id="ibr-30" flag="fatal" test="(exists(cbc:EndDate) and exists(cbc:StartDate) and xs:date(cbc:EndDate) >= xs:date(cbc:StartDate)) or not(exists(cbc:StartDate)) or not(exists(cbc:EndDate))">
				[ibr-30]-If both Invoice line period start date (iibt-134) and Invoice line period end date (iibt-135) are given then the Invoice line period end date (iibt-135) shall be later or equal to the Invoice line period start date (iibt-134).
			</assert>
			<assert id="ibr-co-20" flag="fatal" test="exists(cbc:StartDate) or exists(cbc:EndDate)">
				[ibr-co-20]-If Invoice line period (ibg-26) is used, the Invoice line period start date (iibt-134) or the Invoice line period end date (iibt-135) shall be filled, or both.
			</assert>
			<assert id="jp-s-p6b" flag="fatal" test="exists(cbc:StartDate) and exists(cbc:EndDate)">
				[jp-s-p6b]-If Invoice line period (ibg-26) is used, both the Invoice line period start date (iibt-134) and the Invoice line period end date (iibt-135) shall be filled.
			</assert>
		</rule>

		<rule context="/ubl:Invoice">
			<assert id="jp-br-co-01" flag="fatal" test="(
				cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:Percent/xs:decimal(.) != 0 and
				(
					cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount/xs:decimal(.) &gt;= 
					floor(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount/xs:decimal(.) * (cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:Percent/xs:decimal(.) div 100))
				) and (
					cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount/xs:decimal(.) &lt;= 
					ceiling(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount/xs:decimal(.) * (cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:Percent/xs:decimal(.) div 100))
				)
			)">
			[jp-br-co-01]-Consumption Tax category tax amount (IBT-117) = Consumption Tax category taxable amount (IBT-116) x (Consumption Tax category rate (IBT-119) / 100), rounded to integer. The rounded result amount SHALL be between the floor and the ceiling.
			</assert>
		</rule>
		
		<rule context="/ubl:Invoice/*[local-name()!='InvoiceLine']/*[@currencyID='JPY'] | ubl:Invoice/*[local-name()!='InvoiceLine']/*/*[@currencyID='JPY'] | //cac:InvoiceLine/cbc:chargesTotal[@currencyID='JPY']">
			<assert id="jp-br-02" flag="fatal" test="matches(normalize-space(.),'^-?[1-9][0-9]*$')">[jp-br-02]- Amount shall be integer.</assert>
		</rule>
		
		<rule context="/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[cbc:ID/normalize-space(.)='S' or cbc:ID/normalize-space(.)='AA'][cac:TaxScheme/cbc:ID/normalize-space(.)='VAT']">
			<assert id="jp-s-06" flag="fatal" test="(cbc:Percent) &gt; 0">
				[jp-s-06]-In a Document level allowance (IBG-20) where the Document level allowance Consumption Tax category code (IBT-95) is "Standard rated" or "Reduced rate" the Document level allowance Consumption Tax rate (IBT-96) shall be greater than zero.
			</assert>
		</rule>
		
		<rule context="/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[cbc:ID/normalize-space(.)='S' or cbc:ID/normalize-space(.)='AA'][cac:TaxScheme/cbc:ID/normalize-space(.)='VAT']">
			<assert id="jp-s-07" flag="fatal" test="(cbc:Percent) &gt; 0">
				[jp-s-07]-In a Document level charge (IBG-21) where the Document level charge Consumption Tax category code (IBT-102) is "Standard rated" or "Reduced rate" the Document level charge Consumption Tax rate (IBT-103) shall be greater than zero.
			</assert>
		</rule>
		
		<rule context="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:ID/normalize-space(.)='S'][cac:TaxScheme/cbc:ID/normalize-space(.)='VAT']">
			<assert id="jp-s-08S" flag="fatal" test="every $rate in xs:decimal(cbc:Percent) satisfies (
					(
						exists(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/cbc:ID/normalize-space(.)='S'][cac:Item/cac:ClassifiedTaxCategory/cbc:Percent/xs:decimal(.)=$rate]/cbc:LineExtensionAmount/xs:decimal(.)) or
						exists(../../../cac:AllowanceCharge[cac:TaxCategory/cbc:ID/normalize-space(.)='S'][cac:TaxCategory/cbc:Percent/xs:decimal(.)=$rate])
					) and (
						../cbc:TaxableAmount/xs:decimal(.) = sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/cbc:ID/normalize-space(.)='S'][cac:Item/cac:ClassifiedTaxCategory/cbc:Percent/xs:decimal(.)=$rate]/cbc:LineExtensionAmount/xs:decimal(.)) +
						sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/cbc:ID/normalize-space(.)='S'][cac:TaxCategory/cbc:Percent/xs:decimal(.)=$rate]/cbc:Amount/xs:decimal(.)) - 
						sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/cbc:ID/normalize-space(.)='S'][cac:TaxCategory/cbc:Percent/xs:decimal(.)=$rate]/cbc:Amount/xs:decimal(.))
					)
				)">
				[*jp-s-08S]-For each different value of Consumption Tax category rate (IBT-119) where the Consumption Tax category code (IBT-118) is "Standard rated", the Consumption Tax category taxable amount (IBT-116) in a Consumption Tax breakdown (IBG-23) shall equal the sum of Invoice line net amounts (IBT-131) plus the sum of document level charge amounts (IBT-99) minus the sum of document level allowance amounts (IBT-92) where the Consumption Tax category code (IBT-151, IBT-102, IBT-95) is "Standard rated" and the Consumption Tax rate (IBT-152, IBT-103, IBT-96) equals the Consumption Tax category rate (IBT-119).
			</assert>
			<assert id="jp-s-09S" flag="fatal" test="
				../cbc:TaxAmount/xs:decimal(.) &lt;= ceiling(../cbc:TaxableAmount/xs:decimal(.) * (xs:decimal(cbc:Percent) div 100)) and
				../cbc:TaxAmount/xs:decimal(.) &gt;= floor(../cbc:TaxableAmount/xs:decimal(.) * (xs:decimal(cbc:Percent) div 100))">
				[jp-s-09S]-The Consumption Tax category tax amount (IBT-117) in a Consumption Tax breakdown (IBG-23) where Consumption Tax category code (IBT-118) is "Standard rated" shall equal the Consumption Tax category taxable amount (IBT-116) multiplied by the Consumption Tax category rate (IBT-119).
			</assert>
		</rule>
		
		<rule context="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:ID/normalize-space(.)='AA'][cac:TaxScheme/cbc:ID/normalize-space(.)='VAT']">
			<assert id="jp-s-08AA" flag="fatal" test="every $rate in xs:decimal(cbc:Percent) satisfies (
					(
						exists(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/cbc:ID/normalize-space(.)='AA'][cac:Item/cac:ClassifiedTaxCategory/cbc:Percent/xs:decimal(.)=$rate]/cbc:LineExtensionAmount/xs:decimal(.)) or
						exists(../../../cac:AllowanceCharge[cac:TaxCategory/cbc:ID/normalize-space(.)='AA'][cac:TaxCategory/cbc:Percent/xs:decimal(.)=$rate])
					) and (
						../cbc:TaxableAmount/xs:decimal(.) = sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/cbc:ID/normalize-space(.)='AA'][cac:Item/cac:ClassifiedTaxCategory/cbc:Percent/xs:decimal(.)=$rate]/cbc:LineExtensionAmount/xs:decimal(.)) +
						sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/cbc:ID/normalize-space(.)='AA'][cac:TaxCategory/cbc:Percent/xs:decimal(.)=$rate]/cbc:Amount/xs:decimal(.)) - 
						sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/cbc:ID/normalize-space(.)='AA'][cac:TaxCategory/cbc:Percent/xs:decimal(.)=$rate]/cbc:Amount/xs:decimal(.))
					)
				)">
				[*jp-s-08AA]-For each different value of Consumption Tax category rate (IBT-119) where the Consumption Tax category code (IBT-118) is "Standard rated", the Consumption Tax category taxable amount (IBT-116) in a Consumption Tax breakdown (IBG-23) shall equal the sum of Invoice line net amounts (IBT-131) plus the sum of document level charge amounts (IBT-99) minus the sum of document level allowance amounts (IBT-92) where the Consumption Tax category code (IBT-151, IBT-102, IBT-95) is "Standard rated" and the Consumption Tax rate (IBT-152, IBT-103, IBT-96) equals the Consumption Tax category rate (IBT-119).
			</assert>
			<assert id="jp-s-09AA" flag="fatal" test="
				../cbc:TaxAmount/xs:decimal(.) &lt;= ceiling(../cbc:TaxableAmount/xs:decimal(.) * (xs:decimal(cbc:Percent) div 100)) and
				../cbc:TaxAmount/xs:decimal(.) &gt;= floor(../cbc:TaxableAmount/xs:decimal(.) * (xs:decimal(cbc:Percent) div 100))">
				[jp-s-09AA]-The Consumption Tax category tax amount (IBT-117) in a Consumption Tax breakdown (IBG-23) where Consumption Tax category code (IBT-118) is "Standard rated" shall equal the Consumption Tax category taxable amount (IBT-116) multiplied by the Consumption Tax category rate (IBT-119).
			</assert>
		</rule>
		
		<rule context="/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = false()]">
			<assert id="ibr-31" flag="fatal" test="exists(cbc:Amount)">
				[ibr-31]-Each Document level allowance (ibg-20) shall have a Document level allowance amount (iibt-092).
			</assert>
			<assert id="ibr-33" flag="fatal" test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)">
				[ibr-33]-Each Document level allowance (ibg-20) shall have a Document level allowance reason (iibt-907) or a Document level allowance reason code (iibt-098).
			</assert>
			<assert id="ibr-co-p2a" flag="fatal" test="exists(cac:TaxCategory/cbc:ID) and exists(cac:TaxCategory/cbc:Percent)">
				[ibr-p2a]-"DOCUMENT LEVEL ALLOWANCES"（ibg-20）shall be categorized by "Document level allowance TAX category code"（ibt-095）and "Document level allowance TAX rate"（ibt-096).
			</assert>
			<assert id="ibr-co-05" flag="fatal" test="true()">
				[ibr-co-05]-Document level allowance reason code (iibt-098) and Document level allowance reason (iibt-097) shall indicate the same type of allowance.
			</assert>
			<assert id="ibr-co-21" flag="fatal" test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)">
				[ibr-co-21]-Each Document level allowance (ibg-20) shall contain a Document level allowance reason (iibt-097) or a Document level allowance reason code (iibt-098), or both.
			</assert>
		</rule>
		
		<rule context="/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = true()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = true()]">
			<assert id="ibr-36" flag="fatal" test="exists(cbc:Amount)">
				[ibr-36]-Each Document level charge (ibg-21) shall have a Document level charge amount (iibt-099).
			</assert>
			<assert id="ibr-38" flag="fatal" test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)">
				[ibr-38]-Each Document level charge (ibg-21) shall have a Document level charge reason (iibt-104) or a Document level charge reason code (iibt-105).
			</assert>
			<assert id="ibr-co-p2c" flag="fatal" test="exists(cac:TaxCategory/cbc:ID) and exists(cac:TaxCategory/cbc:Percent)">
				[ibr-p2c]-"DOCUMENT LEVEL CHARGES"（ibg-21）shall be categorized by "Document level charge TAX category code"（ibt-102）and "Document level charge TAX rate" (ibt-103).
			</assert>
			<assert id="ibr-co-06" flag="fatal" test="true()">
				[ibr-co-06]-Document level charge reason code (iibt-105) and Document level charge reason (iibt-104) shall indicate the same type of charge.
			</assert>
			<assert id="ibr-co-22" flag="fatal" test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)">
				[ibr-co-22]-Each Document level charge (ibg-21) shall contain a Document level charge reason (iibt-104) or a Document level charge reason code (iibt-105), or both.
			</assert>
		</rule>
		
		<rule context="/ubl:Invoice/cac:LegalMonetaryTotal">
			<let name="lineNetTotal" value="
				if (cbc:LineExtensionAmount) 
					then cbc:LineExtensionAmount/xs:decimal(.)
				else 0"/>
			<let name="lineNetAmount" value="
				if (../cac:InvoiceLine/cbc:LineExtensionAmount) 
					then ../cac:InvoiceLine/cbc:LineExtensionAmount/xs:decimal(.)
				else 0"/>
			<let name="taxExclusiveAmount" value="
				if (cbc:TaxExclusiveAmount) 
					then cbc:TaxExclusiveAmount/xs:decimal(.)
				else 0"/>
			<let name="taxInclusiveAmount" value="
				if (cbc:TaxInclusiveAmount) 
					then cbc:TaxInclusiveAmount/xs:decimal(.)
				else 0"/>
			<let name="prepaidAmount" value="
				if (cbc:PrepaidAmount) 
					then cbc:PrepaidAmount/xs:decimal(.)
				else 0"/>
			<let name="roundingAmount" value="
				if (cbc:PayableRoundingAmount) 
					then cbc:PayableRoundingAmount/xs:decimal(.)
				else 0"/>
			<let name="payableAmount" value="
				if (cbc:PayableAmount) 
					then cbc:PayableAmount/xs:decimal(.)
				else 0"/>
			<let name="allowancesTotal" value="
				if (cbc:AllowanceTotalAmount) 
					then cbc:AllowanceTotalAmount/xs:decimal(.)
				else 0"/>
			<let name="chargesTotal" value="
				if (cbc:ChargeTotalAmount) 
					then cbc:ChargeTotalAmount/xs:decimal(.)
				else 0"/>
			<let name="allowanceAmount" value="
				if (../cac:AllowanceCharge[cbc:ChargeIndicator=false()]) 
					then ../cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cbc:Amount/xs:decimal(.)
				else 0"/>
			<let name="chargeAmount" value="
				if (../cac:AllowanceCharge[cbc:ChargeIndicator=true()]) 
					then ../cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cbc:Amount/xs:decimal(.)
				else 0"/>
			<assert id="ibr-12" flag="fatal" test="exists(cbc:LineExtensionAmount)">
				[ibr-12]-An Invoice shall have the Sum of Invoice line net amount (IBT-106).
			</assert>
			<assert id="ibr-13" flag="fatal" test="exists(cbc:TaxExclusiveAmount)">
				[ibr-13]-An Invoice shall have the Invoice total amount without Tax (IBT-109).
			</assert>
			<assert id="ibr-14" flag="fatal" test="exists(cbc:TaxInclusiveAmount)">
				[ibr-14]-An Invoice shall have the Invoice total amount with Tax (IBT-112).
			</assert>
			<assert id="ibr-15" flag="fatal" test="exists(cbc:PayableAmount)">
				[ibr-15]-An Invoice shall have the Amount due for payment (IBT-115).
			</assert>
			<assert id="ibr-co-10" flag="fatal" test="$lineNetTotal = sum($lineNetAmount)">
				[ibr-co-10]-Sum of Invoice line net amount (IBT-106) = Σ Invoice line net amount (IBT-131).
			</assert>
			<assert id="ibr-co-11" flag="fatal" test="$allowancesTotal = sum($allowanceAmount)">
				[ibr-co-11]-Sum of allowances on document level (IBT-107) = Σ Document level allowance amount (IBT-092).
			</assert>
			<assert id="ibr-co-12" flag="fatal" test="$chargesTotal = sum($chargeAmount)">
				[ibr-co-12]-Sum of charges on document level (IBT-108) = Σ Document level charge amount (IBT-099).
			</assert>
			<assert id="ibr-co-13" flag="fatal" test="$taxExclusiveAmount = $lineNetTotal - $allowancesTotal + $chargesTotal">
				[ibr-co-13]-Invoice total amount without Tax (IBT-109) = Σ Invoice line net amount (IBT-131) - Sum of allowances on document level (IBT-107) + Sum of charges on document level (IBT-108).
			</assert>
			<assert id="ibr-co-16" flag="fatal" test="$payableAmount = $taxInclusiveAmount - $prepaidAmount + $roundingAmount">
				[*ibr-co-16]-Amount due for payment (IBT-115) = Invoice total amount with Tax (IBT-112) - Paid amount (IBT-113) + Rounding amount (IBT-114).
			</assert>
		</rule>

	</pattern>
	
	<pattern id="Codesmodel">
		<rule flag="fatal" context="cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode">
			<assert id="jp-cl-01" flag="fatal" test="
				self::cbc:InvoiceTypeCode and (not(contains(normalize-space(.), ' ') and contains(' 80 82 84 380 383 386 393 395 575 623 780 ', concat(' ', normalize-space(.), ' ')))) or
				self::cbc:CreditNoteTypeCode and (not(contains(normalize-space(.), ' ') and contains(' 81 83 381 396 532 ', concat(' ', normalize-space(.), ' '))))">
				[jp-cl-01]-The document type code MUST be coded by the Japanese invoice and Japanese credit note related code lists of UNTDID 1001.
			</assert>
		</rule>
		<rule flag="fatal" context="cac:PaymentMeans/cbc:PaymentMeansCode">
			<assert id="jp-cl-02" flag="fatal" test="
				not(contains(normalize-space(.),' ')) and 
				contains(' 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 70 74 75 76 77 78 91 92 93 94 95 96 97 ZZZ Z01 Z02 ',concat(' ',normalize-space(.),' '))">
				[jp-cl-02]-Payment means in a Japanese invoice MUST be coded using a restricted version of the UNCL4461 code list (adding Z01 and Z02)
			</assert>
		</rule>
		<rule flag="fatal" context="cac:TaxCategory/cbc:ID | cac:ClassifiedTaxCategory/cbc:ID">
			<assert id="jp-cl-03" flag="fatal" test="
				not(contains(normalize-space(.),' ')) and
				contains( ' AA S Z G O E ',concat(' ',normalize-space(.),' '))">
				[jp-cl-03]- Japanese invoice tax categories MUST be coded using UNCL5305 code list
			</assert>
		</rule>
		<rule flag="fatal" context="cbc:TaxExemptionReasonCode">
			<assert id="jp-cl-04" flag="fatal" test="
				not(contains(normalize-space(.), ' ')) and
				contains(' ZZZ ', concat(' ', normalize-space(upper-case(.)),' '))">
				[jp-cl-04]-Tax exemption reason code identifier scheme identifier MUST belong to the ????</assert>
		</rule>
	</pattern>
</schema>