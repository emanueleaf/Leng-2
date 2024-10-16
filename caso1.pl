% Herederos: 2 hij@s, 1 herman@, 1 prim@
padre(humberto, hijo1).
madre(beatriz, hijo2).
hermano(hijo1, hermano).
primo(hijo1, primo).

consanguinity_Level(X, Y, 1) :- padre(X, Y).
consanguinity_Level(X, Y, 1) :- madre(X, Y).
consanguinity_Level(X, Y, 2) :- hermano(X, Y).
consanguinity_Level(X, Y, 3) :- primo(X, Y).

distributeInheritance(Total, Distribution) :-
    findall(P, consanguinity_Level(_, P, 1), Level1),
    findall(P, consanguinity_Level(_, P, 2), Level2),
    findall(P, consanguinity_Level(_, P, 3), Level3),
    distribute(Total, Level1, Level2, Level3, Distribution).

distribute(Total, Level1, Level2, Level3, Distribution) :-
    length(Level1, N1),
    length(Level2, N2),
    length(Level3, N3),

    (N1 > 0 -> P1 is Total * 0.3 / N1 ; P1 is 0),
    (N2 > 0 -> P2 is Total * 0.2 / N2 ; P2 is 0),
    (N3 > 0 -> P3 is Total * 0.1 / N3 ; P3 is 0),

    append(Level1, Level2, Temp),
    append(Temp, Level3, Heirs),
    findall(distribution(Person, Amount), (
        member(Person, Heirs),
        (member(Person, Level1) -> Amount = P1;
         member(Person, Level2) -> Amount = P2;
         member(Person, Level3) -> Amount = P3)
    ), Distribution).

% Caso de prueba 1
test_case1(Distribution) :-
    distributeInheritance(100000, Distribution).
