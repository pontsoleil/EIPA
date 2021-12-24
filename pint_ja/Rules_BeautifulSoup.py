#!/usr/bin/env python3
#
# generate CSV from Open Peoopl e-Invoice (UBL 2.1)
# 
# designed by SAMBUICHI, Nobuyuki (Sambuichi Professional Engineers Office)
# written by SAMBUICHI, Nobuyuki (Sambuichi Professional Engineers Office)
#
# MIT License
# 
# Copyright (c) 2021 SAMBUICHI Nobuyuki (Sambuichi Professional Engineers Office)
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from bs4 import BeautifulSoup
from urllib import request
import urllib
import os
import sys
import json
import ssl
ssl._create_default_https_context = ssl._create_unverified_context

root_rule_url = 'https://test-docs.peppol.eu/japan/master/billing-1.0/invoice-1.0/rule/'
basic_rule_url = 'https://test-docs.peppol.eu/japan/master/billing-1.0/invoice-1.0/rule/basic/'
shared_rule_url = 'https://test-docs.peppol.eu/japan/master/billing-1.0/invoice-1.0/rule/PINT-UBL-validation-preprocessed/'
aligned_rule_url =  'https://test-docs.peppol.eu/japan/master/billing-1.0/invoice-1.0/rule/Japan-UBL-validation-preprocessed/'
 
def parse_rule(base_url,RULE):
    try:
        response = request.urlopen(base_url)
        soup = BeautifulSoup(response,"lxml")
        response.close()
        tr_s = soup.find_all('tr')
        header = [x.text for x in tr_s[0].find_all('th')]
        rules = []
        for i in range(len(tr_s)-1):
            data = [x.text for x in tr_s[i+1].find_all('td')]
            rules.append(data)
        results = []
        for rule in rules:
            id = rule[0]
            message = rule[1]
            rule_url = f'{root_rule_url}{id}/'
            response = request.urlopen(rule_url)
            soup = BeautifulSoup(response,"lxml")
            response.close()
            dl = soup.find('dl')
            title = [x.text for x in dl.find_all('dt')]
            value = [x for x in dl.find_all('dd')]
            data = {}
            data[header[0]] = id
            data[header[1]] = message
            for i in range(len(title)):
                data[title[i]] = value[i].text
            results.append(data)
        dir = os.path.dirname(__file__)
        out_file = os.path.join(dir, f'Rules_{RULE}.json')
        with open(out_file, 'w') as f:
            json.dump(results, f, indent=4)
    except urllib.error.HTTPError as err:
        print("WARN", err.code, base_url, file=sys.stderr)
        return False
    except urllib.error.URLError as err:
        print("ERROR", err.reason, base_url, file=sys.stderr)
        return False
    print("DONE BeautifulSoup", base_url)

def main():
   parse_rule(basic_rule_url,'Basic')
   parse_rule(shared_rule_url,'Shared')
   parse_rule(aligned_rule_url,'Aligned')

if __name__ == '__main__':
    main()
