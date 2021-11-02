<?xml version="1.0" encoding="UTF-8"?>
<!--
     
     Licensed under European Union Public Licence (EUPL) version 1.2.
     
-->
<!-- 
     
     UBL syntax binding to the model  
     Created by Validex Schematron Generator. (2015) Midran Ltd.
     Timestamp: 2017-09-15 12:09:57 +0200
-->
<schema
   xmlns="http://purl.oclc.org/dsdl/schematron" 
   xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" 
   xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" 
   xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" 
   xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" 
   queryBinding="xslt2">
   <title>EN16931  model bound to UBL</title>
   <ns prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
   <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
   <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
   <ns prefix="qdt" uri="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2"/>
   <ns prefix="udt" uri="urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2"/>
   <ns prefix="cn"  uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"/>
   <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"/>
   <ns prefix="xs"  uri="http://www.w3.org/2001/XMLSchema"/>
   
   <phase id="JP-PINT_model_phase">
      <active pattern="JP-PINT-model"/>
   </phase>
   <phase id="PINT_model_phase">
      <active pattern="PINT-model"/>
   </phase>
   <phase id="PINT_syntax_phase">
      <active pattern="PINT-syntax"/>
   </phase>
   <phase id="PINTcodelist_phase">
      <active pattern="Codesmodel"/>
   </phase>
   <!-- Abstract JP-PINT patterns -->
   <!-- ========================= -->
   <include href="../../../Documents/GitHub/EIPA/JP-PINT-BIS/billing-1.0-resources-nobu/ubl/schematron/abstract/JP-abstract-model.sch"/>
   <include href="../../../Documents/GitHub/EIPA/JP-PINT-BIS/billing-1.0-resources-nobu/ubl/schematron/abstract/PINT-abstract-model.sch"/>
   <include href="../../../Documents/GitHub/EIPA/JP-PINT-BIS/billing-1.0-resources-nobu/ubl/schematron/abstract/PINT-abstract-syntax.sch"/>
   <!-- JP-PINT Data Binding parameters -->
   <!-- ========================= -->
   <include href="../../../Documents/GitHub/EIPA/JP-PINT-BIS/billing-1.0-resources-nobu/ubl/schematron/UBL/JP-model.sch"/>
   <include href="../../../Documents/GitHub/EIPA/JP-PINT-BIS/billing-1.0-resources-nobu/ubl/schematron/UBL/PINT-model.sch"/>
   <include href="../../../Documents/GitHub/EIPA/JP-PINT-BIS/billing-1.0-resources-nobu/ubl/schematron/UBL/PINT-syntax.sch"/>
   <!-- Code Lists Binding rules -->
   <!-- ========================= -->
   <include href="../../../Documents/GitHub/EIPA/JP-PINT-BIS/billing-1.0-resources-nobu/ubl/schematron/codelist/PINT-codes.sch"/>
</schema>
