:- module( errer, [
	errer/4
] ).

:- use_module(seDirigerVers).
:- use_module(fonctions).

test(Action) :- seDirigerVers:init_astar(_), errer(5, 1, [[5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5], [5, 0, 0, 0, 0, 22, 6, 0, 0, 0, 0, 5], [5, 6, 6, 6, 6, 0, 6, 0, 6, 0, 6, 5], [5, 0, 0, 0, 6, 0, 6, 0, 0, 0, 0, 5], [5, 6, 1, 6, 6, 0, 0, 0, 6, 0, 6, 5], [5, 0, 0, 0, 6, 6, 0, 6, 6, 0, 0, 5], [5, 0, 0, 0, 0, 0, 0, 6, 0, 0, 21, 5], [5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5]], Action).

% Se diriger vers un endroit inexploré
errer(X, Y, Laby, Action) :- premiereOccurence(Laby, -1, X1, Y1), seDirigerVers([X, Y], [X1, Y1], Laby, _, Action).
errer(X, Y, Laby, Action) :- coordLastElement(Laby, X1, Y1), endroitAtteignable(X, Y, Laby, X1, X1, Y1, Action).

% Trouve un endroit atteignable en partant du coin inférieur droit du labyrinthe
endroitAtteignable(X, Y, Laby, _, X0, Y0, Action) :- seDirigerVers([X, Y], [X0, Y0], Laby, _, Action).
endroitAtteignable(X, Y, Laby, XMax, X0, Y0, Action) :- X0 = 0, Y0 > 0, not(seDirigerVers([X, Y], [X0, Y0], Laby, _, _)), Y1 is Y0 - 1, endroitAtteignable(X, Y, Laby, XMax, XMax, Y1, Action).
endroitAtteignable(X, Y, Laby, XMax, X0, Y0, Action) :- X0 > 0, not(seDirigerVers([X, Y], [X0, Y0], Laby, _, _)), X1 is X0 - 1, endroitAtteignable(X, Y, Laby, XMax, X1, Y0, Action).

