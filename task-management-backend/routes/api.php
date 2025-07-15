<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

// user routes
Route::prefix('user')->group(function() {
    Route::post('/login', [App\Http\Controllers\Api\User\AuthController::class, 'login']);
    Route::post('/logout', [App\Http\Controllers\Api\User\AuthController::class, 'logout']);

    // make group for auth routes for user
    Route::middleware('auth:sanctum')->group(function() {
        Route::get('/', [App\Http\Controllers\Api\User\UserController::class, 'show']);

        Route::get('/list', [App\Http\Controllers\Api\User\UserController::class, 'index']);

        Route::prefix('tasks')->group(function() {
            Route::get('/', [App\Http\Controllers\Api\User\TaskController::class, 'index']);
            Route::post('/create', [App\Http\Controllers\Api\User\TaskController::class, 'store']);
            Route::patch('/update/{task}', [App\Http\Controllers\Api\User\TaskController::class, 'update']);
        });

        Route::prefix('comments')->group(function() {
            Route::get('/', [App\Http\Controllers\Api\User\CommentController::class, 'index']);
            Route::post('/create', [App\Http\Controllers\Api\User\CommentController::class, 'store']);
        });
    });
});

