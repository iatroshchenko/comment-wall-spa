<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class CommentResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array
     */
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'name' => $this->user ? $this->user->name : ($this->name ?: 'Anonymous User'),
            'body' => $this->body,
            'replies' => CommentResource::collection($this->whenLoaded('replies')),
            'when' => $this->created_at->diffForHumans()
        ];
    }
}
