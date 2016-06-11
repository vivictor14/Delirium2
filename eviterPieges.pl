:- module( eviterPieges, [
	eviterPieges/6,
	init_GlobaleMonster/1
] ).

:- use_module(fonctions).

init_GlobaleMonster(_):- nb_setval(posMonstre,[]).
  
% Ajoute les zones dangereuses à la liste
eviterPieges(L, X, Y, Pos, Size, L2) :- eviterPieges(L, L, 0, Size, L1), eviterMonstres(L1, X, Y, Pos, Size, L2).

eviterPieges(_, [], _, _, []).
eviterPieges(L, [0|R1], Pos, Size, [4|R2]) :- Pos1 is Pos - Size, elemAtPos(L, Pos1, 3), Pos2 is Pos + 1, eviterPieges(L, R1, Pos2, Size, R2).
eviterPieges(L, [0|R1], Pos, Size, [4|R2]) :- Pos1 is Pos - Size, elemAtPos(L, Pos1, 0), Pos2 is Pos1 - Size, elemAtPos(L, Pos2, 3), Pos3 is Pos + 1, eviterPieges(L, R1, Pos3, Size, R2). 
eviterPieges(L, [0|R1], Pos, Size, [4|R2]) :- Pos1 is Pos - Size, elemAtPos(L, Pos1, 2), Pos2 is Pos + 1, eviterPieges(L, R1, Pos2, Size, R2).
eviterPieges(L, [0|R1], Pos, Size, [4|R2]) :- Pos1 is Pos - Size, elemAtPos(L, Pos1, 0), Pos2 is Pos1 - Size, elemAtPos(L, Pos2, 2), Pos3 is Pos + 1, eviterPieges(L, R1, Pos3, Size, R2). 
eviterPieges(L, [E|R1], Pos, Size, [E|R2]) :- Pos1 is Pos + 1, eviterPieges(L, R1, Pos1, Size, R2).
  
/*
  eviterMonstres(+Map,+X,+Y,+PosMineur, +Size,-NewMap)
  Méthode permettant de récupérer une nouvelleListe contenant les monstres à l'état t+1
*/
eviterMonstres(Map,X,Y,PosMineur, Size,NewMap):-
  recupPosMonstre(Map,0,PosMonstres),
  coordonneeMonstre(PosMonstres,X,Y,PosMineur,Size,CoordMonstres),
  lancerRecupDirection(CoordMonstres,PosMonstres,ListeD),
  nouvellePosition(Map,Size,ListeD,ListeP),
  modifCarte(Map,ListeP,NewMap).
  
/*
  lancerRecupDirection(+CoordMonstres,+PosMonstres,-ListeDirectionPrecedent)
  Méthode permettant de récupérer une liste contenant la direction précédente ainsi que la position du monstre lié à cette direction
*/
lancerRecupDirection(CoordMonstres,PosMonstres,ListeDirectionPrecedent):-
  nb_getval(posMonstre,ListeCoordMonstre),
  verifMonstre(CoordMonstres,PosMonstres,ListeDirectionPrecedent,ListeCoordMonstre,[]).
  
/*
  coordonneeMonstre(+PosMonstres,+X,+Y,+PosMineur,+Size,-CoordMonstres)
  Méthode permettant de récupérer les coordonnée X,Y du monstre
*/

coordonneeMonstre([],_,_,_,_,[]).
coordonneeMonstre([Pos1|Reste],X,Y,Pos,Size,ListeCord):-
	posToCoord(X, Y, Pos, Size, Pos1, X1, Y1),
	!,
	append([[X1,Y1]],NewList,ListeCord),
	coordonneeMonstre(Reste,X,Y,Pos,Size,NewList).
/*
  nouvellePosition(+Map,+Size,+ListeD,-ListeP)
  Méthode permettant de récupérer la position du monstre à l'état t+1
*/

nouvellePosition(_,_,[],[]).
nouvellePosition(Map,Size,[Val|Reste],Liste):-
	Val = [5,Pos],
	Pos1 is Pos+1,
	ajouteCroix(Pos1,Pos,Size,Pos2),
	Pos3 is Pos+Size,
	Pos4 is Pos-1,
	ajouteCroix(Pos4,Pos,Size,Pos5),
	Pos6 is Pos-Size,
	Pos7 is Pos2+Size,
	Pos8 is Pos2-Size,
	Pos9 is Pos5+Size,
	Pos10 is Pos5-Size,
	append([[Pos,Pos2],[Pos,Pos3],[Pos,Pos5],[Pos,Pos6],[Pos,Pos7],[Pos,Pos8],[Pos,Pos9],[Pos,Pos10]],NewListe,Liste),
	!,
	nouvellePosition(Map,Size,Reste,NewListe).
