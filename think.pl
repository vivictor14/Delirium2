%--------------------------------------------------------------------
%====================================================================
%
% Module consisting in:
%  - extracting the relevant information from a stimulus and
%  - thinking about the correct move to perform by the miner.
%
% Version: 	1.0
% Date:		2011/10
%
% Author(s):
%  1- Fabrice Lauri
%
% Status:
%  1- Associate Professor at the "Université de Technologie de
%     Belfort-Montbéliard", France
%     Laboratoire "Systèmes et Transports"
%
%====================================================================
%--------------------------------------------------------------------


:- use_module( decision ).


% ***************************************************************************************
%   Description of a stimulus in Delirium2
% ***************************************************************************************
% 
%   Vector of 64-bit floats. Casting in integers is mandatory...
% 
%   Content:
%   - Header:
%     -   0: Header Size				<- Offset
%     -   1: X coordinate of the agent
%     -   2: Y coordinate of the agent
%     -   3: Width of the view perimeter
%     -   4: Height of the view perimeter
%     -   5: # of items perceived			<- NbrPercepts
%     -   6: agent offset in the list of items
%     -   7: number of items per line
%     -   8: New Map?
%     -   9: Time remaining
%     -  10: # of remaining diamonds to collect
%     -  11: Current Energy
%     -  12: Maximum Energy
%     -  13: Gathered Energy
%   - Variable-length part:
%     - Offset: first perceived item of the first line
%     - ...
%     - Offset+NbrPercepts-1: last perceived item of the last line
%     - Offset+NbrPercepts: attribute of the first perceived item of the first line
%     - ...
%     - 2*Offset+2*NbrPercepts-1: attribute of the last perceived item of the last line
% 
% ***************************************************************************************


startThinking( X ) :-
	init( X ).


think( Stimulus, [Action] ) :-
	Stimulus=[External_Percepts | _],
	External_Percepts=[F_HeaderSize | _],
	HeaderSize is integer( F_HeaderSize ),
	splitList( External_Percepts,Header,Data,HeaderSize ),
	Header=[_,X,Y,VPx,VPy,NbrPercepts,Pos,Size,_,NbrDiamonds,Energy,_,GEnergy | _],
	canGotoExit(NbrDiamonds,CGE),
	splitList( Data,Percepts1,Data2,NbrPercepts ),
	splitList( Data2,Percepts2,[],NbrPercepts ),
	move( Percepts1,Percepts2,X,Y,Pos,Size,CGE,Energy,GEnergy,VPx,VPy,Action ).


canGotoExit(0,1) :-
	!.
canGotoExit(_,0).


splitList( L,[],L,0 ) :-
	!.
splitList( [T|R],[I|R1],L2,N ) :-
	N > 0,
	N1 is N-1,
	I is integer(T),
	splitList( R,R1,L2,N1 ).
