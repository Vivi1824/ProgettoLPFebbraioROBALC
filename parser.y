/* Gatti Daniel Marco e Giuliani Viviana*/

%{
  import java.io.*;
%}




%token <sval> FRAGMENT
%token <sval> CARATTERE
%token <sval> CARATTEREQUERY
%token <sval> IDENTIFICATORE
%token <ival> DIGIT
%token <sval> IDENTIFICATORE_HOST
%token <sval> SCHEME
%token <sval> USERINFO
%token <sval> QUERY

%type <sval> fragment
%type <sval> query
%type <sval> path
%type <ival> port
%type <sval> userinfo
%type <sval> scheme
%type <sval> host
%type <sval> indirizzo_IP
%type <sval> authorithy
%type <sval> uri1

%start s

%%
fragment:  FRAGMENT CARATTERE
		   { $$ = $1 + " " + $2; }
query: QUERY CARATTEREQUERY
		   { $$ = $1  + " " + $2; }
path: IDENTIFICATORE
		   { $$ = $1 + "/"; }     /*INSERIRE LA PRIMA SBARRA NEL LEXER*/
	  | path IDENTIFICATORE
		   { $$ = $1 + "" + $2 + "/"; }
port: DIGIT     							/*INT*/
		   { $$ = $1; }
userinfo: USERINFO							
		   { $$ = $1; }
scheme: SCHEME
		   { $$ = $1; }
indirizzo_IP: DIGIT DIGIT DIGIT DIGIT		/*INT*/
		   { $$ = $1 + "." + $2 + "." + $3 + "." + $4; }
host: IDENTIFICATORE_HOST IDENTIFICATORE_HOST
		   { $$ = $1 + "." + $2; }
	  | host IDENTIFICATORE_HOST 
		   { $$ = $1 + "." + $2; }
	  | indirizzo_IP     /*NEL DUBBIO DIVIDI*/
		   { $$ = $1; }
authorithy: userinfo host port
		   { $$ = "//" + $1 + "@" + $2 + ":" + $3; }
uri1: scheme authorithy path query fragment
		   { $$ = $1 + ":" + $2 + "/" + $3 + "?" + $4 + "#" + $5; }
s: uri1
	{ System.out.println($1); }
			




		   
		   

		   



%%

private Yylex lexer;


  private int yylex () {
    int yyl_return = -1;
    try {
      yylval = new ParserVal(0);
      yyl_return = lexer.yylex();
    }
    catch (IOException e) {
      System.err.println("IO error :"+e);
    }
    return yyl_return;
  }


  public void yyerror (String error) {
    System.err.println ("Error: " + error);
  }


  public Parser(Reader r) {
    lexer = new Yylex(r, this);
  }


  static boolean interactive;

  public static void main(String args[]) throws IOException {

    Parser yyparser;
    if ( args.length > 0 ) {
      // parse a file
      yyparser = new Parser(new FileReader(args[0]));
    }
    else {
      // interactive mode
      interactive = true;
	    yyparser = new Parser(new InputStreamReader(System.in));
    }
    yyparser.yyparse();
  }
