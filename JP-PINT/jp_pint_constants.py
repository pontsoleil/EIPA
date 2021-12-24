# import jp_pint_base
from jp_pint_base import OP_BASE
from jp_pint_base import APP_BASE
from jp_pint_base import MESSAGE # invoice debitnote summarized

profiles = {
	'invoice': {
		'title_en':'Peppol BIS Billing JP 0.9',
		'title_ja':'都度請求書',
		'ProfileID':'urn:peppol:bis:billing',
		'CustomizationID':'urn:peppol:pint:billing-3.0@jp:peppol-1'
	}
	# 'debitnote': {
	# 	'title_en':'Japanese Debit Note',
	# 	'title_ja':'納品書',
	# 	'ProfileID':'urn:peppol:bis:debitnote',
	# 	'CustomizationID':'urn:peppol:pint:debitnote-3.0@jp:peppol-1'
	# },
	# 'summarised': {
	# 	'title_en':'Japanese Summary Invoice, pattern 1',
	# 	'title_ja':'合算請求書パターン１',
	# 	'ProfileID':'urn:peppol:bis:billing',
	# 	'CustomizationID':'urn:peppol:pint:billing-3.0@jp:peppol-1@jp:suminvpt1-1'
	# }
}

SEMANTIC_BASE = APP_BASE+'semantic/'+MESSAGE+'/'
SYNTAX_BASE = APP_BASE+'syntax/ubl-'+MESSAGE+'/'
RULES_BASE = APP_BASE+'rules/'
RULES_UBL_JAPAN_BASE = APP_BASE+'rules/ubl-japan/'
RULES_UBL_PINT_BASE = APP_BASE+'rules/ubl-pint/'
RULES_EN_PEPPOL = APP_BASE+'rules/en-peppol/'
RULES_EN_CEN = APP_BASE+'rules/en-cen/'

SPEC_TITLE_en = 'Peppol Specifications for Japan (Candidate)'
SPEC_TITLE_ja = ''#'電子インボイス 国内標準仕様 - ドラフト 第一版'
SEMANTICS_MESSAGE_TITLE_en = profiles[MESSAGE]['title_en']+', Semantc Model'
SEMANTICS_MESSAGE_TITLE_ja = ''#profiles[MESSAGE]['title_ja']+'モデル'
SEMANTICS_LEGEND_TITLE_en = 'Semantic Model'
SEMANTICS_LEGEND_TITLE_ja = ''#'コアインボイスモデル'
SYNTAX_MESSAGE_TITLE_en = profiles[MESSAGE]['title_en']+', Syntax Binding'
SYNTAX_MESSAGE_TITLE_ja = ''#profiles[MESSAGE]['title_ja']+'XML構文'
SYNTAX_LEGEND_TITLE_en = 'Syntax Binding'
SYNTAX_LEGEND_TITLE_ja = ''#'XML構文'
PINT_RULE_MESSAGE_TITLE_en = 'Rules for PEPPOL PINT'
PINT_RULE_MESSAGE_TITLE_ja = ''#'PEPPOL PINTルール'
JP_RULE_MESSAGE_TITLE_en = 'Rules for Japanese Standard Commercial Invoice'
JP_RULE_MESSAGE_TITLE_ja = ''#'都度請求書ルール'
peppol_rule_MESSAGE_TITLE_en = 'Rules for PEPPOL BIS 3.0 Billing'
peppol_rule_MESSAGE_TITLE_ja = ''#'PEPPOL BIS 3.0 Billing ルール'
cen_rule_MESSAGE_TITLE_en = 'EN16931 model bound to UBL'
cen_rule_MESSAGE_TITLE_ja = ''#'EN16931モデルをUBLで表すためのルール'
HOME_en = '<i class="fa fa-square mr-2" aria-hidden="true"> Home</i>'
HOME_ja = ''#'<i class="fa fa-square mr-2" aria-hidden="true"> ホーム</i>'
warning_en = '<p class="lead">A DRAFT version of a Peppol Business Interoperability Specification (BIS) for a Japanese Billing process that contains two transactions that may be sent from a seller to a buyer. An Invoice and, if needed, a Credit Note. This draft only includes the Invoice transaction with syntax binding to the UBL Invoice document type. The Credit Note will be added into the final release. The semantic data model of the Credit Note is the same as for the Invoice but it will be mapped to the UBL Credit Note document type.</p>'
warning_ja = ''#<p class="lead">注：すべての項目名は、Peppol International Invoicing (PINT)からのものです。共通して同じ名称が、都度請求書、合算請求書、納品書で使われています。違いは、ビジネスプロセスタイプ (Profile ID)、仕様ID (Customization ID)、及び請求書タイプコードです。XML要素名、属性名は、UBL 2.1 Invoice に基づいています。</p>'
searchLegend_en = 'Enter the key word that contains the ID or term/description and click the icon on the left to search.' 
searchLegend_ja = ''#IDまたは用語/説明文が含む単語を入力し、左のアイコンをクリックすると検索します。'

