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

/* Macros de Comentário */
LineComment  = "//" [^\r\n]*
BlockComment = "/*" ~"*/"

Letter = [a-zA-Z]
Digit  = [0-9]

/* Aceita: 7, 3.14, 6.02E23, 6.62e-34 */
Number = [0-9]+(\.[0-9]+)?([Ee][+-]?[0-9]+)?

/* Máximo 32 caracteres */
Identifier = {Letter}({Letter}|{Digit}|_){0,31}

/* Identificador inválido */
OversizedIdentifier = {Letter}({Letter}|{Digit}|_){32,}

%%

<YYINITIAL> {

    /* Ignora espaços e comentários */
    {WhiteSpace}   { }
    {LineComment}  { }
    {BlockComment} { }

    /* ================================================================ */
    /* PALAVRAS RESERVADAS */
    /* ================================================================ */

    "if"        { return symbol(sym.IF); }
    "then"      { return symbol(sym.THEN); }
    "else"      { return symbol(sym.ELSE); }
    "while"     { return symbol(sym.WHILE); }

    /* ================================================================ */
    /* PONTUAÇÃO */
    /* ================================================================ */

    "("         { return symbol(sym.LPAREN); }
    ")"         { return symbol(sym.RPAREN); }

    "{"         { return symbol(sym.LBRACE); }
    "}"         { return symbol(sym.RBRACE); }

    ";"         { return symbol(sym.SEMI); }

    /* ================================================================ */
    /* OPERADORES RELACIONAIS */
    /* ================================================================ */

    "=="        { return symbol(sym.REL_OP, yytext()); }
    "!="        { return symbol(sym.REL_OP, yytext()); }
    "<="        { return symbol(sym.REL_OP, yytext()); }
    ">="        { return symbol(sym.REL_OP, yytext()); }
    "<"         { return symbol(sym.REL_OP, yytext()); }
    ">"         { return symbol(sym.REL_OP, yytext()); }

    /* ================================================================ */
    /* ATRIBUIÇÃO */
    /* ================================================================ */

    "="         { return symbol(sym.ASSIGN); }

    /* ================================================================ */
    /* OPERADORES MATEMÁTICOS */
    /* ================================================================ */

    "+" | "-"   { return symbol(sym.ADD_OP, yytext()); }

    "*" | "/" | "%" {
        return symbol(sym.MUL_OP, yytext());
    }

    /* ================================================================ */
    /* IDENTIFICADORES E NÚMEROS */
    /* ================================================================ */

    {Identifier} {
        return symbol(sym.ID, yytext());
    }

    {Number} {
        return symbol(sym.NUMBER, yytext());
    }

    /* ================================================================ */
    /* ERRO: IDENTIFICADOR MUITO GRANDE */
    /* ================================================================ */

    {OversizedIdentifier} {
        throw new CompilerException(
            "Erro Léxico: Identificador ultrapassou 32 caracteres -> " + yytext()
        );
    }

    /* ================================================================ */
    /* ERRO: CARACTERE INVÁLIDO */
    /* ================================================================ */

    . {
        throw new CompilerException(
            "Erro Léxico: Caractere ilegal -> " + yytext()
        );
    }
}

/* ========================================================================= */
/* EOF */
/* ========================================================================= */

<<EOF>> {
    return symbol(sym.EOF);
}
