<?php

namespace App\Http\Controllers;

use App\Models\Recipe;
use App\Http\Requests\StoreRecipeRequest;
use App\Http\Requests\UpdateRecipeRequest;
use App\Jobs\GenerateRecipe;
use DeepCopy\Filter\Filter;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Yajra\DataTables\Facades\DataTables;

class RecipeController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return inertia('Recipes/Index');
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(StoreRecipeRequest $request)
    {
        $dietaryRestrictions = Str::length($request->dietaryRestrictions) > 0 ? "Dietary restrictions: $request->dietaryRestrictions." : null;
        $prompt = "Generate a recipe using ingredients: $request->ingredients. In style of $request->cuisine cuisine. $dietaryRestrictions ";
        $recipe = Recipe::create([
            'user_prompt' => $prompt,
        ]);
        GenerateRecipe::dispatch($recipe);

        // redirect inertia to recipe show page
        return redirect()->route('recipes.show', $recipe);
    }

    /**
     * Display the specified resource.
     */
    public function show(Recipe $recipe)
    {
        return inertia('Recipes/Show', [
            'recipe' => $recipe,
            'ingredients' => $recipe->ingredients,
            'creator' => $recipe->creator,
        ]);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Recipe $recipe)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateRecipeRequest $request, Recipe $recipe)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Recipe $recipe)
    {
        $recipe->ingredients()->detach();
        $recipe->delete();

        return redirect()->route('recipes.index');
    }

    public function getImage(Recipe $recipe)
    {
        return Storage::response("recipes/$recipe->id.png");
    }

    public function retry(Recipe $recipe)
    {
        $recipe->update([
            'recipe_status' => 0,
        ]);

        GenerateRecipe::dispatch($recipe);

        return redirect()->route('recipes.show', $recipe);
    }

    public function datatable()
    {
        $recipes = DB::table('recipes')
            ->leftJoin('ingredient_recipe', 'recipes.id', '=', 'ingredient_recipe.recipe_id')
            ->leftJoin('ingredients', 'ingredient_recipe.ingredient_id', '=', 'ingredients.id')
            ->leftJoin('users', 'recipes.created_by', '=', 'users.id')
            ->groupBy('recipes.id', 'recipes.name', 'recipes.recipe_status', 'recipes.created_at', 'users.name')
            ->select([
                'recipes.id',
                'recipes.name',
                'recipes.recipe_status',
                'recipes.created_at',
                'users.name as user',
                DB::raw('GROUP_CONCAT(ingredients.name SEPARATOR ", ") as ingredients')
            ]);

        return DataTables::of($recipes)
            ->editColumn('name', function ($recipe) {
                return $recipe->name? $recipe->name : 'Nepabeigta recepte #' . $recipe->id;
            })
            ->editColumn('recipe_status', function ($recipe) {
                return config('constants.recipe_statuses')[$recipe->recipe_status];
            })
            ->filterColumn('recipe_status', function ($query, $keyword) {
                $recipeStatuses = config('constants.recipe_statuses');
                // filter with case when then
                $query->whereRaw("CASE
                    WHEN recipes.recipe_status = 0 THEN '$recipeStatuses[0]'
                    WHEN recipes.recipe_status = 1 THEN '$recipeStatuses[1]'
                    WHEN recipes.recipe_status = 2 THEN '$recipeStatuses[2]'
                    WHEN recipes.recipe_status = 3 THEN '$recipeStatuses[3]'
                END LIKE ?", ["%{$keyword}%"]);
            })
            ->make(true);
    }
}
