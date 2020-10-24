/**
 * cii2en.js
 *
 * Convert UN/CEFACT CII xml file to eipa-cen XBRL
 * called from cii2x.html
 * 
 * This is a free to use open source software and licensed under the MIT License
 * CC-SA-BY Copyright (c) 2020, Sambuichi Professional Engineers Office
 **/
var eipa_ubl = (function() {

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
    en['BG-1'] = {'name':'INVOICE NOTE', 'val':[]};
    en['BG-1'].val['BT-21'] = {'name':'Invoice note subject code', 'val':Invoice['cbc:Note']};
    en['BG-1'].val['BT-22'] = {'name':'Invoice note', 'val':Invoice['cbc:Note']};
    en['BG-2'] = {'name':'PROCESS CONTROL', 'val':[]};
    en['BG-2'].val['BT-23'] = {'name':'Business process type', 'val':Invoice['cbcProfilelD']};
    en['BG-2'].val['BT-24'] = {'name':'Specification identifier', 'val':Invoice['cbc:CustomizationID']};
    var BillingReferences = Invoice['cac:BillingReference'];
    if (BillingReferences) {
      var BillingReference = BillingReferences[0];
      en['BG-3'] = {'name':'PRECEDING INVOICE REFERENCE', 'val':BillingReference['cac:InvoiceDocumentReference']};
      var InvoiceDocumentReferences = BillingReference['cac:InvoiceDocumentReference'];
      if (InvoiceDocumentReferences) {
        var InvoiceDocumentReference = InvoiceDocumentReferences[0];
        en['BG-3'].val['BT-25'] = {'name':'Preceding Invoice number', 'val':InvoiceDocumentReference['cbc:ID']};
        en['BG-3'].val['BT-26'] = {'name':'Preceding Invoice issue date', 'val':InvoiceDocumentReference['cbc:IssueDate']};
      }
    }
    var AccountingSupplierParties = Invoice['cac:AccountingSupplierParty'];
    if (AccountingSupplierParties) {
      var AccountingSupplierParty = AccountingSupplierParties[0];
      en['BG-4'] = {'name':'SELLER', 'val':[]};
      var Parties = AccountingSupplierParty['cac:Party'];
      if (Parties) {
        var Party = Parties[0];
        en['BG-4'].val['BT-27'] = {'name':'Seller name', 'val':Party['cac:PartyLegalEntity/cbc:RegistrationName']};
        en['BG-4'].val['BT-28'] = {'name':'Seller trading name', 'val':Party['cac:PartyName/cbc:Name']};
        en['BG-4'].val['BT-29'] = {'name':'Seller identifier', 'val':Party['cac:PartyIdentification/cbc:ID']};
        // en['BG-4'].val['BT-29-1'] = {'lv':3, 'name':'Seller identifier identification scheme identifier', 'val':Party['cac:PartyIdentification/cbc:ID/@schemelD']};
        en['BG-4'].val['BT-30'] = {'name':'Seller legal registration identifier', 'val':Party['cac:PartyLegalEntity/cbc:CompanyID']};
        // en['BG-4'].val['BT-30-1'] = {'lv':3, 'name':'Seller legal registration identifier identification scheme identifier', 'val':Party['cac:PartyLegalEntity/cbc:CompanyID/@schemeID']};
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
        var contacts = Party['cac:Contact'];
        if (contacts) {
          var contact = contacts[0];
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
    var Deliveries = Invoice['cac:Delivery'];
    if (Deliveries) {
      var Delivery = Deliveries[0];
      en['BG-13'] = {'name':'DELIVERY INFORMATION', 'val':[]};
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
          var Addresse = Addresses[0];
          en['BG-13'].val['BG-15'] = {'name':'DELIVER TO ADDRESS', 'val':[]};
          en['BG-13'].val['BG-15'].val['BT-75'] = {'name':'Deliver to address line 1', 'val':Address['cbc:StreetName']};
          en['BG-13'].val['BG-15'].val['BT-76'] = {'name':'Deliver to address line 2', 'val':Address['cbc:AdditionalStreetName']};
          en['BG-13'].val['BG-15'].val['BT-165'] = {'name':'Deliver to address line 3', 'val':Address['cac:AddressLine/cbc:Line']};
          en['BG-13'].val['BG-15'].val['BT-77'] = {'name':'Deliver to city', 'val':Address['cbc:CityName']};
          en['BG-13'].val['BG-15'].val['BT-78'] = {'name':'Deliver to postcode', 'val':Address['cbc:PostalZone']};
          en['BG-13'].val['BG-15'].val['BT-79'] = {'name':'Deliver to country subdivision', 'val':Address['cbc:CountrySubentity']};
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
      en['BG-13'].val['BG-14'].val['BT-73'] = {'name':'Invoicing period start date', 'val':Invoice['cac:InvoicePeriod/cbc:StartDate']};
      en['BG-13'].val['BG-14'].val['BT-74'] = {'name':'Invoicing period end date', 'val':Invoice['cac:InvoicePeriod/cbc:EndDate']};
    }
    var PaymentMeanses = Invoice['cac:PaymentMeans'];
    if (PaymentMeanses) {
      var PaymentMeans = PaymentMeanses[0];
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
        var PayeeFinancialAccount = PayeeFinancialAccounts[0];
        en['BG-16'].val['BG-17'] = {'name':'CREDIT TRANSFER', 'val':[]};
        en['BG-16'].val['BG-17'].val['BT-84'] = {'name':'Payment account identifier', 'val':PayeeFinancialAccount['cbc:ID']};
        en['BG-16'].val['BG-17'].val['BT-85'] = {'name':'Payment account name', 'val':PayeeFinancialAccount['cbc:Name']};
        var FinancialInstitutionBranches = PayeeFinancialAccount['cac:FinancialInstitutionBranch'];
        if (FinancialInstitutionBranches) {
          var FinancialInstitutionBranch = FinancialInstitutionBranches[0];
          en['BG-16'].val['BG-17'].val['BT-86'] = {'name':'Payment service provider identifier',
            'val':FinancialInstitutionBranch['cbc:ID']};
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

    en['BG-20'] = {'name':'DOCUMENT LEVEL ALLOWANCES', 'val':[]};
    en['BG-21'] = {'name':'DOCUMENT LEVEL CHARGES', 'val':[]};
    var AllowanceCharges = Invoice['cac:AllowanceCharge'];
    if (AllowanceCharges) {
      for (var AllowanceCharge of AllowanceCharges) {
        var TaxCategories = AllowanceCharge['cac:TaxCategory'];
        var BG_20 = {};
        BG_20['BT-92'] = {'name':'Document level allowance amount', 'val':AllowanceCharge['cbc:Amount']};
        BG_20['BT-93'] = {'name':'Document level allowance base amount', 'val':AllowanceCharge['cbc:BaseAmount']};
        BG_20['BT-94'] = {'name':'Document level allowance percentage', 'val':AllowanceCharge['cbc:MuItiplierFactorNumeric']};
        if (TaxCategories) {
          var TaxCategory = TaxCategories[0];
          BG_20['BT-95'] = {'name':'Document level allowance VAT category code', 'val':TaxCategory['cbc:ID']};
          BG_20['BT-96'] = {'name':'Document level allowance VAT rate', 'val':TaxCategory['cbc:Percent']};
        }
        BG_20['BT-97'] = {'name':'Document level allowance reason', 'val':AllowanceCharge['cbc:AllowanceChargeReason']};
        BG_20['BT-98'] = {'name':'Document level allowance reason code', 'val':AllowanceCharge['cbc:AllowanceChargeReasonCode']};
        en['BG-20'].val.push(BG_20);
        var BG_21 = {};
        BG_21['BT-99'] = {'name':'Document level charge amount', 'val':AllowanceCharge['cbc:Amount']};
        BG_21['BT-100'] = {'name':'Document level charge base amount', 'val':Invoice['cac:AIlowanceCharge/cbc:BaseAmount']};
        BG_21['BT-101'] = {'name':'Document level charge percentage', 'val':AllowanceCharge['cbc:MultiplierFactorNumeric']};
        if (TaxCategories) {
          var TaxCategory = TaxCategories[0];
          BG_21['BT-102'] = {'name':'Document level charge VAT category code', 'val':TaxCategory['cbc:ID']};
          BG_21['BT-103'] = {'name':'Document level charge VAT rate', 'val':TaxCategory['cbc:Percent']};
        }
        BG_21['BT-104'] = {'name':'Document level charge reason', 'val':AllowanceCharge['cbc:AllowanceChargeReason']};
        BG_21['BT-105'] = {'name':'Document level charge reason code', 'val':AllowanceCharge['cbc:AllowanceChargeReasonCode']};
        en['BG-21'].val.push(BG_21);
      }
    }
    var LegalMonetaryTotals = Invoice['cac:LegalMonetaryTotal'];
    if (LegalMonetaryTotals) {
      var LegalMonetaryTotal = LegalMonetaryTotals[0];
      en['BG-22'] = {'name':'DOCUMENT TOTALS', 'val':[]};
      en['BG-22'].val['BT-106'] = {'name':'Sum of Invoice line net amount', 'val':LegalMonetaryTotal['cbc:LineExtensionAmount']};
      en['BG-22'].val['BT-107'] = {'name':'Sum of allowances on document level', 'val':LegalMonetaryTotal['cbc:AllowanceTotalAmount']};
      en['BG-22'].val['BT-108'] = {'name':'Sum charges document level', 'val':LegalMonetaryTotal['cbc:ChargeTotalAmount']};
      en['BG-22'].val['BT-109'] = {'name':'Invoice total amount without VAT', 'val':LegalMonetaryTotal['cbc:TaxExclusiveAmount']};
      en['BG-22'].val['BT-110'] = {'name':'Invoice total VAT amount', 'val':Invoice['cac:TaxTotal/cbc:TaxAmount']};
      en['BG-22'].val['BT-112'] = {'name':'Invoice total amount with VAT', 'val':LegalMonetaryTotal['cbc:TaxInclusiveAmount']};
      en['BG-22'].val['BT-113'] = {'name':'Paid amount', 'val':LegalMonetaryTotal['cbc:PrepaidAmount']};
      en['BG-22'].val['BT-114'] = {'name':'Rounding amount', 'val':LegalMonetaryTotal['cbc:PayableRoundingAmount']};
      en['BG-22'].val['BT-115'] = {'name':'Amount due for payment', 'val':LegalMonetaryTotal['cbc:PayableAmount']};
      var TaxTotals = Invoice['cac:TaxTotal'];
      if (TaxTotals) {
        var TaxTotal = TaxTotals[0];
        en['BG-22'].val['BT-111'] = {'name':'Invoice total VAT amount in accounting currency', 'val':TaxTotal['cbc:TaxAmount']};
      }
    }
    var TaxTotals = Invoice['cac:TaxTotal'];
    if (TaxTotals) {
      en['BG-23'] = {'name':'VAT BREAKDOWN', 'val':[]};
      var TaxTotal = TaxTotals[0];
      var TaxSubtotals = TaxTotal['cac:TaxSubtotal'];
      for (var TaxSubtotal of TaxSubtotals) {
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
    en['BG-24'] = {'name':'ADDITIONAL SUPPORTING DOCUMENTS', 'val':[]};
    if (AdditionalDocumentReferences) {
      for (var AdditionalDocumentReference of AdditionalDocumentReferences) {
        var BG_24 = {};
        BG_24['BT-122'] = {'name':'Supporting document reference', 'val':AdditionalDocumentReference['cbc:ID']};
        BG_24['BT-123'] = {'name':'Supporting document description', 'val':AdditionalDocumentReference['cbc:DocumentDescription']};
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
    en['BG-25'] = {'name':'INVOICE LINE', 'val':[]};

    if (InvoiceLines) {
      for (var InvoiceLine of InvoiceLines) {
        var BG_25 = {};
        BG_25['BT-126'] = {'name':'Invoice line identifier', 'val':InvoiceLine['cbc:ID']};
        BG_25['BT-127'] = {'name':'Invoice line note', 'val':InvoiceLine['cbc:Note']};
        BG_25['BT-128'] = {'name':'Invoice object identifier', 'val':InvoiceLine['cac:DocumentReference/cbc:ID']};
        // BG_25['BT-128-1'] = {'lv':3, 'name':'Invoice line object identifier identification scheme identifier', 'val':InvoiceLine['cac:DocumentReference/cbc:ID/@schemeID']};
        BG_25['BT-129'] = {'name':'Invoiced quantity', 'val':InvoiceLine['cbc:InvoicedQuantity']};
        BG_25['BT-130'] = {'name':'Invoiced quantity unit of measure', 'val':InvoiceLine['cbc:InvoicedQuantity/@unitCode']};
        BG_25['BT-131'] = {'name':'Invoice line net amount', 'val':InvoiceLine['cbc:LineExtensionAmount']};
        BG_25['BT-132'] = {'name':'Referenced purchase order line reference', 'val':InvoiceLine['cac:OrderLineReference/cbc:LineID']};
        BG_25['BT-133'] = {'name':'Invoice line Buyer accounting reference', 'val':InvoiceLine['cbc:AccountingCost']};

        var InvoicePeriods = InvoiceLine['cac:InvoicePeriod'];
        if (InvoicePeriods) {
          var InvoicePeriod = InvoicePeriods[0];
          BG_25['BG-26'] = {'name':'INVOICE LINE PERIOD', 'val':[]};
          BG_25['BG-26'].val['BT-134'] = {'name':'Invoice line period start date', 'val':InvoicePeriod['cbc:StartDate']};
          BG_25['BG-26'].val['BT-135'] = {'name':'Invoice period date', 'val':InvoicePeriod['cbc:EndDate']};
        }
        var AllowanceCharges = InvoiceLine['cac:AllowanceCharge'];
        if (AllowanceCharges) {
          var AllowanceCharge = AllowanceCharges[0];
          BG_25['BG-27'] = {'name':'INVOICE LINE ALLOWANCES', 'val':[]};
          BG_25['BG-27'].val['BT-136'] = {'name':'Invoice line allowance amount', 'val':AllowanceCharge['cbc:Amount']};
          BG_25['BG-27'].val['BT-137'] = {'name':'Invoice line allowance base amount', 'val':AllowanceCharge['cbc:BaseAmount']};
          BG_25['BG-27'].val['BT-138'] = {'name':'Invoice line allowance percentage', 'val':AllowanceCharge['cbc:MultiplierFactorNumeric']};
          BG_25['BG-27'].val['BT-139'] = {'name':'Invoice line allowance reason', 'val':AllowanceCharge['cbc:AllowanceChargeReason']};
          BG_25['BG-27'].val['BT-140'] = {'name':'Invoice line allowance reason code', 'val':AllowanceCharge['cbc:AllowanceChargeReasonCode']};
          // 
          BG_25['BG-28'] = {'name':'INVOICE LINE CHARGES', 'val':[]};
          BG_25['BG-28'].val['BT-141'] = {'name':'Invoice charge amount', 'val':AllowanceCharge['cbc:Amount']};
          BG_25['BG-28'].val['BT-142'] = {'name':'Invoice line charge base amount', 'val':AllowanceCharge['cbc:BaseAmount']};
          BG_25['BG-28'].val['BT-143'] = {'name':'Invoice line charge percentage', 'val':AllowanceCharge['cbc:MultiplierFactorNumeric']};
          BG_25['BG-28'].val['BT-144'] = {'name':'Invoice charge reason', 'val':AllowanceCharge['cbc:AlIowanceChargeReason']};
          BG_25['BG-28'].val['BT-145'] = {'name':'Invoice line charge reason code', 'val':AllowanceCharge['cbc:AllowanceChargeReasonCode']};
        }
        var Prices = InvoiceLine['cac:Price'];
        if (Prices) {
          var Price = Prices[0];
          BG_25['BG-29'] = {'name':'PRICE DETAILS', 'val':[]};
          BG_25['BG-29'].val['BT-146'] = {'name':'Item price', 'val':Price['cbc:PriceAmount']};
          var AllowanceCharges = Price['cac:AllowanceCharge'];
          if (AllowanceCharges) {
            var AllowanceCharge = AllowanceCharges[0];
            BG_25['BG-29'].val['BT-147'] = {'name':'Item price discount', 'val':AllowanceCharge['cbc:Amount']};
            BG_25['BG-29'].val['BT-148'] = {'name':'Item gross price', 'val':AllowanceCharge['cbc:BaseAmount']};
          }
          BG_25['BG-29'].val['BT-149'] = {'name':'Item price base quantity', 'val':Price['cbc:BaseQuantity']};
          var BaseQuantities = Price['cbc:BaseQuantity'];
          if (BaseQuantities) {
            var BaseQuantity = BaseQuantities[0];
            BG_25['BG-29'].val['BT-150'] = {'name':'Item price base quantity unit of measure code', 'val':BaseQuantity['@unitCode']};
          }
        }
        var Items = InvoiceLine['cac:Item'];
        if (Items) {
          var Item = Items[0];
          var ClassifiedTaxCategories = Item['cac:ClassifiedTaxCategory'];
          if (ClassifiedTaxCategories) {
            var ClassifiedTaxCategory = ClassifiedTaxCategories[0];
            BG_25['BG-30'] = {'name':'LINE VAT INFORMATION', 'val':[]};
            BG_25['BG-30'].val['BT-151'] = {'name':'Invoiced item VAT category code', 'val':ClassifiedTaxCategory['cbc:ID']};
            BG_25['BG-30'].val['BT-152'] = {'name':'Invoiced item VAT rate', 'val':ClassifiedTaxCategory['cbc:Percent']};
          }
          BG_25['BG-31'] = {'name':'ITEM INFORMATION', 'val':[]};
          BG_25['BG-31'].val['BT-153'] = {'name':'Item name', 'val':Item['cbc:Name']};
          BG_25['BG-31'].val['BT-154'] = {'name':'Item description', 'val':Item['cbc:Description']};
          var SeIlersItemIdentifications = Item['cac:SeIlersItemIdentification'];
          if (SeIlersItemIdentifications) {
            var SeIlersItemIdentification = SeIlersItemIdentifications[0];
            BG_25['BG-31'].val['BT-155'] = {'name':'Item Seller\'s identifier', 'val':SeIlersItemIdentification['cbc:ID']};
          }
          var BuyersItemIdentifications = Item['cac:BuyersItemIdentification'];
          if (BuyersItemIdentifications) {
            var BuyersItemIdentification = BuyersItemIdentifications[0];
            BG_25['BG-31'].val['BT-156'] = {'name':'Item Buyer\'s identifier', 'val':BuyersItemIdentification['cbc:ID']};
          }
          var StandardItemIdentifications = Item['cac:StandardItemIdentification'];
          if (StandardItemIdentifications) {
            var StandardItemIdentification = StandardItemIdentifications[0];
            BG_25['BG-31'].val['BT-157'] = {'name':'Item standard identifier', 'val':StandardItemIdentification['cbc:ID']};
          // BG_25['BG-31'].val['BT-157-1'] = {'lv':4, 'name':'Item standard identifier identification scheme identifier', 'val':Item['cac:StandardItemIdentification/cbc:ID/@schemeID']};
          }
          var CommodityClassifications = Item['cac:CommodityClassification'];
          if (CommodityClassifications) {
            var CommodityClassification = CommodityClassifications[0];
            BG_25['BG-31'].val['BT-158'] = {'name':'Item classification identifier', 'val':Item['cac:CommodityClassification/cbaltemClassificationCode']};
            // BG_25['BG-31'].val['BT-158-1'] = {'lv':4, 'name':'Item classification identifier identification scheme identifier', 'val':Item['cac:CommodityClassification/cbc:ItemClassificationCode/@listID']};
            // BG_25['BG-31'].val['BT-158-2'] = {'lv':4, 'name':'Scheme version identifer', 'val':Item['cac:CommodityClassification/cbc:ItemClassificationCode/@listVersionID']};
          }
          var OriginCountries = Item['cac:OriginCountry'];
          if (OriginCountries) {
            var OriginCountry = OriginCountries[0];
            BG_25['BG-31'].val['BT-159'] = {'name':'Item country of origin', 'val':OriginCountry['cbc:IdentificationCode']};
          }
          var AdditionalItemProperties = Item['cac:AdditionalItemProperty'];
          if (AdditionalItemProperties) {
            BG_25['BG-31'].val['BG-32'] = {'name':'ITEM ATTRIBUTES', 'val':[]};
            for (var AdditionalItemProperty of AdditionalItemProperties) {
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
      'xmlns:eg="'+eg+'">'+
      '<xbrll:schemaRef xlink:type="simple" xlink:href="../cen/eipa-cen-2020-12-31.xsd" xlink:arcrole="http://www.w3.org/1999/xlink/properties/linkbase"/>'+
      // <xbrll:schemaRef xlink:type="simple" xlink:href="../plt/case-c-b-m-u-e-t/eipa-plt-all-2020-12-31_5.xsd" xlink:arcrole="http://www.w3.org/1999/xlink/properties/linkbase"/>'+
      // '<xbrli:context id="now">'+
      //   '<xbrli:entity>'+
      //     '<xbrli:identifier scheme="'+eipa+'">EIPA</xbrli:identifier>'+
      //   '</xbrli:entity>'+
      //   '<xbrli:period>'+
      //     '<xbrli:instant>'+date+'</xbrli:instant>'+
      //   '</xbrli:period>'+
      // '</xbrli:context>'+
      '<xbrli:unit id="eur">'+
        '<xbrli:measure>iso4217:EUR</xbrli:measure>'+
      '</xbrli:unit>'+
      '<xbrli:unit id="NotUsed">'+
        '<xbrli:measure>pure</xbrli:measure>'+
      '</xbrli:unit>'+
    '</xbrli:xbrl>';
    function appendtypedLNumber(L, ID, scenario) {
      var typedMember = xmlDoc.createElementNS(xbrldi,'typedMember'),
          number = xmlDoc.createElementNS(eipa_cen, L+'Number'),
          text = xmlDoc.createTextNode(ID);
      scenario.appendChild(typedMember);
      typedMember.setAttribute('dimension', 'eipa-cen:d'+L+'Number');
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
      instant.appendChild(instantText);
      // scenario
      context.appendChild(scenario);
      // entity.appendChild(segment);
      switch(IDs.length) {
        case 1:
          appendtypedLNumber('L1', IDs[0], scenario);
          break;
        case 2:
          appendtypedLNumber('L1', IDs[0], scenario);
          appendtypedLNumber('L2', IDs[1], scenario);
          break;
        case 3:
          appendtypedLNumber('L1', IDs[0], scenario);
          appendtypedLNumber('L2', IDs[1], scenario);
          appendtypedLNumber('L3', IDs[2], scenario);
          break;
        case 4:
          appendtypedLNumber('L1', IDs[0], scenario);
          appendtypedLNumber('L2', IDs[1], scenario);
          appendtypedLNumber('L3', IDs[2], scenario);
          appendtypedLNumber('L4', IDs[3], scenario);
          break;
      }

      return context;
    }
    function createItem(xmlDoc, keys, item) {
      /**
      <gl-cor:enteredDate contextRef='H50'>2005-07-01</gl-cor:enteredDate>
        */
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
      var type = EN[name].type;
      var val = item.val;
      var element = xmlDoc.createElementNS(eipa_cen, name);
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
        // var key = Object.keys(item.val[0])[0];
        // var val0 = item.val[0][key];
        // if (val0) {
        //   key = key.replace('@', '');
        //   element.setAttribute(key, val0);
        // }
        // console.log(name, type);
        break;
      }
      if (['Amount', 'Quantity', 'Percentage'].indexOf(type) >= 0) {
        element.setAttribute('decimals', 'INF');
        if ('Amount' == type) {
          // InvoiceCurrency, VAT_AccountingCurrency;
          element.setAttribute('unitRef', 'eur');
        }
        else {
          element.setAttribute('unitRef', 'NotUsed');
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
    for (var L1key of L1keys) {
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
          for (var L2key in L2val) {
            var L2item = L2val[L2key];
            if (L2key.match(/^[0-9]+$/)) {
              var L3keys = Object.keys(L2item);
              // console.log('L3keys', L3keys);
              for (var L3key of L3keys) {
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
              for (var L3key in L3val) {
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
        var json = JSON.parse(res);
        var en = ubl2en(json);
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
    'ubl2en': ubl2en,
    'en2xbrl': en2xbrl
  };
})();
