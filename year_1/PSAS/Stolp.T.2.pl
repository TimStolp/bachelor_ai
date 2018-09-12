% PSS Huiswerk # 2
% 18-09-2017
% Tim Stolp, 11848782, tim2stolp@gmail.com


% Opd. 1.

% Dit consult de lijst met woorden voor opdracht 1.
:-consult('words.pl').


% Dit stukje maakt van een woord een lijst met de losse letters van dat woord.
word_letters(A, B):-
  string_chars(A, B).

% Dit checkt of het gegeven element in de head van de gegeven lijst zit, als dat zo is verwijder hem dan, als dat niet zo is doe dit opnieuw maar dan met de tail van de gegeven lijst.
checkHead(A, [A|B], B).
checkHead(A, [C|D], [C|Z]):-
  checkHead(A, D, Z).

% Dit stuk kijkt of de eerste lijst in de 2e lijst zit. Dat doet hij door eerst te kijken of de head van de 1e lijst in de 2e lijst zit, als dat zo is verwijder die uit de 2e lijst, als dat niet zo is dan blijft de 2e lijst hetzelfde.
% en doe dit dan opnieuw met de tail van de 1e lijst en het resultaat van het of wel of niet verwijderen van de 1e head uit de 2e lijst.
cover([], _).
cover([A|B], C):-
  checkHead(A, C, Z),
  cover(B, Z).

% Dit stuk zoekt een woord met de lengte R, R is de eerste keer de lengte van de gegeven woordenlijst, dat is dan dus ook de maximale lengte.
% Als dat niet lukt dan doet hij R - 1, en doet dan opnieuw solution() maar hij zoekt dan voor een woord die 1 letter korter is dan het maximum.
% Dit gaat door tot hij een woord vindt of dat R 0 wordt, dan is er dus ook geen woord gevonden met lengte 1 en zijn er dus geen woorden te vinden in de lijst. Dan faalt het programma.
solution(A, X, R):-
  word(X),
  word_letters(X, Z),
  cover(Z, A),
  length(Z, R).
solution(A, X, R):-
  \+ R =< 0,
  Z is R - 1,
  solution(A, X, Z).

% Dit stuk doet solution met de lijst van letters en de lengte van de lijst van letters.
% Dan checkt hij de lengte van het gevonden woord en geeft hij het woord en de lengte door als antwoord.
topsolution2(A, Word, B, Length):-
  solution(A, Word, Length),
  word_letters(Word, Z),
  length(Z, B).

% Dit stuk berekent de lengte van de lijst ingevoerde woorden en doet dan topsolution2 met de lijst van letters en lengte van die lijst.
topsolution(A, Word, B):-
  length(A, Length),
  topsolution2(A, Word, B, Length).

% opg. 2.

% Als de discriminant kleiner dan 0 is zijn er geen antwoorden en geeft hij een lege lijst terug.
solveQuadratic([A, B, C], []):-
  D is ((B**2) - (4*A*C)),
  D < 0.

% Als de discriminant gelijk is aan 0 dan is er maar 1 antwoord want de wortel van 0 is 0.
% Dus of je nou -0 of +0 doet heb je beide keren hetzelfde antwoord dus kan je dat in de formule weglaten.
solveQuadratic([A, B, C], [Answer]):-
  D is ((B**2) - (4*A*C)),
  D is 0,
  Answer is (-B/(2*A)).

% Als de discriminant groter is dan 0 rekent hij voor beide gevallen van "- wortel(D)" en "+ wortel(D)"
solveQuadratic([A, B, C], [Answer1, Answer2]):-
  D is ((B**2) - (4*A*C)),
  D > 0,
  Answer1 is ((-B + sqrt(D))/(2*A)),
  Answer2 is ((-B - sqrt(D))/(2*A)).


% Opg. 3.

% (a).

% Hier kijkt prolog eerst wat alle voorgaande getallen van het ingevoerde getal zijn door A - 1 te doen en dan met recursie opnieuw fac() te doen.
% Todat hij bij de base case aan is gekomen dat als je 0 invult dat je dan 1 krijgt, daarna doet hij de ingevoerde A * alle gevonden antwoorden die hij vindt met backtracken.
fac(0, 1).
fac(A, Answer):-
  A > 0,
  B is A - 1,
  fac(B, C),
  Answer is A*C.

% Hier rekent prolog de fac() uit van de ingevoerde A, daarna doet hij opnieuw sumInvFacs met A - 1, dit gaat door tot de base case, dan weet hij sumInvFacs van 0 is 1.
% Dan berekent hij B door 1 gedeelt door de fac van C + 1 plus de gevonden E van C te doen.
% Daarna backtrackt hij terug naar de vorige stappen en rekent hij opnieuw B uit.
sumInvFacs(0, 1).
sumInvFacs(A, B):-
  fac(A, D),
  C is A - 1,
  sumInvFacs(C, E),
  B is 1/D + E.


