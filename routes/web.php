<?php

use App\Http\Controllers\HomeController;
use App\Http\Controllers\ProfileController;
use App\Http\Controllers\RecipeController;
use App\Http\Controllers\TestController;
use Illuminate\Foundation\Application;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    if (! Auth::check()) {
        return redirect('/login');
    } else {
        return redirect('/home');
    }
});

Route::get('test', [TestController::class, 'index']);

Route::middleware('auth')->group(function () {
    Route::get('/home', [HomeController::class, 'index'])->name('home');

    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');

    Route::get('/recipes/datatable', [RecipeController::class, 'datatable'])->name('recipes.datatable');
    Route::get('/recipes/{recipe}/image', [RecipeController::class, 'getImage'])->name('recipes.image');
    Route::get('/recipes/{recipe}/retry', [RecipeController::class, 'retry'])->name('recipes.retry');
    Route::resource('recipes', RecipeController::class);
});

require __DIR__.'/auth.php';
