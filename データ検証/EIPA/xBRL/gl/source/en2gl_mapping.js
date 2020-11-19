/**
 * en2gl_mapping.js
 *
 * This is a free to use open source software and licensed under the MIT License
 * CC-SA-BY Copyright (c) 2020, Sambuichi Professional Engineers Office
 **/
var en2glMapping = (function() {
    /**
    ([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)
    "$1":{"general":"$2","level":"$3","name":"$4","path":"$5","ID":"$6","term":"$7","Card":"$8"},
    code general level name path ID term Card
    1    2       3     4    5    6  7    8
    */
var gl_plt = {
    "corG-1":{"general":"","level":"1","name":"accountingEntries","path":"/corG-1","ID":"","term":"","Card":""},
    "corG-2":{"general":"","level":"2","name":"documentInfo","path":"/corG-1corG-2","ID":"","term":"","Card":""},
    "cor-76":{"general":"","level":"3","name":"documentNumber","path":"/corG-1/corG-2/cor-76","ID":"BT-1","term":"Invoice number","Card":"1..1"},
    "cor-79":{"general":"","level":"3","name":"documentDate","path":"/corG-1/corG-2/cor-79","ID":"BT-2","term":"Invoice issue date","Card":"1..1"},
    "cor-73":{"general":"","level":"3","name":"documentType","path":"/corG-1/corG-2/cor-73","ID":"BT-3","term":"Invoice type code","Card":"1..1"},
    "cenG-16":{"general":"","level":"3","name":"paymentInstructions","path":"/corG-1/corG-2/cenG-16","ID":"BG-16","term":"PAYMENT INSTRUCTIONS","Card":"0..1"},
    "cen-82":{"general":"","level":"4","name":"paymentMeansText","path":"/corG-1/corG-2/cenG-16/cen-82","ID":"BT-82","term":"Payment means text","Card":"0..1"},
    "cen-83":{"general":"","level":"4","name":"remittanceInformation","path":"/corG-1/corG-2/cenG-16/cen-83","ID":"BT-83","term":"Remittance information","Card":"0..1"},
    "cenG-17":{"general":"","level":"4","name":"creditTransfer","path":"/corG-1/corG-2/cenG-16/cenG-17","ID":"BG-17","term":"CREDIT TRANSFER","Card":"0..n"},
    "cen-84":{"general":"","level":"5","name":"paymentAccountIdentifier","path":"/corG-1/corG-2/cenG-16/cenG-17/cen-84","ID":"BT-84","term":"Payment account identifier","Card":"1..1"},
    "cen-85":{"general":"","level":"5","name":"paymentAccountName","path":"/corG-1/corG-2/cenG-16/cenG-17/cen-85","ID":"BT-85","term":"Payment account name","Card":"0..1"},
    "cen-86":{"general":"","level":"5","name":"paymentServiceProviderIdentifier","path":"/corG-1/corG-2/cenG-16/cenG-17/cen-86","ID":"BT-86","term":"Payment service provider identifier","Card":"0..1"},
    "cenG-18":{"general":"","level":"4","name":"paymentCardInformation","path":"/corG-1/corG-2/cenG-16/cenG-18","ID":"BG-18","term":"PAYMENT CARD INFORMATION","Card":"0..1"},
    "cen-87":{"general":"","level":"5","name":"paymentCardPrimaryAccountNumber","path":"/corG-1/corG-2/cenG-16/cenG-18/cen-87","ID":"BT-87","term":"Payment card primary account number","Card":"1..1"},
    "cen-88":{"general":"","level":"5","name":"paymentCardHolderName","path":"/corG-1/corG-2/cenG-16/cenG-18/cen-88","ID":"BT-88","term":"Payment card holder name","Card":"0..1"},
    "cenG-19":{"general":"","level":"4","name":"directDebit","path":"/corG-1/corG-2/cenG-16/cenG-19","ID":"BG-19","term":"DIRECT DEBIT","Card":"0..1"},
    "cen-89":{"general":"","level":"5","name":"mandateReferenceIdentifier","path":"/corG-1/corG-2/cenG-16/cenG-19/cen-89","ID":"BT-89","term":"Mandate reference identifier","Card":"0..1"},
    "cen-90":{"general":"","level":"5","name":"bankAssignedCreditorIdentifier","path":"/corG-1/corG-2/cenG-16/cenG-19/cen-90","ID":"BT-90","term":"Bank assigned creditor identifier","Card":"0..1"},
    "cen-91":{"general":"","level":"5","name":"debitedAccountIdentifier","path":"/corG-1/corG-2/cenG-16/cenG-19/cen-91","ID":"BT-91","term":"Debited account identifier","Card":"0..1"},
    "tafG-1":{"general":"","level":"3","name":"originatingDocumentStructure","path":"/corG-1/corG-2/cenG-3/tafG-1","ID":"BG-3","term":"PRECEDING INVOICE REFERENCE","Card":""},
    "taf-4":{"general":"","level":"4","name":"originatingDocumentType","path":"/corG-1/corG-2/cenG-3/tafG-1/taf-4","ID":"","term":"","Card":""},
    "taf-5":{"general":"","level":"4","name":"originatingDocumentNumber","path":"/corG-1/corG-2/cenG-3/tafG-1/taf-5","ID":"BT-25","term":"Preceding Invoice reference","Card":"1..1"},
    "cen-26":{"general":"taf-6","level":"4","name":"precedingInvoiceIssueDate","path":"/corG-1/corG-2/cenG-3/tafG-1/cen-26","ID":"BT-26","term":"Preceding Invoice issue date","Card":"0..1"},
    "cen-132":{"general":"taf-5","level":"4","name":"referencedPurchaseOrderLineReference","path":"/corG-1/corG-2/cenG-3/tafG-1/cen-132","ID":"BT-132","term":"Referenced purchase order line reference","Card":"0..1"},
    "cen-18":{"general":"","level":"3","name":"invoicedObjectIdentifier","path":"/corG-1/corG-2/cen-18","ID":"BT-18","term":"Invoiced object identifier","Card":"0..1"},
    "cenG-1":{"general":"","level":"3","name":"invoiceNote","path":"/corG-1/corG-2/cenG-1","ID":"BG-1","term":"INVOICE NOTE","Card":"0..n"},
    "cen-21":{"general":"","level":"4","name":"invoiceNoteSubjectCode","path":"/corG-1/corG-2/cenG-1/cen-21","ID":"BT-21","term":"Invoice note subject code","Card":"0..1"},
    "cen-22":{"general":"","level":"4","name":"invoiceNote","path":"/corG-1/corG-2/cenG-1/cen-22","ID":"BT-22","term":"Invoice note","Card":"1..1"},
    "cenG-2":{"general":"","level":"3","name":"processControl","path":"/corG-1/corG-2/cenG-2","ID":"BG-2","term":"PROCESS CONTROL","Card":"1..1"},
    "cen-23":{"general":"","level":"4","name":"businessProcessType","path":"/corG-1/corG-2/cenG-2/cen-23","ID":"BT-23","term":"Business process type","Card":"0..1"},
    "cen-24":{"general":"","level":"4","name":"specificationIdentifier","path":"/corG-1/corG-2/cenG-2/cen-24","ID":"BT-24","term":"Specification identifier","Card":"1..1"},
    "cen-133":{"general":"taf-4","level":"4","name":"invoiceLineBuyerAccountingReference","path":"/corG-1/corG-2/cenG-2/cen-133","ID":"BT-133","term":"Invoice line Buyer accounting reference","Card":"0..1"},
    "cenG-24":{"general":"","level":"3","name":"additionalSupportingDocuments","path":"/corG-1/corG-2/cenG-24","ID":"BG-24","term":"ADDITIONAL SUPPORTING DOCUMENTS","Card":"0..n"},
    "cen-122":{"general":"","level":"4","name":"supportingDocumentReference","path":"/corG-1/corG-2/cenG-24/cen-122","ID":"BT-122","term":"Supporting document reference","Card":"1..1"},
    "cen-123":{"general":"","level":"4","name":"supportingDocumentDescription","path":"/corG-1/corG-2/cenG-24/cen-123","ID":"BT-123","term":"Supporting document description","Card":"0..1"},
    "cen-124":{"general":"","level":"4","name":"externalDocumentLocation","path":"/corG-1/corG-2/cenG-24/cen-124","ID":"BT-124","term":"External document location","Card":"0..1"},
    "cen-125":{"general":"","level":"4","name":"attachedDocument","path":"/corG-1/corG-2/cenG-24/cen-125","ID":"BT-125","term":"Attached document","Card":"0..1"},
    "cen-125A":{"general":"","level":"4","name":"attachedDocumentMimeCode","path":"/corG-1/corG-2/cenG-24/cen-125A","ID":"BT-125A","term":"Attached document Mime code","Card":"1..1"},
    "cen-125B":{"general":"","level":"4","name":"attachedDocumentFilename","path":"/corG-1/corG-2/cenG-24/cen-125B","ID":"BT-125B","term":"Attached document Filename","Card":"1..1"},
    "corG-3":{"general":"","level":"2","name":"entityInformation","path":"/corG-1/corG-3","ID":"","term":"","Card":""},
    "cenG-4":{"general":"corG-9","level":"3","name":"seller","path":"/corG-1/corG-3/cenG-4","ID":"BG-4","term":"SELLER","Card":"1..1"},
    "cen-29":{"general":"cor-44","level":"4","name":"sellerIdentifier","path":"/corG-1/corG-3/cenG-4/cen-29","ID":"BT-29","term":"Seller identifier","Card":"0..n"},
    "cen-30":{"general":"cor-45","level":"4","name":"sellerLegalRegistrationIdentifier","path":"/corG-1/corG-3/cenG-4/cen-30","ID":"BT-30","term":"Seller legal registration identifier","Card":"0..1"},
    "cen-31":{"general":"cor-45","level":"4","name":"sellerVatIdentifier","path":"/corG-1/corG-3/cenG-4/cen-31","ID":"BT-31","term":"Seller VAT identifier","Card":"0..1"},
    "cen-32":{"general":"cor-45","level":"4","name":"sellerTaxRegistrationIdentifier","path":"/corG-1/corG-3/cenG-4/cen-32","ID":"BT-32","term":"Seller tax registration identifier","Card":"0..1"},
    "cen-27":{"general":"cor-50","level":"4","name":"sellerName","path":"/corG-1/corG-3/cenG-4/cen-27","ID":"BT-27","term":"Seller name","Card":"1..1"},
    "cen-28":{"general":"","level":"4","name":"sellerTradingName","path":"/corG-1/corG-3/cenG-4/cen-28","ID":"BT-28","term":"Seller trading name","Card":"0..1"},
    "cen-33":{"general":"","level":"4","name":"sellerAdditionalLegalInformation","path":"/corG-1/corG-3/cenG-4/cen-33","ID":"BT-33","term":"Seller additional legal information","Card":"0..1"},
    "cenG-5":{"general":"busG-20","level":"4","name":"sellerPostalAddress","path":"/corG-1/corG-3/cenG-4/cenG-5","ID":"BG-5","term":"SELLER POSTAL ADDRESS","Card":"1..1"},
    "cen-35":{"general":"bus-124","level":"5","name":"sellerAddressLine1","path":"/corG-1/corG-3/cenG-4/cenG-5/cen-35","ID":"BT-35","term":"Seller address line 1","Card":"0..1"},
    "cen-36":{"general":"bus-125","level":"5","name":"sellerAddressLine2","path":"/corG-1/corG-3/cenG-4/cenG-5/cen-36","ID":"BT-36","term":"Seller address line 2","Card":"0..1"},
    "cen-162":{"general":"cen-162","level":"5","name":"sellerAddressLine3","path":"/corG-1/corG-3/cenG-4/cenG-5/cen-162","ID":"BT-162","term":"Seller address line 3","Card":"0..1"},
    "cen-37":{"general":"bus-126","level":"5","name":"sellerCity","path":"/corG-1/corG-3/cenG-4/cenG-5/cen-37","ID":"BT-37","term":"Seller city","Card":"0..1"},
    "cen-39":{"general":"bus-127","level":"5","name":"sellerCountrySubdivision","path":"/corG-1/corG-3/cenG-4/cenG-5/cen-39","ID":"BT-39","term":"Seller country subdivision","Card":"0..1"},
    "cen-40":{"general":"bus-128","level":"5","name":"sellerCountryCode","path":"/corG-1/corG-3/cenG-4/cenG-5/cen-40","ID":"BT-40","term":"Seller country code","Card":"1..1"},
    "cen-38":{"general":"bus-129","level":"5","name":"sellerPostCode","path":"/corG-1/corG-3/cenG-4/cenG-5/cen-38","ID":"BT-38","term":"Seller post code","Card":"0..1"},
    "cenG-6":{"general":"corG-14","level":"5","name":"sellerContact","path":"/corG-1/corG-3/cenG-4/cenG-5/cenG-6","ID":"BG-6","term":"SELLER CONTACT","Card":"0..1"},
    "cen-41":{"general":"cor-63","level":"6","name":"sellerContactPoint","path":"/corG-1/corG-3/cenG-4/cenG-5/cenG-6/cen-41","ID":"BT-41","term":"Seller contact point","Card":"0..1"},
    "cen-42":{"general":"cor-66","level":"6","name":"sellerContactTelephoneNumber","path":"/corG-1/corG-3/cenG-4/cenG-5/cenG-6/cen-42","ID":"BT-42","term":"Seller contact telephone number","Card":"0..1"},
    "cen-34":{"general":"","level":"6","name":"sellerElectronicAddress","path":"/corG-1/corG-3/cenG-4/cenG-5/cenG-6/cen-34","ID":"BT-34","term":"Seller electronic address","Card":"0..1"},
    "cen-43":{"general":"cor-70","level":"6","name":"sellerContactEmailAddress","path":"/corG-1/corG-3/cenG-4/cenG-5/cenG-6/cen-43","ID":"BT-43","term":"Seller contact email address","Card":"0..1"},
    "cenG-11":{"general":"cor-51","level":"4","name":"sellerTaxRepresentativeParty","path":"/corG-1/corG-3/cenG-4/cenG-11","ID":"BG-11","term":"SELLER TAX REPRESENTATIVE PARTY","Card":"0..1"},
    "cen-63":{"general":"cor-45","level":"4","name":"sellerTaxRepresentativeVatIdentifier","path":"/corG-1/corG-3/cenG-4/cen-63","ID":"BT-63","term":"Seller tax representative VAT identifier","Card":"1..1"},
    "cen-62":{"general":"cor-50","level":"4","name":"sellerTaxRepresentativeName","path":"/corG-1/corG-3/cenG-4/cen-62","ID":"BT-62","term":"Seller tax representative name","Card":"1..1"},
    "cenG-12":{"general":"busG-20","level":"4","name":"sellerTaxRepresentativePostalAddress","path":"/corG-1/corG-3/cenG-4/cenG-12","ID":"BG-12","term":"SELLER TAX REPRESENTATIVE POSTAL ADDRESS","Card":"1..1"},
    "cen-64":{"general":"bus-124","level":"5","name":"taxRepresentativeAddressLine1","path":"/corG-1/corG-3/cenG-4/cenG-12/cen-64","ID":"BT-64","term":"Tax representative address line 1","Card":"0..1"},
    "cen-65":{"general":"bus-125","level":"5","name":"taxRepresentativeAddressLine2","path":"/corG-1/corG-3/cenG-4/cenG-12/cen-65","ID":"BT-65","term":"Tax representative address line 2","Card":"0..1"},
    "cen-164":{"general":"cen-162","level":"5","name":"taxRepresentativeAddressLine3","path":"/corG-1/corG-3/cenG-4/cenG-12/cen-164","ID":"BT-164","term":"Tax representative address line 3","Card":"0..1"},
    "cen-66":{"general":"bus-126","level":"5","name":"taxRepresentativeCity","path":"/corG-1/corG-3/cenG-4/cenG-12/cen-66","ID":"BT-66","term":"Tax representative city","Card":"0..1"},
    "cen-68":{"general":"bus-127","level":"5","name":"taxRepresentativeCountrySubdivision","path":"/corG-1/corG-3/cenG-4/cenG-12/cen-68","ID":"BT-68","term":"Tax representative country subdivision","Card":"0..1"},
    "cen-69":{"general":"bus-128","level":"5","name":"taxRepresentativeCountryCode","path":"/corG-1/corG-3/cenG-4/cenG-12/cen-69","ID":"BT-69","term":"Tax representative country code","Card":"1..1"},
    "cen-67":{"general":"bus-129","level":"5","name":"taxRepresentativePostCode","path":"/corG-1/corG-3/cenG-4/cenG-12/cen-67","ID":"BT-67","term":"Tax representative post code","Card":"0..1"},
    "cenG-7":{"general":"cor-51","level":"4","name":"buyer","path":"/corG-1/corG-3/cenG-4/cenG-7","ID":"BG-7","term":"BUYER","Card":"1..1"},
    "cen-46":{"general":"cor-44","level":"4","name":"buyerIdentifier","path":"/corG-1/corG-3/cenG-4/cen-46","ID":"BT-46","term":"Buyer identifier","Card":"0..1"},
    "cen-47":{"general":"cor-45","level":"4","name":"buyerLegalRegistrationIdentifier","path":"/corG-1/corG-3/cenG-4/cen-47","ID":"BT-47","term":"Buyer legal registration identifier","Card":"0..1"},
    "cen-48":{"general":"cor-45","level":"4","name":"buyerVatIdentifier","path":"/corG-1/corG-3/cenG-4/cen-48","ID":"BT-48","term":"Buyer VAT identifier","Card":"0..1"},
    "cen-47A":{"general":"cor-46","level":"4","name":"schemeIdentifier","path":"/corG-1/corG-3/cenG-4/cen-47A","ID":"BT-47A","term":"Scheme identifier","Card":"0..1"},
    "cen-44":{"general":"cor-50","level":"4","name":"buyerName","path":"/corG-1/corG-3/cenG-4/cen-44","ID":"BT-44","term":"Buyer name","Card":"1..1"},
    "cen-45":{"general":"cen-28","level":"4","name":"buyerTradingName","path":"/corG-1/corG-3/cenG-4/cen-45","ID":"BT-45","term":"Buyer trading name","Card":"0..1"},
    "cenG-8":{"general":"busG-20","level":"4","name":"buyerPostalAddress","path":"/corG-1/corG-3/cenG-4/cenG-8","ID":"BG-8","term":"BUYER POSTAL ADDRESS","Card":"1..1"},
    "cen-50":{"general":"bus-124","level":"5","name":"buyerAddressLine1","path":"/corG-1/corG-3/cenG-4/cenG-8/cen-50","ID":"BT-50","term":"Buyer address line 1","Card":"0..1"},
    "cen-51":{"general":"bus-125","level":"5","name":"buyerAddressLine2","path":"/corG-1/corG-3/cenG-4/cenG-8/cen-51","ID":"BT-51","term":"Buyer address line 2","Card":"0..1"},
    "cen-163":{"general":"cen-162","level":"5","name":"buyerAddressLine3","path":"/corG-1/corG-3/cenG-4/cenG-8/cen-163","ID":"BT-163","term":"Buyer address line 3","Card":"0..1"},
    "cen-52":{"general":"bus-126","level":"5","name":"buyerCity","path":"/corG-1/corG-3/cenG-4/cenG-8/cen-52","ID":"BT-52","term":"Buyer city","Card":"0..1"},
    "cen-54":{"general":"bus-127","level":"5","name":"buyerCountrySubdivision","path":"/corG-1/corG-3/cenG-4/cenG-8/cen-54","ID":"BT-54","term":"Buyer country subdivision","Card":"0..1"},
    "cen-55":{"general":"bus-128","level":"5","name":"buyerCountryCode","path":"/corG-1/corG-3/cenG-4/cenG-8/cen-55","ID":"BT-55","term":"Buyer country code","Card":"1..1"},
    "cen-53":{"general":"bus-129","level":"5","name":"buyerPostCode","path":"/corG-1/corG-3/cenG-4/cenG-8/cen-53","ID":"BT-53","term":"Buyer post code","Card":"0..1"},
    "cenG-9":{"general":"corG-14","level":"5","name":"buyerContact","path":"/corG-1/corG-3/cenG-4/cenG-8/cenG-9","ID":"BG-9","term":"BUYER CONTACT ","Card":"0..1"},
    "cen-56":{"general":"cor-63","level":"6","name":"buyerContactPoint","path":"/corG-1/corG-3/cenG-4/cenG-8/cenG-9/cen-56","ID":"BT-56","term":"Buyer contact point","Card":"0..1"},
    "cen-57":{"general":"cor-66","level":"6","name":"buyerContactTelephoneNumber","path":"/corG-1/corG-3/cenG-4/cenG-8/cenG-9/cen-57","ID":"BT-57","term":"Buyer contact telephone number","Card":"0..1"},
    "cen-49":{"general":"","level":"6","name":"buyerElectronicAddress","path":"/corG-1/corG-3/cenG-4/cenG-8/cenG-9/cen-49","ID":"BT-49","term":"Buyer electronic address","Card":"0..1"},
    "cen-58":{"general":"cor-70","level":"6","name":"buyerContactEmailAddress","path":"/corG-1/corG-3/cenG-4/cenG-8/cenG-9/cen-58","ID":"BT-58","term":"Buyer contact email address","Card":"0..1"},
    "bus-35":{"general":"","level":"6","name":"contactAttentionLine","path":"/corG-1/corG-3/cenG-4/cenG-8/cenG-9/bus-35","ID":"BT-10","term":"Buyer reference","Card":"0..1"},
    "cen-60":{"general":"cor-44","level":"4","name":"payeeIdentifier","path":"/corG-1/corG-3/cenG-4/cen-60","ID":"BT-60","term":"Payee identifier","Card":"0..1"},
    "cen-61":{"general":"cor-45","level":"4","name":"payeeLegalRegistrationIdentifier","path":"/corG-1/corG-3/cenG-4/cen-61","ID":"BT-61","term":"Payee legal registration identifier","Card":"0..1"},
    "cen-61A":{"general":"cor-46","level":"4","name":"schemeIdentifier","path":"/corG-1/corG-3/cenG-4/cen-61A","ID":"BT-61A","term":"Scheme identifier","Card":"0..1"},
    "cen-59":{"general":"cor-50","level":"4","name":"payeeName","path":"/corG-1/corG-3/cenG-4/cen-59","ID":"BT-59","term":"Payee name","Card":"1..1"},
    "cen-70":{"general":"cor-50","level":"4","name":"deliverToPartyName","path":"/corG-1/corG-3/cenG-4/cen-70","ID":"BT-70","term":"Deliver to party name","Card":"0..1"},
    "cenG-15":{"general":"busG-20","level":"4","name":"deliverToAddress","path":"/corG-1/corG-3/cenG-4/cenG-15","ID":"BG-15","term":"DELIVER TO ADDRESS","Card":"0..1"},
    "cen-75":{"general":"bus-124","level":"5","name":"deliverToAddressLine1","path":"/corG-1/corG-3/cenG-4/cenG-15/cen-75","ID":"BT-75","term":"Deliver to address line 1","Card":"0..1"},
    "cen-76":{"general":"bus-125","level":"5","name":"deliverToAddressLine2","path":"/corG-1/corG-3/cenG-4/cenG-15/cen-76","ID":"BT-76","term":"Deliver to address line 2","Card":"0..1"},
    "cen-165":{"general":"cen-162","level":"5","name":"deliverToAddressLine3","path":"/corG-1/corG-3/cenG-4/cenG-15/cen-165","ID":"BT-165","term":"Deliver to address line 3","Card":"0..1"},
    "cen-77":{"general":"bus-126","level":"5","name":"deliverToCity","path":"/corG-1/corG-3/cenG-4/cenG-15/cen-77","ID":"BT-77","term":"Deliver to city","Card":"0..1"},
    "cen-79":{"general":"bus-127","level":"5","name":"deliverToCountrySubdivision","path":"/corG-1/corG-3/cenG-4/cenG-15/cen-79","ID":"BT-79","term":"Deliver to country subdivision","Card":"0..1"},
    "cen-80":{"general":"bus-128","level":"5","name":"deliverToCountryCode","path":"/corG-1/corG-3/cenG-4/cenG-15/cen-80","ID":"BT-80","term":"Deliver to country code","Card":"1..1"},
    "cen-78":{"general":"bus-129","level":"5","name":"deliverToPostCode","path":"/corG-1/corG-3/cenG-4/cenG-15/cen-78","ID":"BT-78","term":"Deliver to post code","Card":"0..1"},
    "cen-71":{"general":"bus-130","level":"5","name":"deliverToLocationIdentifier","path":"/corG-1/corG-3/cenG-4/cenG-15/cen-71","ID":"BT-71","term":"Deliver to location identifier","Card":"0..1"},
    "cenG-6":{"general":"corG-14","level":"5","name":"sellerContact","path":"/corG-1/corG-3/cenG-4/cenG-15/cenG-6","ID":"BG-6","term":"SELLER CONTACT","Card":"0..1"},
    "cen-41":{"general":"cor-63","level":"6","name":"sellerContactPoint","path":"/corG-1/corG-3/cenG-4/cenG-15/cenG-6/cen-41","ID":"BT-41","term":"Seller contact point","Card":"0..1"},
    "cen-42":{"general":"cor-66","level":"6","name":"sellerContactTelephoneNumber","path":"/corG-1/corG-3/cenG-4/cenG-15/cenG-6/cen-42","ID":"BT-42","term":"Seller contact telephone number","Card":"0..1"},
    "cen-34":{"general":"","level":"6","name":"sellerElectronicAddress","path":"/corG-1/corG-3/cenG-4/cenG-15/cenG-6/cen-34","ID":"BT-34","term":"Seller electronic address","Card":"0..1"},
    "cen-43":{"general":"cor-70","level":"6","name":"sellerContactEmailAddress","path":"/corG-1/corG-3/cenG-4/cenG-15/cenG-6/cen-43","ID":"BT-43","term":"Seller contact email address","Card":"0..1"},
    "cenG-9":{"general":"corG-14","level":"5","name":"buyerContact","path":"/corG-1/corG-3/cenG-4/cenG-15/cenG-9","ID":"BG-9","term":"BUYER CONTACT ","Card":"0..1"},
    "cen-56":{"general":"cor-63","level":"6","name":"buyerContactPoint","path":"/corG-1/corG-3/cenG-4/cenG-15/cenG-9/cen-56","ID":"BT-56","term":"Buyer contact point","Card":"0..1"},
    "cen-57":{"general":"cor-66","level":"6","name":"buyerContactTelephoneNumber","path":"/corG-1/corG-3/cenG-4/cenG-15/cenG-9/cen-57","ID":"BT-57","term":"Buyer contact telephone number","Card":"0..1"},
    "cen-49":{"general":"","level":"6","name":"buyerElectronicAddress","path":"/corG-1/corG-3/cenG-4/cenG-15/cenG-9/cen-49","ID":"BT-49","term":"Buyer electronic address","Card":"0..1"},
    "cen-58":{"general":"cor-70","level":"6","name":"buyerContactEmailAddress","path":"/corG-1/corG-3/cenG-4/cenG-15/cenG-9/cen-58","ID":"BT-58","term":"Buyer contact email address","Card":"0..1"},
    "bus-35":{"general":"","level":"6","name":"contactAttentionLine","path":"/corG-1/corG-3/cenG-4/cenG-15/cenG-9/bus-35","ID":"BT-10","term":"Buyer reference","Card":"0..1"},
    "cenG-14":{"general":"","level":"4","name":"invoicingPeriod","path":"/corG-1/corG-3/cenG-4/cenG-14","ID":"BG-14","term":"INVOICING PERIOD","Card":"0..1"},
    "cor-8":{"general":"","level":"5","name":"periodCoveredStart","path":"/corG-1/corG-3/cenG-4/cenG-14/cor-8","ID":"BT-73","term":"Invoicing period start date","Card":"0..1"},
    "cor-9":{"general":"","level":"5","name":"periodCoveredEnd","path":"/corG-1/corG-3/cenG-4/cenG-14/cor-9","ID":"BT-74","term":"Invoicing period end date","Card":"0..1"},
    "corG-4":{"general":"","level":"2","name":"entryHeader","path":"/corG-1/corG-4","ID":"","term":"","Card":""},
    "muc-4":{"general":"","level":"3","name":"amountOriginalCurrency","path":"/corG-1/corG-4/muc-4","ID":"BT-5","term":"Invoice currency code","Card":"1..1"},
    "muc-33":{"general":"","level":"3","name":"taxCurrency","path":"/corG-1/corG-4/muc-33","ID":"BT-6","term":"VAT accounting currency code","Card":"0..1"},
    "cor-43":{"general":"","level":"3","name":"postingDate","path":"/corG-1/corG-4/cor-43","ID":"BT-7","term":"Value added tax point date","Card":"0..1"},
    "cen-8":{"general":"","level":"3","name":"valueAddedTaxPointDateCode","path":"/corG-1/corG-4/cen-8","ID":"BT-8","term":"Value added tax point date code","Card":"0..1"},
    "cor-90":{"general":"","level":"3","name":"maturityDate","path":"/corG-1/corG-4/cor-90","ID":"BT-9","term":"Payment due date","Card":""},
    "cenG-20":{"general":"","level":"3","name":"documentLevelAllowances","path":"/corG-1/corG-4/cenG-20","ID":"BG-20","term":"DOCUMENT LEVEL ALLOWANCES","Card":"0..n"},
    "cen-92":{"general":"cor-40","level":"4","name":"documentLevelAllowanceAmount","path":"/corG-1/corG-4/cenG-20/cen-92","ID":"BT-92","term":"Document level allowance amount","Card":"1..1"},
    "cen-95":{"general":"cor-99","level":"4","name":"documentLevelAllowanceVatCategoryCode","path":"/corG-1/corG-4/cenG-20/cen-95","ID":"BT-95","term":"Document level allowance VAT category code","Card":"1..1"},
    "cen-96":{"general":"cor-98","level":"4","name":"documentLevelAllowanceVatRate","path":"/corG-1/corG-4/cenG-20/cen-96","ID":"BT-96","term":"Document level allowance VAT rate","Card":"0..1"},
    "cen-93":{"general":"","level":"4","name":"documentLevelAllowanceBaseAmount","path":"/corG-1/corG-4/cenG-20/cen-93","ID":"BT-93","term":"Document level allowance base amount","Card":"0..1"},
    "cen-94":{"general":"","level":"4","name":"documentLevelAllowancePercentage","path":"/corG-1/corG-4/cenG-20/cen-94","ID":"BT-94","term":"Document level allowance percentage","Card":"0..1"},
    "cen-97":{"general":"","level":"4","name":"documentLevelAllowanceReason","path":"/corG-1/corG-4/cenG-20/cen-97","ID":"BT-97","term":"Document level allowance reason","Card":"0..1"},
    "cen-98":{"general":"","level":"4","name":"documentLevelAllowanceReasonCode","path":"/corG-1/corG-4/cenG-20/cen-98","ID":"BT-98","term":"Document level allowance reason code","Card":"0..1"},
    "cenG-21":{"general":"","level":"3","name":"documentLevelCharges","path":"/corG-1/corG-4/cenG-21","ID":"BG-21","term":"DOCUMENT LEVEL CHARGES","Card":"0..n"},
    "cen-99":{"general":"cor-40","level":"4","name":"documentLevelChargeAmount","path":"/corG-1/corG-4/cenG-21/cen-99","ID":"BT-99","term":"Document level charge amount","Card":"1..1"},
    "cen-102":{"general":"cor-99","level":"4","name":"documentLevelChargeVatCategoryCode","path":"/corG-1/corG-4/cenG-21/cen-102","ID":"BT-102","term":"Document level charge VAT category code","Card":"1..1"},
    "cen-103":{"general":"cor-98","level":"4","name":"documentLevelChargeVatRate","path":"/corG-1/corG-4/cenG-21/cen-103","ID":"BT-103","term":"Document level charge VAT rate","Card":"0..1"},
    "cen-100":{"general":"","level":"4","name":"documentLevelChargeBaseAmount","path":"/corG-1/corG-4/cenG-21/cen-100","ID":"BT-100","term":"Document level charge base amount","Card":"0..1"},
    "cen-101":{"general":"","level":"4","name":"documentLevelChargePercentage","path":"/corG-1/corG-4/cenG-21/cen-101","ID":"BT-101","term":"Document level charge percentage","Card":"0..1"},
    "cen-104":{"general":"","level":"4","name":"documentLevelChargeReason","path":"/corG-1/corG-4/cenG-21/cen-104","ID":"BT-104","term":"Document level charge reason","Card":"0..1"},
    "cen-105":{"general":"","level":"4","name":"documentLevelChargeReasonCode","path":"/corG-1/corG-4/cenG-21/cen-105","ID":"BT-105","term":"Document level charge reason code","Card":"0..1"},
    "cenG-22":{"general":"","level":"3","name":"documentTotals","path":"/corG-1/corG-4/cenG-22","ID":"BG-22","term":"DOCUMENT TOTALS","Card":"1..1"},
    "cen-106":{"general":"cor-40","level":"4","name":"sumOfInvoiceLineNetAmount","path":"/corG-1/corG-4/cenG-22/cen-106","ID":"BT-106","term":"Sum of Invoice line net amount","Card":"1..1"},
    "cen-107":{"general":"","level":"4","name":"sumOfAllowancesOnDocumentLevel","path":"/corG-1/corG-4/cenG-22/cen-107","ID":"BT-107","term":"Sum of allowances on document level","Card":"0..1"},
    "cen-108":{"general":"","level":"4","name":"sumOfChargesOnDocumentLevel","path":"/corG-1/corG-4/cenG-22/cen-108","ID":"BT-108","term":"Sum of charges on document level","Card":"0..1"},
    "cen-109":{"general":"","level":"4","name":"invoiceTotalAmountWithoutVat","path":"/corG-1/corG-4/cenG-22/cen-109","ID":"BT-109","term":"Invoice total amount without VAT","Card":"1..1"},
    "cen-111":{"general":"","level":"4","name":"invoiceTotalVatAmountInAccountingCurrency","path":"/corG-1/corG-4/cenG-22/cen-111","ID":"BT-111","term":"Invoice total VAT amount in accounting currency","Card":"0..1"},
    "cen-112":{"general":"","level":"4","name":"invoiceTotalAmountWithVat","path":"/corG-1/corG-4/cenG-22/cen-112","ID":"BT-112","term":"Invoice total amount with VAT","Card":"1..1"},
    "cen-113":{"general":"","level":"4","name":"paidAmount","path":"/corG-1/corG-4/cenG-22/cen-113","ID":"BT-113","term":"Paid amount","Card":"0..1"},
    "cen-114":{"general":"","level":"4","name":"roundingAmount","path":"/corG-1/corG-4/cenG-22/cen-114","ID":"BT-114","term":"Rounding amount","Card":"0..1"},
    "cen-115":{"general":"","level":"4","name":"amountDueForPayment","path":"/corG-1/corG-4/cenG-22/cen-115","ID":"BT-115","term":"Amount due for payment","Card":"1..1"},
    "cenG-23":{"general":"","level":"3","name":"vatBreakdown","path":"/corG-1/corG-4/cenG-23","ID":"BG-23","term":"VAT BREAKDOWN","Card":"1..n"},
    "cen-116":{"general":"cor-40","level":"4","name":"vatCategoryTaxableAmount","path":"/corG-1/corG-4/cenG-23/cen-116","ID":"BT-116","term":"VAT category taxable amount","Card":"1..1"},
    "cen-117":{"general":"cor-95","level":"4","name":"vatCategoryTaxAmount","path":"/corG-1/corG-4/cenG-23/cen-117","ID":"BT-117","term":"VAT category tax amount","Card":"1..1"},
    "cen-118":{"general":"cor-99","level":"4","name":"vatCategoryCode","path":"/corG-1/corG-4/cenG-23/cen-118","ID":"BT-118","term":"VAT category code ","Card":"1..1"},
    "cen-119":{"general":"cor-98","level":"4","name":"vatCategoryRate","path":"/corG-1/corG-4/cenG-23/cen-119","ID":"BT-119","term":"VAT category rate","Card":"0..1"},
    "cen-120":{"general":"","level":"4","name":"vatExemptionReasonText","path":"/corG-1/corG-4/cenG-23/cen-120","ID":"BT-120","term":"VAT exemption reason text","Card":"0..1"},
    "cen-121":{"general":"","level":"4","name":"vatExemptionReasonCode","path":"/corG-1/corG-4/cenG-23/cen-121","ID":"BT-121","term":"VAT exemption reason code","Card":"0..1"},
    "corG-5":{"general":"","level":"3","name":"entryDetail","path":"/corG-1/corG-4/corG-5","ID":"BG-25","term":"INVOICE LINE","Card":"1..n"},
    "cor-21":{"general":"","level":"4","name":"lineNumber","path":"/corG-1/corG-4/corG-5/cor-21","ID":"BT-128","term":"Invoice line object identifier","Card":"0..1"},
    "cor-22":{"general":"","level":"4","name":"lineNumberCounter","path":"/corG-1/corG-4/corG-5/cor-22","ID":"BT-126","term":"Invoice line identifier","Card":"1..1"},
    "cor-23":{"general":"","level":"4","name":"accountMainID","path":"/corG-1/corG-4/corG-5/cor-23","ID":"BT-19","term":"Buyer accounting reference","Card":"0..1"},
    "cen-131":{"general":"cor-40","level":"4","name":"invoiceLineNetAmount","path":"/corG-1/corG-4/corG-5/cen-131","ID":"BT-131","term":"Invoice line net amount","Card":"1..1"},
    "cen-136":{"general":"cor-40","level":"4","name":"invoiceLineAllowanceAmount","path":"/corG-1/corG-4/corG-5/cen-136","ID":"BT-136","term":"Invoice line allowance amount","Card":"1..1"},
    "cen-141":{"general":"cor-40","level":"4","name":"invoiceLineChargeAmount","path":"/corG-1/corG-4/corG-5/cen-141","ID":"BT-141","term":"Invoice line charge amount","Card":"1..1"},
    "bus-135":{"general":"","level":"4","name":"paymentMethod","path":"/corG-1/corG-4/corG-5/bus-135","ID":"BT-81","term":"Payment means type code","Card":"1..1"},
    "cor-85":{"general":"","level":"4","name":"detailComment","path":"/corG-1/corG-4/corG-5/cor-85","ID":"BT-127","term":"Invoice line note","Card":"0..1"},
    "cor-89":{"general":"","level":"4","name":"shipReceivedDate","path":"/corG-1/corG-4/corG-5/cor-89","ID":"BT-72","term":"Actual delivery date","Card":"0..1"},
    "cor-90":{"general":"","level":"4","name":"maturityDate","path":"/corG-1/corG-4/corG-5/cor-90","ID":"BT-9","term":"Payment due date","Card":"0..1"},
    "cor-91":{"general":"","level":"4","name":"terms","path":"/corG-1/corG-4/corG-5/cor-91","ID":"BT-20","term":"Payment terms","Card":"0..1"},
    "cenG-29":{"general":"busG-21","level":"4","name":"priceDetails","path":"/corG-1/corG-4/corG-5/cenG-29","ID":"BG-29","term":"PRICE DETAILS","Card":"1..1"},
    "cen-146":{"general":"","level":"5","name":"itemNetPrice","path":"/corG-1/corG-4/corG-5/cenG-29/cen-146","ID":"BT-146","term":"Item net price","Card":"1..1"},
    "cen-147":{"general":"","level":"5","name":"itemPriceDiscount","path":"/corG-1/corG-4/corG-5/cenG-29/cen-147","ID":"BT-147","term":"Item price discount","Card":"0..1"},
    "cen-148":{"general":"","level":"5","name":"itemGrossPrice","path":"/corG-1/corG-4/corG-5/cenG-29/cen-148","ID":"BT-148","term":"Item gross price","Card":"0..1"},
    "cen-149":{"general":"bus-144","level":"5","name":"itemPriceBaseQuantity","path":"/corG-1/corG-4/corG-5/cenG-29/cen-149","ID":"BT-149","term":"Item price base quantity","Card":"0..1"},
    "cen-150":{"general":"bus-146","level":"5","name":"itemPriceBaseQuantityUnitOfMeasureCode","path":"/corG-1/corG-4/corG-5/cenG-29/cen-150","ID":"BT-150","term":"Item price base quantity unit of measure code","Card":"0..1"},
    "cenG-31":{"general":"busG-21","level":"4","name":"itemInformation","path":"/corG-1/corG-4/corG-5/cenG-31","ID":"BG-31","term":"ITEM INFORMATION","Card":"1..1"},
    "bus-143":{"general":"","level":"5","name":"measurableDescription","path":"/corG-1/corG-4/corG-5/cenG-31/bus-143","ID":"BT-153","term":"Item name","Card":"1..1"},
    "cen-155":{"general":"","level":"6","name":"itemSeller'SIdentifier","path":"/corG-1/corG-4/corG-5/cenG-31/bus-143/cen-155","ID":"BT-155","term":"Item Seller's identifier","Card":"0..1"},
    "cen-156":{"general":"","level":"6","name":"itemBuyer'SIdentifier","path":"/corG-1/corG-4/corG-5/cenG-31/bus-143/cen-156","ID":"BT-156","term":"Item Buyer's identifier","Card":"0..1"},
    "bus-139":{"general":"","level":"5","name":"measurableID","path":"/corG-1/corG-4/corG-5/cenG-31/bus-139","ID":"BT-157","term":"Item standard identifier","Card":"0..1"},
    "bus-140":{"general":"","level":"5","name":"measurableIDSchema","path":"/corG-1/corG-4/corG-5/cenG-31/bus-140","ID":"BT-157A","term":"Scheme identifier","Card":"1..1"},
    "cen-129":{"general":"bus-144","level":"5","name":"invoicedQuantity","path":"/corG-1/corG-4/corG-5/cenG-31/cen-129","ID":"BT-129","term":"Invoiced quantity","Card":"1..1"},
    "bus-145":{"general":"","level":"5","name":"measurableQualifier","path":"/corG-1/corG-4/corG-5/cenG-31/bus-145","ID":"BT-158","term":"Item classification identifier","Card":"0..n"},
    "cen-159":{"general":"bus-128","level":"6","name":"itemCountryOfOrigin","path":"/corG-1/corG-4/corG-5/cenG-31/bus-145/cen-159","ID":"BT-159","term":"Item country of origin","Card":"0..1"},
    "cen-130":{"general":"bus-146","level":"5","name":"invoicedQuantityUnitOfMeasureCode","path":"/corG-1/corG-4/corG-5/cenG-31/cen-130","ID":"BT-130","term":"Invoiced quantity unit of measure code","Card":"1..1"},
    "cenG-26":{"general":"","level":"5","name":"invoiceLinePeriod","path":"/corG-1/corG-4/corG-5/cenG-31/cenG-26","ID":"BG-26","term":"INVOICE LINE PERIOD","Card":"0..1"},
    "bus-148":{"general":"","level":"5","name":"measurableStartDateTime","path":"/corG-1/corG-4/corG-5/cenG-31/bus-148","ID":"BT-134","term":"Invoice line period start date","Card":"0..1"},
    "bus-149":{"general":"","level":"5","name":"measurableEndDateTime","path":"/corG-1/corG-4/corG-5/cenG-31/bus-149","ID":"BT-135","term":"Invoice line period end date","Card":"0..1"},
    "corG-19":{"general":"","level":"4","name":"taxes","path":"/corG-1/corG-4/corG-5/corG-19","ID":"BG-30","term":"LINE VAT INFORMATION","Card":"1..1"},
    "cen-110":{"general":"cor-95","level":"5","name":"invoiceTotalVatAmount","path":"/corG-1/corG-4/corG-5/corG-19/cen-110","ID":"BT-110","term":"Invoice total VAT amount","Card":"0..1"},
    "cen-117":{"general":"cor-95","level":"5","name":"vatCategoryTaxAmount","path":"/corG-1/corG-4/corG-5/corG-19/cen-117","ID":"BT-117","term":"VAT category tax amount","Card":"1..1"},
    "cen-119":{"general":"cor-98","level":"5","name":"vatCategoryRate","path":"/corG-1/corG-4/corG-5/corG-19/cen-119","ID":"BT-119","term":"VAT category rate","Card":"0..1"},
    "cen-152":{"general":"cor-98","level":"5","name":"invoicedItemVatRate","path":"/corG-1/corG-4/corG-5/corG-19/cen-152","ID":"BT-152","term":"Invoiced item VAT rate","Card":"0..1"},
    "cen-118":{"general":"cor-99","level":"5","name":"vatCategoryCode","path":"/corG-1/corG-4/corG-5/corG-19/cen-118","ID":"BT-118","term":"VAT category code ","Card":"1..1"},
    "cen-151":{"general":"cor-99","level":"5","name":"invoicedItemVatCategoryCode","path":"/corG-1/corG-4/corG-5/corG-19/cen-151","ID":"BT-151","term":"Invoiced item VAT category code","Card":"1..1"},
    "cenG-27":{"general":"","level":"5","name":"invoiceLineAllowances","path":"/corG-1/corG-4/corG-5/corG-19/cenG-27","ID":"BG-27","term":"INVOICE LINE ALLOWANCES","Card":"0..n"},
    "cen-137":{"general":"","level":"6","name":"invoiceLineAllowanceBaseAmount","path":"/corG-1/corG-4/corG-5/corG-19/cenG-27/cen-137","ID":"BT-137","term":"Invoice line allowance base amount","Card":"0..1"},
    "cen-138":{"general":"","level":"6","name":"invoiceLineAllowancePercentage","path":"/corG-1/corG-4/corG-5/corG-19/cenG-27/cen-138","ID":"BT-138","term":"Invoice line allowance percentage","Card":"0..1"},
    "cen-139":{"general":"","level":"6","name":"invoiceLineAllowanceReason","path":"/corG-1/corG-4/corG-5/corG-19/cenG-27/cen-139","ID":"BT-139","term":"Invoice line allowance reason","Card":"0..1"},
    "cen-140":{"general":"","level":"6","name":"invoiceLineAllowanceReasonCode","path":"/corG-1/corG-4/corG-5/corG-19/cenG-27/cen-140","ID":"BT-140","term":"Invoice line allowance reason code","Card":"0..1"},
    "cenG-28":{"general":"","level":"5","name":"invoiceLineCharges","path":"/corG-1/corG-4/corG-5/corG-19/cenG-28","ID":"BG-28","term":"INVOICE LINE CHARGES","Card":"0..n"},
    "cen-142":{"general":"","level":"6","name":"invoiceLineChargeBaseAmount","path":"/corG-1/corG-4/corG-5/corG-19/cenG-28/cen-142","ID":"BT-142","term":"Invoice line charge base amount","Card":"0..1"},
    "cen-143":{"general":"","level":"6","name":"invoiceLineChargePercentage","path":"/corG-1/corG-4/corG-5/corG-19/cenG-28/cen-143","ID":"BT-143","term":"Invoice line charge percentage","Card":"0..1"},
    "cen-144":{"general":"","level":"6","name":"invoiceLineChargeReason","path":"/corG-1/corG-4/corG-5/corG-19/cenG-28/cen-144","ID":"BT-144","term":"Invoice line charge reason","Card":"0..1"},
    "cen-145":{"general":"","level":"6","name":"invoiceLineChargeReasonCode","path":"/corG-1/corG-4/corG-5/corG-19/cenG-28/cen-145","ID":"BT-145","term":"Invoice line charge reason code","Card":"0..1"},
    "cen-154":{"general":"","level":"6","name":"itemDescription","path":"/corG-1/corG-4/corG-5/corG-19/cenG-28/cen-154","ID":"BT-154","term":"Item description","Card":"0..1"},
    "cenG-32":{"general":"","level":"4","name":"itemAttributes","path":"/corG-1/corG-4/corG-5/cenG-32","ID":"BG-32","term":"ITEM ATTRIBUTES","Card":"0..n"},
    "cen-160":{"general":"","level":"5","name":"itemAttributeName","path":"/corG-1/corG-4/corG-5/cenG-32/cen-160","ID":"BT-160","term":"Item attribute name","Card":"1..1"},
    "cen-161":{"general":"","level":"5","name":"itemAttributeValue","path":"/corG-1/corG-4/corG-5/cenG-32/cen-161","ID":"BT-161","term":"Item attribute value","Card":"1..1"}
  };

    var xbrl = null;

    var check = function(seq, path, current) {
        var val;
        if ('Object' === current.constructor.name) {
            val = current.val;
            if (val) {
                if (1 === val.length && 'Object' !== val[0].constructor.name) {
                    return {'seq': seq, 'path': path, 'v': val[0]};
                }
                else if (2 == val.length) {
                    if (val[1] && 'Object' !== val[1].constructor.name) {
                        return {'seq': seq, 'path': path, 'v': val[1]};
                    }
                }
            }
        }
        else if ('Array' === current.constructor.name) {
            if (1 === current.length && 'Object' !== current[0].constructor.name) {
                return {'seq': seq, 'path': path, 'v': current[0]};
            }
            else if (2 == current.length) {
                if (current[1] && 'Object' !== current[1].constructor.name) {
                    return {'seq': seq, 'path': path, 'v': current[1]};
                }
            }
        }
        return null;
    }

    var lookupEN = function(bg, bt) {
        var searchEN = function(seq, path, current) {
            var rgx, found, val;
            if ('Array' === current.constructor.name) {
                rgx = new RegExp((bg ? bg : '')+(bt ? '\\\/'+bt : ''));
                if (path.match(rgx)) {
                    found = check(seq, path, current);
                    if(found) { return found; }
                }
                else {
                    var result = [];
                    for (var record of current) {
                        if (record) {
                            for (var idx in record) {
                                var item = record[idx];
                                var children = item.val;
                                if (children) {
                                    rgx = new RegExp((bg ? bg : '')+(bt ? '\\\/'+bt : ''));
                                    if ((path+'/'+idx).match(rgx)) {
                                        for (seq = 0; seq < children.length; seq++) {
                                            var founds = {};
                                            var found = check(seq, path+'/'+idx, children);
                                            if (found) {
                                                founds[idx] = found.v;
                                            }
                                            else {
                                                var child = children[seq];
                                                for (var key in child) {
                                                    var found = check(seq, path+'/'+idx+'/'+key, child[key]);
                                                    if (found) { founds[key] = found.v; }
                                                }
                                            }
                                            result[seq] = founds;
                                        }
                                        break;
                                    }
                                    if (bg && (path+'/'+idx).match(new RegExp(bg))) {
                                        for (seq = 0; seq < children.length; seq++) {
                                            var child = children[seq];
                                            var founds = {};
                                            for (var key in child) {
                                                rgx = new RegExp((bg ? bg : '')+(bt ? '\\\/'+bt : ''));
                                                if ((path+'/'+idx+'/'+key).match(rgx)) {
                                                    var found = check(seq, path+'/'+idx+'/'+key, child[key]);
                                                    if (found) {
                                                        founds[key] = found.v;
                                                        break;
                                                    }
                                                }
                                            }
                                            result[seq] = founds;
                                        }
                                        break;
                                    }
                                }
                            }
                        }
                    }
                    return result;
                }
            }
            // START process current node here
            for (var i = 0; i < current.length; i++) {
                var val = current[i];
                //visit children of current
                if ('object' == typeof val) {
                    for (var idx in val) {
                        var item = val[idx];
                        var children = item.val;
                        if (children && children.length > 0) {
                            var found = searchEN(0, path+'/'+idx, children);
                            if (found) { return found; }
                        }
                    }
                }
            }
        }
        // call on root node
        return searchEN(0, '', en.val); 
    }

    var buildPalette = function(gl_plt) {
        var gl = {};
        for (var id in gl_plt) {
            var record = gl_plt[id];
            path = record.path;
            var paths = path.split('/');
            paths.shift();
            var element = gl;
            for (var _id of paths) {
                if (!element[_id]) {
                    var record = gl_plt[_id];
                    var code = record['code'];
                    var name = record['name'];
                    element[_id] = {'name':name, 'code':code, 'val':[{}]};
                }
                element = element[_id].val[0];
            }
        }
        return gl;
    }

    var getPalette = function(nth, _path) {
        var code1, code2, code3, code4, code5,
            id1, id2, id3, id4, id5, n1, n2, n3, n4, n5,
            result;
        path = _path.split('/');
        path.shift();
        function id1check() {
            if (!xbrl[id1].val[n1]) {
                xbrl[id1].val[n1] = {};
            }
        }
        function id2check() {
            id1check();
            if (!xbrl[id1].val[n1]) {
                xbrl[id1].val[n1] = {};
            }
            if (!xbrl[id1].val[n1][id2]) {
                xbrl[id1].val[n1][id2] = {'name':name2, 'code':code2, 'val':[{}]};
            }
        }
        function id3check() {
            id2check();
            if (!xbrl[id1].val[n1][id2].val[n2]) {
                xbrl[id1].val[n1][id2].val[n2] = {};
            }
            if (!xbrl[id1].val[n1][id2].val[n2][id3]) {
                xbrl[id1].val[n1][id2].val[n2][id3] = {'name':name3, 'code':code3, 'val':[{}]};
            }
        }
        function id4check() {
            id3check();
            if (!xbrl[id1].val[n1][id2].val[n2][id3].val[n3]) {
                xbrl[id1].val[n1][id2].val[n2][id3].val[n3] = {};
            }
            if (!xbrl[id1].val[n1][id2].val[n2][id3].val[n3][id4]) {
                xbrl[id1].val[n1][id2].val[n2][id3].val[n3][id4] = {'name':name4, 'code':code4, 'val':[{}]};
            }
        }
        function id5check() {
            id4check();
            if (!xbrl[id1].val[n1][id2].val[n2][id3].val[n3][id4].val[n4]) {
                xbrl[id1].val[n1][id2].val[n2][id3].val[n3][id4].val[n4] = {};
            }
            if (!xbrl[id1].val[n1][id2].val[n2][id3].val[n3][id4].val[n4][id5]) {
                xbrl[id1].val[n1][id2].val[n2][id3].val[n3][id4].val[n4][id5] = {'name':name5, 'code':code5, 'val':[{}]};
            }
        }

        switch (path.length) {
            case 5: id5 = path[4]; n5 = nth[4] || 0;
            case 4: id4 = path[3]; n4 = nth[3] || 0;
            case 3: id3 = path[2]; n3 = nth[2] || 0;
            case 2: id2 = path[1]; n2 = nth[1] || 0;
            case 1: id1 = path[0]; n1 = nth[0] || 0;
        }
        for (var k in gl_plt) {
            var record = gl_plt[k];
            var code = record['code'];
            var name = record['name'];
            if (k === id1)      { code1 = code; name1 = name; }
            else if (k === id2) { code2 = code; name2 = name; }
            else if (k === id3) { code3 = code; name3 = name; }
            else if (k === id4) { code4 = code; name4 = name; }
            else if (k === id5) { code5 = code; name5 = name; }
        }
        switch (path.length) {
            case 1:
                id1check(); result = xbrl[id1];
                break;
            case 2:
                id2check(); result = xbrl[id1].val[n1][id2];
                break;
            case 3:
                id3check(); result = xbrl[id1].val[n1][id2].val[n2][id3];
                break;
            case 4:
                id4check(); result = xbrl[id1].val[n1][id2].val[n2][id3].val[n3][id4];
                break;
            case 5:
                id5check(); result = xbrl[id1].val[n1][id2].val[n2][id3].val[n3][id4].val[n4][id5];
                break;
        }
        return result;
    }

    var fill = function(gl_plt) {
        var populate = function(nth, path, current) {
            var codeP, codePs, len, n;
            codeP = current.code;
            var child, code, enG, enT, code;
            var element;
            // console.log('populate', nth, path);
            for (var _id in current.val) {
                var val = current.val[_id];
                if ('object' == typeof val) {
                    for (var idx in val) {
                        child = val[idx];
                        code = child.code;
                        if (idx.match(/^[a-z]{2,3}G-[0-9]+$/)) { // idx is abcG-nn
                            if (!code) {
                                var  _nth = [], _path = path+'/'+idx;
                                var ps = _path.split('/'); ps.shift();
                                for (var i = 0; i < ps.length; i++) {
                                    if (undefined === nth[i]) { _nth[i] = 0; }
                                    else { _nth[i] = nth[i]; }
                                }
                                populate(_nth, _path, child);
                            }
                            else if (code.match(/^BG-[0-9]+$/)) { // code is BG-nn
                                enG = lookupEN(code, '');
                                element = getPalette(nth, path);
                                if (enG && enG.length > 1) {
                                    for (var i = 0; i < enG.length; i++) {
                                        var depth = (path.match(/\//g) || []).length;
                                        nth[depth] = i;
                                        // console.log('- code:'+code, i, nth, path);
                                        var record = enG[i];
                                        if ('object' == typeof record) {
                                            for (var key in record) {
                                                var v = record[key]; // key is either BG-nn or BT-nn
                                                var _nth = [], _path;
                                                for (var k in gl_plt) {
                                                    var d = gl_plt[k];
                                                    if (d.code == key) { _path = d.path; }
                                                }
                                                var ps = _path.split('/'); ps.shift();
                                                for (var k = 0; k < ps.length; k++) {
                                                    if (undefined === nth[k]) { _nth[k] = 0; }
                                                    else { _nth[k] = nth[k]; }
                                                }
                                                // console.log('-- key:'+key, _nth, _path);
                                                if (key.match(/^BG-[0-9]+$/)) { // key is BG-nn)
                                                    var _element = getPalette(_nth, _path);
                                                    if (v && _element) {
                                                        _element.val[i] = v;
                                                    }
                                                    else { console.log('NOT defined '+_path+' '+key); }
                                                }
                                                else if (key.match(/^BT-[0-9]+$/)) { // key is BT-nn
                                                    var _element = getPalette(_nth, _path);
                                                    if (v && _element) {
                                                        _element.val[0] = v;
                                                    }
                                                    else { console.log('NOT defined '+_path+' '+key); }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            else if (code.match(/^BT-[0-9]+$/)) { // code is BT-nn
                                var  _nth = [], _path = _path+'/'+idx;
                                var ps = _path.split('/');
                                ps.shift();
                                for (var k = 0; k < ps.length; k++) {
                                    if (undefined === nth[k]) { _nth[k] = 0; }
                                    else { _nth[k] = nth[k]; }
                                }
                                // console.log('code:'+key, _nth, _path);
                                element = getPalette(_nth, _path);
                                enT = lookupEN(codeP, code);
                                if (element && enT && enT[0] && enT[0][code]) {
                                    if (element && enT) {
                                        element.val[0] = enT[0][code];
                                    }
                                }
                            }
                        }
                        else if (idx.match(/^[a-z]{2,3}-[0-9]+$/)) { // idx is abc-nn
                            if (code.match(/^BT-[0-9]+$/)) { // code is BT-nn
                                var _path = path+'/'+idx;
                                var ps = _path.split('/'); ps.shift();
                                var _nth = [];
                                for (var k = 0; k < ps.length; k++) {
                                    if (undefined === nth[k]) { _nth[k] = 0; }
                                    else { _nth[k] = nth[k]; }
                                }
                                element = getPalette(_nth, _path);
                                enT = lookupEN(codeP, code);
                                if (element && enT && enT[0] && enT[0][code]) {
                                    element.val[0] = enT[0][code];
                                }
                            }
                        }
                    }
                }
            }
        }
        xbrl = buildPalette(gl_plt);
        var current = xbrl['corG-1'];
        populate([0], '/corG-1', current);
        return xbrl;
    }

    var initModule = function() {
        return Promise.resolve(gl_plt)
        .then(function(gl_plt) {
            xbrl = fill(gl_plt);
            
        })
        .catch(function(err) { console.log(err); })
    }

    return {
        gl_plt: gl_plt,
        lookupEN: lookupEN,
        // getPalette: getPalette,
        // fill: fill,
        initModule: initModule
    }
})();
// en2gl_mapping.js