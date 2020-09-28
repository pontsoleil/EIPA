CWA 16356-3:2011 (E)
6 Annexes
A. xPaths Table Spreadsheet
Separate File: Part 3 Annex A_CEN_Core_Invoice_xPaths_CodeAndIDAttributes_v1.0.zip
B. XML Schema Pack
Separate zipped File containing section I, II, III and IV below:
Part 3 Annex B_CEN_Core_Invoice_Example_Schema_Pack_v1.0.zip

EXPAND B_CEN_Core_Invoice_Example_Schema_Pack_v1.0.zip
and copy from
CEN/CEN_Core_Invoice_Example_Schema_Pack_v1.0/data/standard


bin/parsrx.sh -n cii/CoreComponentType_2p0.xsd> cii/cct.tmp
bin/parsrx.sh -n cii/CrossIndustryInvoice_2p0.xsd > cii/cii.tmp
bin/parsrx.sh -n cii/QualifiedDataType_8p0.xsd > cii/qdt.tmp
bin/parsrx.sh -n cii/UnqualifiedDataType_9p0.xsd > cii/udt.tmp
bin/parsrx.sh -n cii/ReusableAggregateBusinessInformationEntity_8p0.xsd > cii/abie.tmp

cat cii/cct.tmp | tr -d $'\r' | bin/makrj.sh > cii/cct.json
cat cii/cii.tmp | tr -d $'\r' | bin/makrj.sh > cii/cii.json
cat cii/qdt.tmp | tr -d $'\r' | bin/makrj.sh > cii/qdt.json
cat cii/udt.tmp | tr -d $'\r' | bin/makrj.sh > cii/udt.json
cat cii/abie.tmp | tr -d $'\r' | bin/makrj.sh > cii/abie.json