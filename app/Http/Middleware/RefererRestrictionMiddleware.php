<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class RefererRestrictionMiddleware
{
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
            $sameOrigin = $_SERVER["HTTP_SEC_FETCH_SITE"] ?? null;
            if (!$sameOrigin || $sameOrigin !== 'same-origin') {
                return response()->json(['you don\'t have permission to access this application.']);
            }
        }

        return $next($request);
    }
}
