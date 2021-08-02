#!/bin/sh
set -e
./jp-pint_semantics.py data/jp_pint.csv data/rules/pint_rules.csv data/rules/jp-pint_rules.csv -v
./jp-pint_syntax.py data/jp_pint.csv data/rules/pint_rules.csv data/rules/jp-pint_rules.csv data/jp-pint_schematron.csv -v
./jp-pint_rules.py data/jp_pint.csv data/rules/pint_rules.csv data/rules/jp-pint_rules.csv data/jp-pint_schematron.csv -v
./peppol_rules.py data/jp_pint.csv data/rules/en-peppol_rules.csv data/rules/en-cen_rules.csv -v