% (b).

% Dit stuk doet sumInvFacs() met een getal (de eerste keer is dat 1) en daarna met dat getal + 1, daarna vergelijkt hij de 2 antwoorden,
% als die volgens prolog hetzelfde zijn, dan geeft hij wat op dat moment A is (dat is een bepaald getal) en wat het antwoord is van sumInvFacs() met dat getal.
sumInvFacs2(A, A, B):-
  sumInvFacs(A, B),
  C is A + 1,
  sumInvFacs(C, D),
  B =:= D.
% Als de 2 antwoorden van de sumInvFacs() niet gelijk zijn aan elkaar dan gaat hij door naar dit stuk, hier neemt hij het getal A en doet dat + 1,
% daarna doet hij opnieuw sumInvFacs2() met dat getal, zo doet het programma sumInvFacs2() steeds opnieuw todat de 2 antwoorden van sumInvFacs() hetzelfde zijn.
sumInvFacs2(A, N, Answer):-
  C is A + 1,
  sumInvFacs2(C, N, Answer).

% Dit stuk roept sumInvFacs2() aan met het begin getal 1, daarna geeft hij uiteindelijk de gevonden antwoorden voor "A" en "Answer" terug.
sumInvFacsLimit(A, Answer):-
  sumInvFacs2(1, A, Answer).


% opg. 4.

% Dit stuk neemt een element en plakt hem aan de achter kant van een lijst. (Uit vorige oefenopgaven).
pushBot(Z, [], [Z]).
pushBot(Z, [H|T], [H|NT]):-
  pushBot(Z, T, NT).

% Dit stuk draait een lijst om. (Uit vorige oefenopgaven).
swapList([], []).
swapList([H|T], SL):-
  swapList(T, ST),
  pushBot(H, ST, SL).

% Dit stuk maakt een lijst van alle getallen kleiner dan het gegeven getal, zonder het getal zelf en zonder 1. Deze lijst loopt van hoog naar laag.
makeFirstList(2, []).
makeFirstList(N1, [N2|R]):-
  N2 is N1 - 1,
  makeFirstList(N2, R).

% Dit stuk draait de lijst van makeFirstList om zodat de lijst van laag naar hoog loopt.
makeList(X, Y):-
  makeFirstList(X, Z),
  swapList(Z, Y).

% Het hele stuk hierboven kan je ook vervangen door numlist(2, X, Y).

% Dit stuk neemt de head van de lijst en gaat alle andere getallen in de lijst proberen te delen door zichzelf, als dat kan dan verwijdert hij dat getal uit de lijst.
% Als dit niet kan dan laat hij het getal in de lijst staan en gaat naar het volgende getal todat hij de lijst heeft afgewerkt.
removeTableHead(_, [], []).
removeTableHead(A, [H|T], C):-
  H mod A =:= 0,
  removeTableHead(A, T, C).
removeTableHead(A, [H|T], [H|C]):-
  removeTableHead(A, T, C).

% Dit stuk kijkt of het kwadraat van de head van de lijst groter of gelijk is dan het aan het begin gegeven getal, als dat zo is dan is er niks meer te verwijderen uit de lijst.
% Als dat niet zo is dan gaat hij naar removeTableHead(). Als hij daarmee klaar is doet hij opnieuw removeNonPrimes maar dan met alleen de tail van de lijst.
removeNonPrimes(A, [C|G], [C|B]):-
  \+ (C**2) >= A,
  removeTableHead(C, G, X),
  removeNonPrimes(A, X, B).
removeNonPrimes(_, [C|G], [C|G]).

% Dit stuk gaat eerst naar de makeList() predicate waar hij de lijst van alle getallen kleiner dan het gegeven getal maakt. (zonder 1)
% Daarna gaat hij naar removeNonPrimes() waar alle niet-priemgetallen worden verwijdert. Nadat al die getallen zijn verwijdert schrijft hij de overgebleven lijst op.

primes(A):-
  A > 2,
  makeList(A, X),
% Z is A - 1, % deze gaat samen met numlist().
% numlist(2, Z, X), % Als ik hier deze numlist() zet en de makeList() hier weg haal, werkt het ook maar dan kan het veel verder rekenen, tot wel primes(100000) of hoger omdat prolog minder stappen hoeft te doen.
  removeNonPrimes(A, X, B),
  write(B).

% Het vinden van de prime numbers kan veel efficienter, bij deze code kan prolog to maximaal 4727 de lijst primes geven.
% Het gebruiken van built-ins is een van de manieren om te zorgen dat de code minder stappen hoeft te doen. bijvoorbeeld de built-in voor het maken van een lijst getallen.
% Daarnaast kan je ook gewoon de formule voor het vinden van primes coderen. Hiervoor zijn verschillende formules mogelijk.
