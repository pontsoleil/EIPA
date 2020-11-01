cat cen.tsv | awk  -F'\t' '{
  term=$3;
  # $3=tolower($3);     # Change filed 3 to all lower character
  n=split(term,w," ");  # Split term to array w and number of words in n
  s=w[1];
  for (i=2;i<=n;i++) {  # Going trough one and one words 
    match(w[i], /^([a-z])(.*)$/, b);
    if (b[1]) {
      t=toupper(b[1]) b[2];
    } else {
      match(w[i], /^([0-9A-Z])(.*)$/, b);
      match(w[i-1], /^(.*)([A-Z])$/, c);
      if (b[1]&&c[2]) {
        t="_" w[i];
      } else {
        t=w[i];
      }
    }
    s=s t;
  }
  term=s;
  type="";
  if ($2) {
    type=$2;
    match($2, /^([A-Z])(.*)$/, y);
    if (y[1]) {
      type=tolower(y[1]) y[2];
    }
    type=type "ItemType";
  } else {
    type="xbrli:stringItemtype";
  }
  print tolower($1) "\t" "\tcen\t" term "\t" type "\t" $3;
}' > cen_type.tsv