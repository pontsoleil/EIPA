
bin/parsrx.sh -n ubl2.1/UBL-CommonBasicComponents-2.1.xsd > ubl2.1/cbc.tmp
bin/parsrx.sh -n ubl2.1/UBL-CommonAggregateComponents-2.1.xsd > ubl2.1/cac.tmp
bin/parsrx.sh -n ubl2.1/UBL-Invoice-2.1.xsd > ubl2.1/ivc.tmp
bin/parsrx.sh -n ubl2.1/UBL-CreditNote-2.1.xsd > ubl2.1/cnt.tmp

bin/makrj.sh ubl2.1/cac.tmp > ubl2.1/cac.json
bin/makrj.sh ubl2.1/cbc.tmp > ubl2.1/cbc.json
bin/makrj.sh ubl2.1/ivc.tmp > ubl2.1/ivc.json
bin/makrj.sh ubl2.1/cnt.tmp > ubl2.1/cnt.json

bin/parsrx.sh -n ubl2.1/UBL-Invoice-2.1.xsd > ubl2.1/Invoice-2.tmp
bin/makrj.sh ubl2.1/Invoice-2.tmp > ubl2.1/Invoice-2.json
