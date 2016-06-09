:- module( eviterPieges, [
	eviterPieges/3,
	init_GlobaleMonster/1
] ).

:- use_module(fonctions).

init_GlobaleMonster(_):- nb_setval(posMonstre,[]).
  
% Ajoute les zones dangereuses à la liste
eviterPieges(L, Size, L2) :- eviterPieges(L, L, 0, Size, L1), eviterMonstres(L1, Size, L2).

eviterPieges(_, [], _, _, []).
eviterPieges(L, [0|R1], Pos, Size, [4|R2]) :- Pos1 is Pos - Size, elemAtPos(L, Pos1, 3), Pos2 is Pos + 1, eviterPieges(L, R1, Pos2, Size, R2).
eviterPieges(L, [0|R1], Pos, Size, [4|R2]) :- Pos1 is Pos - 1, elemAtPos(L, Pos1, 3), elemAtPos(L, Pos + Size - 1, 2), Pos2 is Pos + 1, eviterPieges(L, R1, Pos2, Size, R2).
eviterPieges(L, [0|R1], Pos, Size, [4|R2]) :- Pos1 is Pos - 1, elemAtPos(L, Pos1, 3), Pos2 is Pos1 + Size, elemAtPos(L, Pos2, 2), Pos3 is Pos + Size, elemAtPos(L, Pos3, 0), Pos4 is Pos + 1, eviterPieges(L, R1, Pos4, Size, R2).
eviterPieges(L, [0|R1], Pos, Size, [4|R2]) :- Pos1 is Pos - 1, elemAtPos(L, Pos1, 3), Pos2 is Pos1 + Size, elemAtPos(L, Pos2, 3), Pos3 is Pos + Size, elemAtPos(L, Pos3, 0), Pos4 is Pos + 1, eviterPieges(L, R1, Pos4, Size, R2).
eviterPieges(L, [0|R1], Pos, Size, [4|R2]) :- Pos1 is Pos - 1, elemAtPos(L, Pos1, 3), Pos2 is Pos1 + Size, elemAtPos(L, Pos2, 5), Pos3 is Pos + Size, elemAtPos(L, Pos3, 0), Pos4 is Pos + 1, eviterPieges(L, R1, Pos4, Size, R2).
eviterPieges(L, [0|R1], Pos, Size, [4|R2]) :- Pos1 is Pos + 1, elemAtPos(L, Pos1, 3), Pos2 is Pos1 + Size, elemAtPos(L, Pos2, 2), Pos3 is Pos + Size, elemAtPos(L, Pos3, 0), eviterPieges(L, R1, Pos1, Size, R2).
eviterPieges(L, [0|R1], Pos, Size, [4|R2]) :- Pos1 is Pos + 1, elemAtPos(L, Pos1, 3), Pos2 is Pos1 + Size, elemAtPos(L, Pos2, 3), Pos3 is Pos + Size, elemAtPos(L, Pos3, 0), eviterPieges(L, R1, Pos1, Size, R2).
eviterPieges(L, [0|R1], Pos, Size, [4|R2]) :- Pos1 is Pos + 1, elemAtPos(L, Pos1, 3), Pos2 is Pos1 + Size, elemAtPos(L, Pos2, 5), Pos3 is Pos + Size, elemAtPos(L, Pos3, 0), eviterPieges(L, R1, Pos1, Size, R2).
eviterPieges(L, [3|R1], Pos, Size, [4|R2]) :- Pos1 is Pos - Size, elemAtPos(L, Pos1, 0), Pos2 is Pos + Size, elemAtPos(L, Pos2, 0), Pos3 is Pos + 1, eviterPieges(L, R1, Pos3, Size, R2).
eviterPieges(L, [3|R1], Pos, Size, [4|R2]) :- Pos1 is Pos - Size, elemAtPos(L, Pos1, 0), Pos2 is Pos + Size, elemAtPos(L, Pos2, 22), Pos3 is Pos + 1, eviterPieges(L, R1, Pos3, Size, R2).
eviterPieges(L, [E|R1], Pos, Size, [E|R2]) :- Pos1 is Pos + 1, eviterPieges(L, R1, Pos1, Size, R2).

  
eviterMonstres(Map,Size,NewMap):-
  recupPosMonstre(Map,1,PosMonstresSansBouger),
  modificationPosMonstre(PosMonstresSansBouger,Size,D,PosMonstres),
  lancerRecupDirection(PosMonstres,Size,ListeD),
  nouvellePosition(Map,Size,ListeD,ListeP),
  modifCarte(Map,ListeP,NewMap).
  
