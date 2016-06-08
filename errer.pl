:- module( errer, [
	errer/4
] ).

:- use_module( seDirigerVers ).

test(Action) :- seDirigerVers:init_astar(_), errer(5, 1, [[5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5], [5, 0, 0, 0, 0, 22, 6, 0, 0, 0, 0, 5], [5, 6, 6, 6, 6, 0, 6, 0, 6, 0, 6, 5], [5, 0, 0, 0, 6, 0, 6, 0, 0, 0, 0, 5], [5, 6, 1, 6, 6, 0, 0, 0, 6, 0, 6, 5], [5, 0, 0, 0, 6, 6, 0, 6, 6, 0, 0, 5], [5, 0, 0, 0, 0, 0, 0, 6, 0, 0, 21, 5], [5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5]], Action).

% Se diriger vers un endroit inexploré
errer(X, Y, Laby, Action) :- premiereOccurence(Laby, -1, X1, Y1), seDirigerVers([X, Y], [X1, Y1], Laby, _, Action).
errer(X, Y, Laby, Action) :- coordLastElement(Laby, X1, Y1), endroitAtteignable(X, Y, Laby, X1, X1, Y1, Action).

% Trouve la première occurence d'un élément dans le labyrinthe
premiereOccurence([[Element|_]|_], Element, X, Y, X, Y).
premiereOccurence([[]|R], Element, _, Y0, X, Y) :- Y1 is Y0 + 1, X1 is 0, premiereOccurence(R, Element, X1, Y1, X, Y).
premiereOccurence([[_|R1]|R2], Element, X0, Y0, X, Y) :- X1 is X0 + 1, premiereOccurence([R1|R2], Element, X1, Y0, X, Y).
premiereOccurence(Laby, Element, X, Y) :- premiereOccurence(Laby, Element, 0, 0, X, Y).

% Trouve un endroit atteignable en partant du coin inférieur droit du labyrinthe
endroitAtteignable(X, Y, Laby, _, X0, Y0, Action) :- seDirigerVers([X, Y], [X0, Y0], Laby, _, Action), write(X0), write(' '), write(Y0).
endroitAtteignable(X, Y, Laby, XMax, X0, Y0, Action) :- X0 = 0, Y0 > 0, not(seDirigerVers([X, Y], [X0, Y0], Laby, _, _)), Y1 is Y0 - 1, endroitAtteignable(X, Y, Laby, XMax, XMax, Y1, Action).
endroitAtteignable(X, Y, Laby, XMax, X0, Y0, Action) :- X0 > 0, not(seDirigerVers([X, Y], [X0, Y0], Laby, _, _)), X1 is X0 - 1, endroitAtteignable(X, Y, Laby, XMax, X1, Y0, Action).

% Coordonnées du dernier élément
coordLastElement(Laby, X, Y) :- coordLastElement(Laby, 0, 0, X, Y).
coordLastElement([[_]], X, Y, X, Y).
coordLastElement([[]|R2], _, Y0, X, Y) :- Y1 is Y0 + 1, coordLastElement(R2, 0, Y1, X, Y).
coordLastElement([[_|R1]|R2], X0, Y0, X, Y) :- X1 is X0 + 1, coordLastElement([R1|R2], X1, Y0, X, Y).

% Element aux coordonnées données
elemAtCoord([[E|_]|_], 0, 0, E).
elemAtCoord([[_|R1]|R2], X, 0, E) :- X > 0, X1 is X - 1, elemAtCoord([R1|R2], X1, 0, E). 
elemAtCoord([_|R2], X, Y, E) :- Y > 0, Y1 is Y - 1, elemAtCoord(R2, X, Y1, E).