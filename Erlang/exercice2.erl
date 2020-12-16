% Auteur: Raphaël Lapointe
-module(exercice2).
-include("expr.hrl").
-include("question.hrl").
-compile(export_all).

% Lit le fichier, le ferme et retourne les lignes du fichier sous-forme de liste afin 
% qu'elles puissent être manipulées par d'autres fonctions.
lireFichier(Fichier) ->
    {ok, ToutesLignes} = file:open(Fichier, [read]),
    Liste = lireLigne(ToutesLignes),
    file:close(ToutesLignes),
    % La première ligne ne sert à rien. Il faut donc l'enlever.
    lists:nthtail(1, Liste).

% Appel récursif qui retourne toutes les lignes pour qu'elles puissent être utilisées dans la fonction lireFichier.
lireLigne(ToutesLignes) ->
    case file:read_line(ToutesLignes) of
        {ok, Ligne} ->
                [Ligne] ++ lireLigne(ToutesLignes);
    eof -> []
end.

% Convertit les lignes lues dans la fonction lireFichier en enregistrements destinés à être manipulés dans la fonction main.
lignesVersExpressions([]) ->
    [];
lignesVersExpressions(Liste) ->
    % On effectue un droplast sur la ligne pour enlever le changement de ligne à la fin sauf sur la dernière ligne 
    % où il n'y a pas de changment de ligne.
    Len = length(Liste),
    Ligne = if Len == 1 -> lists:nth(1, Liste); true -> lists:droplast(lists:nth(1, Liste)) end,
    CommenceParGuillemet = string:str(Ligne, "\""),
    DernierCaractere = lists:last(Ligne),
    [Expr, Sign] = string:tokens(Ligne, ";"),
    if (CommenceParGuillemet == 0) or (DernierCaractere == 34) ->
        Record = #expr{expr = Expr, signification = Sign},
        [Record] ++ lignesVersExpressions(lists:nthtail(1, Liste));
    true ->
        SignComplet = Sign ++ " " ++ lists:nth(2, Liste),
        Record = #expr{expr = Expr, signification = SignComplet},
        [Record] ++ lignesVersExpressions(lists:nthtail(2, Liste))
    end.

% Retourne l'expression qui correspond à celle entrée par l'utilisateur afin que le main puisse écrire sa signification.
% Ne reconnaîtra pas l'expression si elle comporte des caractères accentués.
trouverExpression([], Recherche) ->
    throw("Aucun match.");
trouverExpression(Liste, Recherche) ->
    Entree = lists:nth(1, Liste),
    Match = Entree#expr.expr == Recherche,
    if Match ->
        Entree;
    true ->
        trouverExpression(lists:nthtail(1, Liste), Recherche)
    end.

% Convertit la phrase entrée par l'usager en phrase interrogative en rajoutant un "-tu" après le verbe.
obtenirPhraseInterrogative(Phrase) ->
    DernierMot = lists:last(string:split(Phrase, " ", trailing)),
    if (DernierMot == "vient") or (DernierMot == "veux") or (DernierMot == "veulent") or (DernierMot == "écoutes") or (DernierMot == "sais") ->
        Phrase ++ "-tu?\n";
    true ->
        APresent = string:str(Phrase, "a "),
        AiPresent = string:str(Phrase, "ai "),
        if APresent > 0 ->
            string:sub_string(Phrase, 1, APresent - 1) ++ "a-tu " ++ string:sub_string(Phrase, APresent + 2) ++ "?\n";
        AiPresent > 0 ->
            string:sub_string(Phrase, 1, AiPresent - 1) ++ "ai-tu " ++ string:sub_string(Phrase, AiPresent + 3) ++ "?\n";
        true -> 
            "Ta phrase ne matche pas les critères!\n"
        end
    end.
    
% Retourne la liste hardcodée de questions pour le quiz. Il y en a 8, mais seules 5 d'entre elles seront choisies aléatoirement
% pour être posées dans le quiz et dans un ordre aléatoire.
genererQuestions() ->
    [
        #question{
            question = "Au plus sacrant veut dire qu'il faut prendre son temps.",
            reponse = "F"
        },
        #question{question = "Avoir une bad luck signifie être malchanceux", reponse = "V"},
        #question{question = "Chanter la pomme signifie célébrer l'arrivée du printemps.", reponse = "F"},
        #question{question = "Avoir le coeur gros signifie être heureux.", reponse = "F"},
        #question{question = "Être gratteux signifie avoir une fâcheuse tendance à se gratter l'entrejambe.", reponse = "F"},
        #question{question = "Lâcher un ouac signifie crier comme un débile.", reponse = "V"},
        #question{question = "Il nous arrive souvent d'avoir frette en hiver.", reponse = "V"},
        #question{question = "Pantoute signifie en grande quantité.", reponse = "F"}
    ].

% Pige aléatoirement 5 questions parmi la liste préfaite et les retourne sous forme de liste.
obtenirQuiz() ->
    L = lists:seq(1,8),
    Ques = genererQuestions(),
    O = [X||{_,X} <- lists:sort([ {random:uniform(), N} || N <- L])],
    [ques(Ques, O, 1), ques(Ques, O, 2), ques(Ques, O, 3), ques(Ques, O, 4), ques(Ques, O, 5)].
    
% Va chercher la question à la position demandée dans la liste passée comme premier paramètre. 
ques(Liste, Positions, Index) ->
    lists:nth(lists:nth(Index, Positions), Liste).

% Appel récursif qui pose une question parmi les 5 questions choisies par appel jusqu'à ce qu'elles soient toutes posées.
% Ensuite, retourne le score.
jouerQuiz([]) ->
    0;
jouerQuiz(Quiz) ->
    Question = lists:nth(1, Quiz),
    Reponse = lists:droplast(io:get_line(Question#question.question ++ "\n")),
    if Reponse == Question#question.reponse ->
        Score = 1,
        io:fwrite("CORRECT!!!\n");
    true ->
        Score = 0,
        io:fwrite("INCORRECT!!!\n")
    end,
    Score + jouerQuiz(lists:nthtail(1, Quiz)).

% Point d'entrée. Toute les autres fonctions sont appelées ici. Directement ou indirectement.
main() ->
    Liste = lireFichier("expression.csv"),
    Expressions = lignesVersExpressions(Liste),
    Expr = lists:droplast(io:get_line("Entrez une expression: ")),
    Match = trouverExpression(Expressions, Expr),
    io:fwrite(Match#expr.signification ++ "\n"),
    Phrase = obtenirPhraseInterrogative(lists:droplast(io:get_line("Entrez une phrase à convertir en phrase interrogative (ne pas mettre de point à la fin): "))),
    io:fwrite(Phrase),
    Quiz = obtenirQuiz(),
    io:fwrite("Répondez aux questions suivantes soit par \"V\" pour \"Vrai\" ou \"F\" pour \"Faux\":\n"),
    Score = jouerQuiz(Quiz),
    io:fwrite("Vous avez obtenu un score de " ++ io_lib:format("~p", [Score]) ++ " sur 5.\n").

