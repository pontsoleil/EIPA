// (B[GT]-[0-9]*[A-C]*)\t([0-9])\t([01]_[01n])\t(.*)\t(.*)
// ->
// $1":{"level":"$2","card":"$3","type":"$4","name":"$5"},
var EN={
"BG-0":{"level":"0","card":"1_1","type":"","name":"INVOICE"},
"BT-1":{"level":"1","card":"1_1","type":"Identifier","name":"Invoice number"},
"BT-2":{"level":"1","card":"1_1","type":"Date","name":"Invoice issue date"},
"BT-3":{"level":"1","card":"1_1","type":"Code","name":"Invoice type code"},
"BT-5":{"level":"1","card":"1_1","type":"Code","name":"Invoice currency code"},
"BT-6":{"level":"1","card":"0_1","type":"Code","name":"VAT accounting currency code"},
"BT-7":{"level":"1","card":"0_1","type":"Date","name":"Value added tax point date"},
"BT-8":{"level":"1","card":"0_1","type":"Code","name":"Value added tax point date code"},
"BT-9":{"level":"1","card":"0_1","type":"Date","name":"Payment due date"},
"BT-10":{"level":"1","card":"0_1","type":"Text","name":"Buyer reference"},
"BT-11":{"level":"1","card":"0_1","type":"DocumentReference","name":"Project reference"},
"BT-12":{"level":"1","card":"0_1","type":"DocumentReference","name":"Contract reference"},
"BT-13":{"level":"1","card":"0_1","type":"DocumentReference","name":"Purchase order reference "},
"BT-14":{"level":"1","card":"0_1","type":"DocumentReference","name":"Sales order reference"},
"BT-15":{"level":"1","card":"0_1","type":"DocumentReference","name":"Receiving advice reference"},
"BT-16":{"level":"1","card":"0_1","type":"DocumentReference","name":"Despatch advice reference"},
"BT-17":{"level":"1","card":"0_1","type":"DocumentReference","name":"Tender or lot reference"},
"BT-18":{"level":"1","card":"0_1","type":"Identifier","name":"Invoiced object identifier"},
"BT-18A":{"level":"1","card":"0_1","type":"","name":"Scheme identifier"},
"BT-19":{"level":"1","card":"0_1","type":"Text","name":"Buyer accounting reference"},
"BT-20":{"level":"1","card":"0_1","type":"Text","name":"Payment terms"},
"BG-1":{"level":"1","card":"0_n","type":"","name":"INVOICE NOTE"},
"BT-21":{"level":"2","card":"0_1","type":"Code","name":"Invoice note subject code"},
"BT-22":{"level":"2","card":"1_1","type":"Text","name":"Invoice note"},
"BG-2":{"level":"1","card":"1_1","type":"","name":"PROCESS CONTROL"},
"BT-23":{"level":"2","card":"0_1","type":"Text","name":"Business process type"},
"BT-24":{"level":"2","card":"1_1","type":"Identifier","name":"Specification identifier"},
"BG-3":{"level":"1","card":"0_n","type":"","name":"PRECEDING INVOICE REFERENCE"},
"BT-25":{"level":"2","card":"1_1","type":"DocumentReference","name":"Preceding Invoice reference"},
"BT-26":{"level":"2","card":"0_1","type":"Date","name":"Preceding Invoice issue date"},
"BG-4":{"level":"1","card":"1_1","type":"","name":"SELLER"},
"BT-27":{"level":"2","card":"1_1","type":"Text","name":"Seller name"},
"BT-28":{"level":"2","card":"0_1","type":"Text","name":"Seller trading name"},
"BT-29":{"level":"2","card":"0_n","type":"Identifier","name":"Seller identifier"},
"BT-29A":{"level":"2","card":"0_1","type":"","name":"Scheme identifier"},
"BT-30":{"level":"2","card":"0_1","type":"Identifier","name":"Seller legal registration identifier"},
"BT-30A":{"level":"2","card":"0_1","type":"","name":"Scheme identifier"},
"BT-31":{"level":"2","card":"0_1","type":"Identifier","name":"Seller VAT identifier"},
"BT-32":{"level":"2","card":"0_1","type":"Identifier","name":"Seller tax registration identifier"},
"BT-33":{"level":"2","card":"0_1","type":"Text","name":"Seller additional legal information"},
"BT-34":{"level":"2","card":"0_1","type":"Identifier","name":"Seller electronic address"},
"BT-34A":{"level":"2","card":"1_1","type":"","name":"Scheme identifier"},
"BG-5":{"level":"2","card":"1_1","type":"","name":"SELLER POSTAL ADDRESS"},
"BT-35":{"level":"3","card":"0_1","type":"Text","name":"Seller address line 1"},
"BT-36":{"level":"3","card":"0_1","type":"Text","name":"Seller address line 2"},
"BT-162":{"level":"3","card":"0_1","type":"Text","name":"Seller address line 3"},
"BT-37":{"level":"3","card":"0_1","type":"Text","name":"Seller city"},
"BT-38":{"level":"3","card":"0_1","type":"Text","name":"Seller post code"},
"BT-39":{"level":"3","card":"0_1","type":"Text","name":"Seller country subdivision"},
"BT-40":{"level":"3","card":"1_1","type":"Code","name":"Seller country code"},
"BG-6":{"level":"2","card":"0_1","type":"","name":"SELLER CONTACT"},
"BT-41":{"level":"3","card":"0_1","type":"Text","name":"Seller contact point"},
"BT-42":{"level":"3","card":"0_1","type":"Text","name":"Seller contact telephone number"},
"BT-43":{"level":"3","card":"0_1","type":"Text","name":"Seller contact email address"},
"BG-7":{"level":"1","card":"1_1","type":"","name":"BUYER"},
"BT-44":{"level":"2","card":"1_1","type":"Text","name":"Buyer name"},
"BT-45":{"level":"2","card":"0_1","type":"Text","name":"Buyer trading name"},
"BT-46":{"level":"2","card":"0_1","type":"Identifier","name":"Buyer identifier"},
"BT-46A":{"level":"2","card":"0_1","type":"","name":"Scheme identifier"},
"BT-47":{"level":"2","card":"0_1","type":"Identifier","name":"Buyer legal registration identifier"},
"BT-47A":{"level":"2","card":"0_1","type":"","name":"Scheme identifier"},
"BT-48":{"level":"2","card":"0_1","type":"Identifier","name":"Buyer VAT identifier"},
"BT-49":{"level":"2","card":"0_1","type":"Identifier","name":"Buyer electronic address"},
"BT-49A":{"level":"2","card":"1_1","type":"","name":"Scheme identifier"},
"BG-8":{"level":"2","card":"1_1","type":"","name":"BUYER POSTAL ADDRESS"},
"BT-50":{"level":"3","card":"0_1","type":"Text","name":"Buyer address line 1"},
"BT-51":{"level":"3","card":"0_1","type":"Text","name":"Buyer address line 2"},
"BT-163":{"level":"3","card":"0_1","type":"Text","name":"Buyer address line 3"},
"BT-52":{"level":"3","card":"0_1","type":"Text","name":"Buyer city"},
"BT-53":{"level":"3","card":"0_1","type":"Text","name":"Buyer post code"},
"BT-54":{"level":"3","card":"0_1","type":"Text","name":"Buyer country subdivision"},
"BT-55":{"level":"3","card":"1_1","type":"Code","name":"Buyer country code"},
"BG-9":{"level":"2","card":"0_1","type":"","name":"BUYER CONTACT "},
"BT-56":{"level":"3","card":"0_1","type":"Text","name":"Buyer contact point"},
"BT-57":{"level":"3","card":"0_1","type":"Text","name":"Buyer contact telephone number"},
"BT-58":{"level":"3","card":"0_1","type":"Text","name":"Buyer contact email address"},
"BG-10":{"level":"1","card":"0_1","type":"","name":"PAYEE"},
"BT-59":{"level":"2","card":"1_1","type":"Text","name":"Payee name"},
"BT-60":{"level":"2","card":"0_1","type":"Identifier","name":"Payee identifier"},
"BT-60A":{"level":"2","card":"0_1","type":"","name":"Scheme identifier"},
"BT-61":{"level":"2","card":"0_1","type":"Identifier","name":"Payee legal registration identifier"},
"BT-61A":{"level":"2","card":"0_1","type":"","name":"Scheme identifier"},
"BG-11":{"level":"1","card":"0_1","type":"","name":"SELLER TAX REPRESENTATIVE PARTY"},
"BT-62":{"level":"2","card":"1_1","type":"Text","name":"Seller tax representative name"},
"BT-63":{"level":"2","card":"1_1","type":"Identifier","name":"Seller tax representative VAT identifier"},
"BG-12":{"level":"2","card":"1_1","type":"","name":"SELLER TAX REPRESENTATIVE POSTAL ADDRESS"},
"BT-64":{"level":"3","card":"0_1","type":"Text","name":"Tax representative address line 1"},
"BT-65":{"level":"3","card":"0_1","type":"Text","name":"Tax representative address line 2"},
"BT-164":{"level":"3","card":"0_1","type":"Text","name":"Tax representative address line 3"},
"BT-66":{"level":"3","card":"0_1","type":"Text","name":"Tax representative city"},
"BT-67":{"level":"3","card":"0_1","type":"Text","name":"Tax representative post code"},
"BT-68":{"level":"3","card":"0_1","type":"Text","name":"Tax representative country subdivision"},
"BT-69":{"level":"3","card":"1_1","type":"Code","name":"Tax representative country code"},
"BG-13":{"level":"1","card":"0_1","type":"","name":"DELIVERY INFORMATION"},
"BT-70":{"level":"2","card":"0_1","type":"Text","name":"Deliver to party name"},
"BT-71":{"level":"2","card":"0_1","type":"Identifier","name":"Deliver to location identifier"},
"BT-71A":{"level":"2","card":"0_1","type":"","name":"Scheme identifier"},
"BT-72":{"level":"2","card":"0_1","type":"Date","name":"Actual delivery date"},
"BG-14":{"level":"2","card":"0_1","type":"","name":"INVOICING PERIOD"},
"BT-73":{"level":"3","card":"0_1","type":"Date","name":"Invoicing period start date"},
"BT-74":{"level":"3","card":"0_1","type":"Date","name":"Invoicing period end date"},
"BG-15":{"level":"2","card":"0_1","type":"","name":"DELIVER TO ADDRESS"},
"BT-75":{"level":"3","card":"0_1","type":"Text","name":"Deliver to address line 1"},
"BT-76":{"level":"3","card":"0_1","type":"Text","name":"Deliver to address line 2"},
"BT-165":{"level":"3","card":"0_1","type":"Text","name":"Deliver to address line 3"},
"BT-77":{"level":"3","card":"0_1","type":"Text","name":"Deliver to city"},
"BT-78":{"level":"3","card":"0_1","type":"Text","name":"Deliver to post code"},
"BT-79":{"level":"3","card":"0_1","type":"Text","name":"Deliver to country subdivision"},
"BT-80":{"level":"3","card":"1_1","type":"Code","name":"Deliver to country code"},
"BG-16":{"level":"1","card":"0_1","type":"","name":"PAYMENT INSTRUCTIONS"},
"BT-81":{"level":"2","card":"1_1","type":"Code","name":"Payment means type code"},
"BT-82":{"level":"2","card":"0_1","type":"Text","name":"Payment means text"},
"BT-83":{"level":"2","card":"0_1","type":"Text","name":"Remittance information"},
"BG-17":{"level":"2","card":"0_n","type":"","name":"CREDIT TRANSFER"},
"BT-84":{"level":"3","card":"1_1","type":"Identifier","name":"Payment account identifier"},
"BT-85":{"level":"3","card":"0_1","type":"Text","name":"Payment account name"},
"BT-86":{"level":"3","card":"0_1","type":"Identifier","name":"Payment service provider identifier"},
"BG-18":{"level":"2","card":"0_1","type":"","name":"PAYMENT CARD INFORMATION"},
"BT-87":{"level":"3","card":"1_1","type":"Text","name":"Payment card primary account number"},
"BT-88":{"level":"3","card":"0_1","type":"Text","name":"Payment card holder name"},
"BG-19":{"level":"2","card":"0_1","type":"","name":"DIRECT DEBIT"},
"BT-89":{"level":"3","card":"0_1","type":"Identifier","name":"Mandate reference identifier"},
"BT-90":{"level":"3","card":"0_1","type":"Identifier","name":"Bank assigned creditor identifier"},
"BT-91":{"level":"3","card":"0_1","type":"Identifier","name":"Debited account identifier"},
"BG-20":{"level":"1","card":"0_n","type":"","name":"DOCUMENT LEVEL ALLOWANCES"},
"BT-92":{"level":"2","card":"1_1","type":"Amount","name":"Document level allowance amount"},
"BT-93":{"level":"2","card":"0_1","type":"Amount","name":"Document level allowance base amount"},
"BT-94":{"level":"2","card":"0_1","type":"Percentage","name":"Document level allowance percentage"},
"BT-95":{"level":"2","card":"1_1","type":"Code","name":"Document level allowance VAT category code"},
"BT-96":{"level":"2","card":"0_1","type":"Percentage","name":"Document level allowance VAT rate"},
"BT-97":{"level":"2","card":"0_1","type":"Text","name":"Document level allowance reason"},
"BT-98":{"level":"2","card":"0_1","type":"Code","name":"Document level allowance reason code"},
"BG-21":{"level":"1","card":"0_n","type":"","name":"DOCUMENT LEVEL CHARGES"},
"BT-99":{"level":"2","card":"1_1","type":"Amount","name":"Document level charge amount"},
"BT-100":{"level":"2","card":"0_1","type":"Amount","name":"Document level charge base amount"},
"BT-101":{"level":"2","card":"0_1","type":"Percentage","name":"Document level charge percentage"},
"BT-102":{"level":"2","card":"1_1","type":"Code","name":"Document level charge VAT category code"},
"BT-103":{"level":"2","card":"0_1","type":"Percentage","name":"Document level charge VAT rate"},
"BT-104":{"level":"2","card":"0_1","type":"Text","name":"Document level charge reason"},
"BT-105":{"level":"2","card":"0_1","type":"Code","name":"Document level charge reason code"},
"BG-22":{"level":"1","card":"1_1","type":"","name":"DOCUMENT TOTALS"},
"BT-106":{"level":"2","card":"1_1","type":"Amount","name":"Sum of Invoice line net amount"},
"BT-107":{"level":"2","card":"0_1","type":"Amount","name":"Sum of allowances on document level"},
"BT-108":{"level":"2","card":"0_1","type":"Amount","name":"Sum of charges on document level"},
"BT-109":{"level":"2","card":"1_1","type":"Amount","name":"Invoice total amount without VAT"},
"BT-110":{"level":"2","card":"0_1","type":"Amount","name":"Invoice total VAT amount"},
"BT-111":{"level":"2","card":"0_1","type":"Amount","name":"Invoice total VAT amount in accounting currency"},
"BT-112":{"level":"2","card":"1_1","type":"Amount","name":"Invoice total amount with VAT"},
"BT-113":{"level":"2","card":"0_1","type":"Amount","name":"Paid amount"},
"BT-114":{"level":"2","card":"0_1","type":"Amount","name":"Rounding amount"},
"BT-115":{"level":"2","card":"1_1","type":"Amount","name":"Amount due for payment"},
"BG-23":{"level":"1","card":"1_n","type":"","name":"VAT BREAKDOWN"},
"BT-116":{"level":"2","card":"1_1","type":"Amount","name":"VAT category taxable amount"},
"BT-117":{"level":"2","card":"1_1","type":"Amount","name":"VAT category tax amount"},
"BT-118":{"level":"2","card":"1_1","type":"Code","name":"VAT category code "},
"BT-119":{"level":"2","card":"0_1","type":"Percentage","name":"VAT category rate"},
"BT-120":{"level":"2","card":"0_1","type":"Text","name":"VAT exemption reason text"},
"BT-121":{"level":"2","card":"0_1","type":"Code","name":"VAT exemption reason code"},
"BG-24":{"level":"1","card":"0_n","type":"","name":"ADDITIONAL SUPPORTING DOCUMENTS"},
"BT-122":{"level":"2","card":"1_1","type":"DocumentReference","name":"Supporting document reference"},
"BT-123":{"level":"2","card":"0_1","type":"Text","name":"Supporting document description"},
"BT-124":{"level":"2","card":"0_1","type":"Text","name":"External document location"},
"BT-125":{"level":"2","card":"0_1","type":"Binaryobject","name":"Attached document"},
"BT-125A":{"level":"2","card":"1_1","type":"","name":"Attached document Mime code"},
"BT-125B":{"level":"2","card":"1_1","type":"","name":"Attached document Filename"},
"BG-25":{"level":"1","card":"1_n","type":"","name":"INVOICE LINE"},
"BT-126":{"level":"2","card":"1_1","type":"Identifier","name":"Invoice line identifier"},
"BT-127":{"level":"2","card":"0_1","type":"Text","name":"Invoice line note"},
"BT-128":{"level":"2","card":"0_1","type":"Identifier","name":"Invoice line object identifier"},
"BT-128A":{"level":"2","card":"0_1","type":"","name":"Scheme identifier"},
"BT-129":{"level":"2","card":"1_1","type":"Quantity","name":"Invoiced quantity"},
"BT-130":{"level":"2","card":"1_1","type":"Code","name":"Invoiced quantity unit of measure code"},
"BT-131":{"level":"2","card":"1_1","type":"Amount","name":"Invoice line net amount"},
"BT-132":{"level":"2","card":"0_1","type":"DocumentReference","name":"Referenced purchase order line reference"},
"BT-133":{"level":"2","card":"0_1","type":"Text","name":"Invoice line Buyer accounting reference"},
"BG-26":{"level":"2","card":"0_1","type":"","name":"INVOICE LINE PERIOD"},
"BT-134":{"level":"3","card":"0_1","type":"Date","name":"Invoice line period start date"},
"BT-135":{"level":"3","card":"0_1","type":"Date","name":"Invoice line period end date"},
"BG-27":{"level":"2","card":"0_n","type":"","name":"INVOICE LINE ALLOWANCES"},
"BT-136":{"level":"3","card":"1_1","type":"Amount","name":"Invoice line allowance amount"},
"BT-137":{"level":"3","card":"0_1","type":"Amount","name":"Invoice line allowance base amount"},
"BT-138":{"level":"3","card":"0_1","type":"Percentage","name":"Invoice line allowance percentage"},
"BT-139":{"level":"3","card":"0_1","type":"Text","name":"Invoice line allowance reason"},
"BT-140":{"level":"3","card":"0_1","type":"Code","name":"Invoice line allowance reason code"},
"BG-28":{"level":"2","card":"0_n","type":"","name":"INVOICE LINE CHARGES"},
"BT-141":{"level":"3","card":"1_1","type":"Amount","name":"Invoice line charge amount"},
"BT-142":{"level":"3","card":"0_1","type":"Amount","name":"Invoice line charge base amount"},
"BT-143":{"level":"3","card":"0_1","type":"Percentage","name":"Invoice line charge percentage"},
"BT-144":{"level":"3","card":"0_1","type":"Text","name":"Invoice line charge reason"},
"BT-145":{"level":"3","card":"0_1","type":"Code","name":"Invoice line charge reason code"},
"BG-29":{"level":"2","card":"1_1","type":"","name":"PRICE DETAILS"},
"BT-146":{"level":"3","card":"1_1","type":"Unit price amount","name":"Item net price"},
"BT-147":{"level":"3","card":"0_1","type":"Unit price amount","name":"Item price discount"},
"BT-148":{"level":"3","card":"0_1","type":"Unit price amount","name":"Item gross price"},
"BT-149":{"level":"3","card":"0_1","type":"Quantity","name":"Item price base quantity"},
"BT-150":{"level":"3","card":"0_1","type":"Code","name":"Item price base quantity unit of measure code"},
"BG-30":{"level":"2","card":"1_1","type":"","name":"LINE VAT INFORMATION"},
"BT-151":{"level":"3","card":"1_1","type":"Code","name":"Invoiced item VAT category code"},
"BT-152":{"level":"3","card":"0_1","type":"Percent","name":"Invoiced item VAT rate"},
"BG-31":{"level":"2","card":"1_1","type":"","name":"ITEM INFORMATION"},
"BT-153":{"level":"3","card":"1_1","type":"Text","name":"Item name"},
"BT-154":{"level":"3","card":"0_1","type":"Text","name":"Item description"},
"BT-155":{"level":"3","card":"0_1","type":"Identifier","name":"Item Seller's identifier"},
"BT-156":{"level":"3","card":"0_1","type":"Identifier","name":"Item Buyer's identifier"},
"BT-157":{"level":"3","card":"0_1","type":"Identifier","name":"Item standard identifier"},
"BT-157A":{"level":"3","card":"1_1","type":"","name":"Scheme identifier"},
"BT-158":{"level":"3","card":"0_n","type":"Identifier","name":"Item classification identifier"},
"BT-158A":{"level":"3","card":"1_1","type":"","name":"Scheme identifier"},
"BT-158B":{"level":"3","card":"0_1","type":"","name":"Scheme version identifier"},
"BT-159":{"level":"3","card":"0_1","type":"Code","name":"Item country of origin"},
"BG-32":{"level":"3","card":"0_n","type":"","name":"ITEM ATTRIBUTES"},
"BT-160":{"level":"4","card":"1_1","type":"Text","name":"Item attribute name"},
"BT-161":{"level":"4","card":"1_1","type":"Text","name":"Item attribute value"}
};