:- module( errer, [
	errer/4
] ).

:- use_module(seDirigerVers).
:- use_module(fonctions).

test(Action) :- seDirigerVers:init_astar(_), errer(5, 1, [[5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5], [5, 0, 0, 0, 0, 22, 6, 0, 0, 0, 0, 5], [5, 6, 6, 6, 6, 0, 6, 0, 6, 0, 6, 5], [5, 0, 0, 0, 6, 0, 6, 0, 0, 0, 0, 5], [5, 6, 1, 6, 6, 0, 0, 0, 6, 0, 6, 5], [5, 0, 0, 0, 6, 6, 0, 6, 6, 0, 0, 5], [5, 0, 0, 0, 0, 0, 0, 6, 0, 0, 21, 5], [5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5]], Action).

% Se diriger vers un endroit inexploré
errer(X, Y, Laby, Action) :- meilleureOption([X, Y], Laby, -1, Coord), seDirigerVers([X, Y], Coord, Laby, _, Action).
errer(X, Y, Laby, Action) :- endroitAtteignable(X, Y, Laby, Action).

% Trouve un endroit atteignable en partant du coin inférieur droit du labyrinthe
endroitAtteignable(X, Y, Laby, Action) :- X0 is X + 5, Y0 is Y + 5, endroitAtteignable(X, Y, Laby, X0, Y0, 20, Action).

endroitAtteignable(X, Y, Laby, X0, Y0, _, Action) :- elemAtCoord(Laby, X0, Y0, E), destinationPossible(E), seDirigerVers([X, Y], [X0, Y0], Laby, _, Action).
endroitAtteignable(X, Y, Laby, X0, Y0, DistMax, Action) :- X1 is X0 + 1, X1 < (X + DistMax), endroitAtteignable(X, Y, Laby, X1, Y0, DistMax, Action).
endroitAtteignable(X, Y, Laby, _, Y0, DistMax, Action) :- Y1 is Y0 + 1, Y1 < (Y + DistMax), X1 is X + 5, endroitAtteignable(X, Y, Laby, X1, Y1, DistMax, Action).


destinationPossible(E) :- E < 3.