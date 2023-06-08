# ![app logo](https://raw.githubusercontent.com/another-pavels/GroupB-Recepies/main/public/assets/img/logo_med.png) RamsAI Gordon
### Apraksts
Programma, kas ģenerē recepti pēc nejaušības principa, pamatojoties uz lietotāja preferencēm attiecībā uz sastāvdaļām, ēdieniem un diētas ierobežojumiem.
## Sistēmas parasības
Sistēma ir izstrādāta izmantojot [Laravel 10 Framework](https://laravel.com/docs/10.x)
- PHP >= 8.1
- BCMath PHP Extension
- Ctype PHP Extension
- Fileinfo PHP Extension
- JSON PHP Extension
- Mbstring PHP Extension
- OpenSSL PHP Extension
- PDO PHP Extension
- Tokenizer PHP Extension
- XML PHP Extensio
- [Composer](https://getcomposer.org/) - A Dependency Manager for PHP 
- NodeJS (npm package manager)
- MySQL/Maria DB (iespējams, darbojas arī uz SQL Srv, SQL Lite un PostGre)
- [OpenAI](https://openai.com/blog/openai-api) API atslēga
## Uzstādīšana uz lokālās mašīnas
Vienkāršākais veids uzstādīšanai uz lokālās mašīnas ir ar Laravel Sail... pie nosacījuma, ka Tev ir uzstādīts dokeris un WSL, ja lieto Windows.
-   Klonē šo repozitoriju
- ieej aplikācijas root direktorijā un izveido sistēmas konfigurācijas datni `cp .env.example .env`
-   composer install
- npm install 
- npm run dev
-   bash ./vendor/laravel/sail/bin/sail up -d
-   bash ./vendor/laravel/sail/bin/sail artisan migrate
-   bash ./vendor/laravel/sail/bin/sail artisan queue:work
## Manuālā uzstādīšana produkcijā

- Klonē šo repozitoriju
- ieej aplikācijas root direktorijā un izveido sistēmas konfigurācijas datni `cp .env.example .env`
-  `composer update`
-  `npm install`
-  `npm run build`
- Iestatīt šādus parametrus .env datnē:
- debug = false
- env = production
- app_url
- DB iestatījumi
- open AI iestatījumi
-  `php artisan key:generate`
-  `php artisan migrate`
- Iestatīt fona darbu apstrādi ar [Cron vai Supervisor](https://laravel.com/docs/10.x/queues#supervisor-configuration)
- Lieto atbildīgi!
