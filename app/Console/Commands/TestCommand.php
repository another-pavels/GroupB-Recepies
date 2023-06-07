<?php

namespace App\Console\Commands;

use App\Jobs\GenerateDishImage;
use App\Models\Ingredient;
use Illuminate\Console\Command;
use Illuminate\Http\File;
use Illuminate\Support\Facades\Storage;

class TestCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'app:test-command';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Command description';

    /**
     * Execute the console command.
     */
    public function handle()
    {

        // $url = "https://oaidalleapiprodscus.blob.core.windows.net/private/org-1eSpwXydUHNsJggOI1wBG8aZ/user-dKDGWxW5HTRTSWVJm2OsvSVX/img-fbG4zTBPVl9KdSOXtrRs9Ha0.png?st=2023-06-07T13%3A00%3A53Z&se=2023-06-07T15%3A00%3A53Z&sp=r&sv=2021-08-06&sr=b&rscd=inline&rsct=image/png&skoid=6aaadede-4fb3-4698-a8f6-684d7786b067&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2023-06-06T22%3A19%3A47Z&ske=2023-06-07T22%3A19%3A47Z&sks=b&skv=2021-08-06&sig=J5fN0qG6zBFOl9Gidn3la%2BIlDH8DAes3no3O84JMbZk%3D";
        // // //save image to storage

        // $client = new \GuzzleHttp\Client();
        // $response = $client->get($url);
        // $image = $response->getBody()->getContents();
        // $path = 'recipes/' . 5 . '.png';
        // Storage::put($path, $image);

        // return;
        $recipe = \App\Models\Recipe::find(4);

        GenerateDishImage::dispatch($recipe);
    }
}
