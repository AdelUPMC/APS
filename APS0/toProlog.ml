open Ast;;

let rec print_prolog_cmds cmds=
	match cmds with
		 ASTStat(stat) -> (Printf.printf "stat(";
		 				  print_prolog_stat stat;
		 				  Printf.printf "),epsilon")
		|ASTDec(dec,cmds) -> (Printf.printf "dec(";
							  print_prolog_dec dec;
							  Printf.printf "),";
							  print_prolog_cmds cmds)
							 
		|ASTStatcmd(stat,cmds) -> (Printf.printf "stat(";
							     print_prolog_stat stat;
							     Printf.printf "),";
							     print_prolog_cmds cmds)
							     
and print_prolog_prog prog =
	match prog with
	ASTProg(cmds) -> (Printf.printf "prog([";
					 print_prolog_cmds cmds;
					 Printf.printf "]).")
							     
	
and print_prolog_stat stat =
	match stat with
	ASTEcho(e) -> (Printf.printf "echo(";
	               print_prolog_expr e;
	               Printf.printf ")")
	               
and print_prolog_dec dec =
	match dec with
	|ASTConst(id,t,e) -> (Printf.printf "const(%s," id;
							print_prolog_type t;
							Printf.printf ",";
							print_prolog_expr e;
							Printf.printf ")")
	|ASTFun(id,t,args,e) -> (Printf.printf "fun(%s," id;
							 	print_prolog_type t;
								Printf.printf ",";
								Printf.printf "[";
								print_prolog_args args;
								Printf.printf "]";
								Printf.printf ",";
								print_prolog_expr e;
								Printf.printf ")")
								
	|ASTFunRec(id,t,args,e) -> (Printf.printf "funRec(%s," id;
									print_prolog_type t;
									Printf.printf ",";
									Printf.printf "[";
									print_prolog_args args;
									Printf.printf "]";
	 								Printf.printf ",";
									print_prolog_expr e;
								    Printf.printf ")")
													

and print_prolog_expr e =
	match e with
	ASTTrue -> Printf.printf "true"
	|ASTFalse -> Printf.printf "false"
	|ASTNum(num) ->  Printf.printf "num(%d)" num
	|ASTId(id) -> Printf.printf "id(%s)" id
	|ASTBPrim(opbin,e1,e2) -> (Printf.printf"%s" (string_of_opbin opbin);
								Printf.printf"(";
								print_prolog_expr e1;
								Printf.printf",";
								print_prolog_expr e2;
								Printf.printf")")
	|ASTUPrim(opun,e) -> (Printf.printf"%s" (string_of_opun opun);
							Printf.printf"(";
							print_prolog_expr e;
							Printf.printf")")
	|ASTLambda(args,e) -> (Printf.printf "lambda(";
							Printf.printf "[";
							print_prolog_args args;
							Printf.printf "]";
							Printf.printf ",";
							print_prolog_expr e;
							Printf.printf ")")
	|ASTIf(e1,e2,e3) -> (Printf.printf "if(";
						 print_prolog_expr e1;
						 Printf.printf ",";
						 print_prolog_expr e2;
						 Printf.printf ",";
						 print_prolog_expr e3;
						 Printf.printf ")"
						 )
	|ASTApply(e,parameters) -> (Printf.printf "apply(";
								print_prolog_expr e;
								Printf.printf ",[";
								print_prolog_parameters parameters;
								Printf.printf "])")
												


and print_prolog_exprs e =
	match e with
	ASTExpr(e) ->  print_prolog_expr e;
	|ASTExprs(e,exprs) -> (Printf.printf "exprs(";
						   print_prolog_expr e;
						   Printf.printf ",";
						   print_prolog_exprs exprs;
						   Printf.printf ")")
	
and print_prolog_type tprim =
	match tprim with
	Int -> Printf.printf "int"
	|Bool -> Printf.printf "bool"
	|ASTArrow(types,tprim) -> (Printf.printf "arrowtype([";
							   print_prolog_types types;
							   Printf.printf "],";
							   print_prolog_type tprim;
							   Printf.printf ")")
									
and print_prolog_types types =
	match types with
	ASTType(t) -> print_prolog_type t;
	|ASTTypes(t,types) -> (Printf.printf "types(";
							print_prolog_type t;
							Printf.printf ",";
							print_prolog_types types;
							Printf.printf ")")
	
												
and print_prolog_parameters p =
	match p with
		ASTExpr(e) ->  print_prolog_expr e;
		|ASTExprs(e,p) -> (print_prolog_expr e;
						   Printf.printf ",";
						   print_prolog_parameters p;)
							   

and print_prolog_arg arg =
	match arg with
	Arg(id,t) -> (Printf.printf "(";
					Printf.printf "%s," id;
					print_prolog_type t;
					Printf.printf ")")
															   			   
and print_prolog_args args =
  match args with
	ASTArg(arg) -> print_prolog_arg arg
	|ASTArgs(arg,args) -> ( print_prolog_arg arg;
						  Printf.printf ",";
						  print_prolog_args args)	    

(*lecture dans un fichier sample en APS et conversion en AST*)
let _ =
	try
		let fl = open_in Sys.argv.(1) in
		let lexbuf = Lexing.from_channel fl in
		let p = Parser.prog Lexer.token lexbuf in
			print_prolog_prog p;
			print_char '\n'
		with Lexer.Eof -> exit 0
