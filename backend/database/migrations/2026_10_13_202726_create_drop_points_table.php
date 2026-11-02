<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('drop_points', function (Blueprint $table) {
            $table->id();
            $table->string('nama');
            $table->text('alamat');
            $table->decimal('latitude', 10, 7);
            $table->decimal('longitude', 10, 7);
            $table->time('jam_buka');
            $table->time('jam_tutup');
            $table->string('kontak');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('drop_points');
    }
};