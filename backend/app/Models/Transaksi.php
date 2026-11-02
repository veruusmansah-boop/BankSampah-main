<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Transaksi extends Model {
    use HasFactory;
    protected $fillable = ['user_id', 'tipe', 'nominal', 'keterangan', 'referensi_type', 'referensi_id'];
    protected $casts = ['nominal' => 'decimal:2'];

    public function user() { return $this->belongsTo(User::class); }
}