lancerRecupDirection(PosMonstres,Size,ListeDirectionPrecedent):-
  nb_getval(posMonstre,ListePosMonstre),
  verifMonstre(PosMonstres,Size,ListeDirectionPrecedent,ListePosMonstre).
  
modificationPosMonstre([],_,_,[]):-
modificationPosMonstre([X|R],_,1,PosMonstres):-
	X1 is X-1,
	append([X1],PosMonstresAvant,PosMonstres),
	modificationPosMonstre(R,1,PosMonstresAvant).
modificationPosMonstre([X|R],_,3,PosMonstres):-
	X1 is X+1,
	append([X1],PosMonstresAvant,PosMonstres),
	modificationPosMonstre(R,1,PosMonstresAvant).
modificationPosMonstre([X|R],Size,2,PosMonstres):-
	X1 is X+Size,
	append([X1],PosMonstresAvant,PosMonstres),
	modificationPosMonstre(R,1,PosMonstresAvant).
modificationPosMonstre([X|R],Size,4,PosMonstres):-
	X1 is X-Size,
	append([X1],PosMonstresAvant,PosMonstres),
	modificationPosMonstre(R,1,PosMonstresAvant).


nouvellePosition(_,_,[],[]).
nouvellePosition(Map,Size,[Val|Reste],Liste):-
	Val = [5,Pos],
	Pos1 is Pos+1,
	ajouteCroix(Pos1,Pos,Size,Pos2),
	Pos3 is Pos+Size,
	Pos4 is Pos-1,
	ajouteCroix(Pos4,Pos,Size,Pos5),
	Pos6 is Pos-Size,
	append([[Pos,Pos2],[Pos,Pos3],[Pos,Pos5],[Pos,Pos6]],NewListe,Liste),
	!,
	nouvellePosition(Map,Size,Reste,NewListe).
nouvellePosition(Map,Size,[Val|Reste],Liste):-
	Val = [D,Pos],
	moveMonster(Map, Pos, Size, D, Pos1),
	append([[Pos,Pos1]],NewListe,Liste),
	!,
	nouvellePosition(Map,Size,Reste,NewListe).

nouvellePosition(Map,Size,[_|Reste],Liste):-
	nouvellePosition(Map,Size,Reste,Liste).

ajouteCroix(Pos,_,Size,Pos1):-
	Pos > -1,
	Mod is mod(Pos,Size),
	Mod \=0,
	Pos1 = Pos.
ajouteCroix(_,PosInitiale,_,PosInitiale).

/*
  recupPosMonstre(+Map,+Pos,-PosMonstres),
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
	
  
verifMonstre([],_,[],PosMonstre):-
  flushPosMonstre(PosMonstre,NewPosMonstre),
  nb_setval(posMonstre,NewPosMonstre).
verifMonstre([Monstre|AutresMonstre],Size,ListeD,ListPosMonstre):-
  addPosition(ListPosMonstre,Monstre,Size,NewPos,Direction),
  append([Direction],NewListeD,ListeD),
  !,
  append(NewPos,ListPosMonstre,NewListPosMonstre),
  verifMonstre(AutresMonstre,Size,NewListeD,NewListPosMonstre).
verifMonstre([_|AutresMonstre],Size,ListeD,ListPosMonstre):-
  verifMonstre(AutresMonstre,Size,ListeD,ListPosMonstre).

replace([_|T], 1, X, [X|T]).
replace([H|T], I, X, [H|R]):- 
	I > -1, NI is I-1, replace(T, NI, X, R), !.
  
/*
  modifCarte(+Map,+ListeD,-NewMap)
*/
modifCarte(N,[],N):-!.
modifCarte(Map,[X|Reste],NewMap):-
	X = [XAvant,XApres],
	replace(Map,XAvant,0,MapRecursive),
	replace(MapRecursive,XApres,24,MapSuivante),
	!,
	modifCarte(MapSuivante,Reste,NewMap).
modifCarte(Map,[_|Reste],NewMap):-
	modifCarte(Map,Reste,NewMap).


/*
  flushPosMonstre(+PosMonstre,-NewPosMonstre)
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
  addPosition(+ListPosMontre,+PosMonstre,+Size,-Direction)
*/

% droite = 1 , haut = 2, gauche = 3, bas = 4
addPosition([],[],_,[],[]).
addPosition([],X,_,NewPos,[]):-
  append([[X,X]],[],NewPos).
addPosition([PosAvant|_],X,_,NewPos,D):-
  X1 is X+1,
  PosAvant = X1,
  D = [3,X],
  !,
  append([[PosAvant,X]],[],NewPos).
  
