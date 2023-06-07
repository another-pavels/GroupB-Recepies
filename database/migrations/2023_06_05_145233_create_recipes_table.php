<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('recipes', function (Blueprint $table) {
            $table->id();
            $table->text('user_prompt');
            $table->string('name')->nullable();
            $table->json('instructions')->nullable();
            $table->json('nutrition')->nullable();
            $table->string('image_prompt')->nullable();
            $table->integer('recipe_status')->default(0);
            $table->integer('image_status')->default(0);
            // status 0 = pending, 1 = in progress, 2 = ready, 3 = failed
            $table->timestamps();
            $table->unsignedBigInteger('created_by')->nullable();
            $table->unsignedBigInteger('updated_by')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('recipes');
    }
};
