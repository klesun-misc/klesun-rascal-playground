module org::klesun::lang::PsalmTypeExp::Concrete::WithLayout::Syntax

lexical StringLiteral = "\'" StringChar* "\'";
lexical StringChar
	= ![\' \\]
	| "\\" [\' \\ / b f n r t]
	;

lexical IdentifierName = [_a-zA-Z][_a-zA-Z0-9]*;
lexical Fqn = "\\"? IdentifierName ("\\" IdentifierName)*;

syntax AssocMember = StringLiteral ":" PsalmTypeExp;

start syntax PsalmTypeExp 
  = StringLiteral
  | bracket "array{" { AssocMember "," }* "}"
  | bracket Fqn "\<" { PsalmTypeExp "," }+ "\>"
  > left Fqn
  > left PsalmTypeExp "|" PsalmTypeExp
  ;

layout LAYOUT = [\t-\n \r \ ]*;