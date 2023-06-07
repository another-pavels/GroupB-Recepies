<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use GuzzleHttp\Client;
use Illuminate\Support\Str;

use function PHPUnit\Framework\returnSelf;

class TestController extends Controller
{
    public function index()
    {
        $prompt = "Plated image of a bowl of cheddar spring onion dumplings with a side of sour cream.";

        $response = Http::withHeaders([
            'Authorization' => 'Bearer ' . env('GPT_API_KEY'),
            'Content-Type' => 'application/json',
        ])->timeout(60)
        ->post(env('GPT_API_URL') . 'images/generations', [
            'prompt' => $prompt,
            'n' => 1,
            'size' => '256x256',
        ]);

        // rewrite this to use GuzzleHttp\Client
        // $client = new Client([])

        return $response->json()['data'][0]['url'];

        return 'Hello World';
    }
}
