% zad1
% odciêcia wstawiam w miejscach gdzie klauzule wzajemnie siê wykluczaj¹
% po sprecyzowaniu warunku dopasoania do danej klauzuli
% w ostatniej klauzuli mo¿na pomin¹æ odciêcie poniewa¿ dopasoawnie jest
% interpretowane wramach termw od góry do do³u wiêc w ostatniej klauzuli
% q1 i q2 nie wstawiam odciecia, bo i tak niebedzei dalszego
% dopasowywania. Odciêcia s¹ równie¿ wstawione przy faktach

q1([], []):-!.
q1([X], [X]):-!.
q1([H|T], [H1|T1]):-
    q1(T, T1),
    H1 is H/2.

q2([], []):-!.
q2([_], []):-!.
q2([H|T], T1):-
    H>4,!,
    q2(T, T1).
q2([H|T], [H|T1]):-
    q2(T, T1),
    H=<4.

% zad2
% akcepteor dla wyra¿enia:   a (b a | a b)* a (b | b a)+ a b b


% a
acc([a|T]):-
    acc1(T).

% (ba|ab)*a
acc1([a|T]):-
    acc2(T).
acc1([b,a|T]):-
    acc1(T).
acc1([a,b|T]):-
    acc1(T).

% (b|ba)+ jedno konieczne wystapienie przez +
acc2([b|T]):-
    acc3(T).
acc2([b,a|T]):-
    acc3(T).

% (b|ba)+abb
acc3([b|T]):-
    acc3(T).
acc3([b,a|T]):-
    acc3(T).
acc3([a,b,b]):-!.


% zad3 definicja w spsoób rekurencyjny
% zakladamy ze w 2 zmiennj jest poszukiwana wartosc dla ogonu listy

zlicz_wieksze4([],0). % przypadek podstawowy, gdy lista jest pusta, fakt, koniec rekurencji
zlicz_wieksze4([H|T],Y):- % przypadek, kiedy liczba, przy powrocie z rekurecyjnych wywo³añ zwiêksza nasz licznik z wymikiem
    H > 4, % warunek zliczania zgodny z treœci¹ zadania
    zlicz_wieksze4(T,X), % pytamy ile liczb wikszych od 4 jest w ogonie
    Y is X + 1. % zwiêkszenie licznika o 1 przy powrocie z krekurencyjnych wyw³an
zlicz_wieksze4([H|T],Y):- % przypadek dla liczby mniejszej, b¹dŸ równej
     H =< 4, % warunek
    zlicz_wieksze4(T,Y). % pytamy ile liczb wikszych od 4 jest w ogonie, Y jest bezposredni przekazywane do glowy, bo warunek jest nie spelnion


% zad4


% warunki koncowe dla rekurencji, umo¿liwij¹ce wykrycie konca list i jak
% postapic gdy ktoras lista jesty krótsza, lub sa roznych d³ugoœcina
suma([],[],[]). % warunek podstawowy, dla dwóch pustych liczb wspó³czynników, wynikiem te¿ jest pusta lista
suma([],L,L). % gdy tylko w drugiej liscie s¹ wspó³czynniki, s¹ one od razu rozwi¹zaniem
suma(L,[],L). % analogoicznie jak powy¿ej tyczy jednak tylko listy z pierwszej pozycji
% wykorzystanie notacji [H|T] do sumowania elementów , [X|T3] dodaje
% wspolczynnik do listy wynikowej na poczatku tej listy, wykorzystanie
% takiej skladni
suma([H1|T1],[H2|T2],[X|T3]):-
    X is H1 + H2, % zsumowanie wspoczynników z odpowiadjacych pozycji
    suma(T1,T2,T3). % przkazujemy ogony z list T1, T2, T3 jest lista ktora jest juz posumowana, do niej dodajemy na poczatku X


