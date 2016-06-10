:- module( seDirigerVers, [
	init_astar/1,
	seDirigerVers/5,
	getHeuristicValue/3
] ).

:- use_module(fonctions).

seDirigerVers(Coordonnee,Fin,Laby,Cout,Action):-
	initialisationGlobale(Coordonnee,Fin),
	a_star(Coordonnee,Fin,Laby,Path,Cout),
	!,
	getSuite(Coordonnee,Path,Suite),
	getAction(Coordonnee,Suite,Action).
	
	
getSuite(Depart,[Suite,Depart,[-1,-1]],Suite):- !.
getSuite(Depart,[_|Reste],Suite):- getSuite(Depart,Reste,Suite).

getAction([X,_],[XSuite,_],Action):-
	XSuite is X + 1,
	Action = 1.
getAction([X,_],[XSuite,_],Action):-
	XSuite is X - 1,
	Action = 3.
getAction([_,Y],[_,YSuite],Action):-
	YSuite is Y + 1,
	Action = 4.
getAction([_,Y],[_,YSuite],Action):-
	YSuite is Y - 1,
	Action = 2.
	
	
% Init variables globales
init_astar(_):- 
	nb_setval(openList,[]), 
	nb_setval(closeList,[]).
	
initialisationGlobale(Coordonnee,Fin):- 
	getHeuristicValue(Coordonnee,Fin,H),
	nb_setval(openList,[[Coordonnee,0,H,[-1,-1]]]), 
	nb_setval(closeList,[]).

% Predicats A*
/* 
  a_star(+CourantState, +FinalState, +Labyrinth, -Path) 
*/
% openList vide pas de solution
a_star(_,_,_,_,_):-
	nb_getval(openList, []),
	!,
	fail.
	
% etat final atteint par -1
a_star([X,Y],_,Laby,Path,Cout):-
	elemAtCoord(Laby, X, Y, E),
	E = -1,
	buildPath([X,Y],Path,Cout).
	
% etat final atteint
a_star([X,Y],[X,Y],_,Path,Cout):-
	buildPath([X,Y],Path,Cout).

a_star([X,Y],[XFinal,YFinal],Laby,Path,Cout):-
	extractBestNodeFromOpenList(Node),
	addNodeToClose(Node),
	Node = [[X,Y],G,_,_],
	trouverSuccesseurs([X,Y],Laby,Successeurs),
	ajouterChemin([X,Y],Successeurs,[XFinal,YFinal],G,Laby),
	getBestNodeFromOpenList(BestNode),
	BestNode = [NewState,_,_,_],
	a_star(NewState,[XFinal,YFinal],Laby,Path,Cout).
	
ajouterChemin(_,[],_,_,_):-
	!.
ajouterChemin([X,Y],[[]|Reste],Fin,G,Laby):-
	!,
	ajouterChemin([X,Y],Reste,Fin,G,Laby).
	
% test si il n'est pas dans closed et open
ajouterChemin([X,Y],[Successeur|Reste],Fin,G,Laby):-
	not(isInOpen(Successeur)),
	not(isInClose(Successeur)),
	!,
	getHeuristicValue(Successeur,Fin,H),
	getCValue(C, Successeur, Laby),
	GPlus is (G + C),
	%GPlus is (G+1),
	F is (GPlus + H),
	NewNode = [Successeur,GPlus,F,[X,Y]],
	addNodeToOpen(NewNode),
	ajouterChemin([X,Y],Reste,Fin,G,Laby).
	
% test si g(y) > g(N.e)+c(N.e,y)
ajouterChemin([X,Y],[Successeur|Reste],Fin,G,_):-
	testBestCostInOpenOrClose([X,Y],Successeur,G,Fin),
	!,
	ajouterChemin([X,Y],Reste,Fin,G,_).

% aucun des deux critères n'est possible, on passe au successeur suivant
ajouterChemin([X,Y],[_|Reste],Fin,G,_):-
	ajouterChemin([X,Y],Reste,Fin,G,_).
	
% 10 de cout pour un rocher
getCValue(C,[X,Y],Laby):-
	elemAtCoord(Laby,X,Y,3),
	!,
	C is 10.
% 3 de cout pour de la dirt
getCValue(C,[X,Y],Laby):-
	elemAtCoord(Laby,X,Y,1),
	!,
	C is 3.
