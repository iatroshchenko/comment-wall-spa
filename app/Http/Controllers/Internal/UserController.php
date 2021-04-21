<?php

namespace App\Http\Controllers\Internal;

use App\Http\Controllers\Controller;
use App\Http\Resources\UserResource;
use Illuminate\Http\Request;

class UserController extends Controller
{
    public function userinfo(Request $request)
    {
        $user = auth()->user();

        return response()
            ->json([
                'data' => $user ? new UserResource($user) : null
            ]);
    }
}