nouvellePosition(Map,Size,[Val|Reste],Liste):-
	Val = [D,Pos],
	moveMonster(Map, Pos, Size, D, Pos1, Pos2, Pos3, Pos4),
	append([[Pos,Pos1],[Pos,Pos2],[Pos,Pos3],[Pos,Pos4]],NewListe,Liste),
	!,
	nouvellePosition(Map,Size,Reste,NewListe).

nouvellePosition(Map,Size,[_|Reste],Liste):-
	nouvellePosition(Map,Size,Reste,Liste).

/*
 ajouteCroix(PosEtat1,PosInitiale,Size,NewPos)
 Vérifie que la position droite et gauche sont possible (si le monstre est tout à droite du labyrinthe il ne peut pas
 avoir une position = position +1).
 
*/
ajouteCroix(Pos,_,Size,Pos1):-
	Pos > -1,
	Mod is mod(Pos,Size),
	Mod \=0,
	Pos1 = Pos.
ajouteCroix(_,PosInitiale,_,PosInitiale).

/*
  recupPosMonstre(+Map,+Pos,-PosMonstres)
  Renvoie la position du monstre
*/
recupPosMonstre([],_,[]).
recupPosMonstre([X|R],Nb,[Nb|R2]):-
	X > 23,
	Nb1 is Nb+1,
	!,
	recupPosMonstre(R,Nb1,R2).
recupPosMonstre([_|R],Nb,PosMonstres):-
	Nb1 is Nb+1,
	recupPosMonstre(R,Nb1,PosMonstres).
/*
  verifMonstre(+CoordMonstre,+PosMonstre,-ListeD,-ListCoordMonstre)
  Méthode permettant de parcourir toute les positions des monstres et de récupérer leur direction ainsi que set
  la variable globale posMonstre au position courante.
*/
  
verifMonstre([],[],[],_,PosMonstre):-
  flushPosMonstre(PosMonstre,NewPosMonstre),
  nb_setval(posMonstre,NewPosMonstre).
verifMonstre([Monstre|AutresMonstre],[PosMonstre|Reste],ListeD,ListCoordMonstre,NewListe):-
  addPosition(ListCoordMonstre,Monstre,PosMonstre,NewCoord,Direction),
  append([Direction],NewListeD,ListeD),
  !,
  append([NewCoord],NewListe,NewListCoordMonstre),
  verifMonstre(AutresMonstre,Reste,NewListeD,ListCoordMonstre,NewListCoordMonstre).
verifMonstre([_|AutresMonstre],[_|Reste],ListeD,ListCoordMonstre,NewListe):-
  verifMonstre(AutresMonstre,Reste,ListeD,ListCoordMonstre,NewListe).

replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]):- 
	I > -1, NI is I-1, replace(T, NI, X, R), !.
  
/*
  modifCarte(+Map,+ListeD,-NewMap)
  Remplace les positions courante par une case vide et celle au temps t+1 par un monstre.
*/
modifCarte(N,[],N):-!.
modifCarte(Map,[X|Reste],NewMap):-
	X = [XAvant,XApres],
	replace(Map,XApres,24,MapSuivante),
	!,
	modifCarte(MapSuivante,Reste,NewMap).
modifCarte(Map,[_|Reste],NewMap):-
	modifCarte(Map,Reste,NewMap).


/*
  flushPosMonstre(+PosMonstre,-NewPosMonstre)
  Méthode permettant de récupérer les coordonnées des monstres au temps t (permet la maj de la variable globale posMonstre).
*/

flushPosMonstre([],[]).
flushPosMonstre([Monstre|AutresMonstre],PosMonstre):-
    Monstre = [_,Pos2],
    append([Pos2],NewPosMonstre,PosMonstre),
    !,
    flushPosMonstre(AutresMonstre,NewPosMonstre).
  flushPosMonstre([_|AutresMonstre],PosMonstre):-
    flushPosMonstre(AutresMonstre,PosMonstre).
  
/*
  addPosition(+CoordMonstres,+CoordMonstreCourant,+Pos,-NewPos,-D)
  Donne la direction du monstre en fonction des coordonnée de la variable globale et des coordonnées du monstre courant.
  Il donne aussi une liste contenant la position précédente et courante.
*/

% droite = 1 , haut = 2, gauche = 3, bas = 4
addPosition([],[],_,[],[]).
addPosition([],X,_,NewPos,[]):-
  append([X,X],[],NewPos).
addPosition(CoordMonstres,X,Pos,NewPos,D):-
  member(X,CoordMonstres),
  D = [5,Pos],
  !,
  append([X,X],[],NewPos).
addPosition([PosAvant|_],Coord,Pos,NewPos,D):-
  PosAvant = [XA,YA],
  Coord = [X,Y],
  X1 is X+1,
  YA = Y,
  XA = X1,
  D = [3,Pos],
  !,
  append([PosAvant,[X,Y]],[],NewPos).
  
