%{ 
%} 
%% 
[0-9]+[.][0-9]+ printf("%s is a floating point number\n",yytext); 
int|float|char|double|void printf("%s is a datatype\n",yytext); 
if|else|while|main printf("%s is a keyword\n",yytext); 
[0-9]+ printf("%s is an integer number\n",yytext); 
[a-z]+[()] printf("%s is a function\n",yytext); 
[a-z]+ printf("%s is an identifier\n",yytext); 
[+=*/-] printf("%s is an operator\n",yytext); 
; printf("%s is an delimiter\n",yytext); 
, printf("%s is a separator\n",yytext); 
[#][a-z\.h]+ printf("%s is a preprocessor\n",yytext); 
%% 
int yywrap(void) 
{ 
return 1; 
} 
int main() 
{ 
  freopen("6.c", "r", stdin); 
yylex(); 
return 0; 
} 