variables = {
	'/Invoice/cbc:DocumentCurrencyCode/text()':'$documentcurrency',
	'/Invoice/cbc:TaxCurrencyCode/text()':'$taxcurrency'
}

html_head = '''
<!DOCTYPE html>
<html lang="{0}">
<head>
	<title>Japanese PEPPOL BIS Documentation</title>
	<meta charset="utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width,initial-scale=1" />
	<link rel="icon" href="https://www.wuwei.space/jp_pint/billing-japan/favicon.ico">
	<!-- Bootstrap 4 jQuery 3 -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css" integrity="sha384-B0vP5xmATw1+K9KRQjQERJvTumQW0nPEzvF6L/Z6nronJ3oUOFUFpCjEUQouq2+l" crossorigin="anonymous">
  <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.min.js" integrity="sha384-+YQ4JLhjyBLPDQt//I+STsc9iw4uQqACwlvpslubQzn4u2UU2UFM80nGisd026JF" crossorigin="anonymous"></script>
	<!-- Font Awesome 4 -->
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
	<!-- this page -->
	<link rel="stylesheet" href="{1}css/main.css" crossorigin="anonymous">
	<script src="{1}js/main.js" crossorigin="anonymous"></script>
'''
javascript_html = '''
	<script type="text/javascript" class="init">
		$(document).ready(function() {
			alertText = document.getElementById('ie-warning').innerText.trim();
			if (/Trident\/|MSIE /.test(window.navigator.userAgent)) {
				confirm(alertText);
				var expands = document.getElementsByClassName('expand');
				for (var i = 0; i < expands.length; i++) {
					expands[i].style.display = 'none';
				}
			}

			initModule();
		});
	</script>
'''
# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.HOME_en 4.SYNTAX_MESSAGE_TITLE_en 5.'Legend' 
# 6.legend_en 7.'Shows a ...' 8.dropdown_menu 9.tooltipTextForSearch, 10.size 11.warning 12.APP_BASE 13.jang 14.NOT_SUPPORTED  15.gobacktext
NOT_SUPPORTED_en = "This service doesn't support Internet Explorer (IE). Please use either Edge, Chrome, Safari, FireFox, etc."
NOT_SUPPORTED_ja = ''#"インターネットエクスプローラ(IE)では、一部の機能が正しく動作しません。Edge, Google Chrome, Safari, FireFox をご使用ください。"

# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.HOME_en 4.SYNTAX_MESSAGE_TITLE_en 5.'Legend' 
# 6.legend_en 7.'Shows a ...' 8.dropdown_menu 9.tooltipTextForSearch, 10.size 11.warning 12.APP_BASE 13.jang
# 14.NOT_SUPPORTED  15.gobacktext 16.SearchText
navbar_html = '''
</head>
<body>
	<!-- check https://stackoverflow.com/questions/42252443/vertical-align-center-in-bootstrap-4 -->
	<div id="ie-warning" class="container h-100" style="display:none">
	{14}
	</div>
	<div id="infoModal" class="modal fade" tabindex="-1" role="dialog">
		<div class="modal-dialog {10}" role="document">
			<div class="modal-content">
				<div class="modal-header">{5}</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					{6}
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>
	<header class="sticky-top bg-white px-0 py-2">
		<form id="nav-menu" class="form-inline flex-nowrap">
	<!--
			<button class="search btn btn-outline-info my-2 my-sm-0 mr-0 border-0"><i class="fa fa-search" aria-hidden="true"></i></button>
			<input type="search" onsearch="lookupTerm(this)" class="search form-control mr-0" placeholder="{16}" aria-label="Search" data-toggle="tooltip" title="{9}">
			<select id="language" class="form-control mr-0 border-0">
				<option value="en" {1}>English</option>
				<option value="ja" {2}>日本語</option>
			</select>
			<button class="back btn btn-outline-info my-2 my-sm-0 mr-0 border-0" onclick="goBack()"><i class="fa fa-history" aria-hidden="true" data-toggle="tooltip" title="{15}"></i></button>
	-->
			<button type="button" class="info btn btn-outline-info my-2 my-sm-0 mr-0 border-0" data-toggle="modal" data-target="#infoModal">
				<i class="fa fa-info" aria-hidden="true" data-toggle="tooltip" title="{7}"></i>
			</button>
			{8}
		</form>
		<nav class="navbar navbar-expand-lg navbar-light bg-light p-0 mb-1">
			<a class="navbar-brand col-8 mr-auto" href="{12}{13}">{0}</a>
		</nav>
		<ol class="breadcrumb pt-1 pb-1">
			<li class="breadcrumb-item"><a href="{12}{13}">{3}</a></li>
			<li class="breadcrumb-item active">{4}</li>
		</ol>
	</header>
	<div class="container">
		<div class="syntax">

			<div class="page-header">
				<h1>{4}</h1>
				{11}
			</div>
			<div class="table-responsive">
'''
table_trailer = '''
					</tbody>
				</div>
			</dd>
'''
trailer = '''
					</tbody>
				</table>
			</div>
		</div>
		<p>This site is provided by <a href="https://www.sambuichi.jp/?page_id=670&lang=en">Sambuichi Profssional Engineers Office</a> for verification.</p>
		<p>
			<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a> CC BY-SA 4.0 This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.
		</p>
	</div>
	<button id="gotoTopButton" type="button" class="btn btn-secondary" data-toggle="tooltip" data-placement="top" title="{0}">
  	<i class="fa fa-arrow-up fa-2x" aria-hidden="true"></i>
	</button>
'''
item_head = '''
<!DOCTYPE html>
<html lang="{0}">
<head>
	<title>Japanese PEPPOL BIS Documentation</title>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width,initial-scale=1">
	<link rel="icon" href="https://www.wuwei.space/jp_pint/billing-japan/favicon.ico">
	<!-- font awesome 4 -->
	<link rel="stylesheet" href="/font-awesome-4.7.0/css/font-awesome.min.css">
	<script src="https://kit.fontawesome.com/d109b16d3e.js" crossorigin="anonymous"></script>
	<!-- bootstrap 4 and jQuery 3
		If you’re using our compiled JavaScript, don’t forget to include CDN versions of jQuery and Popper.js before it.
		https://getbootstrap.com/docs/4.0/getting-started/download/
	-->
	<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
	<!-- this page -->
	<link rel="stylesheet" href="{1}css/main.css" crossorigin="anonymous">
	<script src="{1}js/main.js" crossorigin="anonymous"></script>
'''
# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.APP_BASE 4.lang 5.'Legend' 6.info_item_modal_en 7.dropdown_menu 8.tooltipText 9.size 10.gobcckText 11.warning
item_navbar = '''
	<div id="ie-warning" class="container h-100" style="display:none">
	{11}
	</div>
	<div id="itemInfoModal" class="modal fade" tabindex="-1" role="dialog">
		<div class="modal-dialog {9}" role="document">
			<div class="modal-content">
				<div class="modal-header">{5}</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					{6}
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>
	<form id="nav-menu" class="form-inline flex-nowrap">
<!--
		<select id="language" class="form-control mr-0 border-0">
			<option value="en" {1}>English</option>
			<option value="ja" {2}>日本語</option>
		</select>
		<button class="back btn btn-outline-info my-2 my-sm-0 mr-0 border-0" onclick="goBack()"><i class="fa fa-history" aria-hidden="true" data-toggle="tooltip" title="{10}"></i></button>
-->
		<button type="button" class="info btn btn-outline-info my-2 my-sm-0 mr-0 border-0" data-toggle="modal" data-target="#itemInfoModal">
			<i class="fa fa-info" aria-hidden="true" data-toggle="tooltip" title="{8}"></i>
		</button>
		{7}
	</form>
	<nav class="navbar navbar-expand-lg navbar-light bg-light p-0 mb-1">
		<a class="navbar-brand col-8 mr-auto" href="{3}{4}">{0}</a>
	</nav>
	<div class="item-syntax">
'''
# item_header = '''
# 			<div class="page-header">
# 				<h1>{0}</h1>
# 			</div>
# 			<p class="lead">{1}</p>
# 			<dl class="row">
# '''
item_trailer = '''
			</dl>
		</div>
	</div>
	<button id="gotoTopButton" type="button" class="btn btn-secondary" data-toggle="tooltip" data-placement="top" title="{0}">
  	<i class="fa fa-arrow-up fa-2x" aria-hidden="true"></i>
	</button>
'''
dropdown_menu_ja = '''
		<li class="nav-item dropdown ja p-0" data-toggle="tooltip" data-placement="bottom" title="遷移メニュー">
			<a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
				<i class="fa fa-list" aria-hidden="true"></i>
			</a>
			<div class="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdown">
				<a class="dropdown-item" href="{0}ja"><i class="fa fa-square mr-2" aria-hidden="true"> ホーム</i></a>
				<div class="dropdown-divider"></div>
				<a href="https://test-docs.peppol.eu/poacc/billing-japan/bis/" onClick="return confirm('Do you want to leave? This link is being provided by OpenPeppol for testing.')" class="external dropdown-item" target="_blank">
					Standard Commercial Invoice <i class="fa fa-external-link" aria-hidden="true"></i>
				</a>
				<a href="https://test-docs.peppol.eu/poacc/billing-japan/bis-debnt/bis/" onClick="return confirm('Do you want to leave? This link is being provided by OpenPeppol for testing.')" class="external dropdown-item" target="_blank">
					Debit note <i class="fa fa-external-link" aria-hidden="true"></i>
				</a>
				<a href="https://test-docs.peppol.eu/poacc/billing-japan/bis-sum1/bis/" onClick="return confirm('Do you want to leave? This link is being provided by OpenPeppol for testing.')" class="external dropdown-item" target="_blank">
					Summary invoice pattern 1 <i class="fa fa-external-link" aria-hidden="true"></i>
				</a>
				<a href="https://test-docs.peppol.eu/poacc/billing-japan/compliance/" onClick="return confirm('Do you want to leave? This link is being provided by OpenPeppol for testing.')" class="external dropdown-item" target="_blank">
					BIS compliance <i class="fa fa-external-link" aria-hidden="true"></i>
				</a>
				<a href="https://test-docs.peppol.eu/poacc/billing-japan/release-notes/" onClick="return confirm('Do you want to leave? This link is being provided by OpenPeppol for testing.')" class="external dropdown-item" target="_blank">
					Release notes <i class="fa fa-external-link" aria-hidden="true"></i>
				</a>
				<div class="dropdown-divider"></div>
				<a class="dropdown-item" href="{0}semantic/invoice/tree/ja/">都度請求書モデル</a>
				<a class="dropdown-item" href="{0}semantic/summarised/tree/ja/">合算請求書パターン１モデル</a>
				<a class="dropdown-item" href="{0}semantic/debitnote/tree/ja/">納品書モデル</a>
				<div class="dropdown-divider"></div>
				<a class="dropdown-item" href="{0}syntax/ubl-invoice/tree/ja/" class="back">都度請求書XML構文</a>
				<a class="dropdown-item" href="{0}syntax/ubl-summarised/tree/ja/" class="back">合算請求書パターン１XML構文</a>
				<a class="dropdown-item" href="{0}syntax/ubl-debitnote/tree/ja/" class="back">納品書XML</a>
				<div class="dropdown-divider"></div>
				<a class="dropdown-item" href="{0}rules/ubl-pint/ja/">PEPPOL PINTルール</a>
				<a class="dropdown-item" href="{0}rules/ubl-japan/ja/">都度請求書ルール</a>
				<div class="dropdown-divider"></div>
				<a class="dropdown-item" href="https://www.eipa.jp/">電子インボイス推進協議会</a>
			</div>
		</li>
'''
dropdown_menu_en = '''
		<li class="nav-item dropdown en p-0" data-toggle="tooltip" data-placement="bottom" title="Navigation menu">
			<a class="nav-link dropdown-toggle fa fa-list" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
			</a>
			<div class="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdown">
<!--
				<a class="dropdown-item" href="{0}en"><i class="fa fa-square mr-2" aria-hidden="true"> Home</i></a>
				<div class="dropdown-divider"></div>
				<a href="https://test-docs.peppol.eu/poacc/billing-japan/bis/" onClick="return confirm('Do you want to leave? This link is being provided by OpenPeppol for testing.')" class="external dropdown-item" target="_blank">
					Standard Commercial Invoice <i class="fa fa-external-link" aria-hidden="true"></i>
				</a>
				<a href="https://test-docs.peppol.eu/poacc/billing-japan/bis-debnt/bis/" onClick="return confirm('Do you want to leave? This link is being provided by OpenPeppol for testing.')" class="external dropdown-item" target="_blank">
					Debit note <i class="fa fa-external-link" aria-hidden="true"></i>
				</a>
				<a href="https://test-docs.peppol.eu/poacc/billing-japan/bis-sum1/bis/" onClick="return confirm('Do you want to leave? This link is being provided by OpenPeppol for testing.')" class="external dropdown-item" target="_blank">
					Summary invoice pattern 1 <i class="fa fa-external-link" aria-hidden="true"></i>
				</a>
				<a href="https://test-docs.peppol.eu/poacc/billing-japan/compliance/" onClick="return confirm('Do you want to leave? This link is being provided by OpenPeppol for testing.')" class="external dropdown-item" target="_blank">
					BIS compliance <i class="fa fa-external-link" aria-hidden="true"></i>
				</a>
				<a href="https://test-docs.peppol.eu/poacc/billing-japan/release-notes/" onClick="return confirm('Do you want to leave? This link is being provided by OpenPeppol for testing.')" class="external dropdown-item" target="_blank">
					Release notes <i class="fa fa-external-link" aria-hidden="true"></i>
				</a>
				<div class="dropdown-divider"></div>
-->
				<a class="dropdown-item" href="{0}semantic/invoice/tree/en/">Standard Commercial Invoice, Semantic Model</a>
<!--
				<a class="dropdown-item" href="{0}semantic/summarised/tree/en/">Summary Invoice, pattern 1, Semantic Data Model</a>
				<a class="dropdown-item" href="{0}semantic/debitnote/tree/en/">Debit Note, Semantic Data Model</a>
				<div class="dropdown-divider"></div>
-->
				<a class="dropdown-item" href="{0}syntax/ubl-invoice/tree/en/">Standard Commercial Invoice, Syntax Binding</a>
<!--
				<a class="dropdown-item" href="{0}syntax/ubl-summarised/tree/en/">Summary Invoice, pattern 1, UBL Syntax</a>
				<a class="dropdown-item" href="{0}syntax/ubl-debitnote/tree/en/">Debit Note, UBL Syntax</a>
				<div class="dropdown-divider"></div>
				<a class="dropdown-item" href="{0}rules/ubl-pint/en/">Rules for PEPPOL PINT</a>
				<a class="dropdown-item" href="{0}rules/ubl-japan/en/">rules for Commercial Invoice</a>
-->
				<div class="dropdown-divider"></div>
				<a class="dropdown-item" href="https://www.eipa.jp/">E-Invoice Promotion Association</a>
				<div class="dropdown-divider"></div>
				<a class="dropdown-item" href="https://test-docs.peppol.eu/japan/master/">Peppol BIS Billing JP 0.9 (test-docs.peppol.eu)</a>
				<a class="dropdown-item" href="https://test-docs.peppol.eu/japan/master/billing-1.0/#:~:text=Documentation-,Peppol%20BIS%20Japan%20Billing,-The%20Peppol%20BIS"> -- Peppol BIS Japan Billing</a>
				<a class="dropdown-item" href="https://test-docs.peppol.eu/japan/master/billing-1.0/#:~:text=Invoice%20transaction-,Semantic%20model,-Syntax%20binding%20Code"> -- Semantic model</a>
				<a class="dropdown-item" href="https://test-docs.peppol.eu/japan/master/billing-1.0/#:~:text=Semantic%20model-,Syntax%20binding,-Code%20lists%20Rules"> -- Syntax binding</a>
				<a class="dropdown-item" href="https://test-docs.peppol.eu/poacc/billing-japan/codelist/"> -- code lists</a>
				<a class="dropdown-item" href="https://test-docs.peppol.eu/japan/master/billing-1.0/#:~:text=binding%20Code%20lists-,Rules"> -- Rules</a>
				<div class="dropdown-divider"></div>
				<a class="dropdown-item" href="https://docs.peppol.eu/poacc/billing/3.0/">PEPPOL BIS Billing 3.0</a>
				<div class="dropdown-divider"></div>
				<a class="dropdown-item" href="http://www.datypic.com/sc/ubl21/ss.html">Schema Central &gt; UBL 2.1</a>
			</div>
		</li>
'''