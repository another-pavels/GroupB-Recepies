<?php

namespace App\Jobs;

use App\Models\Ingredient;
use App\Models\Recipe;
use App\Services\OpenAiService;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldBeUnique;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;

class GenerateRecipe implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    protected $recipe;

    /**
     * Create a new job instance.
     */
    public function __construct(Recipe $recipe)
    {
        $this->recipe = $recipe;
    }

    /**
     * Execute the job.
     */
    public function handle(): void
    {
        try {
            $this->recipe->update(['recipe_status' => 1]);
            $recipeArray = OpenAiService::generateRecipe($this->recipe->user_prompt);

            foreach ($recipeArray['ingredients'] as $item) {
                $ingredient = Ingredient::firstOrCreate([
                    'name' => $item['name'],
                ]);

                $this->recipe->ingredients()->attach($ingredient->id, [
                    'quantity' => $item['quantity'],
                ]);
            }

            $this->recipe->update([
                'name' => $recipeArray['name'],
                'instructions' => $recipeArray['instructions'],
                'nutrition' => $recipeArray['nutrition'],
                'image_prompt' => $recipeArray['image_prompt'],
                'recipe_status' => 2,
            ]);

            GenerateDishImage::dispatch($this->recipe);
        } catch (\Throwable $th) {
            $this->recipe->update(['recipe_status' => 3]);
            throw $th;
        }
    }
}