% 1 pour le reste
getCValue(C,_,_):-
	!,
	C is 1.
	
% trouver les successeur 
trouverSuccesseurs([X,Y],Laby,Successeurs):-
	movementH([X,Y],Laby,CoordH),
	movementG([X,Y],Laby,CoordG),
	movementB([X,Y],Laby,CoordB),
	movementD([X,Y],Laby,CoordD),
	Successeurs = [CoordD,CoordH,CoordG,CoordB].

movementD([X,Y],Laby,CoordD):-
	XNew is X+1,
	possibleMove([XNew,Y],Laby,d),
	!,
	CoordD = [XNew,Y].

movementD(_,_,[]).
	
movementH([X,Y],Laby,CoordH):-
	YNew is Y-1,
	possibleMove([X,YNew],Laby,h),
	!,
	CoordH = [X,YNew].

movementH(_,_,[]).
	
movementB([X,Y],Laby,CoordB):-
	YNew is Y+1,
	possibleMove([X,YNew],Laby,b),
	!,
	CoordB = [X,YNew].

movementB(_,_,[]).
	
movementG([X,Y],Laby,CoordG):-
	XNew is X-1,
	possibleMove([XNew,Y],Laby,g),
	!,
	CoordG = [XNew,Y].

movementG(_,_,[]).	

% Predicats A* spécifique problème
/* 
  getHeuristicValue([+XATester,+YATester],[+XFinal,+YFinal],-V)
*/
getHeuristicValue([XATester,YATester],[XFinal,YFinal],V):- V is sqrt((XFinal-XATester)*(XFinal-XATester)+(YATester-YFinal)*(YATester-YFinal)).

/*
  extractBestNodeFromOpenList(-Node)
*/
%si un seul elem
extractBestNodeFromOpenList(BestNode):-
	nb_getval(openList,OpenList),
	OpenList = [BestNode|[]],
	!,
	substractFromOpenList(BestNode).

extractBestNodeFromOpenList(BestNode):-
	nb_getval(openList,OpenList),
	OpenList = [Node|ResteOpen],
	Node=[_,_,F,_],
	extractBestNodeFromOpenList(Node,BestNode,F,_,ResteOpen),
	substractFromOpenList(BestNode).
	
extractBestNodeFromOpenList(BestNode,BestNode,BestF,BestF,[]):-
	!.
extractBestNodeFromOpenList(_,BestNode,F,BestF,[Node|AutreNode]):-
	Node = [_,_,FNode,_],
	F > FNode,
	!,
	extractBestNodeFromOpenList(Node,BestNode,FNode,BestF,AutreNode).
extractBestNodeFromOpenList(CourNode,BestNode,F,BestF,[_|AutreNode]):-
	!,
	extractBestNodeFromOpenList(CourNode,BestNode,F,BestF,AutreNode).
	
/*
  getBestNodeFromOpenList(-Node)
*/
getBestNodeFromOpenList(BestNode):-
	nb_getval(openList,OpenList),
	OpenList = [Node|ResteOpen],
	Node=[_,_,F,_],
	getBestNodeFromOpenList(Node,BestNode,F,_,ResteOpen).
	
getBestNodeFromOpenList(BestNode,BestNode,BestF,BestF,[]):-
	!.
getBestNodeFromOpenList(_,BestNode,F,BestF,[Node|AutreNode]):-
	Node = [_,_,FNode,_],
	F > FNode,
	!,
	getBestNodeFromOpenList(Node,BestNode,FNode,BestF,AutreNode).
getBestNodeFromOpenList(CourNode,BestNode,F,BestF,[_|AutreNode]):-
	getBestNodeFromOpenList(CourNode,BestNode,F,BestF,AutreNode).

/*
  extractNodeFromOpen(+State, -Node)
*/
extractNodeFromOpen(State,Node):-
	nb_getval(openList,OpenList),
	extractNodeFromOpen(State,Node,OpenList),
	substractFromOpenList(Node).
	
extractNodeFromOpen(_,_,[]):- fail.
extractNodeFromOpen(State,Node,[Node|_]):-
	Node = [State,_,_,_].
extractNodeFromOpen(State,Node,[_|AutreNode]):-
	extractNodeFromOpen(State,Node,AutreNode).	
	
