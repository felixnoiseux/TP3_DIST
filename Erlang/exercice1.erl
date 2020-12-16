% Auteur: Félix Noiseux
-module(exercice1).
-import(lists, [max/1, sublist/2, sum/1]).
-include("livre.hrl").
-export([ex1/0]).	

sum(Func, Data, Acc) ->
    lists:foldr(Func, Acc, Data).

ex1()->
	%%Création de livres
	L1 = #livre{isbn="9783425040639",titre="Letranger", auteur1="Albert", auteur2="", edition="Edition Christian",prix_achat=10.0, prix_vente=20.0, nombre_exemplaires_initial = 25, nombre_exemplaires_actuel=10 },
	L2 = #livre{isbn="8883425040639",titre="La vie d'esclave au college", auteur1="Felix Noiseux", auteur2="Raphael Lapointe", edition="Beliveau Editeur",prix_achat=5.0, prix_vente=15.0, nombre_exemplaires_initial = 50, nombre_exemplaires_actuel=30 },
	L3 = #livre{isbn="1243432459039",titre="Developpement Agile", auteur1="Stephane Denis", auteur2="Albert", edition="La courte echelle",prix_achat=20.0, prix_vente=35.0, nombre_exemplaires_initial = 10, nombre_exemplaires_actuel=1 },
	L4 = #livre{isbn="0941731348877",titre="Apprendre Java", auteur1="Giovana", auteur2="", edition="Flammarion Quebec",prix_achat=2.0, prix_vente=5.0, nombre_exemplaires_initial = 20, nombre_exemplaires_actuel=17 },
	L5 = #livre{isbn="4894794128472",titre="Lenigme de l'Atlantide", auteur1="Edouard Brassey", auteur2="", edition="Front Froid",prix_achat=1.0, prix_vente=2.0, nombre_exemplaires_initial = 1, nombre_exemplaires_actuel=1 },
	%%Création de plusieurs listes concernant les informations demandés
	LstLivres = [L1, L2, L3, L4, L5],
    LstLivresPlusCher = lists:sort(fun (A, B) -> A#livre.prix_vente >= B#livre.prix_vente end, LstLivres),
    LstLivresMoinsCher = lists:sort(fun (A, B) -> A#livre.prix_vente =< B#livre.prix_vente end, LstLivres),
	LstLivresPlusVendus = lists:sort(fun (A, B) -> (A#livre.nombre_exemplaires_initial - A#livre.nombre_exemplaires_actuel) >= (B#livre.nombre_exemplaires_initial - B#livre.nombre_exemplaires_actuel) end, LstLivres),
	LstLivresMoinsVendus = lists:sort(fun (A, B) -> (A#livre.nombre_exemplaires_initial - A#livre.nombre_exemplaires_actuel) =< (B#livre.nombre_exemplaires_initial - B#livre.nombre_exemplaires_actuel) end, LstLivres),
	LstLivresPlusVendusFinal = sublist(LstLivresPlusVendus, length(LstLivresPlusVendus)div 2), 
	LstLivresMoinsVendusFinal = sublist(LstLivresMoinsVendus, (length(LstLivresPlusVendus) + 1) div 2),
	LstLivresMeilleursProfits = lists:sort(fun (A, B) -> 
	((A#livre.prix_vente - A#livre.prix_achat)*(A#livre.nombre_exemplaires_initial - A#livre.nombre_exemplaires_actuel)) >=
	((B#livre.prix_vente - B#livre.prix_achat)*(B#livre.nombre_exemplaires_initial - B#livre.nombre_exemplaires_actuel))end, LstLivres),
	%%Affichage des informations demandés
	io:format("~n~n ==========TITRES DES LIVRES LES PLUS CHERS========== ~n~n"),
	lists:foreach(fun(Y) -> erlang:display("Titre: " ++ Y#livre.titre ++ ", Prix: " ++ float_to_list(Y#livre.prix_vente, [{decimals, 2}]) ++ "$")end, LstLivresPlusCher),
	timer:sleep(1000),
	io:format("~n~n ==========LIVRES LES MOINS CHERS==========  ~n~n"),
	lists:foreach(fun(Y) -> erlang:display("Titre: " ++ Y#livre.titre ++ ", Prix: " ++ float_to_list(Y#livre.prix_vente, [{decimals, 2}]) ++ "$")end, LstLivresMoinsCher),
	timer:sleep(1000),
	io:format("~n~n ==========LIVRES LES PLUS VENDUS=========== ~n~n"),
	lists:foreach(fun(Y) -> erlang:display("Titre: " ++ Y#livre.titre ++ ", Quantite vendu: " ++ integer_to_list(Y#livre.nombre_exemplaires_initial - Y#livre.nombre_exemplaires_actuel))end, LstLivresPlusVendus),
	timer:sleep(1000),
	io:format("~n~n ==========LIVRES LES MOINS VENDUS=========== ~n~n"),
	lists:foreach(fun(Y) -> erlang:display("Titre: " ++ Y#livre.titre ++ ", Quantite vendu: " ++ integer_to_list(Y#livre.nombre_exemplaires_initial - Y#livre.nombre_exemplaires_actuel))end, LstLivresMoinsVendus),
	timer:sleep(1000),
	io:format("~n~n ==============AUGMENTATION DE 10% DU PRIX DE VENTES DES 2 PREMIERS LIVRES LES PLUS POPULAIRES============== n~n"),
	lists:foreach(fun(Y) -> erlang:display("Titre: " ++ Y#livre.titre ++ ", Quantite vendu: " ++ 
											integer_to_list(Y#livre.nombre_exemplaires_initial - Y#livre.nombre_exemplaires_actuel) ++ 
											", PrixVente Initial : " ++ float_to_list(Y#livre.prix_vente, [{decimals, 2}]) ++ ", PrixVente Augmente: " ++ 
											float_to_list(Y#livre.prix_vente * 1.10, [{decimals, 2}]))end, LstLivresPlusVendusFinal),
	timer:sleep(1000),
	io:format("~n~n ==============DIMINUTION DE 10% DU PRIX DE VENTES DES 3 PREMIERS LIVRES LES MOINS POPULAIRES============== ~n~n"),
	lists:foreach(fun(Y) -> erlang:display("Titre: " ++ Y#livre.titre ++ ", Quantite vendu: " ++ 
											integer_to_list(Y#livre.nombre_exemplaires_initial - Y#livre.nombre_exemplaires_actuel) ++ 
											", PrixVente Initial : " ++ float_to_list(Y#livre.prix_vente, [{decimals, 2}]) ++ ", PrixVente Diminue: " ++ 
											float_to_list(Y#livre.prix_vente *0.9, [{decimals, 2}]))end, LstLivresMoinsVendusFinal),
	timer:sleep(1000),
	io:format("~n~n ==============Afficher les ISBN et les titres des livres dun auteur saisi au clavier============== ~n~n"),
	{ok, [NOM_AUTEUR]} = io:fread("Entrer le nom de auteur1 ou auteur2 ~n ", "~s"),
	lists:foreach(fun(X) -> if X#livre.auteur1 == NOM_AUTEUR  -> erlang:display("ISBN: " ++ X#livre.isbn ++ 
																			   ", Titre: " ++ X#livre.titre ++ 
																			   ", Auteur1: " ++ X#livre.auteur1 ++
																			   ", Auteur2: " ++ X#livre.auteur2); 
					          X#livre.auteur2 == NOM_AUTEUR  -> erlang:display("ISBN: " ++ X#livre.isbn ++ 
																			   ", Titre: " ++ X#livre.titre ++ 
																			   ", Auteur1: " ++ X#livre.auteur1 ++
																			   ", Auteur2: " ++ X#livre.auteur2); 
								true -> ok end end, LstLivres),
	timer:sleep(1000),
	io:format("~n~n ==============Titres des livres ayant genere le meilleur profit============== ~n~n"),
	lists:foreach(fun(Y) -> erlang:display("Titre: " ++ Y#livre.titre ++ ", Profite genere: " ++ float_to_list(((Y#livre.prix_vente - Y#livre.prix_achat)*(Y#livre.nombre_exemplaires_initial - Y#livre.nombre_exemplaires_actuel)), [{decimals, 2}]) ++ "$")end, LstLivresMeilleursProfits),
	io:format("~n~n ==============Chiffre daffaires en vendant tous vos livres============== ~n~n"),
	erlang:display("chiffre daffaire: " ++ float_to_list(sum(fun(X, Acc) -> ((X#livre.prix_vente - X#livre.prix_achat) * (X#livre.nombre_exemplaires_initial)) + Acc end, LstLivres, 0), [{decimals, 2}]) ++"$").

