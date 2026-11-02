<?php

namespace Database\Seeders;

use App\Models\JenisSampah;
use App\Models\DropPoint;
use App\Models\User; // <-- TAMBAHKAN INI
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash; // <-- TAMBAHKAN INI

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // 0. Isi Data User Dummy (Nasabah)
        User::create([
            'nama' => 'Nesa PM',
            'username' => 'nesa123',
            'email' => 'nesa@regreen.com',
            'password' => Hash::make('password123'),
            'role' => 'nasabah',
            'no_hp' => '081234567890',
        ]);

        // 1. Isi Data Jenis Sampah
        JenisSampah::create([
            'nama' => 'Plastik',
            'kategori' => 'Anorganik',
            'harga_per_kg' => 2000,
            'deskripsi' => 'Botol plastik, wadah makanan, dll.'
        ]);
        JenisSampah::create([
            'nama' => 'Kertas',
            'kategori' => 'Anorganik',
            'harga_per_kg' => 1500,
            'deskripsi' => 'Kardus, koran, buku bekas.'
        ]);
        JenisSampah::create([
            'nama' => 'Logam',
            'kategori' => 'Anorganik',
            'harga_per_kg' => 5000,
            'deskripsi' => 'Kaleng aluminium, besi bekas.'
        ]);
        JenisSampah::create([
            'nama' => 'Organik',
            'kategori' => 'Organik',
            'harga_per_kg' => 500,
            'deskripsi' => 'Sisa makanan, daun kering.'
        ]);

        // 2. Isi Data Drop Point
        DropPoint::create([
            'nama' => 'TPS Kecamatan Menteng',
            'alamat' => 'Jl. Menteng Raya No. 1, Jakarta Pusat',
            'latitude' => -6.1944,
            'longitude' => 106.8317,
            'jam_buka' => '08:00',
            'jam_tutup' => '17:00',
            'kontak' => '081234567890'
        ]);
        DropPoint::create([
            'nama' => 'Bank Sampah Induk',
            'alamat' => 'Jl. Sudirman No. 5, Jakarta Selatan',
            'latitude' => -6.2088,
            'longitude' => 106.8456,
            'jam_buka' => '09:00',
            'jam_tutup' => '16:00',
            'kontak' => '089876543210'
        ]);
    }
}