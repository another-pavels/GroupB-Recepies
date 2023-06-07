<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Str;

class OpenAiService {
    public static function generateRecipe (string $prompt)
    {
        $text = static::promptGpt($prompt);
        return static::parseRecipe($text);
    }

    private static function promptGpt(string $prompt)
    {
        $prompt .= "Provide list of ingredients, step by step instructions, nutritional information, as well as prompt to use to generate image for recipe. ".
        "Give response in following format 'name: name value|ingredients: *first ingredient - quantity * second ingredient - quantity * third ingredient - ".
        "quantity|instructions: *first instruction *second instruction *third instruction|nutrition: *calories - value *fat - value *carbs - value *protein - ".
        "value|imagePrompt: image prompt value' no fomattig or line breaks";

        $response = Http::withHeaders([
            'Authorization' => 'Bearer ' . env('GPT_API_KEY'),
            'Content-Type' => 'application/json',
        ])->timeout(60)
        ->post(env('GPT_API_URL') . 'completions', [
            'model' => env('GPT_MODEL'),
            'prompt' => $prompt,
            'max_tokens' => 1000,
        ]);

        if ($response->failed()) {
            return $response->throw();
        }

        return $response->json()['choices'][0]['text'];
    }

    static function parseRecipe(string $text)
    {
        $text = str_replace("\n", '', $text);
        $text = str_replace(": ", ':', $text);
        $array = explode('|', $text);
        $input = [];

        foreach ($array as $a) {
            $parts = explode(':', $a);
            $key = Str::snake($parts[0]);
            $value = trim($parts[1]);

            if(in_array($key, ['ingredients', 'instructions', 'nutrition'])){
                $value = explode('*', $value);
                array_shift($value);
            }

            if ($key == 'ingredients') {
                $ingredients = [];
                foreach ($value as $k => $v) {
                    $v = explode('-', $v);
                    $v = array_map('trim', $v);
                    $ingredients[$k]['name'] = $v[0];
                    $ingredients[$k]['quantity'] = $v[1];
                }
                $value = $ingredients;
            }

            $input[$key] = $value;
        }

        return $input;
    }

    public static function generateImage(string $prompt)
    {
        $response = Http::withHeaders([
            'Authorization' => 'Bearer ' . env('GPT_API_KEY'),
            'Content-Type' => 'application/json',
        ])->timeout(60)
        ->post(env('GPT_API_URL') . 'images/generations', [
            'prompt' => $prompt,
            'n' => 1,
            'size' => '256x256',
        ]);

        return $response->json()['data'][0]['url'];
    }
}
