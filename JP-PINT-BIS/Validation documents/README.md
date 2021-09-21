# JP-Validation artefacts

This repository contains the validation artefacts for the Australian - New Zealand electronic invoice specification.

The JP Validation Artefacts are based on two validation artefacts:
* European Norm validation artefacts v1.2.3 https://github.com/ConnectingEurope/eInvoicing-EN16931/releases/tag/validation-1.2.3 
* PEPPOL electronic invoice Spring Release https://github.com/OpenPEPPOL/peppol-bis-invoice-3/releases/tag/3.0.4

# Release Notes
    
**Initial release.**

There are three validation artefacts that should be applied to validate an JP electronic invoice instance:

* JP-UBL-validation.sch adapts the EN16931 business rules to the Australian - New Zealand requirements. It should be applied to any invoice, credit note or selfbilled invoice.
 
* JP-PEPPOL-validation.sch derived from the OpenPEPPOL business rules and adapted to JP. It shall be applied to invoices and credit notes.
* JP-PEPPOL-SB-validation.sch derived from the OpenPEPPOL business rules adapted to JP. It shall be applied the selfbilling invoices and selfbilling credit notes.
* JP-PEPPOL-SI-validation.sch derived from the OpenPEPPOL business rules adapted to JP. It shall be applied the　summarized invoices and summarized credit notes.

To validate the syntax, the UBL 2.1 schema shall be used:
* `ubl` - UBL 2.1 (ISO/IEC 19845:2015) 
  * UBL Website: https://www.oasis-open.org/committees/ubl/

   
# Validation process

In order to validate a document instance, the following process should be used:

* Use the UBL Invoice.xsd or the UBL CreditNote.xsd version 2.1 for schema validation depending on the document type
* Validate the syntax boundaries and the derived EN16931 business rules using the JP-UBL-validation.sch
* Validate PEPPOL rules and specific JP business rules using the JP-PEPPOL-validation.sch, JP-PEPPOL-SB-validation.sch, or JP-PEPPOL-SI-validation.sch depending on the type of instance 

This repository contains an xslt folder with the xslt artefacts compiled from the schematron validation artefacts. Any of them can be used for validation of an JP electronic invoice.
