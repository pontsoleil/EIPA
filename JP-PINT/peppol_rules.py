#!/usr/bin/env python3
#coding: utf-8
#
# generate PEPPOL rules html fron CSV file
# 
# This software was designed by SAMBUICHI,Nobuyuki (Sambuichi Professional Engineers Office)
# and it was written by SAMBUICHI,Nobuyuki (Sambuichi Professional Engineers Office).
#
# ==== MIT License ====
# 
# Copyright (c) 2021 SAMBUICHI Nobuyuki (Sambuichi Professional Engineers Office)
# 
# Permission is hereby granted,free of charge,to any person obtaining a copy
# of this software and associated documentation files (the "Software"),to deal
# in the Software without restriction,including without limitation the rights
# to use,copy,modify,merge,publish,distribute,sublicense,and/or sell
# copies of the Software,and to permit persons to whom the Software is
# furnished to do so,subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS",WITHOUT WARRANTY OF ANY KIND,EXPRESS OR
# IMPLIED,INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,DAMAGES OR OTHER
# LIABILITY,WHETHER IN AN ACTION OF CONTRACT,TORT OR OTHERWISE,ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
import csv
import collections
from collections import OrderedDict
import re
import json
import sys 
import os
import argparse

import jp_pint_constants

APP_BASE = jp_pint_constants.APP_BASE
SEMANTIC_BASE = jp_pint_constants.SEMANTIC_BASE
SYNTAX_BASE = jp_pint_constants.SYNTAX_BASE
RULES_BASE = jp_pint_constants.RULES_BASE
RULES_UBL_JAPAN_BASE = jp_pint_constants.RULES_UBL_JAPAN_BASE
RULES_UBL_PINT_BASE = jp_pint_constants.RULES_UBL_PINT_BASE
SPEC_TITLE_en = jp_pint_constants.SPEC_TITLE_en
SPEC_TITLE_ja = jp_pint_constants.SPEC_TITLE_ja
SEMANTICS_MESSAGE_TITLE_en = jp_pint_constants.SEMANTICS_MESSAGE_TITLE_en
SEMANTICS_MESSAGE_TITLE_ja = jp_pint_constants.SEMANTICS_MESSAGE_TITLE_ja
SYNTAX_MESSAGE_TITLE_en = jp_pint_constants.SYNTAX_MESSAGE_TITLE_en
SYNTAX_MESSAGE_TITLE_ja = jp_pint_constants.SYNTAX_MESSAGE_TITLE_ja
peppol_rule_MESSAGE_TITLE_en = jp_pint_constants.peppol_rule_MESSAGE_TITLE_en
peppol_rule_MESSAGE_TITLE_ja = jp_pint_constants.peppol_rule_MESSAGE_TITLE_ja
cen_rule_MESSAGE_TITLE_en = jp_pint_constants.cen_rule_MESSAGE_TITLE_en
cen_rule_MESSAGE_TITLE_ja = jp_pint_constants.cen_rule_MESSAGE_TITLE_ja
HOME_en = jp_pint_constants.HOME_en
HOME_ja = jp_pint_constants.HOME_ja

html_head = jp_pint_constants.html_head
javascript_html = jp_pint_constants.javascript_html
navbar_html = jp_pint_constants.navbar_html
dropdown_menu_en = jp_pint_constants.dropdown_menu_en.format(APP_BASE)
dropdown_menu_ja = jp_pint_constants.dropdown_menu_ja.format(APP_BASE)

legend_en ='''
<h3>TBD</h3>
'''
legend_ja = '''
<h3>未定</h3>
'''
table_html = '''
				<table class="{0} rules table table-sm table-hover" style="table-layout: fixed; width: 100%;">
					<colgroup>
						<col span="1" style="width: 90%;">
						<col span="1" style="width: 10%;">
					</colgroup>
					<thead>
						<th>{1}</th>
						<th>{2}</th>
					</thead>
					<tbody>
'''
table_trailer = jp_pint_constants.table_trailer
trailer = jp_pint_constants.trailer
# 
# ITEM
# 
item_head = jp_pint_constants.item_head
info_item_modal_en = '''
<h3>ISO/IEC 19757-3:2016(E)</h3>
<h5>Information technology -- Document Schema definition languages (DSDL) -- <br />part 3: Rule-based validation -- Schemetron</h5>
<h5>rule element</h5>
A list of assertions tested within the conttext specified by the required <strong>context</strong> attribute. The <strong>context</strong> attribute specifies the rule context expression.<br />
<br />
<h5>assert element</h5>
An assertion made about the context nodes. The data contents is a natural-language assertion. The required <strong>test</strong> attribute is an assertion test evaluated in the current context. If the test evaluates positive, the report succeeds.
The natural-language assertion shall be a positive statement of a constraint.<br />
The <strong>flag</strong> attribute allows more detailed outcomes.
'''
info_item_modal_ja = info_item_modal_en
item_navbar = jp_pint_constants.item_navbar
# 0.lang 1.HOME_en 2.'Transction Business Rules' 3.'en-peppol' 4.peppol_rule_MESSAGE_TITLE_en 5.id 6.APP_BASE
item_breadcrumb = '''
			<ol class="breadcrumb pt-1 pb-1">
        <li class="breadcrumb-item"><a href="{6}{0}/">{1}</a></li>
        <li class="breadcrumb-item"><a href="{6}rules/{0}">{2}</a></li>
        <li class="breadcrumb-item"><a href="{6}rules/{3}/{0}/">{4}</a></li>
        <li class="breadcrumb-item active">{5}</li>
    </ol>
'''
item_header = jp_pint_constants.item_header
item_data = '''
				<dt class="col-3">{0}</dt><dd class="col-9">{1}</dd>
				<dt class="col-3">{2}</dt><dd class="col-9">{3}</dd>
				<dt class="col-3">{4}</dt><dd class="col-9">{5}</dd>
				<dt class="col-3">{6}</dt><dd class="col-9">{7}</dd>
'''
item_data2 = '''
				<dt class="col-3">{0}</dt><dd class="col-9">{1}</dd>
				<dt class="col-3">{2}</dt><dd class="col-9">{3}</dd>
				<dt class="col-3">{4}</dt><dd class="col-9">{5}</dd>
				<dt class="col-3">{6}</dt><dd class="col-9">{7}</dd>
				<dt class="col-3">{8}</dt><dd class="col-9">{9}</dd>
'''
item_data3 = '''
				<dt class="col-3">{0}</dt><dd class="col-9">{1}</dd>
				<dt class="col-3">{2}</dt><dd class="col-9">{3}</dd>
				<dt class="col-3">{4}</dt><dd class="col-9">{5}</dd>
				<dt class="col-3">{6}</dt><dd class="col-9">{7}</dd>
				<dt class="col-3">{8}</dt><dd class="col-9">{9}</dd>
				<dt class="col-3">{10}</dt><dd class="col-9">{11}</dd>
'''
item_table_head = '''
					<table class="table table-borderless table-sm table-hover">
						<colgroup>
							<col span="1" style="width: 20%;">
							<col span="1" style="width: 80%;">
						</colgroup>
						<tbody>
'''
# 0.lang 1.id 2.term 3.APP_BASE 4.pint_id
item_table_row = '''
						<tr>
							<td><a href="{3}semantic/invoice/{4}/{0}/">{1}</a></td>
							<td>{2}</td>
						</tr>
'''
item_table_trailer = '''
						</tbody>
					</table>
''' 
item_trailer = jp_pint_constants.item_trailer

