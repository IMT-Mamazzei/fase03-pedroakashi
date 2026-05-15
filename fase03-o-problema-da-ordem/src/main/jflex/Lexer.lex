package br.maua.cic303;

import java_cup.runtime.Symbol;

%%

%class Lexer
%public
%unicode
%cup
%type java_cup.runtime.Symbol
%line
%column

%{

    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }

    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }

%}

/* ========================================================================= */
/* MACROS */
/* ========================================================================= */

LineTerminator = \r|\n|\r\n
WhiteSpace     = {LineTerminator} | [ \t\f]

Letter = [a-zA-Z]
Digit  = [0-9]

Number = [0-9]+(\.[0-9]+)?([Ee][+-]?[0-9]+)?

Identifier = {Letter}({Letter}|{Digit}|_){0,31}

OversizedIdentifier = {Letter}({Letter}|{Digit}|_){32,}

%%

<YYINITIAL> {

    {WhiteSpace}    { }

    /* Palavras reservadas */

    "if"            { return symbol(sym.IF); }
    "then"          { return symbol(sym.THEN); }
    "else"          { return symbol(sym.ELSE); }
    "while"         { return symbol(sym.WHILE); }

    /* Pontuação */

    "("             { return symbol(sym.LPAREN); }
    ")"             { return symbol(sym.RPAREN); }
    "{"             { return symbol(sym.LBRACE); }
    "}"             { return symbol(sym.RBRACE); }
    ";"             { return symbol(sym.SEMI); }

    /* Operadores relacionais */

    "=="            { return symbol(sym.REL_OP, yytext()); }
    "!="            { return symbol(sym.REL_OP, yytext()); }
    "<="            { return symbol(sym.REL_OP, yytext()); }
    ">="            { return symbol(sym.REL_OP, yytext()); }
    "<"             { return symbol(sym.REL_OP, yytext()); }
    ">"             { return symbol(sym.REL_OP, yytext()); }

    /* Atribuição */

    "="             { return symbol(sym.ASSIGN); }

    /* Operadores matemáticos */

    "+" | "-"       { return symbol(sym.ADD_OP, yytext()); }

    "*" | "/" | "%" { return symbol(sym.MUL_OP, yytext()); }

    /* Identificadores e números */

    {Identifier}    { return symbol(sym.ID, yytext()); }

    {Number}        { return symbol(sym.NUMBER, yytext()); }

    /* Erro de identificador gigante */

    {OversizedIdentifier} {
        throw new RuntimeException(
            "Erro Léxico: Identificador ultrapassou 32 caracteres -> " + yytext()
        );
    }

    /* Caractere inválido */

    . {
        throw new RuntimeException(
            "Erro Léxico: Caractere ilegal -> " + yytext()
        );
    }
}

/* EOF */

<<EOF>> {
    return symbol(sym.EOF);
}
