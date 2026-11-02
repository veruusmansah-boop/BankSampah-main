<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    // Kolom yang boleh diisi massal
    protected $fillable = [
        'nama', 'username', 'email', 'password', 'role', 
        'saldo', 'poin_hijau', 'login_attempts', 'locked_until', 
        'no_hp', 'alamat', 'foto_profil'
    ];

    // Kolom yang disembunyikan saat return JSON (keamanan)
    protected $hidden = [
        'password',
        'remember_token',
    ];

    // Konversi tipe data otomatis
    protected $casts = [
        'password' => 'hashed',
        'saldo' => 'decimal:2',
        'locked_until' => 'datetime',
    ];

    // --- RELASI ---
    public function penjemputans() {
        return $this->hasMany(Penjemputan::class, 'user_id');
    }
    public function transaksis() {
        return $this->hasMany(Transaksi::class);
    }
    public function riwayats() {
        return $this->hasMany(Riwayat::class);
    }

    // --- HELPER LOGIKA LOGIN (Sesuai Proposal) ---
    public function isLocked() {
        return $this->locked_until && $this->locked_until->isFuture();
    }

    public function resetLoginAttempts() {
        $this->update(['login_attempts' => 0, 'locked_until' => null]);
    }

    public function incrementLoginAttempts() {
        $attempts = $this->login_attempts + 1;
        if ($attempts >= 3) {
            $this->update([
                'login_attempts' => $attempts,
                'locked_until' => now()->addMinutes(5) // Kunci 5 menit
            ]);
        } else {
            $this->update(['login_attempts' => $attempts]);
        }
    }
}