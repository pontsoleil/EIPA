# print("Load dic2etree.py")
import xml.etree.ElementTree as ET
# import defusedxml.ElementTree as ET
from collections import defaultdict
# import csv
import pprint

ET.register_namespace('cac', 'urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2')
ET.register_namespace('cbc', 'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2')
ET.register_namespace('qdt', 'urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2')
ET.register_namespace('udt', 'urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2')
ET.register_namespace('ccts', 'urn:un:unece:uncefact:documentation:2')
ET.register_namespace('', 'urn:oasis:names:specification:ubl:schema:xsd:Invoice-2')

# https://stackoverflow.com/questions/7684333/converting-xml-to-dictionary-using-elementtree
def etree_to_dict(t):
  d = {t.tag: {} if t.attrib else None}
  children = list(t)
  if children:
    dd = defaultdict(list)
    for dc in map(etree_to_dict, children):
      for k, v in dc.items():
        dd[k].append(v)
    d = {t.tag: {k: v[0] if len(v) == 1 else v for k, v in dd.items()}}
  if t.attrib:
    d[t.tag].update(('@' + k, v) for k, v in t.attrib.items())
  if t.text:
    text = t.text.strip()
    if children or t.attrib:
      if text:
        d[t.tag]['#text'] = text
    else:
      d[t.tag] = text
  return d

def dict_to_etree(d, root):
  def _to_etree(d, root):
    if not d:
      pass
    elif isinstance(d, str):
      root.text = d
    elif isinstance(d, dict):
      for k,v in d.items():
        assert isinstance(k, str)
        if k.startswith('#'):
          try:
            assert k == '#text' and isinstance(v, str)
            root.text = v
          except (Exception, ValueError, TypeError) as e:
            print(e, v)
        elif k.startswith('@'):
          if isinstance(v, str): # 2021-06-05
            root.set(k[1:], v)
          else:
            pass
        elif isinstance(v, list):
          for e in v:
            _to_etree(e, ET.SubElement(root, k))
        else:
          _to_etree(v, ET.SubElement(root, k))
    else:
      assert d == 'invalid type', (type(d), d)
  assert isinstance(d, dict) and len(d) == 1
  tag, body = next(iter(d.items()))
  _to_etree(body, root)
  return root
