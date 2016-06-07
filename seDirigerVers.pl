:- module( seDirigerVers, [
	init_astar/1,
	seDirigerVers/5
] ).

% Init variables globales
init_astar(_):- nb_setval(openList,[]), nb_setval(closedList,[]).

% Predicats A*
/* 
  a_star(+CourantState, +FinalState, +Labyrinth, -Path) 
*/
% openList vide donner la solution grace a closeList
a_star(_,_,_,_):-
	nb_getval(openList, []),
	!.
	
% etat final atteint
a_star([X,Y],[X,Y],_,Path):-
	buildPath(Path).


a_star([X,Y],[XFinal,YFinal],Laby,Path):-
	extractBestNodeFromOpenList(Node),
	addNodeToClose(Node),
	Node = [[X,Y],G,F,_],
	trouverSuccesseurs([X,Y],Laby,Successeurs),
	ajouterChemin([X,Y],Successeurs,[XFinal,YFinal],G),
	/*nb_getval(openList, [[NewState,_,_,_]|_]),
	a_star(NewState,[XFinal,YFinal],Laby,Path).*/
	
	
ajouterChemin(_,[],_,_,_).
% test si il n'est pas dans closed et open
ajouterChemin([X,Y],[Successeur|Reste],Fin,G):-
	nb_getval(openList, OpenList),
	nb_getval(closedList, ClosedList),
	nonStateInListe(Successeur,OpenList),
	nonStateInListe(Successeur,CloseList),
	!,
	getHeuristicValue(Successeur,Fin,H),
	GPlus is (G + 1),
	F is (GPlus + H),
	NewNode = [Successeur,GPlus,F,[X,Y]],
	addNodeToOpen(NewNode),
	ajouter([X,Y],Reste,Fin,G).
	
% test si g(y) > g(N.e)+c(N.e,y)
ajouterChemin([X,Y],[Successeur|Reste],Fin,G):-
	testBestCostInOpenOrClose([X,Y],Successeur,G,Fin),
	!,
	ajouterChemin([X,Y],Reste,Fin,G).

% aucun des deux critères n'est possible, ont passe au successeur suivant
ajouterChemin([X,Y],[_|Reste],Fin,G):-
	ajouterChemin([X,Y],Reste,Fin,G).

nonStateInListe(_,[]).
nonStateInListe(Successeur,[[State,_,_,_]|StateRestant]):-
	Successeur \= State,
	nonStateInListe(Successeur,StateRestant).
	
	
% trouver les successeur 
trouverSuccesseurs([X,Y],Laby,Successeurs):-
	movementD([X,Y],Laby,CoordD),
	movementH([X,Y],Laby,CoordH),
	movementG([X,Y],Laby,CoordG),
	movementB([X,Y],Laby,CoordB),
	Successeurs = [CoordD,CoordH,CoordG,CoordB].

movementD([X,Y],Laby,CoordD):-
	XNew is X+1,
	possibleMove([XNew,Y],Laby),
	CoordD = [XNew,Y].

movementD(_,_,[]).
	
movementH([X,Y],Laby,CoordH):-
	YNew is Y-1,
	possibleMove([X,YNew],Laby),
	CoordH = [X,YNew].

movementH(_,_,[]).
	
movementB([X,Y],Laby,CoordB):-
	YNew is Y+1,
	possibleMove([X,YNew],Laby),
	CoordB = [X,YNew].

movementB(_,_,[]).
	
movementG([X,Y],Laby,CoordG):-
	XNew is X-1,
	possibleMove([XNew,Y],Laby),
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
extractBestNodeFromOpenList(Node):-
	nb_getval(openList,OpenList),
	extractBestNodeFromOpenList(Node,OpenList,-1),
	substractFromOpenList(Node).
	
extractBestNodeFromOpenList(BestNode,[],_).
extractBestNodeFromOpenList(BestNode,[BestNode|_],-1).
extractBestNodeFromOpenList(BestNode,[Node|AutreNode],F):-
	Node = [_,_,FNode,_],
	F >= FNode,
	!,
	BestNode = Node,
	extractBestNodeFromOpenList(BestNode,AutreNode,FNode).
extractBestNodeFromOpenList(BestNode,[_|AutreNode],F):-
	extractBestNodeFromOpenList(BestNode,AutreNode,F).

/*
  extractNodeFromOpen(+State, -Node)
*/
extractNodeFromOpen(State,Node):-
	nb_getval(openList,OpenList),
	extractNodeFromOpen(State,Node,OpenList),
	substractFromOpenList(S).
	
