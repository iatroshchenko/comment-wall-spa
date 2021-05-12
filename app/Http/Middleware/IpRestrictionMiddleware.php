<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class IpRestrictionMiddleware
{
    public array $allowedReferers = [
        'https://comment-wall.iatroshchenko.dev'
    ];

    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle(Request $request, Closure $next)
    {
        if (config('app.env') === 'production') {
            $referer = $request->headers->get('referer');
            if (!in_array($referer, $this->allowedReferers)) {
                return response()->json(['you don\'t have permission to access this application.']);
            }
        }

        return $next($request);
    }
}
