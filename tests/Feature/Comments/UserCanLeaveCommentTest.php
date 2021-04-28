<?php

namespace Tests\Feature\Comments;

use App\Http\Requests\Comments\SubmitCommentRequest;
use App\Models\User;
use App\Services\CommentService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Illuminate\Support\Facades\Auth;
use Tests\TestCase;

class UserCanLeaveCommentTest extends TestCase
{
    use RefreshDatabase;

    /**
     * A basic feature test example.
     *
     * @return void
     */
    public function test_success()
    {
        $user = User::factory()->create();

        Auth::shouldReceive('user')
            ->once()
            ->andReturn($user);

        $validRequestData = [
            'body' => 'This is comment body'
        ];

        $submitCommentRequest = new SubmitCommentRequest($validRequestData);

        $commentService = app(CommentService::class);
        $commentCreated = $commentService->createCommentFromRequest($submitCommentRequest);

        $this->assertEquals($validRequestData['body'], $commentCreated->body);
        $this->assertEquals($user->id, $commentCreated->user_id);
    }
}