datatypeDict = {
	'ID': 'Identifier',
	'Unit': 'Unit Price Amount',
	'REF (Optional)': 'Document Reference',
	'Binary': 'Binary objects'
}

variables = {
	'profile':"if (/*/cbc:ProfileID and matches(normalize-space(/*/cbc:ProfileID), 'urn:fdc:peppol.eu:2017:poacc:billing:([0-9]\{2\}):1.0')) then<br /> \
	&nbsp;&nbsp;&nbsp;tokenize(normalize-space(/*/cbc:ProfileID), ':')[7]<br /> \
	&nbsp;&nbsp;else<br /> \
	&nbsp;&nbsp;&nbsp;'Unknown'",
	'supplierCountry':"if (/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)) then<br /> \
	&nbsp;&nbsp;&nbsp;upper-case(normalize-space(/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)))<br /> \
	&nbsp;&nbsp;else<br /> \
	&nbsp;&nbsp;&nbsp;if (/*/cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)) then<br /> \
	&nbsp;&nbsp;&nbsp;&nbsp;upper-case(normalize-space(/*/cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)))<br /> \
	&nbsp;&nbsp;&nbsp;else<br /> \
	&nbsp;&nbsp;&nbsp;&nbsp;if (/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) then<br /> \
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;upper-case(normalize-space(/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))<br /> \
	&nbsp;&nbsp;&nbsp;&nbsp;else<br /> \
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'XX'",
	'customerCountry':"if (/*/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)) then<br /> \
	&nbsp;upper-case(normalize-space(/*/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)))<br /> \
	&nbsp;else<br /> \
	&nbsp;if (/*/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) then<br /> \
	&nbsp;upper-case(normalize-space(/*/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))<br /> \
	&nbsp;else<br /> \
	&nbsp;'XX'",
	'documentCurrencyCode':"'/*/cbc:DocumentCurrencyCode",
	'lineExtensionAmount':"if (cbc:LineExtensionAmount) then<br /> \
	&nbsp;&nbsp;&nbsp;xs:decimal(cbc:LineExtensionAmount)<br /> \
	&nbsp;&nbsp;else<br /> \
	&nbsp;&nbsp;&nbsp;0",
	'quantity':"if (/ubl-invoice:Invoice) then<br /> \
	&nbsp;&nbsp;&nbsp;(if (cbc:InvoicedQuantity) then<br /> \
	&nbsp;&nbsp;&nbsp;&nbsp;xs:decimal(cbc:InvoicedQuantity)<br /> \
	&nbsp;&nbsp;&nbsp;else<br /> \
	&nbsp;&nbsp;&nbsp;&nbsp;1)<br /> \
	&nbsp;&nbsp;else<br /> \
	&nbsp;&nbsp;&nbsp;(if (cbc:CreditedQuantity) then<br /> \
	&nbsp;&nbsp;&nbsp;&nbsp;xs:decimal(cbc:CreditedQuantity)<br /> \
	&nbsp;&nbsp;&nbsp;else<br /> \
	&nbsp;&nbsp;&nbsp;&nbsp;1)",
	'priceAmount':"if (cac:Price/cbc:PriceAmount) then<br /> \
	&nbsp;&nbsp;&nbsp;xs:decimal(cac:Price/cbc:PriceAmount)<br /> \
	&nbsp;&nbsp;else<br /> \
	&nbsp;&nbsp;&nbsp;0",
	'baseQuantity':"if (cac:Price/cbc:BaseQuantity and xs:decimal(cac:Price/cbc:BaseQuantity) != 0) then<br /> \
	&nbsp;&nbsp;&nbsp;xs:decimal(cac:Price/cbc:BaseQuantity)<br /> \
	&nbsp;&nbsp;else<br /> \
	&nbsp;&nbsp;&nbsp;1",
	'allowancesTotal':"if (cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'false']) then<br /> \
	&nbsp;&nbsp;&nbsp;round(sum(cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'false']/cbc:Amount/xs:decimal(.)) * 10 * 10) div 100<br /> \
	&nbsp;&nbsp;else<br /> \
	&nbsp;&nbsp;&nbsp;0",
	'chargesTotal':"if (cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'true']) then<br /> \
	&nbsp;&nbsp;&nbsp;round(sum(cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'true']/cbc:Amount/xs:decimal(.)) * 10 * 10) div 100<br /> \
	&nbsp;&nbsp;else<br /> \
	&nbsp;&nbsp;&nbsp;0",
	'quantity':"if (/ubl-invoice:Invoice) then<br /> \
	&nbsp;&nbsp;&nbsp;../../cbc:InvoicedQuantity<br /> \
	&nbsp;&nbsp;else<br /> \
	&nbsp;&nbsp;&nbsp;../../cbc:CreditedQuantity",
  'DKSupplierCountry':"concat(ubl-creditnote:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode, ubl-invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)",
  'DKCustomerCountry':"concat(ubl-creditnote:CreditNote/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode, ubl-invoice:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)",
	'isGreekSender':"($supplierCountry ='GR') or ($supplierCountry ='EL')",
	'isGreekReceiver':"($customerCountry ='GR') or ($customerCountry ='EL')",
	'isGreekSenderandReceiver':"$isGreekSender and $isGreekReceiver",
	'accountingSupplierCountry':"if (/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)) then<br /> \
	&nbsp;upper-case(normalize-space(/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)))<br /> \
	&nbsp;else<br /> \
	&nbsp;if (/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) then<br /> \
	&nbsp;upper-case(normalize-space(/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))<br /> \
	&nbsp;else<br /> \
	&nbsp;'XX'",
	'dateRegExp':'^(0?[1-9]|[12][0-9]|3[01])[-\\/ ]?(0?[1-9]|1[0-2])[-\\/ ]?(19|20)[0-9]\{2\}',
	'greekDocumentType':"tokenize('1.1 1.2 1.3 1.4 1.5 1.6 2.1 2.2 2.3 2.4 3.1 3.2 4 5.1 5.2 6.1 6.2 7.1 8.1 8.2 11.1 11.2 11.3 11.4 11.5','\s')",
	'tokenizedUblIssueDate':"tokenize(/*/cbc:IssueDate,'-')",
	'IdSegments':"tokenize(.,'\|')",
	'tokenizedIdDate':"tokenize($IdSegments[2],'/')",
	'ISO3166':"tokenize('AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW 1A XI', '\s')",
	'ISO4217':"tokenize('AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STN SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL', '\s')",
	'MIMECODE':"tokenize('application/pdf image/png image/jpeg text/csv application/vnd.openxmlformats-officedocument.spreadsheetml.sheet application/vnd.oasis.opendocument.spreadsheet', '\s')",
	'UNCL2005':"tokenize('3 35 432', '\s')",
	'UNCL5189':"tokenize('41 42 60 62 63 64 65 66 67 68 70 71 88 95 100 102 103 104 105', '\s')",
	'UNCL7161':"tokenize('AA AAA AAC AAD AAE AAF AAH AAI AAS AAT AAV AAY AAZ ABA ABB ABC ABD ABF ABK ABL ABN ABR ABS ABT ABU ACF ACG ACH ACI ACJ ACK ACL ACM ACS ADC ADE ADJ ADK ADL ADM ADN ADO ADP ADQ ADR ADT ADW ADY ADZ AEA AEB AEC AED AEF AEH AEI AEJ AEK AEL AEM AEN AEO AEP AES AET AEU AEV AEW AEX AEY AEZ AJ AU CA CAB CAD CAE CAF CAI CAJ CAK CAL CAM CAN CAO CAP CAQ CAR CAS CAT CAU CAV CAW CAX CAY CAZ CD CG CS CT DAB DAC DAD DAF DAG DAH DAI DAJ DAK DAL DAM DAN DAO DAP DAQ DL EG EP ER FAA FAB FAC FC FH FI GAA HAA HD HH IAA IAB ID IF IR IS KO L1 LA LAA LAB LF MAE MI ML NAA OA PA PAA PC PL RAB RAC RAD RAF RE RF RH RV SA SAA SAD SAE SAI SG SH SM SU TAB TAC TT TV V1 V2 WH XAA YY ZZZ', '\s')",
	'UNCL5305':"tokenize('AE E S Z G O K L M', '\s')",
	'eaid':"tokenize('0002 0007 0009 0037 0060 0088 0096 0097 0106 0130 0135 0142 0151 0183 0184 0190 0191 0192 0193 0195 0196 0198 0199 0200 0201 0202 0204 0208 0209 0210 0211 0212 0213 9901 9906 9907 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9955 9957', '\s')"
}

