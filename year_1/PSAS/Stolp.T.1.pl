% PSS Huiswerk #1
% 11 september 2017
% Tim Stolp, 11848782, tim2stolp@gmail.com


% Opd. 1.

% Hier onder staat de database van studentnamen en bijbehorende TAs

has_ta(alice, mary).
has_ta(bob, mary).
has_ta(cecilia, paul).
has_ta(tim, douwe).

% Hieronder staat de database van TAs en bijbehorende toppings

has_favourite_topping(peter, nutella).
has_favourite_topping(paul, strawberryjam).
has_favourite_topping(mary, caramel).
has_favourite_topping(douwe, perslucht).

% Bij de query wordt een naam ingevuld, dat wordt X.
% Daarna zoekt has_ta(X, Y) naar wat matched met de X
% en geeft dan de bijbehorende Y, dat is de naam van de TA
% Daarna zoekt has_favourite_topping(Y, Z) naar wat matched met de gekregen Y
% en geeft dan de bijbehorende Z, de Z is dan de topping van de TA
% als de Z is gevonden is dan wordt de voorbeeldzin en daarna de Z geschreven.

answer(X):-
  has_ta(X, Y),
  has_favourite_topping(Y, Z),
  write('The favourite pancake topping of the TA of this student is '),
  write(Z).

/*

Opg. 2.
1. Niet, de tail is geen lijst.
2. Wel, elementen: 1 en [2, 3]
3. Niet, de tail is geen lijst.
4. Wel, elementen: [1] en [2, 3]
5. Niet, de tail van de lijst in de tail van de main lijst is geen lijst.
6. Wel, elementen: 1 en [2|[3]]
7. Wel, elementen: 1 en 2 en [3]
8. Niet, de head kan geen lege lijst zijn.

*/

% Opg. 3.

whatisthis([]).
whatisthis([_, b| L]):-
  whatisthis(L).

% De quary ?- whatisthis(X) slaagt of als X een lege lijst is,
% of als de lijst een even aantal members heeft waarbij elk even member (2e,4e,6e etc.) een b is.
% dus [iets, b, iets, b ,iets, b] etc

% opg. 4.

remove_first(_, [], []).
remove_first(X, [X|T], T).
remove_first(X, [H|T], [H|R]):-
  remove_first(X, T, R).

% Eerst checkt remove_first een base case waarbij de lijst waarvan je iets wilt verwijderen leeg is.
% Als dat zo is geeft hij een lege lijst terug.
% Als dat niet zo is checkt remove_first of het element dat je invoert gelijk is aan het element van de head
% nadat prolog de ingevoerde lijst heeft gesplits in een head en tail.
% Als dat zo is dan geeft hij de lijst van de tail terug.
% Als dat niet zo is splits remove_first de ingevoerde lijst in een head en tail
% en doet opnieuw remove_first vanaf bovenaan met hetzelfde te verwijderen element, de tail van de gesplitste lijst en een nieuwe variabele.
% tegelijkertijd onthoud prolog de head van de gesplitste lijst. (noemt prolog bijvoorbeeld H1 = a H2 = b etc.)
% Het uiteindelijke antwoord wordt hierdoor steeds groter in de vorm van [H1|[H2|R]]
% dit gaat door todat het overeenkomt met een base case (dan is 'R' een lege lijst), als dat zo is dan is wat na de if komt true, dus dan is wat voor de if komt true,
% dus dan geeft prolog het antwoord, bijvoorbeeld [H1|[H2|R]] wordt dan [H1, H2, R] (met welke elementen prolog aan die variablen heeft toegekend).


remove_last(_, [], []).
remove_last(X, [H|T], [H|R]):-
  member(X, T),
  remove_last(X, T, R).
remove_last(X, [X|T], T).
remove_last(_, [H|T], [H|T]).

% Eerst checkt remove_last een base case waarbij de lijst waarvan je iets wilt verwijderen leeg is.
% Als dat zo is geeft hij een lege lijst terug.
% Als dat niet zo is wordt de lijst in een head en tail gesplitst en wordt er gescheckt of het te verwijderen element nog in de tail zit.
% Als dat zo is dan wordt er opnieuw vanaf bovenaan remove_last gedaan maar dan met de tail en wordt de head onthouden.
% dit gaat door met recursie todat de recursie faalt.
% Nadat de recursie faalt gaat hij naar de volgende remove_last regel om de overgebleven lijst op te lossen.
% eerst checkt hij of het element in de head van de lijst zit, als dat zo is dan backtrackt hij de recursie
% en geeft de onthouden heads en de overgebleven tail. (op dezelfde manier als bij remove_first)
% Als het element niet in de head zat dan gaat hij naar de laatste remove_last predicate.
% Deze predicate wordt altijd true behalve als de lijst leeg is (maar die situatie wordt al true door de 1e base case).
% Dus als laatste optie gaat hij door met de overgebleven lijst, checkt of er een element in de lijst zit,
% geeft dan de overgebleven lijst en backtrackt de onthouden heads uit de recursie en geeft dan de heads en de overgebleven lijst.
% De laatste lijn zorgt er ook voor dat als je een lijst hebt waar het te verwijderen element niet in zit, dat prolog dan gewoon de orginele lijst geeft.


