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
                % On effectue un droplast sur la ligne pour enlever le changement de ligne à la fin.
                [lists:droplast(Ligne)] ++ lireLigne(ToutesLignes);
    eof -> []
end.

% Convertit les lignes lues dans la fonction lireFichier en enregistrements destinés à être manipulés dans la fonction main.
lignesVersExpressions([]) ->
    [];
lignesVersExpressions(Liste) ->
    Ligne = lists:nth(1, Liste),
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

obtenirPhraseInterrogative(Phrase) ->
    "".

genererQuestions() ->
    [
        #question{
            question = "La vitesse anémométrique d'une hirondelle dépend de son continent d'origine (Europe ou Afrique) (Ceux qui ont vu Monty Python and The Holy Grail comprendront la référence).",
            reponse = "V"
        },
        #question{question = "C# est un langage de programmation en tout point supérieur à Java.", reponse = "V"},
        #question{question = "Google a fait le bon choix en imposant aux développeurs Android d'utiliser le ScopedStorage.", reponse = "F"},
        #question{question = "Les prix des produits Apple sont toujours justifiés.", reponse = "F"},
        #question{question = "Dans Star Wars, les Jedis ont le droit de se marier.", reponse = "F"},
        #question{question = "Node.js est un bien meilleur outil de développement web qu'ASP.NET.", reponse = "V"},
        #question{question = "Dans le Seigneur des Anneaux, Aragorn a l'air plutôt jeune, mais en réalité, il a 87 ans!!!", reponse = "V"},
        #question{question = "En ce moment, vous pensez à une pomme.", reponse = "F"}
    ].

% Point d'entrée. Toute les autres fonctions sont appelées ici. Directement ou indirectement.
main() ->
    Liste = lireFichier("expression.csv"),
    Expressions = lignesVersExpressions(Liste),
    Expr = lists:droplast(io:get_line("Entrez une expression: ")),
    Match = trouverExpression(Expressions, Expr),
    io:fwrite(Match#expr.signification ++ "\n"),
    Phrase = obtenirPhraseInterrogative(lists:droplast(io:get_line("Entrez une phrase à convertir en phrase interrogative: "))),
    io:fwrite(Phrase).
