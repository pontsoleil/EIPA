/**
 * en2gl_mapping.js
 *
 * This is a free to use open source software and licensed under the MIT License
 * CC-SA-BY Copyright (c) 2020, Sambuichi Professional Engineers Office
 **/
var en2glMapping = (function() {
    var en2gl = {
        "BT-1":{"seq":1,"level":1,"term":"Invoice number","code":"cor-76","path":"/corG-1/corG-2/cor-76"},
        "BT-2":{"seq":2,"level":1,"term":"Invoice issue date","code":"cor-79","path":"/corG-1/corG-2/cor-79"},
        "BT-3":{"seq":3,"level":1,"term":"Invoice type code","code":"cor-73","path":"/corG-1/corG-2/cor-73"},
        "BT-5":{"seq":4,"level":1,"term":"Invoice currency code","code":"muc-4","path":"/corG-1/corG-2/muc-4"},
        "BT-6":{"seq":5,"level":1,"term":"VAT accounting currency code","code":"muc-33","path":"/corG-1/corG-2/muc-33"},
        "BT-7":{"seq":6,"level":1,"term":"Value added tax point date","code":"cor-43","path":"/corG-1/corG-2/cor-43"},
        "BT-8":{"seq":7,"level":1,"term":"Value added tax point date code","code":"cen-8","path":"/corG-1/corG-2/cen-8"},
        "BT-9":{"seq":8,"level":1,"term":"Payment due date","code":"cor-90","path":"/corG-1/corG-2/cor-90"},
        "BT-10":{"seq":9,"level":1,"term":"Buyer reference","code":"bus-35","path":"/corG-1/ corG-2/bus-35"},
        "BT-11":{"seq":12,"level":1,"term":"Project reference","code":"taf-5","path":"/corG-1/corG-2/cenG-3/tafG-1/taf-5"},
        "BT-13":{"seq":13,"level":1,"term":"Purchase order reference ","code":"taf-5","path":"/corG-1/corG-2/cenG-3/tafG-1/taf-5"},
        "BT-15":{"seq":14,"level":1,"term":"Receiving advice reference","code":"taf-5","path":"/corG-1/corG-2/cenG-3/tafG-1/taf-5"},
        "BT-17":{"seq":15,"level":1,"term":"Tender or lot reference","code":"taf-5","path":"/corG-1/corG-2/cenG-3/tafG-1/taf-5"},
        "BT-18":{"seq":16,"level":1,"term":"Invoiced object identifier","code":"cen-18","path":"/corG-1/corG-2/cen-18"},
        "BT-19":{"seq":18,"level":1,"term":"Buyer accounting reference","code":"cor-23","path":"/corG-1/corG-2/cor-23"},
        "BT-20":{"seq":19,"level":1,"term":"Payment terms","code":"cor-91","path":"/corG-1/corG-2/cor-91"},
        "BG-1":{"seq":20,"level":1,"term":"INVOICE NOTE","code":"cenG-1","path":"/corG-1/corG-2/cenG-1"},
        "BT-21":{"seq":21,"level":2,"term":"Invoice note subject code","code":"cen-21","path":"/corG-1/corG-2/cenG-1/cen-21"},
        "BG-2":{"seq":23,"level":1,"term":"PROCESS CONTROL","code":"cenG-2","path":"/corG-1/corG-2/cenG-2"},
        "BT-23":{"seq":24,"level":2,"term":"Business process type","code":"cen-23","path":"/corG-1/corG-2/cenG-2/cen-23"},
        "BT-24":{"seq":25,"level":2,"term":"Specification identifier","code":"cen-24","path":"/corG-1/corG-2/cenG-2/cen-24"},
        "BG-3":{"seq":26,"level":1,"term":"PRECEDING INVOICE REFERENCE","code":"cenG-3","path":"/corG-1/corG-2/cenG-3"},
        "BT-25":{"seq":27,"level":2,"term":"Preceding Invoice reference","code":"taf-5","path":"/corG-1/corG-2/cenG-3/tafG-1/taf-5"},
        "BT-26":{"seq":28,"level":2,"term":"Preceding Invoice issue date","code":"taf-6","path":"/corG-1/corG-2/cenG-3/tafG-1/taf-6"},
        "BG-4":{"seq":29,"level":1,"term":"SELLER","code":"corG-9","path":"/corG-1/corG-3/corG-9"},
        "BT-27":{"seq":31,"level":2,"term":"Seller name","code":"cor-50","path":"/corG-1/corG-3/corG-9/cor-50"},
        "BT-28":{"seq":32,"level":2,"term":"Seller trading name","code":"cen-28","path":"/corG-1/corG-3/corG-9/cen-28"},
        "BT-29":{"seq":33,"level":2,"term":"Seller identifier","code":"cor-44","path":"/corG-1/corG-3/corG-9/cor-44"},
        "BT-30":{"seq":35,"level":2,"term":"Seller legal registration identifier","code":"cor-45","path":"/corG-1/corG-3/corG-9/cor-45"},
        "BT-30A":{"seq":36,"level":2,"term":"Scheme identifier","code":"cor-46","path":"/corG-1/corG-3/corG-9/cor-46"},
        "BT-31":{"seq":37,"level":2,"term":"Seller VAT identifier","code":"cor-45","path":"/corG-1/corG-3/corG-9/cor-45"},
        "BT-32":{"seq":38,"level":2,"term":"Seller tax registration identifier","code":"cor-45","path":"/corG-1/corG-3/corG-9/cor-45"},
        "BT-33":{"seq":39,"level":2,"term":"Seller additional legal information","code":"cen-33","path":"/corG-1/corG-3/corG-9/cen-33"},
        "BT-34":{"seq":40,"level":2,"term":"Seller electronic address","code":"cen-34","path":"/corG-1/corG-3/corG-9/cen-34"},
        "BG-5":{"seq":42,"level":2,"term":"SELLER POSTAL ADDRESS","code":"busG-20","path":"/corG-1/corG-3/corG-9/busG-20"},
        "BT-35":{"seq":43,"level":3,"term":"Seller address line 1","code":"bus-124","path":"/corG-1/corG-3/corG-9/busG-20/bus-124"},
        "BT-36":{"seq":44,"level":3,"term":"Seller address line 2","code":"bus-125","path":"/corG-1/corG-3/corG-9/busG-20/bus-125"},
        "BT-162":{"seq":45,"level":3,"term":"Seller address line 3","code":"cen-162","path":"/corG-1/corG-3/corG-9/busG-20/cen-162"},
        "BT-37":{"seq":46,"level":3,"term":"Seller city","code":"bus-126","path":"/corG-1/corG-3/corG-9/busG-20/bus-126"},
        "BT-38":{"seq":47,"level":3,"term":"Seller post code","code":"bus-129","path":"/corG-1/corG-3/corG-9/busG-20/bus-129"},
        "BT-39":{"seq":48,"level":3,"term":"Seller country subdivision","code":"bus-127","path":"/corG-1/corG-3/corG-9/busG-20/bus-127"},
        "BT-40":{"seq":49,"level":3,"term":"Seller country code","code":"bus-128","path":"/corG-1/corG-3/corG-9/busG-20/bus-128"},
        "BG-6":{"seq":50,"level":2,"term":"SELLER CONTACT","code":"corG-14","path":"/corG-1/corG-3/corG-9/corG-14"},
        "BT-41":{"seq":51,"level":3,"term":"Seller contact point","code":"cor-63","path":"/corG-1/corG-3/corG-9/corG-14/cor-63"},
        "BT-42":{"seq":52,"level":3,"term":"Seller contact telephone number","code":"cor-66","path":"/corG-1/corG-3/corG-9/corG-14/cor-63/cor-66"},
        "BT-43":{"seq":53,"level":3,"term":"Seller contact email address","code":"cor-70","path":"/corG-1/corG-3/corG-9/corG-14/cor-63/cor-70"},
        "BG-7":{"seq":54,"level":1,"term":"BUYER","code":"corG-9","path":"/corG-1/corG-3/corG-9"},
        "BT-44":{"seq":56,"level":2,"term":"Buyer name","code":"cor-50","path":"/corG-1/corG-3/corG-9/cor-50"},
        "BT-45":{"seq":57,"level":2,"term":"Buyer trading name","code":"cen-28","path":"/corG-1/corG-3/corG-9/cen-28"},
        "BT-46":{"seq":58,"level":2,"term":"Buyer identifier","code":"cor-44","path":"/corG-1/corG-3/corG-9/cor-44"},
        "BT-47":{"seq":60,"level":2,"term":"Buyer legal registration identifier","code":"cor-45","path":"/corG-1/corG-3/corG-9/cor-45"},
        "BT-47A":{"seq":61,"level":2,"term":"Scheme identifier","code":"cor-46","path":"/corG-1/corG-3/corG-9/cor-46"},
        "BT-48":{"seq":62,"level":2,"term":"Buyer VAT identifier","code":"cor-45","path":"/corG-1/corG-3/corG-9/cor-45"},
        "BT-49":{"seq":63,"level":2,"term":"Buyer electronic address","code":"cen-49","path":"/corG-1/corG-3/corG-9/cen-34"},
        "BG-8":{"seq":65,"level":2,"term":"BUYER POSTAL ADDRESS","code":"busG-20","path":"/corG-1/corG-3/corG-9/busG-20"},
        "BT-50":{"seq":66,"level":3,"term":"Buyer address line 1","code":"bus-124","path":"/corG-1/corG-3/corG-9/busG-20/bus-124"},
        "BT-51":{"seq":67,"level":3,"term":"Buyer address line 2","code":"bus-125","path":"/corG-1/corG-3/corG-9/busG-20/bus-125"},
        "BT-163":{"seq":68,"level":3,"term":"Buyer address line 3","code":"cen-162","path":"/corG-1/corG-3/corG-9/busG-20/cen-162"},
        "BT-52":{"seq":69,"level":3,"term":"Buyer city","code":"bus-126","path":"/corG-1/corG-3/corG-9/busG-20/bus-126"},
        "BT-53":{"seq":70,"level":3,"term":"Buyer post code","code":"bus-129","path":"/corG-1/corG-3/corG-9/busG-20/bus-129"},
        "BT-54":{"seq":71,"level":3,"term":"Buyer country subdivision","code":"bus-127","path":"/corG-1/corG-3/corG-9/busG-20/bus-127"},
        "BT-55":{"seq":72,"level":3,"term":"Buyer country code","code":"bus-128","path":"/corG-1/corG-3/corG-9/busG-20/bus-128"},
        "BG-9":{"seq":73,"level":2,"term":"BUYER CONTACT ","code":"corG-14","path":"/corG-1/corG-3/corG-9/corG-14"},
        "BT-56":{"seq":74,"level":3,"term":"Buyer contact point","code":"cor-63","path":"/corG-1/corG-3/corG-9/corG-14/cor-63"},
        "BT-57":{"seq":75,"level":3,"term":"Buyer contact telephone number","code":"cor-66","path":"/corG-1/corG-3/corG-9/corG-14/cor-63/cor-66"},
        "BT-58":{"seq":76,"level":3,"term":"Buyer contact email address","code":"cor-70","path":"/corG-1/corG-3/corG-9/corG-14/cor-63/cor-70"},
        "BG-10":{"seq":77,"level":1,"term":"PAYEE","code":"corG-9","path":"/corG-1/corG-3/corG-9"},
        "BT-59":{"seq":79,"level":2,"term":"Payee name","code":"cor-50","path":"/corG-1/corG-3/corG-9/cor-50"},
        "BT-60":{"seq":80,"level":2,"term":"Payee identifier","code":"cor-44","path":"/corG-1/corG-3/corG-9/cor-44"},
        "BT-61":{"seq":82,"level":2,"term":"Payee legal registration identifier","code":"cor-45","path":"/corG-1/corG-3/corG-9/cor-45"},
        "BT-61A":{"seq":83,"level":2,"term":"Scheme identifier","code":"cor-46","path":"/corG-1/corG-3/corG-9/cor-46"},
        "BG-11":{"seq":84,"level":1,"term":"SELLER TAX REPRESENTATIVE PARTY","code":"corG-9","path":"/corG-1/corG-3/corG-9"},
        "BT-62":{"seq":86,"level":2,"term":"Seller tax representative name","code":"cor-50","path":"/corG-1/corG-3/corG-9/cor-50"},
        "BT-63":{"seq":87,"level":2,"term":"Seller tax representative VAT identifier","code":"cor-45","path":"/corG-1/corG-3/corG-9/cor-45"},
        "BG-12":{"seq":88,"level":2,"term":"SELLER TAX REPRESENTATIVE POSTAL ADDRESS","code":"busG-20","path":"/corG-1/corG-3/corG-9/busG-20"},
        "BT-64":{"seq":89,"level":3,"term":"Tax representative address line 1","code":"bus-124","path":"/corG-1/corG-3/corG-9/busG-20/bus-124"},
        "BT-65":{"seq":90,"level":3,"term":"Tax representative address line 2","code":"bus-125","path":"/corG-1/corG-3/corG-9/busG-20/bus-125"},
        "BT-164":{"seq":91,"level":3,"term":"Tax representative address line 3","code":"cen-162","path":"/corG-1/corG-3/corG-9/busG-20/cen-162"},
        "BT-66":{"seq":92,"level":3,"term":"Tax representative city","code":"bus-126","path":"/corG-1/corG-3/corG-9/busG-20/bus-126"},
        "BT-67":{"seq":93,"level":3,"term":"Tax representative post code","code":"bus-129","path":"/corG-1/corG-3/corG-9/busG-20/bus-129"},
        "BT-68":{"seq":94,"level":3,"term":"Tax representative country subdivision","code":"bus-127","path":"/corG-1/corG-3/corG-9/busG-20/bus-127"},
        "BT-69":{"seq":95,"level":3,"term":"Tax representative country code","code":"bus-128","path":"/corG-1/corG-3/corG-9/busG-20/bus-128"},
        "BG-13":{"seq":96,"level":1,"term":"DELIVERY INFORMATION","code":"corG-9","path":"/corG-1/corG-3/corG-9"},
        "BT-70":{"seq":98,"level":2,"term":"Deliver to party name","code":"cor-50","path":"/corG-1/corG-3/corG-9/cor-50"},
        "BT-71":{"seq":99,"level":2,"term":"Deliver to location identifier","code":"bus-130","path":"/corG-1/corG-3/corG-9/busG-20/bus-130"},
        "BT-72":{"seq":101,"level":2,"term":"Actual delivery date","code":"cor-89","path":"/corG-1/corG-3/corG-9/cor-89"},
        "BG-14":{"seq":102,"level":2,"term":"INVOICING PERIOD","code":"cenG-14","path":"/corG-1/corG-3/busG-18/cenG-14"},
        "BT-73":{"seq":103,"level":3,"term":"Invoicing period start date","code":"cor-8","path":"/corG-1/corG-3/busG-18/cenG-14/cor-8"},
        "BT-74":{"seq":104,"level":3,"term":"Invoicing period end date","code":"cor-9","path":"/corG-1/corG-3/busG-18/cenG-14/cor-9"},
        "BG-15":{"seq":105,"level":2,"term":"DELIVER TO ADDRESS","code":"busG-20","path":"/corG-1/corG-3/corG-9/busG-20"},
        "BT-75":{"seq":106,"level":3,"term":"Deliver to address line 1","code":"bus-124","path":"/corG-1/corG-3/corG-9/busG-20/bus-124"},
        "BT-76":{"seq":107,"level":3,"term":"Deliver to address line 2","code":"bus-125","path":"/corG-1/corG-3/corG-9/busG-20/bus-125"},
        "BT-165":{"seq":108,"level":3,"term":"Deliver to address line 3","code":"cen-162","path":"/corG-1/corG-3/corG-9/busG-20/cen-162"},
        "BT-77":{"seq":109,"level":3,"term":"Deliver to city","code":"bus-126","path":"/corG-1/corG-3/corG-9/busG-20/bus-126"},
        "BT-78":{"seq":110,"level":3,"term":"Deliver to post code","code":"bus-129","path":"/corG-1/corG-3/corG-9/busG-20/bus-129"},
        "BT-79":{"seq":111,"level":3,"term":"Deliver to country subdivision","code":"bus-127","path":"/corG-1/corG-3/corG-9/busG-20/bus-127"},
        "BT-80":{"seq":112,"level":3,"term":"Deliver to country code","code":"bus-128","path":"/corG-1/corG-3/corG-9/busG-20/bus-128"},
        "BG-16":{"seq":113,"level":1,"term":"PAYMENT INSTRUCTIONS","code":"cenG-16","path":"/corG-1/corG-2/cenG-16"},
        "BT-81":{"seq":114,"level":2,"term":"Payment means type code","code":"bus-135","path":"/corG-1/corG-2/cenG-16/bus-135"},
        "BT-82":{"seq":115,"level":2,"term":"Payment means text","code":"cen-82","path":"/corG-1/corG-2/cenG-16/cen-82"},
        "BT-83":{"seq":116,"level":2,"term":"Remittance information","code":"cen-83","path":"/corG-1/corG-2/cenG-16/cen-83"},
        "BG-17":{"seq":117,"level":2,"term":"CREDIT TRANSFER","code":"cenG-17","path":"/corG-1/corG-2/cenG-16/cenG-17"},
        "BT-84":{"seq":118,"level":3,"term":"Payment account identifier","code":"cen-84","path":"/corG-1/corG-2/cenG-16/cenG-17/cen-84"},
        "BT-85":{"seq":119,"level":3,"term":"Payment account name","code":"cen-85","path":"/corG-1/corG-2/cenG-16/cenG-17/cen-85"},
        "BT-86":{"seq":120,"level":3,"term":"Payment service provider identifier","code":"cen-86","path":"/corG-1/corG-2/cenG-16/cenG-17/cen-86"},
        "BG-18":{"seq":122,"level":2,"term":"PAYMENT CARD INFORMATION","code":"cenG-18","path":"/corG-1/corG-2/cenG-16/cenG-18"},
        "BT-87":{"seq":123,"level":3,"term":"Payment card primary account number","code":"cen-87","path":"/corG-1/corG-2/cenG-16/cenG-18/cen-87"},
        "BT-88":{"seq":124,"level":3,"term":"Payment card holder name","code":"cen-88","path":"/corG-1/corG-2/cenG-16/cenG-18/cen-88"},
        "BG-19":{"seq":125,"level":2,"term":"DIRECT DEBIT","code":"cenG-19","path":"/corG-1/corG-2/cenG-16/cenG-19"},
        "BT-89":{"seq":126,"level":3,"term":"Mandate reference identifier","code":"cen-89","path":"/corG-1/corG-2/cenG-16/cenG-19/cen-89"},
        "BT-90":{"seq":127,"level":3,"term":"Bank assigned creditor identifier","code":"cen-90","path":"/corG-1/corG-2/cenG-16/cenG-19/cen-90"},
        "BT-91":{"seq":128,"level":3,"term":"Debited account identifier","code":"cen-91","path":"/corG-1/corG-2/cenG-16/cenG-19/cen-91"},
        "BG-20":{"seq":129,"level":1,"term":"DOCUMENT LEVEL ALLOWANCES","code":"cenG-20","path":"/corG-1/corG-4/cenG-20"},
        "BT-92":{"seq":130,"level":2,"term":"Document level allowance amount","code":"cor-40","path":"/corG-1/corG-4/cenG-20/cor-40"},
        "BT-93":{"seq":131,"level":2,"term":"Document level allowance base amount","code":"cen-93","path":"/corG-1/corG-4/cenG-20/cen-93"},
        "BT-94":{"seq":132,"level":2,"term":"Document level allowance percentage","code":"cen-94","path":"/corG-1/corG-4/cenG-20/cen-94"},
        "BT-95":{"seq":133,"level":2,"term":"Document level allowance VAT category code","code":"cor-99","path":"/corG-1/corG-4/cenG-20/cor-99"},
        "BT-96":{"seq":134,"level":2,"term":"Document level allowance VAT rate","code":"cor-98","path":"/corG-1/corG-4/cenG-20/cor-98"},
        "BT-97":{"seq":135,"level":2,"term":"Document level allowance reason","code":"cen-97","path":"/corG-1/corG-4/cenG-20/cen-97"},
        "BT-98":{"seq":136,"level":2,"term":"Document level allowance reason code","code":"cen-98","path":"/corG-1/corG-4/cenG-20/cen-98"},
        "BG-21":{"seq":137,"level":1,"term":"DOCUMENT LEVEL CHARGES","code":"cenG-21","path":"/corG-1/corG-4/cenG-21"},
        "BT-99":{"seq":138,"level":2,"term":"Document level charge amount","code":"cor-40","path":"/corG-1/corG-4/cenG-21/cor-40"},
        "BT-100":{"seq":139,"level":2,"term":"Document level charge base amount","code":"cen-100","path":"/corG-1/corG-4/cenG-21/cen-100"},
        "BT-101":{"seq":140,"level":2,"term":"Document level charge percentage","code":"cen-101","path":"/corG-1/corG-4/cenG-21/cen-101"},
        "BT-102":{"seq":141,"level":2,"term":"Document level charge VAT category code","code":"cor-99","path":"/corG-1/corG-4/cenG-21/cor-99"},
        "BT-103":{"seq":142,"level":2,"term":"Document level charge VAT rate","code":"cor-98","path":"/corG-1/corG-4/cenG-21/cor-98"},
        "BT-104":{"seq":143,"level":2,"term":"Document level charge reason","code":"cen-104","path":"/corG-1/corG-4/cenG-21/cen-104"},
        "BT-105":{"seq":144,"level":2,"term":"Document level charge reason code","code":"cen-105","path":"/corG-1/corG-4/cenG-21/cen-105"},
        "BG-22":{"seq":145,"level":1,"term":"DOCUMENT TOTALS","code":"cenG-22","path":"/corG-1/corG-4/cenG-22"},
        "BT-106":{"seq":146,"level":2,"term":"Sum of Invoice line net amount","code":"cor-40","path":"/corG-1/corG-4/cenG-22/cor-40"},
        "BT-107":{"seq":147,"level":2,"term":"Sum of allowances on document level","code":"cen-107","path":"/corG-1/corG-4/cenG-22/cen-107"},
        "BT-108":{"seq":148,"level":2,"term":"Sum of charges on document level","code":"cen-108","path":"/corG-1/corG-4/cenG-22/cen-108"},
        "BT-109":{"seq":149,"level":2,"term":"Invoice total amount without VAT","code":"cen-109","path":"/corG-1/corG-4/cenG-22/cen-109"},
        "BT-110":{"seq":150,"level":2,"term":"Invoice total VAT amount","code":"cor-95","path":"/corG-1/corG-4/cenG-22/cor-95"},
        "BT-111":{"seq":151,"level":2,"term":"Invoice total VAT amount in accounting currency","code":"cen-111","path":"/corG-1/corG-4/cenG-22/cen-111"},
        "BT-112":{"seq":152,"level":2,"term":"Invoice total amount with VAT","code":"cen-112","path":"/corG-1/corG-4/cenG-22/cen-112"},
        "BT-113":{"seq":153,"level":2,"term":"Paid amount","code":"cen-113","path":"/corG-1/corG-4/cenG-22/cen-113"},
        "BT-114":{"seq":154,"level":2,"term":"Rounding amount","code":"cen-114","path":"/corG-1/corG-4/cenG-22/cen-114"},
        "BT-115":{"seq":155,"level":2,"term":"Amount due for payment","code":"cen-115","path":"/corG-1/corG-4/cenG-22/cen-115"},
        "BG-23":{"seq":156,"level":1,"term":"VAT BREAKDOWN","code":"cenG-23","path":"/corG-1/corG-4/cenG-23"},
        "BT-116":{"seq":157,"level":2,"term":"VAT category taxable amount","code":"cor-40","path":"/corG-1/corG-4/cenG-23/cor-40"},
        "BT-117":{"seq":158,"level":2,"term":"VAT category tax amount","code":"cor-95","path":"/corG-1/corG-4/cenG-23/cor-95"},
        "BT-118":{"seq":159,"level":2,"term":"VAT category code ","code":"cor-99","path":"/corG-1/corG-4/cenG-23/cor-99"},
        "BT-119":{"seq":160,"level":2,"term":"VAT category rate","code":"cor-98","path":"/corG-1/corG-4/cenG-23/cor-98"},
        "BT-120":{"seq":161,"level":2,"term":"VAT exemption reason text","code":"cen-120","path":"/corG-1/corG-4/cenG-23/cen-120"},
        "BT-121":{"seq":162,"level":2,"term":"VAT exemption reason code","code":"cen-121","path":"/corG-1/corG-4/cenG-23/cen-121"},
        "BG-24":{"seq":163,"level":1,"term":"ADDITIONAL SUPPORTING DOCUMENTS","code":"cenG-24","path":"/corG-1/corG-2/cenG-24"},
        "BT-122":{"seq":164,"level":2,"term":"Supporting document reference","code":"cen-122","path":"/corG-1/corG-2/cenG-24/cen-122"},
        "BT-123":{"seq":165,"level":2,"term":"Supporting document description","code":"cen-123","path":"/corG-1/corG-2/cenG-24/cen-123"},
        "BT-124":{"seq":166,"level":2,"term":"External document location","code":"cen-124","path":"/corG-1/corG-2/cenG-24/cen-124"},
        "BT-125":{"seq":167,"level":2,"term":"Attached document","code":"cen-125","path":"/corG-1/corG-2/cenG-24/cen-125"},
        "BT-125A":{"seq":168,"level":2,"term":"Attached document Mime code","code":"cen-125A","path":"/corG-1/corG-2/cenG-24/cen-125A"},
        "BT-125B":{"seq":169,"level":2,"term":"Attached document Filename","code":"cen-125B","path":"/corG-1/corG-2/cenG-24/cen-125B"},
        "BG-25":{"seq":170,"level":1,"term":"INVOICE LINE","code":"corG-5","path":"/corG-1/corG-4/corG-5"},
        "BT-126":{"seq":171,"level":2,"term":"Invoice line identifier","code":"cor-22","path":"/corG-1/corG-4/corG-5/cor-22"},
        "BT-127":{"seq":172,"level":2,"term":"Invoice line note","code":"cor-85","path":"/corG-1/corG-4/corG-5/cor-85"},
        "BT-128":{"seq":173,"level":2,"term":"Invoice line object identifier","code":"cor-21","path":"/corG-1/corG-4/corG-5/cor-21"},
        "BT-129":{"seq":175,"level":2,"term":"Invoiced quantity","code":"bus-144","path":"/corG-1/corG-4/corG-5/busG-21/bus-144"},
        "BT-130":{"seq":176,"level":2,"term":"Invoiced quantity unit of measure code","code":"bus-146","path":"/corG-1/corG-4/corG-5/busG-21/bus-146"},
        "BT-131":{"seq":177,"level":2,"term":"Invoice line net amount","code":"cor-40","path":"/corG-1/corG-4/cenG-20/cor-40"},
        "BT-132":{"seq":178,"level":2,"term":"Referenced purchase order line reference","code":"taf-5","path":"/corG-1/corG-2/cenG-3/tafG-1/taf-5"},
        "BT-133":{"seq":179,"level":2,"term":"Invoice line Buyer accounting reference","code":"taf-4","path":"/corG-1/corG-2/cenG-3/tafG-1/taf-4"},
        "BG-26":{"seq":180,"level":2,"term":"INVOICE LINE PERIOD","code":"cenG-26","path":"/corG-1/corG-4/corG-5/cenG-26"},
        "BT-134":{"seq":181,"level":3,"term":"Invoice line period start date","code":"bus-148","path":"/corG-1/corG-4/corG-5/cenG-26/bus-148"},
        "BT-135":{"seq":182,"level":3,"term":"Invoice line period end date","code":"bus-149","path":"/corG-1/corG-4/corG-5/cenG-26/bus-149"},
        "BG-27":{"seq":183,"level":2,"term":"INVOICE LINE ALLOWANCES","code":"cenG-27","path":"/corG-1/corG-4/corG-5/cenG-27"},
        "BT-136":{"seq":184,"level":3,"term":"Invoice line allowance amount","code":"cor-40","path":"/corG-1/corG-4/corG-5/cenG-27/cor-40"},
        "BT-137":{"seq":185,"level":3,"term":"Invoice line allowance base amount","code":"cen-137","path":"/corG-1/corG-4/corG-5/cenG-27/cen-137"},
        "BT-138":{"seq":186,"level":3,"term":"Invoice line allowance percentage","code":"cen-138","path":"/corG-1/corG-4/corG-5/cenG-27/cen-138"},
        "BT-139":{"seq":187,"level":3,"term":"Invoice line allowance reason","code":"cen-139","path":"/corG-1/corG-4/corG-5/cenG-27/cen-139"},
        "BT-140":{"seq":188,"level":3,"term":"Invoice line allowance reason code","code":"cen-140","path":"/corG-1/corG-4/corG-5/cenG-27/cen-140"},
        "BG-28":{"seq":189,"level":2,"term":"INVOICE LINE CHARGES","code":"cenG-28","path":"/corG-1/corG-4/corG-5/cenG-28"},
        "BT-141":{"seq":190,"level":3,"term":"Invoice line charge amount","code":"cor-40","path":"/corG-1/corG-4/corG-5/cenG-28/cor-40"},
        "BT-142":{"seq":191,"level":3,"term":"Invoice line charge base amount","code":"cen-142","path":"/corG-1/corG-4/corG-5/cenG-28/cen-142"},
        "BT-143":{"seq":192,"level":3,"term":"Invoice line charge percentage","code":"cen-143","path":"/corG-1/corG-4/corG-5/cenG-28/cen-143"},
        "BT-144":{"seq":193,"level":3,"term":"Invoice line charge reason","code":"cen-144","path":"/corG-1/corG-4/corG-5/cenG-28/cen-144"},
        "BT-145":{"seq":194,"level":3,"term":"Invoice line charge reason code","code":"cen-145","path":"/corG-1/corG-4/corG-5/cenG-28/cen-145"},
        "BG-29":{"seq":195,"level":2,"term":"PRICE DETAILS","code":"busG-21","path":"/corG-1/corG-4/corG-5/busG-21"},
        "BT-146":{"seq":196,"level":3,"term":"Item net price","code":"cen-146","path":"/corG-1/corG-4/corG-5/busG-21/cen-146"},
        "BT-147":{"seq":197,"level":3,"term":"Item price discount","code":"cen-147","path":"/corG-1/corG-4/corG-5/busG-21/cen-147"},
        "BT-148":{"seq":198,"level":3,"term":"Item gross price","code":"cen-148","path":"/corG-1/corG-4/corG-5/busG-21/cen-148"},
        "BT-149":{"seq":199,"level":3,"term":"Item price base quantity","code":"bus-144","path":"/corG-1/corG-4/corG-5/busG-21/bus-144"},
        "BT-150":{"seq":200,"level":3,"term":"Item price base quantity unit of measure code","code":"bus-146","path":"/corG-1/corG-4/corG-5/busG-21/bus-146"},
        "BG-30":{"seq":201,"level":2,"term":"LINE VAT INFORMATION","code":"corG-19","path":"/corG-1/corG-4/corG-5/corG-19"},
        "BT-151":{"seq":202,"level":3,"term":"Invoiced item VAT category code","code":"cor-99","path":"/corG-1/corG-4/corG-5/corG-19/cor-99"},
        "BT-152":{"seq":203,"level":3,"term":"Invoiced item VAT rate","code":"cor-98","path":"/corG-1/corG-4/corG-5/corG-19/cor-98"},
        "BG-31":{"seq":204,"level":2,"term":"ITEM INFORMATION","code":"busG-21","path":"/corG-1/corG-4/corG-5/busG-21"},
        "BT-153":{"seq":205,"level":3,"term":"Item name","code":"bus-143","path":"/corG-1/corG-4/corG-5/busG-21/bus-143"},
        "BT-154":{"seq":206,"level":3,"term":"Item description","code":"cen-154","path":"/corG-1/corG-4/corG-5/cenG-21/cen-154"},
        "BT-155":{"seq":207,"level":3,"term":"Item Seller's identifier","code":"cen-155","path":"/corG-1/corG-4/corG-5/busG-21/cen-155"},
        "BT-156":{"seq":208,"level":3,"term":"Item Buyer's identifier","code":"cen-156","path":"/corG-1/corG-4/corG-5/busG-21/cen-156"},
        "BT-157":{"seq":209,"level":3,"term":"Item standard identifier","code":"bus-139","path":"/corG-1/corG-4/corG-5/busG-21/bus-139"},
        "BT-157A":{"seq":210,"level":3,"term":"Scheme identifier","code":"bus-140","path":"/corG-1/corG-4/corG-5/busG-21/bus-140"},
        "BT-158":{"seq":211,"level":3,"term":"Item classification identifier","code":"bus-145","path":"/corG-1/corG-4/corG-5/busG-21/bus-145"},
        "BT-159":{"seq":214,"level":3,"term":"Item country of origin","code":"bus-128","path":"/corG-1/corG-3/corG-9/busG-20/bus-128"},
        "BG-32":{"seq":215,"level":3,"term":"ITEM ATTRIBUTES","code":"cenG-32","path":"/corG-1/corG-4/corG-5/cenG-32"},
        "BT-160":{"seq":216,"level":4,"term":"Item attribute name","code":"cen-160","path":"/corG-1/corG-4/corG-5/cenG-32/cen-160"},
        "BT-161":{"seq":217,"level":4,"term":"Item attribute value","code":"cen-161","path":"/corG-1/corG-4/corG-5/cenG-32/cen-161/"}
    };

    var gl2en ={
        "corG-1":{"seq":1,"level":1,"module":"cor","term":"accountingEntries","code":""},
        "corG-2":{"seq":2,"level":2,"module":"cor","term":"documentInfo","code":""},
        "cor-76":{"seq":373,"level":3,"module":"cor","term":"documentNumber","code":"BT-1"},
        "cor-79":{"seq":376,"level":3,"module":"cor","term":"documentDate","code":"BT-2"},
        "cor-73":{"seq":370,"level":3,"module":"cor","term":"documentType","code":"BT-3"},
        "muc-4":{"seq":324,"level":3,"module":"muc","term":"amountOriginalCurrency","code":"BT-5"},
        "cor-43":{"seq":338,"level":3,"module":"cor","term":"postingDate","code":"BT-7"},
        "cen-8":{"seq":287,"level":3,"module":"cen","term":"ValueAddedTaxPointDateCode","code":"BT-8"},
        "cenG-16":{"seq":24,"level":3,"module":"cen","term":"PAYMENT_INSTRUCTIONS","code":"BG-16"},
        "cen-82":{"seq":25,"level":4,"module":"cen","term":"PaymentMeansText","code":"BT-82"},
        "cen-83":{"seq":26,"level":4,"module":"cen","term":"RemittanceInformation","code":"BT-83"},
        "cenG-17":{"seq":27,"level":4,"module":"cen","term":"CREDIT_TRANSFER","code":"BG-17"},
        "cen-84":{"seq":28,"level":5,"module":"cen","term":"PaymentAccountIdentifier","code":"BT-84"},
        "cen-85":{"seq":29,"level":5,"module":"cen","term":"PaymentAccountName","code":"BT-85"},
        "cen-86":{"seq":30,"level":5,"module":"cen","term":"PaymentServiceProviderIdentifier","code":"BT-86"},
        "cenG-18":{"seq":31,"level":4,"module":"cen","term":"PAYMENT_CARD_INFORMATION","code":"BG-18"},
        "cen-87":{"seq":32,"level":5,"module":"cen","term":"PaymentCardPrimaryAccountNumber","code":"BT-87"},
        "cen-88":{"seq":33,"level":5,"module":"cen","term":"PaymentCardHolderName","code":"BT-88"},
        "cenG-19":{"seq":34,"level":4,"module":"cen","term":"DIRECT_DEBIT","code":"BG-19"},
        "cen-89":{"seq":35,"level":5,"module":"cen","term":"MandateReferenceIdentifier","code":"BT-89"},
        "cen-90":{"seq":36,"level":5,"module":"cen","term":"BankAssignedCreditorIdentifier","code":"BT-90"},
        "cen-91":{"seq":37,"level":5,"module":"cen","term":"DebitedAccountIdentifier","code":"BT-91"},
        "cenG-3":{"seq":38,"level":3,"module":"cen","term":"PRECEDING_INVOICE_REFERENCE","code":"BG-3"},
        "tafG-1":{"seq":528,"level":4,"module":"taf","term":"originatingDocumentStructure","code":""},
        "taf-4":{"seq":529,"level":5,"module":"taf","term":"originatingDocumentType","code":"","type":"Project Purchase order  Receiving advice Tender or lot"},
        "taf-5":{"seq":530,"level":5,"module":"taf","term":"originatingDocumentNumber","code":"BT-25 BT-11 BT-13 BT-15 BT-17"},
        "taf-6":{"seq":531,"level":5,"module":"taf","term":"originatingDocumentDate","code":"BT-26"},
        "taf-5":{"seq":530,"level":5,"module":"taf","term":"originatingDocumentNumber","code":"BT-132"},
        "cen-18":{"seq":288,"level":3,"module":"cen","term":"InvoicedObjectIdentifier","code":"BT-18"},
        "cenG-1":{"seq":39,"level":3,"module":"cen","term":"INVOICE_NOTE","code":"BG-1"},
        "cen-21":{"seq":40,"level":4,"module":"cen","term":"InvoiceNoteSubjectCode","code":"BT-21"},
        "cor-7":{"seq":10,"level":3,"module":"cor","term":"entriesComment","code":"BT-22"},
        "cenG-2":{"seq":42,"level":3,"module":"cen","term":"PROCESS_CONTROL","code":"BG-2"},
        "cen-23":{"seq":43,"level":4,"module":"cen","term":"BusinessProcessType","code":"BT-23"},
        "cen-24":{"seq":44,"level":4,"module":"cen","term":"SpecificationIdentifier","code":"BT-24"},
        "taf-4":{"seq":529,"level":5,"module":"taf","term":"originatingDocumentType","code":"BT-133"},
        "cenG-24":{"seq":280,"level":3,"module":"cen","term":"ADDITIONAL_SUPPORTING_DOCUMENTS","code":"BG-24"},
        "cen-122":{"seq":281,"level":4,"module":"cen","term":"SupportingDocumentReference","code":"BT-122"},
        "cen-123":{"seq":282,"level":4,"module":"cen","term":"SupportingDocumentDescription","code":"BT-123"},
        "cen-124":{"seq":283,"level":4,"module":"cen","term":"ExternalDocumentLocation","code":"BT-124"},
        "cen-125":{"seq":284,"level":4,"module":"cen","term":"AttachedDocument","code":"BT-125"},
        "cen-125A":{"seq":285,"level":4,"module":"cen","term":"AttachedDocumentMimeCode","code":"BT-125A"},
        "cen-125B":{"seq":286,"level":4,"module":"cen","term":"AttachedDocumentFilename","code":"BT-125B"},
        "corG-3":{"seq":45,"level":2,"module":"cor","term":"entityInformation","code":""},
        "corG-9":{"seq":142,"level":3,"module":"cor","term":"identifierReference","code":" BG-4 BG-11 BG-7 BG-10 BG-13"},
        "cor-51":{"seq":153,"level":4,"module":"cor","term":"identifierType","code":"","type":"SELLER SELLER TAX REPRESENTATIVE PARTY BUYER PAYEE DELIVERY INFORMATION"},
        "cor-44":{"seq":143,"level":4,"module":"cor","term":"identifierCode","code":" BT-29 BT-46 BT-60"},
        "cor-45":{"seq":145,"level":4,"module":"cor","term":"identifierAuthorityCode","code":" BT-30 BT-47 BT-61"},
        "cor-45":{"seq":145,"level":4,"module":"cor","term":"identifierAuthorityCode","code":" BT-31 BT-63 BT-48"},
        "cor-45":{"seq":145,"level":4,"module":"cor","term":"identifierAuthorityCode","code":" BT-32"},
        "cor-46":{"seq":146,"level":4,"module":"cor","term":"identifierAuthority","code":" BT-30A BT-47A BT-61A"},
        "cor-50":{"seq":152,"level":4,"module":"cor","term":"identifierDescription","code":" BT-27 BT-62 BT-44 BT-59 BT-70"},
        "cen-28":{"seq":150,"level":4,"module":"cen","term":"tradingName","code":" BT-28 BT-45"},
        "cen-33":{"seq":151,"level":4,"module":"cen","term":"additionalLegalInformation","code":" BT-33"},
        "busG-20":{"seq":165,"level":4,"module":"bus","term":"identifierAddress","code":" BG-5 BG-12 BG-8 BG-15"},
        "bus-124":{"seq":169,"level":5,"module":"bus","term":"identifierStreet","code":" BT-35 BT-64 BT-50 BT-75"},
        "bus-125":{"seq":170,"level":5,"module":"bus","term":"identifierAddressStreet2","code":" BT-36 BT-65 BT-51 BT-76"},
        "cen-162":{"seq":171,"level":5,"module":"cen","term":"AddressLine3","code":" BT-162 BT-164 BT-163 BT-165"},
        "bus-126":{"seq":172,"level":5,"module":"bus","term":"identifierCity","code":" BT-37 BT-66 BT-52 BT-77"},
        "bus-127":{"seq":173,"level":5,"module":"bus","term":"identifierStateOrProvince","code":" BT-39 BT-68 BT-54 BT-79"},
        "bus-128":{"seq":174,"level":5,"module":"bus","term":"identifierCountry","code":" BT-40 BT-69 BT-55 BT-80"},
        "bus-129":{"seq":175,"level":5,"module":"bus","term":"identifierZipOrPostalCode","code":" BT-38 BT-67 BT-53 BT-78"},
        "bus-129":{"seq":175,"level":5,"module":"bus","term":"identifierZipOrPostalCode","code":""},
        "bus-130":{"seq":176,"level":5,"module":"bus","term":"identifierAddressLocationIdentifier","code":" BT-71"},
        "corG-14":{"seq":177,"level":4,"module":"cor","term":"identifierContactInformationStructure","code":" BG-6 BG-9"},
        "cor-63":{"seq":66,"level":5,"module":"cor","term":"identifierContactAttentionLine","code":" BT-41 BT-56"},
        "cor-66":{"seq":67,"level":6,"module":"cor","term":"identifierContactPhoneNumber","code":" BT-42 BT-57"},
        "cen-34":{"seq":68,"level":4,"module":"cen","term":"organizationAddressStreet3","code":" BT-34 BT-49"},
        "cor-70":{"seq":69,"level":6,"module":"cor","term":"identifierContactEmailAddress","code":" BT-43 BT-58"},
        "bus-35":{"seq":70,"level":6,"module":"bus","term":"contactAttentionLine","code":" BT-10"},
        "busG-18":{"seq":197,"level":3,"module":"bus","term":"reportingCalendar","code":""},
        "cenG-14":{"seq":206,"level":4,"module":"cen","term":"INVOICING_PERIOD","code":"BG-14"},
        "cor-8":{"seq":11,"level":5,"module":"cor","term":"periodCoveredStart","code":"BT-73"},
        "cor-9":{"seq":12,"level":5,"module":"cor","term":"periodCoveredEnd","code":"BT-74"},
        "corG-4":{"seq":215,"level":2,"module":"cor","term":"entryHeader","code":""},
        "cenG-20":{"seq":253,"level":3,"module":"cen","term":"DOCUMENT_LEVEL_ALLOWANCES","code":""},
        "cor-40":{"seq":320,"level":4,"module":"cor","term":"amount","code":"BT-92"},
        "cor-99":{"seq":508,"level":4,"module":"cor","term":"taxCode","code":"BT-95"},
        "cor-98":{"seq":507,"level":4,"module":"cor","term":"taxPercentageRate","code":"BT-96"},
        "cen-93":{"seq":254,"level":4,"module":"cen","term":"DocumentLevelAllowanceBaseAmount","code":"BT-93"},
        "cen-94":{"seq":255,"level":4,"module":"cen","term":"DocumentLevelAllowancePercentage","code":"BT-94"},
        "cen-97":{"seq":256,"level":4,"module":"cen","term":"DocumentLevelAllowanceReason","code":"BT-97"},
        "cen-98":{"seq":257,"level":4,"module":"cen","term":"DocumentLevelAllowanceReasonCode","code":"BT-98"},
        "cenG-21":{"seq":258,"level":3,"module":"cen","term":"DOCUMENT_LEVEL_CHARGES","code":""},
        "cor-40":{"seq":320,"level":4,"module":"cor","term":"amount","code":"BT-99"},
        "cor-99":{"seq":508,"level":4,"module":"cor","term":"taxCode","code":"BT-102"},
        "cor-98":{"seq":507,"level":4,"module":"cor","term":"taxPercentageRate","code":"BT-103"},
        "cen-100":{"seq":259,"level":4,"module":"cen","term":"DocumentLevelChargeBaseAmount","code":"BT-100"},
        "cen-101":{"seq":260,"level":4,"module":"cen","term":"DocumentLevelChargePercentage","code":"BT-101"},
        "cen-104":{"seq":261,"level":4,"module":"cen","term":"DocumentLevelChargeReason","code":"BT-104"},
        "cen-105":{"seq":262,"level":4,"module":"cen","term":"DocumentLevelChargeReasonCode","code":"BT-105"},
        "cenG-23":{"seq":273,"level":3,"module":"cen","term":"VAT_BREAKDOWN","code":"BG-23"},
        "cen-116":{"seq":274,"level":4,"module":"cen","term":"VATCategoryTaxableAmount","code":"BT-116"},
        "cen-117":{"seq":275,"level":4,"module":"cen","term":"VATCategoryTaxAmount","code":"BT-117"},
        "cen-118":{"seq":276,"level":4,"module":"cen","term":"VATCategoryCode ","code":"BT-118"},
        "cen-119":{"seq":277,"level":4,"module":"cen","term":"VATCategoryRate","code":"BT-119"},
        "cen-120":{"seq":278,"level":4,"module":"cen","term":"VATExemptionReasonText","code":"BT-120"},
        "cen-121":{"seq":279,"level":4,"module":"cen","term":"VATExemptionReasonCode","code":"BT-121"},
        "cenG-22":{"seq":263,"level":3,"module":"cen","term":"DOCUMENT_TOTALS","code":"BG-22"},
        "cen-106":{"seq":264,"level":4,"module":"cen","term":"SumOfInvoiceLineNetAmount","code":"BT-106"},
        "cen-107":{"seq":265,"level":4,"module":"cen","term":"SumOfAllowancesOnDocumentLevel","code":"BT-107"},
        "cen-108":{"seq":266,"level":4,"module":"cen","term":"SumOfChargesOnDocumentLevel","code":"BT-108"},
        "cen-109":{"seq":267,"level":4,"module":"cen","term":"InvoiceTotalAmountWithoutVAT","code":"BT-109"},
        "cen-111":{"seq":268,"level":4,"module":"cen","term":"InvoiceTotalVATAmountInAccountingCurrency","code":"BT-111"},
        "cen-112":{"seq":269,"level":4,"module":"cen","term":"InvoiceTotalAmountWithVAT","code":"BT-112"},
        "cen-113":{"seq":270,"level":4,"module":"cen","term":"PaidAmount","code":"BT-113"},
        "cen-114":{"seq":271,"level":4,"module":"cen","term":"RoundingAmount","code":"BT-114"},
        "cen-115":{"seq":272,"level":4,"module":"cen","term":"AmountDueForPayment","code":"BT-115"},
        "corG-5":{"seq":289,"level":3,"module":"cor","term":"entryDetail","code":"BG-25"},
        "cor-21":{"seq":290,"level":4,"module":"cor","term":"lineNumber","code":"BT-128"},
        "cor-22":{"seq":291,"level":4,"module":"cor","term":"lineNumberCounter","code":"BT-126"},
        "cor-23":{"seq":297,"level":4,"module":"cor","term":"accountMainID","code":"BT-19"},
        "cen-131":{"seq":292,"level":4,"module":"cen","term":"InvoiceLineNetAmount","code":"BT-131"},
        "cen-136":{"seq":341,"level":4,"module":"cen","term":"InvoiceLineAllowanceAmount","code":"BT-136"},
        "cen-141":{"seq":347,"level":4,"module":"cen","term":"InvoiceLineChargeAmount","code":"BT-141"},
        "bus-135":{"seq":380,"level":4,"module":"bus","term":"paymentMethod","code":"BT-81"},
        "cor-85":{"seq":430,"level":4,"module":"cor","term":"detailComment","code":"BT-127"},
        "cor-89":{"seq":434,"level":4,"module":"cor","term":"shipReceivedDate","code":"BT-72"},
        "cor-90":{"seq":435,"level":4,"module":"cor","term":"maturityDate","code":"BT-9"},
        "cor-91":{"seq":436,"level":4,"module":"cor","term":"terms","code":"BT-20"},
        "busG-21":{"seq":437,"level":4,"module":"bus","term":"measurable","code":"BG-29"},
        "cen-146":{"seq":483,"level":5,"module":"cen","term":"ItemNetPrice","code":"BT-146"},
        "cen-147":{"seq":484,"level":5,"module":"cen","term":"ItemPriceDiscount","code":"BT-147"},
        "cen-148":{"seq":485,"level":5,"module":"cen","term":"ItemGrossPrice","code":"BT-148"},
        "bus-144":{"seq":446,"level":5,"module":"bus","term":"measurableQuantity","code":"BT-149"},
        "bus-146":{"seq":451,"level":5,"module":"bus","term":"measurableUnitOfMeasure","code":"BT-150"},
        "busG-21":{"seq":437,"level":4,"module":"bus","term":"measurable","code":"BG-31"},
        "bus-143":{"seq":445,"level":5,"module":"bus","term":"measurableDescription","code":"BT-153"},
        "cen-155":{"seq":448,"level":5,"module":"cen","term":"ItemSellersIdentifier","code":"BT-155"},
        "cen-156":{"seq":449,"level":5,"module":"cen","term":"ItemBuyersIdentifier","code":"BT-156"},
        "bus-139":{"seq":441,"level":5,"module":"bus","term":"measurableID","code":"BT-157"},
        "bus-140":{"seq":442,"level":5,"module":"bus","term":"measurableIDSchema","code":"BT-157A"},
        "bus-144":{"seq":446,"level":5,"module":"bus","term":"measurableQuantity","code":"BT-129"},
        "bus-145":{"seq":447,"level":5,"module":"bus","term":"measurableQualifier","code":"BT-158"},
        "cen-159":{"seq":450,"level":5,"module":"cen","term":"itemCountryOfOrigin","code":"BT-159"},
        "bus-146":{"seq":451,"level":5,"module":"bus","term":"measurableUnitOfMeasure","code":"BT-130"},
        "cenG-26":{"seq":293,"level":4,"module":"cen","term":"INVOICE_LINE_PERIOD","code":"BG-26"},
        "bus-148":{"seq":453,"level":5,"module":"bus","term":"measurableStartDateTime","code":"BT-134"},
        "bus-149":{"seq":454,"level":5,"module":"bus","term":"measurableEndDateTime","code":"BT-135"},
        "corG-19":{"seq":500,"level":4,"module":"cor","term":"taxes","code":"BG-30"},
        "cor-95":{"seq":504,"level":5,"module":"cor","term":"taxAmount","code":"BT-110"},
        "cor-95":{"seq":504,"level":5,"module":"cor","term":"taxAmount","code":"BT-117"},
        "cor-98":{"seq":507,"level":5,"module":"cor","term":"taxPercentageRate","code":"BT-119"},
        "cor-98":{"seq":507,"level":5,"module":"cor","term":"taxPercentageRate","code":"BT-152"},
        "cor-99":{"seq":508,"level":5,"module":"cor","term":"taxCode","code":"BT-118"},
        "cor-99":{"seq":508,"level":5,"module":"cor","term":"taxCode","code":"BT-151"},
        "muc-33":{"seq":511,"level":5,"module":"muc","term":"taxCurrency","code":"BT-6"},
        "cenG-27":{"seq":340,"level":4,"module":"cen","term":"INVOICE_LINE_ALLOWANCES","code":"BG-27"},
        "cen-137":{"seq":342,"level":5,"module":"cen","term":"InvoiceLineAllowanceBaseAmount","code":"BT-137"},
        "cen-138":{"seq":343,"level":5,"module":"cen","term":"InvoiceLineAllowancePercentage","code":"BT-138"},
        "cen-139":{"seq":344,"level":5,"module":"cen","term":"InvoiceLineAllowanceReason","code":"BT-139"},
        "cen-140":{"seq":345,"level":5,"module":"cen","term":"InvoiceLineAllowanceReasonCode","code":"BT-140"},
        "cenG-28":{"seq":346,"level":4,"module":"cen","term":"INVOICE_LINE_CHARGES","code":"BG-28"},
        "cen-142":{"seq":348,"level":5,"module":"cen","term":"InvoiceLineChargeBaseAmount","code":"BT-142"},
        "cen-143":{"seq":349,"level":5,"module":"cen","term":"InvoiceLineChargePercentage","code":"BT-143"},
        "cen-144":{"seq":350,"level":5,"module":"cen","term":"InvoiceLineChargeReason","code":"BT-144"},
        "cen-145":{"seq":351,"level":5,"module":"cen","term":"InvoiceLineChargeReasonCode","code":"BT-145"},
        "cen-154":{"seq":352,"level":5,"module":"cen","term":"ItemDescription","code":"BT-154"},
        "cenG-32":{"seq":480,"level":4,"module":"cen","term":"ITEM_ATTRIBUTES","code":"BG-32"},
        "cen-160":{"seq":481,"level":5,"module":"cen","term":"ItemAttributeName","code":"BT-160"},
        "cen-161":{"seq":482,"level":5,"module":"cen","term":"ItemAttributeValue","code":"BT-161"}
    };
        
    var xbrlgl = { // template
    // /corG-1/corG-2/cenG-1
        "corG-1":[{ "name":"accountingEntries",
            "code":"",
        // /corG-1/corG-2
        // documentInfo
            "corG-2":[{ "name":"documentInfo",
                "code":"",
        // /corG-1/corG-2/cenG-2
                "cenG-2":[{ "name":"PROCESS_CONTROL",
                "code":"BG-2" }],
        // /corG-1/corG-2/cenG-3
                "cenG-3":[{ "name":"PRECEDING_INVOICE_REFERENCE",
                "code":"BG-3",
                "tafG-1":[{ "name":"originatingDocumentStructure",
                    "code":"" }]
                }],
        // /corG-1/corG-2/cenG-16
                "cenG-16":[{ "name":"PAYMENT_INSTRUCTIONS",
                "code":"BG-16",
        // /corG-1/corG-2/cenG-16/cenG-17
                "cenG-17":[{ "name":"CREDIT_TRANSFER",
                    "code":"BG-17" }],
        // /corG-1/corG-2/cenG-16/cenG-18
                "cenG-18":[{ "name":"PAYMENT_CARD_INFORMATION",
                    "code":"BG-18"}],
        // /corG-1/corG-2/cenG-16/cenG-19
                "cenG-19":[{ "name":"DIRECT_DEBIT",
                    "code":"BG-19" }]
                }],
        // /corG-1/corG-2/cenG-24
                "cenG-24":[{ "name":"ADDITIONAL_SUPPORTING_DOCUMENTS",
                "code":"BG-24" }]
            }],
        // /corG-1/corG-3
        // entityInformation
            "corG-3":[{ "name":"entityInformation",
                "code":"",
        // /corG-1/corG-3/corG-9
                "corG-9":[{ "name":"identifierReference",
                "code":" BG-4 BG-11 BG-7 BG-10 BG-13",
        // /corG-1/corG-3/corG-9/busG-20
                "busG-20":[{ "name":"identifierAddress",
                    "code":"BG-5 BG-12 BG-8 BG-15" }],
        // /corG-1/corG-3/corG-9/corG-14
                "corG-14":[{ "name":"identifierContactInformationStructure",
                    "code":"BG-6 BG-9" }],
                "cen-34":[{ "name":"organizationAddressStreet3", // check here
                    "code":"BT-34 BT-49" }]
                }],
        // /corG-1/corG-3/busG-18/cenG-14
                "busG-18":[{ "name":"reportingCalendar",
                    "code":"",
                    "cenG-14":[{ "name":"INVOICING_PERIOD",
                    "code":"BG-14" }]
                }]
            }],
        // /corG-1/corG-4
        // entryHeader
            "corG-4":[{ "name":"entryHeader",
                "code":"",
        // /corG-1/corG-4/cenG-20
                "cenG-20":[{ "name":"DOCUMENT_LEVEL_ALLOWANCES",
                "code":"" }],
        // /corG-1/corG-4/cenG-21
                "cenG-21":[{ "name":"DOCUMENT_LEVEL_CHARGES",
                "code":"" }],
        // /corG-1/corG-4/cenG-22
                "cenG-22":[{ "name":"DOCUMENT_TOTALS",
                "code":"BG-22" }],
        // /corG-1/corG-4/cenG-23
                "cenG-23":[{ "name":"VAT_BREAKDOWN",
                "code":"BG-23" }],
        // /corG-1/corG-4/corG-5
        // entryDetail
                "corG-5":[{ "name":"entryDetail",
                    "code":"BG-25",
        // /corG-1/corG-4/corG-5/corG-19
                    "corG-19":[{"name":"taxes",
                    "code":"" }],
        // /corG-1/corG-4/corG-5/busG-21
                    "busG-21":[{ "name":"measurable",
                    "code":"BG-29 BG-31" }],
        // /corG-1/corG-4/corG-5/cenG-26
                    "cenG-26":[{ "name":"INVOICE_LINE_PERIOD",
                    "code":"" }],
        // /corG-1/corG-4/corG-5/cenG-27
                    "cenG-27":[{ "name":"INVOICE_LINE_ALLOWANCE",
                    "code":"" }],
        // /corG-1/corG-4/corG-5/cenG-28
                    "cenG-28":[{ "name":"INVOICE_LINE_CHARGES",
                    "code":"" }],
        // /corG-1/corG-4/corG-5/cenG-32
                    "cenG-32":[{ "name":"ITEM_ATTRIBUTES",
                    "code":"" }]
                }]
            }]
        }]
    };

    var xbrl_gl = {
        "corG-1":[{ "name":"accountingEntries",
            "code":"",
            "corG-2":[{ "name":"documentInfo",
                "code":"",
                "cor-76":[{ "name":"documentNumber",
                    "code":"BT-1" }],
                "cor-79":[{ "name":"documentDate",
                    "code":"BT-2" }],
                "cor-73":[{ "name":"documentType",
                    "code":"BT-3" }],
                "muc-4":[{ "name":"amountOriginalCurrency",
                    "code":"BT-5" }],
                "cor-43":[{ "name":"postingDate",
                    "code":"BT-7" }],
                "cen-8":[{ "name":"ValueAddedTaxPointDateCode",
                    "code":"BT-8" }],
                "cenG-16":[{ "name":"PAYMENT_INSTRUCTIONS",
                    "code":"BG-16",
                    "cen-82":[{ "name":"PaymentMeansText",
                        "code":"BT-82" }],
                    "cen-83":[{ "name":"RemittanceInformation",
                        "code":"BT-83" }],
                    "cenG-17":[{ "name":"CREDIT_TRANSFER",
                        "code":"BG-17",
                        "cen-84":[{ "name":"PaymentAccountIdentifier",
                            "code":"BT-84" }],
                        "cen-85":[{ "name":"PaymentAccountName",
                            "code":"BT-85" }],
                        "cen-86":[{ "name":"PaymentServiceProviderIdentifier",
                            "code":"BT-86" }]
                    }],
                    "cenG-18":[{ "name":"PAYMENT_CARD_INFORMATION",
                        "code":"BG-18",
                        "cen-87":[{ "name":"PaymentCardPrimaryAccountNumber",
                            "code":"BT-87" }],
                        "cen-88":[{ "name":"PaymentCardHolderName",
                            "code":"BT-88" }]
                    }],
                    "cenG-19":[{ "name":"DIRECT_DEBIT",
                        "code":"BG-19",
                        "cen-89":[{ "name":"MandateReferenceIdentifier",
                            "code":"BT-89" }],
                        "cen-90":[{ "name":"BankAssignedCreditorIdentifier",
                            "code":"BT-90" }],
                        "cen-91":[{ "name":"DebitedAccountIdentifier",
                            "code":"BT-91" }]
                    }]
                }],
                "cenG-3":[{ "name":"PRECEDING_INVOICE_REFERENCE",
                    "code":"BG-3",
                    "tafG-1":[{ "name":"originatingDocumentStructure",
                        "code":"",
                        "taf-4":[{ "name":"originatingDocumentType",
                            "code":" Project Purchase order  Receiving advice Tender or lot" }],
                        "taf-5":[{ "name":"originatingDocumentNumber",
                            "code":"BT-25 BT-11 BT-13 BT-15 BT-17" }],
                        "taf-6":[{ "name":"originatingDocumentDate",
                            "code":"BT-26" }],
                        "taf-5":[{ "name":"originatingDocumentNumber",
                            "code":"BT-132" }]
                    }]
                }],
                "cen-18":[{ "name":"InvoicedObjectIdentifier",
                    "code":"BT-18" }],
                "cenG-1":[{ "name":"INVOICE_NOTE",
                    "code":"BG-1",
                    "cen-21":[{ "name":"InvoiceNoteSubjectCode",
                        "code":"BT-21" }]
                }],
                "cor-7":[{ "name":"entriesComment",
                    "code":"BT-22" }],
                "cenG-2":[{ "name":"PROCESS_CONTROL",
                    "code":"BG-2",
                    "cen-23":[{ "name":"BusinessProcessType",
                        "code":"BT-23" }],
                    "cen-24":[{ "name":"SpecificationIdentifier",
                        "code":"BT-24",
                        "taf-4":[{ "name":"originatingDocumentType",
                            "code":"BT-133" }]
                    }]
                }],
                "cenG-24":[{ "name":"ADDITIONAL_SUPPORTING_DOCUMENTS",
                    "code":"BG-24",
                    "cen-122":[{ "name":"SupportingDocumentReference",
                        "code":"BT-122" }],
                    "cen-123":[{ "name":"SupportingDocumentDescription",
                        "code":"BT-123" }],
                    "cen-124":[{ "name":"ExternalDocumentLocation",
                        "code":"BT-124" }],
                    "cen-125":[{ "name":"AttachedDocument",
                        "code":"BT-125" }],
                    "cen-125A":[{ "name":"AttachedDocumentMimeCode",
                        "code":"BT-125A" }],
                    "cen-125B":[{ "name":"AttachedDocumentFilename",
                        "code":"BT-125B" }]
                }]
            }],
            "corG-3":[{ "name":"entityInformation",
                "code":"",
                "corG-9":[{ "name":"identifierReference",
                    "code":" BG-4 BG-11 BG-7 BG-10 BG-13",
                    "cor-51":[{ "name":"identifierType",
                        "code":" SELLER SELLER TAX REPRESENTATIVE PARTY BUYER PAYEE DELIVERY INFORMATION" }],
                    "cor-44":[{ "name":"identifierCode",
                        "code":" BT-29 BT-46 BT-60" }],
                    "cor-45":[{ "name":"identifierAuthorityCode",
                        "code":" BT-30 BT-47 BT-61 BT-31 BT-63 BT-48 BT-32" }],
                    "cor-46":[{ "name":"identifierAuthority",
                        "code":" BT-30A BT-47A BT-61A" }],
                    "cor-50":[{ "name":"identifierDescription",
                        "code":" BT-27 BT-62 BT-44 BT-59 BT-70" }],
                    "cen-28":[{ "name":"tradingName",
                        "code":" BT-28 BT-45" }],
                    "cen-33":[{ "name":"additionalLegalInformation",
                        "code":" BT-33" }],
                    "busG-20":[{ "name":"identifierAddress",
                        "code":" BG-5 BG-12 BG-8 BG-15",
                        "bus-124":[{ "name":"identifierStreet",
                            "code":" BT-35 BT-64 BT-50 BT-75" }],
                        "bus-125":[{ "name":"identifierAddressStreet2",
                            "code":" BT-36 BT-65 BT-51 BT-76" }],
                        "cen-162":[{ "name":"AddressLine3",
                            "code":" BT-162 BT-164 BT-163 BT-165" }],
                        "bus-126":[{ "name":"identifierCity",
                            "code":" BT-37 BT-66 BT-52 BT-77"  }],
                        "bus-127":[{ "name":"identifierStateOrProvince",
                            "code":" BT-39 BT-68 BT-54 BT-79" }],
                        "bus-128":[{ "name":"identifierCountry",
                            "code":" BT-40 BT-69 BT-55 BT-80" }],
                        "bus-129":[{ "name":"identifierZipOrPostalCode",
                            "code":" BT-38 BT-67 BT-53 BT-78" }],
                        "bus-130":[{ "name":"identifierAddressLocationIdentifier",
                            "code":" BT-71" }]
                    }],
                    "corG-14":[{ "name":"identifierContactInformationStructure",
                        "code":" BG-6 BG-9",
                        "cor-63":[{ "name":"identifierContactAttentionLine",
                            "code":" BT-41 BT-56",
                            "cor-66":[{ "name":"identifierContactPhoneNumber",
                                "code":" BT-42 BT-57" }]
                        }]
                    }],
                    "cen-34":[{ "name":"organizationAddressStreet3", // check here
                        "code":" BT-34 BT-49",
                        "cor-63":[{ "cor-70":[{ "name":"identifierContactEmailAddress",
                                "code":" BT-43 BT-58" }],
                            "bus-35":[{ "name":"contactAttentionLine",
                                "code":" BT-10" }]
                        }]
                    }]
                }],
                "busG-18":[{ "name":"reportingCalendar",
                    "code":"",
                    "cenG-14":[{ "name":"INVOICING_PERIOD",
                        "code":"BG-14",
                        "cor-8":[{ "name":"periodCoveredStart",
                            "code":"BT-73" }],
                        "cor-9":[{ "name":"periodCoveredEnd",
                            "code":"BT-74" }]
                    }]
                }]
            }],
            "corG-4":[{
                "name":"entryHeader",
                "code":"",
                "cenG-20":[{ "name":"DOCUMENT_LEVEL_ALLOWANCES",
                    "code":"",
                    "cor-40":[{ "name":"amount",
                        "code":"BT-92" }],
                    "cor-99":[{ "name":"taxCode",
                        "code":"BT-95" }],
                    "cor-98":[{ "name":"taxPercentageRate",
                        "code":"BT-96" }],
                    "cen-93":[{ "name":"DocumentLevelAllowanceBaseAmount",
                        "code":"BT-93" }],
                    "cen-94":[{ "name":"DocumentLevelAllowancePercentage",
                        "code":"BT-94" }],
                    "cen-97":[{ "name":"DocumentLevelAllowanceReason",
                        "code":"BT-97" }],
                    "cen-98":[{ "name":"DocumentLevelAllowanceReasonCode",
                        "code":"BT-98" }]
                }],
                "cenG-21":[{
                    "name":"DOCUMENT_LEVEL_CHARGES",
                    "code":"",
                    "cor-40":[{ "name":"amount",
                        "code":"BT-99" }],
                    "cor-99":[{ "name":"taxCode",
                        "code":"BT-102" }],
                    "cor-98":[{ "name":"taxPercentageRate",
                        "code":"BT-103" }],
                    "cen-100":[{ "name":"DocumentLevelChargeBaseAmount",
                        "code":"BT-100" }],
                    "cen-101":[{ "name":"DocumentLevelChargePercentage",
                        "code":"BT-101" }],
                    "cen-104":[{ "name":"DocumentLevelChargeReason",
                        "code":"BT-104" }],
                    "cen-105":[{ "name":"DocumentLevelChargeReasonCode",
                        "code":"BT-105" }]
                }],
                "cenG-23":[{ "name":"VAT_BREAKDOWN",
                    "code":"BG-23",
                    "cen-116":[{ "name":"VATCategoryTaxableAmount",
                        "code":"BT-116" }],
                    "cen-117":[{ "name":"VATCategoryTaxAmount",
                        "code":"BT-117" }],
                    "cen-118":[{ "name":"VATCategoryCode ",
                        "code":"BT-118" }],
                    "cen-119":[{ "name":"VATCategoryRate",
                        "code":"BT-119" }],
                    "cen-120":[{ "name":"VATExemptionReasonText",
                        "code":"BT-120" }],
                    "cen-121":[{ "name":"VATExemptionReasonCode",
                        "code":"BT-121" }]
                }],
                "cenG-22":[{ "name":"DOCUMENT_TOTALS",
                    "code":"BG-22",
                    "cen-106":[{ "name":"SumOfInvoiceLineNetAmount",
                        "code":"BT-106" }],
                    "cen-107":[{ "name":"SumOfAllowancesOnDocumentLevel",
                        "code":"BT-107" }],
                    "cen-108":[{ "name":"SumOfChargesOnDocumentLevel",
                        "code":"BT-108" }],
                    "cen-109":[{ "name":"InvoiceTotalAmountWithoutVAT",
                        "code":"BT-109" }],
                    "cen-111":[{ "name":"InvoiceTotalVATAmountInAccountingCurrency",
                        "code":"BT-111" }],
                    "cen-112":[{ "name":"InvoiceTotalAmountWithVAT",
                        "code":"BT-112" }],
                    "cen-113":[{ "name":"PaidAmount",
                        "code":"BT-113" }],
                    "cen-114":[{ "name":"RoundingAmount",
                        "code":"BT-114" }],
                    "cen-115":[{ "name":"AmountDueForPayment",
                        "code":"BT-115" }]
                }],
                "corG-5":[{ "name":"entryDetail",
                    "code":"BG-25",
                    "cor-21":[{ "name":"lineNumber",
                        "code":"BT-128" }],
                    "cor-22":[{ "name":"lineNumberCounter",
                        "code":"BT-126" }],
                    "cor-23":[{ "name":"accountMainID",
                        "code":"BT-19" }],
                    "cen-131":[{ "name":"InvoiceLineNetAmount",
                        "code":"BT-131" }],
                    "cen-136":[{ "name":"InvoiceLineAllowanceAmount",
                        "code":"BT-136" }],
                    "cen-141":[{ "name":"InvoiceLineChargeAmount",
                        "code":"BT-141" }],
                    "bus-135":[{ "name":"paymentMethod",
                        "code":"BT-81" }],
                    "cor-85":[{ "name":"detailComment",
                        "code":"BT-127" }],
                    "cor-89":[{ "name":"shipReceivedDate",
                        "code":"BT-72" }],
                    "cor-90":[{ "name":"maturityDate",
                        "code":"BT-9" }],
                    "cor-91":[{ "name":"terms",
                        "code":"BT-20" }],
                    "busG-21":[{ "name":"measurable",
                        "code":"BG-29",
                        "cen-146":[{ "name":"ItemNetPrice",
                            "code":"BT-146" }],
                        "cen-147":[{ "name":"ItemPriceDiscount",
                            "code":"BT-147" }],
                        "cen-148":[{ "name":"ItemGrossPrice",
                            "code":"BT-148" }],
                        "bus-144":[{ "name":"measurableQuantity",
                            "code":"BT-149" }],
                        "bus-146":[{ "name":"measurableUnitOfMeasure",
                            "code":"BT-150" }]
                    },
                    { "name":"measurable",
                        "code":"BG-31",
                        "bus-143":[{ "name":"measurableDescription",
                        "code":"BT-153" }],
                        "cen-155":[{ "name":"ItemSellersIdentifier",
                            "code":"BT-155" }],
                        "cen-156":[{ "name":"ItemBuyersIdentifier",
                            "code":"BT-156" }],
                        "bus-139":[{ "name":"measurableID",
                            "code":"BT-157" }],
                        "bus-140":[{ "name":"measurableIDSchema",
                            "code":"BT-157A" }],
                        "bus-144":[{ "name":"measurableQuantity",
                            "code":"BT-129" }],
                        "bus-145":[{ "name":"measurableQualifier",
                            "code":"BT-158" }],
                        "cen-159":[{ "name":"itemCountryOfOrigin",
                        "code":"BT-159" }],
                        "bus-146":[{ "name":"measurableUnitOfMeasure",
                            "code":"BT-130" }]
                    }],
                    "cenG-26":[{ "name":"INVOICE_LINE_PERIOD",
                        "code":"BG-26",
                        "bus-148":[{ "name":"measurableStartDateTime",
                            "code":"BT-134" }],
                        "bus-149":[{ "name":"measurableEndDateTime",
                            "code":"BT-135" }]
                    }],
                    "corG-19":[{ "name":"taxes",
                        "code":"BG-30",
                        "cor-95":[{ "name":"taxAmount",
                            "code":"BT-110 BT-117" }],
                        "cor-98":[{ "name":"taxPercentageRate",
                            "code":"BT-119 BT-152" }],
                        "cor-99":[{ "name":"taxCode",
                            "code":"BT-118 BT-151" }],
                        "muc-33":[{ "name":"taxCurrency",
                            "code":"BT-6" }]
                    }],
                    "cenG-27":[{ "name":"INVOICE_LINE_ALLOWANCES",
                        "code":"BG-27",
                        "cen-137":[{ "name":"InvoiceLineAllowanceBaseAmount",
                            "code":"BT-137" }],
                        "cen-138":[{ "name":"InvoiceLineAllowancePercentage",
                            "code":"BT-138" }],
                        "cen-139":[{ "name":"InvoiceLineAllowanceReason",
                            "code":"BT-139" }],
                        "cen-140":[{ "name":"InvoiceLineAllowanceReasonCode",
                            "code":"BT-140" }]
                    }],
                    "cenG-28":[{ "name":"INVOICE_LINE_CHARGES",
                        "code":"BG-28",
                        "cen-142":[{ "name":"InvoiceLineChargeBaseAmount",
                            "code":"BT-142" }],
                        "cen-143":[{ "name":"InvoiceLineChargePercentage",
                            "code":"BT-143" }],
                        "cen-144":[{ "name":"InvoiceLineChargeReason",
                            "code":"BT-144" }],
                        "cen-145":[{ "name":"InvoiceLineChargeReasonCode",
                            "code":"BT-145" }],
                        "cen-154":[{ "name":"ItemDescription",
                            "code":"BT-154" }]
                    }],
                    "cenG-32":[{ "name":"ITEM_ATTRIBUTES",
                        "code":"BG-32",
                        "cen-160":[{ "name":"ItemAttributeName",
                            "code":"BT-160" }],
                        "cen-161":[{ "name":"ItemAttributeValue",
                            "code":"BT-161" }]
                    }]
                }]
            }]
        }]
    };

    var xbrl = null;

    var convert = function(en) {
        var traverse = function(seq, path, current) {
            var val, match, group, term, p_path, gl_path, paths,
                nth4, nth3, nth2, nth1, nth0;
            if ('Array' === current.constructor.name) {
                if (1 === current.length && 'Object' !== current[0].constructor.name) {
                    // console.log(seq, path, current[0]);
                    val = {'seq': seq, 'path': path, 'v': current[0]};
                }
                else if (current.length > 1 && current[1] && 'Object' !== current[1].constructor.name) {
                    // console.log(seq, path, current[0]); // console.log(seq, path, current[1]);
                    val = {'seq': seq, 'path': path, 'v': current[1]};
                }
                if (val) {
                    match = val.path.match(/^\/([^\/]*)\/?([^\/]*)?\/?$/);
                    if (match) {
                        group = match[1];
                        term = match[2];
                        if (!term) {
                            if (group.match(/^BT/)) {
                                term = group;
                                group = null;// 'corG-1';
                            }
                        }
                        gl_path = en2gl[term] && en2gl[term].path;
                        console.log(group, term, gl_path, val.v);
                        paths = gl_path.split('/');
                        paths.shift();
                    try {
                        // nth = 0;
                        switch (paths.length) {
                            case 6:
                                nth4 = xbrl[paths[0]][0][paths[1]][0][paths[2]][0][paths[3]][0][paths[4]][0]['nth'];
                                if (!nth4) {
                                    nth4 = 0;
                                    xbrl[paths[0]][0][paths[1]][0][paths[2]][0][paths[3]][0][paths[4]][0]['nth'] = 0;
                                }
                            case 5:
                                nth3 = xbrl[paths[0]][0][paths[1]][0][paths[2]][0][paths[3]][0]['nth'];
                                if (!nth3) {
                                    nth3 = 0;
                                    xbrl[paths[0]][0][paths[1]][0][paths[2]][0][paths[3]][0]['nth'] = 0;
                                }
                            case 4:
                                nth2 = xbrl[paths[0]][0][paths[1]][0][paths[2]][0]['nth'];
                                if (!nth2) {
                                    nth2 = 0;
                                    xbrl[paths[0]][0][paths[1]][0][paths[2]][0]['nth'] = 0;
                                }
                            case 3:
                                nth1 = xbrl[paths[0]][0][paths[1]][0]['nth'];
                                if (!nth1) {
                                    nth1 = 0;
                                    xbrl[paths[0]][0][paths[1]][0]['nth'] = 0;
                                }
                            case 2:
                                nth0 = xbrl[paths[0]][0]['nth'];
                                if (!nth0) {
                                    nth0 = 0;
                                    xbrl[paths[0]][0]['nth'] = 0;
                                }
                        }
                        if (6 === paths.length) {
                            if (xbrl[paths[0]][nth0][paths[1]][nth1][paths[2]][nth2][paths[3]][nth3][paths[4]][nth4][paths[5]]) {
                                nth4 += 1;
                                xbrl[paths[0]][nth0][paths[1]][nth1][paths[2]][nth2][paths[3]][nth3][paths[4]][0]['nth'] = nth4;
                                xbrl[paths[0]][nth0][paths[1]][nth1][paths[2]][nth2][paths[3]][nth3][paths[4]][nth4] = {};
                            }
                            xbrl[paths[0]][nth0][paths[1]][nth1][paths[2]][nth2][paths[3]][nth3][paths[4]][nth4][paths[5]] = val.v;
                        }
                        else if (5 === paths.length) {
                            if (xbrl[paths[0]][nth0][paths[1]][nth1][paths[2]][nth2][paths[3]][nth3][paths[4]]) {
                                nth3 += 1;
                                xbrl[paths[0]][nth0][paths[1]][nth1][paths[2]][nth2][paths[3]][0]['nth'] = nth3;
                                xbrl[paths[0]][nth0][paths[1]][nth1][paths[2]][nth2][paths[3]][nth3] = {};
                            }
                            xbrl[paths[0]][nth0][paths[1]][nth1][paths[2]][nth2][paths[3]][nth3][paths[4]] = val.v;
                        }
                        else if (4 === paths.length) {
                            if (xbrl[paths[0]][nth0][paths[1]][nth1][paths[2]][nth2][paths[3]]) {
                                nth2 += 1;
                                xbrl[paths[0]][nth0][paths[1]][nth1][paths[2]][0]['nth'] = nth2;
                                xbrl[paths[0]][nth0][paths[1]][nth1][paths[2]][nth2] = {};
                            }
                            xbrl[paths[0]][nth0][paths[1]][nth1][paths[2]][nth2][paths[3]] = val.v;
                        }
                        else if (3 === paths.length) {
                            if (xbrl[paths[0]][nth0][paths[1]][nth1][paths[2]]) {
                                nth1 += 1;
                                xbrl[paths[0]][nth0][paths[1]][0]['nth'] = nth1;
                                xbrl[paths[0]][nth0][paths[1]][nth1] = {};
                            }
                            xbrl[paths[0]][nth0][paths[1]][nth1][paths[2]] = val.v;
                        }
                        else if (2 === paths.length) {
                            if (xbrl[paths[0]][nth0][paths[1]]) {
                                nth0 += 1;
                                xbrl[paths[0]][0]['nth'] = nth0;
                                xbrl[paths[0]][0][nth0] = {};
                            }
                            xbrl[paths[0]][nth0][paths[1]] = val.v;
                        }
                    }
                    catch(e) {
                        console.log(e, paths, xbrl);
                    }
                        // console.log(xbrl);
                    }
                }
            }
            //process current node here
            for (var i = 0; i < current.length; i++) {
                var val = current[i];
                //visit children of current
                if ('object' == typeof val) {
                    for (var idx in val) {
                        var item = val[idx];
                        var children = item.val;
                        if (children && children.length > 0) {
                            traverse(i, path+'/'+idx, children);
                        }
                    }
                }
            }
        }
        xbrl = JSON.parse(JSON.stringify(xbrlgl));
        //call on root node
        traverse(0, '', en.val);
        console.log(xbrl);
        return xbrl;
    }

    var initModule = function() {
        // console.log(xbrl_gl);
        var xbrl = convert(en);
        console.log(xbrl);
    }

    return {
        en2gl: en2gl,
        gl2en: gl2en,
        xbrlgl: xbrlgl,
        xbrl_gl: xbrl_gl,
        convert: convert,
        initModule: initModule
    }
})();
// en2gl_mapping.js