def file_path(pathname):
	if '/' == pathname[0:1]:
		return pathname
	else:
		dir = os.path.dirname(__file__)
		new_path = os.path.join(dir,pathname)
		return new_path

def writeTr_en(f,type,data):
	html = '''
							<tr data-id="{0}">
								<td class="info-link"><a href="{1}">{0}</a><br />{2}</td>
								<td>{3}</td>
							</tr>
	'''
	id = data['id']
	flag = data['flag']
	text = data['text']
	item_dir = RULES_BASE+type+id+'/en/'
	html = html.format(id,item_dir,text,flag)
	f.write(html)

def writeTr_ja(f,type,data):
	html = '''
							<tr data-id="{0}">
								<td class="info-link"><a href="{1}">{0}</a><br />{2}</td>
								<td>{3}</td>
							</tr>
	'''
	# tabs = '\t\t\t\t\t\t'
	id = data['id']
	flag = data['flag']
	text = data['text']
	item_dir = RULES_BASE+type+id+'/ja/'
	html = html.format(id,item_dir,text,flag)
	f.write(html)

def blank2fa_minus(str):
	if str:
		return str
	return '<i class="fa fa-minus" aria-hidden="true"></i>'

def lookupBG(data, lang):
	table ='<i class="fa fa-minus" aria-hidden="true"></i>'
	BGs = data['BG']
	if len(BGs) > 0:
		table = item_table_head
		BGs = BGs.split(' ')
		for id in BGs:
			if 'BG' == id[:2]:
				pint_id = 'i'+id[:3].lower()+'{:02d}'.format(int(id[3:]))
			elif 'BT' == id[:2]:
				pint_id = 'i'+id[:3].lower()+'{:03d}'.format(int(id[3:]))
			else:
				continue
			if 'ja' == lang:
				term = [x['BT_ja'] for x in pint_list if pint_id == x['PINT_ID']]
			else:
				term = [x['BT'] for x in pint_list if pint_id == x['PINT_ID']]
			if len(term) > 0:
				term = term[0]
				table += item_table_row.format(lang,id,term,APP_BASE,pint_id)
			else:
				table += item_table_row.format(lang,id,'Not found',APP_BASE,pint_id)
		table += item_table_trailer
	return table
		
