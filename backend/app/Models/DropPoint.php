<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DropPoint extends Model {
    use HasFactory;
    protected $fillable = ['nama', 'alamat', 'latitude', 'longitude', 'jam_buka', 'jam_tutup', 'jenis_sampah_diterima', 'kontak'];
}