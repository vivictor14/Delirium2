/*


  Définition de l'IA du mineur

  Le prédicat move/12 est consulté à chaque itération du jeu.


*/

%:- use_module( seDirigerVers ).
%:- use_module( errer ).

:- module( decision, [
	init/1,
	move/12
] ).


init(_).


/*
  move( +L,+LP, +X,+Y,+Pos, +Size, +CanGotoExit, +Energy,+GEnergy, +VPx,+VPy, -ActionId )
*/

% Mouvement aléatoire avec prédicat move/12
% move( _,_, _,_,_, _, _, _,_, _,_, Action ) :- Action is random( 5 ), write(Action),nl.
% move( Action ) :- Action is 1+random( 4 ), write(Action),nl.


% Mettre à jour le labyrinthe avant de choisir le mouvement
move(L, _, X, Y, Pos, Size, CGE, _, _, VPx, VPy, Action) :- nb_getval(labyrinthe, Laby), updateLaby(Laby, L, X, Y, Pos, Size, VPx, VPy), nb_getval(labyrinthe, Laby1), move(L, X, Y, Pos ,Size, CGE, Laby1, Action).

% Se diriger vers la sortie
move(L, X, Y, Pos, Size, 0, Laby, Action) :- member(20, L), premiereOccurence(Laby, 20, X1, Y1), seDirigerVers(L, X, Y, Pos, Size, X1, Y1, Action).

% Se diriger vers un diamant
move(L, X, Y, Pos, Size, CGE, Laby, Action) :- not(CGE = 0), member(2, L), meilleureOption(L, Size, Pos, 2, Pos1), posToCoord(X, Y, Pos, Size, Pos1, X1, Y1), seDirigerVers(L, X, Y, Pos, Size, X1, Y1, Action).

% Errer
move(L, X, Y, Pos, Size, _, Laby, Action) :- errer(L, X, Y, Pos, Size, Laby, Action).

% Meilleure option possible
meilleureOption(L, Size, Pos, Element, Pos1) :- allPosition(Element, L, Positions), seDirigerVers:couts(L, Pos, Size, Positions, Rangs), meilleureOp(Positions, Rangs, Pos1).

meilleureOp([X|Positions], [Y|Rangs], Pos1) :- meilleureOp(Positions, Rangs, X, Y, Pos1).
meilleureOp([], [], Pos, _, Pos).
meilleureOp([X|P], [Y|R], _, Min, Pos) :- Y < Min, !, meilleureOp(P, R, X, Y, Pos).
meilleureOp([_|P], [_|R], Pos0, Min, Pos) :- meilleureOp(P, R, Pos0, Min, Pos).

% Positions de toutes les occurences de l'élément
allPosition(_, [], _, []).
allPosition(Element, [X|R1], Pos, [Pos|Y]) :- Element = X, !, Pos1 is Pos + 1, allPosition(Element,R1,Pos1,Y).
allPosition(Element, [_|R], Pos, Index) :- Pos1 is Pos + 1, allPosition(Element, R, Pos1, Index).
allPosition(Element, L, Index) :- allPosition(Element, L, 0, Index).

% Mise à jour du labyrinthe
updateLaby().

% Transformer position dans la liste en coordonnées dans le labyrinthe
posToCoord(X, Y, Pos, Size, Pos1, X1, Y1) :- X1 is (X + (Pos1 mod Size) - (Pos mod Size)), Y1 is (Y + (Pos1 // Size) - (Pos // Size)).

