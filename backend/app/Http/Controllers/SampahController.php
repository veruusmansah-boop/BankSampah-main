<?php

namespace App\Http\Controllers;

use App\Models\JenisSampah;
use App\Traits\ApiResponse;

class SampahController extends Controller
{
    use ApiResponse;

    // Ambil semua jenis sampah
    public function index()
    {
        $sampah = JenisSampah::all();
        return $this->successResponse($sampah, 'Data jenis sampah berhasil diambil');
    }

    // Ambil detail 1 jenis sampah
    public function show($id)
    {
        $sampah = JenisSampah::find($id);
        
        if (!$sampah) {
            return $this->errorResponse('Jenis sampah tidak ditemukan', 404);
        }

        return $this->successResponse($sampah, 'Detail jenis sampah berhasil diambil');
    }
}