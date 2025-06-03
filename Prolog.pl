%%% dishes
dish(tagliereFormaggi).
dish(tagliereSalumi).
dish(crescia).

dish(pastaPesto).
dish(pastaCarbonara).
dish(risottoPomodoro).

dish(pizzaMargherita).
dish(pizzaTonnoCipolla).
dish(pizzaDiavola).

dish(insalataLegumi).
dish(uovaSode).
dish(tagliataRosmarino).

%%% ingredients
ingredient(acqua).
ingredient(aglio).
ingredient(basilico).
ingredient(burro).
ingredient(caciotta).
ingredient(carne).
ingredient(ceci).
ingredient(cipolla).
ingredient(coppa).
ingredient(fagioli).
ingredient(farina).
ingredient(guanciale).
ingredient(lenticchie).
ingredient(mortadella).
ingredient(mozzarella).
ingredient(olio).
ingredient(parmigiano).
ingredient(pasta).
ingredient(pecorino).
ingredient(pepe).
ingredient(pomodoro).
ingredient(riso).
ingredient(rosmarino).
ingredient(salame).
ingredient(spianata).
ingredient(tonno).
ingredient(uova).

%%% attributes
%% has_attributes(Ingredient, CalorieCount, isGlutenFree, isLactoseFree, isVegetarian, Nuts, Soy, Peanuts, Eggs, Crustacean Shellfish)

has_attributes(acqua, 0, true, true, true).
has_attributes(aglio, 5, true, true, true).
has_attributes(basilico, 1, true, true, true).
has_attributes(burro, 102, true, false, true).
has_attributes(caciotta, 110, true, false, true).
has_attributes(carne, 250, true, true, false).
has_attributes(ceci, 180, true, true, true).
has_attributes(cipolla, 40, true, true, true).
has_attributes(coppa, 270, true, true, false).
has_attributes(fagioli, 120, true, true, true).
has_attributes(farina, 360, false, true, true).
has_attributes(guanciale, 300, true, true, false).
has_attributes(lenticchie, 115, true, true, true).
has_attributes(mortadella, 310, true, false, false).
has_attributes(mozzarella, 85, true, false, true).
has_attributes(olio, 120, true, true, true).
has_attributes(parmigiano, 110, true, false, true).
has_attributes(pasta, 220, false, true, true).
has_attributes(pecorino, 130, true, true, true).
has_attributes(pepe, 2, true, true, true).
has_attributes(pomodoro, 20, true, true, true).
has_attributes(riso, 200, true, true, true).
has_attributes(rosmarino, 3, true, true, true).
has_attributes(salame, 300, true, true, false).
has_attributes(spianata, 310, true, true, false).
has_attributes(tonno, 140, true, true, false).
has_attributes(uova, 70, true, true, true).

%%% recipes
has_ingredients(tagliereFormaggi, [caciotta, pecorino, parmigiano]).
has_ingredients(tagliereSalumi, [salame, mortadella, coppa]).
has_ingredients(crescia, [acqua, olio, farina, rosmarino]).

has_ingredients(pastaPesto, [pasta, olio, basilico, aglio, parmigiano]).
has_ingredients(pastaCarbonara, [guanciale, pecorino, uova, pasta, pepe]).
has_ingredients(risottoPomodoro, [riso, pomodoro, basilico, parmigiano, burro]).

has_ingredients(pizzaMargherita, [farina, olio, acqua, pomodoro, mozzarella, basilico]).
has_ingredients(pizzaTonnoCipolla, [farina, olio, acqua, tonno, cipolla]).
has_ingredients(pizzaDiavola, [farina, acqua, olio, spianata, pomodoro]).

has_ingredients(insalataLegumi, [ceci, lenticchie, fagioli, pepe, olio, cipolla]).
has_ingredients(uovaSode, [uova, olio, pepe]).
has_ingredients(tagliataRosmarino, [carne, olio, rosmarino, aglio]).

member(X,[X|_]).
member(X,[_|T]) :- member(X,T).
contains(Dish, Ingredient) :- dish(Dish), ingredient(Ingredient),
    has_ingredients(Dish, Ingredients), member(Ingredient, Ingredients).

%%% calorie count
calorieCount(Dish, TotalCalories) :-
    dish(Dish),
    has_ingredients(Dish, Ingredients),
    sum_ingredient_calories(Ingredients, TotalCalories).

sum_ingredient_calories([], 0).
sum_ingredient_calories([Ingr|Tail], Total) :-
    has_attributes(Ingr, Calories, _, _, _),
    sum_ingredient_calories(Tail, SubTotal),
    Total is Calories + SubTotal.

%%% filter
caloriesLessThan(Cal, Dish) :- dish(Dish), calorieCount(Dish, TotalCalories), TotalCalories < Cal. 
caloriesMoreThan(Cal, Dish) :- dish(Dish), calorieCount(Dish, TotalCalories), TotalCalories >= Cal.

isGlutenFree(Dish) :- dish(Dish), has_ingredients(Dish, Ingredients),
    all_gluten_free(Ingredients).

all_gluten_free([]).
all_gluten_free([Ingr|Tail]) :-
    has_attributes(Ingr, _, true, _, _),
    all_gluten_free(Tail).

isLactoseFree(Dish) :- dish(Dish), has_ingredients(Dish, Ingredients),
    all_lactose_free(Ingredients).

all_lactose_free([]).
all_lactose_free([Ingr|Tail]) :-
    has_attributes(Ingr, _, _, true, _),
    all_lactose_free(Tail).

isVegetarian(Dish) :- dish(Dish), has_ingredients(Dish, Ingredients),
    all_vegetarian(Ingredients).

all_vegetarian([]).
all_vegetarian([Ingr|Tail]) :-
    has_attributes(Ingr, _, _, _, true),
    all_vegetarian(Tail).

% satisfiesFilters(+MaxCalories, +GlutenFree, +LactoseFree, +Vegetarian, +ExcludedIngredients, ?Dish)
satisfiesFilters(MaxCal, GlutenFree, LactoseFree, Vegetarian, ExcludedIngredients, Dish) :-
    dish(Dish),
    calorieCount(Dish, TotalCalories),
    TotalCalories =< MaxCal,
    (GlutenFree == true -> isGlutenFree(Dish) ; true),
    (LactoseFree == true -> isLactoseFree(Dish) ; true),
    (Vegetarian == true -> isVegetarian(Dish) ; true),
    \+ (member(Ingredient, ExcludedIngredients), contains(Dish, Ingredient)).