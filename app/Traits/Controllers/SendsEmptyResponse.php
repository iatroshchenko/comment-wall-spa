<?php


namespace App\Traits\Controllers;

use Illuminate\Http\JsonResponse;


trait SendsEmptyResponse
{
    public function sendEmptyResponse(): JsonResponse
    {
        return response()
            ->json([]);
    }

    public function sendEmptyTrueResponse(string $resultDescription): JsonResponse
    {
        return response()->json([
            $resultDescription => true
        ]);
    }

    public function sendCreatedResponse(): JsonResponse
    {
        return $this->sendEmptyTrueResponse('created');
    }

    public function sendUpdatedResponse(): JsonResponse
    {
        return $this->sendEmptyTrueResponse('updated');
    }

    public function sendDeletedResponse(): JsonResponse
    {
        return $this->sendEmptyTrueResponse('deleted');
    }
}
