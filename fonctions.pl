:- module( fonctions, [
	meilleureOption/4,
	posToCoord/7,
	elemAtPos/3,
	elemAtCoord/4,
	posLastElement/2,
	coordLastElement/3,
	premiereOccurence/4
] ).

:- use_module(seDirigerVers).

% Meilleure option possible
meilleureOption([X, Y], Laby, Elem, [X1, Y1]) :- meilleureOption([X, Y], Laby, Laby, [0, 0], Elem, 200, [0, 0], [X1, Y1]).

meilleureOption(Coord, _, [[Elem]], Coord1, Elem, Min, _, Coord1) :- getHeuristicValue(Coord, Coord1, Cout), Cout =< Min.
meilleureOption(_, _, [[_]], _, _, _, [0, 0], _) :- fail.
meilleureOption(_, _, [[_]], _, _, _, Coord1, Coord1).
meilleureOption([X, Y], Laby, [[]|R2], [_, Y0], Elem, Min, [X1, Y1], [X2, Y2]) :- Y3 is Y0 + 1, meilleureOption([X, Y], Laby, R2, [0, Y3], Elem, Min, [X1, Y1], [X2, Y2]).
meilleureOption([X, Y], Laby, [[Elem|R1]|R2], [X0, Y0], Elem, Min, _, [X2, Y2]) :- getHeuristicValue([X, Y], [X0, Y0], Cout), Cout =< Min, X3 is X0 + 1, meilleureOption([X, Y], Laby, [R1|R2], [X3, Y0], Elem, Cout, [X0, Y0], [X2, Y2]).
meilleureOption([X, Y], Laby, [[_|R1]|R2], [X0, Y0], Elem, Min, [X1, Y1], [X2, Y2]) :- X3 is X0 + 1, meilleureOption([X, Y], Laby, [R1|R2], [X3, Y0], Elem, Min, [X1, Y1], [X2, Y2]).

% Transformer position dans la liste en coordonnées dans le labyrinthe
posToCoord(X, Y, Pos, Size, Pos1, X1, Y1) :- X1 is (X + (Pos1 mod Size) - (Pos mod Size)), Y1 is (Y + (Pos1 // Size) - (Pos // Size)).

% Element à la position donnée
elemAtPos([E|_], 0, E):- !.
elemAtPos([_|R], Pos, E) :- Pos1 is Pos - 1, elemAtPos(R, Pos1, E).

% Element aux coordonnées données
elemAtCoord([[E|_]|_], 0, 0, E).
elemAtCoord([[_|R1]|R2], X, 0, E) :- X > 0, X1 is X - 1, elemAtCoord([R1|R2], X1, 0, E). 
elemAtCoord([_|R2], X, Y, E) :- Y > 0, Y1 is Y - 1, elemAtCoord(R2, X, Y1, E).

% Position du dernier élément
posLastElement(L, Pos) :- posLastElement(L, 0, Pos).
posLastElement([_], Pos, Pos).
posLastElement([_|R], Pos0, Pos) :- Pos1 is Pos0 + 1, posLastElement(R, Pos1, Pos).

% Coordonnées du dernier élément
coordLastElement(Laby, X, Y) :- coordLastElement(Laby, 0, 0, X, Y).
coordLastElement([[_]], X, Y, X, Y).
coordLastElement([[]|R2], _, Y0, X, Y) :- Y1 is Y0 + 1, coordLastElement(R2, 0, Y1, X, Y).
coordLastElement([[_|R1]|R2], X0, Y0, X, Y) :- X1 is X0 + 1, coordLastElement([R1|R2], X1, Y0, X, Y).

% Trouve la première occurence d'un élément dans le labyrinthe
premiereOccurence([[Element|_]|_], Element, X, Y, X, Y).
premiereOccurence([[]|R], Element, _, Y0, X, Y) :- Y1 is Y0 + 1, X1 is 0, premiereOccurence(R, Element, X1, Y1, X, Y).
premiereOccurence([[_|R1]|R2], Element, X0, Y0, X, Y) :- X1 is X0 + 1, premiereOccurence([R1|R2], Element, X1, Y0, X, Y).
premiereOccurence(Laby, Element, X, Y) :- premiereOccurence(Laby, Element, 0, 0, X, Y).