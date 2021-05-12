<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Internal\UserController;
use App\Http\Controllers\Internal\CommentController;

Route::get('userinfo', [
    UserController::class,
    'userinfo'
])->name('userinfo');

Route::get('comments', [
    CommentController::class,
    'all'
])
    ->name('comments.all')
    ->middleware([
        'auth',
        'referer'
    ]);

Route::post('comments', [
    CommentController::class,
    'submit'
])
    ->name('comments.submit')
    ->middleware('auth');
