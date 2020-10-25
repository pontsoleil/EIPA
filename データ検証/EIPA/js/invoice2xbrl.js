/**
 * en2xbrl.js
 *
 * Convert UN/CEFACT CII xml or UBL xml file to cen XBRL
 * called from invoice2xbrl.html
 * 
 * This is a free to use open source software and licensed under the MIT License
 * CC-SA-BY Copyright (c) 2020, Sambuichi Professional Engineers Office
 **/
var invoice2xbrl = (function() {

  function cii2en(json) {
    var cii = json;
    var en = {};
    var CrossIndustryInvoice = cii['rsm:CrossIndustryInvoice'][0];
    var ExchangedDocument = CrossIndustryInvoice['rsm:ExchangedDocument'];
    if (!ExchangedDocument) { return null; }
    ExchangedDocument = ExchangedDocument[0];
    en['BT-1'] = {'name':'Invoice number', 'val':ExchangedDocument['ram:ID']};
    var IssueDateTime = ExchangedDocument['ram:IssueDateTime'];
    if (IssueDateTime) {
      IssueDateTime = IssueDateTime[0];
      en['BT-2'] = {'name':'Invoice issue date', 'val':IssueDateTime['udt:DateTimeString']};//['udt:DateTimeString/@format']};
    }
    en['BT-3'] = {'name':'Invoice type code', 'val':ExchangedDocument['ram:TypeCode']};
    var SupplyChainTradeTransaction = CrossIndustryInvoice['rsm:SupplyChainTradeTransaction'];
    if (!SupplyChainTradeTransaction) { return null; }
    SupplyChainTradeTransaction = SupplyChainTradeTransaction[0];
    var ApplicableHeaderTradeSettlements = SupplyChainTradeTransaction['ram:ApplicableHeaderTradeSettlement'];
    if (ApplicableHeaderTradeSettlements) {
      en['BT-5'] = {'name':'Invoice currency code', 'val':[]};
      en['BT-6'] = {'name':'VAT accounting currency code', 'val':[]};
      // PRECEDING INVOICE REFERENCE (Multiple)
      en['BG-3'] = {'name':'PRECEDING INVOICE REFERENCE', 'val':[]};//, 'val':ApplicableHeaderTradeSettlement['ram:InvoiceReferencedDocument']};
      for (var ApplicableHeaderTradeSettlement of ApplicableHeaderTradeSettlements || []){
        en['BT-5'].val.push(ApplicableHeaderTradeSettlement['ram:InvoiceCurrencyCode']);
        en['BT-6'].val.push(ApplicableHeaderTradeSettlement['ram:TaxCurrencyCode']);
        var InvoiceReferencedDocuments = ApplicableHeaderTradeSettlement['ram:InvoiceReferencedDocument'];
        for (InvoiceReferencedDocument of InvoiceReferencedDocuments || []) {
          var BG_3 = {};
          BG_3['BT-25'] = {'name':'Preceding Invoice number',
            'val':InvoiceReferencedDocument['ram:IssuerAssignedID']};
          BG_3['BT-26'] = {'name':'Preceding Invoice issue date',
            'val':InvoiceReferencedDocument['ram:FormattedIssueDateTime/qdt:DateTimeString']};
          en['BG-3'].val.push(BG_3);
        }
      }
    }
    var ApplicableTradeTaxes = ApplicableHeaderTradeSettlement['ram:ApplicableTradeTax'];
    if (ApplicableTradeTaxes) {
      en['BT-7'] = {'name':'Value added tax point date', 'val':[]};//['udt:DateString/@format']};
      en['BT-8'] = {'name':'Value added tax point date code', 'val':[]};
      // BG-23 VAT BREAKDOWN (Multiple)
      en['BG-23'] = {'name':'VAT BREAKDOWN', 'val':[]};//, 'val':ApplicableHeaderTradeSettlement['ram:ApplicableTradeTax']};
      for (var ApplicableTradeTax of ApplicableTradeTaxes || []){
        var TaxPointDates = ApplicableTradeTax['ram:TaxPointDate'];
        for (var TaxPointDate of TaxPointDates || []){
          en['BT-7'].val.push(TaxPointDate['udt:DateString']);//['udt:DateString/@format']};
        }        
        en['BT-8'].val.push(ApplicableTradeTax['ram:DueDateTypeCode']);
        var BG_23 = {};
        BG_23['BT-116'] = {'name':'VAT category taxable amount', 'val':ApplicableTradeTax['ram:BasisAmount']};
        BG_23['BT-117'] = {'name':'VAT category tax amount', 'val':ApplicableTradeTax['ram:CalculatedAmount']};
        BG_23['BT-118'] = {'name':'VAT category code', 'val':ApplicableTradeTax['ram:TypeCode']};
        // en['BT-118'] = {'name':'VAT category code', 'val':SupplyChainTradeTransaction['ram:ApplicableHeaderTradeSettIement'][0]['ram:ApplicableTradeTax'][0]['ram:CategoryCode']};
        BG_23['BT-119'] = {'name':'VAT category rate', 'val':ApplicableTradeTax['ram:RateApplicablePercent']};
        BG_23['BT-120'] = {'name':'VAT exemption reason text', 'val':ApplicableTradeTax['ram:ExemptionReason']};
        BG_23['BT-121'] = {'name':'VAT exemption reason code', 'val':ApplicableTradeTax['ram:ExemptionReasonCode']};
        en['BG-23'].val.push(BG_23);
      }
    }
    if (ApplicableHeaderTradeSettlement['ram:SpecifiedTradePaymentTerms'] &&
        ApplicableHeaderTradeSettlement['ram:SpecifiedTradePaymentTerms'][0]['ram:DueDateDateTime']) {
      en['BT-9'] = {'name':'Payment due date',
        'val':ApplicableHeaderTradeSettlement['ram:SpecifiedTradePaymentTerms'][0]['ram:DueDateDateTime'][0]['udt:DateTimeString']};//['udt:DateTimeString/@format']
    }

    var ApplicableHeaderTradeAgreement = SupplyChainTradeTransaction['ram:ApplicableHeaderTradeAgreement'];
    if (ApplicableHeaderTradeAgreement) {
      ApplicableHeaderTradeAgreement = ApplicableHeaderTradeAgreement[0];
      en['BT-10'] = {'name':'Buyer reference',
        'val':ApplicableHeaderTradeAgreement['ram:BuyerReference']};
      var SpecifiedProcuringProjects = ApplicableHeaderTradeAgreement['ram:SpecifiedProcuringProject'];
      if (SpecifiedProcuringProjects) {
        var SpecifiedProcuringProject = SpecifiedProcuringProjects[0];
        en['BT-11'] = {'name':'Project reference', 'val':SpecifiedProcuringProject['ram:ID']};
      }// en['BT-11'] = {'name':'Project reference', 'val':ApplicableHeaderTradeAgreement['ram:SpecifiedProcuringProject'][0]['ram:Name']};
      var ContractReferencedDocuments = ApplicableHeaderTradeAgreement['ram:ContractReferencedDocument'];
      if (ContractReferencedDocuments) {
        var ContractReferencedDocument = ContractReferencedDocuments[0];
        en['BT-12'] = {'name':'Contract reference', 'val':ContractReferencedDocument['ram:IssuerAssignedID']};
      }
      var BuyerOrderReferencedDocuments = ApplicableHeaderTradeAgreement['ram:BuyerOrderReferencedDocument'];
      if (BuyerOrderReferencedDocuments) {
        var BuyerOrderReferencedDocument = BuyerOrderReferencedDocuments[0];
        en['BT-13'] = {'name':'Purchase order reference', 'val':BuyerOrderReferencedDocument['ram:IssuerAssignedID']};
      }
      var SellerOrderReferencedDocuments = ApplicableHeaderTradeAgreement['ram:SellerOrderReferencedDocument'];
      if (SellerOrderReferencedDocuments) {
        var SellerOrderReferencedDocument = SellerOrderReferencedDocuments[0];
        en['BT-14'] = {'name':'Sales order reference', 'val':SellerOrderReferencedDocument['ram:IssuerAssignedID']};
      }
    }
    var ApplicableHeaderTradeDeliveries = SupplyChainTradeTransaction['ram:ApplicableHeaderTradeDelivery'];
    if (ApplicableHeaderTradeDeliveries) {
      var ApplicableHeaderTradeDelivery = ApplicableHeaderTradeDeliveries[0];
      var ReceivingAdviceReferencedDocuments = ApplicableHeaderTradeDelivery['ram:ReceivingAdviceReferencedDocument'];
      if (ReceivingAdviceReferencedDocuments) {
        var ReceivingAdviceReferencedDocument = ReceivingAdviceReferencedDocuments[0];
        en['BT-15'] = {'name':'Receiving advice reference',
          'val':ReceivingAdviceReferencedDocument['ram:IssuerAssignedID']};
      }
      var DespatchAdviceReferencedDocuments = ApplicableHeaderTradeDelivery['ram:DespatchAdviceReferencedDocument'];
      if (DespatchAdviceReferencedDocuments) {
        var DespatchAdviceReferencedDocument = DespatchAdviceReferencedDocuments[0];
        en['BT-16'] = {'name':'Despatch advice reference',
          'val':DespatchAdviceReferencedDocument['ram:IssuerAssignedID']};
      }
    }

    var AdditionalReferencedDocuments = ApplicableHeaderTradeAgreement['ram:AdditionalReferencedDocument'];
    if (AdditionalReferencedDocuments) {
      en['BT-17'] = {'name':'Tender or lot reference', 'val':[]};
      en['BT-18'] = {'name':'Invoiced object identifier', 'val':[]};
      // BG-24 ADDITIONAL SUPPORTING DOCUMENTS (Multiple)
      en['BG-24'] = {'name':'ADDITIONAL SUPPORTING DOCUMENTS', 'val':[]};//, 'val':ApplicableHeaderTradeAgreement['ram:AdditionalReferencedDocument']};
      for (var AdditionalReferencedDocument of AdditionalReferencedDocuments || []){
        en['BT-17'].val.push(AdditionalReferencedDocument['ram:IssuerAssignedID']);
        // en['BT-17'] = {'name':'Tender or lot reference', 'val':AdditionalReferencedDocument['ram:TypeCode']};
        en['BT-18'].val.push(AdditionalReferencedDocument['ram:IssuerAssignedID']);
        // en['BT-18'] = {'name':'Invoiced object identifier', 'val':AdditionalReferencedDocument['ram:TypeCode']};
        // en['BT-18'] = {'name':'Scheme identifier', 'val':AdditionalReferencedDocument['ram:ReferenceTypeCode']};
        var BG_24 = {};
        BG_24['BT-122'] = {'name':'Supportin g document reference', 'val':AdditionalReferencedDocument['ram:IssuerAssignedID']};
        // en['BT-122'] = {'name':'Supportin g document reference', 'val':AdditionalReferencedDocument['ram:TypeCode']};
        BG_24['BT-123'] = {'name':'Supportin g document description', 'val':AdditionalReferencedDocument['ram:Name']};
        BG_24['BT-124'] = {'name':'External document location', 'val':AdditionalReferencedDocument['ram:URIID']};
        BG_24['BT-125'] = {'name':'Attached document', 'val':AdditionalReferencedDocument['ram:AttachmentBinaryObject']};
        // en['BT-125'] = {'name':'Attached document Mime code', 'val':AdditionalReferencedDocument['ram:AttachmentBinaryObject/@mimeCode']};
        // en['BT-125'] = {'name':'Attached document Filename', 'val':CrossIndustryInvoice['rsm:SuppIyChainTradeTransaction'][0]['ram:ApplicableHeaderTradeAgreement'][0]['ram:AdditionalReferencedDocument'][0]['ram:AttachmentBinaryObject/@filename']};
        en['BG-24'].val.push(BG_24);
      }
    }
    var ReceivableSpecifiedTradeAccountingAccounts = ApplicableHeaderTradeSettlement['ram:ReceivableSpecifiedTradeAccountingAccount'];
    if (ReceivableSpecifiedTradeAccountingAccounts) {
      var ReceivableSpecifiedTradeAccountingAccount = ReceivableSpecifiedTradeAccountingAccounts[0];
      en['BT-19'] = {'name':'Buyer accounting reference',
        'val':ReceivableSpecifiedTradeAccountingAccount['ram:ID']};
    }
    var SpecifiedTradePaymentTerms = ApplicableHeaderTradeSettlement['ram:SpecifiedTradePaymentTerms'];
    if (SpecifiedTradePaymentTerms) {
      var SpecifiedTradePaymentTerm = SpecifiedTradePaymentTerms[0];
      en['BT-20'] = {'name':'Payment terms', 'val':SpecifiedTradePaymentTerm['ram:Description']};
    }
    // INVOICE NOTE (Multiple)
    en['BG-1'] = {'name':'INVOICE NOTE', 'val':[]};//, 'val':ExchangedDocument['ram:IncludedNote']};
    var IncludedNotes = ExchangedDocument['ram:IncludedNote'];
    if (IncludedNotes) {
      var IncludedNote = IncludedNotes[0];
      en['BG-1'].val['BT-21'] = {'name':'Invoice note subject code', 'val':IncludedNote['ram:SubjectCode']};
      en['BG-1'].val['BT-22'] = {'name':'Invoice note', 'val':IncludedNote['ram:Content']};
    }
    // PROCESS CONTROL
    en['BG-2'] = {'name':'PROCESS CONTROL', 'val':[]};//, 'val':CrossIndustryInvoice['rsm:ExchangedDocumentContext']};
    var ExchangedDocumentContext = CrossIndustryInvoice['rsm:ExchangedDocumentContext'];
    if (ExchangedDocumentContext) {
      ExchangedDocumentContext = ExchangedDocumentContext[0];
      var BusinessProcessSpecifiedDocumentContextParameters = ExchangedDocumentContext['ram:BusinessProcessSpecifiedDocumentContextParameter'];
      if (BusinessProcessSpecifiedDocumentContextParameters) {
        var BusinessProcessSpecifiedDocumentContextParameter = BusinessProcessSpecifiedDocumentContextParameters[0];
        en['BG-2'].val['BT-23'] = {'name':'Business process type',
          'val':BusinessProcessSpecifiedDocumentContextParameter['ram:ID']};
      }
      var GuidelineSpecifiedDocumentContextParameters = ExchangedDocumentContext['ram:GuidelineSpecifiedDocumentContextParameter'];
      if (GuidelineSpecifiedDocumentContextParameters) {
        var GuidelineSpecifiedDocumentContextParameter = GuidelineSpecifiedDocumentContextParameters[0];
        en['BG-2'].val['BT-24'] = {'name':'Specification identifier',
          'val':GuidelineSpecifiedDocumentContextParameter['ram:ID']};
      }
    }

    // en['BT-26'] = {'name':'Preceding Invoice issue date', 'val':ApplicableHeaderTradeSettlement['ram:InvoiceReferencedDocument'][0]['ram:FormattedIssueDateTime/qdt:DateTimeString/@format']};
    // SELLER
    var SellerTradeParty = ApplicableHeaderTradeAgreement['ram:SellerTradeParty'];
    if (SellerTradeParty) {
      SellerTradeParty = SellerTradeParty[0];
      en['BG-4'] = {'name':'SELLER', 'val':[]};//, 'val':ApplicableHeaderTradeAgreement['ramiSellerTradeParty']};
      en['BG-4'].val['BT-27'] = {'name':'Seller name', 'val':SellerTradeParty['ram:Name']};
      if (SellerTradeParty['ram:SpecifiedLegalOrganization']) {
        en['BG-4'].val['BT-28'] = {'name':'Seller trading name',
          'val':SellerTradeParty['ram:SpecifiedLegalOrganization'][0]['ram:TradingBusinessName']};
      }
      // BT-29 Seller identifier (Multiple)
      en['BG-4'].val['BT-29'] = {'name':'Seller identifier', 'val':[]};
      var IDs = SellerTradeParty['ram:ID'];
      for (var ID of IDs || []){
        en['BG-4'].val['BT-29'].val.push(ID);
      // en['BT-29'] = {'name':'Seller identifier', 'val':SellerTradeParty['ram:GlobalID']};
      // en['BT-29'] = {'name':'Seller identifier identificati on scheme identifier', 'val':ApplicableHeaderTradeAgreement['ram:SeIlerTradeParty'][0]['ram:GlobalID/@schemeID']};
      }
      if (SellerTradeParty['ram:SpecifiedLegalOrganization']) {
        en['BG-4'].val['BT-30'] = {'name':'Seller legal registration identifier',
          'val':SellerTradeParty['ram:SpecifiedLegalOrganization'][0]['ram:ID']};
      }
      // en['BT-30'] = {'name':'Seller legal registration identifier identificati on scheme identifier', 'val':SellerTradeParty['ram:SpecifiedLegalOrganization'][0]['ram:ID/@schemeID']};
      if (SellerTradeParty['ram:SpecifiedTaxRegistration']) {
        en['BG-4'].val['BT-31'] = {'name':'Seller VAT identifier',
          'val':SellerTradeParty['ram:SpecifiedTaxRegistration'][0]['ram:ID']};
        en['BG-4'].val['BT-32'] = {'name':'Seller tax registration identifier',
          'val':SellerTradeParty['ram:SpecifiedTaxRegistration'][0]['ram:ID']};
      }
      en['BG-4'].val['BT-33'] = {'name':'Seller additional legal information',
        'val':SellerTradeParty['ram:Description']};
      if (SellerTradeParty['ram:URIUniversalCommunication']) {
        en['BG-4'].val['BT-34'] = {'name':'Seller electronic address',
          'val':SellerTradeParty['ram:URIUniversalCommunication'][0]['ram:URIID']};
      }
    }
    // en['BT-34'] = {'name':'Seller electronic address identificati on scheme identifier', 'val':SellerTradeParty['ram:URIUniversalCommunication'][0]['ram:URIID/@schemeID']};
    en['BG-4'].val['BG-5'] = {'name':'SELLER POSTAL ADDRESS', 'val':[]};
    //, 'val':SellerTradeParty['ram:PostalTradeAddress']};
    var SellerPostalTradeAddress = SellerTradeParty['ram:PostalTradeAddress'];
    if (SellerPostalTradeAddress) {
      SellerPostalTradeAddress = SellerPostalTradeAddress[0];
      en['BG-4'].val['BG-5'].val['BT-35'] = {'name':'Seller address line 1',
        'val':SellerPostalTradeAddress['ram:LineOne']};
      en['BG-4'].val['BG-5'].val['BT-36'] = {'name':'Seller address line 2',
        'val':SellerPostalTradeAddress['ram:LineTwo']};
      en['BG-4'].val['BG-5'].val['BT-162'] = {'name':'Seller address line 3',
        'val':SellerPostalTradeAddress['ram:LineThree']};
      en['BG-4'].val['BG-5'].val['BT-37'] = {'name':'Seller city',
        'val':SellerPostalTradeAddress['ram:CityName']};
      en['BG-4'].val['BG-5'].val['BT-38'] = {'name':'Seller post code',
        'val':SellerPostalTradeAddress['ram:PostcodeCode']};
      en['BG-4'].val['BG-5'].val['BT-39'] = {'name':'Seller country subdivision',
        'val':SellerPostalTradeAddress['ram:CountrySubDivisionName']};
      en['BG-4'].val['BG-5'].val['BT-40'] = {'name':'Seller country code',
        'val':SellerPostalTradeAddress['ram:CountryID']};
    }
    en['BG-4'].val['BG-6'] = {'name':'SELLER CONTACT', 'val':[]};//, 'val':ApplicableHeaderTradeAgreement['ram:SeIlerTradeParty'][0]['ram:DefinedTradeContact']};
    var SellerDefinedTradeContact = SellerTradeParty['ram:DefinedTradeContact'];
    if (SellerDefinedTradeContact) {
      SellerDefinedTradeContact = SellerDefinedTradeContact[0];
      en['BG-4'].val['BG-6'].val['BT-41'] = {'name':'Seller contact point',
        'val':SellerDefinedTradeContact['ram:PersonName']};
      en['BG-4'].val['BG-6'].val['BT-41'] = {'name':'Seller contact point',
        'val':SellerDefinedTradeContact['ram:DepartmentName']};
      if (SellerDefinedTradeContact['ram:TelephoneUniversalCommunication']) {
        en['BG-4'].val['BG-6'].val['BT-42'] = {'name':'Seller contact telephone number',
          'val':SellerDefinedTradeContact['ram:TelephoneUniversalCommunication'][0]['ram:CompleteNumber']};
      }
      if (SellerDefinedTradeContact['ram:EmailURIUniversalCommunication']) {
        en['BG-4'].val['BG-6'].val['BT-43'] = {'name':'Seller contact email address',
          'val':SellerDefinedTradeContact['ram:EmailURIUniversalCommunication'][0]['ram:URIID']};
      }
    }
    // BUYER
    var BuyerTradeParty = ApplicableHeaderTradeAgreement['ram:BuyerTradeParty'];
    en['BG-7'] = {'name':'BUYER', 'val':[]};//, 'val':ApplicableHeaderTradeAgreement['ram:BuyerTradeParty']};
    if (BuyerTradeParty) {
      BuyerTradeParty = BuyerTradeParty[0];
      en['BG-7'].val['BT-44'] = {'name':'Buyer name', 'val':BuyerTradeParty['ram:Name']};
      var BuyerSpecifiedLegalOrganization = BuyerTradeParty['ram:SpecifiedLegalOrganization'];
      if (BuyerSpecifiedLegalOrganization) {
        BuyerSpecifiedLegalOrganization = BuyerSpecifiedLegalOrganization[0];
        en['BG-7'].val['BT-45'] = {'name':'Buyer trading name',
          'val':BuyerSpecifiedLegalOrganization['ram:TradingBusinessName']};
        en['BG-7'].val['BT-47'] = {'name':'Buyer legal registration identifier',
          'val':BuyerSpecifiedLegalOrganization['ram:ID']};
      }
      en['BG-7'].val['BT-46'] = {'name':'Buyer identifier', 'val':BuyerTradeParty['ram:ID']};
      // en['BT-46'] = {'name':'Buyer identifier', 'val':BuyerTradeParty['ram:Globa1ID']};
      // en['BT-46'] = {'name':'Buyer identifier identificati on scheme identifier', 'val':BuyerTradeParty['ram:GlobaHD/@schemeID']};
      // en['BT-47'] = {'name':'Buyer legal registration identifier identification  scheme identifier', 'val':BuyerSpecifiedLegalOrganization['ram:ID/@schemeID']};
      if (BuyerTradeParty['ram:SpecifiedTaxRegistration']) {
        en['BG-7'].val['BT-48'] = {'name':'Buyer VAT identifier',
          'val':BuyerTradeParty['ram:SpecifiedTaxRegistration'][0]['ram:ID']};
      }
      if (BuyerTradeParty['ram:URIUniversalCommunication']) {
        en['BG-7'].val['BT-49'] = {'name':'Buyer electronic address',
          'val':BuyerTradeParty['ram:URIUniversalCommunication'][0]['ram:URIID']};
      }
    }
    // en['BT-49'] = {'name':'Buyer electronic address identificati on scheme  identifier', 'val':SupplyChainTradeTransaction['ram:ApplicabIeHeaderTradeAgreement'][0]['ram:BuyerTradeParty'][0]['ram:URIUniversalCommunication'][0]['ram:URIID/@schemeID']};
    var BuyerPostalTradeAddress = BuyerTradeParty['ram:PostalTradeAddress'];
    if (BuyerPostalTradeAddress) {
      BuyerPostalTradeAddress = BuyerPostalTradeAddress[0];
      en['BG-7'].val['BG-8'] = {'name':'BUYER POSTAL ADDRESS', 'val':[]};
      //, 'val':BuyerTradeParty['ram:PostaITradeAddress']};
      en['BG-7'].val['BG-8'].val['BT-50'] = {'name':'Buyer address line 1', 'val':BuyerPostalTradeAddress['ram:LineOne']};
      en['BG-7'].val['BG-8'].val['BT-51'] = {'name':'Buyer address line 2', 'val':BuyerPostalTradeAddress['ram:LineTwo']};
      en['BG-7'].val['BG-8'].val['BT-163'] = {'name':'Buyer address line 3', 'val':BuyerPostalTradeAddress['ram:LineThree']};
      en['BG-7'].val['BG-8'].val['BT-52'] = {'name':'Buyer city', 'val':BuyerPostalTradeAddress['ram:CityName']};
      en['BG-7'].val['BG-8'].val['BT-53'] = {'name':'Buyer post code', 'val':BuyerPostalTradeAddress['ram:PostcodeCode']};
      en['BG-7'].val['BG-8'].val['BT-54'] = {'name':'Buyer country subdivision', 'val':BuyerPostalTradeAddress['ram:CountrySubDivisionName']};
      en['BG-7'].val['BG-8'].val['BT-55'] = {'name':'Buyer country code', 'val':BuyerPostalTradeAddress['ram:CountryID']};
    }
    var BuyerDefinedTradeContact = BuyerTradeParty['ram:DefinedTradeContact'];
    if (BuyerDefinedTradeContact) {
      BuyerDefinedTradeContact = BuyerDefinedTradeContact[0];
      en['BG-7'].val['BG-9'] = {'name':'BUYER CONTACT', 'val':[]};
      //, 'val':SupplyChainTradeTransaction['ram;ApplicableHeaderTradeAgreement'][0]['ram:BuyerTradeParty'][0]['ram:DefinedTradeContact']};
      en['BG-7'].val['BG-9'].val['BT-56'] = {'name':'Buyer contact point', 'val':BuyerDefinedTradeContact['ram:PersonName']};
      // en['BT-56'] = {'name':'Buyer contact point', 'val':BuyerDefinedTradeContact['ram:DepartmentName']};
      if (BuyerDefinedTradeContact['ram:TelephoneUniversalCommunication']) {
        en['BG-7'].val['BG-9'].val['BT-57'] = {'name':'Buyer contact telephone number',
          'val':BuyerDefinedTradeContact['ram:TelephoneUniversalCommunication'][0]['ram:CompleteNumber']};
      }
      if (BuyerDefinedTradeContact['ram:EmailURIUniversalCommunication']) {
        en['BG-7'].val['BG-9'].val['BT-58'] = {'name':'Buyer contact email address',
          'val':BuyerDefinedTradeContact['ram:EmailURIUniversalCommunication'][0]['ram:URIID']};
      }
    }
    // PAYEE
    var PayeeTradeParty = ApplicableHeaderTradeSettlement['ram:PayeeTradeParty'];
    if (PayeeTradeParty) {
      PayeeTradeParty = PayeeTradeParty[0];
      en['BG-10'] = {'name':'PAYEE', 'val':[]};//, 'val':ApplicableHeaderTradeSettlement['ramiPayeeTradeParty']};
      en['BG-10'].val['BT-59'] = {'name':'Payee name', 'val':PayeeTradeParty['ram:Name']};
      en['BG-10'].val['BT-60'] = {'name':'Payee identifier', 'val':PayeeTradeParty['ram:ID']};
      // en['BT-60'] = {'name':'Payee identifier', 'val':PayeeTradeParty['ram:GlobalID']};
      // en['BT-60'] = {'name':'Payee identifier identificati on scheme identifier', 'val':PayeeTradeParty['ram:GlobalID/@schemeID']};
      if (PayeeTradeParty['ram:SpecifiedLegalOrganization']) {
        en['BG-10'].val['BT-61'] = {'name':'Payee legal registration identifier',
          'val':PayeeTradeParty['ram:SpecifiedLegalOrganization'][0]['ram:ID']};
        // en['BT-61'] = {'name':'Payee legal registration identifier identificati on scheme identifier', 'val':PayeeTradeParty['ram:SpecifiedLegalOrganization'][0]['ram:ID/@schemeID']};
      }
    }
    // SELLER TAX REPRESENTATIVE PARTY
    var SellerTaxRepresentativeTradeParty = ApplicableHeaderTradeAgreement['ram:SellerTaxRepresentativeTradeParty'];
    if (SellerTaxRepresentativeTradeParty) {
      SellerTaxRepresentativeTradeParty = SellerTaxRepresentativeTradeParty[0];
      en['BG-11'] = {'name':'SELLER TAX REPRESENTATIVE PARTY', 'val':[]};
      //, 'val':CrossIndustryInvoice['rsm:SuppIyChainTradeTransaction'][0]['ram:ApplicableHeaderTradeAgreement'][0]['ram:SellerTaxRepresentativeTradeParty']};
      en['BG-11'].val['BT-62'] = {'name':'Seller tax representative name', 'val':SellerTaxRepresentativeTradeParty['ram:Name']};
      if (SellerTaxRepresentativeTradeParty['ram:SpecifiedTaxRegistration']) {
        en['BG-11'].val['BT-63'] = {'name':'Seller tax representative VAT identifier',
          'val':SellerTaxRepresentativeTradeParty['ram:SpecifiedTaxRegistration'][0]['ram:ID']};
      }
      var SellerTaxRepresentativePostalTradeAddress = SellerTaxRepresentativeTradeParty['ram:PostalTradeAddress'];
      if (SellerTaxRepresentativePostalTradeAddress) {
        SellerTaxRepresentativePostalTradeAddress = SellerTaxRepresentativePostalTradeAddress[0];
        en['BG-11'].val['BG-12'] = {'name':'SELLER TAX REPRESENTATIVE POSTAL  ADDRESS', 'val':[]};
        //, 'val':SellerTaxRepresentativeTradeParty['ram:PostalTradeAddress']};
        en['BG-11'].val['BG-12'].val['BT-64'] = {'name':'Tax representative address line 1', 'val':SellerTaxRepresentativePostalTradeAddress['ram:LineOne']};
        en['BG-11'].val['BG-12'].val['BT-65'] = {'name':'Tax representative address line 2', 'val':SellerTaxRepresentativePostalTradeAddress['ram:LineTwo']};
        en['BG-11'].val['BG-12'].val['BT-164'] = {'name':'Tax representative address line 3', 'val':SellerTaxRepresentativePostalTradeAddress['ram:LineThree']};
        en['BG-11'].val['BG-12'].val['BT-66'] = {'name':'Tax representative city', 'val':SellerTaxRepresentativePostalTradeAddress['ram:CityName']};
        en['BG-11'].val['BG-12'].val['BT-67'] = {'name':'Tax representative post code', 'val':SellerTaxRepresentativePostalTradeAddress['ram:PostcodeCode']};
        en['BG-11'].val['BG-12'].val['BT-68'] = {'name':'Tax representative country subdivision', 'val':SellerTaxRepresentativePostalTradeAddress['ram:CountrySubDivisionName']};
        en['BG-11'].val['BG-12'].val['BT-69'] = {'name':'Tax representative country code', 'val':SellerTaxRepresentativePostalTradeAddress['ram:CountryID']};
      }
    }
    // DELIVERY INFORMATION
    en['BG-13'] = {'name':'DELIVERY INFORMATION', 'val':[]};//, 'val':ApplicableHeaderTradeDelivery['ram:ShipToTradeParty']};
    if (ApplicableHeaderTradeDelivery) {
      var ShipToTradeParty = ApplicableHeaderTradeDelivery['ram:ShipToTradeParty'];
      if (ShipToTradeParty) {
        ShipToTradeParty = ShipToTradeParty[0];
        en['BG-13'].val['BT-70'] = {'name':'Deliver to party name', 'val':ShipToTradeParty['ram:Name']};
        en['BG-13'].val['BT-71'] = {'name':'Deliver to location identifier', 'val':ShipToTradeParty['ram:ID']};
        // en['BT-71'] = {'name':'Deliver to location identifier', 'val':ShipToTradeParty['ram:GlobalID']};
        // en['BT-71'] = {'name':'Deliver to location identifier identificati on  scheme identifier', 'val':ShipToTradeParty['ram:GlobalID/@schemeID']};
        var ActualDeliverySupplyChainEvents = ApplicableHeaderTradeDelivery['ram:ActualDeliverySupplyChainEvent'];
        if (ActualDeliverySupplyChainEvents) {
          var ActualDeliverySupplyChainEvent = ActualDeliverySupplyChainEvents[0];
          var OccurrenceDateTimes = ActualDeliverySupplyChainEvent['ram:OccurrenceDateTime'];
          if (OccurrenceDateTimes) {
            var OccurrenceDateTime = OccurrenceDateTimes[0];
            en['BG-13'].val['BT-72'] = {'name':'Actual delivery date',
              'val':OccurrenceDateTime['udt:DateTimeString']};
          }
        }
      }
      var BillingSpecifiedPeriod = ApplicableHeaderTradeSettlement['ram:BillingSpecifiedPeriod'];
      if (BillingSpecifiedPeriod) {
        BillingSpecifiedPeriod = BillingSpecifiedPeriod[0];
        en['BG-13'].val['BG-14'] = {'name':'DELIVERY OR INVOICE PERIOD', 'val':[]};
        //, 'val':ApplicableHeaderTradeSettlement['ram:BillingSpecifiedPeriod']};
        var StartDateTimes = BillingSpecifiedPeriod['ram:StartDateTime'];
        if (StartDateTimes) {
          var StartDateTime = StartDateTimes[0];
          en['BG-13'].val['BG-14'].val['BT-73'] = {'name':'Invoicing period start date',
            'val':StartDateTime['udt:DateTimeString']};
          // en['BT-73'] = {'name':'Invoicing period start date', 'val':BillingSpecifiedPeriod['ram:StartDateTime'][0]['udt:DateTimeString/@format']};
        }
        var EndDateTimes = BillingSpecifiedPeriod['ram:EndDateTime'];
        if (EndDateTimes) {
          var EndDateTime = EndDateTimes[0];
          en['BG-13'].val['BG-14'].val['BT-74'] = {'name':'Invoicing period end date',
            'val':EndDateTime['udt:DateTimeStrlng']};
          // en['BT-74'] = {'name':'Invoicing period end date', 'val':BillingSpecifiedPeriod['ram:EndDateTime'][0]['udt:DateTimeString/@format']};
        }
      }
      // var ApplicableHeaderTradeDelivery = ApplicableHeaderTradeDelivery;
      var ShipToPostalTradeAddress = ShipToTradeParty['ram:PostalTradeAddress'];
      if (ShipToPostalTradeAddress) {
        ShipToPostalTradeAddress = ShipToPostalTradeAddress[0];
        en['BG-13'].val['BG-15'] = {'name':'DELIVER TO ADDRESS', 'val':[]};
        //, 'val':ShipToTradeParty['ram:PostalTradeAddress']};
        en['BG-13'].val['BG-15'].val['BT-75'] = {'name':'Deliver to address line 1',
          'val':ShipToPostalTradeAddress['ram:LineOne']};
        en['BG-13'].val['BG-15'].val['BT-76'] = {'name':'Deliver to address line 2',
          'val':ShipToPostalTradeAddress['ram:LineTwo']};
        en['BG-13'].val['BG-15'].val['BT-165'] = {'name':'Deliver to address line 3',
          'val':ShipToPostalTradeAddress['ram:LineThree']};
        en['BG-13'].val['BG-15'].val['BT-77'] = {'name':'Deliver to city',
          'val':ShipToPostalTradeAddress['ram:CityName']};
        en['BG-13'].val['BG-15'].val['BT-78'] = {'name':'Deliver to post code',
          'val':ShipToPostalTradeAddress['ram:PostcodeCode']};
        en['BG-13'].val['BG-15'].val['BT-79'] = {'name':'Deliver to country subdivision',
          'val':ShipToPostalTradeAddress['ram:CountrySubDivisionName']};
        en['BG-13'].val['BG-15'].val['BT-80'] = {'name':'Deliver to country code',
          'val':ShipToPostalTradeAddress['ram:CountryID']};
      }
    }
    // PAYMENT INSTRUCTIONS
    var SpecifiedTradeSettlementPaymentMeans = ApplicableHeaderTradeSettlement['ram:SpecifiedTradeSettlementPaymentMeans'];
    if (SpecifiedTradeSettlementPaymentMeans) {
      SpecifiedTradeSettlementPaymentMeans = SpecifiedTradeSettlementPaymentMeans[0];
      en['BG-16'] = {'name':'PAYMENT INSTRUCTIONS', 'val':[]};
      //, 'val':ApplicableHeaderTradeSettlement['ram:SpecifiedTradeSettlementPaymentMeans']};
      en['BG-16'].val['BT-81'] = {'name':'Payment means type code',
        'val':SpecifiedTradeSettlementPaymentMeans['ram:TypeCode']};
      en['BG-16'].val['BT-82'] = {'name':'Payment means text',
        'val':SpecifiedTradeSettlementPaymentMeans['ram:Information']};
      en['BG-16'].val['BT-83'] = {'name':'Remittance information',
        'val':ApplicableHeaderTradeSettlement['ram:PaymentReference']};
      var PayeePartyCreditorFinancialAccounts = SpecifiedTradeSettlementPaymentMeans['ram:PayeePartyCreditorFinancialAccount'];
      if (PayeePartyCreditorFinancialAccounts) {
        // BG-17 CREDIT TRANSFER (Multiple)
        en['BG-16'].val['BG-17'] = {'name':'CREDIT TRANSFER', 'val':[]};
        //, 'val':SpecifiedTradeSettlementPaymentMeans['ram:PayeePartyCreditorFinancialAccount']};
        for (var PayeePartyCreditorFinancialAccount of PayeePartyCreditorFinancialAccounts || []){
          var BG_17 ={};
          BG_17['BT-84'] = {'name':'Payment account identifier', 'val':PayeePartyCreditorFinancialAccount['ram:IBANID']};
          // en['BG-16'].val['BT-84'] = {'name':'Payment account identifier', 'val':PayeePartyCreditorFinancialAccount['ram:ProprietarylD']};
          BG_17['BT-85'] = {'name':'Payment account name', 'val':PayeePartyCreditorFinancialAccount['ram:AccountName']};
          en['BG-16'].val['BG-17'].val.push(BG_17);
        }
      }
      var PayeeSpecifiedCreditorFinancialInstitution = SpecifiedTradeSettlementPaymentMeans['ram:PayeeSpecifiedCreditorFinancialInstitution'];
      if (PayeeSpecifiedCreditorFinancialInstitution) {
        PayeeSpecifiedCreditorFinancialInstitution = PayeeSpecifiedCreditorFinancialInstitution[0];
        en['BG-16'].val['BG-17'].val['BT-86'] = {'name':'Payment service provider identifier',
          'val':PayeeSpecifiedCreditorFinancialInstitution['ram:BICID']};
      }
      // en['BG-16'].val['BT-86'] = {'name':'Payment service provider identifier', 'val':SpecifiedTradeSettlementPaymentMeans['ram:PayeeSpecifiedCreditorFinancialInstitution'][0]['ram:BICID']};
      var ApplicableTradeSettlementFinancialCard = SpecifiedTradeSettlementPaymentMeans['ram:ApplicableTradeSettlementFinancialCard'];
      if (ApplicableTradeSettlementFinancialCard) {
        ApplicableTradeSettlementFinancialCard = ApplicableTradeSettlementFinancialCard[0];
        en['BG-16'].val['BG-18'] = {'name':'PAYMENT CARD INFORMATION', 'val':[]};
        //, 'val':SpecifiedTradeSettlementPaymentMeans['ram:ApplicableTradeSettlementFinancialCard']};
        en['BG-16'].val['BG-18'].val['BT-87'] = {'name':'Payment card primary account number',
          'val':ApplicableTradeSettlementFinancialCard['ram:ID']};
        en['BG-16'].val['BG-18'].val['BT-88'] = {'name':'Payment card holder name',
          'val':ApplicableTradeSettlementFinancialCard['ram:CardholderName']};
      }
      en['BG-16'].val['BG-19'] = {'name':'DIRECT DEBIT', 'val':[]};
      //, 'val':SupplyChainTradeTransaction['ram:ApplicableHeaderTradeSettlement']};
      var SpecifiedTradePaymentTerms = ApplicableHeaderTradeSettlement['ram:SpecifiedTradePaymentTerms'];
      if (SpecifiedTradePaymentTerms) {
        SpecifiedTradePaymentTerms = SpecifiedTradePaymentTerms[0];
        en['BG-16'].val['BG-19'].val['BT-89'] = {'name':'Mandate reference identifier',
          'val':SpecifiedTradePaymentTerms['ram:DirectDebitMandatelD']};
      }
      en['BG-16'].val['BG-19'].val['BT-90'] = {'name':'Bank assigned creditor identifier',
        'val':ApplicableHeaderTradeSettlement['ram:CreditorReferenceID']
      };
      var PayerPartyDebtorFinancialAccount = SpecifiedTradeSettlementPaymentMeans['ram:PayerPartyDebtorFinancialAccount'];
      if (PayerPartyDebtorFinancialAccount) {
        PayerPartyDebtorFinancialAccount = PayerPartyDebtorFinancialAccount[0];
        en['BG-16'].val['BG-19'].val['BT-91'] = {'name':'Debited account identifier',
          'val':PayerPartyDebtorFinancialAccount['ram:IBANID']};
      }
    }
    // DOCUMENT LEVEL ALLOWANCES
    var SpecifiedTradeAllowanceCharges = ApplicableHeaderTradeSettlement['ram:SpecifiedTradeAllowanceCharge'];
    if (SpecifiedTradeAllowanceCharges) {
      // BG-20 DOCUMENT LEVEL ALLOWANCES (Multiple)
      en['BG-20'] = {'name':'DOCUMENT LEVEL ALLOWANCES', 'val':[]};
      //, 'val':ApplicableHeaderTradeSettlement['ram:SpecifiedTradeA]lowanceCharge']};
      // BG-21 DOCUMENT LEVEL CHARGES (Multiple)
      en['BG-21'] = {'name':'DOCUMENT LEVEL CHARGES', 'val':[]};
      //, 'val':ApplicableHeaderTradeSettlement['ram:SpecifiedTradeAllowanceCharge']};
      for (var SpecifiedTradeAllowanceCharge of SpecifiedTradeAllowanceCharges || []){
        var BG_20 = {};
        BG_20['BT-92'] = {'name':'Document level allowance amount',
          'val':SpecifiedTradeAllowanceCharge['ram:ActualAmount']};
        BG_20['BT-93'] = {'name':'Document level allowance base amount',
          'val':SpecifiedTradeAllowanceCharge['ram:BasisAmount']};
        BG_20['BT-94'] = {'name':'Document level allowance percentage',
          'val':SpecifiedTradeAllowanceCharge['ram:CalculationPercent']};
        var CategoryTradeTax = SpecifiedTradeAllowanceCharge['ram:CategoryTradeTax'];
        if (CategoryTradeTax) {
          CategoryTradeTax = CategoryTradeTax[0];
          BG_20['BT-95'] = {'name':'Document level allowance VAT category code',
            'val':CategoryTradeTax['ram:TypeCode']
          };
          // en['BT-95'] = {'name':'Document level allowance VAT category code', 'val':CategoryTradeTax['ram:CategoryCode']};
          BG_20['BT-96'] = {'name':'Document level allowance VAT rate',
            'val':CategoryTradeTax['ram:RateApplicablePercent']
          };
          BG_20['BT-97'] = {'name':'Document level allowance reason',
            'val':SpecifiedTradeAllowanceCharge['ram:Reason']
          };
          BG_20['BT-98'] = {'name':'Document level allowance reason code',
            'val':SpecifiedTradeAllowanceCharge['ram:ReasonCode']
          };
          en['BG-20'].val.push(BG_20);
          var BG_21 = {};
          BG_21['BT-99'] = {'name':'Document level charge amount',
            'val':SpecifiedTradeAllowanceCharge['ram:ActualAmount']
          };
          BG_21['BT-100'] = {'name':'Document level charge base amount',
            'val':SpecifiedTradeAllowanceCharge['ram:BasisAmount']
          };
          BG_21['BT-101'] = {'name':'Document level charge percentage',
            'val':SpecifiedTradeAllowanceCharge['ram:CalculationPercent']
          };
          BG_21['BT-102'] = {'name':'Document level charge VAT category code',
            'val':CategoryTradeTax['ram:TypeCode']
          };
          BG_21['BT-102'] = {'name':'Document level charge VAT category code',
            'val':CategoryTradeTax['ram:CategoryCode']
          };
          BG_21['BT-103'] = {'name':'Document level charge VAT rate',
            'val':CategoryTradeTax['ram:RateApplicablePercent']
          };
          BG_21['BT-104'] = {'name':'Document level charge reason',
            'val':SpecifiedTradeAllowanceCharge['ram:Reason']
          };
          BG_21['BT-105'] = {'name':'Document level charge reason code',
            'val':SpecifiedTradeAllowanceCharge['ram:ReasonCode']
          };
          en['BG-21'].val.push(BG_21);
        }
      }
    }
    // DOCUMENT TOTALS
    var SpecifiedTradeSettlementHeaderMonetarySummation = ApplicableHeaderTradeSettlement['ram:SpecifiedTradeSettlementHeaderMonetarySummation'];
    if (SpecifiedTradeSettlementHeaderMonetarySummation) {
      SpecifiedTradeSettlementHeaderMonetarySummation = SpecifiedTradeSettlementHeaderMonetarySummation[0];
      en['BG-22'] = {'name':'DOCUMENT TOTALS', 'val':[]};
      //, 'val':ApplicableHeaderTradeSettlement['ram:SpecifiedTradeSettlementHeaderMonetarySummation']};
      en['BG-22'].val['BT-106'] = {'name':'Sum of Invoice line net amount',
        'val':SpecifiedTradeSettlementHeaderMonetarySummation['ram:LineTotalAmount']
      };
      en['BG-22'].val['BT-107'] = {'name':'Sum of allowances on document level',
        'val':SpecifiedTradeSettlementHeaderMonetarySummation['ram:AllowanceTotalAmount']
      };
      en['BG-22'].val['BT-108'] = {'name':'Sum of charges on document level',
        'val':SpecifiedTradeSettlementHeaderMonetarySummation['ram:ChargeTotalAmount']
      };
      en['BG-22'].val['BT-109'] = {'name':'Invoice total amount without VAT',
        'val':SpecifiedTradeSettlementHeaderMonetarySummation['ram:TaxBasisTotalAmount']
      };
      en['BG-22'].val['BT-110'] = {'name':'Invoice total VAT amount',
        'val':SpecifiedTradeSettlementHeaderMonetarySummation['ram:TaxTotalAmount']
      };
      en['BG-22'].val['BT-111'] = {'name':'Invoice total VAT amount in accounting currency',
        'val':SpecifiedTradeSettlementHeaderMonetarySummation['ram:TaxTotalAmount']
      };
      en['BG-22'].val['BT-112'] = {'name':'Invoice total amount with VAT',
        'val':SpecifiedTradeSettlementHeaderMonetarySummation['ram:GrandTotalAmount']
      };
      en['BG-22'].val['BT-113'] = {'name':'Paid amount',
        'val':SpecifiedTradeSettlementHeaderMonetarySummation['ram:TotalPrepaidAmount']
      };
      en['BG-22'].val['BT-114'] = {'name':'Rounding amount',
        'val':SpecifiedTradeSettlementHeaderMonetarySummation['ram:RoundingAmount']
      };
      en['BG-22'].val['BT-115'] = {'name':'Amount due for payment',
        'val':SpecifiedTradeSettlementHeaderMonetarySummation['ram:DuePayableAmount']
      };
    }
    // INVOICE LINE
    var IncludedSupplyChainTradeLineItems = SupplyChainTradeTransaction['ram:IncludedSupplyChainTradeLineItem'];
    if (IncludedSupplyChainTradeLineItems) {
      en['BG-25'] = {'name':'INVOICE LINE', 'val':[]};
      //, 'val':SupplyChainTradeTransaction['ram:IncludedSupplyChainTradeLineltem']};
      for (var i = 0; i < IncludedSupplyChainTradeLineItems.length; i++ || []){
        var IncludedSupplyChainTradeLineItem = IncludedSupplyChainTradeLineItems[i];
        var BG_25 = {};
        var AssociatedDocumentLineDocuments = IncludedSupplyChainTradeLineItem['ram:AssociatedDocumentLineDocument'];
        if (AssociatedDocumentLineDocuments) {
          var AssociatedDocumentLineDocument = AssociatedDocumentLineDocuments[0];
          BG_25['BT-126'] = {'name':'Invoice line identifier', 'val':AssociatedDocumentLineDocument['ram:LineID']};
          var IncludedNotes = AssociatedDocumentLineDocument['ram:IncludedNote'];
          if (IncludedNotes) {
            var IncludedNote = IncludedNotes[0];
            BG_25['BT-127'] = {'name':'Invoice line note', 'val':IncludedNote['ram:Content']};
          }
        }
        var SpecifiedLineTradeSettlements = IncludedSupplyChainTradeLineItem['ram:SpecifiedLineTradeSettlement'];
        if (SpecifiedLineTradeSettlements) {
          var SpecifiedLineTradeSettlement = SpecifiedLineTradeSettlements[0];
          var AdditionalReferencedDocument = SpecifiedLineTradeSettlement['ram:AdditionalReferencedDocument'];
          if (AdditionalReferencedDocument) {
            AdditionalReferencedDocument = AdditionalReferencedDocument[0];
            BG_25['BT-128'] = {'name':'Invoice line object identifier',
              'val':AdditionalReferencedDocument['ram:IssuerAssignedID']};
          }
        }
        // en['BT-128'] = {'name':'Invoice line object identifier', 'val':SpecifiedLineTradeSettlement['ram:AdditionalReferencedDocument'][0]['ram:TypeCode']};
        // en['BT-128'] = {'name':'Invoice line object identifier identificati on  scheme identifier', 'val':SpecifiedLineTradeSettlement['ram:AdditionalReferencedDocument'][0]['ram:ReferenceTypeCode']};
        var SpecifiedLineTradeDeliveries = IncludedSupplyChainTradeLineItem['ram:SpecifiedLineTradeDelivery'];
        if (SpecifiedLineTradeDeliveries) {
          var SpecifiedLineTradeDelivery = SpecifiedLineTradeDeliveries[0];
          BG_25['BT-129'] = {'name':'Invoiced quantity',
            'val':SpecifiedLineTradeDelivery['ram:BilledQuantity']};
          BG_25['BT-130'] = {'name':'Invoiced quantity unit of measure',
            'val':SpecifiedLineTradeDelivery['ram:BilledQuantity']};//@unitCode']};
        }
        var SpecifiedTradeSettlementLineMonetarySummations = SpecifiedLineTradeSettlement['ram:SpecifiedTradeSettlementLineMonetarySummation'];
        if (SpecifiedTradeSettlementLineMonetarySummations) {
          var SpecifiedTradeSettlementLineMonetarySummation = SpecifiedTradeSettlementLineMonetarySummations[0];
          BG_25['BT-131'] = {'name':'Invoice line net amount',
            'val':SpecifiedTradeSettlementLineMonetarySummation['ram:LineTotalAmount']};
        }
        var SpecifiedLineTradeAgreements = IncludedSupplyChainTradeLineItem['ram:SpecifiedLineTradeAgreement'];
        if (SpecifiedLineTradeAgreements) {
          var SpecifiedLineTradeAgreement = SpecifiedLineTradeAgreements[0];
          var BuyerOrderReferencedDocuments = SpecifiedLineTradeAgreement['ram:BuyerOrderReferencedDocument'];
          if (BuyerOrderReferencedDocuments) {
            var BuyerOrderReferencedDocument = BuyerOrderReferencedDocuments[0];
            BG_25['BT-132'] = {'name':'Referenced purchase order line reference',
              'val':BuyerOrderReferencedDocument['ram:LineID']
            };
          }
        }
        var ReceivableSpecifiedTradeAccountingAccounts = SpecifiedLineTradeSettlement['ram:ReceivableSpecifiedTradeAccountingAccount'];
        if (ReceivableSpecifiedTradeAccountingAccounts) {
          var ReceivableSpecifiedTradeAccountingAccount = ReceivableSpecifiedTradeAccountingAccounts[0];
          BG_25['BT-133'] = {'name':'Invoice line Buyer accounting reference',
            'val':ReceivableSpecifiedTradeAccountingAccount['ram:ID']
          };
        }
        var BillingSpecifiedPeriods = SpecifiedLineTradeSettlement['ram:BillingSpecifiedPeriod'];
        if (BillingSpecifiedPeriods) {
          var BillingSpecifiedPeriod = BillingSpecifiedPeriods[0];
          BG_25['BG-26'] = {'name':'INVOICE LINE PERIOD', 'val':[]};
          //, 'val':SpecifiedLineTradeSettlement['ram:BillingSpecifiedPeriod']};
          BG_25['BG-26'].val['BT-134'] = {'name':'Invoice line period start date',
            'val':BillingSpecifiedPeriod['ram:StartDateTime'][0]['udt:DateTimeString']
          };
          // BG_25['BT-134'] = {'name':'Invoice line period start date',
          // 'val':SupplyChainTradeTransaction['ram:IncludedSupplyChainTradeLineltem/ranrSpecifiedLineTradeSettlement'][0]['ram:BillingSpecifiedPeriod'][0]['ram:StartDateTime'][0]['udt:DateTimeString/@format']};
          BG_25['BG-26'].val['BT-135'] = {'name':'Invoice line period end date',
            'val':BillingSpecifiedPeriod['ram:EndDateTime'][0]['udt:DateTimeString']
          };
          // BG_25['BT-135'] = {'name':'Invoice line period end date',
          // 'val':BillingSpecifiedPeriod['ram:EndDateTime'][0]['udt:DateTimeString/@format']};
        }
        var SpecifiedTradeAllowanceCharges = SpecifiedLineTradeSettlement['ram:SpecifiedTradeAllowanceCharge'];
        if (SpecifiedTradeAllowanceCharges) {
          var SpecifiedTradeAllowanceCharge = SpecifiedTradeAllowanceCharges[0]; // Multiple
          // BG-27 INVOICE LINE ALLOWANCES (Multiple)
          BG_25['BG-27'] = {'name':'INVOICE LINE ALLOWANCES', 'val':[]};
          //, 'val':SpecifiedLineTradeSettlement['ram:SpecifiedTradeAllowanceCharge']};
          BG_25['BG-27'].val['BT-136'] = {'name':'Invoice line allowance amount',
            'val':SpecifiedTradeAllowanceCharge['ram:ActualAmount']
          };
          BG_25['BG-27'].val['BT-137'] = {'name':'Invoice line allowance base amount',
            'val':SpecifiedTradeAllowanceCharge['ram:BasisAmount']
          };
          // var SpecifiedTradeAllowanceCharge = SpecifiedLineTradeSettlement['ram:SpecifiedTradeAllowanceCharge'];
          BG_25['BG-27'].val['BT-138'] = {'name':'Invoice line allowance percentage',
            'val':SpecifiedTradeAllowanceCharge['ram:CalculationPercent']
          };
          BG_25['BG-27'].val['BT-139'] = {'name':'Invoice line allowance reason',
            'val':SpecifiedTradeAllowanceCharge['ram:Reason']
          };
          BG_25['BG-27'].val['BT-140'] = {'name':'Invoice line allowance reason code',
            'val':SpecifiedTradeAllowanceCharge['ram:ReasonCode']
          };
          // BG-28 INVOICE LINE CHARGES (Multiple)
          BG_25['BG-28'] = {'name':'INVOICE LINE CHARGES', 'val':[]};
          //, 'val':SpecifiedLineTradeSettlement['ram:SpecifiedTradeAllowanceCharge']};
          BG_25['BG-28'].val['BT-141'] = {'name':'Invoice line charge amount',
            'val':SpecifiedTradeAllowanceCharge['ram:ActualAmount']
          };
          BG_25['BG-28'].val['BT-142'] = {'name':'Invoice line charge base amount',
            'val':SpecifiedTradeAllowanceCharge['ram:BasisAmount']
          };
          BG_25['BG-28'].val['BT-143'] = {'name':'Invoice line charge percentage',
            'val':SpecifiedTradeAllowanceCharge['ram:CalculationPercent']
          };
          BG_25['BG-28'].val['BT-144'] = {'name':'Invoice line charge reason',
            'val':SpecifiedTradeAllowanceCharge['ram:Reason']
          };
          BG_25['BG-28'].val['BT-145'] = {'name':'Invoice line charge reason code',
            'val':SpecifiedTradeAllowanceCharge['ram:ReasonCode']
          };
        }
        if (SpecifiedLineTradeAgreement) {
          var NetPriceProductTradePrices = SpecifiedLineTradeAgreement['ram:NetPriceProductTradePrice'];
          var NetPriceProductTradePrices, GrossPriceProductTradePrice;
          if (NetPriceProductTradePrices) {
            NetPriceProductTradePrice = NetPriceProductTradePrices[0];
          }
          var GrossPriceProductTradePrices = SpecifiedLineTradeAgreement['ram:GrossPriceProductTradePrice'];
          if (GrossPriceProductTradePrices) {
            GrossPriceProductTradePrice = GrossPriceProductTradePrices[0];
          }
          if (NetPriceProductTradePrice || GrossPriceProductTradePrice) {
            BG_25['BG-29'] = {'name':'PRICE DETAILS', 'val':[]};
            //, 'val':IncludedSupplyChainTradeLineItem['ram:SpecifiedLineTradeAgreement']};
          }
          if (NetPriceProductTradePrice) {
            BG_25['BG-29'].val['BT-146'] = {'name':'Item price',
              'val':NetPriceProductTradePrice['ram:ChargeAmount']
            };
          }
          if (GrossPriceProductTradePrice) {
            var AppliedTradeAllowanceCharge = GrossPriceProductTradePrice['ram:AppliedTradeAllowanceCharge'];
            if (AppliedTradeAllowanceCharge) {
              BG_25['BG-29'].val['BT-147'] = {'name':'Item price discount',
                'val':AppliedTradeAllowanceCharge['ram:ActualAmount']};
            }
            BG_25['BG-29'].val['BT-148'] = {'name':'Item gross price',
              'val':GrossPriceProductTradePrice['ram:ChargeAmount']
            };
            BG_25['BG-29'].val['BT-149'] = {'name':'Item price base quantity',
              'val':GrossPriceProductTradePrice['ram:BasisQuantity']
            };
            // BG_25['BT-149'] = {'name':'Item price base quantity',
            // 'val':SupplyChainTradeTransaction['ram:IncludedSupplyChainTradeLineltem'][0]['ramrSpecifiedLineTradeAgreement'][0]['ram:NetPriceProductTradePrice'][0]['ram:BasisQuantity']};
            BG_25['BG-29'].val['BT-150'] = {'name':'Item price base quantity unit of measure code',
              'val':GrossPriceProductTradePrice['ram:BasisQuantity']
            };///@unitCode']};
          }
        }
        var ApplicableTradeTaxes = SpecifiedLineTradeSettlement['ram:ApplicableTradeTax'];
        if (ApplicableTradeTaxes) {
          var ApplicableTradeTax = ApplicableTradeTaxes[0];
          BG_25['BG-30'] = {'name':'LINE VAT INFORMATION', 'val':[]};
          //, 'val':SpecifiedLineTradeSettlement['ram:ApplicableTradeTax']};
          BG_25['BG-30'].val['BT-151'] = {'name':'Invoiced BG_25 VAT category code',
            'val':ApplicableTradeTax['ram:TypeCode']
          };
          // BG_25['BT-151'] = {'name':'Invoiced item VAT category code', 'val':ApplicableTradeTax['ram:CategoryCode']};
          BG_25['BG-30'].val['BT-152'] = {'name':'Invoiced item VAT rate',
            'val':ApplicableTradeTax['ram:RateApplicablePercent']
          };
        }
        var SpecifiedTradeProducts = IncludedSupplyChainTradeLineItem['ram:SpecifiedTradeProduct']
        if (SpecifiedTradeProducts) {
          var SpecifiedTradeProduct = SpecifiedTradeProducts[0];
          BG_25['BG-31'] = {'name':'ITEM INFORMATION', 'val':[]};
          //, 'val':IncludedSupplyChainTradeLineItem['ram:SpecifiedTradeProduct']};
          BG_25['BG-31'].val['BT-153'] = {'name':'Item name',
            'val':SpecifiedTradeProduct['ram:Name']
          };
          BG_25['BG-31'].val['BT-154'] = {'name':'Item description',
            'val':SpecifiedTradeProduct['ram:Description']
          };
          BG_25['BG-31'].val['BT-155'] = {'name':'Item Seller&quots identifier',
            'val':SpecifiedTradeProduct['ram:SellerAssignedID']
          };
          BG_25['BG-31'].val['BT-156'] = {'name':'Item Buyer&quots identifier',
            'val':SpecifiedTradeProduct['ram:BuyerAssignedID']
          };
          BG_25['BG-31'].val['BT-157'] = {'name':'Item standard identifier',
            'val':SpecifiedTradeProduct['ram:GlobalID']
          };
          // BG_25['BT-157'] = {'name':'Item standard identifier identificati on scheme  identifier', 'val':CrossIndustryInvoice['rsm:Supp]yChainTradeTransaction'][0]['ram:IncludedSupplyChainTradeLineItem'][0]['ram:SpecifiedTradeProduct'][0]['ram:GlobalID/@schemeID']};
          var DesignatedProductClassifications = SpecifiedTradeProduct['ram:DesignatedProductClassification'];
          if (DesignatedProductClassifications) {
            var DesignatedProductClassification = DesignatedProductClassifications[0];
            // BT-158 (Multiple)
            BG_25['BG-31'].val['BT-158'] = {'name':'Item classificati on identifier',
              'val':DesignatedProductClassification['ram:ClassCode']
            };
            BG_25['BG-31'].val['BT-158'] = {'name':'Item classificati on identifier identificati on  scheme identifier',
              'val':DesignatedProductClassification['ram:ClassCode']
            };///@listID']};
          }
          // BG_25['BT-158'] = {'name':'Scheme version identifer', 'val':SpecifiedTradeProduct['ram:DesignatedProductClassification'][0]['ram:ClassCode/@listVersionID']};
          var OriginTradeCountries = SpecifiedTradeProduct['ram:OriginTradeCountry'];
          if (OriginTradeCountries) {
            var OriginTradeCountry = OriginTradeCountries[0];
            BG_25['BG-31'].val['BT-159'] = {'name':'Item country of origin',
              'val':OriginTradeCountry['ram:ID']
            };
          }
          var ApplicableProductCharacteristics = SpecifiedTradeProduct['ram:ApplicableProductCharacteristic'];
          if (ApplicableProductCharacteristics) {
            var ApplicableProductCharacteristic = ApplicableProductCharacteristics[0];
            // BG-32 ITEM ATTRIBUTES (Multiple)
            BG_25['BG-32'] = {'name':'ITEM ATTRIBUTES', 'val':[]};//, 'val':SpecifiedTradeProduct['ram:ApplicableProductCharacteristic']};
            BG_25['BG-32'].val['BT-160'] = {'name':'Item attribute name',
              'val':ApplicableProductCharacteristic['ram:Description']
            };
            BG_25['BG-32'].val['BT-161'] = {'name':'Item attribute value',
              'val':ApplicableProductCharacteristic['ram:Value']
            };
          }
        }
        en['BG-25'].val.push(BG_25);
      }
    }
    return en;
  }

  function ubl2en(json) {
    // edit
    // (B[GT]-[0-9\-]*)\t([ 0-9]*)\t([0-9a-zA-Z ]*)\t(.*)
    // en['$1'] = {'lv':'$2', 'name':'$3', 'val':'$4'};
    var en = {};
    var Invoice = json['Invoice'][0];
    en['BT-1'] = {'name':'Invoice number', 'val':Invoice['cbc:ID']};
    en['BT-2'] = {'name':'Invoice issue date', 'val':Invoice['cbc:IssueDate']};
    en['BT-3'] = {'name':'Invoice type code', 'val':Invoice['cbc:InvoiceTypeCode']};
    en['BT-5'] = {'name':'Invoice currency code', 'val':Invoice['cbcDocumentCurrencyCode']};
    en['BT-6'] = {'name':'VAT accounting currency code', 'val':Invoice['cbciTaxCurrencyCode']};
    en['BT-7'] = {'name':'Value added tax point date', 'val':Invoice['cbc:TaxPointDate']};
    var InvoicePeriods = Invoice['cac:InvoicePeriod'];
    if (InvoicePeriods) {
      var InvoicePeriod = InvoicePeriods[0];
      en['BT-8'] = {'name':'Value added tax point date code', 'val':InvoicePeriod['cbc:DescriptionCode']};
    }
    en['BT-9'] = {'name':'Payment due date', 'val':Invoice['cbc:DueDate']};
    en['BT-10'] = {'name':'Buyer reference', 'val':Invoice['cbc:BuyerReference']};
    var ProjectReferences = Invoice['cac:ProjectReference'];
    if (ProjectReferences) {
      var ProjectReference = ProjectReferences[0];
      en['BT-11'] = {'name':'Project reference', 'val':ProjectReference['cbc:ID']};
    }
    var ContractDocumentReferences = Invoice['cac:ContractDocumentReference'];
    if (ContractDocumentReferences) {
      var ContractDocumentReference = ContractDocumentReferences[0];
      en['BT-12'] = {'name':'Contract reference', 'val':ContractDocumentReference['cbc:ID']};
    }
    var OrderReferences = Invoice['cac:OrderReference'];
    if (OrderReferences) {
      var OrderReference = OrderReferences[0];
      en['BT-13'] = {'name':'Purchase order reference', 'val':OrderReference['cbc:ID']};
      en['BT-14'] = {'name':'Sales order reference', 'val':OrderReference['cbc:SalesOrderID']};
    }
    var ReceiptDocumentReferences = Invoice['cac:ReceiptDocumentReference'];
    if (ReceiptDocumentReferences) {
      var ReceiptDocumentReference = ReceiptDocumentReferences[0];
      en['BT-15'] = {'name':'Receiving advice reference', 'val':ReceiptDocumentReference['cbc:ID']};
    }
    var DespatchDocumentReferences = Invoice['cac:DespatchDocumentReference'];
    if (DespatchDocumentReferences) {
      var DespatchDocumentReference = DespatchDocumentReferences[0];
      en['BT-16'] = {'name':'Despatch advice reference', 'val':DespatchDocumentReference['cbc:ID']};
    }
    var OriginatorDocumentReferences = Invoice['cac:OriginatorDocumentReference'];
    if (OriginatorDocumentReferences) {
      var OriginatorDocumentReference = OriginatorDocumentReferences[0];
      en['BT-17'] = {'name':'Tender or lot reference', 'val':OriginatorDocumentReference['cbc:ID']};
    }
    var AdditionalDocumentReferences = Invoice['cac:AdditionalDocumentReference'];
    if (AdditionalDocumentReferences) {
      var AdditionalDocumentReference = AdditionalDocumentReferences[0];
      en['BT-18'] = {'name':'Invoiced object identifier', 'val':AdditionalDocumentReference['cbc:ID']};
      //TODO en['BT-18-1'] = {'name':'Scheme identifier', 'val':AdditionalDocumentReference['cbc:ID/@schemeID']};
    }
    en['BT-19'] = {'name':'Buyer accounting reference', 'val':Invoice['cbc:AccountingCost']};
    var PaymentTerms = Invoice['cac:PaymentTerms'];
    if (PaymentTerms) {
      var PaymentTerm = PaymentTerms[0]; //TODO multiple
      en['BT-20'] = {'name':'Payment terms', 'val':Invoice['cac:PaymentTerms/cbc:Note']};
    }
    // INVOICE NOTE (Multiple)
    en['BG-1'] = {'name':'INVOICE NOTE', 'val':[]};
    var Notes = Invoice['cbc:Note'];
    for (var Note of Notes || []){
      BG_1 = {};
      BG_1['BT-21'] = {'name':'Invoice note subject code', 'val':Note};
      BG_1['BT-22'] = {'name':'Invoice note', 'val':Note};
      en['BG-1'].val.push(BG_1);
    }
    // PROCESS CONTROL
    en['BG-2'] = {'name':'PROCESS CONTROL', 'val':[]};
    en['BG-2'].val['BT-23'] = {'name':'Business process type', 'val':Invoice['cbcProfilelD']};
    en['BG-2'].val['BT-24'] = {'name':'Specification identifier', 'val':Invoice['cbc:CustomizationID']};
    // BG-3 PRECEDING INVOICE REFERENCE (Multiple)
    en['BG-3'] = {'name':'PRECEDING INVOICE REFERENCE', 'val':[]};
    var BillingReferences = Invoice['cac:BillingReference'];
    if (BillingReferences) {
      for (var BillingReference of BillingReferences || []){
        var BG_3 = {};
        var InvoiceDocumentReferences = BillingReference['cac:InvoiceDocumentReference'];
        if (InvoiceDocumentReferences) {
          var InvoiceDocumentReference = InvoiceDocumentReferences[0];
          BG_3['BT-25'] = {'name':'Preceding Invoice number', 'val':InvoiceDocumentReference['cbc:ID']};
          BG_3['BT-26'] = {'name':'Preceding Invoice issue date', 'val':InvoiceDocumentReference['cbc:IssueDate']};
          en['BG-3'].val.push(BG_3);
        }
      }
    }
    var AccountingSupplierParties = Invoice['cac:AccountingSupplierParty'];
    if (AccountingSupplierParties) {
      var AccountingSupplierParty = AccountingSupplierParties[0];
      // SELLER
      en['BG-4'] = {'name':'SELLER', 'val':[]};
      var Parties = AccountingSupplierParty['cac:Party'];
      if (Parties) {
        var Party = Parties[0];
        en['BG-4'].val['BT-27'] = {'name':'Seller name', 'val':Party['cac:PartyLegalEntity/cbc:RegistrationName']};
        en['BG-4'].val['BT-30'] = {'name':'Seller legal registration identifier', 'val':Party['cac:PartyLegalEntity/cbc:CompanyID']};
        // en['BG-4'].val['BT-30-1'] = {'lv':3, 'name':'Seller legal registration identifier identification scheme identifier', 'val':Party['cac:PartyLegalEntity/cbc:CompanyID/@schemeID']};
        en['BG-4'].val['BT-28'] = {'name':'Seller trading name', 'val':Party['cac:PartyName/cbc:Name']};
        // BT-29 Seller identifier (Multiple)
        en['BG-4'].val['BT-29'] = {'name':'Seller identifier', 'val':[]};
        var PartyIdentifications = Party['cac:PartyIdentification'];
        for (var PartyIdentification of PartyIdentifications || []){
          en['BG-4'].val['BT-29'].val.push(PartyIdentification['cbc:ID']);
        }
        // en['BG-4'].val['BT-29-1'] = {'lv':3, 'name':'Seller identifier identification scheme identifier', 'val':Party['cac:PartyIdentification/cbc:ID/@schemelD']};
        en['BG-4'].val['BT-31'] = {'name':'Seller VAT identifier', 'val':Party['cac:PartyTaxScheme/cbc:CompanyID']};
        en['BG-4'].val['BT-32'] = {'name':'Seller tax registration identifier', 'val':Party['cac:PartyTaxScheme/cbc:CompanyID']};
        en['BG-4'].val['BT-33'] = {'name':'Seller additional legal information', 'val':Party['cac:PartyLegalEntity/cbc:CompanyLegalForm']};
        en['BG-4'].val['BT-34'] = {'name':'Seller electronic address', 'val':Party['cbc:EndpointID']};
        // TODO en['BG-4'].val['BT-34-1'] = {'lv':3, 'name':'Seller electronic address identification scheme identifier', 'val':Party['cbc:EndpointID/@schemeID']};
        var PostalAddresses = Party['cac:PostalAddress'];
        if (PostalAddresses) {
          var PostalAddress = PostalAddresses[0];
          en['BG-4'].val['BG-5'] = {'name':'SELLER POSTAL ADDRESS', 'val':[]};
          en['BG-4'].val['BG-5'].val['BT-35'] = {'name':'Seller address 1', 'val':PostalAddress['cbc:StreetName']};
          en['BG-4'].val['BG-5'].val['BT-36'] = {'name':'Seller address line 2', 'val':PostalAddress['cbc:AdditionalStreetName']};
          var AddressLines = PostalAddress['cac:AddressLine'];
          if (AddressLines) {
            var AddressLine = AddressLines[0];
            en['BG-4'].val['BG-5'].val['BT-162'] = {'name':'Seller address line 3', 'val':AddressLine['cbc:Line']};
          }
          en['BG-4'].val['BG-5'].val['BT-37'] = {'name':'Seller city', 'val':PostalAddress['cbc:CityName']};
          en['BG-4'].val['BG-5'].val['BT-38'] = {'name':'Seller post code', 'val':PostalAddress['cbc:PostalZone']};
          en['BG-4'].val['BG-5'].val['BT-39'] = {'name':'Seller country subdivision', 'val':PostalAddress['cbc:CountiySubentity']};
          var Countries = PostalAddress['cac:Country'];
          if (Countries) {
            var Country = Countries[0];
            en['BG-4'].val['BG-5'].val['BT-40'] = {'name':'Seller country code', 'val':Country['cbc:IdentificationCode']};
          }
        }
        var Contacts = Party['cac:Contact'];
        if (Contacts) {
          var Contact = Contacts[0];
          en['BG-4'].val['BG-6'] = {'name':'SELLER CONTACT', 'val':[]};
          en['BG-4'].val['BG-6'].val['BT-41'] = {'name':'Seller contact point', 'val':Contact['cbc:Name']};
          en['BG-4'].val['BG-6'].val['BT-42'] = {'name':'Seller contact telephone number', 'val':Contact['cbc:Telephone']};
          en['BG-4'].val['BG-6'].val['BT-43'] = {'name':'Seller contact email address', 'val':Contact['cbc:ElectronicMail']};
        }
      }
    }
    var AccountingCustomerParties = Invoice['cac:AccountingCustomerParty'];
    if (AccountingCustomerParties) {
      var AccountingCustomerParty = AccountingCustomerParties[0];
      // BUYER
      en['BG-7'] = {'name':'BUYER', 'val':[]};
      var Parties = AccountingCustomerParty['cac:Party'];
      if (Parties) {
        var Party = Parties[0];
        var PartyLegalEntities = Party['cac:PartyLegalEntity'];
        if (PartyLegalEntities) {
          var PartyLegalEntity = PartyLegalEntities[0]
          en['BG-7'].val['BT-44'] = {'name':'Buyer name', 'val':PartyLegalEntity['cbc:RegistrationName']};
        }
        var PartyNames = Party['cac:PartyName'];
        if (PartyNames) {
          var PartyName = PartyNames[0];
          en['BG-7'].val['BT-45'] = {'name':'Buyer trading name', 'val':PartyName['cbc:Name']};
        }
        var PartyIdentifications = Party['cac:PartyIdentification'];
        if (PartyIdentifications) {
          var PartyIdentification = PartyIdentifications[0];
          en['BG-7'].val['BT-46'] = {'name':'Buyer identifier', 'val':PartyIdentification['cbc:ID']};
          // en['BG-7'].val['BT-46-1'] = {'name':'Buyer identifier identification scheme identifier', 'val':Party['cac:PartyIdentification/cbc:ID/@schemelD']};
        }
        var PartyLegalEntities = Party['cac:PartyLegalEntity'];
        if (PartyLegalEntities) {
          var PartyLegalEntity = PartyLegalEntities[0];
          en['BG-7'].val['BT-47'] = {'name':'Buyer legal registration identifier', 'val':PartyLegalEntity['cbc:CompanyID']};
          // en['BG-7'].val['BT-47-1'] = {'name':'Buyer legal registration identifier identification scheme identifier', 'val':Party['cac:PartyLegalEntity/cbc:CompanyID/@schemeID']};
        }
        var PartyTaxSchemes = Party['cac:PartyTaxScheme'];
        if (PartyTaxSchemes) {
          var PartyTaxScheme = PartyTaxSchemes[0];
          en['BG-7'].val['BT-48'] = {'name':'Buyer VAT identifier', 'val':PartyTaxScheme['cbc:CompanylD']};
        }
        en['BG-7'].val['BT-49'] = {'name':'Buyer electronic address', 'val':Party['cbc:EndpointID']};
        // en['BG-7'].val['BT-49-1'] = {'name':'Buyer electronic address identification scheme identifier', 'val':Party['cbc:EndpointID/@schemeID']};
        var PostalAddresses = Party['cac:PostalAddress'];
        if (PostalAddresses) {
          var PostalAddress = PostalAddresses[0];
          en['BG-7'].val['BG-8'] = {'name':'BUYER POSTAL ADDRESS', 'val':[]};
          en['BG-7'].val['BG-8'].val['BT-50'] = {'name':'Buyer address 1', 'val':PostalAddress['cbc:StreetName']};
          en['BG-7'].val['BG-8'].val['BT-51'] = {'name':'Buyer address 2', 'val':PostalAddress['cbc:AdditionalStreetName']};
          var AddressLines = PostalAddress['cac:AddressLine'];
          if (AddressLines) {
            var AddressLine = AddressLines[0];
            en['BG-7'].val['BG-8'].val['BT-163'] = {'name':'Buyer address 3', 'val':AddressLine['cbc:Line']};
          }
          en['BG-7'].val['BG-8'].val['BT-52'] = {'name':'Buyer city', 'val':PostalAddress['cbc:CityName']};
          en['BG-7'].val['BG-8'].val['BT-53'] = {'name':'Buyer post code', 'val':PostalAddress['cbc:PostalZone']};
          en['BG-7'].val['BG-8'].val['BT-54'] = {'name':'Buyer country subdivision', 'val':PostalAddress['cbc:CountrySubentity']};
          var Countries = PostalAddress['cac:Country'];
          if (Countries) {
            Country = Countries[0];
            en['BG-7'].val['BG-8'].val['BT-55'] = {'name':'Buyer country code', 'val':Country['cbc:IdentificationCode']};
          }
        }
        var Contacts = Party['cac:Contact'];
        if (Contacts) {
          var Contact = Contacts[0];
          en['BG-7'].val['BG-9'] = {'name':'BUYER CONTACT', 'val':[]};
          en['BG-7'].val['BG-9'].val['BT-56'] = {'name':'Buyer contact point', 'val':Contact['cbc:Name']};
          en['BG-7'].val['BG-9'].val['BT-57'] = {'name':'Buyer contact telephone number', 'val':Contact['cbc:Telephone']};
          en['BG-7'].val['BG-9'].val['BT-58'] = {'name':'Buyer contact email address', 'val':Contact['cbc:ElectronicMail']};
        }
      }
    }
    var PayeeParties = Invoice['cac:PayeeParty'];
    if (PayeeParties) {
      var PayeeParty = PayeeParties[0];
      // PAYEE
      en['BG-10'] = {'name':'PAYEE', 'val':[]};
      var PartyNames = PayeeParty['cac:PartyName'];
      if (PartyNames) {
        var PartyName = PartyNames[0];
        en['BT-59'] = {'name':'Payee name', 'val':PartyName['cbc:Name']};
      }
      var PartyIdentifications = PayeeParty['cac:PartyIdentification'];
      if (PartyIdentifications) {
        var PartyIdentification = PartyIdentifications[0];
        en['BT-60'] = {'name':'Payee identifier', 'val':PartyIdentification['cbc:ID']};
        // en['BT-60-1'] = {'name':'Payee identifier identification scheme identifier', 'val':PartyIdentification['cbc:ID/@schemeID']};
      }
      var PartyLegalEntities = PayeeParty['cac:PartyLegalEntity'];
      if (PartyLegalEntities) {
        var PartyLegalEntity = PartyLegalEntities[0];
        en['BT-61'] = {'name':'Payee legal registration identifier', 'val':PartyLegalEntity['cbc:CompanylD']};
        // en['BT-61-1'] = {'name':'Payee legal registration identifier identification scheme identifier', 'val':PartyLegalEntity['cbc:CompanyID/@schemeID']};
      }
    }
    var TaxRepresentativeParties = Invoice['cac:TaxRepresentativeParty'];
    if (TaxRepresentativeParties) {
      var TaxRepresentativeParty = TaxRepresentativeParties[0];
      // SELLER TAX REPRESENTATIVE PARTY
      en['BG-11'] = {'name':'SELLER TAX REPRESENTATIVE PARTY', 'val':[]};
      var PartyNames = TaxRepresentativeParty['cac:PartyName'];
      if (PartyNames) {
        var PartyName = PartyNames[0];
        en['BG-11'].val['BT-62'] = {'name':'Seller tax representative name', 'val':PartyName['cbc:Name']};
      }
      var PartyTaxSchemes = TaxRepresentativeParty['cac:PartyTaxScheme'];
      if (PartyTaxSchemes) {
        var PartyTaxScheme = PartyTaxSchemes[0];
        en['BG-11'].val['BT-63'] = {'name':'Seller tax representative VAT identifier', 'val':PartyTaxScheme['cbc:CompanyID']};
      }
      var PostalAddresses = TaxRepresentativeParty['cac:PostalAddress'];
      if (PostalAddresses) {
        var PostalAddress = PostalAddresses[0];
        en['BG-11'].val['BG-12'] = {'name':'SELLER TAX REPRESENTATIVE POSTAL ADDRESS', 'val':[]};
        en['BG-11'].val['BG-12'].val['BT-64'] = {'name':'Tax representative address line 1', 'val':PostalAddress['cbc:StreetName']};
        en['BG-11'].val['BG-12'].val['BT-65'] = {'name':'Tax representative address line 2', 'val':PostalAddress['cbc:AdditionalStreetName']};
        var AddressLines = PostalAddress['cac:AddressLine'];
        if (AddressLines) {
          var AddressLine = AddressLines[0];
          en['BG-11'].val['BG-12'].val['BT-164'] = {'name':'Tax representative address line 3', 'val':AddressLine['cbc:Line']};
        }
        en['BG-11'].val['BG-12'].val['BT-66'] = {'name':'Tax representative city', 'val':PostalAddress['cbc:CityName']};
        en['BG-11'].val['BG-12'].val['BT-67'] = {'name':'Tax representative post code', 'val':PostalAddress['cbc:PostalZone']};
        en['BG-11'].val['BG-12'].val['BT-68'] = {'name':'Tax representative country subdivision', 'val':PostalAddress['cbc:CountrySubentity']};
        var Countries = PostalAddress['cac:Country'];
        if (Countries) {
          var Country = Countries[0];
          en['BG-11'].val['BG-12'].val['BT-69'] = {'name':'Tax representative country code', 'val':Country['cbc:IdentificationCode']};
        }
      }
    }
    // DELIVERY INFORMATION
    en['BG-13'] = {'name':'DELIVERY INFORMATION', 'val':[]};
    var Deliveries = Invoice['cac:Delivery'];
    if (Deliveries) {
      var Delivery = Deliveries[0];
      var DeliveryParties = Delivery['cac:DeliveryParty'];
      if (DeliveryParties) {
        DeliveryParty = DeliveryParties[0];
        var PartyNames = DeliveryParty['cac:PartyName'];
        if (PartyNames) {
          var PartyName = PartyNames[0];
          en['BG-13'].val['BT-70'] = {'name':'Deliver to party name', 'val':PartyName['cbc:Name']};
        }
      }
      en['BG-13'].val['BT-72'] = {'name':'Actual delivery date', 'val':Delivery['cbc:ActualDeliveryDate']};
      var DeliveryLocations = Delivery['cac:DeliveryLocation'];
      if (DeliveryLocations) {
        var DeliveryLocation = DeliveryLocations[0];
        en['BG-13'].val['BT-71'] = {'name':'Deliver to location identifier', 'val':DeliveryLocation['cbc:ID']};
        // en['BT-71-1'] = {Address[''name':'Deliver to location identifier identification scheme identifier', 'val':DeliveryLocation['cbc:ID/@schemeID']};
        var Addresses = DeliveryLocation['cac:Address'];
        if (Addresses) {
          var Address = Addresses[0];
          en['BG-13'].val['BG-15'] = {'name':'DELIVER TO ADDRESS', 'val':[]};
          en['BG-13'].val['BG-15'].val['BT-75'] = {'name':'Deliver to address line 1',
            'val':Address['cbc:StreetName']};
          en['BG-13'].val['BG-15'].val['BT-76'] = {'name':'Deliver to address line 2',
            'val':Address['cbc:AdditionalStreetName']};
          en['BG-13'].val['BG-15'].val['BT-165'] = {'name':'Deliver to address line 3',
            'val':Address['cac:AddressLine/cbc:Line']};
          en['BG-13'].val['BG-15'].val['BT-77'] = {'name':'Deliver to city',
            'val':Address['cbc:CityName']};
          en['BG-13'].val['BG-15'].val['BT-78'] = {'name':'Deliver to postcode',
            'val':Address['cbc:PostalZone']};
          en['BG-13'].val['BG-15'].val['BT-79'] = {'name':'Deliver to country subdivision',
            'val':Address['cbc:CountrySubentity']};
          var Counties = Address['cac:Countiy'];
          if (Counties) {
            var County = Counties[0];
            en['BG-13'].val['BG-15'].val['BT-80'] = {'name':'Deliver to country code', 'val':Countiy['cbc:IdentificationCode']};
          }
        }
      }
    }
    var InvoicePeriods = Invoice['cac:InvoicePeriod'];
    if (InvoicePeriods) {
      var InvoicePeriod = InvoicePeriods[0];
      en['BG-13'].val['BG-14'] = {'name':'DELIVERY OR INVOICE PERIOD', 'val':[]};
      en['BG-13'].val['BG-14'].val['BT-73'] = {'name':'Invoicing period start date',
        'val':Invoice['cac:InvoicePeriod/cbc:StartDate']};
      en['BG-13'].val['BG-14'].val['BT-74'] = {'name':'Invoicing period end date',
        'val':Invoice['cac:InvoicePeriod/cbc:EndDate']};
    }
    var PaymentMeanses = Invoice['cac:PaymentMeans'];
    if (PaymentMeanses) {
      var PaymentMeans = PaymentMeanses[0];
      // PAYMENT INSTRUCTIONS
      en['BG-16'] = {'name':'PAYMENT INSTRUCTIONS', 'val':[]};
      en['BG-16'].val['BT-81'] = {'name':'Payment means type code', 'val':PaymentMeans['cbc:PaymentMeansCode']};
      var PaymentMeansCodes = PaymentMeans['cbc:PaymentMeansCode'];
      if (PaymentMeansCodes) {
        var PaymentMeansCode = PaymentMeansCodes[0];
        en['BG-16'].val['BT-82'] = {'name':'Payment means text', 'val':PaymentMeansCode['@name']};
      }
      en['BG-16'].val['BT-83'] = {'name':'Remittance information', 'val':PaymentMeans['cbc:PaymentID']};
      var PayeeFinancialAccounts = PaymentMeans['cac:PayeeFinancialAccount'];
      if (PayeeFinancialAccounts) {
        // BG-17 CREDIT TRANSFER (Multiple)
        en['BG-16'].val['BG-17'] = {'name':'CREDIT TRANSFER', 'val':[]};
        for (var PayeeFinancialAccount of PayeeFinancialAccounts || []){
          var BG_17 = {};
          BG_17['BT-84'] = {'name':'Payment account identifier', 'val':PayeeFinancialAccount['cbc:ID']};
          BG_17['BT-85'] = {'name':'Payment account name', 'val':PayeeFinancialAccount['cbc:Name']};
          var FinancialInstitutionBranches = PayeeFinancialAccount['cac:FinancialInstitutionBranch'];
          if (FinancialInstitutionBranches) {
            var FinancialInstitutionBranch = FinancialInstitutionBranches[0];
            BG_17['BT-86'] = {'name':'Payment service provider identifier',
              'val':FinancialInstitutionBranch['cbc:ID']};
          }
          en['BG-16'].val['BG-17'].val.push(BG_17);
        }
      }
      var CardAccounts = PaymentMeans['cac:CardAccount'];
      if (CardAccounts) {
        var CardAccount = CardAccounts[0];
        en['BG-16'].val['BG-18'] = {'name':'PAYMENT CARD INFORMATION', 'val':[]};
        en['BG-16'].val['BG-18'].val['BT-87'] = {'name':'Payment card primary account number',
          'val':CardAccount['cbc:PrimaryAccountNumberID']};
        en['BG-16'].val['BG-18'].val['BT-88'] = {'name':'Payment card holder name', 'val':CardAccount['cbc:HolderName']};
      }
      var PaymentMandates = PaymentMeans['cac:PaymentMandate'];
      if (PaymentMandates) {
        var PaymentMandate = PaymentMandates[0];
        en['BG-16'].val['BG-19'] = {'name':'DIRECT DEBIT', 'val':[]};
        en['BG-16'].val['BG-19'].val['BT-89'] = {'name':'Mandate reference identifier', 'val':PaymentMandate['cbc:ID']};
        var PayerFinancialAccounts = PaymentMandate['cac:PayerFinancialAccount'];
        if (PayerFinancialAccounts) {
          PayerFinancialAccount = PayerFinancialAccounts[0];
          en['BG-16'].val['BG-19'].val['BT-91'] = {'name':'Debited account identifier', 'val':PayerFinancialAccount['cbc:ID']};
        }
        if (AccountingSupplierParties) {
          var AccountingSupplierParty = AccountingSupplierParties[0];
          var parties = AccountingSupplierParty['cac:Party'];
          if (parties) {
            var party = parties[0];
            var PartyIdentifications = Party['cac:PartyIdentification'];
            if (PartyIdentifications) {
              var PartyIdentification = PartyIdentifications[0];
              en['BG-16'].val['BG-19'].val['BT-90'] = {'name':'Bank assigned creditor identifier',
                'val':PartyIdentification['cbc:ID']};
            }
          }
        }
        if (PayeeParties) {
          var PayeeParty = PayeeParties[0];
          var PartyIdentifications = PayeeParty['cac:PartyIdentification'];
          if (PartyIdentifications) {
            var PartyIdentification = PartyIdentifications[0];
            en['BG-16'].val['BG-19'].val['BT-90'] = {'name':'Bank assigned creditor identifier', 'val':PartyIdentification['cbc:ID']};
          }
        }
      }
    }
    // BG-20 DOCUMENT LEVEL ALLOWANCES (Multiple)
    en['BG-20'] = {'name':'DOCUMENT LEVEL ALLOWANCES', 'val':[]};
    // BG-21 DOCUMENT LEVEL CHARGES (Multiple)
    en['BG-21'] = {'name':'DOCUMENT LEVEL CHARGES', 'val':[]};
    var AllowanceCharges = Invoice['cac:AllowanceCharge'];
    if (AllowanceCharges) {
      for (var AllowanceCharge of AllowanceCharges || []){
        var TaxCategories = AllowanceCharge['cac:TaxCategory'];
        var BG_20 = {};
        BG_20['BT-92'] = {'name':'Document level allowance amount',
          'val':AllowanceCharge['cbc:Amount']};
        BG_20['BT-93'] = {'name':'Document level allowance base amount',
          'val':AllowanceCharge['cbc:BaseAmount']};
        BG_20['BT-94'] = {'name':'Document level allowance percentage',
          'val':AllowanceCharge['cbc:MuItiplierFactorNumeric']};
        if (TaxCategories) {
          var TaxCategory = TaxCategories[0];
          BG_20['BT-95'] = {'name':'Document level allowance VAT category code', 'val':TaxCategory['cbc:ID']};
          BG_20['BT-96'] = {'name':'Document level allowance VAT rate', 'val':TaxCategory['cbc:Percent']};
        }
        BG_20['BT-97'] = {'name':'Document level allowance reason',
          'val':AllowanceCharge['cbc:AllowanceChargeReason']};
        BG_20['BT-98'] = {'name':'Document level allowance reason code',
          'val':AllowanceCharge['cbc:AllowanceChargeReasonCode']};
        en['BG-20'].val.push(BG_20);
        var BG_21 = {};
        BG_21['BT-99'] = {'name':'Document level charge amount',
          'val':AllowanceCharge['cbc:Amount']};
        BG_21['BT-100'] = {'name':'Document level charge base amount',
          'val':Invoice['cac:AIlowanceCharge/cbc:BaseAmount']};
        BG_21['BT-101'] = {'name':'Document level charge percentage',
          'val':AllowanceCharge['cbc:MultiplierFactorNumeric']};
        if (TaxCategories) {
          var TaxCategory = TaxCategories[0];
          BG_21['BT-102'] = {'name':'Document level charge VAT category code', 'val':TaxCategory['cbc:ID']};
          BG_21['BT-103'] = {'name':'Document level charge VAT rate', 'val':TaxCategory['cbc:Percent']};
        }
        BG_21['BT-104'] = {'name':'Document level charge reason',
          'val':AllowanceCharge['cbc:AllowanceChargeReason']};
        BG_21['BT-105'] = {'name':'Document level charge reason code',
          'val':AllowanceCharge['cbc:AllowanceChargeReasonCode']};
        en['BG-21'].val.push(BG_21);
      }
    }
    var LegalMonetaryTotals = Invoice['cac:LegalMonetaryTotal'];
    if (LegalMonetaryTotals) {
      var LegalMonetaryTotal = LegalMonetaryTotals[0];
      // DOCUMENT TOTALS
      en['BG-22'] = {'name':'DOCUMENT TOTALS', 'val':[]};
      en['BG-22'].val['BT-106'] = {'name':'Sum of Invoice line net amount',
        'val':LegalMonetaryTotal['cbc:LineExtensionAmount']};
      en['BG-22'].val['BT-107'] = {'name':'Sum of allowances on document level',
        'val':LegalMonetaryTotal['cbc:AllowanceTotalAmount']};
      en['BG-22'].val['BT-108'] = {'name':'Sum charges document level',
        'val':LegalMonetaryTotal['cbc:ChargeTotalAmount']};
      en['BG-22'].val['BT-109'] = {'name':'Invoice total amount without VAT',
        'val':LegalMonetaryTotal['cbc:TaxExclusiveAmount']};
      en['BG-22'].val['BT-110'] = {'name':'Invoice total VAT amount',
        'val':Invoice['cac:TaxTotal/cbc:TaxAmount']};
      en['BG-22'].val['BT-112'] = {'name':'Invoice total amount with VAT',
        'val':LegalMonetaryTotal['cbc:TaxInclusiveAmount']};
      en['BG-22'].val['BT-113'] = {'name':'Paid amount',
        'val':LegalMonetaryTotal['cbc:PrepaidAmount']};
      en['BG-22'].val['BT-114'] = {'name':'Rounding amount',
        'val':LegalMonetaryTotal['cbc:PayableRoundingAmount']};
      en['BG-22'].val['BT-115'] = {'name':'Amount due for payment',
        'val':LegalMonetaryTotal['cbc:PayableAmount']};
      var TaxTotals = Invoice['cac:TaxTotal'];
      if (TaxTotals) {
        var TaxTotal = TaxTotals[0];
        en['BG-22'].val['BT-111'] = {'name':'Invoice total VAT amount in accounting currency', 'val':TaxTotal['cbc:TaxAmount']};
      }
    }
    var TaxTotals = Invoice['cac:TaxTotal'];
    if (TaxTotals) {
      var TaxTotal = TaxTotals[0];
      var TaxSubtotals = TaxTotal['cac:TaxSubtotal'];
      // BG-23 VAT BREAKDOWN (Multiple)
      en['BG-23'] = {'name':'VAT BREAKDOWN', 'val':[]};
      for (var TaxSubtotal of TaxSubtotals || []){
        var BG_23 = {};
        BG_23['BT-116'] = {'name':'VAT category taxable amount', 'val':TaxSubtotal['cbc:TaxableAmount']};
        BG_23['BT-117'] = {'name':'VAT category tax amount', 'val':TaxSubtotal['cbc:TaxAmount']};
        var TaxCategories = TaxSubtotal['cac:TaxCategory'];
        if (TaxCategories) {
          var TaxCategory = TaxCategories[0];
          BG_23['BT-118'] = {'name':'VAT category code', 'val':TaxCategory['cbc:ID']};
          BG_23['BT-119'] = {'name':'VAT category rate', 'val':TaxCategory['cbc:Percent']};
          BG_23['BT-120'] = {'name':'VAT exemption reason text', 'val':TaxCategory['cbc:TaxExemptionReason']};
          BG_23['BT-121'] = {'name':'VAT exemption reason code', 'val':TaxCategory['cbc:TaxExemptionReasonCode']};
        }
        en['BG-23'].val.push(BG_23);
      }
    }
    var AdditionalDocumentReferences = Invoice['cac:AdditionalDocumentReference'];
    // BG-24 ADDITIONAL SUPPORTING DOCUMENTS (Multiple)
    en['BG-24'] = {'name':'ADDITIONAL SUPPORTING DOCUMENTS', 'val':[]};
    if (AdditionalDocumentReferences) {
      for (var AdditionalDocumentReference of AdditionalDocumentReferences || []){
        var BG_24 = {};
        BG_24['BT-122'] = {'name':'Supporting document reference',
          'val':AdditionalDocumentReference['cbc:ID']};
        BG_24['BT-123'] = {'name':'Supporting document description',
          'val':AdditionalDocumentReference['cbc:DocumentDescription']};
        var Attachments = AdditionalDocumentReference['cac:Attachment'];
        if (Attachments) {
          var Attachment = Attachments[0];
          var ExternalReferences = Attachment['cac:ExternalReference'];
          if (ExternalReferences) {
            var ExternalReference = ExternalReferences[0];
            BG_24['BT-124'] = {'name':'External document location', 'val':ExternalReference['cbc:URI']};
          }
          BG_24['BT-125'] = {'name':'Attached document', 'val':Attachment['cbc:EmbeddedDocumentBinaryObject']};
          var EmbeddedDocumentBinaryObjects = Attachment['cbc:EmbeddedDocumentBinaryObject'];
          if (EmbeddedDocumentBinaryObjects) {
            var EmbeddedDocumentBinaryObject = EmbeddedDocumentBinaryObjects[0];
            BG_24['BT-125-1'] = {'name':'Attached document Mime code', 'val':EmbeddedDocumentBinaryObject['@mimeCode']};
            BG_24['BT-125-2'] = {'name':'Attached document Filename', 'val':EmbeddedDocumentBinaryObject['@filename']};
          }
        }
        en['BG-24'].val.push(BG_24);
      }
    }
    var InvoiceLines = Invoice['cac:InvoiceLine'];
    // INVOICE LINE (Multiple)
    en['BG-25'] = {'name':'INVOICE LINE', 'val':[]};
    if (InvoiceLines) {
      for (var InvoiceLine of InvoiceLines || []){
        var BG_25 = {};
        BG_25['BT-126'] = {'name':'Invoice line identifier',
          'val':InvoiceLine['cbc:ID']};
        BG_25['BT-127'] = {'name':'Invoice line note',
          'val':InvoiceLine['cbc:Note']};
        BG_25['BT-128'] = {'name':'Invoice object identifier',
          'val':InvoiceLine['cac:DocumentReference/cbc:ID']};
        // BG_25['BT-128-1'] = {'lv':3, 'name':'Invoice line object identifier identification scheme identifier', 'val':InvoiceLine['cac:DocumentReference/cbc:ID/@schemeID']};
        BG_25['BT-129'] = {'name':'Invoiced quantity',
          'val':InvoiceLine['cbc:InvoicedQuantity']};
        BG_25['BT-130'] = {'name':'Invoiced quantity unit of measure',
          'val':InvoiceLine['cbc:InvoicedQuantity/@unitCode']};
        BG_25['BT-131'] = {'name':'Invoice line net amount',
          'val':InvoiceLine['cbc:LineExtensionAmount']};
        BG_25['BT-132'] = {'name':'Referenced purchase order line reference',
          'val':InvoiceLine['cac:OrderLineReference/cbc:LineID']};
        BG_25['BT-133'] = {'name':'Invoice line Buyer accounting reference',
          'val':InvoiceLine['cbc:AccountingCost']};
        var InvoicePeriods = InvoiceLine['cac:InvoicePeriod'];
        if (InvoicePeriods) {
          var InvoicePeriod = InvoicePeriods[0];
          // INVOICE LINE PERIOD
          BG_25['BG-26'] = {'name':'INVOICE LINE PERIOD', 'val':[]};
          BG_25['BG-26'].val['BT-134'] = {'name':'Invoice line period start date',
            'val':InvoicePeriod['cbc:StartDate']};
          BG_25['BG-26'].val['BT-135'] = {'name':'Invoice period date',
            'val':InvoicePeriod['cbc:EndDate']};
        }
        var AllowanceCharges = InvoiceLine['cac:AllowanceCharge'];
        if (AllowanceCharges) {
          // BG-27 INVOICE LINE ALLOWANCES (Multiple)
          BG_25['BG-27'] = {'name':'INVOICE LINE ALLOWANCES', 'val':[]};
          // BG-28 INVOICE LINE CHARGES (Multiple)
          BG_25['BG-28'] = {'name':'INVOICE LINE CHARGES', 'val':[]};
          for (var AllowanceCharge of AllowanceCharges || []){
            var BG_27 = {};
            BG_27['BT-136'] = {'name':'Invoice line allowance amount',
              'val':AllowanceCharge['cbc:Amount']};
            BG_27['BT-137'] = {'name':'Invoice line allowance base amount',
              'val':AllowanceCharge['cbc:BaseAmount']};
            BG_27['BT-138'] = {'name':'Invoice line allowance percentage',
              'val':AllowanceCharge['cbc:MultiplierFactorNumeric']};
            BG_27['BT-139'] = {'name':'Invoice line allowance reason',
              'val':AllowanceCharge['cbc:AllowanceChargeReason']};
            BG_27['BT-140'] = {'name':'Invoice line allowance reason code',
              'val':AllowanceCharge['cbc:AllowanceChargeReasonCode']};
            BG_25['BG-27'].val.push(BG_27);
            var BG_28 = {};
            BG_28['BT-141'] = {'name':'Invoice charge amount',
              'val':AllowanceCharge['cbc:Amount']};
            BG_28['BT-142'] = {'name':'Invoice line charge base amount',
              'val':AllowanceCharge['cbc:BaseAmount']};
            BG_28['BT-143'] = {'name':'Invoice line charge percentage',
              'val':AllowanceCharge['cbc:MultiplierFactorNumeric']};
            BG_28['BT-144'] = {'name':'Invoice charge reason',
              'val':AllowanceCharge['cbc:AlIowanceChargeReason']};
            BG_28['BT-145'] = {'name':'Invoice line charge reason code',
              'val':AllowanceCharge['cbc:AllowanceChargeReasonCode']};
            BG_25['BG-28'].val.push(BG_28);
          }
        }
        var Prices = InvoiceLine['cac:Price'];
        if (Prices) {
          var Price = Prices[0];
          // PRICE DETAILS
          BG_25['BG-29'] = {'name':'PRICE DETAILS', 'val':[]};
          BG_25['BG-29'].val['BT-146'] = {'name':'Item price',
            'val':Price['cbc:PriceAmount']};
          var AllowanceCharges = Price['cac:AllowanceCharge'];
          if (AllowanceCharges) {
            var AllowanceCharge = AllowanceCharges[0];
            BG_25['BG-29'].val['BT-147'] = {'name':'Item price discount',
              'val':AllowanceCharge['cbc:Amount']};
            BG_25['BG-29'].val['BT-148'] = {'name':'Item gross price',
              'val':AllowanceCharge['cbc:BaseAmount']};
          }
          BG_25['BG-29'].val['BT-149'] = {'name':'Item price base quantity',
            'val':Price['cbc:BaseQuantity']};
          var BaseQuantities = Price['cbc:BaseQuantity'];
          if (BaseQuantities) {
            var BaseQuantity = BaseQuantities[0];
            BG_25['BG-29'].val['BT-150'] = {'name':'Item price base quantity unit of measure code',
              'val':BaseQuantity['@unitCode']};
          }
        }
        var Items = InvoiceLine['cac:Item'];
        if (Items) {
          var Item = Items[0];
          var ClassifiedTaxCategories = Item['cac:ClassifiedTaxCategory'];
          if (ClassifiedTaxCategories) {
            var ClassifiedTaxCategory = ClassifiedTaxCategories[0];
            // LINE VAT INFORMATION
            BG_25['BG-30'] = {'name':'LINE VAT INFORMATION', 'val':[]};
            BG_25['BG-30'].val['BT-151'] = {'name':'Invoiced item VAT category code',
              'val':ClassifiedTaxCategory['cbc:ID']};
            BG_25['BG-30'].val['BT-152'] = {'name':'Invoiced item VAT rate',
              'val':ClassifiedTaxCategory['cbc:Percent']};
          }
          // ITEM INFORMATION
          BG_25['BG-31'] = {'name':'ITEM INFORMATION', 'val':[]};
          BG_25['BG-31'].val['BT-153'] = {'name':'Item name',
            'val':Item['cbc:Name']};
          BG_25['BG-31'].val['BT-154'] = {'name':'Item description',
            'val':Item['cbc:Description']};
          var SeIlersItemIdentifications = Item['cac:SeIlersItemIdentification'];
          if (SeIlersItemIdentifications) {
            var SeIlersItemIdentification = SeIlersItemIdentifications[0];
            BG_25['BG-31'].val['BT-155'] = {'name':'Item Seller\'s identifier',
              'val':SeIlersItemIdentification['cbc:ID']};
          }
          var BuyersItemIdentifications = Item['cac:BuyersItemIdentification'];
          if (BuyersItemIdentifications) {
            var BuyersItemIdentification = BuyersItemIdentifications[0];
            BG_25['BG-31'].val['BT-156'] = {'name':'Item Buyer\'s identifier',
              'val':BuyersItemIdentification['cbc:ID']};
          }
          var StandardItemIdentifications = Item['cac:StandardItemIdentification'];
          if (StandardItemIdentifications) {
            var StandardItemIdentification = StandardItemIdentifications[0];
            BG_25['BG-31'].val['BT-157'] = {'name':'Item standard identifier',
              'val':StandardItemIdentification['cbc:ID']};
          // BG_25['BG-31'].val['BT-157-1'] = {'lv':4, 'name':'Item standard identifier identification scheme identifier', 'val':Item['cac:StandardItemIdentification/cbc:ID/@schemeID']};
          }
          var CommodityClassifications = Item['cac:CommodityClassification'];
          if (CommodityClassifications) {
            var CommodityClassification = CommodityClassifications[0];
            // BT-158 (Multiple)
            var CommodityClassifications = Item['cac:CommodityClassification'];
            BG_25['BG-31'].val['BT-158'] = {'name':'Item classification identifier', 'val':[]};
            for (var CommodityClassification of CommodityClassifications || []){
              BG_25['BG-31'].val['BT-158'].val.push(CommodityClassification['cbc:ItemClassificationCode']);
            // BG_25['BG-31'].val['BT-158-1'] = {'lv':4, 'name':'Item classification identifier identification scheme identifier', 'val':Item['cac:CommodityClassification/cbc:ItemClassificationCode/@listID']};
            // BG_25['BG-31'].val['BT-158-2'] = {'lv':4, 'name':'Scheme version identifer', 'val':Item['cac:CommodityClassification/cbc:ItemClassificationCode/@listVersionID']};
          }
          }
          var OriginCountries = Item['cac:OriginCountry'];
          if (OriginCountries) {
            var OriginCountry = OriginCountries[0];
            BG_25['BG-31'].val['BT-159'] = {'name':'Item country of origin',
              'val':OriginCountry['cbc:IdentificationCode']};
          }
          var AdditionalItemProperties = Item['cac:AdditionalItemProperty'];
          if (AdditionalItemProperties) {
            // BG-32 ITEM ATTRIBUTES (Multiple)
            BG_25['BG-31'].val['BG-32'] = {'name':'ITEM ATTRIBUTES', 'val':[]};
            for (var AdditionalItemProperty of AdditionalItemProperties || []){
              var BG_32 = {};
              BG_32['BT-160'] = {'lv':4, 'name':'Item attribute name', 'val':AdditionalItemProperty['cbc:Name']};
              BG_32['BT-161'] = {'lv':4, 'name':'Item attribute value', 'val':AdditionalItemProperty['cbc:Value']};
              BG_25['BG-31'].val['BG-32'].val.push(BG_32);
            }
          }
        }
        en['BG-25'].val.push(BG_25);
      }
    }
    return en;
  }

  function en2xbrl(en) {
    // EN is defined in EN_16931-1.js
    var xbrli = 'http://www.xbrl.org/2003/instance';
    var xbrldi = 'http://xbrl.org/2006/xbrldi';
    var eipa = 'http://www.eipa.jp';
    var cen = eipa+'/cen/EN-16931-1';
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
      'xmlns:cen="'+cen+'">'+
      '<xbrll:schemaRef xlink:type="simple" xlink:href="../cen/EN-16931-1.xsd" xlink:arcrole="http://www.w3.org/1999/xlink/properties/linkbase"/>'+
      '<xbrli:unit id="eur">'+
        '<xbrli:measure>iso4217:EUR</xbrli:measure>'+
      '</xbrli:unit>'+
      '<xbrli:unit id="pure">'+
        '<xbrli:measure>xbrli:pure</xbrli:measure>'+
      '</xbrli:unit>'+
    '</xbrli:xbrl>';
    function appendtypedLN(L, ID, scenario) {
      var typedMember = xmlDoc.createElementNS(xbrldi,'typedMember'),
          number = xmlDoc.createElementNS(cen, L+'N'),
          text = xmlDoc.createTextNode(ID);
      scenario.appendChild(typedMember);
      typedMember.setAttribute('dimension', 'cen:d'+L+'N');
      typedMember.appendChild(number);
      number.appendChild(text);
    }
    function createContext(xmlDoc, IDs, date) {
      var _IDs = IDs.join('_');
      if (contexts[_IDs]) { return null; }
      contexts[_IDs] = true;
      var context = xmlDoc.createElementNS(xbrli,'context');
      var entity = xmlDoc.createElementNS(xbrli,'entity');
      var identifier = xmlDoc.createElementNS(xbrli,'identifier');
      var identifierText = xmlDoc.createTextNode('SAMPLE');
      var scenario = xmlDoc.createElementNS(xbrli,'scenario');
      // var segment = xmlDoc.createElementNS(xbrli,'segment');
      var period = xmlDoc.createElementNS(xbrli,'period');
      var instant = xmlDoc.createElementNS(xbrli,'instant');
      // var forever = xmlDoc.createElementNS(xbrli,'forever');
      var instantText = xmlDoc.createTextNode(date);
      xbrl.appendChild(context);
      context.setAttribute('id', _IDs);
      // entity
      context.appendChild(entity);
      entity.appendChild(identifier);
      identifier.setAttribute('scheme', eg);
      identifier.appendChild(identifierText);
      // period
      context.appendChild(period);
      period.appendChild(instant);
      // period.appendChild(forever);
      instant.appendChild(instantText);
      // scenario
      context.appendChild(scenario);
      // entity.appendChild(segment);
      switch(IDs.length) {
        case 1:
          appendtypedLN('L1', IDs[0], scenario);
          break;
        case 2:
          appendtypedLN('L1', IDs[0], scenario);
          appendtypedLN('L2', IDs[1], scenario);
          break;
        case 3:
          appendtypedLN('L1', IDs[0], scenario);
          appendtypedLN('L2', IDs[1], scenario);
          appendtypedLN('L3', IDs[2], scenario);
          break;
        case 4:
          appendtypedLN('L1', IDs[0], scenario);
          appendtypedLN('L2', IDs[1], scenario);
          appendtypedLN('L3', IDs[2], scenario);
          appendtypedLN('L4', IDs[3], scenario);
          break;
      }

      return context;
    }
    function createItem(xmlDoc, keys, item) {
      // console.log(level, keys, item);
      var contextText;
      if ('BG-0' === keys[0]) {
        contextText = keys[0];
      }
      else {
        contextText = keys[0]+(keys[1] 
          ? '_'+keys[1] 
          : '');
      }
      var length = keys.length;
      var name = keys[length - 1];
      var type = '';
      if (EN[name]) {
        type = EN[name].type;
      }
      else {
        console.log('Not defined EN['+name+']');
      }
      var val = item.val;
      var element = xmlDoc.createElementNS(cen, name);
      var match;
      switch(val.length) {
      case 1:
        var val = ''+item.val[0];
        if ('Date' === type) {
          match = val.match(/^([0-9]{4})([0-9]{2})([0-9]{2})$/);
          if (match) {
            val = match[1]+'-'+match[2]+'-'+match[3];
          }
        }
        var text = xmlDoc.createTextNode(val);
        element.appendChild(text);
        element.setAttribute('contextRef', contextText);
        xbrl.appendChild(element);
        break;
      case 2:
        var val = ''+item.val[1];
        if ('Date' === type) {
          match = val.match(/^([0-9]{4})([0-9]{2})([0-9]{2})$/);
          if (match) {
            val = match[1]+'-'+match[2]+'-'+match[3];
          }
        }
        var text = xmlDoc.createTextNode(val);
        element.appendChild(text);
        element.setAttribute('contextRef', contextText);
        xbrl.appendChild(element);
        break;
      }
      if (['Amount', 'Quantity', 'Percentage'].indexOf(type) >= 0) {
        element.setAttribute('decimals', 'INF');
        if ('Amount' == type) {
          element.setAttribute('unitRef', 'eur');
        }
        else if ('Percentage' == type) {
          element.setAttribute('unitRef', 'pure');
        }
        else {
          element.setAttribute('unitRef', 'pure');
        }
      }
    }
    // ---------------------------------------------------------------
    // START
    var contexts = {};
    var DOMP = new DOMParser();
    var xmlDoc = DOMP.parseFromString(xmlString, 'text/xml');
    var xbrl = xmlDoc.getElementsByTagNameNS(xbrli, 'xbrl')[0];
    var InvoiceCurrency, VAT_AccountingCurrency;
    var L1keys = Object.keys(en);
    // console.log('L1keys', L1keys);
    for (var L1key of L1keys || []){
      var L1item = en[L1key];
      var L1itemkeys = L1item.val ? Object.keys(L1item.val) : null;
      if (L1itemkeys && L1itemkeys.length > 0) {
        // console.log('1) key:'+L1key, 'item:', L1item);
        if (L1key.match(/^BT/)) {
          createContext(xmlDoc, ['BG-0'], date);
          createItem(xmlDoc, ['BG-0', L1key], L1item);
          if ('BT-5' === L1key) {
            InvoiceCurrency = L1item.val[0];
          }
          else if ('BT-6' === L1key) {
            VAT_AccountingCurrency = L1item.val[0];
          }
        }
        else if (L1key.match(/^BG/)) {
          var L2val = L1item.val;
          // console.log('L2val:', L2val);
          for (var L2key in L2val || []){
            var L2item = L2val[L2key];
            if (L2key.match(/^[0-9]+$/)) {
              var L3keys = Object.keys(L2item);
              // console.log('L3keys', L3keys);
              for (var L3key of L3keys || []){
                var L3item = L2item[L3key];
                if (L3item.val && L3item.val.length > 0) {
                  // console.log('2) key:'+L1key+' '+L2key+' '+L3key, 'item:', L3item);
                  createContext(xmlDoc, [L1key, L2key], date);
                  createItem(xmlDoc, [L1key, L2key, L3key], L3item);
                }
              }
            }
            else if (L2key.match(/^BT/)) {
              if (L2item && L2item.length > 0) {
                // console.log('3) key:'+L1key+' '+L2key, 'item:', L2item);
                createContext(xmlDoc, [L1key], date);
                createItem(xmlDoc, [L1key, L2key], L2item);
              }
            }
            else if (L2key.match(/^BG/)) {
              var L3val = L2item.val;
              // console.log('L3val:', L3val);
              for (var L3key in L3val || []){
                var L3item = L3val[L3key];
                // console.log('4) key:'+L1key+' '+L2key+' '+L3key, 'item:', L3item);
                if (L3item.val && L3item.val.length > 0) {
                  if (L3key.match(/^[0-9]+$/)) {
                    createContext(xmlDoc, [L1key, L2key], date);
                    createItem(xmlDoc, [L1key, L2key, L3key], L3item);
                  }
                  else if (L3key.match(/^BT/)) {
                    createContext(xmlDoc, [L1key, L2key], date);
                    createItem(xmlDoc, [L1key, L2key, L3key], L3item);
                  }
                  else if (L3key.match(/^BG/)) {
                    createContext(xmlDoc, [L1key, L2key], date);
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
      if (res.match(/^<html>/)) {
        alert(res.match(/<title>(.*)<\/title>/)[1]);
        return null;
      }
      try {
        var json = JSON.parse(res), en;
        if (url.match(/\/cii\//)) {
          en = cii2en(json);
        }
        else if (url.match(/\/ubl\//)) {
          en = ubl2en(json);
        }
        // console.log(en);
        return en;
      }
      catch(e) { console.log(e); }
    })
    .then(function(en) {
      console.log(en);
      var xbrl = en2xbrl(en);
      return xbrl;
    })
    .then(function(xbrl) {
      console.log(xbrl);
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
        'data': xbrl
      };
      return ajaxRequest('data/save.cgi', data, 'POST', 20000)
      .then(function(res) {
        console.log(res);
      })
      .catch(function(err) { console.log(err); })
      // console.log(xbrl);
      return 
    })
    .catch(function(err) { console.log(err); })
  }

  return {
    'initModule' : initModule,
    'cii2en': cii2en,
    'ubl2en': ubl2en,
    'en2xbrl': en2xbrl
  };
})();
// invoice2xbrl.js