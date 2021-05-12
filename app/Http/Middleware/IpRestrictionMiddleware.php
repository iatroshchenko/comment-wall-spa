<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class IpRestrictionMiddleware
{
    public array $restrictIps = [
        '161.35.213.148'
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
        if (in_array($request->ip(), $this->restrictIps)) {

            return response()->json(['you don\'t have permission to access this application.']);
        }

        return $next($request);
    }
}
