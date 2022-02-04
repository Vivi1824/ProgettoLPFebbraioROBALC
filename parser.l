%%

%byaccj

%{
  private Parser yyparser;
  public Yylex(java.io.Reader r, Parser yyparser) {
    this(r);
    this.yyparser = yyparser;
  }
%}
NL  = \n | \r
BEGINUSERINFO = "://"
BEGINPATH = "/"
BEGINQUERY = "?"
BEGINFRAGMENT = "#"
BEGINHOST = "@"
BEGINPORT = ":"


//STATI
%state S_USER_INFO
%state S_HOST
%state S_PORT
%state S_PATH
%state S_QUERY
%state S_FRAGMENT

%%

<YYINITIAL> {
  [\s]+                            { }

  [^:\{\n\r]+ {BEGINUSERINFO}           { String s = yytext();
                                     s = s.substring(0, s.length() - 1);
                                     yyparser.yylval = new ParserVal(s);
                                     yybegin(S_USER_INFO);
                                     return Parser.SCHEME; }
}
<S_USER_INFO> {
  [\s]+                            { }
  [^:\{\n\r]+ {BEGINHOST}           { String s = yytext();
                                     s = s.substring(0, s.length() - 1);
                                     yyparser.yylval = new ParserVal(s);
                                     yybegin(S_HOST);
                                     return Parser.USERINFO; }
}
<S_HOST> {
  [\s]+                            { }
  [^:\{\n\r]+ {BEGINPORT}           { String s = yytext();
                                     s = s.substring(0, s.length() - 1);
                                     yyparser.yylval = new ParserVal(s);
                                     yybegin(S_PORT);
                                     return Parser.IDENTIFICATORE_HOST; }
}
<S_PORT> {
  [\s]+                            { }       
  [0-9]+ {BEGINPATH}                {yyparser.yylval = new ParserVal(Integer.parseInt(yytext()));
                                     yybegin(S_PATH);
                                     return Parser.DIGIT; }
}
<S_PATH> {
  [\s]+                            { }
  [^:\{\n\r]+ {BEGINQUERY}           { String s = yytext();
                                     s = s.substring(0, s.length() - 1);
                                     yyparser.yylval = new ParserVal(s);
                                     yybegin(S_QUERY);
                                     return Parser.IDENTIFICATORE; }
}
<S_QUERY> {
  [\s]+                            { }
  [^:\{\n\r]+ {BEGINFRAGMENT}       { String s = yytext();
                                     s = s.substring(0, s.length() - 1);
                                     yyparser.yylval = new ParserVal(s);
                                     yybegin(S_FRAGMENT);
                                     return Parser.QUERY; }
}
<S_FRAGMENT> {
  [\s]+                            { }
  [^:\{\n\r]+ {NL}                    { String s = yytext();
                                     s = s.substring(0, s.length() - 1);
                                     yyparser.yylval = new ParserVal(s);
                                     return Parser.FRAGMENT; }
}













