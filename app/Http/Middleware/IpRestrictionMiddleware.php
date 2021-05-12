<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class IpRestrictionMiddleware
{
    public array $allowedReferers = [
        'comment-wall.iatroshchenko.dev'
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

            $filtered = array_filter($this->allowedReferers, function ($item) use ($referer) {
                return str_contains($referer, $item);
            });

            if (count($filtered) === 0) {
                return response()->json(['you don\'t have permission to access this application.']);
            }
        }

        return $next($request);
    }
}
