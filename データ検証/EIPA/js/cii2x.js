/**
 * cii2en.js
 *
 * Convert UN/CEFACT CII xml file to eipa-cen XBRL
 * called from cii2x.html
 * 
 * This is a free to use open source software and licensed under the MIT License
 * CC-SA-BY Copyright (c) 2020, Sambuichi Professional Engineers Office
 **/
var eipa = (function() {
  function cii2en(json) {
    var cii = json;
    var en = {};
    var CrossIndustryInvoice = cii['rsm:CrossIndustryInvoice'][0];
    var ExchangedDocument = CrossIndustryInvoice['rsm:ExchangedDocument'];
    if (!ExchangedDocument) { return null; }
    ExchangedDocument = ExchangedDocument[0];
    en['BT-1'] = {
      name: 'Invoice number',
      val: ExchangedDocument['ram:ID']};
    var IssueDateTime = ExchangedDocument['ram:IssueDateTime'];
    if (IssueDateTime) {
      IssueDateTime = IssueDateTime[0];
      en['BT-2'] = {
        name: 'Invoice issue date',
        val: IssueDateTime['udt:DateTimeString']};//['udt:DateTimeString/@format']};
    }
    en['BT-3'] = {
      name: 'Invoice type code',
      val: ExchangedDocument['ram:TypeCode']};
    var SupplyChainTradeTransaction = CrossIndustryInvoice['rsm:SupplyChainTradeTransaction'];
    if (!SupplyChainTradeTransaction) { return null; }
    SupplyChainTradeTransaction = SupplyChainTradeTransaction[0];
    var ApplicableHeaderTradeSettlement = SupplyChainTradeTransaction['ram:ApplicableHeaderTradeSettlement'];
    if (ApplicableHeaderTradeSettlement) {
      ApplicableHeaderTradeSettlement = ApplicableHeaderTradeSettlement[0];
      en['BT-5'] = {
        name: 'Invoice currency code',
        val: ApplicableHeaderTradeSettlement['ram:InvoiceCurrencyCode']};
      en['BT-6'] = {
        name: 'VAT accounting currency code',
        val: ApplicableHeaderTradeSettlement['ram:TaxCurrencyCode']};
    }
    var ApplicableTradeTax = ApplicableHeaderTradeSettlement['ram:ApplicableTradeTax'];
    if (ApplicableTradeTax) {
      ApplicableTradeTax = ApplicableTradeTax[0];
      if (ApplicableTradeTax['ram:TaxPointDate']) {
        en['BT-7'] = {
          name: 'Value added tax point date',
          val: ApplicableTradeTax['ram:TaxPointDate'][0]['udt:DateString']};//['udt:DateString/@format']};
        en['BT-8'] = {
          name: 'Value added tax point date code',
          val: ApplicableTradeTax['ram:DueDateTypeCode']};
      }
    }
    if (ApplicableHeaderTradeSettlement['ram:SpecifiedTradePaymentTerms'] &&
        ApplicableHeaderTradeSettlement['ram:SpecifiedTradePaymentTerms'][0]['ram:DueDateDateTime']) {
      en['BT-9'] = {
        name: 'Payment due date',
        val: ApplicableHeaderTradeSettlement['ram:SpecifiedTradePaymentTerms'][0]['ram:DueDateDateTime'][0]['udt:DateTimeString']};//['udt:DateTimeString/@format']
    }
    var ApplicableHeaderTradeAgreement = SupplyChainTradeTransaction['ram:ApplicableHeaderTradeAgreement'];
    if (ApplicableHeaderTradeAgreement) {
      ApplicableHeaderTradeAgreement = ApplicableHeaderTradeAgreement[0];
      en['BT-10'] = {
        name: 'Buyer reference',
        val: ApplicableHeaderTradeAgreement['ram:BuyerReference']};
      if (ApplicableHeaderTradeAgreement['ram:SpecifiedProcuringProject']) {
        en['BT-11'] = {
          name: 'Project reference',
          val: ApplicableHeaderTradeAgreement['ram:SpecifiedProcuringProject'][0]['ram:ID']};
      }// en['BT-11'] = {name: 'Project reference', val: ApplicableHeaderTradeAgreement['ram:SpecifiedProcuringProject'][0]['ram:Name']};
      if (ApplicableHeaderTradeAgreement['ram:ContractReferencedDocument']) {
        en['BT-12'] = {
          name: 'Contract reference',
          val: ApplicableHeaderTradeAgreement['ram:ContractReferencedDocument'][0]['ram:IssuerAssignedID']};
      }
      if (ApplicableHeaderTradeAgreement['ram:BuyerOrderReferencedDocument']) {
        en['BT-13'] = {
          name: 'Purchase order reference',
          val: ApplicableHeaderTradeAgreement['ram:BuyerOrderReferencedDocument'][0]['ram:IssuerAssignedID']};
      }
      if (ApplicableHeaderTradeAgreement['ram:SellerOrderReferencedDocument']) {
        en['BT-14'] = {
          name: 'Sales order reference',
          val: ApplicableHeaderTradeAgreement['ram:SellerOrderReferencedDocument'][0]['ram:IssuerAssignedID']};
      }
    }
    var ApplicableHeaderTradeDelivery = SupplyChainTradeTransaction['ram:ApplicableHeaderTradeDelivery'];
    if (ApplicableHeaderTradeDelivery) {
      ApplicableHeaderTradeDelivery = ApplicableHeaderTradeDelivery[0];
      if (ApplicableHeaderTradeDelivery['ram:ReceivingAdviceReferencedDocument']) {
        en['BT-15'] = {
          name: 'Receiving advice reference',
          val: ApplicableHeaderTradeDelivery['ram:ReceivingAdviceReferencedDocument'][0]['ram:IssuerAssignedID']};
      }
      if (ApplicableHeaderTradeDelivery['ram:DespatchAdviceReferencedDocument']) {
        en['BT-16'] = {
          name: 'Despatch advice reference',
          val: ApplicableHeaderTradeDelivery['ram:DespatchAdviceReferencedDocument'][0]['ram:IssuerAssignedID']};
      }
    }

    var AdditionalReferencedDocument = ApplicableHeaderTradeAgreement['ram:AdditionalReferencedDocument'];
    if (AdditionalReferencedDocument) {
      AdditionalReferencedDocument = AdditionalReferencedDocument[0];
      en['BT-17'] = {
        name: 'Tender or lot reference',
        val: AdditionalReferencedDocument['ram:IssuerAssignedID']};
      // en['BT-17'] = {name: 'Tender or lot reference', val: AdditionalReferencedDocument['ram:TypeCode']};
      en['BT-18'] = {
        name: 'Invoiced object identifier',
        val: AdditionalReferencedDocument['ram:IssuerAssignedID']};
    }
    // en['BT-18'] = {name: 'Invoiced object identifier', val: AdditionalReferencedDocument['ram:TypeCode']};
    // en['BT-18'] = {name: 'Scheme identifier', val: AdditionalReferencedDocument['ram:ReferenceTypeCode']};
    if (ApplicableHeaderTradeSettlement['ram:ReceivableSpecifiedTradeAccountingAccount']) {
      en['BT-19'] = {
        name: 'Buyer accounting reference',
        val: ApplicableHeaderTradeSettlement['ram:ReceivableSpecifiedTradeAccountingAccount'][0]['ram:ID']};
    }
    if (ApplicableHeaderTradeSettlement['ram:SpecifiedTradePaymentTerms']) {
      en['BT-20'] = {
        name: 'Payment terms',
        val: ApplicableHeaderTradeSettlement['ram:SpecifiedTradePaymentTerms'][0]['ram:Description']};
    }
    // INVOICE NOTE
    en['BG-1'] = {name: 'INVOICE NOTE', val: []};//, val: ExchangedDocument['ram:IncludedNote']};
    if (ExchangedDocument['ram:IncludedNote']) {
      en['BG-1'].val['BT-21'] = {
        name: 'Invoice note subject code',
        val: ExchangedDocument['ram:IncludedNote'][0]['ram:SubjectCode']};
    }
    if (ExchangedDocument['ram:IncludedNote']) {
      en['BG-1'].val['BT-22'] = {
        name: 'Invoice note',
        val: ExchangedDocument['ram:IncludedNote'][0]['ram:Content']};
    }
    // PROCESS CONTROL
    en['BG-2'] = {name: 'PROCESS CONTROL', val: []};//, val: CrossIndustryInvoice['rsm:ExchangedDocumentContext']};
    var ExchangedDocumentContext = CrossIndustryInvoice['rsm:ExchangedDocumentContext'];
    if (ExchangedDocumentContext) {
      ExchangedDocumentContext = ExchangedDocumentContext[0];
      if (ExchangedDocumentContext['ram:BusinessProcessSpecifiedDocumentContextParameter']) {
        en['BG-2'].val['BT-23'] = {
          name: 'Business process type',
          val: ExchangedDocumentContext['ram:BusinessProcessSpecifiedDocumentContextParameter'][0]['ram:ID']};
      }
      if (ExchangedDocumentContext['ram:GuidelineSpecifiedDocumentContextParameter']) {
        en['BG-2'].val['BT-24'] = {
          name: 'Specification identifier',
          val: ExchangedDocumentContext['ram:GuidelineSpecifiedDocumentContextParameter'][0]['ram:ID']};
      }
    }
    // PRECEDING INVOICE REFERENCE
    en['BG-3'] = {name: 'PRECEDING INVOICE REFERENCE', val: []};//, val: ApplicableHeaderTradeSettlement['ram:InvoiceReferencedDocument']};
    if (ApplicableHeaderTradeSettlement['ram:InvoiceReferencedDocument']) {
      en['BG-3'].val['BT-25'] = {
        name: 'Preceding Invoice number',
        val: ApplicableHeaderTradeSettlement['ram:InvoiceReferencedDocument'][0]['ram:IssuerAssignedID']};
      en['BG-3'].val['BT-26'] = {
        name: 'Preceding Invoice issue date',
        val: ApplicableHeaderTradeSettlement['ram:InvoiceReferencedDocument'][0]['ram:FormattedIssueDateTime/qdt:DateTimeString']};
    }
    // en['BT-26'] = {name: 'Preceding Invoice issue date', val: ApplicableHeaderTradeSettlement['ram:InvoiceReferencedDocument'][0]['ram:FormattedIssueDateTime/qdt:DateTimeString/@format']};
    // SELLER
    var SellerTradeParty = ApplicableHeaderTradeAgreement['ram:SellerTradeParty'];
    if (SellerTradeParty) {
      SellerTradeParty = SellerTradeParty[0];
      en['BG-4'] = {name: 'SELLER', val: []};//, val: ApplicableHeaderTradeAgreement['ramiSellerTradeParty']};
      en['BG-4'].val['BT-27'] = {name: 'Seller name', val: SellerTradeParty['ram:Name']};
      if (SellerTradeParty['ram:SpecifiedLegalOrganization']) {
        en['BG-4'].val['BT-28'] = {
          name: 'Seller trading name',
          val: SellerTradeParty['ram:SpecifiedLegalOrganization'][0]['ram:TradingBusinessName']};
      }
      en['BG-4'].val['BT-29'] = {name: 'Seller identifier', val: SellerTradeParty['ram:ID']};
      // en['BT-29'] = {name: 'Seller identifier', val: SellerTradeParty['ram:GlobalID']};
      // en['BT-29'] = {name: 'Seller identifier identificati on scheme identifier', val: ApplicableHeaderTradeAgreement['ram:SeIlerTradeParty'][0]['ram:GlobalID/@schemeID']};
      if (SellerTradeParty['ram:SpecifiedLegalOrganization']) {
        en['BG-4'].val['BT-30'] = {
          name: 'Seller legal registration identifier',
          val: SellerTradeParty['ram:SpecifiedLegalOrganization'][0]['ram:ID']};
      }
      // en['BT-30'] = {name: 'Seller legal registration identifier identificati on scheme identifier', val: SellerTradeParty['ram:SpecifiedLegalOrganization'][0]['ram:ID/@schemeID']};
      if (SellerTradeParty['ram:SpecifiedTaxRegistration']) {
        en['BG-4'].val['BT-31'] = {
          name: 'Seller VAT identifier',
          val: SellerTradeParty['ram:SpecifiedTaxRegistration'][0]['ram:ID']};
        en['BG-4'].val['BT-32'] = {
          name: 'Seller tax registration identifier',
          val: SellerTradeParty['ram:SpecifiedTaxRegistration'][0]['ram:ID']};
      }
      en['BG-4'].val['BT-33'] = {
        name: 'Seller additional legal information',
        val: SellerTradeParty['ram:Description']};
      if (SellerTradeParty['ram:URIUniversalCommunication']) {
        en['BG-4'].val['BT-34'] = {
          name: 'Seller electronic address',
          val: SellerTradeParty['ram:URIUniversalCommunication'][0]['ram:URIID']};
      }
    }
    // en['BT-34'] = {name: 'Seller electronic address identificati on scheme identifier', val: SellerTradeParty['ram:URIUniversalCommunication'][0]['ram:URIID/@schemeID']};
    en['BG-4'].val['BG-5'] = {name: 'SELLER POSTAL ADDRESS', val: []};//, val: SellerTradeParty['ram:PostalTradeAddress']};
    var SellerPostalTradeAddress = SellerTradeParty['ram:PostalTradeAddress'];
    if (SellerPostalTradeAddress) {
      SellerPostalTradeAddress = SellerPostalTradeAddress[0];
      en['BG-4'].val['BG-5'].val['BT-35'] = {
        name: 'Seller address line 1', val: SellerPostalTradeAddress['ram:LineOne']};
      en['BG-4'].val['BG-5'].val['BT-36'] = {
        name: 'Seller address line 2', val: SellerPostalTradeAddress['ram:LineTwo']};
      en['BG-4'].val['BG-5'].val['BT-162'] = {
        name: 'Seller address line 3', val: SellerPostalTradeAddress['ram:LineThree']};
      en['BG-4'].val['BG-5'].val['BT-37'] = {
        name: 'Seller city', val: SellerPostalTradeAddress['ram:CityName']};
      en['BG-4'].val['BG-5'].val['BT-38'] = {
        name: 'Seller post code', val: SellerPostalTradeAddress['ram:PostcodeCode']};
      en['BG-4'].val['BG-5'].val['BT-39'] = {
        name: 'Seller country subdivision', val: SellerPostalTradeAddress['ram:CountrySubDivisionName']};
      en['BG-4'].val['BG-5'].val['BT-40'] = {
        name: 'Seller country code', val: SellerPostalTradeAddress['ram:CountryID']};
    }
    en['BG-4'].val['BG-6'] = {name: 'SELLER CONTACT', val: []};//, val: ApplicableHeaderTradeAgreement['ram:SeIlerTradeParty'][0]['ram:DefinedTradeContact']};
    var SellerDefinedTradeContact = SellerTradeParty['ram:DefinedTradeContact'];
    if (SellerDefinedTradeContact) {
      SellerDefinedTradeContact = SellerDefinedTradeContact[0];
      en['BG-4'].val['BG-6'].val['BT-41'] = {
        name: 'Seller contact point', val: SellerDefinedTradeContact['ram:PersonName']};
      en['BG-4'].val['BG-6'].val['BT-41'] = {
        name: 'Seller contact point', val: SellerDefinedTradeContact['ram:DepartmentName']};
      if (SellerDefinedTradeContact['ram:TelephoneUniversalCommunication']) {
        en['BG-4'].val['BG-6'].val['BT-42'] = {
          name: 'Seller contact telephone number',
          val: SellerDefinedTradeContact['ram:TelephoneUniversalCommunication'][0]['ram:CompleteNumber']};
      }
      if (SellerDefinedTradeContact['ram:EmailURIUniversalCommunication']) {
        en['BG-4'].val['BG-6'].val['BT-43'] = {
          name: 'Seller contact email address',
          val: SellerDefinedTradeContact['ram:EmailURIUniversalCommunication'][0]['ram:URIID']};
      }
    }
    // BUYER
    var BuyerTradeParty = ApplicableHeaderTradeAgreement['ram:BuyerTradeParty'];
    en['BG-7'] = {name: 'BUYER', val: []};//, val: ApplicableHeaderTradeAgreement['ram:BuyerTradeParty']};
    if (BuyerTradeParty) {
      BuyerTradeParty = BuyerTradeParty[0];
      en['BG-7'].val['BT-44'] = {
        name: 'Buyer name', val: BuyerTradeParty['ram:Name']};
      var BuyerSpecifiedLegalOrganization = BuyerTradeParty['ram:SpecifiedLegalOrganization'];
      if (BuyerSpecifiedLegalOrganization) {
        BuyerSpecifiedLegalOrganization = BuyerSpecifiedLegalOrganization[0];
        en['BG-7'].val['BT-45'] = {
          name: 'Buyer trading name', val: BuyerSpecifiedLegalOrganization['ram:TradingBusinessName']};
        en['BG-7'].val['BT-47'] = {
          name: 'Buyer legal registration identifier', val: BuyerSpecifiedLegalOrganization['ram:ID']};
      }
      en['BG-7'].val['BT-46'] = {name: 'Buyer identifier', val: BuyerTradeParty['ram:ID']};
      // en['BT-46'] = {name: 'Buyer identifier', val: BuyerTradeParty['ram:Globa1ID']};
      // en['BT-46'] = {name: 'Buyer identifier identificati on scheme identifier', val: BuyerTradeParty['ram:GlobaHD/@schemeID']};
      // en['BT-47'] = {name: 'Buyer legal registration identifier identification  scheme identifier', val: BuyerSpecifiedLegalOrganization['ram:ID/@schemeID']};
      if (BuyerTradeParty['ram:SpecifiedTaxRegistration']) {
        en['BG-7'].val['BT-48'] = {
          name: 'Buyer VAT identifier',
          val: BuyerTradeParty['ram:SpecifiedTaxRegistration'][0]['ram:ID']};
      }
      if (BuyerTradeParty['ram:URIUniversalCommunication']) {
        en['BG-7'].val['BT-49'] = {
          name: 'Buyer electronic address',
          val: BuyerTradeParty['ram:URIUniversalCommunication'][0]['ram:URIID']};
      }
    }
    // en['BT-49'] = {name: 'Buyer electronic address identificati on scheme  identifier', val: SupplyChainTradeTransaction['ram:ApplicabIeHeaderTradeAgreement'][0]['ram:BuyerTradeParty'][0]['ram:URIUniversalCommunication'][0]['ram:URIID/@schemeID']};
    var BuyerPostalTradeAddress = BuyerTradeParty['ram:PostalTradeAddress'];
    if (BuyerPostalTradeAddress) {
      BuyerPostalTradeAddress = BuyerPostalTradeAddress[0];
      en['BG-7'].val['BG-8'] = {name: 'BUYER POSTAL ADDRESS', val: []};//, val: BuyerTradeParty['ram:PostaITradeAddress']};
      en['BG-7'].val['BG-8'].val['BT-50'] = {
        name: 'Buyer address line 1', val: BuyerPostalTradeAddress['ram:LineOne']};
      en['BG-7'].val['BG-8'].val['BT-51'] = {
        name: 'Buyer address line 2', val: BuyerPostalTradeAddress['ram:LineTwo']};
      en['BG-7'].val['BG-8'].val['BT-163'] = {
        name: 'Buyer address line 3', val: BuyerPostalTradeAddress['ram:LineThree']};
      en['BG-7'].val['BG-8'].val['BT-52'] = {
        name: 'Buyer city', val: BuyerPostalTradeAddress['ram:CityName']};
      en['BG-7'].val['BG-8'].val['BT-53'] = {
        name: 'Buyer post code', val: BuyerPostalTradeAddress['ram:PostcodeCode']};
      en['BG-7'].val['BG-8'].val['BT-54'] = {
        name: 'Buyer country subdivision', val: BuyerPostalTradeAddress['ram:CountrySubDivisionName']};
      en['BG-7'].val['BG-8'].val['BT-55'] = {
        name: 'Buyer country code', val: BuyerPostalTradeAddress['ram:CountryID']};
    }
    var BuyerDefinedTradeContact = BuyerTradeParty['ram:DefinedTradeContact'];
    if (BuyerDefinedTradeContact) {
      BuyerDefinedTradeContact = BuyerDefinedTradeContact[0];
      en['BG-7'].val['BG-9'] = {name: 'BUYER CONTACT', val: []};//, val: SupplyChainTradeTransaction['ram;ApplicableHeaderTradeAgreement'][0]['ram:BuyerTradeParty'][0]['ram:DefinedTradeContact']};
      en['BG-7'].val['BG-9'].val['BT-56'] = {
        name: 'Buyer contact point', val: BuyerDefinedTradeContact['ram:PersonName']};
      // en['BT-56'] = {name: 'Buyer contact point', val: BuyerDefinedTradeContact['ram:DepartmentName']};
      if (BuyerDefinedTradeContact['ram:TelephoneUniversalCommunication']) {
        en['BG-7'].val['BG-9'].val['BT-57'] = {
          name: 'Buyer contact telephone number',
          val: BuyerDefinedTradeContact['ram:TelephoneUniversalCommunication'][0]['ram:CompleteNumber']};
      }
      if (BuyerDefinedTradeContact['ram:EmailURIUniversalCommunication']) {
        en['BG-7'].val['BG-9'].val['BT-58'] = {
          name: 'Buyer contact email address',
          val: BuyerDefinedTradeContact['ram:EmailURIUniversalCommunication'][0]['ram:URIID']};
      }
    }
    // PAYEE
    var PayeeTradeParty = ApplicableHeaderTradeSettlement['ram:PayeeTradeParty'];
    if (PayeeTradeParty) {
      PayeeTradeParty = PayeeTradeParty[0];
      en['BG-10'] = {name: 'PAYEE', val: []};//, val: ApplicableHeaderTradeSettlement['ramiPayeeTradeParty']};
      en['BG-10'].val['BT-59'] = {name: 'Payee name', val: PayeeTradeParty['ram:Name']};
      en['BG-10'].val['BT-60'] = {name: 'Payee identifier', val: PayeeTradeParty['ram:ID']};
      // en['BT-60'] = {name: 'Payee identifier', val: PayeeTradeParty['ram:GlobalID']};
      // en['BT-60'] = {name: 'Payee identifier identificati on scheme identifier', val: PayeeTradeParty['ram:GlobalID/@schemeID']};
      if (PayeeTradeParty['ram:SpecifiedLegalOrganization']) {
        en['BG-10'].val['BT-61'] = {
          name: 'Payee legal registration identifier',
          val: PayeeTradeParty['ram:SpecifiedLegalOrganization'][0]['ram:ID']};
        // en['BT-61'] = {name: 'Payee legal registration identifier identificati on scheme identifier', val: PayeeTradeParty['ram:SpecifiedLegalOrganization'][0]['ram:ID/@schemeID']};
      }
    }
    // SELLER TAX REPRESENTATIVE PARTY
    var SellerTaxRepresentativeTradeParty = ApplicableHeaderTradeAgreement['ram:SellerTaxRepresentativeTradeParty'];
    if (SellerTaxRepresentativeTradeParty) {
      SellerTaxRepresentativeTradeParty = SellerTaxRepresentativeTradeParty[0];
      en['BG-11'] = {name: 'SELLER TAX REPRESENTATIVE PARTY', val: []};//, val: CrossIndustryInvoice['rsm:SuppIyChainTradeTransaction'][0]['ram:ApplicableHeaderTradeAgreement'][0]['ram:SellerTaxRepresentativeTradeParty']};
      en['BG-11'].val['BT-62'] = {
        name: 'Seller tax representative name', val: SellerTaxRepresentativeTradeParty['ram:Name']};
      if (SellerTaxRepresentativeTradeParty['ram:SpecifiedTaxRegistration']) {
        en['BG-11'].val['BT-63'] = {
          name: 'Seller tax representative VAT identifier',
          val: SellerTaxRepresentativeTradeParty['ram:SpecifiedTaxRegistration'][0]['ram:ID']};
      }
      var SellerTaxRepresentativePostalTradeAddress = SellerTaxRepresentativeTradeParty['ram:PostalTradeAddress'];
      if (SellerTaxRepresentativePostalTradeAddress) {
        SellerTaxRepresentativePostalTradeAddress = SellerTaxRepresentativePostalTradeAddress[0];
        en['BG-11'].val['BG-12'] = {name: 'SELLER TAX REPRESENTATIVE POSTAL  ADDRESS', val: []};//, val: SellerTaxRepresentativeTradeParty['ram:PostalTradeAddress']};
        en['BG-11'].val['BG-12'].val['BT-64'] = {
          name: 'Tax representative address line 1', val: SellerTaxRepresentativePostalTradeAddress['ram:LineOne']};
        en['BG-11'].val['BG-12'].val['BT-65'] = {
          name: 'Tax representative address line 2', val: SellerTaxRepresentativePostalTradeAddress['ram:LineTwo']};
        en['BG-11'].val['BG-12'].val['BT-164'] = {
          name: 'Tax representative address line 3', val: SellerTaxRepresentativePostalTradeAddress['ram:LineThree']};
        en['BG-11'].val['BG-12'].val['BT-66'] = {
          name: 'Tax representative city', val: SellerTaxRepresentativePostalTradeAddress['ram:CityName']};
        en['BG-11'].val['BG-12'].val['BT-67'] = {
          name: 'Tax representative post code', val: SellerTaxRepresentativePostalTradeAddress['ram:PostcodeCode']};
        en['BG-11'].val['BG-12'].val['BT-68'] = {
          name: 'Tax representative country subdivision', val: SellerTaxRepresentativePostalTradeAddress['ram:CountrySubDivisionName']};
        en['BG-11'].val['BG-12'].val['BT-69'] = {
          name: 'Tax representative country code', val: SellerTaxRepresentativePostalTradeAddress['ram:CountryID']};
      }
    }
    // DELIVERY INFORMATION
    en['BG-13'] = {name: 'DELIVERY INFORMATION', val: []};//, val: ApplicableHeaderTradeDelivery['ram:ShipToTradeParty']};
    if (ApplicableHeaderTradeDelivery) {
      var ShipToTradeParty = ApplicableHeaderTradeDelivery['ram:ShipToTradeParty'];
      if (ShipToTradeParty) {
        ShipToTradeParty = ShipToTradeParty[0];
        en['BG-13'].val['BT-70'] = {
          name: 'Deliver to party name', val: ShipToTradeParty['ram:Name']};
        en['BG-13'].val['BT-71'] = {
          name: 'Deliver to location identifier', val: ShipToTradeParty['ram:ID']};
        // en['BT-71'] = {name: 'Deliver to location identifier', val: ShipToTradeParty['ram:GlobalID']};
        // en['BT-71'] = {name: 'Deliver to location identifier identificati on  scheme identifier', val: ShipToTradeParty['ram:GlobalID/@schemeID']};
        if (ApplicableHeaderTradeDelivery['ram:ActualDeliverySupplyChainEvent'] &&
            ApplicableHeaderTradeDelivery['ram:ActualDeliverySupplyChainEvent'][0]['ram:OccurrenceDateTime']) {
          en['BG-13'].val['BT-72'] = {
            name: 'Actual delivery date',
            val: ApplicableHeaderTradeDelivery['ram:ActualDeliverySupplyChainEvent'][0]['ram:OccurrenceDateTime'][0]['udt:DateTimeString']};
        }
      }
      var BillingSpecifiedPeriod = ApplicableHeaderTradeSettlement['ram:BillingSpecifiedPeriod'];
      if (BillingSpecifiedPeriod) {
        BillingSpecifiedPeriod = BillingSpecifiedPeriod[0];
        en['BG-13'].val['BG-14'] = {name: 'DELIVERY OR INVOICE PERIOD', val: []};//, val: ApplicableHeaderTradeSettlement['ram:BillingSpecifiedPeriod']};
        if (BillingSpecifiedPeriod['ram:StartDateTime']) {
          en['BG-13'].val['BG-14'].val['BT-73'] = {
            name: 'Invoicing period start date',
            val: BillingSpecifiedPeriod['ram:StartDateTime'][0]['udt:DateTimeString']};
          // en['BT-73'] = {name: 'Invoicing period start date', val: BillingSpecifiedPeriod['ram:StartDateTime'][0]['udt:DateTimeString/@format']};
        }
      if (BillingSpecifiedPeriod['ram:EndDateTime']) {
          en['BG-13'].val['BG-14'].val['BT-74'] = {
            name: 'Invoicing period end date',
            val: BillingSpecifiedPeriod['ram:EndDateTime'][0]['udt:DateTimeStrlng']};
          // en['BT-74'] = {name: 'Invoicing period end date', val: BillingSpecifiedPeriod['ram:EndDateTime'][0]['udt:DateTimeString/@format']};
        }
      }
      // var ApplicableHeaderTradeDelivery = ApplicableHeaderTradeDelivery;
      var ShipToPostalTradeAddress = ShipToTradeParty['ram:PostalTradeAddress'];
      if (ShipToPostalTradeAddress) {
        ShipToPostalTradeAddress = ShipToPostalTradeAddress[0];
        en['BG-13'].val['BG-15'] = {name: 'DELIVER TO ADDRESS', val: []};//, val: ShipToTradeParty['ram:PostalTradeAddress']};
        en['BG-13'].val['BG-15'].val['BT-75'] = {
          name: 'Deliver to address line 1', val: ShipToPostalTradeAddress['ram:LineOne']};
        en['BG-13'].val['BG-15'].val['BT-76'] = {
          name: 'Deliver to address line 2', val: ShipToPostalTradeAddress['ram:LineTwo']};
        en['BG-13'].val['BG-15'].val['BT-165'] = {
          name: 'Deliver to address line 3', val: ShipToPostalTradeAddress['ram:LineThree']};
        en['BG-13'].val['BG-15'].val['BT-77'] = {
          name: 'Deliver to city', val: ShipToPostalTradeAddress['ram:CityName']};
        en['BG-13'].val['BG-15'].val['BT-78'] = {
          name: 'Deliver to post code', val: ShipToPostalTradeAddress['ram:PostcodeCode']};
        en['BG-13'].val['BG-15'].val['BT-79'] = {
          name: 'Deliver to country subdivision', val: ShipToPostalTradeAddress['ram:CountrySubDivisionName']};
        en['BG-13'].val['BG-15'].val['BT-80'] = {
          name: 'Deliver to country code', val: ShipToPostalTradeAddress['ram:CountryID']};
      }
    }
    // PAYMENT INSTRUCTIONS
    var SpecifiedTradeSettlementPaymentMeans = ApplicableHeaderTradeSettlement['ram:SpecifiedTradeSettlementPaymentMeans'];
    if (SpecifiedTradeSettlementPaymentMeans) {
      SpecifiedTradeSettlementPaymentMeans = SpecifiedTradeSettlementPaymentMeans[0];
      en['BG-16'] = {name: 'PAYMENT INSTRUCTIONS', val: []};//, val: ApplicableHeaderTradeSettlement['ram:SpecifiedTradeSettlementPaymentMeans']};
      en['BG-16'].val['BT-81'] = {
        name: 'Payment means type code', val: SpecifiedTradeSettlementPaymentMeans['ram:TypeCode']};
      en['BG-16'].val['BT-82'] = {
        name: 'Payment means text', val: SpecifiedTradeSettlementPaymentMeans['ram:Information']};
      en['BG-16'].val['BT-83'] = {
        name: 'Remittance information', val: ApplicableHeaderTradeSettlement['ram:PaymentReference']};
      var PayeePartyCreditorFinancialAccount = SpecifiedTradeSettlementPaymentMeans['ram:PayeePartyCreditorFinancialAccount'];
      if (PayeePartyCreditorFinancialAccount) {
        PayeePartyCreditorFinancialAccount = PayeePartyCreditorFinancialAccount[0]
        en['BG-16'].val['BG-17'] = {name: 'CREDIT TRANSFER', val: []};//, val: SpecifiedTradeSettlementPaymentMeans['ram:PayeePartyCreditorFinancialAccount']};
        en['BG-16'].val['BG-17'].val['BT-84'] = {
          name: 'Payment account identifier', val: PayeePartyCreditorFinancialAccount['ram:IBANID']};
        // en['BG-16'].val['BT-84'] = {name: 'Payment account identifier', val: PayeePartyCreditorFinancialAccount['ram:ProprietarylD']};
        en['BG-16'].val['BG-17'].val['BT-85'] = {
          name: 'Payment account name', val: PayeePartyCreditorFinancialAccount['ram:AccountName']};
      }
      if (SpecifiedTradeSettlementPaymentMeans['ram:PayeeSpecifiedCreditorFinancialInstitution']) {
        en['BG-16'].val['BG-17'].val['BT-86'] = {
          name: 'Payment service provider identifier',
          val: SpecifiedTradeSettlementPaymentMeans['ram:PayeeSpecifiedCreditorFinancialInstitution'][0]['ram:BICID']};
      }
      // en['BG-16'].val['BT-86'] = {name: 'Payment service provider identifier', val: SpecifiedTradeSettlementPaymentMeans['ram:PayeeSpecifiedCreditorFinancialInstitution'][0]['ram:BICID']};
      var ApplicableTradeSettlementFinancialCard = SpecifiedTradeSettlementPaymentMeans['ram:ApplicableTradeSettlementFinancialCard'];
      if (ApplicableTradeSettlementFinancialCard) {
        ApplicableTradeSettlementFinancialCard = ApplicableTradeSettlementFinancialCard[0];
        en['BG-16'].val['BG-18'] = {name: 'PAYMENT CARD INFORMATION', val: []};//, val: SpecifiedTradeSettlementPaymentMeans['ram:ApplicableTradeSettlementFinancialCard']};
        en['BG-16'].val['BG-18'].val['BT-87'] = {
          name: 'Payment card primary account number',
          val: ApplicableTradeSettlementFinancialCard['ram:ID']};
        en['BG-16'].val['BG-18'].val['BT-88'] = {
          name: 'Payment card holder name',
          val: ApplicableTradeSettlementFinancialCard['ram:CardholderName']};
      }
      en['BG-16'].val['BG-19'] = {name: 'DIRECT DEBIT', val: []};//, val: SupplyChainTradeTransaction['ram:ApplicableHeaderTradeSettlement']};
      if (ApplicableHeaderTradeSettlement['ram:SpecifiedTradePaymentTerms']) {
        en['BG-16'].val['BG-19'].val['BT-89'] = {
          name: 'Mandate reference identifier',
          val: ApplicableHeaderTradeSettlement['ram:SpecifiedTradePaymentTerms'][0]['ram:DirectDebitMandatelD']};
      }
      en['BG-16'].val['BG-19'].val['BT-90'] = {
        name: 'Bank assigned creditor identifier',
        val: ApplicableHeaderTradeSettlement['ram:CreditorReferenceID']};
      if (SpecifiedTradeSettlementPaymentMeans['ram:PayerPartyDebtorFinancialAccount']) {
        en['BG-16'].val['BG-19'].val['BT-91'] = {
          name: 'Debited account identifier',
          val: SpecifiedTradeSettlementPaymentMeans['ram:PayerPartyDebtorFinancialAccount'][0]['ram:IBANID']};
      }
    }
    // DOCUMENT LEVEL ALLOWANCES
    var SpecifiedTradeAllowanceCharge = ApplicableHeaderTradeSettlement['ram:SpecifiedTradeAllowanceCharge'];
    if (SpecifiedTradeAllowanceCharge) {
      SpecifiedTradeAllowanceCharge = SpecifiedTradeAllowanceCharge[0];
      en['BG-20'] = {name: 'DOCUMENT LEVEL ALLOWANCES', val: []};//, val: ApplicableHeaderTradeSettlement['ram:SpecifiedTradeA]lowanceCharge']};
      en['BG-20'].val['BT-92'] = {
        name: 'Document level allowance amount',
        val: SpecifiedTradeAllowanceCharge['ram:ActualAmount']};
      if (ApplicableHeaderTradeSettlement['ramiSpecifiedTradeAllowanceCharge']) {
        en['BG-20'].val['BT-93'] = {
          name: 'Document level allowance base amount',
          val: ApplicableHeaderTradeSettlement['ramiSpecifiedTradeAllowanceCharge'][0]['ram:BasisAmount']};
      }
      en['BG-20'].val['BT-94'] = {
        name: 'Document level allowance percentage',
        val: SpecifiedTradeAllowanceCharge['ram:CalculationPercent']};
      var CategoryTradeTax = SpecifiedTradeAllowanceCharge['ram:CategoryTradeTax'];
      if (CategoryTradeTax) {
        CategoryTradeTax = CategoryTradeTax[0];
        en['BG-20'].val['BT-95'] = {
          name: 'Document level allowance VAT category code',
          val: CategoryTradeTax['ram:TypeCode']};
        // en['BT-95'] = {name: 'Document level allowance VAT category code', val: CategoryTradeTax['ram:CategoryCode']};
        en['BG-20'].val['BT-96'] = {
          name: 'Document level allowance VAT rate',
          val: CategoryTradeTax['ram:RateApplicablePercent']};
        en['BG-20'].val['BT-97'] = {
          name: 'Document level allowance reason',
          val: SpecifiedTradeAllowanceCharge['ram:Reason']};
        en['BG-20'].val['BT-98'] = {
          name: 'Document level allowance reason code',
          val: SpecifiedTradeAllowanceCharge['ram:ReasonCode']};
        en['BG-21'] = {name: 'DOCUMENT LEVEL CHARGES', val: []};//, val: ApplicableHeaderTradeSettlement['ram:SpecifiedTradeAllowanceCharge']};
        en['BG-21'].val['BT-99'] = {
          name: 'Document level charge amount',
          val: SpecifiedTradeAllowanceCharge['ram:ActualAmount']};
        en['BG-21'].val['BT-100'] = {
          name: 'Document level charge base amount',
          val: SpecifiedTradeAllowanceCharge['ram:BasisAmount']};
        en['BG-21'].val['BT-101'] = {
          name: 'Document level charge percentage',
          val: SpecifiedTradeAllowanceCharge['ram:CalculationPercent']};
        en['BG-21'].val['BT-102'] = {
          name: 'Document level charge VAT category code',
          val: CategoryTradeTax['ram:TypeCode']};
        en['BG-21'].val['BT-102'] = {
          name: 'Document level charge VAT category code',
          val: CategoryTradeTax['ram:CategoryCode']};
        en['BG-21'].val['BT-103'] = {
          name: 'Document level charge VAT rate',
          val: CategoryTradeTax['ram:RateApplicablePercent']};
        en['BG-21'].val['BT-104'] = {
          name: 'Document level charge reason',
          val: SpecifiedTradeAllowanceCharge['ram:Reason']};
        en['BG-21'].val['BT-105'] = {
          name: 'Document level charge reason code',
          val: SpecifiedTradeAllowanceCharge['ram:ReasonCode']};
      }
    }
    // DOCUMENT TOTALS
    var SpecifiedTradeSettlementHeaderMonetarySummation = ApplicableHeaderTradeSettlement['ram:SpecifiedTradeSettlementHeaderMonetarySummation'];
    if (SpecifiedTradeSettlementHeaderMonetarySummation) {
      SpecifiedTradeSettlementHeaderMonetarySummation = SpecifiedTradeSettlementHeaderMonetarySummation[0];
      en['BG-22'] = {name: 'DOCUMENT TOTALS', val: []};//, val: ApplicableHeaderTradeSettlement['ram:SpecifiedTradeSettlementHeaderMonetarySummation']};
      en['BG-22'].val['BT-106'] = {
        name: 'Sum of Invoice line net amount',
        val: SpecifiedTradeSettlementHeaderMonetarySummation['ram:LineTotalAmount']};
      en['BG-22'].val['BT-107'] = {
        name: 'Sum of allowances on document level', val: SpecifiedTradeSettlementHeaderMonetarySummation['ram:AllowanceTotalAmount']};
      en['BG-22'].val['BT-108'] = {
        name: 'Sum of charges on document level',
        val: SpecifiedTradeSettlementHeaderMonetarySummation['ram:ChargeTotalAmount']};
      en['BG-22'].val['BT-109'] = {
        name: 'Invoice total amount without VAT',
        val: SpecifiedTradeSettlementHeaderMonetarySummation['ram:TaxBasisTotalAmount']};
      en['BG-22'].val['BT-110'] = {
        name: 'Invoice total VAT amount',
        val: SpecifiedTradeSettlementHeaderMonetarySummation['ram:TaxTotalAmount']};
      en['BG-22'].val['BT-111'] = {
        name: 'Invoice total VAT amount in accounting currency',
        val: SpecifiedTradeSettlementHeaderMonetarySummation['ram:TaxTotalAmount']};
      en['BG-22'].val['BT-112'] = {
        name: 'Invoice total amount with VAT',
        val: SpecifiedTradeSettlementHeaderMonetarySummation['ram:GrandTotalAmount']};
      en['BG-22'].val['BT-113'] = {
        name: 'Paid amount',
        val: SpecifiedTradeSettlementHeaderMonetarySummation['ram:TotalPrepaidAmount']};
      en['BG-22'].val['BT-114'] = {
        name: 'Rounding amount',
        val: SpecifiedTradeSettlementHeaderMonetarySummation['ram:RoundingAmount']};
      en['BG-22'].val['BT-115'] = {
        name: 'Amount due for payment',
        val: SpecifiedTradeSettlementHeaderMonetarySummation['ram:DuePayableAmount']};
    }
    // VAT BREAKDOWN
    if (ApplicableTradeTax) {
      en['BG-23'] = {name: 'VAT BREAKDOWN', val: []};//, val: ApplicableHeaderTradeSettlement['ram:ApplicableTradeTax']};
      en['BG-23'].val['BT-116'] = {
        name: 'VAT category taxable amount', val: ApplicableTradeTax['ram:BasisAmount']};
      en['BG-23'].val['BT-117'] = {
        name: 'VAT category tax amount', val: ApplicableTradeTax['ram:CalculatedAmount']};
      en['BG-23'].val['BT-118'] = {
        name: 'VAT category code', val: ApplicableTradeTax['ram:TypeCode']};
      // en['BT-118'] = {name: 'VAT category code', val: SupplyChainTradeTransaction['ram:ApplicableHeaderTradeSettIement'][0]['ram:ApplicableTradeTax'][0]['ram:CategoryCode']};
      en['BG-23'].val['BT-119'] = {
        name: 'VAT category rate', val: ApplicableTradeTax['ram:RateApplicablePercent']};
      en['BG-23'].val['BT-120'] = {
        name: 'VAT exemption reason text', val: ApplicableTradeTax['ram:ExemptionReason']};
      en['BG-23'].val['BT-121'] = {
        name: 'VAT exemption reason code', val: ApplicableTradeTax['ram:ExemptionReasonCode']};
    }
    // ADDITIONAL SUPPORTING DOCUMENTS
    if (AdditionalReferencedDocument) {
      en['BG-24'] = {name: 'ADDITIONAL SUPPORTING DOCUMENTS', val: []};//, val: ApplicableHeaderTradeAgreement['ram:AdditionalReferencedDocument']};
      en['BG-24'].val['BT-122'] = {
        name: 'Supportin g document reference', val: AdditionalReferencedDocument['ram:IssuerAssignedID']};
      // en['BT-122'] = {name: 'Supportin g document reference', val: AdditionalReferencedDocument['ram:TypeCode']};
      en['BG-24'].val['BT-123'] = {
        name: 'Supportin g document description', val: AdditionalReferencedDocument['ram:Name']};
      en['BG-24'].val['BT-124'] = {
        name: 'External document location', val: AdditionalReferencedDocument['ram:URIID']};
      en['BG-24'].val['BT-125'] = {
        name: 'Attached document', val: AdditionalReferencedDocument['ram:AttachmentBinaryObject']};
      // en['BT-125'] = {name: 'Attached document Mime code', val: AdditionalReferencedDocument['ram:AttachmentBinaryObject/@mimeCode']};
      // en['BT-125'] = {name: 'Attached document Filename', val: CrossIndustryInvoice['rsm:SuppIyChainTradeTransaction'][0]['ram:ApplicableHeaderTradeAgreement'][0]['ram:AdditionalReferencedDocument'][0]['ram:AttachmentBinaryObject/@filename']};
    }
    // INVOICE LINE
    var IncludedSupplyChainTradeLineItems = SupplyChainTradeTransaction['ram:IncludedSupplyChainTradeLineItem'];
    if (IncludedSupplyChainTradeLineItems) {
      en['BG-25'] = {name: 'INVOICE LINE', val: []};//, val: SupplyChainTradeTransaction['ram:IncludedSupplyChainTradeLineltem']};
      for (var i = 0; i < IncludedSupplyChainTradeLineItems.length; i++) {
        var IncludedSupplyChainTradeLineItem = IncludedSupplyChainTradeLineItems[i];
        var bg_25 = {};
        var AssociatedDocumentLineDocuments = IncludedSupplyChainTradeLineItem['ram:AssociatedDocumentLineDocument'];
        if (AssociatedDocumentLineDocuments) {
          var AssociatedDocumentLineDocument = AssociatedDocumentLineDocuments[0];
          bg_25['BT-126'] = {name: 'Invoice line identifier', val: AssociatedDocumentLineDocument['ram:LineID']};
          if (AssociatedDocumentLineDocument['ram:IncludedNote']) {
            bg_25['BT-127'] = {
              name: 'Invoice line note',
              val: AssociatedDocumentLineDocument['ram:IncludedNote'][0]['ram:Content']};
          }
        }
        var SpecifiedLineTradeSettlements = IncludedSupplyChainTradeLineItem['ram:SpecifiedLineTradeSettlement'];
        if (SpecifiedLineTradeSettlements) {
          var SpecifiedLineTradeSettlement = SpecifiedLineTradeSettlements[0];
          var AdditionalReferencedDocument = SpecifiedLineTradeSettlement['ram:AdditionalReferencedDocument'];
          if (AdditionalReferencedDocument) {
            AdditionalReferencedDocument = AdditionalReferencedDocument[0];
            bg_25['BT-128'] = {
              name: 'Invoice line object identifier',
              val: AdditionalReferencedDocument['ram:IssuerAssignedID']};
          }
        }
        // en['BT-128'] = {name: 'Invoice line object identifier', val: SpecifiedLineTradeSettlement['ram:AdditionalReferencedDocument'][0]['ram:TypeCode']};
        // en['BT-128'] = {name: 'Invoice line object identifier identificati on  scheme identifier', val: SpecifiedLineTradeSettlement['ram:AdditionalReferencedDocument'][0]['ram:ReferenceTypeCode']};
        var SpecifiedLineTradeDeliveries = IncludedSupplyChainTradeLineItem['ram:SpecifiedLineTradeDelivery'];
        if (SpecifiedLineTradeDeliveries) {
          var SpecifiedLineTradeDelivery = SpecifiedLineTradeDeliveries[0];
          bg_25['BT-129'] = {
            name: 'Invoiced quantity', val: SpecifiedLineTradeDelivery['ram:BilledQuantity']};
          bg_25['BT-130'] = {
            name: 'Invoiced quantity unit of measure',
            val: SpecifiedLineTradeDelivery['ram:BilledQuantity']};//@unitCode']};
        }
        if (SpecifiedLineTradeSettlement['ram:SpecifiedTradeSettlementLineMonetarySummation']) {
          bg_25['BT-131'] = {
            name: 'Invoice line net amount',
            val: SpecifiedLineTradeSettlement['ram:SpecifiedTradeSettlementLineMonetarySummation'][0]['ram:LineTotalAmount']};
        }
        var SpecifiedLineTradeAgreement = IncludedSupplyChainTradeLineItem['ram:SpecifiedLineTradeAgreement'];
        if (SpecifiedLineTradeAgreement) {
          SpecifiedLineTradeAgreement = SpecifiedLineTradeAgreement[0];
          if (SpecifiedLineTradeAgreement['ram:BuyerOrderReferencedDocument']) {
            bg_25['BT-132'] = {
              name: 'Referenced purchase order line reference',
              val: SpecifiedLineTradeAgreement['ram:BuyerOrderReferencedDocument'][0]['ram:LineID']};
          }
        }
        if (SpecifiedLineTradeSettlement['ram:ReceivableSpecifiedTradeAccountingAccount']) {
          bg_25['BT-133'] = {
            name: 'Invoice line Buyer accounting reference',
            val: SpecifiedLineTradeSettlement['ram:ReceivableSpecifiedTradeAccountingAccount'][0]['ram:ID']};
        }
        var BillingSpecifiedPeriods = SpecifiedLineTradeSettlement['ram:BillingSpecifiedPeriod'];
        if (BillingSpecifiedPeriods) {
          var BillingSpecifiedPeriod = BillingSpecifiedPeriods[0];
          bg_25['BG-26'] = {name: 'INVOICE LINE PERIOD', val: []};//, val: SpecifiedLineTradeSettlement['ram:BillingSpecifiedPeriod']};
          bg_25['BG-26'].val['BT-134'] = {
            name: 'Invoice line period start date',
            val: BillingSpecifiedPeriod['ram:StartDateTime'][0]['udt:DateTimeString']};
          // bg_25['BT-134'] = {name: 'Invoice line period start date', val: SupplyChainTradeTransaction['ram:IncludedSupplyChainTradeLineltem/ranrSpecifiedLineTradeSettlement'][0]['ram:BillingSpecifiedPeriod'][0]['ram:StartDateTime'][0]['udt:DateTimeString/@format']};
          bg_25['BG-26'].val['BT-135'] = {
            name: 'Invoice line period end date',
            val: BillingSpecifiedPeriod['ram:EndDateTime'][0]['udt:DateTimeString']};
          // bg_25['BT-135'] = {name: 'Invoice line period end date', val: BillingSpecifiedPeriod['ram:EndDateTime'][0]['udt:DateTimeString/@format']};
        }
        var SpecifiedTradeAllowanceCharges = SpecifiedLineTradeSettlement['ram:SpecifiedTradeAllowanceCharge'];
        if (SpecifiedTradeAllowanceCharges) {
          var SpecifiedTradeAllowanceCharge = SpecifiedTradeAllowanceCharges[0];
          bg_25['BG-27'] = {name: 'INVOICE LINE ALLOWANCES', val: []};//, val: SpecifiedLineTradeSettlement['ram:SpecifiedTradeAllowanceCharge']};
          bg_25['BG-27'].val['BT-136'] = {
            name: 'Invoice line allowance amount',
            val: SpecifiedTradeAllowanceCharge['ram:ActualAmount']};
          bg_25['BG-27'].val['BT-137'] = {
            name: 'Invoice line allowance base amount',
            val: SpecifiedTradeAllowanceCharge['ram:BasisAmount']};
          bg_25['BG-27'].val['BT-138'] = {
            name: 'Invoice line allowance percentage',
            val: SpecifiedLineTradeSettlement['ram:SpecifiedTradeAllowanceCharge'][0]['ram:CalculationPercent']};
          bg_25['BG-27'].val['BT-139'] = {
            name: 'Invoice line allowance reason',
            val: SpecifiedTradeAllowanceCharge['ram:Reason']};
          bg_25['BG-27'].val['BT-140'] = {
            name: 'Invoice line allowance reason code',
            val: SpecifiedTradeAllowanceCharge['ram:ReasonCode']};
          bg_25['BG-28'] = {name: 'INVOICE LINE CHARGES', val: []};//, val: SpecifiedLineTradeSettlement['ram:SpecifiedTradeAllowanceCharge']};
          bg_25['BG-28'].val['BT-141'] = {
            name: 'Invoice line charge amount',
            val: SpecifiedTradeAllowanceCharge['ram:ActualAmount']};
          bg_25['BG-28'].val['BT-142'] = {
            name: 'Invoice line charge base amount',
            val: SpecifiedTradeAllowanceCharge['ram:BasisAmount']};
          bg_25['BG-28'].val['BT-143'] = {
            name: 'Invoice line charge percentage',
            val: SpecifiedTradeAllowanceCharge['ram:CalculationPercent']};
          bg_25['BG-28'].val['BT-144'] = {
            name: 'Invoice line charge reason',
            val: SpecifiedTradeAllowanceCharge['ram:Reason']};
          bg_25['BG-28'].val['BT-145'] = {
            name: 'Invoice line charge reason code',
            val: SpecifiedTradeAllowanceCharge['ram:ReasonCode']};
        }
        if (SpecifiedLineTradeAgreement) {
          var NetPriceProductTradePrice = SpecifiedLineTradeAgreement['ram:NetPriceProductTradePrice'];
          if (NetPriceProductTradePrice) {
            NetPriceProductTradePrice = NetPriceProductTradePrice[0];
          }
          var GrossPriceProductTradePrice = SpecifiedLineTradeAgreement['ram:GrossPriceProductTradePrice'];
          if (GrossPriceProductTradePrice) {
            GrossPriceProductTradePrice = GrossPriceProductTradePrice[0];
          }
          if (NetPriceProductTradePrice || GrossPriceProductTradePrice) {
            bg_25['BG-29'] = {name: 'PRICE DETAILS', val: []};//, val: IncludedSupplyChainTradeLineItem['ram:SpecifiedLineTradeAgreement']};
          }
          if (NetPriceProductTradePrice) {
            bg_25['BG-29'].val['BT-146'] = {
              name: 'Item price', val: NetPriceProductTradePrice['ram:ChargeAmount']};
          }
          if (GrossPriceProductTradePrice) {
            if (GrossPriceProductTradePrice['ram:AppliedTradeAllowanceCharge']) {
              bg_25['BG-29'].val['BT-147'] = {
                name: 'Item price discount',
                val: GrossPriceProductTradePrice['ram:AppliedTradeAllowanceCharge'][0]['ram:ActualAmount']};
            }
            bg_25['BG-29'].val['BT-148'] = {
              name: 'Item gross price',
              val: GrossPriceProductTradePrice['ram:ChargeAmount']};
            bg_25['BG-29'].val['BT-149'] = {
              name: 'Item price base quantity', val: GrossPriceProductTradePrice['ram:BasisQuantity']};
            // bg_25['BT-149'] = {name: 'Item price base quantity', val: SupplyChainTradeTransaction['ram:IncludedSupplyChainTradeLineltem'][0]['ramrSpecifiedLineTradeAgreement'][0]['ram:NetPriceProductTradePrice'][0]['ram:BasisQuantity']};
            bg_25['BG-29'].val['BT-150'] = {
              name: 'Item price base quantity unit of measure code',
              val: GrossPriceProductTradePrice['ram:BasisQuantity']};///@unitCode']};
          }
        }
        var ApplicableTradeTax = SpecifiedLineTradeSettlement['ram:ApplicableTradeTax'];
        if (ApplicableTradeTax) {
          ApplicableTradeTax = ApplicableTradeTax[0];
          bg_25['BG-30'] = {name: 'LINE VAT INFORMATION', val: []};//, val: SpecifiedLineTradeSettlement['ram:ApplicableTradeTax']};
          bg_25['BG-30'].val['BT-151'] = {
            name: 'Invoiced bg_25 VAT category code', val: ApplicableTradeTax['ram:TypeCode']};
          // bg_25['BT-151'] = {name: 'Invoiced item VAT category code', val: ApplicableTradeTax['ram:CategoryCode']};
          bg_25['BG-30'].val['BT-152'] = {
            name: 'Invoiced item VAT rate', val: ApplicableTradeTax['ram:RateApplicablePercent']};
        }
        var SpecifiedTradeProduct = IncludedSupplyChainTradeLineItem['ram:SpecifiedTradeProduct']
        if (SpecifiedTradeProduct) {
          SpecifiedTradeProduct = SpecifiedTradeProduct[0];
          bg_25['BG-31'] = {name: 'ITEM INFORMATION', val: []};//, val: IncludedSupplyChainTradeLineItem['ram:SpecifiedTradeProduct']};
          bg_25['BG-31'].val['BT-153'] = {
            name: 'Item name', val: SpecifiedTradeProduct['ram:Name']};
          bg_25['BG-31'].val['BT-154'] = {
            name: 'Item description', val: SpecifiedTradeProduct['ram:Description']};
          bg_25['BG-31'].val['BT-155'] = {
            name: 'Item Seller&quots identifier', val: SpecifiedTradeProduct['ram:SellerAssignedID']};
          bg_25['BG-31'].val['BT-156'] = {
            name: 'Item Buyer&quots identifier', val: SpecifiedTradeProduct['ram:BuyerAssignedID']};
          bg_25['BG-31'].val['BT-157'] = {
            name: 'Item standard identifier', val: SpecifiedTradeProduct['ram:GlobalID']};
          // bg_25['BT-157'] = {name: 'Item standard identifier identificati on scheme  identifier', val: CrossIndustryInvoice['rsm:Supp]yChainTradeTransaction'][0]['ram:IncludedSupplyChainTradeLineItem'][0]['ram:SpecifiedTradeProduct'][0]['ram:GlobalID/@schemeID']};
          var DesignatedProductClassification = SpecifiedTradeProduct['ram:DesignatedProductClassification'];
          if (DesignatedProductClassification) {
            DesignatedProductClassification = DesignatedProductClassification[0];
            bg_25['BG-31'].val['BT-158'] = {
              name: 'Item classificati on identifier', val: DesignatedProductClassification['ram:ClassCode']};
            bg_25['BG-31'].val['BT-158'] = {
              name: 'Item classificati on identifier identificati on  scheme identifier', val: DesignatedProductClassification['ram:ClassCode']};///@listID']};
          }
          // bg_25['BT-158'] = {name: 'Scheme version identifer', val: SpecifiedTradeProduct['ram:DesignatedProductClassification'][0]['ram:ClassCode/@listVersionID']};
          var OriginTradeCountry = SpecifiedTradeProduct['ram:OriginTradeCountry'];
          if (OriginTradeCountry) {
            OriginTradeCountry = OriginTradeCountry[0];
            bg_25['BG-31'].val['BT-159'] = {
              name: 'Item country of origin', val: OriginTradeCountry['ram:ID']};
          }
          var ApplicableProductCharacteristic = SpecifiedTradeProduct['ram:ApplicableProductCharacteristic'];
          if (ApplicableProductCharacteristic) {
            ApplicableProductCharacteristic = ApplicableProductCharacteristic[0];
            bg_25['BG-32'] = {name: 'ITEM ATTRIBUTES', val: []};//, val: SpecifiedTradeProduct['ram:ApplicableProductCharacteristic']};
            bg_25['BG-32'].val['BT-160'] = {
              name: 'Item attribute name', val: ApplicableProductCharacteristic['ram:Description']};
            bg_25['BG-32'].val['BT-161'] = {
              name: 'Item attribute value', val: ApplicableProductCharacteristic['ram:Value']};
          }
        }
        en['BG-25'].val.push(bg_25);
      }
    }
    return en;
  }

  function en2xbrlgl(en) {
    var xbrli = 'http://www.xbrl.org/2003/instance';
    var xbrldi = 'http://xbrl.org/2006/xbrldi';
    var eipa = 'http://www.sample.org/eipa';
    var eipa_cen = eipa+'/cen/2020-12-31';
    var eg = eipa;
    var date = (new Date()).toISOString().match(/^([0-9]{4}-[0-9]{2}-[0-9]{2})T.*$/)[1];
    var xmlString = '<?xml version="1.0" encoding="UTF-8"?>'+
    '<xbrli:xbrl xmlns:xbrll="http://www.xbrl.org/2003/linkbase" '+
      'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '+
      'xmlns:xlink="http://www.w3.org/1999/xlink" '+
      'xmlns:iso639="http://www.xbrl.org/2005/iso639" '+
      'xmlns:iso4217="http://www.xbrl.org/2003/iso4217" '+
      'xmlns:xbrli="'+xbrli+'" '+
      'xmlns:xbrldi="'+xbrldi+'" '+
      'xmlns:eipa-cen="'+eipa_cen+'" '+
      'xmlns:eg="'+eg+'" '+
      'xsi:schemaLocation="'+eipa_plt+' ../plt/case-c-b-m-u-e-t/eipa-plt-all-2020-12-31.xsd">'+
      '<xbrll:schemaRef xlink:type="simple" xlink:href="../plt/case-c-b-m-u-e-t/eipa-plt-all-2020-12-31_5.xsd" xlink:arcrole="http://www.w3.org/1999/xlink/properties/linkbase"/>'+
      '<xbrli:context id="now">'+
        '<xbrli:entity>'+
          '<xbrli:identifier scheme="'+eipa+'">EIPA</xbrli:identifier>'+
        '</xbrli:entity>'+
        '<xbrli:period>'+
          '<xbrli:instant>'+date+'</xbrli:instant>'+
        '</xbrli:period>'+
      '</xbrli:context>'+
    '</xbrli:xbrl>';
// context
/** <xbrli:context id="H50">
      <xbrli:entity>
        <xbrli:identifier scheme="http://www.sample.org/xbrlgl/sample">SAMPLE</xbrli:identifier>
        <xbrli:segment>
          <xbrldi:typedMember dimension="eipa-cen:dL1Number">
            <eipa-cen:L1Number>50</eipa-cen:L1Number>
          </xbrldi:typedMember>
        </xbrli:segment>
      </xbrli:entity>
      <xbrli:period>
        <xbrli:instant>2020-01-01</xbrli:instant>
      </xbrli:period>
    </xbrli:context> */
    function appendtypedLNumber(L, ID, segment) {
      var typedMember = xmlDoc.createElementNS(xbrldi,'typedMember'),
          number = xmlDoc.createElementNS(eipa_cen, L+'Number'),
          text = xmlDoc.createTextNode(ID);
      segment.appendChild(typedMember);
      typedMember.setAttribute('dimension', 'eipa-cen:d'+L+'Number');
      typedMember.appendChild(number);
      number.appendChild(text);
    }
    function createL1Context(xmlDoc, IDS, date) {
      var L1ID = IDS[0]
      var context = xmlDoc.createElementNS(xbrli,'context');
      var entity = xmlDoc.createElementNS(xbrli,'entity');
      var identifier = xmlDoc.createElementNS(xbrli,'identifier');
      var identifierText = xmlDoc.createTextNode('SAMPLE');
      var segment = xmlDoc.createElementNS(xbrli,'segment');
      var period = xmlDoc.createElementNS(xbrli,'period');
      var instant = xmlDoc.createElementNS(xbrli,'instant');
      var instantText = xmlDoc.createTextNode(date);
      xbrl.appendChild(context);
      context.setAttribute('id', L1ID); context.appendChild(entity);
      entity.appendChild(identifier); identifier.setAttribute('scheme', eg);
      identifier.appendChild(identifierText);
      entity.appendChild(segment);
      appendtypedLNumber('L1', L1ID, segment);
      context.appendChild(period); period.appendChild(instant); instant.appendChild(instantText);
      return context;
    }
/** <xbrli:context id='H50L1'>
      <xbrli:entity>
        <xbrli:identifier scheme='http://www.sample.org/xbrlgl/sample'>SAMPLE</xbrli:identifier>
        <xbrli:segment>
          <xbrldi:typedMember dimension='eipa-cen:dL1Number'>
            <eipa-cen:L1Number>50</eipa-cen:L1Number>
          </xbrldi:typedMember>
          <xbrldi:typedMember dimension='eipa-cen:dL2Number'>
            <eipa-cen:L2Number>L1</eipa-cen:L2Number>
          </xbrldi:typedMember>
        </xbrli:segment>
      </xbrli:entity>
      <xbrli:period>
        <xbrli:instant>2020-01-01</xbrli:instant>
      </xbrli:period>
    </xbrli:context> */
    function createL2Context(xmlDoc, IDS, date) {
      var L1ID =IDS[0], L2ID = IDS[1];
      var context = xmlDoc.createElementNS(xbrli,'context');
      var entity = xmlDoc.createElementNS(xbrli,'entity');
      var identifier = xmlDoc.createElementNS(xbrli,'identifier');
      var identifierText = xmlDoc.createTextNode('SAMPLE');
      var segment = xmlDoc.createElementNS(xbrli,'segment');
      var period = xmlDoc.createElementNS(xbrli,'period');
      var instant = xmlDoc.createElementNS(xbrli,'instant');
      var instantText = xmlDoc.createTextNode(date);
      xbrl.appendChild(context);
      context.appendChild(entity); context.setAttribute('id', L1ID+'_'+L2ID);
      identifier.setAttribute('scheme', eg); identifier.appendChild(identifierText);
      entity.appendChild(identifier);
      entity.appendChild(segment);
      appendtypedLNumber('L1', L1ID, segment);
      appendtypedLNumber('L2', L2ID, segment);
      context.appendChild(period); period.appendChild(instant); instant.appendChild(instantText);
      return context;
    }
    function createL3Context(xmlDoc, L1ID, date) {
      var L1ID =IDS[0], L2ID = IDS[1], L3ID = IDS[2];
      var context = xmlDoc.createElementNS(xbrli,'context');
      var entity = xmlDoc.createElementNS(xbrli,'entity');
      var identifier = xmlDoc.createElementNS(xbrli,'identifier');
      var identifierText = xmlDoc.createTextNode('SAMPLE');
      var segment = xmlDoc.createElementNS(xbrli,'segment');
      var period = xmlDoc.createElementNS(xbrli,'period');
      var instant = xmlDoc.createElementNS(xbrli,'instant');
      var instantText = xmlDoc.createTextNode(date);
      xbrl.appendChild(context);
      context.setAttribute('id', L1ID); context.appendChild(entity);
      entity.appendChild(identifier); identifier.setAttribute('scheme', eg);
      identifier.appendChild(identifierText);
      entity.appendChild(segment);
      appendtypedLNumber('L1', L1ID, segment);
      appendtypedLNumber('L2', L2ID, segment);
      appendtypedLNumber('L3', L3ID, segment);
      context.appendChild(period); period.appendChild(instant); instant.appendChild(instantText);
      return context;
    }
    function createL4Context(xmlDoc, L1ID, date) {
      var L1ID =IDS[0], L2ID = IDS[1], L3ID = IDS[2], L4ID = IDS[3];
      var context = xmlDoc.createElementNS(xbrli,'context');
      var entity = xmlDoc.createElementNS(xbrli,'entity');
      var identifier = xmlDoc.createElementNS(xbrli,'identifier');
      var identifierText = xmlDoc.createTextNode('SAMPLE');
      var segment = xmlDoc.createElementNS(xbrli,'segment');
      var period = xmlDoc.createElementNS(xbrli,'period');
      var instant = xmlDoc.createElementNS(xbrli,'instant');
      var instantText = xmlDoc.createTextNode(date);
      xbrl.appendChild(context);
      context.setAttribute('id', L1ID); context.appendChild(entity);
      entity.appendChild(identifier); identifier.setAttribute('scheme', eg);
      identifier.appendChild(identifierText);
      entity.appendChild(segment);
      appendtypedLNumber('L1', L1ID, segment);
      appendtypedLNumber('L2', L2ID, segment);
      appendtypedLNumber('L3', L3ID, segment);
      appendtypedLNumber('L4', L4ID, segment);
      context.appendChild(period); period.appendChild(instant); instant.appendChild(instantText);
      return context;
    }

    function createItem(xmlDoc, keys, item) {
/**
<gl-cor:enteredDate contextRef='H50'>2005-07-01</gl-cor:enteredDate>
  */
      // console.log(level, keys, item);
      var contextText = keys[0]+(keys[1] ? '_'+keys[1] : '');
      var length = keys.length;
      var name = keys[length - 1];
      var val = item.val;
      var element = xmlDoc.createElementNS(eipa_cen, name);
      switch(val.length) {
      case 1:
        var text = xmlDoc.createTextNode(item.val[0]);
        element.appendChild(text);
        element.setAttribute('contextRef', contextText);
        xbrl.appendChild(element);
        break;
      case 2:
        var text = xmlDoc.createTextNode(item.val[1]);
        element.appendChild(text);
        element.setAttribute('contextRef', contextText);
        xbrl.appendChild(element);
        var key = Object.keys(item.val[0])[0];
        var val0 = item.val[0][key];
        key = key.replace('@', '_');
        key = name+key;
        var element0 = xmlDoc.createElementNS(eipa_cen, key);
        var text0 = xmlDoc.createTextNode(val0);
        element0.appendChild(text0);
        element0.setAttribute('contextRef', contextText);
        xbrl.appendChild(element0);
        break;
      }
    }
    // ---------------------------------------------------------------
    // START
    var DOMP = new DOMParser();
    var xmlDoc = DOMP.parseFromString(xmlString, 'text/xml');
    var xbrl = xmlDoc.getElementsByTagNameNS(xbrli, 'xbrl')[0];
    createL1Context(xmlDoc, ['root'], date);
    var L1keys = Object.keys(en);
    // console.log('L1keys', L1keys);
    var newL1key = true;
    for (var L1key of L1keys) {
      var L1item = en[L1key];
      if (L1item.val && L1item.val.length > 0) {
        console.log('1) key:'+L1key, 'item:', L1item);
        if (L1key.match(/^BT/)) {
          createItem(xmlDoc, [L1key], L1item);
        }
        else if (L1key.match(/^BG/)) {
          var L2val = L1item.val;
          // console.log('L2val:', L2val);
          for (var L2key in L2val) {
            var L2item = L2val[L2key];
            if (L2key.match(/^[0-9]+$/)) {
              if (newL1key) {
                createL1Context(xmlDoc, [L1key], date);
              }
              else { newL1key = false; }
              createL2Context(xmlDoc, [L1key, L2key], date);
              var L3keys = Object.keys(L2item);
              // console.log('L3keys', L3keys);
              for (var L3key of L3keys) {
                var L3item = L2item[L3key];
                if (L3item.val && L3item.val.length > 0) {
                  console.log('2) key:'+L1key+' '+L2key+' '+L3key, 'item:', L3item);
                  createItem(xmlDoc, [L1key, L2key, L3key], L3item);
                }
              }
            }
            else if (L2key.match(/^BT/)) {
              if (L2item && L2item.length > 0) {
                console.log('3) key:'+L1key+' '+L2key, 'item:', L2item);
                createItem(xmlDoc, [L1key, L2key], L2item);
              }
            }
            else if (L2key.match(/^BG/)) {
              var L3val = L2item.val;
              // console.log('L3val:', L3val);
              for (var L3key in L3val) {
                var L3item = L3val[L3key];
                console.log('4) key:'+L1key+' '+L2key+' '+L3key, 'item:', L3item);
                if (L3item.val && L3item.val.length > 0) {
                  // var 
                  if (L3key.match(/^[0-9]+$/)) {
                    createItem(xmlDoc, [L1key, L2key, L3key], L3item);
                  }
                  else if (L3key.match(/^BT/)) {
                    createItem(xmlDoc, [L1key, L2key, L3key], L3item);
                  }
                  else if (L3key.match(/^BG/)) {
                    createItem(xmlDoc, [L1key, L2key, L3key], L3item);
                  }
                }
              }
            }
          }
        }
      }
    }
    var XMLS = new XMLSerializer();
    var xmlStr = XMLS.serializeToString(xmlDoc)
    return xmlStr;
  }

  function initModule(url, ms) {
    return ajaxRequest(url, null, 'GET', ms)
    .then(function(res) {
      // console.log(res);
      try {
        var json = JSON.parse(res);
        var en = cii2en(json);
        // console.log(en);
        return en;
      }
      catch(e) { console.log(e); }
    })
    .then(function(en) {
      var xbrlgl = en2xbrlgl(en);
      return xbrlgl;
    })
    .then(function(xbrlgl) {
      var match, dir = '', name = '';
      if (url.match(/\//)) {
        match = url.match(/^(.*)\/([^\/]*)\.json$/);
        if (match) {
          dir = match[1];
          name = match[2];
        }
      }
      else {
        match = url.match(/^(.*)\.json$/);
        if (match) { name = match[1]; }
      }
      var data = {
        'name': name,
        'data': xbrlgl
      };
      return ajaxRequest('data/save.cgi', data, 'POST', 20000)
      .then(function(res) {
        console.log(res);
      })
      .catch(function(err) { console.log(err); })
      // console.log(xbrlgl);
      return 
    })
    .catch(function(err) { console.log(err); })
  }
  return {
    'initModule' : initModule,
    'cii2en': cii2en,
    'en2xbrlgl': en2xbrlgl
  };
})();
