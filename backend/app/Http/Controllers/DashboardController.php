<?php

namespace App\Http\Controllers;

use App\Models\Penjemputan;
use App\Models\Transaksi;
use App\Models\Riwayat;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    use ApiResponse;

    // 1. DASHBOARD (Ringkasan Beranda)
    public function index(Request $request)
    {
        $user = $request->user();

        // Hitung jumlah penjemputan berdasarkan status
        $totalPenjemputan = Penjemputan::where('user_id', $user->id)->count();
        $penjemputanAktif = Penjemputan::where('user_id', $user->id)
            ->whereIn('status', ['DIAJUKAN', 'DITERIMA', 'DALAM PROSES'])
            ->count();
        $penjemputanSelesai = Penjemputan::where('user_id', $user->id)
            ->where('status', 'SELESAI')
            ->count();

        // Hitung total transaksi
        $totalTransaksiMasuk = Transaksi::where('user_id', $user->id)
            ->where('tipe', 'masuk')
            ->sum('nominal');
        $totalTransaksiKeluar = Transaksi::where('user_id', $user->id)
            ->where('tipe', 'keluar')
            ->sum('nominal');

        return $this->successResponse([
            'user' => [
                'nama' => $user->nama,
                'username' => $user->username,
                'saldo' => $user->saldo,
                'poin_hijau' => $user->poin_hijau,
            ],
            'statistik' => [
                'total_penjemputan' => $totalPenjemputan,
                'penjemputan_aktif' => $penjemputanAktif,
                'penjemputan_selesai' => $penjemputanSelesai,
                'total_transaksi_masuk' => $totalTransaksiMasuk,
                'total_transaksi_keluar' => $totalTransaksiKeluar,
            ],
        ], 'Data dashboard berhasil diambil');
    }

    // 2. RIWAYAT AKTIVITAS
    public function aktivitas(Request $request)
    {
        $user = $request->user();

        $riwayat = Riwayat::where('user_id', $user->id)
            ->orderBy('created_at', 'desc')
            ->limit(20)
            ->get();

        return $this->successResponse($riwayat, 'Riwayat aktivitas berhasil diambil');
    }

    // 3. INFO SALDO + RIWAYAT TRANSAKSI
    public function saldo(Request $request)
    {
        $user = $request->user();

        $transaksi = Transaksi::where('user_id', $user->id)
            ->orderBy('created_at', 'desc')
            ->limit(50)
            ->get();

        return $this->successResponse([
            'saldo' => $user->saldo,
            'poin_hijau' => $user->poin_hijau,
            'transaksi' => $transaksi,
        ], 'Info saldo berhasil diambil');
    }
}