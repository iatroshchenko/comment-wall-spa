<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Comment extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'reply_to',
        'user_id',
        'body'
    ];

    public function replies()
    {
        return $this->hasMany(Comment::class, 'reply_to', 'id');
    }

    public function replyTo()
    {
        return $this->belongsTo(Comment::class, 'reply_to', 'id');
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id', 'id');
    }
}
