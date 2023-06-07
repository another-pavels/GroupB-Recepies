<?php

namespace App\Jobs;

use App\Models\Recipe;
use App\Services\OpenAiService;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldBeUnique;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Storage;

class GenerateDishImage implements ShouldQueue
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
        $this->recipe->update(['image_status' => 1]);
        $prompt = $this->recipe->image_prompt;

        try {
            $url = OpenAiService::generateImage($prompt);
            //fetch image and save it to storage
            $client = new \GuzzleHttp\Client();
            $response = $client->get($url);
            $image = $response->getBody()->getContents();
            $path = 'recipes/' . $this->recipe->id . '.png';
            Storage::put($path, $image);

            $this->recipe->update([
                'image_status' => 2,
            ]);

        } catch (\Throwable $th) {
            $this->recipe->update([
                'image_status' => 3,
            ]);
            throw $th;
        }


    }
}