def lookupBT(data,lang):
	table = '<i class="fa fa-minus" aria-hidden="true"></i>'
	BTs = data['BT']
	if len(BTs) > 0:
		table = item_table_head
		BTs = BTs.split(' ')
		for id in BTs:
			if 'BG' == id[:2]:
				pint_id = 'i'+id[:3].lower()+'{:02d}'.format(int(id[3:]))
			elif 'BT' == id[:2]:
				pint_id = 'i'+id[:3].lower()+'{:03d}'.format(int(id[3:]))
			else:
				continue
			if 'ja' == lang:
				term = [x['BT_ja'] for x in pint_list if pint_id == x['PINT_ID']]
			else:
				term = [x['BT'] for x in pint_list if pint_id == x['PINT_ID']]
			if len(term) > 0:
				term = term[0]
				table += item_table_row.format(lang,id,term,APP_BASE,pint_id)
			else:
				table += item_table_row.format(lang,id,'Not found',APP_BASE,pint_id)
		table += item_table_trailer
	return table

def lookupBGT(id,lang):
	rule = cen_rule_dict[id]
	if len(rule) > 0:
		pint_ids = rule['PINT_IDs']
	else:
		rule = peppol_rule_dict[id]
		if len(rule) > 0:
			pint_ids = rule['PINT_IDs']
	pint_ids = pint_ids.split(' ')
	BGs = ' '.join([x for x in pint_ids if re.match(r'^BG-.*$',x)])
	BGroup = termTable(BGs,lang)
	BTs = ' '.join([x for x in pint_ids if re.match(r'^BT-.*$',x)])
	BTerm = termTable(BTs,lang)
	return {'BGroup':BGroup,'BTerm':BTerm}

def termTable(terms,lang):
	table = '<i class="fa fa-minus" aria-hidden="true"></i>'
	if len(terms) > 0:
		table = item_table_head
		terms = terms.split(' ')
		for id in terms:
			if 'BG' == id[:2]:
				pint_id = 'i'+id[:3].lower()+'{:02d}'.format(int(id[3:]))
			elif 'BT' == id[:2]:
				pint_id = 'i'+id[:3].lower()+'{:03d}'.format(int(id[3:]))
			else:
				continue
			if 'ja' == lang:
				term = [x['BT_ja'] for x in pint_list if pint_id == x['PINT_ID']]
			else:
				term = [x['BT'] for x in pint_list if pint_id == x['PINT_ID']]
			if len(term) > 0:
				term = term[0]
				table += item_table_row.format(lang,id,term,APP_BASE,pint_id)
			else:
				table += item_table_row.format(lang,id,'Not found',APP_BASE,pint_id)
		table += item_table_trailer
	return table

