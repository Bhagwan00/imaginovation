<?php

namespace App\Http\Controllers\Api\User;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Task;
use App\Enums\PriorityLevel;
use App\Enums\Status;
use Illuminate\Validation\Rules\Enum;

class TaskController extends Controller
{

    public function index(Request $request) {
        $userId = $request->user()->id;

        $data = Task::with('comments', 'assigned_user', 'user')
        ->where(function ($query) use ($userId) {
            $query->where('user_id', $userId)
                    ->orWhere('assigned_to', $userId);
        })
        ->when($request->filled('status'), function ($query) use ($request) {
            $query->where('status', $request->status);
        })
        ->when($request->filled('priority'), function ($query) use ($request) {
            $query->where('priority', $request->priority);
        })
        ->when($request->filled('due_date'), function ($query) use ($request) {
            $query->whereDate('due_date', $request->due_date);
        })
        ->latest()
        ->cursorPaginate(request()->get('per_page', 10));

        return response()->json([
            'status' => true,
            'data' => $data
        ]);
    }

    public function store(Request $request) {
        $validated = $request->validate([
            'title'           => 'required|string|max:255',
            'description'     => 'required|string',
            'due_date'        => 'required|date|after:today',
            'priority'        => ['required', 'string', new Enum(PriorityLevel::class)],
            'status'          => ['required', 'string', new Enum(Status::class)],
        ]);

        try {
            $validated['user_id'] = $request->user()->id;
            $data = Task::create($validated);

            return response()->json([
                'status' => true,
                'message' => 'Task created successfully',
                'task'   => $data
            ], 201);
        }catch (\Throwable $th) {
            return response()->json([
                'status' => true,
                'message' => 'Something went wrong',
                'error' => $th->getMessage()
            ], 500);
        }
    }

    public function update(Request $request, Task $task) {
        $validated = $request->validate([
            'title'           => 'required|string|max:255',
            'description'     => 'required|string',
        ]);

        try {
            if($task->user_id != $request->user()->id) {
                return response()->json([
                    'status' => false,
                    'message' => 'Unauthorized - You are not allowed to update this task'
                ], 401);
            }


            $input = $request->all();
            $task->update($input);

            return response()->json([
                'status' => true,
                'message' => 'Task updated successfully',
                'task'   => $task
            ], 200);
        } catch (\Throwable $th) {
            return response()->json([
                'status' => false,
                'message' => 'Something went wrong',
                'error' => $th->getMessage()
            ], 500);
        }
    }
}
