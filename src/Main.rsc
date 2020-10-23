module Main

import org::klesun::lang::PsalmTypeExp::Concrete::WithLayout::Syntax;
import ParseTree;

import IO;

bool isWhitespace(value lexemeKind) {
	switch (lexemeKind) {
		case layouts(_): return true;
		default: return false;
	}
}

bool shouldPrintChildren(value lexemeKind) {
	switch (lexemeKind) {
		case sort(_): return true;
		case label(_, sort(_)): return true;
		case \iter-star-seps(sort(_), _): return true;
		case \iter-seps(sort(_), _): return true;
		default: return false;
	}
}

void printParsedAst(Tree parsed, int depth) {
	value lexemeKind = parsed.prod[0];
	if (!isWhitespace(lexemeKind)) {
		int nextDepth;
		if (lexemeKind == sort("PsalmTypeExp")) {
			// skip actual PsalmTypeExp node from output, as
			// everythinng is a PsalmTypeExp - it is verbose
			nextDepth = depth;
		} else {
			for (int i <- [0..depth]) {
				print("| ");
			}
			print(lexemeKind);
			if (lexemeKind == lex("StringLiteral") ||
				lexemeKind == lex("Fqn")
			) {
				print(" ");
				print(parsed); // print actual text of the lexeme
			}
			nextDepth = depth + 1;
			println();
		}
		if (shouldPrintChildren(lexemeKind)) {
			for (Tree child <- parsed.args) {
				printParsedAst(child, nextDepth);
			}
		}
	}
}

void main() {
	str psalmTypeStr = readFile(|project://klesun-rascal-playground/src/meal_type_def.psalm|);
	println(psalmTypeStr);
	PsalmTypeExp parsed = parse(#PsalmTypeExp, psalmTypeStr);
	printParsedAst(parsed, 0);
}
