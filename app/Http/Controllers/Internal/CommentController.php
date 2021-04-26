<?php

namespace App\Http\Controllers\Internal;

use App\Http\Controllers\Controller;
use App\Http\Requests\Comments\SubmitCommentRequest;
use App\Http\Resources\CommentResource;
use App\Models\Comment;
use App\Traits\Controllers\SendsEmptyResponse;
use Illuminate\Http\Request;

class CommentController extends Controller
{
    use SendsEmptyResponse;

    public function all()
    {
        $comments = Comment::with([
            'user',
            'replies' => function ($query) {
                $query->orderByDesc('id');
            },
            'replies.replies' => function ($query) {
                $query->orderByDesc('id');
            },
        ])
            ->orderByDesc('id')
            ->whereNull('reply_to')
            ->get();

        return response()
            ->json([
                'data' => CommentResource::collection($comments)
            ]);
    }

    public function submit(SubmitCommentRequest $request)
    {
        $comment = Comment::create([
            'body' => $request->input('body'),
            'name' => $request->input('name'),
            'user_id' => auth()->user()->id,
            'reply_to' => $request->input('reply_to')
        ]);

        return $this->sendEmptyTrueResponse('created');
    }
}
