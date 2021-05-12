<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class IpRestrictionMiddleware
{
    public array $allowedIps = [
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
        $requestHost = parse_url($request->headers->get('origin'),  PHP_URL_HOST);

        $requestInfo = [
            'host' => $requestHost,
            'ip' => $request->getClientIp(),
            'url' => $request->getRequestUri(),
            'agent' => $request->header('User-Agent'),
            'forwarded-for' => $request->header('X-Forwarded-For')
        ];

        dump($requestInfo);

        dd($_SERVER);

        if (!in_array($request->ip(), $this->allowedIps)) {
            return response()->json(['you don\'t have permission to access this application.']);
        }

        return $next($request);
    }
}
