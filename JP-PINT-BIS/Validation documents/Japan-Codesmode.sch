<pattern xmlns="http://purl.oclc.org/dsdl/schematron" id="japan-Codesmodel">
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