remove_all(_, [], []).
remove_all(X, [H|T], R):-
  member(X, [H]),
  remove_all(X, T, R).
remove_all(X, [H|T], [H|R]):-
  remove_all(X, T, R).

% Eerst wordt de basecase voor een lege lijst gecheckt zoals bij de andere "removes".
% Daarna wordt de lijst in head en tail gesplitst en gekeken of het te verwijderen element in de head zit.
% Als dat zo is dan doet hij weer remove_all bovenaan met de overgebleven tail (hier wordt de head niet aan het uiteindelijke antwoordt geplakt omdat de head verwijdert moet worden)
% todat hij tegenkomt dat de head niet overeenkomt met het te verwijderen element.
% Als dat zo is dan gaat hij door naar de volgende remove_all waar hij de lijst opsplitsts in head en tail en weer remove_all vanaf boven doet met alleen de tail,
% Hier wordt wel de head onthouden en aan het uiteindelijke antwoord geplakt.
% Dit gaat door met recursie todat er remove_all wordt gedaan met een tail die in een lege lijst is, dat geeft dan true door de 1e regel,
% daarna backtrackt hij de overgebleven heads die wel onthouden zijn en geeft die als antwoord samen met de lege lijst.


remove_list(_, [], []).
remove_list([], [H|T], [H|T]).
remove_list([H|T], L, R):-
  remove_all(H, L, Y),
  remove_list(T, Y, R).

% Eerst wordt de basecase voor een lege lijst gecheckt zoals bij de andere "removes".
% Daarna wordt de 2e basecase gecheckt of de te verwijderen lijst leeg is, dan geeft hij gewoon de orginele lijst.
% Daarna wordt de te verwijderen lijst in een head en tail gesplitst en wordt de head daarvan met de lijst waarvan je iets wilt verwijderen in de remove_all predicate gedaan.
% Als dat uiteindelijke gelukt is gaat prolog naar de volgende lijn achter de 'if'.
% Daar neemt hij de tail van de aan het begin gesplitste te verwijderen lijst en stop dat samen met het resultaat van de remove_all predicate weer terug in de remove_list predicate.
% dit gaat door tot de te verwijderen lijst leeg is. Als dit zo is geeft hij bij de 2e basecase true.
% Dan geeft prolog gewoon de lijst waarmee hij remove_list aan het doen is.


% Opg. 5.

intersect([], [], []).
intersect([], [_|_], []).
intersect([_|_], [], []).
intersect([H|T], L, R):-
  member(H, T),
  intersect(T, L, R).
intersect([H|T], L, [H|R]):-
  member(H, L),
  intersect(T, L, R).
intersect([_|T], L, R):-
  intersect(T, L, R).

% Eerst wordt de 1e basecase gecheckt, als allebei de lijsten leeg zijn, dan is er geen overeenkomst dus is het antwoord een lege lijst.
% Daarna worden de volgende 2 base casen geschekt, als een van de 2 lijsten leeg is, komt er dus niks overeen en is het antwoord dus een lege lijst.
% Daarna checkt hij of de head van de 1e lijst ook aanwezig is in de 2e lijst, als dat zo is doet hij opnieuw intersect met de tail.
% Dit zorgt ervoor dat een dezelfde element niet 2 keer in het antwoord komt.
% Als de head dan uiteindelijke een element bevat dat als enige aanwezig is in de 1e lijst (dus niet in de tail van de 1e lijst), dan faalt de member en gaat hij door naar de volgende regel.
% Hier checkt member of de head van de 1e lijst aanwezig is in de 2e lijst, als dat zo is dan onthoud hij dat element en stop de tail van de 1e lijst weer in de intersect predicate samen met de 2e lijst.
% Dit gaat door met recursie todat hij een element in de head van de 1e lijst tegenkomt die niet overeenkomt met een element in de 2e lijst, als dat zo is gaat hij naar de volgende lijn.
% deze lijn zorgt ervoor dat de tail van de 1e lijst samen met de 2e lijst weer terug in de intersect predicate wordt gestopt.
% (Hier wordt de head van de 1e lijst niet onthouden want hij kwam niet overeen met een element in de 2e lijst.)
% Dit gaat door tot de 1e lijst leeg is, op dat moment voldoet het aan de 2e basecase en wordt het true, hierna geeft prolog de gevonden antwoorden
% (dat zijn de heads van de 1e lijst waarvan het element overeenkwam met een element uit de 2e lijst).

% P.S. Het kan zo zijn dat als er geen overeenkomsten zijn dat het false moet geven in plaats van een lege lijst aangezien een lege lijst ook een element kan zijn.
