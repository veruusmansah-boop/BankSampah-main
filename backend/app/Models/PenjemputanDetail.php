<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PenjemputanDetail extends Model
{
    use HasFactory;

    protected $fillable = [
        'penjemputan_id',
        'jenis_sampah_id',
        'berat_estimasi',
        'berat_aktual',
        'harga_per_kg',
        'subtotal',
    ];

    // Relasi ke JenisSampah
    public function jenisSampah() {
        return $this->belongsTo(JenisSampah::class);
    }

    // Relasi ke Penjemputan
    public function penjemputan() {
        return $this->belongsTo(Penjemputan::class);
    }
}