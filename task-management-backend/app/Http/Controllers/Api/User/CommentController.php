<?php

namespace App\Http\Controllers\Api\User;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Comment;

class CommentController extends Controller
{
    public function index() {
        $data = Comment::latest()->cursorPaginate(request()->get('per_page', 10));

        return response()->json($data);
    }

    public function store(Request $request) {
        $validated = $request->validate([
            'message'           => 'required|string|max:255',
            'task_id'           => 'required',
        ]);

        try {
            $user = $request->user();
            if(!$user) {
                return response()->json([
                    'message' => 'User not found'
                ], 404);
            }else{
                $validated['user_id'] = $user->id;
            }
            $data = Comment::create($validated);

            return response()->json([
                'status' => true,
                'message' => 'Comment added successfully',
                'comment'   => $data
            ], 201);
        }catch (\Throwable $th) {
            return response()->json([
                'status' => false,
                'message' => 'Something went wrong',
                'error' => $th->getMessage()
            ], 500);
        }
    }
}
