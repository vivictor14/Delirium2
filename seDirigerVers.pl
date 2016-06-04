:- module( seDirigerVers, [
	init/1,
	seDirigerVers/5
] ).

% Init variables globales
init(_):- nb_setval(openList,[]), nb_setval(closedList,[]).

% Predicats A*
/* 
  a_star(+CourantState, +FinalState, -Path) 
*/
% openList vide pas de solution
a_star(_,_,_,[],_,_):-
	nb_getval(openList, []),
	!.
	
% etat final atteint
a_star(_,_,_,[X,Y],[X,Y],_):-
	nb_getval(openList, [[_], [X,Y]])


a_star(Liste,PosMineur,Size,[X,Y],[XFinal,YFinal],Path):-

	nb_getval(openList, [[Chemin,G,Cout,Pere]|CheminRestant]),
	nb_getval(closedList, ClosedList),
	
	Chemin = [X,Y],
	nb_setval(openList,CheminRestant),
	append(closedList,[Chemin],closedListFinal),
	nb_setval(closedList,closedListFinal),
	trouverSuccesseur(PosMineur,Chemin,Size,Liste,Successeur),
	ajouterChemin(Chemin,Successeur,[XFinal,YFinal],Cout,G),
	nb_getval(openList, [[Chemin,_,_,_]|_]),
	a_star(Liste,[X,Y],Chemin,[XFinal,YFinal],Path).
	
	
ajouterChemin(_,[],_,_,_).	
% test si il n'est pas dans closed et open
ajouterChemin(Chemin,[Successeur|Reste],Fin,Cout,G):-
	nb_getval(openList, openList),
	nb_getval(closedList, ClosedList),
	nonOpen(Successeur,openList),
	not(member(Successeur,closeList)),
	getHeuristicValue(Successeur,Fin,Y),
	F is G + 1 + Y,
	NouvelleDonnee is [Successeur,Y,F,Chemin],
	% ajout trié !
	
% test si g(y) > g(N.e)+c(N.e,y)
ajouterChemin(Chemin,[Successeur|Reste],Fin,Cout,G):-

% aucun des deux critères n'est possible, ont passe au successeur suivant
ajouterChemin(Chemin,[_|Reste],Fin,Cout,G):-
	ajouterChemin(Chemin,Reste,Fin,Cout,G).

nonOpen(_,[]).
nonOpen(Successeur,[[Chemin,_,_,_]|CheminRestant]):-
	Successeur \= Chemin,
	nonOpen(Successeur,CheminRestant).
	
	

/* 
  getBestNodeFromOpenList(-Node) 
*/
getBestNodeFromOpenList(_).

% trouver les successeur 
trouverSuccesseur(PosMineur,Chemin,Size,Liste,Successeur):-
	movementD(PosMineur,Liste,Chemin,X1),
	movementH(PosMineur,Liste,Size,Chemin,X2),
	movementG(PosMineur,Liste,Size,Chemin,X3),
	movementB(PosMineur,Liste,Chemin,X4),
	append(X1,X2,Successeur),
	append(X3,Successeur,Successeur),
	append(X4,Successeur,Successeur).

movementD(PosMineur,List,Chemin,X):-
	Chemin = [XChemin,YChemin],
	Pos is PosMineur +1,
	possibleMove(List,Pos),
	XNew is XChemin+1,
	X is [XNew,Y].
movementD(PosMineur,List,Chemin,X):-
	X is [].
	
movementH(PosMineur,List,Size,Chemin,X):-
	Chemin = [XChemin,YChemin],
	Pos is PosMineur - Size,
	possibleMove(List,Pos),
	YNew is YNew+1,
	X is [X,YNew].
movementH(PosMineur,List,Chemin,X):-
	X is [].
	
movementB(PosMineur,List,Chemin,X):-
	Chemin = [XChemin,YChemin],
	Pos is PosMineur + Size,
	possibleMove(List,Pos),
	YNew is YNew-1,
	X is [X,YNew].
movementB(PosMineur,List,Size,Chemin,X):-
	X is [].
	
movementG(PosMineur,List,Chemin,X):-
	Chemin = [XChemin,YChemin],
	Pos is PosMineur -1,
	possibleMove(List,Pos),
	XNew is XChemin-1,
	X is [XNew,Y].
movementG(PosMineur,List,Chemin,X):-
	X is [].
	
/* 
  extractBestNodeFromOpenList(-Node) 
*/
extractBestNodeFromOpenList(_).

/* 
  buildPath(+Fils,+Pere,+PathPrecedent,-NewPath) 
*/
buildPath(Fils,_,Path,NPath):-
	Path = [],
	NPath is [Fils].
buildPath(Fils,Pere,Path,NPath):-
	Path = [[X,Y]|Reste],
	Pere = [X,Y],
	append(Fils,Path,NPath).
buildPath(Fils,Pere,Path,NPath):-
	Path = [[X,Y]|Reste],
	Pere \= [X,Y],
	buildPath(Fils,Pere,Reste,NPath).


/* 
  insertAllStatesInOpenList(+Node, +FinalState, +AccessibleStatesList) 
*/
insertAllStatesInOpenList(_,_,_).

% Predicats A* spécifique problème
/* 
  getHeuristicValue(+XATester,+YATester,+XFinal,+YFinal,-V)
*/
getHeuristicValue([XATester,YATester],[XFinal,YFinal],V):- V is sqrt((XFinal-XATester)*(XFinal-XATester)+(YATester-YFinal)*(YATester-YFinal)).

/*
  getAllAccessibleStates(+State, -AccessibleStatesList)
*/
getAllAccessibleStates(_,_).


% Type de l'élément à la position indiquée
elementAtPosIs([X|_], 0, X).
elementAtPosIs([X|R], Pos, Element) :- Pos1 is Pos - 1, elementAtPosIs(R, Pos1, Element).

% Prochaine position possible
possibleMove(L, Pos) :- elementAtPosIs(L, Pos, X), X < 3.
possibleMove(L, Pos) :- elementAtPosIs(L, Pos, X), X = 20.

% Se rapproche de la position voulue
seRapproche(Pos, Pos1, Pos2) :- X is abs(Pos2 - Pos), Y is abs(Pos2 - Pos1), X > Y.

% Position la plus proche
positionLaPlusProche(L, Size, Pos, Element, Pos1) :- allPosition(Element, L, Positions), positionLPP(Pos, Size, Positions, Pos1).
positionLPP(Pos, Size, Positions, Pos1) :- positionLPP(Pos, Size, Positions, Size, Pos1).
positionLPP(_, _, [], _, _).
positionLPP(Pos, Size, [X|R], PosInit, PosPP) :- abs(Pos - (X mod Size)) <= PosInit, PosInit is X, PosPP is X, positionLPP(Pos, Size, R, PosInit, PosPP).
positionLPP(Pos, Size, [X|R], PosInit, PosPP) :- positionLPP(Pos, Size, R, PosInit, PosPP).
