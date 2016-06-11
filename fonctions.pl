:- module( fonctions, [
	meilleureOption/5,
	posToCoord/7,
	actionToCoord/5,
	elemAtPos/3,
	elemAtCoord/4,
	posLastElement/2,
	coordLastElement/3,
	premiereOccurence/4
] ).

:- use_module(seDirigerVers).

% Trouver la meilleure option possible
/*
  meilleureOption( +Laby, +X, +Y, +Elem, -Action )
*/
meilleureOption(Laby, X, Y, Elem, Action) :- triOptions(Laby, X, Y, Elem, List), !, meilleureOption(Laby, [X, Y], List, Action).
/*
  meilleureOption( +Laby, +Coord, +CoordList, -Action )
*/
meilleureOption(Laby, Coord, [Coord1|_], Action) :- seDirigerVers(Coord, Coord1, Laby, Action).
meilleureOption(Laby, Coord, [_|R], Action) :- meilleureOption(Laby, Coord, R, Action).

% Trier les options par coût croissant
/*
  triOptions( +Laby, +X, +Y, +Elem, -List )
*/
triOptions(Laby, X, Y, Elem, List) :- occurencesElement(Laby, 0, 0, Elem, List1), triOptions([X, Y], List1, List).
/*
  triOptions( +Coord, +L, -List )
*/
triOptions(_, [], []) :- !.
triOptions(Coord, L, [E|R]) :- moindreCout(Coord, L, 500, [-1, -1], E), retirerElement(E, L, L1), triOptions(Coord, L1, R).

% Retirer un élément de la liste
/*
  retirerElement( +E, +L1, -L2 )
*/
retirerElement(_, [], []) :- !.
retirerElement(E, [E|R], L) :- retirerElement(E, R, L).
retirerElement(E, [X|R1], [X|R2]) :- retirerElement(E, R1, R2).

% Trouver l'élément ayant le plus faible coût de la liste
/*
  moindreCout( +Coord, +L, +Min, +Coord1, -Coord2 )
*/
moindreCout(_, [], _, Coord1, Coord1) :- not(Coord1 = [-1, -1]), !.
moindreCout(Coord, [Coord1|R], Min, _, Coord2) :- getHeuristicValue(Coord, Coord1, Cout), Cout =< Min, moindreCout(Coord, R, Cout, Coord1, Coord2).
moindreCout(Coord, [_|R], Min, Coord1, Coord2) :- moindreCout(Coord, R, Min, Coord1, Coord2).

% Trouver toutes les occurences de l'élément dans le labyrinthe
/*
  occurencesElement( +Laby, +X, +Y, +Element, -List )
*/
occurencesElement([[E]], X, Y, E, [[X,Y]]) :- !.
occurencesElement([[_]], _, _, _, []) :- !.
occurencesElement([[]|R2], _, Y, E, L) :- Y1 is Y + 1, occurencesElement(R2, 0, Y1, E, L).
occurencesElement([[E|R1]|R2], X, Y, E, [[X, Y]|R3]) :- X1 is X + 1, occurencesElement([R1|R2], X1, Y, E, R3).
occurencesElement([[_|R1]|R2], X, Y, E, L) :- X1 is X + 1, occurencesElement([R1|R2], X1, Y, E, L).

% Transformer position dans la liste en coordonnées dans le labyrinthe
/*
  posToCoord( +X, +Y, +Pos, +Size, +Pos1, -X1, -Y1)
*/
posToCoord(X, Y, Pos, Size, Pos1, X1, Y1) :- X1 is (X + (Pos1 mod Size) - (Pos mod Size)), Y1 is (Y + (Pos1 // Size) - (Pos // Size)).

% Transformer une action en coordonnées d'arrivée
/*
  actionToCoord( +X, +Y, +Action, -X1, -Y1 )
*/
actionToCoord(X, Y, 1, X1, Y) :- X1 is X + 1.
actionToCoord(X, Y, 2, X, Y1) :- Y1 is Y - 1.
actionToCoord(X, Y, 3, X1, Y) :- X1 is X - 1.
actionToCoord(X, Y, 4, X, Y1) :- Y1 is Y + 1.

% Element à la position donnée
/*
  elemAtPos( +L, +Pos, -Element )
*/
elemAtPos([E|_], 0, E) :- !.
elemAtPos([_|R], Pos, E) :- Pos1 is Pos - 1, elemAtPos(R, Pos1, E).

% Element aux coordonnées données
/*
  elemAtCoord( +Laby, +X, +Y, -Element )
*/
elemAtCoord([[E|_]|_], 0, 0, E) :- !.
elemAtCoord([[_|R1]|R2], X, 0, E) :- X > 0, X1 is X - 1, elemAtCoord([R1|R2], X1, 0, E). 
elemAtCoord([_|R2], X, Y, E) :- Y > 0, Y1 is Y - 1, elemAtCoord(R2, X, Y1, E).

% Position du dernier élément
/*
  posLastElement( +L, -Pos )
*/
posLastElement(L, Pos) :- posLastElement(L, 0, Pos), !.
/*
  posLastElement( +L, +Pos0, -Pos )
*/
posLastElement([_], Pos, Pos).
posLastElement([_|R], Pos0, Pos) :- Pos1 is Pos0 + 1, posLastElement(R, Pos1, Pos).

% Coordonnées du dernier élément
/*
  coordLastElement( +Laby, -X, -Y )
*/
coordLastElement(Laby, X, Y) :- coordLastElement(Laby, 0, 0, X, Y), !.
/* 
  coordLastElement( +Laby, +X0, +Y0, -X, -Y )
*/
coordLastElement([[_]], X, Y, X, Y).
coordLastElement([[]|R2], _, Y0, X, Y) :- Y1 is Y0 + 1, coordLastElement(R2, 0, Y1, X, Y).
coordLastElement([[_|R1]|R2], X0, Y0, X, Y) :- X1 is X0 + 1, coordLastElement([R1|R2], X1, Y0, X, Y).

% Trouver la première occurence d'un élément dans le labyrinthe
/*
  premiereOccurence( +Laby, +Element, -X, -Y )
*/
premiereOccurence(Laby, Element, X, Y) :- premiereOccurence(Laby, Element, 0, 0, X, Y).
/*
  premiereOccurence( +Laby, +Element, +X0, +Y0, -X, -Y )
*/
premiereOccurence([[Element|_]|_], Element, X, Y, X, Y) :- !.
premiereOccurence([[]|R], Element, _, Y0, X, Y) :- Y1 is Y0 + 1, X1 is 0, premiereOccurence(R, Element, X1, Y1, X, Y).
premiereOccurence([[_|R1]|R2], Element, X0, Y0, X, Y) :- X1 is X0 + 1, premiereOccurence([R1|R2], Element, X1, Y0, X, Y).