extractNodeFromOpen(_,_,[]):- fail.
extractNodeFromOpen(State,Node,[Node|_]):-
	Node = [State,_,_,_].
extractNodeFromOpen(State,Node,[_|AutreNode]):-
	extractNodeFromOpen(State,Node,AutreNode).	

/*
  substractFromOpenList(-Node)
*/
substractFromOpenList(Node):-
	nb_getval(openList,OpenList),
	substractFromOpenList(Node,OpenList,[]).
	
substractFromOpenList(Node,[Node|AutreNode],DebutNode):-
	append(DebutNode,AutreNode,NewOpenList),
	nb_setval(openList,NewOpenList).
substractFromOpenList(Node,[PasNode|AutreNode],DebutNode):-
	append(DebutNode,PasNode,ListeNode),
	substractFromOpenList(Node,AutreNode,ListeNode).
	
/*
  addNodeToOpen(+Node)
*/
addNodeToOpen(Node):-
	nb_getval(closeList,CloseList),
	append([Node],CloseList,NewCloseList),
	nb_setval(closeList,NewCloseList).

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
  substractFromCloseList(+Node)
*/
substractFromCloseList(Node):-
	nb_getval(closeList,CloseList),
	substractFromCloseList(Node,CloseList,[]).
	
substractFromCloseList(Node,[Node|AutreNode],DebutNode):-
	append(DebutNode,AutreNode,NewCloseList),
	nb_setval(closeList,NewCloseList).
substractFromCloseList(Node,[PasNode|AutreNode],DebutNode):-
	append(DebutNode,PasNode,ListeNode),
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
	extractNodeFromOpen(Successeur,Node),
	GPlus is (GPere + 1),
	getHeuristicValue(Successeur,Fin,H)
	F is (GPlus + H),
	NewNode = [Successeur,GPlus,F,[X,Y]],
	addNodeToOpen(NewNode).
	
testBestCostInOpenOrClose([X,Y],Successeur,GPere):-
	isInCloseWithBestCost(Successeur,GPere),
	!,
	extractNodeFromClose(Successeur,Node),
	GPlus is (GPere + 1),
	getHeuristicValue(Successeur,Fin,H)
	F is (GPlus + H),
	NewNode = [Successeur,GPlus,F,[X,Y]],
	addNodeToOpen(NewNode).
	
/*
  isInOpenWithBestCost(+Successeur,+GPere)
*/
isInOpenWithBestCost(Successeur,GPere):-
	nb_getval(openList,OpenList),
	isInOpenWithBestCost(Successeur,GPere,OpenList).
	
isInOpenWithBestCost(Successeur,GPere,[]):- fail.
	
isInOpenWithBestCost(Successeur,GPere,[Node|_]):-
	Node = [Successeur,G,_,_],
	GPlus is (GPere + 1),
	GPlus =< G,
	!.
	
isInOpenWithBestCost(Successeur,GPere,[_|AutreNode]):-
	isInCloseWithBestCost(Successeur,GPere,AutreNode).


	
/*
  isInCloseWithBestCost(+Successeur,+GPere)
*/
isInCloseWithBestCost(Successeur,GPere):-
	nb_getval(closeList,CloseList),
	isInCloseWithBestCost(Successeur,GPere,CloseList).
	
isInCloseWithBestCost(Successeur,GPere,[]):- fail.
	
isInCloseWithBestCost(Successeur,GPere,[Node|_]):-
	Node = [Successeur,G,_,_],
	GPlus is (GPere + 1),
	GPlus =< G,
	!.
	
isInCloseWithBestCost(Successeur,GPere,[_|AutreNode]):-
	isInCloseWithBestCost(Successeur,GPere,AutreNode).
	
% Element aux coordonnées données
elemAtCoord([[E|_]|_], 0, 0, E).
elemAtCoord([[_|R1]|R2], X, 0, E) :- X1 is X - 1, elemAtCoord([R1|R2], X1, 0, E). 
elemAtCoord([_|R2], X, Y, E) :- Y1 is Y - 1, elemAtCoord(R2, X, Y1, E).

% Prochaine position possible
possibleMove([X,Y], Laby) :- elemAtCoord(Laby, [X,Y], E), E =< 2.
possibleMove([X,Y], Laby) :- elemAtCoord(Laby, [X,Y], E), E = 21.

////////////////////////////////////////

Gérer destination pas encore explorée

BuildPath

Init openList

Finir a_star (commentaires)