if __name__ == '__main__':
	# Create the parser
	parser = argparse.ArgumentParser(prog='peppol_rules.py',
																	usage='%(prog)s [options] infile ppeppol_rulefile cen_rulefile ubl_notfile',
																	description='CSVファイルからPEPPOLのHTMLファイル(ルール)を作成')
	# Add the arguments
	parser.add_argument('inFile',metavar='infile',type=str,help='入力TSVファイル')
	parser.add_argument('peppol_ruleFile',metavar='peppol_rulefile',type=str,help='PEPPOLルールCSVファイル')
	parser.add_argument('cen_ruleFile',metavar='cen_rulefile',type=str,help='CENルールCSVファイル')
	parser.add_argument('ubl_notFile',metavar='ubl_notfile',type=str,help='UBL不使用項目CSVファイル')
	parser.add_argument('-v','--verbose',action='store_true')
	args = parser.parse_args()

	in_file = file_path(args.inFile)
	peppol_rule_file = file_path(args.peppol_ruleFile)
	cen_rule_file = file_path(args.cen_ruleFile)
	ubl_not_file = file_path(args.ubl_notFile)

	peppol_rule_en_html = 'billing-japan/rules/en-peppol/en/index.html'
	peppol_rule_ja_html = 'billing-japan/rules/en-peppol/ja/index.html'
	cen_rule_en_html = 'billing-japan/rules/en-cen/en/index.html'
	cen_rule_ja_html = 'billing-japan/rules/en-cen/ja/index.html'

	verbose = args.verbose
	# Check if infile exists
	if not os.path.isfile(in_file):
		print('入力ファイルがありません')
		sys.exit()
	if verbose:
		print('** START ** ',__file__)

	# Read Rule CSV file
	rule_keys = ('context','id','flag','test','text')
	peppol_rule_dict = {}
	with open(peppol_rule_file,'r',encoding='utf-8',newline='') as f:
		reader = csv.DictReader(f,rule_keys)
		header = next(reader)
		for row in reader:
			id = row['id']
			flag = row['flag']
			text = row['text']
			context = row['context']
			test = row['test']
			vars = re.findall('\$([a-zA-Z]*)',context)
			if len(vars) > 0 and vars[0]:
				varSet = set()
				for v in vars:
					if v in variables:
						d = variables[v]
						varSet.add(v+' : '+d)
				if len(varSet) > 0:
					vars = '$'+json.dumps('<br />$'.join(list(varSet)))[1:-1]
				else:
					vars = None
			else:
				vars = None
			tVars = re.findall('\$([a-zA-Z]*)',test)
			if len(tVars) > 0 and tVars[0]:
				tVarSet = set()
				for v in tVars:
					if v in variables:
						d = variables[v]
						tVarSet.add(v+' : '+d)
				if len(tVarSet) > 0:
					tVars = '$'+json.dumps('<br />$'.join(list(tVarSet)))[1:-1]
				else:
					tVars = None
			else:
				tVars = None
			data = { # 'context','id','flag','test','text'
				'id':id,
				'flag':flag,
				'text':text,
				'context':context,
				'test':test,
				'vars':vars,
				'tVars':tVars
			}
			rulesBG = re.findall(r'(BG-[0-9]+)',text)
			data['BG'] = ' '.join(rulesBG)
			rulesBT = re.findall(r'(BT-[0-9]+)',text)
			data['BT'] = ' '.join(rulesBT)
			rules = rulesBG + rulesBT
			data['PINT_IDs'] = ' '.join(rules)
			peppol_rule_dict[id] = data

	cen_rule_dict = {}
	with open(cen_rule_file,'r',encoding='utf-8',newline='') as f:
		reader = csv.DictReader(f,rule_keys)
		header = next(reader)
		for row in reader:
			id = row['id']
			flag = row['flag']
			text = row['text']
			context = row['context']
			test = row['test']
			vars = re.findall('\$([a-zA-Z]*)',context)
			if len(vars) > 0 and vars[0]:
				varSet = set()
				for v in vars:
					if v in variables:
						d = variables[v]
						varSet.add(v+' : '+d)
				if len(varSet) > 0:
					vars = '$'+json.dumps('<br />$'.join(list(varSet)))[1:-1]
				else:
					vars = None
			else:
				vars = None
			tVars = re.findall('\$([a-zA-Z]*)',test)
			if len(tVars) > 0 and tVars[0]:
				tVarSet = set()
				for v in tVars:
					if v in variables:
						d = variables[v]
						tVarSet.add(v+' : '+d)
				if len(tVarSet) > 0:
					tVars = '$'+json.dumps('<br />$'.join(list(tVarSet)))[1:-1]
				else:
					tVars = None
			else:
				tVars = None
			data = { # 'context','id','flag','test','text'
				'id':id,
				'flag':flag,
				'text':text,
				'context':context,
				'test':test,
				'vars':vars,
				'tVars':tVars
			}
			rulesBG = re.findall(r'(BG-[0-9]+)',text)
			data['BG'] = ' '.join(rulesBG)
			rulesBT = re.findall(r'(BT-[0-9]+)',text)
			data['BT'] = ' '.join(rulesBT)
			rules = rulesBG + rulesBT
			data['PINT_IDs'] = ' '.join(rules)
			cen_rule_dict[id] = data

	# Read UBL2.1 not used file
	not_keys = ('Sort','UBL_Sort','SynSort','PINT_ID','Schematron','XPath','Level','CC','Datatype','Occurrence')
	ubl_not_dict = {}
	with open(ubl_not_file,'r',encoding='utf-8',newline='') as f:
		reader = csv.DictReader(f,not_keys)
		header = next(reader)
		for row in reader:
			XPath = row['XPath']
			PINT_ID = row['PINT_ID']
			Schematron = row['Schematron']
			Datatype = row['Datatype']
			Occurrence = row['Occurrence']
			data = {
				'XPath':XPath,
				'PINT_ID':PINT_ID,
				'Schematron':Schematron,
				'Datatype':Datatype,
				'Occurrence':Occurrence
			}
			ubl_not_dict[XPath] = data

	# Read CSV file
	# csv_list = []
	keys = (
		'SemSort','EN_ID','PINT_ID','Level','BT','BT_ja','Desc','Desc_ja','Exp','Exp_ja','Example',
		'Card','DT','Section','Extension','SynSort','Path','Attr','Rules','Datatype','Occ','Align'
	)
	csv_item = OrderedDict([
		('SemSort','0000'),
		('EN_ID','BG-0'),
		('PINT_ID','ibg-00'),
		('Level','0'),
		('BT','Invoice'),
		('BT_ja','インボイス'),
		('Desc',''),
		('Desc_ja',''),
		('Exp',''),
		('Exp_ja',''),
		('Example',''),
		('Card','1..n'),
		('DT',''),
		('Section',''),
		('Extension',''),
		('SynSort','0000'),
		('Path','/Invoice'),
		('Attr',''),
		('Rules',''),
		('Datatype','InvoiceType'),
		('Occ','1..n'),
		('Align','')
	])
	csv_list = [csv_item]
	with open(in_file,'r',encoding='utf-8',newline='') as f:
		reader = csv.DictReader(f,keys)
		header = next(reader)
		header = next(reader)
		for row in reader:
			csv_list.append(row)

	pint_list = [{
			"SemSort": "0000",
			"EN_ID": "BG-0",
			"PINT_ID": "ibg-00",
			"Level": "0",
			"BT": "Invoice",
			"BT_ja": "インボイス",
			"Desc": "",
			"Desc_ja": "",
			"Exp": "",
			"Exp_ja": "",
			"Example": "",
			"Card": "1..1 ",
			"DT": "",
			"Section": "Shared",
			"Extension": "",
			"SynSort": "0000",
			"Path": "/Invoice",
			"Attr": "",
			"Rules": "",
			"Datatype":"",
			"Occ":"",
			"Align":""
		}]+[x for x in csv_list if ''!=x['SynSort'] and ''!=x['Path']]
	pint_list = sorted(pint_list,key=lambda x: x['SynSort'])

	rules = {}
	rule_dict = {}
	for data in pint_list:
		level = data['Level']
		if level:
			pint_id = data['PINT_ID']
			rules[pint_id] = set()
			for k,v in peppol_rule_dict.items():
				rule_dict[k] = v
				pint_ids = v['PINT_IDs']
				if pint_ids:
					pint_ids = pint_ids.split(' ')
					if pint_id in pint_ids:
						rules[pint_id].add(k)
			for k,v in cen_rule_dict.items():
				rule_dict[k] = v
				pint_ids = v['PINT_IDs']
				if pint_ids:
					pint_ids = pint_ids.split(' ')
					if pint_id in pint_ids:
						rules[pint_id].add(k)

	def listUndefInSchematron():
		Rs = ''
		tests = [v['test'] for k,v in rule_dict.items() \
			if re.match(r'UBL-.*',v['id']) and re.match(r'^not\([^\)]*\)',v['test'])]
		for k,v in ubl_not_dict.items():
			if 'not' == v['Schematron']:
				defined = False
				for t in tests:
					t = re.sub(re.escape('(cac:InvoiceLine|cac:CreditNoteLine)'),'cac:InvoiceLine',t)
					t = re.sub(re.escape('(cac:Invoice|cac:CreditNote)'),'cac:Invoice',t)
					m = re.findall(r'^not\(([^\)]*)\)',t)
					if not m:
						continue
					_t = m[0]
					# print(_t)
					if '//' == _t[:2]:
						_t = _t[2:]
					if '/Invoice/' == _t[:9]:
						_t = _t[9:]
					if _t in k:
						defined = True
						# if verbose:
						# 	print('-OK-\t{0} is defined in the rule.'.format(k))
						break
				if not defined:
					Rs += k+'<br />'
					if verbose:
						print('*NG*\t{0} is not defined in the rule.'.format(k))
		return Rs

	listUndefInSchematron()

	legend_peppol_rule = '''
PEPPOL-EN16931-Rnnn
Transaction rules
R00X - Document level
R01X - Accounting customer
R02X - Accounting supplier
R04X - Allowance/Charge (document and line)
R05X - Tax
R06X - Payment
R08X - Additonal document reference
R1XX - Line level
R11X - Invoice period
	'''
	with open(peppol_rule_en_html,'w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
		lang = 'en'
		f.write(html_head.format(lang,APP_BASE))
		f.write(javascript_html)
		# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.HOME_en 4.MESSAGE_TITLE_en 5.lang 6.APP_BASE 
		# 7.'Legend' 8.legend_en 9.'Shows a ...' 10.dropdown_menu_en 11.tooltipTextForSearch
		html = navbar_html.format(SPEC_TITLE_en,'selected','',HOME_en,peppol_rule_MESSAGE_TITLE_en,lang, \
															APP_BASE,'Legend',legend_en,'Shows a modal window for the legend.', \
															dropdown_menu_en,'ID or word in Term/Description','modal-sm')
		f.write(html)
		f.write(table_html.format('PINT','ID / Message','flag'))
		for id,data in peppol_rule_dict.items():
			writeTr_en(f,'en-peppol/',data)
		f.write(trailer.format('Go to top'))

	with open(peppol_rule_ja_html,'w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
		lang = 'ja'
		f.write(html_head.format(lang,APP_BASE))
		f.write(javascript_html)
		# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.HOME_en 4.MESSAGE_TITLE_en 5.lang 6.APP_BASE 
		# 7.'凡例' 8.legend_ja 9.'凡例を説明するウィンドウを表示' 10.dropdown_menu_ja 11.tooltipTextForSearch
		html = navbar_html.format(SPEC_TITLE_ja,'','selected',HOME_ja,peppol_rule_MESSAGE_TITLE_ja,lang, \
															APP_BASE,'凡例',legend_ja,'凡例を表示', \
															dropdown_menu_ja,'IDまたは用語/説明文が含む単語','modal-sm')
		f.write(html)
		f.write(table_html.format('PINT','ID / メッセージ','flag'))
		for id,data in peppol_rule_dict.items():
			writeTr_ja(f,'en-peppol/',data)
		f.write(trailer.format('先頭に戻る'))

	with open(cen_rule_en_html,'w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
		lang = 'en'
		f.write(html_head.format(lang,APP_BASE))
		f.write(javascript_html)
		# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.HOME_en 4.MESSAGE_TITLE_en 5.lang 6.APP_BASE 
		# 7.'Legend' 8.legend_en 9.'Shows a ...' 10.dropdown_menu_en 11.tooltipTextForSearch
		html = navbar_html.format(SPEC_TITLE_en,'selected','',HOME_en,cen_rule_MESSAGE_TITLE_en,lang, \
															APP_BASE,'Legend',legend_en,'Shows a modal window of the legend.', \
															dropdown_menu_en,'ID or word in Term/Description','modal-sm')
		f.write(html)
		f.write(table_html.format('JP','ID / Message','flag'))
		for id,data in cen_rule_dict.items():
			writeTr_en(f,'en-cen/',data)
		f.write(trailer.format('Go to top'))

	with open(cen_rule_ja_html,'w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
		lang = 'ja'
		f.write(html_head.format(lang,APP_BASE))
		f.write(javascript_html)
		# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.HOME_en 4.MESSAGE_TITLE_en 5.lang 6.APP_BASE 
		# 7.'凡例' 8.legend_ja 9.'凡例を説明するウィンドウを表示' 10.dropdown_menu_ja 11.tooltipTextForSearch
		html = navbar_html.format(SPEC_TITLE_ja,'','selected',HOME_ja,cen_rule_MESSAGE_TITLE_ja,lang, \
															APP_BASE,'凡例',legend_ja,'凡例を表示', \
															dropdown_menu_ja,'IDまたは用語/説明文が含む単語','modal-sm')
		f.write(html)
		f.write(table_html.format('JP','ID / メッセージ','flag'))
		for id,data in cen_rule_dict.items():
			writeTr_ja(f,'en-cen/',data)
		f.write(trailer.format('先頭に戻る'))

	for id,v in peppol_rule_dict.items():
		if not id:
			continue
		lang = 'en'
		item_dir0 = 'billing-japan/rules/en-peppol/'+id+'/'+lang
		os.makedirs(item_dir0,exist_ok=True)
		with open(item_dir0+'/index.html','w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
			f.write(item_head.format(lang,APP_BASE))
			f.write(javascript_html)
			f.write('</head><body>')
			# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.lang 4.APP_BASE 5.'Legend' 6.info_item_modal_en 7.dropdown_menu_en　8.tooltipText
			f.write(item_navbar.format(SPEC_TITLE_en,'selected','',lang,APP_BASE, \
																'Legend',info_item_modal_en,dropdown_menu_en,'Shows a modal window of the legend.','modal-lg'))
			# 0.lang 1.HOME_en 2.'Transction Business Rules' 3.'en-peppol' 4.peppol_rule_MESSAGE_TITLE_en 5.id 6.APP_BASE
			f.write(item_breadcrumb.format(lang,HOME_en,'Transction Business Rules','en-peppol',peppol_rule_MESSAGE_TITLE_en, \
																			id,APP_BASE))
			if id in rule_dict:
				data = rule_dict[id]
				title = id+' ('+data['flag']+')'
				f.write(item_header.format(title,v['text']))
				BGroup = lookupBG(data,lang)
				BTerm = lookupBT(data,lang)
				if data['vars'] and data['tVars']:
					html = item_data3.format('context','<code>'+data['context']+'</code>','test','<code>'+data['test']+'</code>', \
																	'Variables in context','<code>'+data['vars']+'</code>', \
																	'Variables in test','<code>'+data['tVars']+'</code>', \
																	'Associated Business term Group',BGroup,'Associated Business Term',BTerm)
				elif data['vars']:
					html = item_data2.format('context','<code>'+data['context']+'</code>','test','<code>'+data['test']+'</code>', \
																	'Variables in context','<code>'+data['vars']+'</code>', \
																	'Associated Business term Group',BGroup,'Associated Business Term',BTerm)
				elif data['tVars']:
					html = item_data2.format('context','<code>'+data['context']+'</code>','test','<code>'+data['test']+'</code>', \
																	'Variables in test','<code>'+data['tVars']+'</code>', \
																	'Associated Business term Group',BGroup,'Associated Business Term',BTerm)
				else:
					html = item_data.format('context','<code>'+data['context']+'</code>','test','<code>'+data['test']+'</code>', \
																	'Associated Business term Group',BGroup,'Associated Business Term',BTerm)
				f.write(html)
			else:
				f.write(item_header.format(id,v['text']))
				GBT = lookupBGT(id,lang)
				BGroup = GBT['BGroup']
				BTerm = GBT['BTerm']
				html = item_data.format('context','** The rule is not defined in the schematron file. **','test','<i class="fa fa-minus" aria-hidden="true"></i>',
																'Associated Business term Group',BGroup,'Associated Business Term',BTerm)
				f.write(html)
			f.write(item_trailer.format('Go to top'))

		lang = 'ja'
		item_dir0 = 'billing-japan/rules/en-peppol/'+id+'/'+lang
		os.makedirs(item_dir0,exist_ok=True)
		with open(item_dir0+'/index.html','w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
			f.write(item_head.format(lang,APP_BASE))
			f.write(javascript_html)
			# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.lang 4.APP_BASE 5.'凡例' 6.info_item_modal_ja 7.dropdown_menu_ja 8.tooltipText
			f.write(item_navbar.format(SPEC_TITLE_ja,'','selected',lang,APP_BASE, \
																'凡例',info_item_modal_ja,dropdown_menu_ja,'凡例を表示','modal-lg'))
			# 0.lang 1.HOME_en 2.'Transction Business Rules' 3.'en-peppol' 4.peppol_rule_MESSAGE_TITLE_en 5.id 6.APP_BASE
			f.write(item_breadcrumb.format(lang,HOME_ja,'ビジネスルール','en-peppol',peppol_rule_MESSAGE_TITLE_ja, \
																			id,APP_BASE))
			if id in rule_dict:
				data = rule_dict[id]
				title = id+' ('+data['flag']+')'
				f.write(item_header.format(title,v['text']))
				BGroup = lookupBG(data,'ja')
				BTerm = lookupBT(data,'ja')
				if data['vars'] and data['tVars']:
					html = item_data3.format('対象(context)','<code>'+data['context']+'</code>', \
																	'検証(test)','<code>'+data['test']+'</code>', \
																	'対象(context)にある変数','<code>'+data['vars']+'</code>', \
																	'検証(test)にある変数','<code>'+data['tVars']+'</code>', \
																	'関連するビジネス用語グループ',BGroup,'関連するビジネス用語',BTerm)
				elif data['vars']:
					html = item_data2.format('対象(context)','<code>'+data['context']+'</code>', \
																	'検証(test)','<code>'+data['test']+'</code>', \
																	'対象(context)にある変数','<code>'+data['vars']+'</code>', \
																	'関連するビジネス用語グループ',BGroup,'関連するビジネス用語',BTerm)
				elif data['tVars']:
					html = item_data2.format('対象(context)','<code>'+data['context']+'</code>', \
																	'検証(test)','<code>'+data['test']+'</code>', \
																	'検証(test)にある変数','<code>'+data['tVars']+'</code>', \
																	'関連するビジネス用語グループ',BGroup,'関連するビジネス用語',BTerm)
				else:
					html = item_data.format('対象(context)','<code>'+data['context']+'</code>', \
																	'検証(test)','<code>'+data['test']+'</code>', \
																	'関連するビジネス用語グループ',BGroup,'関連するビジネス用語',BTerm)
				f.write(html)
			else:
				GBT = lookupBGT(id,lang)
				BGroup = GBT['BGroup']
				BTerm = GBT['BTerm']
				f.write(item_header.format(id,v['text']))
				html = item_data.format('対象(context)','** ビジネスルールは、スキーマトロンで未定義 **','検証(test)','<i class="fa fa-minus" aria-hidden="true"></i>', \
																'関連するビジネス用語グループ',BGroup,'関連するビジネス用語',BTerm)
				f.write(html)
			f.write(item_trailer.format('先頭に戻る'))

	for id,v in cen_rule_dict.items():
		if not id:
			continue
		lang = 'en'
		item_dir0 = 'billing-japan/rules/en-cen/'+id+'/'+lang
		os.makedirs(item_dir0,exist_ok=True)
		with open(item_dir0+'/index.html','w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
			f.write(item_head.format(lang,APP_BASE))
			f.write(javascript_html)
			# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.lang 4.APP_BASE 5.'Legend' 6.info_item_modal_en 7.dropdown_menu_en　8.tooltipText
			f.write(item_navbar.format(SPEC_TITLE_en,'selected','',lang,APP_BASE, \
																'Legend',info_item_modal_en,dropdown_menu_en,'Show Legend','modal-lg'))
			# 0.lang 1.HOME_en 2.'Transction Business Rules' 3.'en-cen' 4.peppol_rule_MESSAGE_TITLE_en 5.id 6.APP_BASE
			f.write(item_breadcrumb.format(lang,HOME_en,'Transction Business Rules','en-cen',cen_rule_MESSAGE_TITLE_en, \
																			id,APP_BASE))
			if id in rule_dict:
				data = rule_dict[id]
				title = id+' ('+data['flag']+')'
				f.write(item_header.format(title,v['text']))
				BGroup = lookupBG(data,lang)
				BTerm = lookupBT(data,lang)
				if data['vars'] and data['tVars']:
					html = item_data3.format('context','<code>'+data['context']+'</code>','test','<code>'+data['test']+'</code>', \
																	'Variables in context','<code>'+data['vars']+'</code>', \
																	'Variables in test','<code>'+data['tVars']+'</code>', \
																	'Associated Business term Group',BGroup,'Associated Business Term',BTerm)
				elif data['vars']:
					html = item_data2.format('context','<code>'+data['context']+'</code>','test','<code>'+data['test']+'</code>', \
																	'Variables in context','<code>'+data['vars']+'</code>', \
																	'Associated Business term Group',BGroup,'Associated Business Term',BTerm)
				elif data['tVars']:
					html = item_data2.format('context','<code>'+data['context']+'</code>','test','<code>'+data['test']+'</code>', \
																	'Variables in test','<code>'+data['tVars']+'</code>', \
																	'Associated Business term Group',BGroup,'Associated Business Term',BTerm)
				else:
					html = item_data.format('context','<code>'+data['context']+'</code>','test','<code>'+data['test']+'</code>', \
																	'Associated Business term Group',BGroup,'Associated Business Term',BTerm)
				f.write(html)
			else:
				GBT = lookupBGT(id,lang)
				BGroup = GBT['BGroup']
				BTerm = GBT['BTerm']
				f.write(item_header.format(id,v['text']))
				html = item_data.format('context','** The rule is not defined in the schematron file. **','test','<i class="fa fa-minus" aria-hidden="true"></i>', 
																'Associated Business term Group',BGroup,'Associated Business Term',BTerm)
				f.write(html)
			f.write(item_trailer.format('Go to top'))

		lang = 'ja'
		item_dir0 = 'billing-japan/rules/en-cen/'+id+'/'+lang
		os.makedirs(item_dir0,exist_ok=True)
		with open(item_dir0+'/index.html','w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
			f.write(item_head.format(lang,APP_BASE))
			f.write(javascript_html)
			# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.lang 4.APP_BASE 5.'凡例' 6.info_item_modal_ja 7.dropdown_menu_ja 8.tooltipText
			f.write(item_navbar.format(SPEC_TITLE_ja,'','selected',lang,APP_BASE, \
																'凡例',info_item_modal_ja,dropdown_menu_ja,'凡例を表示','modal-lg'))
			# 0.lang 1.HOME_en 2.'Transction Business Rules' 3.'en-peppol' 4.peppol_rule_MESSAGE_TITLE_en 5.id 6.APP_BASE
			f.write(item_breadcrumb.format(lang,HOME_ja,'ビジネスルール','en-cen',cen_rule_MESSAGE_TITLE_ja, \
																			id,APP_BASE))
			if id in rule_dict:
				data = rule_dict[id]
				title = id+' ('+data['flag']+')'
				f.write(item_header.format(title,v['text']))
				BGroup = lookupBG(data,lang)
				BTerm = lookupBT(data,lang)
				if data['vars'] and data['tVars']:
					html = item_data3.format('対象(context)','<code>'+data['context']+'</code>', \
																	'検証(test)','<code>'+data['test']+'</code>', \
																	'対象(context)にある変数','<code>'+data['vars']+'</code>', \
																	'検証(test)にある変数','<code>'+data['tVars']+'</code>', \
																	'関連するビジネス用語グループ',BGroup,'関連するビジネス用語',BTerm)
				elif data['vars']:
					html = item_data2.format('対象(context)','<code>'+data['context']+'</code>', \
																	'検証(test)','<code>'+data['test']+'</code>', \
																	'対象(context)にある変数','<code>'+data['vars']+'</code>', \
																	'関連するビジネス用語グループ',BGroup,'関連するビジネス用語',BTerm)
				elif data['tVars']:
					html = item_data2.format('対象(context)','<code>'+data['context']+'</code>', \
																	'検証(test)','<code>'+data['test']+'</code>', \
																	'検証(test)にある変数','<code>'+data['tVars']+'</code>', \
																	'関連するビジネス用語グループ',BGroup,'関連するビジネス用語',BTerm)
				else:
					html = item_data.format('対象(context)','<code>'+data['context']+'</code>', \
																	'検証(test)','<code>'+data['test']+'</code>', \
																	'関連するビジネス用語グループ',BGroup,'関連するビジネス用語',BTerm)
				f.write(html)
			else:
				GBT = lookupBGT(id,lang)
				BGroup = GBT['BGroup']
				BTerm = GBT['BTerm']
				f.write(item_header.format(id,v['text']))
				html = item_data.format('対象(context)','** ビジネスルールは、スキーマトロンで未定義 **','検証(test)','<i class="fa fa-minus" aria-hidden="true"></i>', \
																'関連するビジネス用語グループ',BGroup,'関連するビジネス用語',BTerm)
				f.write(html)
			f.write(item_trailer.format('先頭に戻る'))

	if verbose:
		print(f'** END ** {peppol_rule_en_html} {peppol_rule_ja_html} {cen_rule_en_html} {cen_rule_ja_html}')