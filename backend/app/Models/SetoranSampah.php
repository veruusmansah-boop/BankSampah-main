<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SetoranSampah extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'drop_point_id',
        'jenis_sampah_id',
        'berat',
        'harga_per_kg',
        'subtotal',
        'status',
    ];

    // Relasi ke User
    public function user() {
        return $this->belongsTo(User::class);
    }

    // Relasi ke DropPoint
    public function dropPoint() {
        return $this->belongsTo(DropPoint::class);
    }

    // Relasi ke JenisSampah
    public function jenisSampah() {
        return $this->belongsTo(JenisSampah::class);
    }
}