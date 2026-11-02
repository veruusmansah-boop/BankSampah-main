<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Riwayat extends Model {
    use HasFactory;
    protected $fillable = ['user_id', 'aktivitas', 'referensi_type', 'referensi_id', 'deskripsi'];

    public function user() { return $this->belongsTo(User::class); }
}