/*
  getNodeFromOpen(+State, -Node)
*/
getNodeFromOpen(State,Node):-
	nb_getval(openList,OpenList),
	getNodeFromOpen(State,Node,OpenList).
	
getNodeFromOpen(_,_,[]):- fail.
getNodeFromOpen(State,Node,[Node|_]):-
	Node = [State,_,_,_].
getNodeFromOpen(State,Node,[_|AutreNode]):-
	getNodeFromOpen(State,Node,AutreNode).	
	
	
/*
  substractFromOpenList(+Node)
*/
substractFromOpenList(Node):-
	nb_getval(openList,OpenList),
	substractFromOpenList(Node,OpenList,[]).
	
substractFromOpenList(Node,[Node|AutreNode],DebutNode):-
	append(DebutNode,AutreNode,NewOpenList),
	!,
	nb_setval(openList,NewOpenList).
substractFromOpenList(Node,[PasNode|AutreNode],DebutNode):-
	append(DebutNode,[PasNode],ListeNode),
	substractFromOpenList(Node,AutreNode,ListeNode).
	
/*
  addNodeToOpen(+Node)
*/
addNodeToOpen(Node):-
	nb_getval(openList,OpenList),
	append([Node],OpenList,NewOpenList),
	nb_setval(openList,NewOpenList).

/*
  extractNodeFromClose(+State, -Node)
*/
extractNodeFromClose(State,Node):-
	nb_getval(closeList,CloseList),
	extractNodeFromClose(State,Node,CloseList),
	substractFromCloseList(Node).
	
extractNodeFromClose(_,_,[]):- fail.
extractNodeFromClose(State,Node,[Node|_]):-
	Node = [State,_,_,_].
extractNodeFromClose(State,Node,[_|AutreNode]):-
	extractNodeFromClose(State,Node,AutreNode).
	
/*
  getNodeFromClose(+State, -Node)
*/
getNodeFromClose(State,Node):-
	nb_getval(closeList,CloseList),
	getNodeFromClose(State,Node,CloseList).
	
getNodeFromClose(_,_,[]):- fail.
getNodeFromClose(State,Node,[Node|_]):-
	Node = [State,_,_,_].
getNodeFromClose(State,Node,[_|AutreNode]):-
	getNodeFromClose(State,Node,AutreNode).

/*
  substractFromCloseList(+Node)
*/
substractFromCloseList(Node):-
	nb_getval(closeList,CloseList),
	substractFromCloseList(Node,CloseList,[]).
	
substractFromCloseList(Node,[Node|AutreNode],DebutNode):-
	append(DebutNode,AutreNode,NewCloseList),
	!,
	nb_setval(closeList,NewCloseList).
substractFromCloseList(Node,[PasNode|AutreNode],DebutNode):-
	append(DebutNode,[PasNode],ListeNode),
	substractFromCloseList(Node,AutreNode,ListeNode).
	
/*
  addNodeToClose(+Node)
*/
addNodeToClose(Node):-
	nb_getval(closeList,CloseList),
	append([Node],CloseList,NewCloseList),
	nb_setval(closeList,NewCloseList).
	
/*
  testBestCostInOpenOrClose(+Pere,+Successeur,+GPere,+Fin)
*/
testBestCostInOpenOrClose([X,Y],Successeur,GPere,Fin):-
	isInOpenWithBestCost(Successeur,GPere),
	!,
	extractNodeFromOpen(Successeur,_),
	GPlus is (GPere + 1),
	getHeuristicValue(Successeur,Fin,H),
	F is (GPlus + H),
	NewNode = [Successeur,GPlus,F,[X,Y]],
	addNodeToOpen(NewNode).
	
testBestCostInOpenOrClose([X,Y],Successeur,GPere,Fin):-
	isInCloseWithBestCost(Successeur,GPere),
	!,
	extractNodeFromClose(Successeur,_),
	GPlus is (GPere + 1),
	getHeuristicValue(Successeur,Fin,H),
	F is (GPlus + H),
	NewNode = [Successeur,GPlus,F,[X,Y]],
	addNodeToOpen(NewNode).
	
/*
  isInOpenWithBestCost(+Successeur,+GPere)
*/
isInOpenWithBestCost(Successeur,GPere):-
	nb_getval(openList,OpenList),
	isInOpenWithBestCost(Successeur,GPere,OpenList).
	
isInOpenWithBestCost(_,_,[]):- fail.
	
