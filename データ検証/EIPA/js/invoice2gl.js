/**
 * invoice2gl.js
 *
 * This is a free to use open source software and licensed under the MIT License
 * CC-SA-BY Copyright (c) 2020, Sambuichi Professional Engineers Office
 **/
var invoice2gl = (function() {
    var stateMap = {
        en: null,
        gl_plt: null,
        xbrlgl: null
    };
    /**
    ([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)
    "$2":{"level":"$4","module":"$8","name":"$9","code":"$10","type":"$17","Card":"$15","path":"$19"},
    seq code general level parent mode plt_parent module term ID label description p_term plt_term Card dataType SemanticDataType dataType path
    1   2    3       4     5      6    7          8      9    10 11    12          13     14       15   16       17               18       19
    */
    var gl_plt = {
        "corG-1":{"level":"1","module":"cor","name":"accountingEntries","code":"","type":"","Card":"","path":"/corG-1"},
        "corG-2":{"level":"2","module":"cor","name":"documentInfo","code":"","type":"","Card":"","path":"/corG-1/corG-2"},
        "cor-76":{"level":"3","module":"cor","name":"documentNumber","code":"BT-1","type":"Identifier","Card":"1..1","path":"/corG-1/corG-2/cor-76"},
        "cor-79":{"level":"3","module":"cor","name":"documentDate","code":"BT-2","type":"Date","Card":"1..1","path":"/corG-1/corG-2/cor-79"},
        "cor-73":{"level":"3","module":"cor","name":"documentType","code":"BT-3","type":"Code","Card":"1..1","path":"/corG-1/corG-2/cor-73"},
        "cen-11":{"level":"3","module":"cen","name":"projectReference","code":"BT-11","type":"Document reference","Card":"0..1","path":"/corG-1/corG-2/cen-11"},
        "cen-12":{"level":"3","module":"cen","name":"contractReference","code":"BT-12","type":"Document reference","Card":"0..1","path":"/corG-1/corG-2/cen-12"},
        "cen-13":{"level":"3","module":"cen","name":"purchaseOrderReference","code":"BT-13","type":"Document reference","Card":"0..1","path":"/corG-1/corG-2/cen-13"},
        "cen-14":{"level":"3","module":"cen","name":"salesOrderReference","code":"BT-14","type":"Document reference","Card":"0..1","path":"/corG-1/corG-2/cen-14"},
        "cen-15":{"level":"3","module":"cen","name":"receivingAdviceReference","code":"BT-15","type":"Document reference","Card":"0..1","path":"/corG-1/corG-2/cen-15"},
        "cen-16":{"level":"3","module":"cen","name":"despatchAdviceReference","code":"BT-16","type":"Document reference","Card":"0..1","path":"/corG-1/corG-2/cen-16"},
        "cen-17":{"level":"3","module":"cen","name":"tenderOrLotReference","code":"BT-17","type":"Document reference","Card":"0..1","path":"/corG-1/corG-2/cen-17"},
        "cenG-16":{"level":"3","module":"cen","name":"paymentInstructions","code":"BG-16","type":"","Card":"0..1","path":"/corG-1/corG-2/cenG-16"},
        "cen-81":{"level":"4","module":"cen","name":"paymentMeansTypeCode","code":"BT-81","type":"Code","Card":"1..1","path":"/corG-1/corG-2/cenG-16/cen-81"},
        "cen-82":{"level":"4","module":"cen","name":"paymentMeansText","code":"BT-82","type":"Text","Card":"0..1","path":"/corG-1/corG-2/cenG-16/cen-82"},
        "cen-83":{"level":"4","module":"cen","name":"remittanceInformation","code":"BT-83","type":"Text","Card":"0..1","path":"/corG-1/corG-2/cenG-16/cen-83"},
        "cenG-17":{"level":"4","module":"cen","name":"creditTransfer","code":"BG-17","type":"","Card":"0..n","path":"/corG-1/corG-2/cenG-16/cenG-17"},
        "cen-84":{"level":"5","module":"cen","name":"paymentAccountIdentifier","code":"BT-84","type":"Identifier","Card":"1..1","path":"/corG-1/corG-2/cenG-16/cenG-17/cen-84"},
        "cen-85":{"level":"5","module":"cen","name":"paymentAccountName","code":"BT-85","type":"Text","Card":"0..1","path":"/corG-1/corG-2/cenG-16/cenG-17/cen-85"},
        "cen-86":{"level":"5","module":"cen","name":"paymentServiceProviderIdentifier","code":"BT-86","type":"Identifier","Card":"0..1","path":"/corG-1/corG-2/cenG-16/cenG-17/cen-86"},
        "cenG-18":{"level":"4","module":"cen","name":"paymentCardInformation","code":"BG-18","type":"","Card":"0..1","path":"/corG-1/corG-2/cenG-16/cenG-18"},
        "cen-87":{"level":"5","module":"cen","name":"paymentCardPrimaryAccountNumber","code":"BT-87","type":"Text","Card":"1..1","path":"/corG-1/corG-2/cenG-16/cenG-18/cen-87"},
        "cen-88":{"level":"5","module":"cen","name":"paymentCardHolderName","code":"BT-88","type":"Text","Card":"0..1","path":"/corG-1/corG-2/cenG-16/cenG-18/cen-88"},
        "cenG-19":{"level":"4","module":"cen","name":"directDebit","code":"BG-19","type":"","Card":"0..1","path":"/corG-1/corG-2/cenG-16/cenG-19"},
        "cen-89":{"level":"5","module":"cen","name":"mandateReferenceIdentifier","code":"BT-89","type":"Identifier","Card":"0..1","path":"/corG-1/corG-2/cenG-16/cenG-19/cen-89"},
        "cen-90":{"level":"5","module":"cen","name":"bankAssignedCreditorIdentifier","code":"BT-90","type":"Identifier","Card":"0..1","path":"/corG-1/corG-2/cenG-16/cenG-19/cen-90"},
        "cen-91":{"level":"5","module":"cen","name":"debitedAccountIdentifier","code":"BT-91","type":"Identifier","Card":"0..1","path":"/corG-1/corG-2/cenG-16/cenG-19/cen-91"},
        "tafG-1":{"level":"3","module":"taf","name":"originatingDocumentStructure","code":"BG-3","type":"","Card":"","path":"/corG-1/corG-2/cenG-3/tafG-1"},
        "taf-4":{"level":"4","module":"taf","name":"originatingDocumentType","code":"","type":"","Card":"","path":"/corG-1/corG-2/cenG-3/tafG-1/taf-4"},
        "taf-5":{"level":"4","module":"taf","name":"originatingDocumentNumber","code":"BT-25","type":"Document reference","Card":"1..1","path":"/corG-1/corG-2/cenG-3/tafG-1/taf-5"},
        "cen-26":{"level":"4","module":"cen","name":"precedingInvoiceIssueDate","code":"BT-26","type":"Date","Card":"0..1","path":"/corG-1/corG-2/cenG-3/tafG-1/cen-26"},
        "cen-18":{"level":"3","module":"cen","name":"invoicedObjectIdentifier","code":"BT-18","type":"Identifier","Card":"0..1","path":"/corG-1/corG-2/cen-18"},
        "cenG-1":{"level":"3","module":"cen","name":"invoiceNote","code":"BG-1","type":"","Card":"0..n","path":"/corG-1/corG-2/cenG-1"},
        "cen-21":{"level":"4","module":"cen","name":"invoiceNoteSubjectCode","code":"BT-21","type":"Code","Card":"0..1","path":"/corG-1/corG-2/cenG-1/cen-21"},
        "cen-22":{"level":"4","module":"cen","name":"invoiceNoteText","code":"BT-22","type":"Text","Card":"1..1","path":"/corG-1/corG-2/cenG-1/cen-22"},
        "cenG-2":{"level":"3","module":"cen","name":"processControl","code":"BG-2","type":"","Card":"1..1","path":"/corG-1/corG-2/cenG-2"},
        "cen-23":{"level":"4","module":"cen","name":"businessProcessType","code":"BT-23","type":"Text","Card":"0..1","path":"/corG-1/corG-2/cenG-2/cen-23"},
        "cen-24":{"level":"4","module":"cen","name":"specificationIdentifier","code":"BT-24","type":"Identifier","Card":"1..1","path":"/corG-1/corG-2/cenG-2/cen-24"},
        "cenG-24":{"level":"3","module":"cen","name":"additionalSupportingDocuments","code":"BG-24","type":"","Card":"0..n","path":"/corG-1/corG-2/cenG-24"},
        "cen-122":{"level":"4","module":"cen","name":"supportingDocument reference","code":"BT-122","type":"Document reference","Card":"1..1","path":"/corG-1/corG-2/cenG-24/cen-122"},
        "cen-123":{"level":"4","module":"cen","name":"supportingDocumentDescription","code":"BT-123","type":"Text","Card":"0..1","path":"/corG-1/corG-2/cenG-24/cen-123"},
        "cen-124":{"level":"4","module":"cen","name":"externalDocumentLocation","code":"BT-124","type":"Text","Card":"0..1","path":"/corG-1/corG-2/cenG-24/cen-124"},
        "cen-125":{"level":"4","module":"cen","name":"attachedDocument","code":"BT-125","type":"Binaryobject","Card":"0..1","path":"/corG-1/corG-2/cenG-24/cen-125"},
        "cen-125A":{"level":"4","module":"cen","name":"attachedDocumentMimeCode","code":"BT-125A","type":"","Card":"1..1","path":"/corG-1/corG-2/cenG-24/cen-125A"},
        "cen-125B":{"level":"4","module":"cen","name":"attachedDocumentFilename","code":"BT-125B","type":"","Card":"1..1","path":"/corG-1/corG-2/cenG-24/cen-125B"},
        "corG-3":{"level":"2","module":"cor","name":"entityInformation","code":"","type":"","Card":"","path":"/corG-1/corG-3"},
        "cenG-4":{"level":"3","module":"cen","name":"seller","code":"BG-4","type":"","Card":"1..1","path":"/corG-1/corG-3/cenG-4"},
        "cen-29":{"level":"4","module":"cen","name":"sellerIdentifier","code":"BT-29","type":"Identifier","Card":"0..n","path":"/corG-1/corG-3/cenG-4/cen-29"},
        "cen-30":{"level":"4","module":"cen","name":"sellerLegalRegistrationIdentifier","code":"BT-30","type":"Identifier","Card":"0..1","path":"/corG-1/corG-3/cenG-4/cen-30"},
        "cen-31":{"level":"4","module":"cen","name":"sellerVatIdentifier","code":"BT-31","type":"Identifier","Card":"0..1","path":"/corG-1/corG-3/cenG-4/cen-31"},
        "cen-32":{"level":"4","module":"cen","name":"sellerTaxRegistrationIdentifier","code":"BT-32","type":"Identifier","Card":"0..1","path":"/corG-1/corG-3/cenG-4/cen-32"},
        "cen-27":{"level":"4","module":"cen","name":"sellerName","code":"BT-27","type":"Text","Card":"1..1","path":"/corG-1/corG-3/cenG-4/cen-27"},
        "cen-28":{"level":"4","module":"cen","name":"sellerTradingName","code":"BT-28","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-4/cen-28"},
        "cen-33":{"level":"4","module":"cen","name":"sellerAdditionalLegalInformation","code":"BT-33","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-4/cen-33"},
        "cenG-5":{"level":"4","module":"cen","name":"sellerPostalAddress","code":"BG-5","type":"","Card":"1..1","path":"/corG-1/corG-3/cenG-4/cenG-5"},
        "cen-35":{"level":"5","module":"cen","name":"sellerAddressLine1","code":"BT-35","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-4/cenG-5/cen-35"},
        "cen-36":{"level":"5","module":"cen","name":"sellerAddressLine2","code":"BT-36","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-4/cenG-5/cen-36"},
        "cen-162":{"level":"5","module":"cen","name":"sellerAddressLine3","code":"BT-162","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-4/cenG-5/cen-162"},
        "cen-37":{"level":"5","module":"cen","name":"sellerCity","code":"BT-37","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-4/cenG-5/cen-37"},
        "cen-38":{"level":"5","module":"cen","name":"sellerPostCode","code":"BT-38","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-4/cenG-5/cen-38"},
        "cen-39":{"level":"5","module":"cen","name":"sellerCountrySubdivision","code":"BT-39","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-4/cenG-5/cen-39"},
        "cen-40":{"level":"5","module":"cen","name":"sellerCountryCode","code":"BT-40","type":"Code","Card":"1..1","path":"/corG-1/corG-3/cenG-4/cenG-5/cen-40"},
        "cenG-6":{"level":"5","module":"cen","name":"sellerContact","code":"BG-6","type":"","Card":"0..1","path":"/corG-1/corG-3/cenG-4/cenG-5/cenG-6"},
        "cen-41":{"level":"6","module":"cen","name":"sellerContactPoint","code":"BT-41","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-4/cenG-5/cenG-6/cen-41"},
        "cen-42":{"level":"6","module":"cen","name":"sellerContactTelephoneNumber","code":"BT-42","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-4/cenG-5/cenG-6/cen-42"},
        "cen-34":{"level":"6","module":"cen","name":"sellerElectronicAddress","code":"BT-34","type":"Code","Card":"0..1","path":"/corG-1/corG-3/cenG-4/cenG-5/cenG-6/cen-34"},
        "cen-43":{"level":"6","module":"cen","name":"sellerContactEmailAddress","code":"BT-43","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-4/cenG-5/cenG-6/cen-43"},
        "cenG-11":{"level":"3","module":"cen","name":"sellerTaxRepresentativeParty","code":"BG-11","type":"","Card":"0..1","path":"/corG-1/corG-3/cenG-11"},
        "cen-63":{"level":"4","module":"cen","name":"sellerTaxRepresentativeVatIdentifier","code":"BT-63","type":"Identifier","Card":"1..1","path":"/corG-1/corG-3/cenG-11/cen-63"},
        "cen-62":{"level":"4","module":"cen","name":"sellerTaxRepresentativeName","code":"BT-62","type":"Text","Card":"1..1","path":"/corG-1/corG-3/cenG-11/cen-62"},
        "cenG-12":{"level":"4","module":"cen","name":"sellerTaxRepresentativePostalAddress","code":"BG-12","type":"","Card":"1..1","path":"/corG-1/corG-3/cenG-11/cenG-12"},
        "cen-64":{"level":"5","module":"cen","name":"taxRepresentativeAddressLine1","code":"BT-64","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-11/cenG-12/cen-64"},
        "cen-65":{"level":"5","module":"cen","name":"taxRepresentativeAddressLine2","code":"BT-65","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-11/cenG-12/cen-65"},
        "cen-164":{"level":"5","module":"cen","name":"taxRepresentativeAddressLine3","code":"BT-164","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-11/cenG-12/cen-164"},
        "cen-66":{"level":"5","module":"cen","name":"taxRepresentativeCity","code":"BT-66","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-11/cenG-12/cen-66"},
        "cen-67":{"level":"5","module":"cen","name":"taxRepresentativePostCode","code":"BT-67","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-11/cenG-12/cen-67"},
        "cen-68":{"level":"5","module":"cen","name":"taxRepresentativeCountrySubdivision","code":"BT-68","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-11/cenG-12/cen-68"},
        "cen-69":{"level":"5","module":"cen","name":"taxRepresentativeCountryCode","code":"BT-69","type":"Code","Card":"1..1","path":"/corG-1/corG-3/cenG-11/cenG-12/cen-69"},
        "cenG-7":{"level":"3","module":"cen","name":"buyer","code":"BG-7","type":"","Card":"1..1","path":"/corG-1/corG-3/cenG-7"},
        "cen-46":{"level":"4","module":"cen","name":"buyerIdentifier","code":"BT-46","type":"Identifier","Card":"0..1","path":"/corG-1/corG-3/cenG-7/cen-46"},
        "cen-47":{"level":"4","module":"cen","name":"buyerLegalRegistrationIdentifier","code":"BT-47","type":"Identifier","Card":"0..1","path":"/corG-1/corG-3/cenG-7/cen-47"},
        "cen-48":{"level":"4","module":"cen","name":"buyerVatIdentifier","code":"BT-48","type":"Identifier","Card":"0..1","path":"/corG-1/corG-3/cenG-7/cen-48"},
        "cen-47A":{"level":"4","module":"cen","name":"buyerSchemeIdentifier","code":"BT-47A","type":"","Card":"0..1","path":"/corG-1/corG-3/cenG-7/cen-47A"},
        "cen-44":{"level":"4","module":"cen","name":"buyerName","code":"BT-44","type":"Text","Card":"1..1","path":"/corG-1/corG-3/cenG-7/cen-44"},
        "cen-45":{"level":"4","module":"cen","name":"buyerTradingName","code":"BT-45","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-7/cen-45"},
        "cenG-8":{"level":"4","module":"cen","name":"buyerPostalAddress","code":"BG-8","type":"","Card":"1..1","path":"/corG-1/corG-3/cenG-7/cenG-8"},
        "cen-50":{"level":"5","module":"cen","name":"buyerAddressLine1","code":"BT-50","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-7/cenG-8/cen-50"},
        "cen-51":{"level":"5","module":"cen","name":"buyerAddressLine2","code":"BT-51","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-7/cenG-8/cen-51"},
        "cen-163":{"level":"5","module":"cen","name":"buyerAddressLine3","code":"BT-163","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-7/cenG-8/cen-163"},
        "cen-52":{"level":"5","module":"cen","name":"buyerCity","code":"BT-52","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-7/cenG-8/cen-52"},
        "cen-53":{"level":"5","module":"cen","name":"buyerPostCode","code":"BT-53","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-7/cenG-8/cen-53"},
        "cen-54":{"level":"5","module":"cen","name":"buyerCountrySubdivision","code":"BT-54","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-7/cenG-8/cen-54"},
        "cen-55":{"level":"5","module":"cen","name":"buyerCountryCode","code":"BT-55","type":"Code","Card":"1..1","path":"/corG-1/corG-3/cenG-7/cenG-8/cen-55"},
        "cenG-9":{"level":"5","module":"cen","name":"buyerContact","code":"BG-9","type":"","Card":"0..1","path":"/corG-1/corG-3/cenG-7/cenG-8/cenG-9"},
        "cen-56":{"level":"6","module":"cen","name":"buyerContactPoint","code":"BT-56","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-7/cenG-8/cenG-9/cen-56"},
        "cen-57":{"level":"6","module":"cen","name":"buyerContactTelephoneNumber","code":"BT-57","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-7/cenG-8/cenG-9/cen-57"},
        "cen-49":{"level":"6","module":"cen","name":"buyerElectronicAddress","code":"BT-49","type":"Code","Card":"0..1","path":"/corG-1/corG-3/cenG-7/cenG-8/cenG-9/cen-49"},
        "cen-58":{"level":"6","module":"cen","name":"buyerContactEmailAddress","code":"BT-58","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-7/cenG-8/cenG-9/cen-58"},
        "cenG-13":{"level":"3","module":"cen","name":"deliveryInformation","code":"BG-13","type":"","Card":"0..1","path":"/corG-1/corG-3/cenG-13"},
        "cen-70":{"level":"4","module":"cen","name":"deliverToPartyName","code":"BT-70","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-13/cen-70"},
        "cen-71":{"level":"4","module":"cen","name":"deliverToLocationIdentifier","code":"BT-71","type":"Identifier","Card":"0..1","path":"/corG-1/corG-3/cenG-13/cen-71"},
        "cen-72":{"level":"4","module":"cen","name":"actualDeliveryDate","code":"BT-72","type":"Date","Card":"0..1","path":"/corG-1/corG-3/cenG-13/cen-72"},
        "cenG-14":{"level":"4","module":"cen","name":"invoicingPeriod","code":"BG-14","type":"","Card":"0..1","path":"/corG-1/corG-3/cenG-13/cenG-14"},
        "cor-8":{"level":"5","module":"cor","name":"periodCoveredStart","code":"BT-73","type":"Date","Card":"0..1","path":"/corG-1/corG-3/cenG-13/cenG-14/cor-8"},
        "cor-9":{"level":"5","module":"cor","name":"periodCoveredEnd","code":"BT-74","type":"Date","Card":"0..1","path":"/corG-1/corG-3/cenG-13/cenG-14/cor-9"},
        "cenG-15":{"level":"4","module":"cen","name":"deliverToAddress","code":"BG-15","type":"","Card":"0..1","path":"/corG-1/corG-3/cenG-13/cenG-15"},
        "cen-75":{"level":"5","module":"cen","name":"deliverToAddressLine1","code":"BT-75","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-13/cenG-15/cen-75"},
        "cen-76":{"level":"5","module":"cen","name":"deliverToAddressLine2","code":"BT-76","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-13/cenG-15/cen-76"},
        "cen-165":{"level":"5","module":"cen","name":"deliverToAddressLine3","code":"BT-165","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-13/cenG-15/cen-165"},
        "cen-77":{"level":"5","module":"cen","name":"deliverToCity","code":"BT-77","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-13/cenG-15/cen-77"},
        "cen-78":{"level":"5","module":"cen","name":"deliverToPostCode","code":"BT-78","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-13/cenG-15/cen-78"},
        "cen-79":{"level":"5","module":"cen","name":"deliverToCountrySubdivision","code":"BT-79","type":"Text","Card":"0..1","path":"/corG-1/corG-3/cenG-13/cenG-15/cen-79"},
        "cen-80":{"level":"5","module":"cen","name":"deliverToCountryCode","code":"BT-80","type":"Code","Card":"1..1","path":"/corG-1/corG-3/cenG-13/cenG-15/cen-80"},
        "cenG-10":{"level":"3","module":"cen","name":"payee","code":"BG-10","type":"","Card":"0..1","path":"/corG-1/corG-3/cenG-10"},
        "cen-59":{"level":"4","module":"cen","name":"payeeName","code":"BT-59","type":"Text","Card":"1..1","path":"/corG-1/corG-3/cenG-10/cen-59"},
        "cen-60":{"level":"4","module":"cen","name":"payeeIdentifier","code":"BT-60","type":"Identifier","Card":"0..1","path":"/corG-1/corG-3/cenG-10/cen-60"},
        "cen-61":{"level":"4","module":"cen","name":"payeeLegalRegistrationIdentifier","code":"BT-61","type":"Identifier","Card":"0..1","path":"/corG-1/corG-3/cenG-10/cen-61"},
        "cen-61A":{"level":"4","module":"cen","name":"payeeSchemeIdentifier","code":"BT-61A","type":"","Card":"0..1","path":"/corG-1/corG-3/cenG-10/cen-61A"},
        "corG-4":{"level":"2","module":"cor","name":"entryHeader","code":"","type":"","Card":"","path":"/corG-1/corG-4"},
        "muc-4":{"level":"3","module":"muc","name":"amountOriginalCurrency","code":"BT-5","type":"Code","Card":"1..1","path":"/corG-1/corG-4/muc-4"},
        "muc-33":{"level":"3","module":"muc","name":"taxCurrency","code":"BT-6","type":"Code","Card":"0..1","path":"/corG-1/corG-4/muc-33"},
        "cor-43":{"level":"3","module":"cor","name":"postingDate","code":"BT-7","type":"Date","Card":"0..1","path":"/corG-1/corG-4/cor-43"},
        "cen-8":{"level":"3","module":"cen","name":"valueAddedTaxPointDateCode","code":"BT-8","type":"Code","Card":"0..1","path":"/corG-1/corG-4/cen-8"},
        "cor-90":{"level":"3","module":"cor","name":"maturityDate","code":"BT-9","type":"","Card":"","path":"/corG-1/corG-4/cor-90"},
        "cen-10":{"level":"3","module":"cen","name":"buyerReference","code":"BT-10","type":"Text","Card":"0..1","path":"/corG-1/corG-4/cen-10"},
        "cen-19":{"level":"3","module":"cen","name":"buyerAcountingReference","code":"BT-19","type":"Text","Card":"0..1","path":"/corG-1/corG-4/cen-19"},
        "cenG-20":{"level":"3","module":"cen","name":"documentLevelAllowances","code":"BG-20","type":"","Card":"0..n","path":"/corG-1/corG-4/cenG-20"},
        "cen-92":{"level":"4","module":"cen","name":"documentLevelAllowanceAmount","code":"BT-92","type":"Amount","Card":"1..1","path":"/corG-1/corG-4/cenG-20/cen-92"},
        "cen-95":{"level":"4","module":"cen","name":"documentLevelAllowanceVatCategoryCode","code":"BT-95","type":"Code","Card":"1..1","path":"/corG-1/corG-4/cenG-20/cen-95"},
        "cen-96":{"level":"4","module":"cen","name":"documentLevelAllowanceVatRate","code":"BT-96","type":"Percentage","Card":"0..1","path":"/corG-1/corG-4/cenG-20/cen-96"},
        "cen-93":{"level":"4","module":"cen","name":"documentLevelAllowanceBaseAmount","code":"BT-93","type":"Amount","Card":"0..1","path":"/corG-1/corG-4/cenG-20/cen-93"},
        "cen-94":{"level":"4","module":"cen","name":"documentLevelAllowancePercentage","code":"BT-94","type":"Percentage","Card":"0..1","path":"/corG-1/corG-4/cenG-20/cen-94"},
        "cen-97":{"level":"4","module":"cen","name":"documentLevelAllowanceReason","code":"BT-97","type":"Text","Card":"0..1","path":"/corG-1/corG-4/cenG-20/cen-97"},
        "cen-98":{"level":"4","module":"cen","name":"documentLevelAllowanceReasonCode","code":"BT-98","type":"Code","Card":"0..1","path":"/corG-1/corG-4/cenG-20/cen-98"},
        "cenG-21":{"level":"3","module":"cen","name":"documentLevelCharges","code":"BG-21","type":"","Card":"0..n","path":"/corG-1/corG-4/cenG-21"},
        "cen-99":{"level":"4","module":"cen","name":"documentLevelChargeAmount","code":"BT-99","type":"Amount","Card":"1..1","path":"/corG-1/corG-4/cenG-21/cen-99"},
        "cen-102":{"level":"4","module":"cen","name":"documentLevelChargeVatCategoryCode","code":"BT-102","type":"Code","Card":"1..1","path":"/corG-1/corG-4/cenG-21/cen-102"},
        "cen-103":{"level":"4","module":"cen","name":"documentLevelChargeVatRate","code":"BT-103","type":"Percentage","Card":"0..1","path":"/corG-1/corG-4/cenG-21/cen-103"},
        "cen-100":{"level":"4","module":"cen","name":"documentLevelChargeBaseAmount","code":"BT-100","type":"Amount","Card":"0..1","path":"/corG-1/corG-4/cenG-21/cen-100"},
        "cen-101":{"level":"4","module":"cen","name":"documentLevelChargePercentage","code":"BT-101","type":"Percentage","Card":"0..1","path":"/corG-1/corG-4/cenG-21/cen-101"},
        "cen-104":{"level":"4","module":"cen","name":"documentLevelChargeReason","code":"BT-104","type":"Text","Card":"0..1","path":"/corG-1/corG-4/cenG-21/cen-104"},
        "cen-105":{"level":"4","module":"cen","name":"documentLevelChargeReasonCode","code":"BT-105","type":"Code","Card":"0..1","path":"/corG-1/corG-4/cenG-21/cen-105"},
        "cenG-22":{"level":"3","module":"cen","name":"documentTotals","code":"BG-22","type":"","Card":"1..1","path":"/corG-1/corG-4/cenG-22"},
        "cen-106":{"level":"4","module":"cen","name":"sumOfInvoiceLineNetAmount","code":"BT-106","type":"Amount","Card":"1..1","path":"/corG-1/corG-4/cenG-22/cen-106"},
        "cen-107":{"level":"4","module":"cen","name":"sumOfAllowancesOnDocumentLevel","code":"BT-107","type":"Amount","Card":"0..1","path":"/corG-1/corG-4/cenG-22/cen-107"},
        "cen-108":{"level":"4","module":"cen","name":"sumOfChargesOnDocumentLevel","code":"BT-108","type":"Amount","Card":"0..1","path":"/corG-1/corG-4/cenG-22/cen-108"},
        "cen-109":{"level":"4","module":"cen","name":"invoiceTotalAmountWithoutVat","code":"BT-109","type":"Amount","Card":"1..1","path":"/corG-1/corG-4/cenG-22/cen-109"},
        "cen-110":{"level":"4","module":"cen","name":"invoiceTotalVatAmount","code":"BT-110","type":"Amount","Card":"0..1","path":"/corG-1/corG-4/cenG-22/cen-110"},
        "cen-111":{"level":"4","module":"cen","name":"invoiceTotalVatAmountInAccountingCurrency","code":"BT-111","type":"Amount","Card":"0..1","path":"/corG-1/corG-4/cenG-22/cen-111"},
        "cen-112":{"level":"4","module":"cen","name":"invoiceTotalAmountWithVat","code":"BT-112","type":"Amount","Card":"1..1","path":"/corG-1/corG-4/cenG-22/cen-112"},
        "cen-113":{"level":"4","module":"cen","name":"paidAmount","code":"BT-113","type":"Amount","Card":"0..1","path":"/corG-1/corG-4/cenG-22/cen-113"},
        "cen-114":{"level":"4","module":"cen","name":"roundingAmount","code":"BT-114","type":"Amount","Card":"0..1","path":"/corG-1/corG-4/cenG-22/cen-114"},
        "cen-115":{"level":"4","module":"cen","name":"amountDueForPayment","code":"BT-115","type":"Amount","Card":"1..1","path":"/corG-1/corG-4/cenG-22/cen-115"},
        "cenG-23":{"level":"3","module":"cen","name":"vatBreakdown","code":"BG-23","type":"","Card":"1..n","path":"/corG-1/corG-4/cenG-23"},
        "cen-116":{"level":"4","module":"cen","name":"vatCategoryTaxableAmount","code":"BT-116","type":"Amount","Card":"1..1","path":"/corG-1/corG-4/cenG-23/cen-116"},
        "cen-117":{"level":"4","module":"cen","name":"vatCategoryTaxAmount","code":"BT-117","type":"Amount","Card":"1..1","path":"/corG-1/corG-4/cenG-23/cen-117"},
        "cen-118":{"level":"4","module":"cen","name":"vatCategoryCode","code":"BT-118","type":"Code","Card":"1..1","path":"/corG-1/corG-4/cenG-23/cen-118"},
        "cen-119":{"level":"4","module":"cen","name":"vatCategoryRate","code":"BT-119","type":"Percentage","Card":"0..1","path":"/corG-1/corG-4/cenG-23/cen-119"},
        "cen-120":{"level":"4","module":"cen","name":"vatExemptionReasonText","code":"BT-120","type":"Text","Card":"0..1","path":"/corG-1/corG-4/cenG-23/cen-120"},
        "cen-121":{"level":"4","module":"cen","name":"vatExemptionReasonCode","code":"BT-121","type":"Code","Card":"0..1","path":"/corG-1/corG-4/cenG-23/cen-121"},
        "corG-5":{"level":"3","module":"cor","name":"entryDetail","code":"BG-25","type":"","Card":"1..n","path":"/corG-1/corG-4/corG-5"},
        "cor-22":{"level":"4","module":"cor","name":"lineNumberCounter","code":"BT-126","type":"Identifier","Card":"1..1","path":"/corG-1/corG-4/corG-5/cor-22"},
        "cor-21":{"level":"4","module":"cor","name":"lineNumber","code":"BT-128","type":"Identifier","Card":"0..1","path":"/corG-1/corG-4/corG-5/cor-21"},
        "cen-129":{"level":"4","module":"cen","name":"invoicedQuantity","code":"BT-129","type":"Quantity","Card":"1..1","path":"/corG-1/corG-4/corG-5/cen-129"},
        "cen-130":{"level":"4","module":"cen","name":"invoicedQuantityUnitOfMeasureCode","code":"BT-130","type":"Code","Card":"1..1","path":"/corG-1/corG-4/corG-5/cen-130"},
        "cen-131":{"level":"4","module":"cen","name":"invoiceLineNetAmount","code":"BT-131","type":"Amount","Card":"1..1","path":"/corG-1/corG-4/corG-5/cen-131"},
        "cen-132":{"level":"4","module":"cen","name":"referencedPurchaseOrderLineReference","code":"BT-132","type":"Document reference","Card":"0..1","path":"/corG-1/corG-2/cenG-2/cen-132"},
        "cen-133":{"level":"4","module":"cen","name":"invoiceLineBuyerAccountingReference","code":"BT-133","type":"Text","Card":"0..1","path":"/corG-1/corG-2/cenG-2/cen-133"},
        "cenG-26":{"level":"4","module":"cen","name":"invoiceLinePeriod","code":"BG-26","type":"","Card":"0..1","path":"/corG-1/corG-4/corG-5/cenG-26"},
        "bus-148":{"level":"5","module":"bus","name":"measurableStartDateTime","code":"BT-134","type":"Date","Card":"0..1","path":"/corG-1/corG-4/corG-5/cenG-26/bus-148"},
        "bus-149":{"level":"5","module":"bus","name":"measurableEndDateTime","code":"BT-135","type":"Date","Card":"0..1","path":"/corG-1/corG-4/corG-5/cenG-26/bus-149"},
        "cenG-27":{"level":"5","module":"cen","name":"invoiceLineAllowances","code":"BG-27","type":"","Card":"0..n","path":"/corG-1/corG-4/corG-5/cenG-26/cenG-27"},
        "cen-136":{"level":"6","module":"cen","name":"invoiceLineAllowanceAmount","code":"BT-136","type":"Amount","Card":"1..1","path":"/corG-1/corG-4/corG-5/corG-19/cenG-27/cen-136"},
        "cen-137":{"level":"6","module":"cen","name":"invoiceLineAllowanceBaseAmount","code":"BT-137","type":"Amount","Card":"0..1","path":"/corG-1/corG-4/corG-5/corG-19/cenG-27/cen-137"},
        "cen-138":{"level":"6","module":"cen","name":"invoiceLineAllowancePercentage","code":"BT-138","type":"Percentage","Card":"0..1","path":"/corG-1/corG-4/corG-5/corG-19/cenG-27/cen-138"},
        "cen-139":{"level":"6","module":"cen","name":"invoiceLineAllowanceReason","code":"BT-139","type":"Text","Card":"0..1","path":"/corG-1/corG-4/corG-5/corG-19/cenG-27/cen-139"},
        "cen-140":{"level":"6","module":"cen","name":"invoiceLineAllowanceReasonCode","code":"BT-140","type":"Code","Card":"0..1","path":"/corG-1/corG-4/corG-5/corG-19/cenG-27/cen-140"},
        "cenG-28":{"level":"5","module":"cen","name":"invoiceLineCharges","code":"BG-28","type":"","Card":"0..n","path":"/corG-1/corG-4/corG-5/corG-19/cenG-28"},
        "cen-141":{"level":"6","module":"cen","name":"invoiceLineChargeAmount","code":"BT-141","type":"Amount","Card":"1..1","path":"/corG-1/corG-4/corG-5/corG-19/cenG-28/cen-141"},
        "cen-142":{"level":"6","module":"cen","name":"invoiceLineChargeBaseAmount","code":"BT-142","type":"Amount","Card":"0..1","path":"/corG-1/corG-4/corG-5/corG-19/cenG-28/cen-142"},
        "cen-143":{"level":"6","module":"cen","name":"invoiceLineChargePercentage","code":"BT-143","type":"Percentage","Card":"0..1","path":"/corG-1/corG-4/corG-5/corG-19/cenG-28/cen-143"},
        "cen-144":{"level":"6","module":"cen","name":"invoiceLineChargeReason","code":"BT-144","type":"Text","Card":"0..1","path":"/corG-1/corG-4/corG-5/corG-19/cenG-28/cen-144"},
        "cen-145":{"level":"6","module":"cen","name":"invoiceLineChargeReasonCode","code":"BT-145","type":"Code","Card":"0..1","path":"/corG-1/corG-4/corG-5/corG-19/cenG-28/cen-145"},
        "bus-135":{"level":"4","module":"bus","name":"paymentMethod","code":"BT-81","type":"Code","Card":"1..1","path":"/corG-1/corG-4/corG-5/bus-135"},
        "cor-85":{"level":"4","module":"cor","name":"detailComment","code":"BT-127","type":"Text","Card":"0..1","path":"/corG-1/corG-4/corG-5/cor-85"},
        "cor-89":{"level":"4","module":"cor","name":"shipReceivedDate","code":"BT-72","type":"Date","Card":"0..1","path":"/corG-1/corG-4/corG-5/cor-89"},
        "cor-90":{"level":"4","module":"cor","name":"maturityDate","code":"BT-9","type":"Date","Card":"0..1","path":"/corG-1/corG-4/corG-5/cor-90"},
        "cor-91":{"level":"4","module":"cor","name":"terms","code":"BT-20","type":"Text","Card":"0..1","path":"/corG-1/corG-4/corG-5/cor-91"},
        "cenG-29":{"level":"4","module":"cen","name":"priceDetails","code":"BG-29","type":"","Card":"1..1","path":"/corG-1/corG-4/corG-5/cenG-29"},
        "cen-146":{"level":"5","module":"cen","name":"itemNetPrice","code":"BT-146","type":"UnitPriceAmount","Card":"1..1","path":"/corG-1/corG-4/corG-5/cenG-29/cen-146"},
        "cen-147":{"level":"5","module":"cen","name":"itemPriceDiscount","code":"BT-147","type":"UnitPriceAmount","Card":"0..1","path":"/corG-1/corG-4/corG-5/cenG-29/cen-147"},
        "cen-148":{"level":"5","module":"cen","name":"itemGrossPrice","code":"BT-148","type":"UnitPriceAmount","Card":"0..1","path":"/corG-1/corG-4/corG-5/cenG-29/cen-148"},
        "cen-149":{"level":"5","module":"cen","name":"itemPriceBaseQuantity","code":"BT-149","type":"Quantity","Card":"0..1","path":"/corG-1/corG-4/corG-5/cenG-29/cen-149"},
        "cen-150":{"level":"5","module":"cen","name":"itemPriceBaseQuantityUnitOfMeasureCode","code":"BT-150","type":"Code","Card":"0..1","path":"/corG-1/corG-4/corG-5/cenG-29/cen-150"},
        "cenG-31":{"level":"4","module":"cen","name":"itemInformation","code":"BG-31","type":"","Card":"1..1","path":"/corG-1/corG-4/corG-5/cenG-31"},
        "bus-143":{"level":"5","module":"bus","name":"measurableDescription","code":"BT-153","type":"Text","Card":"1..1","path":"/corG-1/corG-4/corG-5/cenG-31/bus-143"},
        "cen-154":{"level":"5","module":"cen","name":"itemDescription","code":"BT-154","type":"Text","Card":"0..1","path":"/corG-1/corG-4/corG-5/corG-31/cen-154"},
        "cen-155":{"level":"5","module":"cen","name":"itemSellersIdentifier","code":"BT-155","type":"Identifier","Card":"0..1","path":"/corG-1/corG-4/corG-5/corG-31/cen-155"},
        "cen-156":{"level":"5","module":"cen","name":"itemBuyersIdentifier","code":"BT-156","type":"Identifier","Card":"0..1","path":"/corG-1/corG-4/corG-5/corG-31/cen-156"},
        "bus-139":{"level":"5","module":"bus","name":"measurableID","code":"BT-157","type":"Identifier","Card":"0..1","path":"/corG-1/corG-4/corG-5/cenG-31/bus-139"},
        "bus-140":{"level":"5","module":"bus","name":"measurableIDSchema","code":"BT-157A","type":"","Card":"1..1","path":"/corG-1/corG-4/corG-5/cenG-31/bus-140"},
        "bus-145":{"level":"5","module":"bus","name":"measurableQualifier","code":"BT-158","type":"Identifier","Card":"0..n","path":"/corG-1/corG-4/corG-5/cenG-31/bus-145"},
        "cen-159":{"level":"5","module":"cen","name":"itemCountryOfOrigin","code":"BT-159","type":"Code","Card":"0..1","path":"/corG-1/corG-4/corG-5/cenG-31/cen-159"},
        "corG-19":{"level":"4","module":"cor","name":"taxes","code":"BG-30","type":"","Card":"1..1","path":"/corG-1/corG-4/corG-5/corG-19"},
        "cen-151":{"level":"5","module":"cen","name":"invoicedItemVatCategoryCode","code":"BT-151","type":"Code","Card":"1..1","path":"/corG-1/corG-4/corG-5/corG-19/cen-151"},
        "cen-152":{"level":"5","module":"cen","name":"invoicedItemVatRate","code":"BT-152","type":"Percentage","Card":"0..1","path":"/corG-1/corG-4/corG-5/corG-19/cen-152"},
        "cenG-32":{"level":"4","module":"cen","name":"itemAttributes","code":"BG-32","type":"","Card":"0..n","path":"/corG-1/corG-4/corG-5/cenG-32"},
        "cen-160":{"level":"5","module":"cen","name":"itemAttributeName","code":"BT-160","type":"Text","Card":"1..1","path":"/corG-1/corG-4/corG-5/cenG-32/cen-160"},
        "cen-161":{"level":"5","module":"cen","name":"itemAttributeValue","code":"BT-161","type":"Text","Card":"1..1","path":"/corG-1/corG-4/corG-5/cenG-32/cen-161"}
    }

    var lookupEN = function(path) { // e.g. path = '/BG-25[3]/BT-126'
        var IDs = path.split('/');
        var depth = IDs.length - 1;
        var code = IDs[depth], p1, p2, p3, p4, p5, p6, n1, n2, n3, n4, n5, n6;
        var val1, val2, val3, val4, val5, val6, val;
        var match, result;
        switch (depth) {
            case 7: match = IDs[6].match(/^(BG-[0-9]+)\[([0-9]+)\]$/); if (match) { p6 = match[1]; n6 = match[2]; }
            case 6: match = IDs[5].match(/^(BG-[0-9]+)\[([0-9]+)\]$/); if (match) { p5 = match[1]; n5 = match[2]; }
            case 5: match = IDs[4].match(/^(BG-[0-9]+)\[([0-9]+)\]$/); if (match) { p4 = match[1]; n4 = match[2]; }
            case 4: match = IDs[3].match(/^(BG-[0-9]+)\[([0-9]+)\]$/); if (match) { p3 = match[1]; n3 = match[2]; }
            case 3: match = IDs[2].match(/^(BG-[0-9]+)\[([0-9]+)\]$/); if (match) { p2 = match[1]; n2 = match[2]; }
            case 2: match = IDs[1].match(/^(BG-[0-9]+)\[([0-9]+)\]$/); if (match) { p1 = match[1]; n1 = match[2]; }
        }
        try {
            switch (depth) {
                case 7:
                    if (stateMap.en[p1].val.length > 0) { val1 = stateMap.en[p1].val[n1]; } else { val1 = stateMap.en[p1].val; }
                    if (val1[p2].val.length > 0) { val2 = val1[p2].val[n2]; } else { val2 = val1[p2].val; }
                    if (val2[p3].val.length > 0) { val3 = val2[p3].val[n3]; } else { val3 = val2[p3].val; }
                    if (val3[p4].val.length > 0) { val4 = val3[p4].val[n4]; } else { val4 = val3[p4].val; }
                    if (val4[p5].val.length > 0) { val5 = val4[p5].val[n5]; } else { val5 = val4[p5].val; }
                    if (val5[p6].val.length > 0) { val6 = val5[p6].val[n6]; } else { val6 = val5[p6].val; }
                    result = val6[code];
                    break;
                case 6:
                    if (stateMap.en[p1].val.length > 0) { val1 = stateMap.en[p1].val[n1]; } else { val1 = stateMap.en[p1].val; }
                    if (val1[p2].val.length > 0) { val2 = val1[p2].val[n2]; } else { val2 = val1[p2].val; }
                    if (val2[p3].val.length > 0) { val3 = val2[p3].val[n3]; } else { val3 = val2[p3].val; }
                    if (val3[p4].val.length > 0) { val4 = val3[p4].val[n4]; } else { val4 = val3[p4].val; }
                    if (val4[p5].val.length > 0) { val5 = val4[p5].val[n5]; } else { val5 = val4[p5].val; }
                    result = val5[code];
                    break;
                case 5:
                    if (stateMap.en[p1].val.length > 0) { val1 = stateMap.en[p1].val[n1]; } else { val1 = stateMap.en[p1].val; }
                    if (val1[p2].val.length > 0) { val2 = val1[p2].val[n2]; } else { val2 = val1[p2].val; }
                    if (val2[p3].val.length > 0) { val3 = val2[p3].val[n3]; } else { val3 = val2[p3].val; }
                    if (val3[p4].val.length > 0) { val4 = val3[p4].val[n4]; } else { val4 = val3[p4].val; }
                    result = val4[code];
                    break;
                case 4:
                    if (stateMap.en[p1].val.length > 0) { val1 = stateMap.en[p1].val[n1]; } else { val1 = stateMap.en[p1].val; }
                    if (val1[p2].val.length > 0) { val2 = val1[p2].val[n2]; } else { val2 = val1[p2].val; }
                    if (val2[p3].val.length > 0) { val3 = val2[p3].val[n3]; } else { val3 = val2[p3].val; }
                    result = val3[code];
                    break;
                case 3:
                    if (stateMap.en[p1].val.length > 0) { val1 = stateMap.en[p1].val[n1]; } else { val1 = stateMap.en[p1].val; }
                    if (val1[p2].val.length > 0) { val2 = val1[p2].val[n2]; } else { val2 = val1[p2].val; }
                    result = val2[code];
                    break;
                case 2:
                    if (stateMap.en[p1].val.length > 0) { val1 = stateMap.en[p1].val[n1]; } else { val1 = stateMap.en[p1].val; }
                    result = val1[code];
                    break;
                case 1:
                    result = stateMap.en[code];
                    break;
            }
        }
        catch(e) {
            return null;
        }
        if (result && result.val && result.val.length > 0 && 
            ( 'number' == typeof result.val[0] ||
              'string' == typeof result.val[0] ||
              ('object' == typeof result.val[0] && Object.keys(result.val[0]).length > 0))) {
            return result;
        }
        return null;
    };

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
                    if (record) {
                        var code = record['code'];
                        var name = record['name'];
                        element[_id] = {'name':name, 'code':code, 'val':[{}]};
                    }
                    else {
                        element[_id] = {'name':'', 'code':'', 'val':[{}]};
                        console.log('buildPalette UNDEF record in gl_plt ', _id);
                    }
                }
                element = element[_id].val[0];
            }
        }
        return gl;
    };

    var getPalette = function(path) { // path = '/corG-1[0]/corG-2[0]/cor-76'
        var IDs = path.split('/');
        var depth = IDs.length - 1;
        var code = IDs[depth], p1, p2, p3, p4, p5, p6, p7;//, n1, n2, n3, n4, n5, n6, n7;
        var match, result;
        switch (depth) {
            case 8: match = IDs[7].match(/^([a-z]{3,4}G-[0-9]+)\[([0-9]+)\]$/); if (match) { p7 = match[1]; }//n7 = match[2]; }
            case 7: match = IDs[6].match(/^([a-z]{3,4}G-[0-9]+)\[([0-9]+)\]$/); if (match) { p6 = match[1]; }//n6 = match[2]; }
            case 6: match = IDs[5].match(/^([a-z]{3,4}G-[0-9]+)\[([0-9]+)\]$/); if (match) { p5 = match[1]; }//n5 = match[2]; }
            case 5: match = IDs[4].match(/^([a-z]{3,4}G-[0-9]+)\[([0-9]+)\]$/); if (match) { p4 = match[1]; }//n4 = match[2]; }
            case 4: match = IDs[3].match(/^([a-z]{3,4}G-[0-9]+)\[([0-9]+)\]$/); if (match) { p3 = match[1]; }//n3 = match[2]; }
            case 3: match = IDs[2].match(/^([a-z]{3,4}G-[0-9]+)\[([0-9]+)\]$/); if (match) { p2 = match[1]; }//n2 = match[2]; }
            case 2: match = IDs[1].match(/^([a-z]{3,4}G-[0-9]+)\[([0-9]+)\]$/); if (match) { p1 = match[1]; }//n1 = match[2]; }
        }
        switch (depth) {
            case 8: result = stateMap.gl_plt[p1].val[0][p2].val[0][p3].val[0][p4].val[0][p5].val[0][p6].val[0][p7].val[0][code]; break;
            case 7: result = stateMap.gl_plt[p1].val[0][p2].val[0][p3].val[0][p4].val[0][p5].val[0][p6].val[0][code]; break;
            case 6: result = stateMap.gl_plt[p1].val[0][p2].val[0][p3].val[0][p4].val[0][p5].val[0][code]; break;
            case 5: result = stateMap.gl_plt[p1].val[0][p2].val[0][p3].val[0][p4].val[0][code]; break;
            case 4: result = stateMap.gl_plt[p1].val[0][p2].val[0][p3].val[0][code]; break;
            case 3: result = stateMap.gl_plt[p1].val[0][p2].val[0][code]; break;
            case 2: result = stateMap.gl_plt[p1].val[0][code]; break;
            case 1: result = stateMap.gl_plt[code]; break;
        }
        return result;
    };

    var getGL = function(path) { // path = '/corG-1[0]/corG-2[0]/cor-76'
        var IDs = path.split('/');
        var depth = IDs.length - 1;
        var code = IDs[depth], p1, p2, p3, p4, p5, p6, p7, n1, n2, n3, n4, n5, n6, n7;
        var match, result;
        switch (depth) {
            case 8: match = IDs[7].match(/^([a-z]{3,4}G-[0-9]+)\[([0-9]+)\]$/); if (match) { p7 = match[1]; n7 = match[2]; }
            case 7: match = IDs[6].match(/^([a-z]{3,4}G-[0-9]+)\[([0-9]+)\]$/); if (match) { p6 = match[1]; n6 = match[2]; }
            case 6: match = IDs[5].match(/^([a-z]{3,4}G-[0-9]+)\[([0-9]+)\]$/); if (match) { p5 = match[1]; n5 = match[2]; }
            case 5: match = IDs[4].match(/^([a-z]{3,4}G-[0-9]+)\[([0-9]+)\]$/); if (match) { p4 = match[1]; n4 = match[2]; }
            case 4: match = IDs[3].match(/^([a-z]{3,4}G-[0-9]+)\[([0-9]+)\]$/); if (match) { p3 = match[1]; n3 = match[2]; }
            case 3: match = IDs[2].match(/^([a-z]{3,4}G-[0-9]+)\[([0-9]+)\]$/); if (match) { p2 = match[1]; n2 = match[2]; }
            case 2: match = IDs[1].match(/^([a-z]{3,4}G-[0-9]+)\[([0-9]+)\]$/); if (match) { p1 = match[1]; n1 = match[2]; }
        }
        try {
            switch (depth) {
                case 8: result = stateMap.xbrlgl[p1].val[n1][p2].val[n2][p3].val[n3][p4].val[n4][p5].val[n5][p6].val[n6][p7].val[n7][code]; break;
                case 7: result = stateMap.xbrlgl[p1].val[n1][p2].val[n2][p3].val[n3][p4].val[n4][p5].val[n5][p6].val[n6][code]; break;
                case 6: result = stateMap.xbrlgl[p1].val[n1][p2].val[n2][p3].val[n3][p4].val[n4][p5].val[n5][code]; break;
                case 5: result = stateMap.xbrlgl[p1].val[n1][p2].val[n2][p3].val[n3][p4].val[n4][code]; break;
                case 4: result = stateMap.xbrlgl[p1].val[n1][p2].val[n2][p3].val[n3][code]; break;
                case 3: result = stateMap.xbrlgl[p1].val[n1][p2].val[n2][code]; break;
                case 2: result = stateMap.xbrlgl[p1].val[n1][code]; break;
                case 1: result = stateMap.xbrlgl[code]; break;
            }
        }
        catch(e) {
            console.log(e, path);
            return null;
        }
        return result;
    };

    var en2gl = function(en) {
        var fillGL = function(target, path) {
            var IDs = path.split('/'),
                depth = IDs.length - 1,
                gl_plt;
            var id = IDs[depth], p1, p2, p3, p4, p5, p6, p7, n1, n2, n3, n4, n5, n6, n7;
            var check7 = function(p1, n1, p2, n2, p3, n3, p4, n4, p5, n5, p6, n6, p7, n7) {
                if (!stateMap.xbrlgl[p1].val[n1][p2].val[n2][p3].val[n3][p4].val[n4][p5].val[n5][p6].val[n6][p7]) {
                    var _path = path.replace(/\[[0-9]+]\]/g, '[0]');
                    gl_plt = getPalette(_path);
                    stateMap.xbrlgl[p1].val[n1][p2].val[n2][p3].val[n3][p4].val[n4][p5].val[n5][p6].val[n6][p7] = {name:gl_plt.name, code:gl_plt.code, val:[{}]};
                }
                if (!stateMap.xbrlgl[p1].val[n1][p2].val[n2][p3].val[n3][p4].val[n4][p5].val[n5][p6].val[n6][p7].val[n7]) {
                    stateMap.xbrlgl[p1].val[n1][p2].val[n2][p3].val[n3][p4].val[n4][p5].val[n5][p6].val[n6][p7].val[n7] = {};
                }
            };
            var check6 = function(p1, n1, p2, n2, p3, n3, p4, n4, p5, n5, p6, n6) {
                if (!stateMap.xbrlgl[p1].val[n1][p2].val[n2][p3].val[n3][p4].val[n4][p5].val[n5][p6]) {
                    var _path = path.replace(/\[[0-9]+]\]/g, '[0]');
                    gl_plt = getPalette(_path);
                    stateMap.xbrlgl[p1].val[n1][p2].val[n2][p3].val[n3][p4].val[n4][p5].val[n5][p6] = {name:gl_plt.name, code:gl_plt.code, val:[{}]};
                }
                if (!stateMap.xbrlgl[p1].val[n1][p2].val[n2][p3].val[n3][p4].val[n4][p5].val[n5][p6].val[n6]) {
                    stateMap.xbrlgl[p1].val[n1][p2].val[n2][p3].val[n3][p4].val[n4][p5].val[n5][p6].val[n6] = {};
                }
            };
            var check5 = function(p1, n1, p2, n2, p3, n3, p4, n4, p5, n5) {
                if (!stateMap.xbrlgl[p1].val[n1][p2].val[n2][p3].val[n3][p4].val[n4][p5]) {
                    var _path = path.replace(/\[[0-9]+]\]/g, '[0]');
                    gl_plt = getPalette(_path);
                    stateMap.xbrlgl[p1].val[n1][p2].val[n2][p3].val[n3][p4].val[n4][p5] = {name:gl_plt.name, code:gl_plt.code, val:[{}]};
                }
                if (!stateMap.xbrlgl[p1].val[n1][p2].val[n2][p3].val[n3][p4].val[n4][p5].val[n5]) {
                    stateMap.xbrlgl[p1].val[n1][p2].val[n2][p3].val[n3][p4].val[n4][p5].val[n5] = {};
                }
            };
            var check4 = function(p1, n1, p2, n2, p3, n3, p4, n4) {
                if (!stateMap.xbrlgl[p1].val[n1][p2].val[n2][p3].val[n3][p4]) {
                    var _path = path.replace(/\[[0-9]+]\]/g, '[0]');
                    gl_plt = getPalette(_path);
                    stateMap.xbrlgl[p1].val[n1][p2].val[n2][p3].val[n3][p4] = {name:gl_plt.name, code:gl_plt.code, val:[{}]};
                }
                if (!stateMap.xbrlgl[p1].val[n1][p2].val[n2][p3].val[n3][p4].val[n4]) {
                    stateMap.xbrlgl[p1].val[n1][p2].val[n2][p3].val[n3][p4].val[n4] = {};
                }
            };
            var check3 = function(p1, n1, p2, n2, p3, n3) {
                if (!stateMap.xbrlgl[p1].val[n1][p2].val[n2][p3]) {
                    var _path = path.replace(/\[[0-9]+]\]/g, '[0]');
                    gl_plt = getPalette(_path);
                    stateMap.xbrlgl[p1].val[n1][p2].val[n2][p3] = {name:gl_plt.name, code:gl_plt.code, val:[{}]};
                }
                if (!stateMap.xbrlgl[p1].val[n1][p2].val[n2][p3].val[n3]) {
                    stateMap.xbrlgl[p1].val[n1][p2].val[n2][p3].val[n3] = {};
                }
            };
            var check2 = function(p1, n1, p2, n2) {
                if (!stateMap.xbrlgl[p1].val[n1][p2]) {
                    var _path = path.replace(/\[[0-9]+]\]/g, '[0]');
                    gl_plt = getPalette(_path);
                    stateMap.xbrlgl[p1].val[n1][p2] = {name:gl_plt.name, code:gl_plt.code, val:[{}]};
                }
                if (!stateMap.xbrlgl[p1].val[n1][p2].val[n2]) {
                    stateMap.xbrlgl[p1].val[n1][p2].val[n2] = {};
                }
            };
            var check1 = function(p1, n1) {
                if (!stateMap.xbrlgl[p1]) {
                    var _path = path.replace(/\[[0-9]+]\]/g, '[0]');
                    gl_plt = getPalette(_path);
                    stateMap.xbrlgl[p1] = {name:gl_plt.name, code:gl_plt.code, val:[{}]};
                }
                if (!stateMap.xbrlgl[p1].val[n1]) {
                    stateMap.xbrlgl[p1].val[n1] = {};
                }
            }
            switch (depth) {
                case 8: match = IDs[7].match(/^([a-z]{3,4}G-[0-9]+)\[([0-9]+)\]$/); if (match) { p7 = match[1]; n7 = match[2]; }
                case 7: match = IDs[6].match(/^([a-z]{3,4}G-[0-9]+)\[([0-9]+)\]$/); if (match) { p6 = match[1]; n6 = match[2]; }
                case 6: match = IDs[5].match(/^([a-z]{3,4}G-[0-9]+)\[([0-9]+)\]$/); if (match) { p5 = match[1]; n5 = match[2]; }
                case 5: match = IDs[4].match(/^([a-z]{3,4}G-[0-9]+)\[([0-9]+)\]$/); if (match) { p4 = match[1]; n4 = match[2]; }
                case 4: match = IDs[3].match(/^([a-z]{3,4}G-[0-9]+)\[([0-9]+)\]$/); if (match) { p3 = match[1]; n3 = match[2]; }
                case 3: match = IDs[2].match(/^([a-z]{3,4}G-[0-9]+)\[([0-9]+)\]$/); if (match) { p2 = match[1]; n2 = match[2]; }
                case 2: match = IDs[1].match(/^([a-z]{3,4}G-[0-9]+)\[([0-9]+)\]$/); if (match) { p1 = match[1]; n1 = match[2]; }
            }
            try {
                switch (depth) {
                    case 8:
                        check1(p1, n1);
                        check2(p1, n1, p2, n2);
                        check3(p1, n1, p2, n2, p3, n3);
                        check4(p1, n1, p2, n2, p3, n3, p4, n4);
                        check5(p1, n1, p2, n2, p3, n3, p4, n4, p5, n5);
                        check6(p1, n1, p2, n2, p3, n3, p4, n4, p5, n5, p6, n6);
                        check7(p1, n1, p2, n2, p3, n3, p4, n4, p5, n5, p6, n6, p7, n7);
                        stateMap.xbrlgl[p1].val[n1][p2].val[n2][p3].val[n3][p4].val[n4][p5].val[n5][p6].val[n6][p7].val[n7][id] = target;
                        break;
                    case 7:
                        check1(p1, n1);
                        check2(p1, n1, p2, n2);
                        check3(p1, n1, p2, n2, p3, n3);
                        check4(p1, n1, p2, n2, p3, n3, p4, n4);
                        check5(p1, n1, p2, n2, p3, n3, p4, n4, p5, n5);
                        check6(p1, n1, p2, n2, p3, n3, p4, n4, p5, n5, p6, n6);
                        stateMap.xbrlgl[p1].val[n1][p2].val[n2][p3].val[n3][p4].val[n4][p5].val[n5][p6].val[n6][id] = target;
                        break;
                    case 6:
                        check1(p1, n1);
                        check2(p1, n1, p2, n2);
                        check3(p1, n1, p2, n2, p3, n3);
                        check4(p1, n1, p2, n2, p3, n3, p4, n4);
                        check5(p1, n1, p2, n2, p3, n3, p4, n4, p5, n5);
                        stateMap.xbrlgl[p1].val[n1][p2].val[n2][p3].val[n3][p4].val[n4][p5].val[n5][id] = target;
                        break;
                    case 5:
                        check1(p1, n1);
                        check2(p1, n1, p2, n2);
                        check3(p1, n1, p2, n2, p3, n3);
                        check4(p1, n1, p2, n2, p3, n3, p4, n4);
                        stateMap.xbrlgl[p1].val[n1][p2].val[n2][p3].val[n3][p4].val[n4][id] = target;
                        break;
                    case 4:
                        check1(p1, n1);
                        check2(p1, n1, p2, n2);
                        check3(p1, n1, p2, n2, p3, n3);
                        stateMap.xbrlgl[p1].val[n1][p2].val[n2][p3].val[n3][id] = target;
                        break;
                    case 3:
                        check1(p1, n1);
                        check2(p1, n1, p2, n2);
                        stateMap.xbrlgl[p1].val[n1][p2].val[n2][id] = target;
                        break;
                    case 2:
                        check1(p1, n1);
                        stateMap.xbrlgl[p1].val[n1][id] = target;
                        break;
                    case 1:
                        stateMap.xbrlgl[id] = target;
                        break;
                }
            }
            catch(e) { console.log(e, target, path); }
        }

        var populate = function(path, enPath, current) {
            var enT, plt, target;
            var code = current.code,
                val = current.val;
            var IDs = path.split('/'),
                depth = IDs.length - 1;
            var id = IDs[depth]
            if (id.match(/^[a-z]{3,4}-[0-9]+$/)) { // ccc-nn
                try {
                    enT = lookupEN(enPath);
                    plt = getPalette(path);
                    if (enT && enT.val && enT.val.length > 0 && plt) {
                        target = {name:plt.name, code:plt.code, val:enT.val};
                        fillGL(target, path);
                    }
                }
                catch(e) { console.log(e, path, enPath, code);                }
            }
            else { // cccG-nn
                var enG = lookupEN(enPath);
                var length = val.length;
                if (enG && enG.val && enG.val.length > 0) {
                    length = enG.val.length;
                }
                for (var i = 0; i < length; i++) {
                    for (var idx in val[0]) {
                        var data = val[0][idx];
                        code = data.code;
                        var _path = path+'['+i+']/'+idx;
                        var _enPath = enPath+(code? (enPath? '['+i+']' : '')+'/'+code : '');
                        if (code.match(/BG-/)) {
                            try {
                                var enG = lookupEN(_enPath);
                                if (enG) {
                                    plt = getPalette(_path);
                                    target = {name:plt.name, code:plt.code, val:[{}]};
                                    fillGL(target, _path);
                                }
                            }
                            catch(e) { console.log(e, _path, _enPath); }
                        }
                        populate(_path, _enPath, data);
                    }
                }
            }
            // return xbrlgl;
        }

        stateMap.en = en;
        stateMap.gl_plt = buildPalette(gl_plt);
        stateMap.xbrlgl = {'corG-1': {name: 'accountingEntries', code: '', val: [{}]}};
        var current = getPalette('/corG-1');
        populate('/corG-1', '', current);
        return stateMap.xbrlgl;
    };

    function gl2xbrl(gl) {

        var appendtypedLN = function (L, ID, scenario) {
            var typedMember = xmlDoc.createElementNS(xbrldi,'typedMember'),
                number = xmlDoc.createElementNS(cor, '_'+L),
                text = xmlDoc.createTextNode(ID);
            scenario.appendChild(typedMember);
            typedMember.setAttribute('dimension', 'c:d'+L);
            typedMember.appendChild(number);
            number.appendChild(text);
        }

        var createContext = function (xmlDoc, IDs) {
            var contextText = IDs.join('');
            contextText = contextText.replace(/\[([0-9]+)\]/g, '.$1');
            if (contexts[contextText]) { return null; }
            contexts[contextText] = true;
            var context = xmlDoc.createElementNS(xbrli, 'context');
            var entity = xmlDoc.createElementNS(xbrli, 'entity');
            var identifier = xmlDoc.createElementNS(xbrli, 'identifier');
            var identifierText = xmlDoc.createTextNode('EIPA');
            var scenario = xmlDoc.createElementNS(xbrli, 'scenario');
            // var segment = xmlDoc.createElementNS(xbrli, 'segment');
            var period = xmlDoc.createElementNS(xbrli, 'period');
            var instant = xmlDoc.createElementNS(xbrli, 'instant');
            // var forever = xmlDoc.createElementNS(xbrli, 'forever');
            var instantText = xmlDoc.createTextNode(date);
            xbrl.appendChild(context);
            context.setAttribute('id', contextText);
            // entity
            context.appendChild(entity);
            entity.appendChild(identifier);
            identifier.setAttribute('scheme', eipa);
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
                    appendtypedLN('1', IDs[0], scenario);
                    break;
                case 2:
                    appendtypedLN('1', IDs[0], scenario);
                    appendtypedLN('2', IDs[1], scenario);
                    break;
                case 3:
                    appendtypedLN('1', IDs[0], scenario);
                    appendtypedLN('2', IDs[1], scenario);
                    appendtypedLN('3', IDs[2], scenario);
                    break;
                case 4:
                    appendtypedLN('1', IDs[0], scenario);
                    appendtypedLN('2', IDs[1], scenario);
                    appendtypedLN('3', IDs[2], scenario);
                    appendtypedLN('4', IDs[3], scenario);
                    break;
                case 5:
                    appendtypedLN('1', IDs[0], scenario);
                    appendtypedLN('2', IDs[1], scenario);
                    appendtypedLN('3', IDs[2], scenario);
                    appendtypedLN('4', IDs[3], scenario);
                    appendtypedLN('5', IDs[4], scenario);
                    break;
                case 6:
                    appendtypedLN('1', IDs[0], scenario);
                    appendtypedLN('2', IDs[1], scenario);
                    appendtypedLN('3', IDs[2], scenario);
                    appendtypedLN('4', IDs[3], scenario);
                    appendtypedLN('5', IDs[4], scenario);
                    appendtypedLN('6', IDs[5], scenario);
                    break;
            }
            return context;
        }

        var createItem = function (xmlDoc, path, item) {
            var module;
            var name = path.match(/[^\/]*$/)[0];
            // var _path = path.replace(/^(.*[a-z]{3,4}G?-[0-9]+)\[([0-9]+)\]\/[^\/]+$/,'$1_$2');
            path = path.replace(/\[0\]/g, '');
            path = path.replace(/-/g, '');
            path = path.replace(/cor/g, 'c');
            path = path.replace(/bus/g, 'b');
            path = path.replace(/muc/g, 'm');
            path = path.replace(/taf/g, 't');
            path = path.replace(/ehm/g, 'h');
            path = path.replace(/cen/g, 'e');
            path = path.replace(/\[([0-9]+)\]/g, '.$1');

            var keys = path.split('/');
            keys.shift(); keys.shift();
            keys.pop();
            var contextText = keys.join('');

            var match = name.match(/^[a-z]{3,4}G-/);
            if (match) {
                console.log('createItem '+name+' is Group item');
                return;
            }
            match = name.match(/^([a-z]{3,4})/);
            if (match) {
                module = 'http://www.xbrl.org/int/gl/'+match[1]+'/2020-12-31';
            }
            
            var type = '';
            if (gl_plt[name]) {
                type = gl_plt[name].type;
            }
            else {
                console.log('Not defined gl_plt['+name+']');
            }
            console.log('createItem path:'+path+' name:'+name+' type:'+type+' item:', item);

            var val = item.val;
            var element = xmlDoc.createElementNS(module, name);
            var match;
            
            switch(val.length) {
                case 1:
                    var val = item.val[0];
                    if ('object' != typeof val) {
                        if ('Percentage' == type) {
                            val /= 100;
                        }
                        val = ''+val;
                    }
                    else if (1 == Object.keys(val).length) {
                        val = JSON.stringify(val[0]);
                    }
                    else if (Object.keys(val).length > 1) {
                        val = JSON.stringify(val);
                    }
                    else if (0 === Object.keys(val).length) {
                        return null;
                    }
                    if ('Date' === type) {
                        if ('object' === typeof val && 'Array' === val.constructor.name) {
                            val = ''+val[1];
                        }
                        match = val.match(/^([0-9]{4})([0-9]{2})([0-9]{2})$/);
                        if (match) {
                            val = match[1]+'-'+match[2]+'-'+match[3];
                        }
                    }

                    createContext(xmlDoc, keys);

                    var text = xmlDoc.createTextNode(val);
                    element.appendChild(text);
                    element.setAttribute('contextRef', contextText);
                    xbrl.appendChild(element);
                    break;
                case 2:
                    var val = item.val[1];
                    if ('object' != typeof val) {
                        if ('Percentage' == type) {
                            val /= 100;
                        }
                        val = ''+val;
                    }
                    else if (0 === Object.keys(val).length) {
                        return null;
                    }
                    if ('Date' === type) {
                        if ('object' === typeof val && 'Array' === val.constructor.name) {
                            val = ''+val[1];
                        }
                        match = val.match(/^([0-9]{4})([0-9]{2})([0-9]{2})$/);
                        if (match) {
                            val = match[1]+'-'+match[2]+'-'+match[3];
                        }
                    }

                    createContext(xmlDoc, keys);

                    var text = xmlDoc.createTextNode(val);
                    element.appendChild(text);
                    element.setAttribute('contextRef', contextText);
                    xbrl.appendChild(element);
                    break;
            }
            if (['Amount', 'UnitPriceAmount', 'Quantity', 'Percentage'].indexOf(type) >= 0 ||
                'cor-22' === name) {
                element.setAttribute('decimals', 'INF');
                if (type.match(/Amount$/)) {
                    if (2 === item.val.length) {
                        var currencyID  = item.val[0]['@currencyID'];
                        if (currencyID) {
                            element.setAttribute('unitRef', currencyID);
                        }
                    }
                    else if (name.match(/VAT/)) {
                        element.setAttribute('unitRef', VAT_Currency);
                    }
                    else {
                        element.setAttribute('unitRef', InvoiceCurrency);
                    }
                }
                else if ('Percentage' == type) {
                    element.setAttribute('unitRef', 'pure');
                }
                else {
                    element.setAttribute('unitRef', 'pure');
                }
            }
        }

        var populateGL = function(xmlDoc, path, current) {
            var item;
            var IDs = path.split('/'),
                depth = IDs.length - 1;
            var id = IDs[depth]
            var val = current.val;
            if (id.match(/^[a-z]{3,4}-[0-9]+$/)) { // ccc-nn
                item = getGL(path);
                createItem(xmlDoc, path, item)
            }
            else { // cccG-nn
                var length = val.length;
                for (var i = 0; i < length; i++) {
                    for (var idx in val[i]) {
                        var data = val[i][idx];
                        code = data.code;
                        var _path = path+'['+i+']/'+idx;
                        populateGL(xmlDoc, _path, data);
                    }
                }
            }
        }
        // ---------------------------------------------------------------
        // START
        var xbrli = 'http://www.xbrl.org/2003/instance';
        var xbrldi = 'http://xbrl.org/2006/xbrldi';
        var cor = 'http://www.xbrl.org/int/gl/cor/2020-12-31';
        var eipa = 'http://eipa.jp';
        var date = (new Date()).toISOString().match(/^([0-9]{4}-[0-9]{2}-[0-9]{2})T.*$/)[1];
        var InvoiceCurrency = lookupEN('/BT-5');
        if (InvoiceCurrency && InvoiceCurrency.val) {
            InvoiceCurrency = InvoiceCurrency.val[0];
        }
        else {
            InvoiceCurrency = 'EUR';
        }
        var VAT_Currency = lookupEN('/BT-6');
        if (VAT_Currency && VAT_Currency.val) {
            VAT_Currency = VAT_Currency.val[0];
        }
        var xmlString = '<?xml version="1.0" encoding="UTF-8"?>'+
            '<xbrli:xbrl '+
                'xmlns:xbrll="http://www.xbrl.org/2003/linkbase" '+
                'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '+
                'xmlns:xlink="http://www.w3.org/1999/xlink" '+
                'xmlns:iso639="http://www.xbrl.org/2005/iso639" '+
                'xmlns:iso4217="http://www.xbrl.org/2003/iso4217" '+
                'xmlns:xbrli="'+xbrli+'" '+
                'xmlns:xbrldi="'+xbrldi+'" '+
                'xmlns:c="'+cor+'" '+
                'xmlns:b="http://www.xbrl.org/int/gl/bus/2020-12-31" '+
                'xmlns:m="http://www.xbrl.org/int/gl/muc/2020-12-31" '+
                'xmlns:t="http://www.xbrl.org/int/gl/taf/2020-12-31" '+
                'xmlns:h="http://www.xbrl.org/int/gl/ehm/2020-12-31" '+
                'xmlns:e="http://www.xbrl.org/int/gl/cen/2020-12-31">'+
            '<xbrll:schemaRef xlink:type="simple" xlink:href="../plt/case-cen/gl-plt-2020-12-31.xsd" xlink:arcrole="http://www.w3.org/1999/xlink/properties/linkbase"/>'+
            '<xbrli:unit id="pure">'+
                '<xbrli:measure>xbrli:pure</xbrli:measure>'+
            '</xbrli:unit>';
        if (InvoiceCurrency && InvoiceCurrency.match(/^[A-Z]{3}$/) && 'EUR' !== InvoiceCurrency.toUpperCase()) {
          xmlString += '<xbrli:unit id="'+InvoiceCurrency+'">'+
            '<xbrli:measure>iso4217:'+InvoiceCurrency+'</xbrli:measure></xbrli:unit>';
        }
        else {
          InvoiceCurrency = 'EUR';
          xmlString += '<xbrli:unit id="EUR"><xbrli:measure>iso4217:EUR</xbrli:measure></xbrli:unit>'
        }
        if (VAT_Currency && VAT_Currency.match(/^[A-Z]{3}$/) &&
            'EUR' !== VAT_Currency.toUpperCase() && InvoiceCurrency !== VAT_Currency) {
          xmlString += '<xbrli:unit id="'+VAT_Currency+'">'+
            '<xbrli:measure>iso4217:'+VAT_Currency+'</xbrli:measure></xbrli:unit>';
        }
        else {
          VAT_Currency = InvoiceCurrency;
        }
        xmlString += '</xbrli:xbrl>';
        var contexts = {};

        var DOMP = new DOMParser();
        var xmlDoc = DOMP.parseFromString(xmlString, 'text/xml');
        var current = getGL('/corG-1');
        var xbrl = xmlDoc.getElementsByTagNameNS(xbrli, 'xbrl')[0];

        populateGL(xmlDoc, '/corG-1', current);
       
        var XMLS = new XMLSerializer();
        var xmlStr = XMLS.serializeToString(xmlDoc);
        return xmlStr;
    };

    var initModule = function(url, ms) {
        return ajaxRequest(url, null, 'GET', ms)
        .then(function(res) {
            // console.log(res);
            if (res.match(/^<html>/)) {
                alert(res.match(/<title>(.*)<\/title>/)[1]);
                return null;
            }
            try {
                var json = JSON.parse(res),
                    en;
                if (url.match(/\/cii\//)) {
                en = invoice2xbrl.cii2en(json);
                }
                else if (url.match(/\/ubl\//)) {
                en = invoice2xbrl.ubl2en(json);
                }
                // console.log(JSON.stringify(en));
                return en;
            }
            catch(e) { console.log(e); }
        })
        .then(function(en) {
            var gl = en2gl(en);
            return gl;
        })
        .then(function(gl) {
            // console.log(JSON.stringify(gl));
            var xbrl = gl2xbrl(gl);
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
              'name': 'xbrl-gl_'+name,
              'data': xbrl
            };
            return ajaxRequest('data/save.cgi', data, 'POST', 20000)
            .then(function(res) {
              console.log(res);
              return res;
            })
            .catch(function(err) { console.log(err); })
          })
          .catch(function(err) { console.log(err); })
    };

    return {
        lookupEN: lookupEN,
        getPalette: getPalette,
        en2gl: en2gl,
        initModule: initModule
    };
})();
// invoice2gl.js