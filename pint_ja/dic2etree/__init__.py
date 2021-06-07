# print("Load pint_ja/generate_ubl/dic2etree/__init__.py")
from .dic2etree import dict_to_etree
from .dic2etree import etree_to_dict
from .dic2etree import get_path_value
from .dic2etree import set_path_value

ns = {
  '': 'urn:oasis:names:specification:ubl:schema:xsd:Invoice-2',
  'xsi': 'http://www.w3.org/2001/XMLSchema-instance',
  'cac': 'urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2',
  'cbc': 'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2',
  'qdt': 'urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2',
  'udt': 'urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2',
  'ccts': 'urn:un:unece:uncefact:documentation:2',
  'ubl-creditnote': 'urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2',
  'ubl-invoice': 'urn:oasis:names:specification:ubl:schema:xsd:Invoice-2',
  'sch': 'http://purl.oclc.org/dsdl/schematron'
}

__all__ = ['dict_to_etree', 'etree_to_dict', 'get_path_value', 'set_path_value', 'ns']