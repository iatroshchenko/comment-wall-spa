<?php


namespace App\Services;


use App\Http\Requests\Comments\SubmitCommentRequest;
use App\Models\Comment;

class CommentService
{
    public function createCommentFromRequest(SubmitCommentRequest $request): Comment
    {
        $comment = Comment::create([
            'body' => $request->input('body'),
            'name' => $request->input('name'),
            'user_id' => auth()->user()->id,
            'reply_to' => $request->input('reply_to')
        ]);

        return $comment;
    }
}
