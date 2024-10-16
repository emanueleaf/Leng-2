padre(juan, hijo).
abuelo(juan, abuelo1).
abuela(juan, abuela2).
tio(juan, tio1).
tio(juan, tio2).
tio(juan, tio3).
tio(juan, tio4).
tio(juan, tio5).
tio(juan, tio6).

consanguinity_Level(X, Y, 1) :- padre(X, Y).
consanguinity_Level(X, Y, 2) :- abuelo(X, Y); abuela(X, Y).
consanguinity_Level(X, Y, 3) :- tio(X, Y).

distributeInheritance(Total, Distribution) :-
    findall(P, consanguinity_Level(_, P, 1), Level1),
    findall(P, consanguinity_Level(_, P, 2), Level2),
    findall(P, consanguinity_Level(_, P, 3), Level3),
    distribute(Total, Level1, Level2, Level3, Distribution).

distribute(Total, Level1, Level2, Level3, Distribution) :-
    length(Level1, N1),
    length(Level2, N2),
    length(Level3, N3),

    TotalPercent is N1 * 0.3 + N2 * 0.2 + N3 * 0.1,
    AdjustFactor is min(1.0, 1 / TotalPercent),

    (N1 > 0 -> P1 is AdjustFactor * Total * 0.3 / N1 ; P1 is 0),
    (N2 > 0 -> P2 is AdjustFactor * Total * 0.2 / N2 ; P2 is 0),
    (N3 > 0 -> P3 is AdjustFactor * Total * 0.1 / N3 ; P3 is 0),

    append(Level1, Level2, Temp),
    append(Temp, Level3, Heirs),
    findall(distribution(Person, Amount), (
        member(Person, Heirs),
        (member(Person, Level1) -> Amount = P1;
         member(Person, Level2) -> Amount = P2;
         member(Person, Level3) -> Amount = P3)
    ), Distribution).

test_case2(Distribution) :-
    distributeInheritance(250000, Distribution).
