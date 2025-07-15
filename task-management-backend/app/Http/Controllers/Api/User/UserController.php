<?php

namespace App\Http\Controllers\Api\User;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;

class UserController extends Controller
{
    public function index() {
        $users = User::where('id', '!=', request()->user()->id)->orderBy('name')->get();

        return response()->json($users);
    }

    public function show() {
        $user = request()->user();
        if(!$user) {
            return response()->json([
                'status' => false,
                'message' => 'User not found'
            ], 404);
        }else{
            return response()->json([
                'status' => true,
                'user' => $user
            ]);
        }
    }
}
