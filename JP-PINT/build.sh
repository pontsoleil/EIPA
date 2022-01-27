#!/bin/sh
set -e

# echo Summarised Invoice
# cp ./jp_pint_base_summarised.py ./jp_pint_base.py
# ./jp-pint_semantics.py data/jp_pint.csv data/rules/pint_rules.csv data/rules/jp-pint_rules.csv data/jp-pint_schematron.csv data/rules/en-peppol_rules.csv data/rules/en-cen_rules.csv -v
# ./jp-pint_syntax.py data/jp_pint.csv data/rules/pint_rules.csv data/rules/jp-pint_rules.csv data/jp-pint_schematron.csv data/rules/en-peppol_rules.csv data/rules/en-cen_rules.csv -v

# echo Debit Note
# cp ./jp_pint_base_debitnote.py ./jp_pint_base.py
# ./jp-pint_semantics.py data/jp_pint.csv data/rules/pint_rules.csv data/rules/jp-pint_rules.csv data/jp-pint_schematron.csv data/rules/en-peppol_rules.csv data/rules/en-cen_rules.csv -v
# ./jp-pint_syntax.py data/jp_pint.csv data/rules/pint_rules.csv data/rules/jp-pint_rules.csv data/jp-pint_schematron.csv data/rules/en-peppol_rules.csv data/rules/en-cen_rules.csv -v

echo Invoice
# cp ./jp_pint_base_invoice.py ./jp_pint_base.py
./jp-pint_semantics.py data/jp_pint.csv -v
./jp-pint_syntax.py data/jp_pint.csv -v
# ./jp-pint_rules.py data/jp_pint.csv data/rules/pint_rules.csv data/rules/jp-pint_rules.csv data/jp-pint_schematron.csv -v
