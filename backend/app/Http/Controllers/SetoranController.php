<?php

namespace App\Http\Controllers;

use App\Models\SetoranSampah;
use App\Models\JenisSampah;
use App\Models\DropPoint;
use App\Models\Transaksi;
use App\Models\Riwayat;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class SetoranController extends Controller
{
    use ApiResponse;

    // 1. CATAT SETORAN BARU
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'drop_point_id' => 'required|exists:drop_points,id',
            'jenis_sampah_id' => 'required|exists:jenis_sampahs,id',
            'berat' => 'required|numeric|min:0.1',
        ]);

        if ($validator->fails()) {
            return $this->errorResponse('Validasi gagal', 422, $validator->errors());
        }

        $user = $request->user();

        try {
            $setoran = DB::transaction(function () use ($request, $user) {
                $jenisSampah = JenisSampah::find($request->jenis_sampah_id);
                $berat = $request->berat;
                $hargaPerKg = $jenisSampah->harga_per_kg;
                $subtotal = $berat * $hargaPerKg;

                // Buat setoran
                $setoran = SetoranSampah::create([
                    'user_id' => $user->id,
                    'drop_point_id' => $request->drop_point_id,
                    'jenis_sampah_id' => $jenisSampah->id,
                    'berat' => $berat,
                    'harga_per_kg' => $hargaPerKg,
                    'subtotal' => $subtotal,
                    'status' => 'SELESAI',
                ]);

                // Tambah saldo user
                $user->increment('saldo', $subtotal);
                
                // Tambah poin hijau (1 poin per 1000 rupiah)
                $poin = floor($subtotal / 1000);
                $user->increment('poin_hijau', $poin);

                // Catat transaksi
                Transaksi::create([
                    'user_id' => $user->id,
                    'tipe' => 'masuk',
                    'nominal' => $subtotal,
                    'keterangan' => "Setoran {$jenisSampah->nama} seberat {$berat}kg",
                    'referensi_type' => 'setoran',
                    'referensi_id' => $setoran->id,
                ]);

                // Catat riwayat
                Riwayat::create([
                    'user_id' => $user->id,
                    'aktivitas' => 'Setor Sampah',
                    'referensi_type' => 'setoran',
                    'referensi_id' => $setoran->id,
                    'deskripsi' => "Menyetor {$jenisSampah->nama} seberat {$berat}kg ke {$request->drop_point_id}",
                ]);

                return $setoran->load(['jenisSampah', 'dropPoint']);
            });

            return $this->successResponse($setoran, 'Setoran berhasil dicatat', 201);

        } catch (\Exception $e) {
            return $this->errorResponse('Gagal mencatat setoran: ' . $e->getMessage(), 500);
        }
    }

    // 2. RIWAYAT SETORAN USER
    public function index(Request $request)
    {
        $user = $request->user();

        $setoran = SetoranSampah::where('user_id', $user->id)
            ->with(['jenisSampah', 'dropPoint'])
            ->orderBy('created_at', 'desc')
            ->get();

        return $this->successResponse($setoran, 'Riwayat setoran berhasil diambil');
    }
}