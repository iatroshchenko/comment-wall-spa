<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Internal\UserController;

Route::name('internal.')->group(function () {
    Route::get('userinfo', [
        UserController::class,
        'userinfo'
    ])->name('userinfo');
});
