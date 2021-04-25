<?php

namespace App\Http\Controllers\Internal;

use App\Http\Controllers\Controller;
use App\Http\Resources\CommentResource;
use App\Models\Comment;
use Illuminate\Http\Request;

class CommentController extends Controller
{
    public function all()
    {
        $comments = Comment::with([
            'user',
            'replies.replies',
        ])
            ->whereNull('reply_to')
            ->get();

        return response()
            ->json([
                'data' => CommentResource::collection($comments)
            ]);
    }
}
