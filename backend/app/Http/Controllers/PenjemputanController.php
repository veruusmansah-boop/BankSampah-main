<?php

namespace App\Http\Controllers;

use App\Models\Penjemputan;
use App\Models\PenjemputanDetail;
use App\Models\JenisSampah;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class PenjemputanController extends Controller
{
    use ApiResponse;

    // 1. AJUKAN PENJEMPUTAN BARU
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'tanggal' => 'required|date|after_or_equal:today',
            'sesi' => 'required|in:PAGI,SIANG,SORE',
            'lokasi' => 'required|string|max:255',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            'catatan' => 'nullable|string',
            'items' => 'required|array|min:1',
            'items.*.jenis_sampah_id' => 'required|exists:jenis_sampahs,id',
            'items.*.berat_estimasi' => 'required|numeric|min:0.1',
        ]);

        if ($validator->fails()) {
            return $this->errorResponse('Validasi gagal', 422, $validator->errors());
        }

        $user = $request->user();

        // Gunakan transaction agar data konsisten
        try {
            $penjemputan = DB::transaction(function () use ($request, $user) {
                // Buat penjemputan utama
                $penjemputan = Penjemputan::create([
                    'user_id' => $user->id,
                    'tanggal' => $request->tanggal,
                    'sesi' => $request->sesi,
                    'lokasi' => $request->lokasi,
                    'latitude' => $request->latitude,
                    'longitude' => $request->longitude,
                    'status' => 'DIAJUKAN',
                    'catatan' => $request->catatan,
                    'total_berat' => 0,
                    'total_harga' => 0,
                ]);

                $totalBerat = 0;
                $totalHarga = 0;

                // Loop items untuk buat detail
                foreach ($request->items as $item) {
                    $jenisSampah = JenisSampah::find($item['jenis_sampah_id']);
                    $berat = $item['berat_estimasi'];
                    $hargaPerKg = $jenisSampah->harga_per_kg;
                    $subtotal = $berat * $hargaPerKg;

                    PenjemputanDetail::create([
                        'penjemputan_id' => $penjemputan->id,
                        'jenis_sampah_id' => $jenisSampah->id,
                        'berat_estimasi' => $berat,
                        'harga_per_kg' => $hargaPerKg,
                        'subtotal' => $subtotal,
                    ]);

                    $totalBerat += $berat;
                    $totalHarga += $subtotal;
                }

                // Update total di penjemputan utama
                $penjemputan->update([
                    'total_berat' => $totalBerat,
                    'total_harga' => $totalHarga,
                ]);

                return $penjemputan->load(['details.jenisSampah', 'user']);
            });

            return $this->successResponse($penjemputan, 'Penjemputan berhasil diajukan', 201);

        } catch (\Exception $e) {
            return $this->errorResponse('Gagal membuat penjemputan: ' . $e->getMessage(), 500);
        }
    }

    // 2. LIST PENJEMPUTAN USER
    public function index(Request $request)
    {
        $user = $request->user();

        $penjemputans = Penjemputan::where('user_id', $user->id)
            ->with(['details.jenisSampah'])
            ->orderBy('created_at', 'desc')
            ->get();

        return $this->successResponse($penjemputans, 'Riwayat penjemputan berhasil diambil');
    }

    // 3. DETAIL PENJEMPUTAN
    public function show(Request $request, $id)
    {
        $user = $request->user();

        $penjemputan = Penjemputan::where('id', $id)
            ->where('user_id', $user->id)
            ->with(['details.jenisSampah', 'kurir'])
            ->first();

        if (!$penjemputan) {
            return $this->errorResponse('Penjemputan tidak ditemukan', 404);
        }

        return $this->successResponse($penjemputan, 'Detail penjemputan berhasil diambil');
    }

    // 4. UPDATE STATUS (Untuk Kurir/Admin)
    public function updateStatus(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'status' => 'required|in:DITERIMA,DALAM PROSES,DIJEMPUT,SELESAI,DIBATALKAN',
        ]);

        if ($validator->fails()) {
            return $this->errorResponse('Validasi gagal', 422, $validator->errors());
        }

        $penjemputan = Penjemputan::find($id);

        if (!$penjemputan) {
            return $this->errorResponse('Penjemputan tidak ditemukan', 404);
        }

        $penjemputan->update(['status' => $request->status]);

        return $this->successResponse($penjemputan, 'Status berhasil diupdate');
    }

    // 5. BATALKAN PENJEMPUTAN (User sendiri)
    public function batal(Request $request, $id)
    {
        $user = $request->user();

        $penjemputan = Penjemputan::where('id', $id)
            ->where('user_id', $user->id)
            ->first();

        if (!$penjemputan) {
            return $this->errorResponse('Penjemputan tidak ditemukan', 404);
        }

        // Hanya bisa dibatalkan jika status masih DIAJUKAN
        if ($penjemputan->status !== 'DIAJUKAN') {
            return $this->errorResponse('Hanya penjemputan dengan status DIAJUKAN yang bisa dibatalkan', 400);
        }

        $penjemputan->update(['status' => 'DIBATALKAN']);

        return $this->successResponse($penjemputan, 'Penjemputan berhasil dibatalkan');
    }
}