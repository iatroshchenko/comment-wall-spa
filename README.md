<p align="center">
    Built on top of
</p>

<p align="center"><a href="https://laravel.com" target="_blank"><img src="https://raw.githubusercontent.com/laravel/art/master/logo-lockup/5%20SVG/2%20CMYK/1%20Full%20Color/laravel-logolockup-cmyk-red.svg" width="400"></a></p>

## Pipeline Steps

1. npm install and compile assets
2. dev environment pull images (docker-compose pull --include-deps)
3. dev environment build --pull
4. libraries (from lib environment)
5. dev environment up
6. dev run migrations 
7. CI -- unit tests
8. destroy dev environment
9. Test environment - pull images
10. Build production images (to run them on test environment)
11. Start test environment
12. test environment - run migrations
13. Run Laravel Dusk
14. Destroy Test environment
15. Deploy
