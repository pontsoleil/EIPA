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
    d = {t.tag: {k: v[0] if len(v) == 1 else v
      for k, v in dd.items()}}
  if t.attrib:
    d[t.tag].update(('@' + k, v)
      for k, v in t.attrib.items())
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
          except Exception:
            pprint(v)
          root.text = v
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

# ref https://stackoverflow.com/questions/15210148/get-parents-keys-from-nested-dictionary
# breadcrumb(json_dict_or_list, value)
def get_path_value(base, path):
  key = path[0]
  if isinstance(base, dict):
    if 1 == len(path):
      if key in base.keys():
        return {'k':key, 'v':base[key]}
    else:
      path.pop(0)
      for k, v in base.items():
        if isinstance(base, dict):
          if key == k:
            p = get_path_value(v, path)
            if p:
              return p
  elif isinstance(base, list):
    try:
      key = int(key)
      if key < len(base):
        path.pop(0)
        p = get_path_value(base[key], path)
        if p:
          return p
    except ValueError:
      pass

def set_path_value(base, parent, path, value, datatype):
  key = path[0]
  if len(path) > 1:
    try:
      index = int(path[1])
      if not key in base:
        base[key] = {}
      if not isinstance(base[key], list):
        base[key] = [{}]
      else:
        pass
      if index >= len(base[key]):
        for i in range(index - len(base[key]) + 1):
          base[key].append({})
      try:
        base = base[key][index]
      except Exception:
        pass
      path.pop(0)
      path.pop(0)
      set_path_value(base, None, path, value, datatype)
    except ValueError:
      pass
  if isinstance(base, dict):
    if 1 == len(path):
      if not key in base.keys():
        base[key] = {}
      if 'Amount' == datatype or 'Unit' == datatype:
        value = {'#text': str(value), '@currencyID': 'JPY'}
      elif 'Quantity' == datatype:
        value = {'#text': str(value), '@unitCode': 'EA'}
      if not '#text' in base[key]:
        base[key] = value  # when Amount/Unit/Quantity is already set
    else:
      path.pop(0)
      if not key in base.keys():
        base[key] = {}
      if isinstance(base, dict):
        for k, v in base.items():
          if key == k:
            p = None
            if 1 == len(path) and '@' == path[0][:1]:
              if isinstance(base[key], str):
                val = base[key]
                if isinstance(val, dict):
                  val[path[0]] = value
                elif isinstance(val, str):
                  base[key] = {'#text': val, path[0]: value}
              elif isinstance(base[key], dict):
                val = base[key]
                val[path[0]] = value
            else:
              set_path_value(v, None, path, value, datatype)
