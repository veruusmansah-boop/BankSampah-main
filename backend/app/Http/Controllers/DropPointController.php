<?php

namespace App\Http\Controllers;

use App\Models\DropPoint;
use App\Traits\ApiResponse;

class DropPointController extends Controller
{
    use ApiResponse;

    // Ambil semua drop point
    public function index()
    {
        $dropPoints = DropPoint::all();
        return $this->successResponse($dropPoints, 'Data drop point berhasil diambil');
    }

    // Ambil detail 1 drop point
    public function show($id)
    {
        $dropPoint = DropPoint::find($id);
        
        if (!$dropPoint) {
            return $this->errorResponse('Drop point tidak ditemukan', 404);
        }

        return $this->successResponse($dropPoint, 'Detail drop point berhasil diambil');
    }
}