isInOpenWithBestCost(Successeur,GPere,[Node|_]):-
	Node = [Successeur,G,_,_],
	GPlus is (GPere + 1),
	GPlus < G,
	!.
	
isInOpenWithBestCost(Successeur,GPere,[_|AutreNode]):-
	isInOpenWithBestCost(Successeur,GPere,AutreNode).


	
/*
  isInCloseWithBestCost(+Successeur,+GPere)
*/
isInCloseWithBestCost(Successeur,GPere):-
	nb_getval(closeList,CloseList),
	isInCloseWithBestCost(Successeur,GPere,CloseList).
	
isInCloseWithBestCost(_,_,[]):- fail.
	
isInCloseWithBestCost(Successeur,GPere,[Node|_]):-
	Node = [Successeur,G,_,_],
	GPlus is (GPere + 1),
	GPlus < G,
	!.
	
isInCloseWithBestCost(Successeur,GPere,[_|AutreNode]):-
	isInCloseWithBestCost(Successeur,GPere,AutreNode).
	
/*
  buildPath(+Coordonnee,-Path,-Cout)
*/
buildPath([X,Y],Path,Cout):-
	getCout([X,Y],Cout),
	buildPath([X,Y],PathSansPere,[]),
	append([[X,Y]],PathSansPere,Path).

buildPath([-1,-1],Path,Path).

buildPath([X,Y],Path,CourPath):-
	isInOpen([X,Y]),
	extractNodeFromOpen([X,Y],Node),
	Node = [[X,Y],_,_,Pere],
	append(CourPath,[Pere],NewPath),
	buildPath(Pere,Path,NewPath).
	
buildPath([X,Y],Path,CourPath):-
	isInClose([X,Y]),
	extractNodeFromClose([X,Y],Node),
	Node = [[X,Y],_,_,Pere],
	append(CourPath,[Pere],NewPath),
	buildPath(Pere,Path,NewPath).
	
	
/*
  getCout(+Coordonne,-Cout)
*/

getCout([X,Y],Cout):-
	isInOpen([X,Y]),
	getNodeFromOpen([X,Y],Node),
	Node = [_,_,Cout,_].
	
getCout([X,Y],Cout):-
	isInClose([X,Y]),
	getNodeFromClose([X,Y],Node),
	Node = [_,_,Cout,_].
	
/*
  isInOpen(+Coordonnee)
*/
isInOpen(Successeur):-
	nb_getval(openList,OpenList),
	isInOpen(Successeur,OpenList).
	
isInOpen(_,[]):- fail.
	
isInOpen(Successeur,[Node|_]):-
	Node = [Successeur,_,_,_],
	!.
	
isInOpen(Successeur,[_|AutreNode]):-
	isInOpen(Successeur,AutreNode).

/*
  isInClose(+Coordonnee)
*/
isInClose(Successeur):-
	nb_getval(closeList,CloseList),
	isInClose(Successeur,CloseList).
	
isInClose(_,[]):- fail.
	
isInClose(Successeur,[Node|_]):-
	Node = [Successeur,_,_,_],
	!.
	
isInClose(Successeur,[_|AutreNode]):-
	isInClose(Successeur,AutreNode).

% Prochaine position possible
possibleMove([X,Y], Laby,_):- elemAtCoord(Laby,X,Y, E), E =< 2.
possibleMove([X,Y], Laby,_):- elemAtCoord(Laby,X,Y, E), E = 21.

possibleMove([X,Y],Laby,g):- elemAtCoord(Laby,X,Y,3), XGauche is (X-1), elemAtCoord(Laby,XGauche,Y,0).
possibleMove([X,Y],Laby,h):- elemAtCoord(Laby,X,Y,3), YHaut is (Y-1), elemAtCoord(Laby,X,YHaut,0).
possibleMove([X,Y],Laby,b):- elemAtCoord(Laby,X,Y,3), YBas is (Y+1), elemAtCoord(Laby,X,YBas,0).
possibleMove([X,Y],Laby,b):- elemAtCoord(Laby,X,Y,3), YBas is (Y+1), elemAtCoord(Laby,X,YBas,4).
possibleMove([X,Y],Laby,d):- elemAtCoord(Laby,X,Y,3), XDroit is (X+1), elemAtCoord(Laby,XDroit,Y,0).
