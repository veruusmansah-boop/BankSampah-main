<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Penjemputan extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'kurir_id',
        'tanggal',
        'sesi',
        'lokasi',
        'latitude',
        'longitude',
        'status',
        'total_berat',
        'total_harga',
        'catatan',
    ];

    // Relasi ke User (Nasabah)
    public function user() {
        return $this->belongsTo(User::class);
    }

    // Relasi ke Kurir
    public function kurir() {
        return $this->belongsTo(User::class, 'kurir_id');
    }

    // Relasi ke Detail Items
    public function details() {
        return $this->hasMany(PenjemputanDetail::class);
    }
}