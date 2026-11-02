<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{
    use ApiResponse;

    // 1. REGISTER
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nama' => 'required|string|max:255',
            'username' => 'required|string|max:50|unique:users',
            'email' => 'required|email|unique:users',
            'password' => 'required|string|min:6|confirmed',
            'no_hp' => 'nullable|string|max:20',
        ]);

        if ($validator->fails()) {
            return $this->errorResponse('Validasi gagal', 422, $validator->errors());
        }

        $user = User::create([
            'nama' => $request->nama,
            'username' => $request->username,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'role' => 'nasabah',
            'no_hp' => $request->no_hp,
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return $this->successResponse([
            'user' => $user,
            'token' => $token,
        ], 'Registrasi berhasil', 201);
    }

    // 2. LOGIN (Dengan Logika 3x Gagal)
    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'password' => 'required|string',
        ]);

        if ($validator->fails()) {
            return $this->errorResponse('Validasi gagal', 422, $validator->errors());
        }

        $user = User::where('email', $request->email)->first();

        // Cek apakah user ada
        if (!$user) {
            return $this->errorResponse('Email tidak terdaftar', 401);
        }

        // Cek apakah akun sedang terkunci
        if ($user->isLocked()) {
            return $this->errorResponse(
                'Akun terkunci 5 menit karena terlalu banyak percobaan gagal. Silakan gunakan Lupa Password.',
                429
            );
        }

               // Cek password
        if (!Hash::check($request->password, $user->password)) {
            $user->incrementLoginAttempts(); 
            
            // Refresh model agar membaca data terbaru dari database
            $user->refresh(); 
            
            $remainingAttempts = 3 - $user->login_attempts;
            
            if ($user->login_attempts >= 3) {
                return $this->errorResponse(
                    'Akun terkunci 5 menit. Silakan reset password.',
                    429
                );
            }

            return $this->errorResponse(
                "Password salah. Sisa percobaan: {$remainingAttempts}",
                401
            );
        }

        // Login Berhasil -> Reset counter
        $user->resetLoginAttempts();
        $token = $user->createToken('auth_token')->plainTextToken;

        return $this->successResponse([
            'user' => $user,
            'token' => $token,
        ], 'Login berhasil');
    }

    // 3. LOGOUT
    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();
        return $this->successResponse(null, 'Logout berhasil');
    }

    // 4. GET PROFILE
    public function profile(Request $request)
    {
        return $this->successResponse($request->user(), 'Data profil berhasil diambil');
    }

    // 5. UPDATE PROFILE
    public function updateProfile(Request $request)
    {
        $user = $request->user();

        $validator = Validator::make($request->all(), [
            'nama' => 'sometimes|string|max:255',
            'username' => 'sometimes|string|max:50|unique:users,username,' . $user->id,
            'no_hp' => 'nullable|string|max:20',
            'alamat' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return $this->errorResponse('Validasi gagal', 422, $validator->errors());
        }

        $user->update($request->only(['nama', 'username', 'no_hp', 'alamat']));
        return $this->successResponse($user, 'Profil berhasil diupdate');
    }
}