<?php

namespace App\Http\Requests\Comments;

use Illuminate\Foundation\Http\FormRequest;

class SubmitCommentRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            'reply_to' => [
                'nullable',
                'exists:comments,id'
            ],
            'name' => [
                'nullable',
                'string',
                'max:40'
            ],
            'body' => [
                'required',
                'max:5000',
                'min:1'
            ]
        ];
    }
}
