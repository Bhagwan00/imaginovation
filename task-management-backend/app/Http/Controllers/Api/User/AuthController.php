<?php

namespace App\Http\Controllers\Api\User;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required'
        ]);

        if (!Auth::attempt($request->only('email', 'password'))) {
            return response()->json([
                'status' => false,
                'message' => 'Invalid login details'
            ], 401);
        }

        $user = User::where('email', $request->email)->first();

        $token = $user->createToken('auth_token', ['user'])->plainTextToken;

        return response()->json([
            'status' => true,
            'token' => $token,
            'token_type' => 'Bearer',
            'user' => $user,
            'message' => 'Login successfully'
        ]);
    }

    public function logout()
    {
        try {
            //code...
            auth()->user()->tokens()->delete();

            return response()->json([
                'status' => true,
                'message' => 'Logout successfully',
            ]);
        } catch (\Throwable $th) {
            return response()->json([
                'status' => false,
                'message' => 'Logout failed',
            ], 500);
        }
    }
}