addPosition([PosAvant|_],Coord,Pos,NewPos,D):-
  PosAvant = [XA,YA],
  Coord = [X,Y],
  X1 is X-1,
  YA = Y,
  XA = X1,
  D = [1,Pos],
  !,
  append([PosAvant,Coord],[],NewPos).
  
addPosition([PosAvant|_],Coord,Pos,NewPos,D):-
  Coord = [X,Y],
  PosAvant = [XA,YA],
  Y1 is Y+1,
  YA = Y1,
  XA = X,
  D = [2,Pos],
  !,
  append([PosAvant,Coord],[],NewPos).

addPosition([PosAvant|_],Coord,Pos,NewPos,D):-
  Coord = [X,Y],
  PosAvant = [XA,YA],
  Y1 is Y-1,
  YA = Y1,
  XA = X,
  D = [4,Pos],
  !,
  append([PosAvant,Coord],[],NewPos).
  
addPosition([_|Reste],Coord,Pos,NewPos,D):-
  addPosition(Reste,Coord,Pos,NewPos,D).


% Prochaine position possible pour monstre
possibleMoveMonster(L, Pos) :- 
	elemAtPos(L, Pos, E),
	E = 0.

/*
  moveMonster(+L, +Pos, +Size, +D, -Pos1)
  donne la position au temps t+1 en fonction de la direction du monstre
*/

% f(d)
% Vers la gauche
moveMonster(L, Pos, Size, D, Pos1, Pos2, Pos4, Pos5) :- 
	D = 2, 
	Pos1 is Pos - 1, 
	Pos1 > -1, 
	Mod is mod(Pos1,Size),
	Mod \=0, 
	possibleMoveMonster(L, Pos1),
	!,
	Pos2 is Pos1+Size,
	Pos3 is Pos1-1,
	ajouteCroix(Pos3,Pos1,Size,Pos4),
	Pos5 is Pos1-Size.
% Vers le bas
moveMonster(L, Pos, Size, D, Pos1, Pos2, Pos4, Pos6) :- 
	D = 3,
	Pos1 is Pos + Size,
	possibleMoveMonster(L, Pos1),
	!,
	Pos2 is Pos1+Size,
	Pos3 is Pos1-1,
	ajouteCroix(Pos3,Pos1,Size,Pos4),
	Pos5 is Pos1+1,
	ajouteCroix(Pos5,Pos1,Size,Pos6).
% Vers la droite
moveMonster(L, Pos, Size, D, Pos1, Pos2, Pos4, Pos5) :-
	D = 4, 
	Pos1 is Pos + 1, 
	Mod is mod(Pos1,Size), 
	Mod \=0, 
	possibleMoveMonster(L, Pos1),
	!,
	Pos2 is Pos1+Size,
	Pos3 is Pos1+1,
	ajouteCroix(Pos3,Pos1,Size,Pos4),
	Pos5 is Pos1-Size.
% Vers le haut
moveMonster(L, Pos, Size, D, Pos1, Pos3, Pos5, Pos6) :- 
	D = 1, 
	Pos1 is Pos - Size, 
	possibleMoveMonster(L, Pos1),
	!,
	Pos2 is Pos1-1,
	ajouteCroix(Pos2,Pos1,Size,Pos3),
	Pos4 is Pos1+1,
	ajouteCroix(Pos4,Pos1,Size,Pos5),
	Pos6 is Pos1-Size.
% d
% Vers le haut
moveMonster(L, Pos, Size, D, Pos1, Pos3, Pos5, Pos6) :- 
	D = 2, 
	Pos1 is Pos - Size, 
	possibleMoveMonster(L, Pos1),
	!,
	Pos2 is Pos1-1,
	ajouteCroix(Pos2,Pos1,Size,Pos3),
	Pos4 is Pos1+1,
	ajouteCroix(Pos4,Pos1,Size,Pos5),
	Pos6 is Pos1-Size.
% Vers la gauche
moveMonster(L, Pos, Size, D, Pos1, Pos2, Pos4, Pos5) :- 
	D = 3, 
	Pos1 is Pos - 1, 
	Pos1 > -1, 
	Mod is mod(Pos1,Size), 
	Mod \=0, 
	possibleMoveMonster(L, Pos1),
	!,
	Pos2 is Pos1+Size,
	Pos3 is Pos1-1,
	ajouteCroix(Pos3,Pos1,Size,Pos4),
	Pos5 is Pos1-Size.
% Vers le bas
moveMonster(L, Pos, Size, D, Pos1, Pos2, Pos4, Pos6) :- 
	D = 4, 
	Pos1 is Pos + Size, 
	possibleMoveMonster(L, Pos1),
	!,
	Pos2 is Pos1+Size,
	Pos3 is Pos1-1,
	ajouteCroix(Pos3,Pos1,Size,Pos4),
	Pos5 is Pos1+1,
	ajouteCroix(Pos5,Pos1,Size,Pos6).
