/**
 * en2gl_mapping.js
 *
 * This is a free to use open source software and licensed under the MIT License
 * CC-SA-BY Copyright (c) 2020, Sambuichi Professional Engineers Office
 **/
var en2glMapping = (function() {
    /**
    ([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)
    "$1":{"level":"$2","module":"$3","name":"$4","path":"$5","code":"$6","Card":"$7","BG-4":"$8","BG-5":"$9","BG-6":"$10","BG-11":"$11","BG-12":"$12","BG-7":"$13","BG-8":"$14","BG-9":"$15","BG-10":"$16","BG-13":"$17"},
    id level module name path code Card BG-4 BG-5 BG-6 BG-11 BG-12 BG-7 BG-8 BG-9 BG-10 BG-13
    1  2     3      4    5    6    7    8    9    10   11    12    13   14   15   16    17  
    */
    var gl_plt = {
        "corG-1":{"level":"1","module":"cor","name":"accountingEntries","path":"/corG-1","code":"","Card":"","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "corG-2":{"level":"2","module":"cor","name":"documentInfo","path":"/corG-1/corG-2","code":"","Card":"","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cor-76":{"level":"3","module":"cor","name":"documentNumber","path":"/corG-1/corG-2/cor-76","code":"BT-1","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cor-79":{"level":"3","module":"cor","name":"documentDate","path":"/corG-1/corG-2/cor-79","code":"BT-2","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cor-73":{"level":"3","module":"cor","name":"documentType","path":"/corG-1/corG-2/cor-73","code":"BT-3","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "muc-4":{"level":"3","module":"muc","name":"amountOriginalCurrency","path":"/corG-1/corG-2/muc-4","code":"BT-5","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cor-43":{"level":"3","module":"cor","name":"postingDate","path":"/corG-1/corG-2/cor-43","code":"BT-7","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-8":{"level":"3","module":"cen","name":"ValueAddedTaxPointDateCode","path":"/corG-1/corG-2/cen-8","code":"BT-8","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cenG-16":{"level":"3","module":"cen","name":"PAYMENT_INSTRUCTIONS","path":"/corG-1/corG-2/cenG-16","code":"BG-16","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-82":{"level":"4","module":"cen","name":"PaymentMeansText","path":"/corG-1/corG-2/cenG-16/cen-82","code":"BT-82","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-83":{"level":"4","module":"cen","name":"RemittanceInformation","path":"/corG-1/corG-2/cenG-16/cen-83","code":"BT-83","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cenG-17":{"level":"4","module":"cen","name":"CREDIT_TRANSFER","path":"/corG-1/corG-2/cenG-16/cenG-17","code":"BG-17","Card":"0..n","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-84":{"level":"5","module":"cen","name":"PaymentAccountIdentifier","path":"/corG-1/corG-2/cenG-16/cenG-17/cen-84","code":"BT-84","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-85":{"level":"5","module":"cen","name":"PaymentAccountName","path":"/corG-1/corG-2/cenG-16/cenG-17/cen-85","code":"BT-85","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-86":{"level":"5","module":"cen","name":"PaymentServiceProviderIdentifier","path":"/corG-1/corG-2/cenG-16/cenG-17/cen-86","code":"BT-86","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cenG-18":{"level":"4","module":"cen","name":"PAYMENT_CARD_INFORMATION","path":"/corG-1/corG-2/cenG-16/cenG-18","code":"BG-18","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-87":{"level":"5","module":"cen","name":"PaymentCardPrimaryAccountNumber","path":"/corG-1/corG-2/cenG-16/cenG-18/cen-87","code":"BT-87","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-88":{"level":"5","module":"cen","name":"PaymentCardHolderName","path":"/corG-1/corG-2/cenG-16/cenG-18/cen-88","code":"BT-88","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cenG-19":{"level":"4","module":"cen","name":"DIRECT_DEBIT","path":"/corG-1/corG-2/cenG-16/cenG-19","code":"BG-19","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-89":{"level":"5","module":"cen","name":"MandateReferenceIdentifier","path":"/corG-1/corG-2/cenG-16/cenG-19/cen-89","code":"BT-89","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-90":{"level":"5","module":"cen","name":"BankAssignedCreditorIdentifier","path":"/corG-1/corG-2/cenG-16/cenG-19/cen-90","code":"BT-90","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-91":{"level":"5","module":"cen","name":"DebitedAccountIdentifier","path":"/corG-1/corG-2/cenG-16/cenG-19/cen-91","code":"BT-91","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cenG-3":{"level":"3","module":"cen","name":"PRECEDING_INVOICE_REFERENCE","path":"/corG-1/corG-2/cenG-3","code":"BG-3","Card":"0..n","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "tafG-1":{"level":"4","module":"taf","name":"originatingDocumentStructure","path":"/corG-1/corG-2/cenG-3/tafG-1","code":"","Card":"","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "taf-4":{"level":"5","module":"taf","name":"originatingDocumentType","path":"/corG-1/corG-2/cenG-3/tafG-1/taf-4","code":"","Card":"","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "taf-5":{"level":"5","module":"taf","name":"originatingDocumentNumber","path":"/corG-1/corG-2/cenG-3/tafG-1/taf-5","code":"BT-25 BT-11 BT-13 BT-15 BT-17","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "taf-6":{"level":"5","module":"taf","name":"originatingDocumentDate","path":"/corG-1/corG-2/cenG-3/tafG-1/taf-6","code":"BT-26","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "taf-5":{"level":"5","module":"taf","name":"originatingDocumentNumber","path":"/corG-1/corG-2/cenG-3/tafG-1/taf-5","code":"BT-132","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-18":{"level":"3","module":"cen","name":"InvoicedObjectIdentifier","path":"/corG-1/corG-2/cen-18","code":"BT-18","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cenG-1":{"level":"3","module":"cen","name":"INVOICE_NOTE","path":"/corG-1/corG-2/cenG-1","code":"BG-1","Card":"0..n","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-21":{"level":"4","module":"cen","name":"InvoiceNoteSubjectCode","path":"/corG-1/corG-2/cenG-1/cen-21","code":"BT-21","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cor-7":{"level":"3","module":"cor","name":"entriesComment","path":"/corG-1/corG-2/cor-7","code":"BT-22","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cenG-2":{"level":"3","module":"cen","name":"PROCESS_CONTROL","path":"/corG-1/corG-2/cenG-2","code":"BG-2","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-23":{"level":"4","module":"cen","name":"BusinessProcessType","path":"/corG-1/corG-2/cenG-2/cen-23","code":"BT-23","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-24":{"level":"4","module":"cen","name":"SpecificationIdentifier","path":"/corG-1/corG-2/cenG-2/cen-24","code":"BT-24","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "taf-4":{"level":"5","module":"taf","name":"originatingDocumentType","path":"/corG-1/corG-2/cenG-2/cen-24/taf-4","code":"BT-133","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cenG-24":{"level":"3","module":"cen","name":"ADDITIONAL_SUPPORTING_DOCUMENTS","path":"/corG-1/corG-2/cenG-24","code":"BG-24","Card":"0..n","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-122":{"level":"4","module":"cen","name":"SupportingDocumentReference","path":"/corG-1/corG-2/cenG-24/cen-122","code":"BT-122","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-123":{"level":"4","module":"cen","name":"SupportingDocumentDescription","path":"/corG-1/corG-2/cenG-24/cen-123","code":"BT-123","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-124":{"level":"4","module":"cen","name":"ExternalDocumentLocation","path":"/corG-1/corG-2/cenG-24/cen-124","code":"BT-124","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-125":{"level":"4","module":"cen","name":"AttachedDocument","path":"/corG-1/corG-2/cenG-24/cen-125","code":"BT-125","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-125A":{"level":"4","module":"cen","name":"AttachedDocumentMimeCode","path":"/corG-1/corG-2/cenG-24/cen-125A","code":"BT-125A","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-125B":{"level":"4","module":"cen","name":"AttachedDocumentFilename","path":"/corG-1/corG-2/cenG-24/cen-125B","code":"BT-125B","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "corG-3":{"level":"2","module":"cor","name":"entityInformation","path":"/corG-1/corG-3","code":"","Card":"","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "corG-9":{"level":"3","module":"cor","name":"identifierReference","path":"/corG-1/corG-3/corG-9","code":"BG-4 BG-11 BG-7 BG-10 BG-13","Card":"1..1","BG-4":"BG-4","BG-5":"","BG-6":"","BG-11":"BG-11","BG-12":"","BG-7":"BG-7","BG-8":"","BG-9":"","BG-10":"BG-10","BG-13":"BG-13","BG-29":"","BG-31":""},
        "cor-51":{"level":"4","module":"cor","name":"identifierType","path":"/corG-1/corG-3/corG-9/cor-51","code":"","Card":"","BG-4":"SELLER","BG-5":"","BG-6":"","BG-11":"SELLERTAXREPRESENTATIVEPARTY","BG-12":"","BG-7":"BUYER","BG-8":"","BG-9":"","BG-10":"PAYEE","BG-13":"DELIVERYINFORMATION","BG-29":"","BG-31":""},
        "cor-44":{"level":"4","module":"cor","name":"identifierCode","path":"/corG-1/corG-3/corG-9/cor-44","code":"BT-29 BT-46 BT-60","Card":"0..n","BG-4":"BT-29","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"BT-46","BG-8":"","BG-9":"","BG-10":"BT-60","BG-13":"","BG-29":"","BG-31":""},
        "cor-45":{"level":"4","module":"cor","name":"identifierAuthorityCode","path":"/corG-1/corG-3/corG-9/cor-45","code":"BT-30 BT-47 BT-61","Card":"0..1","BG-4":"BT-30","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"BT-47","BG-8":"","BG-9":"","BG-10":"BT-61","BG-13":"","BG-29":"","BG-31":""},
        "cor-45":{"level":"4","module":"cor","name":"identifierAuthorityCode","path":"/corG-1/corG-3/corG-9/cor-45","code":"BT-31 BT-63 BT-48","Card":"0..1","BG-4":"BT-31","BG-5":"","BG-6":"","BG-11":"BT-63","BG-12":"","BG-7":"BT-48","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cor-45":{"level":"4","module":"cor","name":"identifierAuthorityCode","path":"/corG-1/corG-3/corG-9/cor-45","code":"BT-32","Card":"0..1","BG-4":"BT-32","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cor-46":{"level":"4","module":"cor","name":"identifierAuthority","path":"/corG-1/corG-3/corG-9/cor-46","code":"BT-30A BT-47A BT-61A","Card":"0..1","BG-4":"BT-30A","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"BT-47A","BG-8":"","BG-9":"","BG-10":"BT-61A","BG-13":"","BG-29":"","BG-31":""},
        "cor-50":{"level":"4","module":"cor","name":"identifierDescription","path":"/corG-1/corG-3/corG-9/cor-50","code":"BT-27 BT-62 BT-44 BT-59 BT-70","Card":"1..1","BG-4":"BT-27","BG-5":"","BG-6":"","BG-11":"BT-62","BG-12":"","BG-7":"BT-44","BG-8":"","BG-9":"","BG-10":"BT-59","BG-13":"BT-70","BG-29":"","BG-31":""},
        "cen-28":{"level":"4","module":"cen","name":"tradingName","path":"/corG-1/corG-3/corG-9/cen-28","code":"BT-28 BT-45","Card":"0..1","BG-4":"BT-28","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"BT-45","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-33":{"level":"4","module":"cen","name":"additionalLegalInformation","path":"/corG-1/corG-3/corG-9/cen-33","code":"BT-33","Card":"0..1","BG-4":"BT-33","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "busG-20":{"level":"4","module":"bus","name":"identifierAddress","path":"/corG-1/corG-3/corG-9/busG-20","code":"BG-5 BG-12 BG-8 BG-15","Card":"1..1","BG-4":"","BG-5":"BG-5","BG-6":"","BG-11":"","BG-12":"BG-12","BG-7":"","BG-8":"BG-8","BG-9":"","BG-10":"","BG-13":"BG-15","BG-29":"","BG-31":""},
        "bus-124":{"level":"5","module":"bus","name":"identifierStreet","path":"/corG-1/corG-3/corG-9/busG-20/bus-124","code":"BT-35 BT-64 BT-50 BT-75","Card":"0..1","BG-4":"","BG-5":"BT-35","BG-6":"","BG-11":"","BG-12":"BT-64","BG-7":"","BG-8":"BT-50","BG-9":"","BG-10":"","BG-13":"BT-75","BG-29":"","BG-31":""},
        "bus-125":{"level":"5","module":"bus","name":"identifierAddressStreet2","path":"/corG-1/corG-3/corG-9/busG-20/bus-125","code":"BT-36 BT-65 BT-51 BT-76","Card":"0..1","BG-4":"","BG-5":"BT-36","BG-6":"","BG-11":"","BG-12":"BT-65","BG-7":"","BG-8":"BT-51","BG-9":"","BG-10":"","BG-13":"BT-76","BG-29":"","BG-31":""},
        "cen-162":{"level":"5","module":"cen","name":"AddressLine3","path":"/corG-1/corG-3/corG-9/busG-20/cen-162","code":"BT-162 BT-164 BT-163 BT-165","Card":"0..1","BG-4":"","BG-5":"BT-162","BG-6":"","BG-11":"","BG-12":"BT-164","BG-7":"","BG-8":"BT-163","BG-9":"","BG-10":"","BG-13":"BT-165","BG-29":"","BG-31":""},
        "bus-126":{"level":"5","module":"bus","name":"identifierCity","path":"/corG-1/corG-3/corG-9/busG-20/bus-126","code":"BT-37 BT-66 BT-52 BT-77","Card":"0..1","BG-4":"","BG-5":"BT-37","BG-6":"","BG-11":"","BG-12":"BT-66","BG-7":"","BG-8":"BT-52","BG-9":"","BG-10":"","BG-13":"BT-77","BG-29":"","BG-31":""},
        "bus-127":{"level":"5","module":"bus","name":"identifierStateOrProvince","path":"/corG-1/corG-3/corG-9/busG-20/bus-127","code":"BT-39 BT-68 BT-54 BT-79","Card":"0..1","BG-4":"","BG-5":"BT-39","BG-6":"","BG-11":"","BG-12":"BT-68","BG-7":"","BG-8":"BT-54","BG-9":"","BG-10":"","BG-13":"BT-79","BG-29":"","BG-31":""},
        "bus-128":{"level":"5","module":"bus","name":"identifierCountry","path":"/corG-1/corG-3/corG-9/busG-20/bus-128","code":"BT-40 BT-69 BT-55 BT-80","Card":"1..1","BG-4":"","BG-5":"BT-40","BG-6":"","BG-11":"","BG-12":"BT-69","BG-7":"","BG-8":"BT-55","BG-9":"","BG-10":"","BG-13":"BT-80","BG-29":"","BG-31":""},
        "bus-129":{"level":"5","module":"bus","name":"identifierZipOrPostalCode","path":"/corG-1/corG-3/corG-9/busG-20/bus-129","code":"BT-38 BT-67 BT-53 BT-78","Card":"0..1","BG-4":"","BG-5":"BT-38","BG-6":"","BG-11":"","BG-12":"BT-67","BG-7":"","BG-8":"BT-53","BG-9":"","BG-10":"","BG-13":"BT-78","BG-29":"","BG-31":""},
        "bus-130":{"level":"5","module":"bus","name":"identifierAddressLocationIdentifier","path":"/corG-1/corG-3/corG-9/busG-20/bus-130","code":"BT-71","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"BT-71","BG-29":"","BG-31":""},
        "corG-14":{"level":"4","module":"cor","name":"identifierContactInformationStructure","path":"/corG-1/corG-3/corG-9/corG-14","code":"BG-6 BG-9","Card":"0..1","BG-4":"","BG-5":"","BG-6":"BG-6","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"BG-9","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cor-63":{"level":"5","module":"cor","name":"identifierContactAttentionLine","path":"/corG-1/corG-3/corG-9/corG-14/cor-63","code":"BT-41 BT-56","Card":"0..1","BG-4":"","BG-5":"","BG-6":"BT-41","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"BT-56","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cor-66":{"level":"6","module":"cor","name":"identifierContactPhoneNumber","path":"/corG-1/corG-3/corG-9/corG-14/cor-63/cor-66","code":"BT-42 BT-57","Card":"0..1","BG-4":"","BG-5":"","BG-6":"BT-42","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"BT-57","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-34":{"level":"6","module":"cen","name":"organizationAddressStreet3","path":"/corG-1/corG-3/corG-9/corG-14/cor-63/cen-34","code":"BT-34 BT-49","Card":"0..1","BG-4":"","BG-5":"","BG-6":"BT-34","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"BT-49","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cor-70":{"level":"6","module":"cor","name":"identifierContactEmailAddress","path":"/corG-1/corG-3/corG-9/corG-14/cor-63/cor-70","code":"BT-43 BT-58","Card":"0..1","BG-4":"","BG-5":"","BG-6":"BT-43","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"BT-58","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "bus-35":{"level":"6","module":"bus","name":"contactAttentionLine","path":"/corG-1/corG-3/corG-9/corG-14/cor-63/bus-35","code":"BT-10","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"BT-10","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "busG-18":{"level":"3","module":"bus","name":"reportingCalendar","path":"/corG-1/corG-3/busG-18","code":"","Card":"","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cenG-14":{"level":"4","module":"cen","name":"INVOICING_PERIOD","path":"/corG-1/corG-3/busG-18/cenG-14","code":"BG-14","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cor-8":{"level":"5","module":"cor","name":"periodCoveredStart","path":"/corG-1/corG-3/busG-18/cenG-14/cor-8","code":"BT-73","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cor-9":{"level":"5","module":"cor","name":"periodCoveredEnd","path":"/corG-1/corG-3/busG-18/cenG-14/cor-9","code":"BT-74","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "corG-4":{"level":"2","module":"cor","name":"entryHeader","path":"/corG-1/corG-4","code":"","Card":"","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cenG-20":{"level":"3","module":"cen","name":"DOCUMENT_LEVEL_ALLOWANCES","path":"/corG-1/corG-4/cenG-20","code":"BG-20","Card":"0..n","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cor-40":{"level":"4","module":"cor","name":"amount","path":"/corG-1/corG-4/cenG-20/cor-40","code":"BT-92","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cor-99":{"level":"4","module":"cor","name":"taxCode","path":"/corG-1/corG-4/cenG-20/cor-99","code":"BT-95","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cor-98":{"level":"4","module":"cor","name":"taxPercentageRate","path":"/corG-1/corG-4/cenG-20/cor-98","code":"BT-96","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-93":{"level":"4","module":"cen","name":"DocumentLevelAllowanceBaseAmount","path":"/corG-1/corG-4/cenG-20/cen-93","code":"BT-93","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-94":{"level":"4","module":"cen","name":"DocumentLevelAllowancePercentage","path":"/corG-1/corG-4/cenG-20/cen-94","code":"BT-94","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-97":{"level":"4","module":"cen","name":"DocumentLevelAllowanceReason","path":"/corG-1/corG-4/cenG-20/cen-97","code":"BT-97","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-98":{"level":"4","module":"cen","name":"DocumentLevelAllowanceReasonCode","path":"/corG-1/corG-4/cenG-20/cen-98","code":"BT-98","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cenG-21":{"level":"3","module":"cen","name":"DOCUMENT_LEVEL_CHARGES","path":"/corG-1/corG-4/cenG-21","code":"BG-21","Card":"0..n","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cor-40":{"level":"4","module":"cor","name":"amount","path":"/corG-1/corG-4/cenG-21/cor-40","code":"BT-99","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cor-99":{"level":"4","module":"cor","name":"taxCode","path":"/corG-1/corG-4/cenG-21/cor-99","code":"BT-102","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cor-98":{"level":"4","module":"cor","name":"taxPercentageRate","path":"/corG-1/corG-4/cenG-21/cor-98","code":"BT-103","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-100":{"level":"4","module":"cen","name":"DocumentLevelChargeBaseAmount","path":"/corG-1/corG-4/cenG-21/cen-100","code":"BT-100","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-101":{"level":"4","module":"cen","name":"DocumentLevelChargePercentage","path":"/corG-1/corG-4/cenG-21/cen-101","code":"BT-101","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-104":{"level":"4","module":"cen","name":"DocumentLevelChargeReason","path":"/corG-1/corG-4/cenG-21/cen-104","code":"BT-104","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-105":{"level":"4","module":"cen","name":"DocumentLevelChargeReasonCode","path":"/corG-1/corG-4/cenG-21/cen-105","code":"BT-105","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cenG-22":{"level":"3","module":"cen","name":"DOCUMENT_TOTALS","path":"/corG-1/corG-4/cenG-22","code":"BG-22","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-106":{"level":"4","module":"cen","name":"SumOfInvoiceLineNetAmount","path":"/corG-1/corG-4/cenG-22/cen-106","code":"BT-106","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-107":{"level":"4","module":"cen","name":"SumOfAllowancesOnDocumentLevel","path":"/corG-1/corG-4/cenG-22/cen-107","code":"BT-107","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-108":{"level":"4","module":"cen","name":"SumOfChargesOnDocumentLevel","path":"/corG-1/corG-4/cenG-22/cen-108","code":"BT-108","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-109":{"level":"4","module":"cen","name":"InvoiceTotalAmountWithoutVAT","path":"/corG-1/corG-4/cenG-22/cen-109","code":"BT-109","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-111":{"level":"4","module":"cen","name":"InvoiceTotalVATAmountInAccountingCurrency","path":"/corG-1/corG-4/cenG-22/cen-111","code":"BT-111","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-112":{"level":"4","module":"cen","name":"InvoiceTotalAmountWithVAT","path":"/corG-1/corG-4/cenG-22/cen-112","code":"BT-112","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-113":{"level":"4","module":"cen","name":"PaidAmount","path":"/corG-1/corG-4/cenG-22/cen-113","code":"BT-113","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-114":{"level":"4","module":"cen","name":"RoundingAmount","path":"/corG-1/corG-4/cenG-22/cen-114","code":"BT-114","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-115":{"level":"4","module":"cen","name":"AmountDueForPayment","path":"/corG-1/corG-4/cenG-22/cen-115","code":"BT-115","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cenG-23":{"level":"3","module":"cen","name":"VAT_BREAKDOWN","path":"/corG-1/corG-4/cenG-23","code":"BG-23","Card":"1..n","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-116":{"level":"4","module":"cen","name":"VATCategoryTaxableAmount","path":"/corG-1/corG-4/cenG-23/cen-116","code":"BT-116","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-117":{"level":"4","module":"cen","name":"VATCategoryTaxAmount","path":"/corG-1/corG-4/cenG-23/cen-117","code":"BT-117","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-118":{"level":"4","module":"cen","name":"VATCategoryCode","path":"/corG-1/corG-4/cenG-23/cen-118","code":"BT-118","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-119":{"level":"4","module":"cen","name":"VATCategoryRate","path":"/corG-1/corG-4/cenG-23/cen-119","code":"BT-119","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-120":{"level":"4","module":"cen","name":"VATExemptionReasonText","path":"/corG-1/corG-4/cenG-23/cen-120","code":"BT-120","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-121":{"level":"4","module":"cen","name":"VATExemptionReasonCode","path":"/corG-1/corG-4/cenG-23/cen-121","code":"BT-121","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "corG-5":{"level":"3","module":"cor","name":"entryDetail","path":"/corG-1/corG-4/corG-5","code":"BG-25","Card":"1..n","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cor-21":{"level":"4","module":"cor","name":"lineNumber","path":"/corG-1/corG-4/corG-5/cor-21","code":"BT-128","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cor-22":{"level":"4","module":"cor","name":"lineNumberCounter","path":"/corG-1/corG-4/corG-5/cor-22","code":"BT-126","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cor-23":{"level":"4","module":"cor","name":"accountMainID","path":"/corG-1/corG-4/corG-5/cor-23","code":"BT-19","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-131":{"level":"4","module":"cen","name":"InvoiceLineNetAmount","path":"/corG-1/corG-4/corG-5/cen-131","code":"BT-131","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-136":{"level":"4","module":"cen","name":"InvoiceLineAllowanceAmount","path":"/corG-1/corG-4/corG-5/cen-136","code":"BT-136","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-141":{"level":"4","module":"cen","name":"InvoiceLineChargeAmount","path":"/corG-1/corG-4/corG-5/cen-141","code":"BT-141","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "bus-135":{"level":"4","module":"bus","name":"paymentMethod","path":"/corG-1/corG-4/corG-5/bus-135","code":"BT-81","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cor-85":{"level":"4","module":"cor","name":"detailComment","path":"/corG-1/corG-4/corG-5/cor-85","code":"BT-127","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cor-89":{"level":"4","module":"cor","name":"shipReceivedDate","path":"/corG-1/corG-4/corG-5/cor-89","code":"BT-72","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cor-90":{"level":"4","module":"cor","name":"maturityDate","path":"/corG-1/corG-4/corG-5/cor-90","code":"BT-9","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cor-91":{"level":"4","module":"cor","name":"terms","path":"/corG-1/corG-4/corG-5/cor-91","code":"BT-20","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "busG-21":{"level":"4","module":"bus","name":"measurable","path":"/corG-1/corG-4/corG-5/busG-21","code":"BG-29","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"BG-29","BG-31":""},
        "cen-146":{"level":"5","module":"cen","name":"ItemNetPrice","path":"/corG-1/corG-4/corG-5/busG-21/cen-146","code":"BT-146","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"BT-146","BG-31":""},
        "cen-147":{"level":"5","module":"cen","name":"ItemPriceDiscount","path":"/corG-1/corG-4/corG-5/busG-21/cen-147","code":"BT-147","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"BT-147","BG-31":""},
        "cen-148":{"level":"5","module":"cen","name":"ItemGrossPrice","path":"/corG-1/corG-4/corG-5/busG-21/cen-148","code":"BT-148","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"BT-148","BG-31":""},
        "bus-144":{"level":"5","module":"bus","name":"measurableQuantity","path":"/corG-1/corG-4/corG-5/busG-21/bus-144","code":"BT-149","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"BT-149","BG-31":""},
        "bus-146":{"level":"5","module":"bus","name":"measurableUnitOfMeasure","path":"/corG-1/corG-4/corG-5/busG-21/bus-146","code":"BT-150","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"BT-150","BG-31":""},
        "busG-21":{"level":"4","module":"bus","name":"measurable","path":"/corG-1/corG-4/corG-5/busG-21","code":"BG-31","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":"BG-31"},
        "bus-143":{"level":"5","module":"bus","name":"measurableDescription","path":"/corG-1/corG-4/corG-5/busG-21/bus-143","code":"BT-153","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":"BT-153"},
        "cen-155":{"level":"5","module":"cen","name":"ItemSellersIdentifier","path":"/corG-1/corG-4/corG-5/busG-21/cen-155","code":"BT-155","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":"BT-155"},
        "cen-156":{"level":"5","module":"cen","name":"ItemBuyersIdentifier","path":"/corG-1/corG-4/corG-5/busG-21/cen-156","code":"BT-156","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":"BT-156"},
        "bus-139":{"level":"5","module":"bus","name":"measurableID","path":"/corG-1/corG-4/corG-5/busG-21/bus-139","code":"BT-157","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":"BT-157"},
        "bus-140":{"level":"5","module":"bus","name":"measurableIDSchema","path":"/corG-1/corG-4/corG-5/busG-21/bus-140","code":"BT-157A","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":"BT-157A"},
        "bus-144":{"level":"5","module":"bus","name":"measurableQuantity","path":"/corG-1/corG-4/corG-5/busG-21/bus-144","code":"BT-129","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":"BT-129"},
        "bus-145":{"level":"5","module":"bus","name":"measurableQualifier","path":"/corG-1/corG-4/corG-5/busG-21/bus-145","code":"BT-158","Card":"0..n","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":"BT-158"},
        "cen-159":{"level":"5","module":"cen","name":"itemCountryOfOrigin","path":"/corG-1/corG-4/corG-5/busG-21/cen-159","code":"BT-159","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":"BT-159"},
        "bus-146":{"level":"5","module":"bus","name":"measurableUnitOfMeasure","path":"/corG-1/corG-4/corG-5/busG-21/bus-146","code":"BT-130","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":"BT-130"},
        "cenG-26":{"level":"4","module":"cen","name":"INVOICE_LINE_PERIOD","path":"/corG-1/corG-4/corG-5/cenG-26","code":"BG-26","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "bus-148":{"level":"5","module":"bus","name":"measurableStartDateTime","path":"/corG-1/corG-4/corG-5/cenG-26/bus-148","code":"BT-134","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "bus-149":{"level":"5","module":"bus","name":"measurableEndDateTime","path":"/corG-1/corG-4/corG-5/cenG-26/bus-149","code":"BT-135","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "corG-19":{"level":"4","module":"cor","name":"taxes","path":"/corG-1/corG-4/corG-5/corG-19","code":"BG-30","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cor-95":{"level":"5","module":"cor","name":"taxAmount","path":"/corG-1/corG-4/corG-5/corG-19/cor-95","code":"BT-110","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cor-95":{"level":"5","module":"cor","name":"taxAmount","path":"/corG-1/corG-4/corG-5/corG-19/cor-95","code":"BT-117","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cor-98":{"level":"5","module":"cor","name":"taxPercentageRate","path":"/corG-1/corG-4/corG-5/corG-19/cor-98","code":"BT-119","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cor-98":{"level":"5","module":"cor","name":"taxPercentageRate","path":"/corG-1/corG-4/corG-5/corG-19/cor-98","code":"BT-152","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cor-99":{"level":"5","module":"cor","name":"taxCode","path":"/corG-1/corG-4/corG-5/corG-19/cor-99","code":"BT-118","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cor-99":{"level":"5","module":"cor","name":"taxCode","path":"/corG-1/corG-4/corG-5/corG-19/cor-99","code":"BT-151","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "muc-33":{"level":"5","module":"muc","name":"taxCurrency","path":"/corG-1/corG-4/corG-5/corG-19/muc-33","code":"BT-6","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cenG-27":{"level":"4","module":"cen","name":"INVOICE_LINE_ALLOWANCES","path":"/corG-1/corG-4/corG-5/cenG-27","code":"BG-27","Card":"0..n","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-137":{"level":"5","module":"cen","name":"InvoiceLineAllowanceBaseAmount","path":"/corG-1/corG-4/corG-5/cenG-27/cen-137","code":"BT-137","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-138":{"level":"5","module":"cen","name":"InvoiceLineAllowancePercentage","path":"/corG-1/corG-4/corG-5/cenG-27/cen-138","code":"BT-138","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-139":{"level":"5","module":"cen","name":"InvoiceLineAllowanceReason","path":"/corG-1/corG-4/corG-5/cenG-27/cen-139","code":"BT-139","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-140":{"level":"5","module":"cen","name":"InvoiceLineAllowanceReasonCode","path":"/corG-1/corG-4/corG-5/cenG-27/cen-140","code":"BT-140","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cenG-28":{"level":"4","module":"cen","name":"INVOICE_LINE_CHARGES","path":"/corG-1/corG-4/corG-5/cenG-28","code":"BG-28","Card":"0..n","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-142":{"level":"5","module":"cen","name":"InvoiceLineChargeBaseAmount","path":"/corG-1/corG-4/corG-5/cenG-28/cen-142","code":"BT-142","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-143":{"level":"5","module":"cen","name":"InvoiceLineChargePercentage","path":"/corG-1/corG-4/corG-5/cenG-28/cen-143","code":"BT-143","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-144":{"level":"5","module":"cen","name":"InvoiceLineChargeReason","path":"/corG-1/corG-4/corG-5/cenG-28/cen-144","code":"BT-144","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-145":{"level":"5","module":"cen","name":"InvoiceLineChargeReasonCode","path":"/corG-1/corG-4/corG-5/cenG-28/cen-145","code":"BT-145","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-154":{"level":"5","module":"cen","name":"ItemDescription","path":"/corG-1/corG-4/corG-5/cenG-28/cen-154","code":"BT-154","Card":"0..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cenG-32":{"level":"4","module":"cen","name":"ITEM_ATTRIBUTES","path":"/corG-1/corG-4/corG-5/cenG-32","code":"BG-32","Card":"0..n","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-160":{"level":"5","module":"cen","name":"ItemAttributeName","path":"/corG-1/corG-4/corG-5/cenG-32/cen-160","code":"BT-160","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""},
        "cen-161":{"level":"5","module":"cen","name":"ItemAttributeValue","path":"/corG-1/corG-4/corG-5/cenG-32/cen-161","code":"BT-161","Card":"1..1","BG-4":"","BG-5":"","BG-6":"","BG-11":"","BG-12":"","BG-7":"","BG-8":"","BG-9":"","BG-10":"","BG-13":"","BG-29":"","BG-31":""}
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
        xbrl = fill(gl_plt);
        // console.log(xbrl);
    }

    return {
        gl_plt: gl_plt,
        lookupEN: lookupEN,
        getPalette: getPalette,
        fill: fill,
        initModule: initModule
    }
})();
// en2gl_mapping.js