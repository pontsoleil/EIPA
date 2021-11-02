<!--
     
     Licensed under MIT License
     
-->
<!-- Schematron rules edited by Sambuichi Professional Engineers Office -->
<!-- Abstract rules for JP-model -->
<!-- Timestamp: 2021-11-02 14:25:00 +0900 -->
<pattern xmlns="http://purl.oclc.org/dsdl/schematron" abstract="true" id="JP-model">
  <!-- Japanese ruleset -->
  <rule context="$Seller">
    <assert id="jp-br-01" flag="fatal" test="$jp-br-01">[jp-br-01]-From October 1st 2023, Seller Tax identifier (ibt-031) shall be coded by using a Registration number for Qualified Invoice in Japan, which consists of 14 digits that starts with "T".</assert>
  </rule>
  <rule context="$Amount_data_type">
    <assert id="jp-br-02" flag="fatal" test="$jp-br-02">[jp-br-02]-Amount shall be integer.</assert>
  </rule>
  <rule context="$Tax_identifiers">
    <assert id="jp-br-03" flag="fatal" test="$jp-br-03">[jp-br-03]-Tax scheme (ibt-118-1) shall use VAT from UNECE 5153 code list. VAT means Consumption Tax in Japan.</assert>
  </rule>

  <rule context="$Seller">
    <assert id="jp-br-04" flag="fatal" test="$jp-br-04">[jp-br-04]-An Invoice shall have the Seller tax identifier (ibt-031).</assert>
  </rule>
  <rule context="$Invoice">
    <assert id="jp-br-05" flag="fatal" test="$jp-br-05">[jp-br-05]-An Invoice shall have an invoice period (ibg-14) or an Invoice line period (ibg-26).</assert>
  </rule>
  <rule context="$Invoice_Period">
    <assert id="jp-br-06" flag="fatal" test="$jp-br-06">[jp-br-06]-Invoice period (ibg-14) shall have both invoice period start date (ibt-073) and invoice period end date (ibt-074).</assert>
  </rule>
  <rule context="$Invoice_Line_Period">
    <assert id="jp-br-07" flag="fatal" test="$jp-br-07">[jp-br-07]-Invoice line period (ibg-26) shall have both invoice line period start date (ibt-134) and invoice line period end date (ibt-135).</assert>
    <assert id="jp-br-08" flag="fatal" test="$jp-br-08">[jp-br-08]-Both start date and end date of line period must be within invoice period.</assert>
  </rule>

  <rule context="$Invoice_Line">
    <assert id="jp-br-09" flag="fatal" test="$jp-br-09">[jp-br-09]-Invoice line net amount (ibt-131) = Item net price (ibt-146) X Invoiced quantity (ibt-129) ÷ Item price base quantity (ibt-149) + Invoice line charge amount (ibt-141) – Invoice line allowance amount (ibt-136).</assert>
  </rule>

  <!--
  <rule>
    <assert id="jp-br-10" flag="fatal" test="$jp-br-10">[jp-br-10]-Specification identifier MUST start with the value 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0'.</assert>
  </rule>
  <rule>
    <assert id="jp-br-11" flag="fatal" test="$jp-br-11">[jp-br-11]-Business process MUST be in the format 'urn:fdc:peppol.eu:2017:poacc:billing:NN:1.0' where NN indicates the process number.</a</assert>
  </rule>
  -->

  <rule context="$Document_level_allowances">
    <assert id="jp-br-32" flag="fatal" test="$jp-br-32">[jp-br-32]-Each Document level allowance (ibg-20) shall be categorized by document level allowance tax category code（ibt-095）and document level allowance tax rate（ibt-096).</assert>
  </rule>
  <rule context="$Invoice_line_allowances">
    <assert id="jp-br-33" flag="fatal" test="$jp-br-33">[jp-br-33]-Each line level allowance (ibg-27) shall be categorized by invoiced item tax category code（ibt-151）and invoiced item tax rate (ibt-152).</assert>
  </rule>
  <rule context="$Document_level_charges">
    <assert id="jp-br-37" flag="fatal" test="$jp-br-37">[jp-br-37]-Each Document level charge (ibg-21) shall be categorized by document level charge tax category code（ibt-102）and document level charge tax rate (ibt-103).</assert>
  </rule>
  <rule context="$Invoice_line_charges">
    <assert id="jp-br-38" flag="fatal" test="$jp-br-38">[jp-br-38]-Each line level charge (ibg-27) shall be categorized by invoiced item tax category code（ibt-151）and invoiced item tax rate (ibt-152).</assert>
  </rule>
  <rule context="$Tax_breakdown">
    <assert id="jp-br-45" flag="fatal" test="$jp-br-45">[jp-br-45]-Each tax breakdown (ibg-23) shall have a tax category taxable amount (ibt-116).</assert>
    <assert id="jp-br-46" flag="fatal" test="$jp-br-46">[jp-br-46]-Each tax breakdown (ibg-23) shall have a tax category tax amount (ibt-117).</assert>
    <assert id="jp-br-47" flag="fatal" test="$jp-br-47">[jp-br-47]-Each tax breakdown (ibg-23) shall be defined through a tax category code (BT-118).</assert>
    <assert id="jp-br-48" flag="fatal" test="$jp-br-48">[jp-br-48]-Each tax breakdown (ibg-23) shall have a tax category rate (BT-119), except if the Invoice is not subject to tax.</assert>
  </rule>

  <rule context="$Tax_Total">
    <assert id="jp-br-co-01" flag="fatal" test="$jp-br-co-01">[jp-br-co-01]-Consumption Tax category tax amount (ibt-117) = Consumption Tax category taxable amount (ibt-116) x (Consumption Tax category rate (ibt-119) / 100), rounded to integer. The rounded result amount SHALL be between the floor and the ceiling.</assert>
  </rule>
  <rule context="$Invoice">
    <assert id="jp-br-co-02" flag="fatal" test="$jp-br-co-02">[jp-br-co-02]-If tax accounting currency (ibt-006) is present, tax category tax amount in tax accounting currency (ibt-117-○) shall be provided.</assert>
  </rule>
  <rule context="$Tax_currencycode">
    <assert id="jp-br-co-03" flag="fatal" test="$jp-br-co-03">[jp-br-co-03]-If tax accounting currency (ibt-006) is present, it shall be coded using JPY in ISO code list of 4217 alpha-3.</assert>
  </rule>
  <rule context="$Invoice_Line">
    <assert id="jp-br-co-04" flag="fatal" test="$jp-br-co-04">[jp-br-co-04]-Invoice line (ibg-25), invoice line charge (ibg-28) and invoice line allowance (ibg-29) shall be categorized by both invoiced item tax category code (ibt-151) and invoiced item tax rate (ibt152).</assert>
  </rule>

  <!-- Tax rules -->

  <rule context="$Invoice">
    <assert id="jp-s-01" flag="fatal" test="$jp-s-01">[jp-s-01]-An Invoice that contains an Invoice line (ibg-25), a Document level allowance (ibg-20) or a Document level charge (ibg-21) where the Consumption Tax category code (ibt-151, ibt-95 or ibt-102) is "Standard rated" shall contain in the Consumption Tax breakdown (ibg-23) at least one Consumption Tax category code (ibt-118) equal with "Standard rated".</assert>
    <assert id="jp-s-02" flag="fatal" test="$jp-s-02">[jp-s-02]-An Invoice that contains an Invoice line (ibg-25) where the Invoiced item Consumption Tax category code (ibt-151) is "Standard rated" shall contain the Seller Consumption Tax Identifier (ibt-31), the Seller tax registration identifier (ibt-32) and/or the Seller tax representative Consumption Tax identifier (ibt-63).</assert>
    <assert id="jp-s-03" flag="fatal" test="$jp-s-03">[jp-s-03]-An Invoice that contains a Document level allowance (ibg-20) where the Document level allowance Consumption Tax category code (ibt-95) is "Standard rated" shall contain the Seller Consumption Tax Identifier (ibt-31), the Seller tax registration identifier (ibt-32) and/or the Seller tax representative Consumption Tax identifier (ibt-63).</assert>
    <assert id="jp-s-04" flag="fatal" test="$jp-s-04">[jp-s-04]-An Invoice that contains a Document level charge (ibg-21) where the Document level charge Consumption Tax category code (ibt-102) is "Standard rated" shall contain the Seller Consumption Tax Identifier (ibt-31), the Seller tax registration identifier (ibt-32) and/or the Seller tax representative Consumption Tax identifier (ibt-63).</assert>
    <assert id="jp-s-05" flag="fatal" test="$jp-s-05">[jp-s-05]-In an Invoice line (ibg-25) where the Invoiced item Consumption Tax category code (iibt-151) is "Standard rated" the Invoiced item Consumption Tax rate (iibt-152) shall be greater than zero.</assert>
    <assert id="jp-s-06" flag="fatal" test="$jp-s-06">[jp-s-06]-In a Document level allowance (ibg-20) where the Document level allowance Consumption Tax category code (ibt-95) is "Standard rated" the Document level allowance Consumption Tax rate (ibt-96) shall be greater than zero.</assert>
    <assert id="jp-s-07" flag="fatal" test="$jp-s-07">[jp-s-07]-In a Document level charge (ibg-21) where the Document level charge Consumption Tax category code (ibt-102) is "Standard rated" the Document level charge Consumption Tax rate (ibt-103) shall be greater than zero.  </assert>
  </rule>
  <rule context="$Tax_S_breakdown_category">
    <assert id="jp-s-08" flag="fatal" test="$jp-s-08">[jp-s-08]-For each different value of Consumption Tax category rate (ibt-119) where the Consumption Tax category code (ibt-118) is "Standard rated", the Consumption Tax category taxable amount (ibt-116) in a Consumption Tax breakdown (ibg-23) shall equal the sum of Invoice line net amounts (ibt-131) plus the sum of document level charge amounts (ibt-99) minus the sum of document level allowance amounts (ibt-92) where the Consumption Tax category code (ibt-151, ibt-102, ibt-95) is "Standard rated" and the Consumption Tax rate (ibt-152, ibt-103, ibt-96) equals the Consumption Tax category rate (ibt-119).</assert>
    <assert id="jp-s-09" flag="fatal" test="$jp-s-09">[jp-s-09]-The Consumption Tax category tax amount (ibt-117) in a Consumption Tax breakdown (ibg-23) where Consumption Tax category code (ibt-118) is "Standard rated" shall equal the Consumption Tax category taxable amount (ibt-116) multiplied by the Consumption Tax category rate (ibt-119).</assert>
    <assert id="jp-s-10" flag="fatal" test="$jp-s-10">[jp-s-10]-A Consumption Tax breakdown (ibg-23) with Consumption Tax Category code (ibt-118) "Standard rate" shall not have a Consumption Tax exemption reason code (ibt-121) or Consumption Tax exemption reason text (ibt-120).</assert>
  </rule>
  
  <rule context="$Invoice">
    <assert id="jp-aa-01" flag="fatal" test="$jp-aa-01">[jp-aa-01]-An Invoice that contains an Invoice line (ibg-25), a Document level allowance (ibg-20) or a Document level charge (ibg-21) where the Consumption Tax category code (ibt-151, ibt-95 or ibt-102) is "Reduced rated" shall contain in the Consumption Tax breakdown (ibg-23) at least one Consumption Tax category code (ibt-118) equal with "Reduced rated".</assert>
    <assert id="jp-aa-02" flag="fatal" test="$jp-aa-02">[jp-aa-02]-An Invoice that contains an Invoice line (ibg-25) where the Invoiced item Consumption Tax category code (ibt-151) is "Reduced rated" shall contain the Seller Consumption Tax Identifier (ibt-31), the Seller tax registration identifier (ibt-32) and/or the Seller tax representative Consumption Tax identifier (ibt-63).</assert>
    <assert id="jp-aa-03" flag="fatal" test="$jp-aa-03">[jp-aa-03]-An Invoice that contains a Document level allowance (ibg-20) where the Document level allowance Consumption Tax category code (ibt-95) is "Reduced rated" shall contain the Seller Consumption Tax Identifier (ibt-31), the Seller tax registration identifier (ibt-32) and/or the Seller tax representative Consumption Tax identifier (ibt-63).</assert>
    <assert id="jp-aa-04" flag="fatal" test="$jp-aa-04">[jp-aa-04]-An Invoice that contains a Document level charge (ibg-21) where the Document level charge Consumption Tax category code (ibt-102) is "Reduced rated" shall contain the Seller Consumption Tax Identifier (ibt-31), the Seller tax registration identifier (ibt-32) and/or the Seller tax representative Consumption Tax identifier (ibt-63).</assert>
    <assert id="jp-aa-05" flag="fatal" test="$jp-aa-05">[jp-aa-05]-In an Invoice line (ibg-25) where the Invoiced item Consumption Tax category code (iibt-151) is "Reduced rated" the Invoiced item Consumption Tax rate (iibt-152) shall be greater than zero.</assert>
    <assert id="jp-aa-06" flag="fatal" test="$jp-aa-06">[jp-aa-06]-In a Document level allowance (ibg-20) where the Document level allowance Consumption Tax category code (ibt-95) is "Reduced rated" the Document level allowance Consumption Tax rate (ibt-96) shall be greater than zero.</assert>
    <assert id="jp-aa-07" flag="fatal" test="$jp-aa-07">[jp-aa-07]-In a Document level charge (ibg-21) where the Document level charge Consumption Tax category code (ibt-102) is "Reduced rated" the Document level charge Consumption Tax rate (ibt-103) shall be greater than zero.</assert>
  </rule>
  <rule context="$Tax_AA_breakdown_category">
    <assert id="jp-aa-08" flag="fatal" test="$jp-aa-08">[jp-aa-08]-For each different value of Consumption Tax category rate (ibt-119) where the Consumption Tax category code (ibt-118) is "Reduced rated", the Consumption Tax category taxable amount (ibt-116) in a Consumption Tax breakdown (ibg-23) shall equal the sum of Invoice line net amounts (ibt-131) plus the sum of document level charge amounts (ibt-99) minus the sum of document level allowance amounts (ibt-92) where the Consumption Tax category code (ibt-151, ibt-102, ibt-95) is "Reduced rated" and the Consumption Tax rate (ibt-152, ibt-103, ibt-96) equals the Consumption Tax category rate (ibt-119).</assert>
    <assert id="jp-aa-09" flag="fatal" test="$jp-aa-09">[jp-aa-09]-The Consumption Tax category tax amount (ibt-117) in a Consumption Tax breakdown (ibg-23) where Consumption Tax category code (ibt-118) is "Reduced rated" shall equal the Consumption Tax category taxable amount (ibt-116) multiplied by the Consumption Tax category rate (ibt-119).</assert>
    <assert id="jp-aa-10" flag="fatal" test="$jp-aa-10">[jp-aa-10]-A Consumption Tax breakdown (ibg-23) with Consumption Tax Category code (ibt-118) "Reduced rate" shall not have a Consumption Tax exemption reason code (ibt-121) or Consumption Tax exemption reason text (ibt-120).</assert>
  </rule>
  
  <rule context="$Invoice">
    <assert id="jp-e-01" flag="fatal" test="$jp-e-01">[jp-e-01]-An Invoice that contains an Invoice line (ibg-25), a Document level allowance (ibg-20) and a Document level charge (ibg-21) where the tax category code (ibt-151, ibt-095, ibt-102) is “E (Exempt from tax)” shall contain exactly one “Tax breakdown” (ibg-23) with “Tax category code” (ibt-118) equal to “E”.</assert>
    <assert id="jp-e-05" flag="fatal" test="$jp-e-05">[jp-e-05]-In an Invoice line (BG-25) where the Invoiced item tax category code (BT-151) is Exempt from tax, the Invoiced item tax rate (BT-152) shall be 0 (zero).</assert>
    <assert id="jp-e-06" flag="fatal" test="$jp-e-06">[jp-e-06]-In a Document level allowance (BG-20) where the Document level allowance tax category code (BT-95) is Exempt from tax, the Document level allowance tax rate (BT-96) shall be 0 (zero).</assert>
    <assert id="jp-e-07" flag="fatal" test="$jp-e-07">[jp-e-07]-In a Document level charge (BG-21) where the Document level charge tax category code (BT-102) is Exempt from tax, the Document level charge tax rate (BT-103) shall be 0 (zero).</assert>
  </rule>
  <rule context="$Tax_E_breakdown_category">
    <assert id="jp-e-09" flag="fatal" test="$jp-e-09">[jp-e-09]-Tax category tax amount (ibt-117) shall be 0 (zero) if tax category code (ibt-118) equals to E (Exempt from tax).</assert>
  </rule>
  
  <rule context="$Invoice">
    <assert id="jp-g-01" flag="fatal" test="$jp-g-01">[jp-g-01]-An Invoice that contains an invoice line (ibg-25) where the tax category code (ibt-151) is “G (Free export item, tax not charged)” shall contain exactly one tax breakdown (ibg-23) with tax category code (ibt-118) equals to “G”.</assert>
    <assert id="jp-g-05" flag="fatal" test="$jp-g-05">[jp-g-05]-In an invoice line (ibg-25) where the invoiced item tax category code (ibt-151) is “G (Free export item, tax not charged)” the invoiced item tax rate (ibt-152) shall be 0 (zero).</assert>
    <assert id="jp-g-06" flag="fatal" test="$jp-g-06">[jp-g-06]-In a document level allowance (ibg-20) where the Document level allowance tax category code (ibt-95) is “G (Free export item, tax not charged)” the document level allowance tax rate (ibt-96) shall be 0 (zero).</assert>
    <assert id="jp-g-07" flag="fatal" test="$jp-g-07">[jp-g-07]-In a document level charge (ibg-21) where the Document level charge tax category code (ibt-102) is “G (Free export item, tax not charged)” the document level charge tax rate (ibt-103) shall be 0 (zero).</assert>
  </rule>
  <rule context="$Tax_G_breakdown_category">
    <assert id="jp-g-09" flag="fatal" test="$jp-g-09">[jp-g-09]-Tax category tax amount (ibt-117) shall be 0 (zero) if tax category code (ibt-118) equals to “G (Free export item, tax not charged)”. </assert>
  </rule>
  
  <rule context="$Invoice">
    <assert id="jp-o-01" flag="fatal" test="$jp-o-01">[jp-o-01]-An Invoice that contains an invoice line (ibg-25), a document level allowance (ibg-20) and a document level charge (ibg-21) where the tax category code (ibt-151, ibt-095, ibt-102) is “O (Outside of scope of tax)” shall contain exactly one tax breakdown (ibg-23) with tax category code(ibt-118) equal to “O”.</assert>
    <assert id="jp-o-05" flag="fatal" test="$jp-o-05">[jp-o-05]-An invoice line (ibg-25) where the tax category code (ibt-151) is "O (Outside of scope of tax)" shall not contain an Invoiced item tax rate (BT-152).</assert>
    <assert id="jp-o-06" flag="fatal" test="$jp-o-06">[jp-o-06]-A document level allowance (ibg-20) where tax category code (ibt-95) is "O (Outside of scope of tax)" shall not contain a document level allowance tax rate (BT-96).</assert>
    <assert id="jp-o-07" flag="fatal" test="$jp-o-07">[jp-o-07]-A document level charge (ibg-21) where the tax category code (ibt-102) is "O (Outside of scope of tax)" shall not contain a Document level charge tax rate (BT-103).</assert>
  </rule>
  <rule context="$Tax_O_breakdown_category">
    <assert id="jp-o-09" flag="fatal" test="$jp-o-09">[jp-o-09]-Tax category tax amount (ibt-117) shall be 0 (zero) if tax category code (ibt-118) equals to “O (Outside of scope of tax)”.</assert>
  </rule>

  <!-- Reused  Peppol Rules -->
 <!--  
  <rule>
    <assert id="PEPPOL-EN16931-R001" flag="fatal" test="$PEPPOL-EN16931-R001">[PEPPOL-EN16931-R001]- Business process MUST be provided.</assert>
  </rule>
  <rule>
    <assert id="PEPPOL-EN16931-R005" flag="fatal" test="$PEPPOL-EN16931-R005">[PEPPOL-EN16931-R005]-VAT accounting currency code MUST be different from invoice currency code when provided.</assert>
  </rule>
  <rule context="$Date">
    <assert id="PEPPOL-EN16931-F001" flag="fatal" test="$PEPPOL-EN16931-F001">[PEPPOL-EN16931-F001]-A date MUST be formatted YYYY-MM-DD.</assert>
  </rule>
  <rule>
    <assert id="PEPPOL-EN16931-R044" flag="fatal" test="$PEPPOL-EN16931-R044">[PEPPOL-EN16931-R044]-Charge on price level is NOT allowed. Only value 'false' allowed.</assert>
  </rule>
  <rule>
    <assert id="PEPPOL-EN16931-R046" flag="fatal" test="$PEPPOL-EN16931-R046">[PEPPOL-EN16931-R046]-Item net price MUST equal (Gross price - Allowance amount) when gross price is provided.</assert>
  </rule>
 
  <rule>
    <assert id="PEPPOL-COMMON-R040" flag="fatal" test="$PEPPOL-COMMON-R040">[PEPPOL-COMMON-R040]-GLN must have a valid format according to GS1 rules.</assert>
  </rule>
  <rule context="$Embedded_Document_Binary_Object">
    <assert id="PEPPOL-EN16931-CL001" flag="fatal" test="$PEPPOL-EN16931-CL001">[PEPPOL-EN16931-CL001]-Mime code must be according to subset of IANA code list.</assert>
  </rule>
  <rule context="$Document_level_allowances">
    <assert id="PEPPOL-EN16931-CL002" flag="fatal" test="$PEPPOL-EN16931-CL002">[PEPPOL-EN16931-CL002]-Alowance Reason code MUST be according to subset of UNCL 5189 D.16B.</assert>
  </rule>
  <rule context="$Document_level_charge">
    <assert id="PEPPOL-EN16931-CL003" flag="fatal" test="$PEPPOL-EN16931-CL003">[PEPPOL-EN16931-CL003]-Charge Reason code MUST be according to subset of UNCL 5189 D.16B.</assert>
  </rule>
  <rule context="$Invoice_Period">
    <assert id="PEPPOL-EN16931-CL006" flag="fatal" test="$PEPPOL-EN16931-CL006">[PEPPOL-EN16931-CL006]-Invoice period description code must be according to UNCL 2005 D.16B.</assert>
  </rule>

  <rule>
    <assert id="PEPPOL-EN16931-CL008" flag="fatal" test="$PEPPOL-EN16931-CL008">[PEPPOL-EN16931-CL008]-Electronic address identifier scheme must be from the codelist "Electronic Address Identifier Scheme"</assert>
  </rule>
  <rule>
    <assert id="PEPPOL-EN16931-P0100" flag="fatal" test="$PEPPOL-EN16931-P0100">[PEPPOL-EN16931-P0100]-Invoice type code MUST be set according to the profile.</assert>
  </rule>
  <rule>
    <assert id="PEPPOL-EN16931-P0101" flag="fatal" test="$PEPPOL-EN16931-P0101">[PEPPOL-EN16931-P0101]-Credit note type code MUST be set according to the profile.</assert>
  </rule>
  <rule>
    <assert id="PEPPOL-EN16931-R010" flag="fatal" test="$PEPPOL-EN16931-R010">[PEPPOL-EN16931-R010]-Buyer electronic address MUST be provided</assert>
  </rule>
  <rule>
    <assert id="PEPPOL-EN16931-R020" flag="fatal" test="$PEPPOL-EN16931-R020">[PEPPOL-EN16931-R020]-Seller electronic address MUST be provided</assert>
  </rule>
  <rule>
    <assert id="PEPPOL-EN16931-R043" flag="fatal" test="$PEPPOL-EN16931-R043">[PEPPOL-EN16931-R043]-Allowance/charge ChargeIndicator value MUST equal 'true' or 'false'</assert>
  </rule>
  -->
</pattern>