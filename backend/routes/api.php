<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\SampahController;
use App\Http\Controllers\DropPointController;
use App\Http\Controllers\PenjemputanController;
use App\Http\Controllers\SetoranController; // <-- TAMBAHKAN

// PUBLIC ROUTES
Route::post('/register', [AuthController::class, 'register'])->name('register');
Route::post('/login', [AuthController::class, 'login'])->name('login');

Route::get('/sampah', [SampahController::class, 'index']);
Route::get('/sampah/{id}', [SampahController::class, 'show']);
Route::get('/drop-points', [DropPointController::class, 'index']);
Route::get('/drop-points/{id}', [DropPointController::class, 'show']);

// PROTECTED ROUTES
Route::middleware('auth:sanctum')->group(function () {
    // Auth
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/profile', [AuthController::class, 'profile']);
    Route::put('/profile', [AuthController::class, 'updateProfile']);
    
    // Dashboard
    Route::get('/dashboard', [DashboardController::class, 'index']);
    Route::get('/aktivitas', [DashboardController::class, 'aktivitas']);
    Route::get('/saldo', [DashboardController::class, 'saldo']);

    // Penjemputan
    Route::post('/penjemputan', [PenjemputanController::class, 'store']);
    Route::get('/penjemputan', [PenjemputanController::class, 'index']);
    Route::get('/penjemputan/{id}', [PenjemputanController::class, 'show']);
    Route::put('/penjemputan/{id}/status', [PenjemputanController::class, 'updateStatus']);
    Route::put('/penjemputan/{id}/batal', [PenjemputanController::class, 'batal']);

    // SETORAN <-- TAMBAHKAN INI
    Route::post('/setoran', [SetoranController::class, 'store']);
    Route::get('/setoran', [SetoranController::class, 'index']);
});