% Vers la droite
moveMonster(L, Pos, Size, D, Pos1, Pos2, Pos4, Pos5) :- 
	D = 1, 
	Pos1 is Pos + 1, 
	Mod is mod(Pos1,Size), 
	Mod \=0, 
	possibleMoveMonster(L, Pos1),
	!,
	Pos2 is Pos1+Size,
	Pos3 is Pos1+1,
	ajouteCroix(Pos3,Pos1,Size,Pos4),
	Pos5 is Pos1-Size.
% f(f(d))
% Vers le bas
moveMonster(L, Pos, Size, D, Pos1, Pos2, Pos4, Pos6) :-
	D = 2,
	Pos1 is Pos + Size, 
	possibleMoveMonster(L, Pos1),
	!,
	Pos2 is Pos1+Size,
	Pos3 is Pos1-1,
	ajouteCroix(Pos3,Pos1,Size,Pos4),
	Pos5 is Pos1+1,
	ajouteCroix(Pos5,Pos1,Size,Pos6).
% Vers la droite
moveMonster(L, Pos, Size, D, Pos1, Pos2, Pos4, Pos5) :-
	D = 3, 
	Pos1 is Pos + 1, 
	Mod is mod(Pos1,Size), 
	Mod \=0, 
	possibleMoveMonster(L, Pos1),
	!,
	Pos2 is Pos1+Size,
	Pos3 is Pos1+1,
	ajouteCroix(Pos3,Pos1,Size,Pos4),
	Pos5 is Pos1-Size.
% Vers le haut
moveMonster(L, Pos, Size, D, Pos1, Pos3, Pos5, Pos6) :- 
	D = 4, 
	Pos1 is Pos - Size, 
	possibleMoveMonster(L, Pos1),
	!,
	Pos2 is Pos1-1,
	ajouteCroix(Pos2,Pos1,Size,Pos3),
	Pos4 is Pos1+1,
	ajouteCroix(Pos4,Pos1,Size,Pos5),
	Pos6 is Pos1-Size.
% Vers la gauche
moveMonster(L, Pos, Size, D, Pos1, Pos2, Pos4, Pos5) :- 
	D = 1, 
	Pos1 is Pos - 1, 
	Pos1 > -1,
	Mod is mod(Pos1,Size), 
	Mod \=0, 
	possibleMoveMonster(L, Pos1),
	!,
	Pos2 is Pos1+Size,
	Pos3 is Pos1-1,
	ajouteCroix(Pos3,Pos1,Size,Pos4),
	Pos5 is Pos1-Size.
% f(f(f(d)))
% Vers la droite
moveMonster(L, Pos, Size, D, Pos1, Pos2, Pos4, Pos5) :- 
	D = 2,
	Pos1 is Pos + 1, 
	Mod is mod(Pos1,Size), 
	Mod \=0, 
	possibleMoveMonster(L, Pos1),
	!,
	Pos2 is Pos1+Size,
	Pos3 is Pos1+1,
	ajouteCroix(Pos3,Pos1,Size,Pos4),
	Pos5 is Pos1-Size.
% Vers le haut
moveMonster(L, Pos, Size, D, Pos1, Pos3, Pos5, Pos6) :- 
	D = 3, 
	Pos1 is Pos - Size, 
	possibleMoveMonster(L, Pos1),
	!,
	Pos2 is Pos1-1,
	ajouteCroix(Pos2,Pos1,Size,Pos3),
	Pos4 is Pos1+1,
	ajouteCroix(Pos4,Pos1,Size,Pos5),
	Pos6 is Pos1-Size.
% Vers la gauche
moveMonster(L, Pos, Size, D, Pos1, Pos2, Pos4, Pos5) :- 
	D = 4, 
	Pos1 is Pos - 1, 
	Pos1 > -1, 
	Mod is mod(Pos1,Size), 
	Mod \=0, 
	possibleMoveMonster(L, Pos1),
	!,
	Pos2 is Pos1+Size,
	Pos3 is Pos1-1,
	ajouteCroix(Pos3,Pos1,Size,Pos4),
	Pos5 is Pos1-Size.
% Vers le bas
moveMonster(L, Pos, Size, D, Pos1, Pos2, Pos4, Pos6) :- 
	D = 1, 
	Pos1 is Pos + Size,
	possibleMoveMonster(L, Pos1),
	!,
	Pos2 is Pos1+Size,
	Pos3 is Pos1-1,
	ajouteCroix(Pos3,Pos1,Size,Pos4),
	Pos5 is Pos1+1,
	ajouteCroix(Pos5,Pos1,Size,Pos6).
