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
a_star([],_,_):-
	nb_getval(openList, []),
	!.
	
% etat final atteint
a_star([X,Y],[X,Y],_):-
	nb_getval(openList, [[_, [X,Y])


a_star([X,Y],[XFinal,YFinal],Path):- 

/* 
  getBestNodeFromOpenList(-Node) 
*/
getBestNodeFromOpenList(_).

/* 
  extractBestNodeFromOpenList(-Node) 
*/
extractBestNodeFromOpenList(_).

/* 
  buildPath(+State, -Path) 
*/
buildPath(_,_).

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