addPosition([PosAvant|_],X,_,NewPos,D):-
  X1 is X-1,
  PosAvant = X1,
  D = [1,X],
  !,
  append([[PosAvant,X]],[],NewPos).
  
addPosition([PosAvant|_],X,Size,NewPos,D):-
  X1 is X+Size,
  PosAvant = X1,
  D = [4,X],
  !,
  append([[PosAvant,X]],[],NewPos).

addPosition([PosAvant|_],X,Size,NewPos,D):-
  X1 is X-Size,
  PosAvant = X1,
  D = [2,X],
  !,
  append([[PosAvant,X]],[],NewPos).
  
addPosition([_|Reste],Pos,Size,NewPos,D):-
  addPosition(Reste,Pos,Size,NewPos,D).

/*
% Type de l'élément à la position indiquée
elemAtPos([X|_], 1, X).
elemAtPos([_|R], Pos, Element) :- Pos1 is Pos - 1, elemAtPos(R, Pos1, Element).
*/

% Prochaine position possible pour monstre
possibleMoveMonster(L, Pos) :- elemAtPos(L, Pos, 0).

% f(d)
% Vers la gauche
moveMonster(L, Pos, Size, D, Pos1) :- D = 2, Pos1 is Pos - 1, Pos1 > -1, Mod is mod(Pos1,Size), Mod \=0, possibleMoveMonster(L, Pos1),!.
% Vers le bas
moveMonster(L, _, _, D, Pos1) :- D = 3, possibleMoveMonster(L, Pos1),!.
% Vers la droite
moveMonster(L, Pos, Size, D, Pos1) :- D = 4, Pos1 is Pos + 1, Mod is mod(Pos1,Size), Mod \=0, possibleMoveMonster(L, Pos1),!.
% Vers le haut
moveMonster(L, Pos, Size, D, Pos1) :- D = 1, Pos1 is Pos - Size, possibleMoveMonster(L, Pos1),!.

% d
% Vers le haut
moveMonster(L, Pos, Size, D, Pos1) :- D = 2, Pos1 is Pos - Size, possibleMoveMonster(L, Pos1),!.
% Vers la gauche
moveMonster(L, Pos, Size, D, Pos1) :- D = 3, Pos1 is Pos - 1, Pos1 > -1, Mod is mod(Pos1,Size), Mod \=0, possibleMoveMonster(L, Pos1),!.
% Vers le bas
moveMonster(L, Pos, Size, D, Pos1) :- D = 4, Pos1 is Pos + Size, possibleMoveMonster(L, Pos1),!.
% Vers la droite
moveMonster(L, Pos, Size, D, Pos1) :- D = 1, Pos1 is Pos + 1, Mod is mod(Pos1,Size), Mod \=0, possibleMoveMonster(L, Pos1),!.

% f(f(d))
% Vers le bas
moveMonster(L, Pos, Size, D, Pos1) :- D = 2, Pos1 is Pos + Size, possibleMoveMonster(L, Pos1),!.
% Vers la droite
moveMonster(L, Pos, Size, D, Pos1) :- D = 3, Pos1 is Pos + 1, Mod is mod(Pos1,Size), Mod \=0, possibleMoveMonster(L, Pos1),!.
% Vers le haut
moveMonster(L, Pos, Size, D, Pos1) :- D = 4, Pos1 is Pos - Size, possibleMoveMonster(L, Pos1),!.
% Vers la gauche
moveMonster(L, Pos, Size, D, Pos1) :- D = 1, Pos1 is Pos - 1, Pos1 > -1, Mod is mod(Pos1,Size), Mod \=0, possibleMoveMonster(L, Pos1),!.

% f(f(f(d)))
% Vers la droite
moveMonster(L, Pos, Size, D, Pos1) :- D = 2, Pos1 is Pos + 1,  Mod is mod(Pos1,Size), Mod \=0, possibleMoveMonster(L, Pos1),!.
% Vers le haut
moveMonster(L, Pos, Size, D, Pos1) :- D = 3, Pos1 is Pos - Size, possibleMoveMonster(L, Pos1),!.
% Vers la gauche
moveMonster(L, Pos, Size, D, Pos1) :- D = 4, Pos1 is Pos - 1, Pos1 > -1, Mod is mod(Pos1,Size), Mod \=0, possibleMoveMonster(L, Pos1),!.
% Vers le bas
moveMonster(L, Pos, Size, D, Pos1) :- D = 1, Pos1 is Pos + Size, possibleMoveMonster(L, Pos1),!.
