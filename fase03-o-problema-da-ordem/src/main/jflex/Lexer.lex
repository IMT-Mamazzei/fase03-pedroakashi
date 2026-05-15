package br.maua.cic303;

import java_cup.runtime.*;

%%
%class Lexer
%public
%unicode
%implements java_cup.runtime.Scanner
%type java_cup.runtime.Symbol
%function next_token
%line
%column

/* ================= MACROS ================= */

LineTerminator = \r|\n|\r\n
WhiteSpace = {LineTerminator} | [ \t\f]

Letter = [a-zA-Z]
Digit = [0-9]

Number = [0-9]+(\.[0-9]+)?([Ee][+-]?[0-9]+)?

Identifier = {Letter}({Letter}|{Digit}|_){0,31}

/* ================= REGRAS ================= */

%%
<YYINITIAL> {

    /* Ignorar espaços */
    {WhiteSpace}    { }

    /* ===== PALAVRAS RESERVADAS ===== */
    "if"    { return new Symbol(sym.IF, yyline, yycolumn, yytext()); }
    "then"  { return new Symbol(sym.THEN, yyline, yycolumn, yytext()); }
    "else"  { return new Symbol(sym.ELSE, yyline, yycolumn, yytext()); }
    "while" { return new Symbol(sym.WHILE, yyline, yycolumn, yytext()); }

    /* ===== PONTUAÇÃO ===== */
    "("  { return new Symbol(sym.LPAREN, yyline, yycolumn, yytext()); }
    ")"  { return new Symbol(sym.RPAREN, yyline, yycolumn, yytext()); }
    "{"  { return new Symbol(sym.LBRACE, yyline, yycolumn, yytext()); }
    "}"  { return new Symbol(sym.RBRACE, yyline, yycolumn, yytext()); }
    ";"  { return new Symbol(sym.SEMI, yyline, yycolumn, yytext()); }

    /* ===== OPERADORES RELACIONAIS (ORDEM IMPORTANTE) ===== */
    "==" { return new Symbol(sym.REL_OP, yyline, yycolumn, yytext()); }
    "!=" { return new Symbol(sym.REL_OP, yyline, yycolumn, yytext()); }
    "<=" { return new Symbol(sym.REL_OP, yyline, yycolumn, yytext()); }
    ">=" { return new Symbol(sym.REL_OP, yyline, yycolumn, yytext()); }
    "<"  { return new Symbol(sym.REL_OP, yyline, yycolumn, yytext()); }
    ">"  { return new Symbol(sym.REL_OP, yyline, yycolumn, yytext()); }

    /* ===== ATRIBUIÇÃO ===== */
    "="  { return new Symbol(sym.ASSIGN, yyline, yycolumn, yytext()); }

    /* ===== OPERADORES MATEMÁTICOS ===== */
    "+" | "-"       { return new Symbol(sym.ADD_OP, yyline, yycolumn, yytext()); }
    "*" | "/" | "%" { return new Symbol(sym.MUL_OP, yyline, yycolumn, yytext()); }

    /* ===== IDENTIFICADORES ===== */
    {Identifier}    { return new Symbol(sym.ID, yyline, yycolumn, yytext()); }

    /* ===== NÚMEROS ===== */
    {Number}        { return new Symbol(sym.NUMBER, yyline, yycolumn, yytext()); }

    /* ===== ERRO: MAIS DE 32 CARACTERES ===== */
    {Letter}({Letter}|{Digit}|_){32} {
        throw new RuntimeException("Erro Léxico: Identificador ultrapassou 32 caracteres -> " + yytext());
    }

    /* ===== ERRO GENÉRICO ===== */
    . {
        throw new RuntimeException("Erro Léxico: Caractere ilegal -> " + yytext());
    }
}

<<EOF>> { return new Symbol(sym.EOF, yyline, yycolumn); }
