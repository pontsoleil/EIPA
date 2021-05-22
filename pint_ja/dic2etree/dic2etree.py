# print("Load dic2etree.py")
import xml.etree.ElementTree as ET
# import defusedxml.ElementTree as ET
from collections import defaultdict

ET.register_namespace('cac', 'urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2')
ET.register_namespace('cbc', 'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2')
ET.register_namespace('qdt', 'urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2')
ET.register_namespace('udt', 'urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2')
ET.register_namespace('ccts', 'urn:un:unece:uncefact:documentation:2')
ET.register_namespace('', 'urn:oasis:names:specification:ubl:schema:xsd:Invoice-2')

dictID = defaultdict(type(""))

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

def dict_to_etree(d):
  def _to_etree(d, root):
    if not d:
      pass
    elif isinstance(d, str):
      root.text = d
    elif isinstance(d, dict):
      for k,v in d.items():
        assert isinstance(k, str)
        if k.startswith('#'):
          assert k == '#text' and isinstance(v, str)
          root.text = v
        elif k.startswith('@'):
          assert isinstance(v, str)
          root.set(k[1:], v)
        elif isinstance(v, list):
          for e in v:
            _to_etree(e, ET.SubElement(root, k))
        else:
          _to_etree(v, ET.SubElement(root, k))
    else:
      assert d == 'invalid type', (type(d), d)
  # assert isinstance(d, dict) and len(d) == 1
  tag, body = next(iter(d.items()))
  node = ET.Element(tag)
  _to_etree(body, node)
  return node

def dict_to_tsv(tsv, d, tag, path):
  def _setup_record(case, path, tag, k, v):
    _record = {}
    if 1 == case:
      pathString = path+'/'+tag
      id = dictID[pathString]
    elif 2 == case or 3 == case:
      pathString = path+'/'+tag
      id = dictID[path]+' '+dictID[pathString]
      tag = k
    elif 4 == case:
      pathString = path+'/'+tag+'/'+k
      id = dictID[pathString]
      tag = k
    _record = {'case': case, 'id': id, 'path': pathString, 'tag': tag, 'val': v}
    return _record
  def _to_tsv(tsv, d, tag, path):
    record = {}
    if not d:
      pass
    elif isinstance(d, str):  # case 1
      record = _setup_record(1, path, tag, '', d)
      tsv.append(record)
    elif isinstance(d, dict):
      for k,v in d.items():
        assert isinstance(k, str)
        if k.startswith('#'):
          assert k == '#text' and isinstance(v, str)  # case 2
          record = _setup_record(2, path, tag, k, v)
          tsv.append(record)
        elif isinstance(k, str) and k.startswith('@'):
          assert isinstance(v, str)  # case 3
          record = _setup_record(3, path, tag, k, v)
          tsv.append(record)
        elif isinstance(v, list):
          for e in v:  # case 4
            record = _setup_record(4, path, tag, k, '')
            tsv.append(record)
            tsv = _to_tsv(tsv, e, k, path+'/'+tag)
        else:
          tsv = _to_tsv(tsv, v, k, path+'/'+tag)
    else:
      assert d == 'invalid type', (type(d), d)
    return tsv
  assert isinstance(d, dict) and len(d) == 1
  for tag, body in d.items():
    tsv = _to_tsv(tsv, body, tag, path)
  return tsv

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

def set_path_value(base, path, value, datatype):
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
      p = set_path_value(base, path, value, datatype)
      if p:
        return p
    except ValueError:
      pass
  if isinstance(base, dict):
    if 1 == len(path):
      if not key in base.keys():
        base[key] = {}
      if 'Amount' == datatype:
        value = {'#text':str(value), '@currencyID': 'JPY'}
      base[key] = value
      return {'k':key, 'v':base[key]}
    else:
      path.pop(0)
      if not key in base.keys():
        base[key] = {}
      for k, v in base.items():
        if isinstance(base, dict):
          if key == k:
            p = set_path_value(v, path, value, datatype)
            if p:
              return p

