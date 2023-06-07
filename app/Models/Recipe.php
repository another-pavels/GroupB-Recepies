<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Wildside\Userstamps\Userstamps;
class Recipe extends Model
{
    use HasFactory, Userstamps;

    public $fillable = [
        'user_prompt',
        'name',
        'instructions',
        'nutrition',
        'image_prompt',
        'recipe_status',
        'image_status',
    ];

    protected $casts = [
        'instructions' => 'array',
        'nutrition' => 'array',
    ];

    public function ingredients()
    {
        return $this->belongsToMany(Ingredient::class)->withPivot('quantity');
    }
}
