# ![app logo](https://raw.githubusercontent.com/another-pavels/GroupB-Recepies/main/public/assets/img/logo_med.png) RamsAI Gordon
### Apraksts
Programma, kas ģenerē recepti pēc nejaušības principa, pamatojoties uz lietotāja preferencēm, attiecībā uz sastāvdaļām, ēdieniem un diētas ierobežojumiem.


## [DEMO](https://recipes.us.to/)

## Sistēmas parasības

Sistēma ir izstrādāta, izmantojot [Laravel 10 Framework](https://laravel.com/docs/10.x)
- PHP >= 8.1 with extensions:
  - bcmath
  - ctype
  - fileinfo
  - json
  - mbstring
  - openssl
  - PDO
  - tokenizer
  - xml
- [Composer](https://getcomposer.org/)
- NodeJS & npm package manager
- DB: platforma primāri būvēta ar MySQL/MariaDB atbalstu (iespējams, darbojas arī uz SQL Server, SQLite un PostgreSQL)
- [OpenAI](https://openai.com/blog/openai-api) API atslēga

## Uzstādīšana uz lokālās mašīnas

Vienkāršākais veids uzstādīšanai uz lokālās mašīnas ir ar Laravel Sail... pie nosacījuma, ka Tev ir uzstādīts Docker un WSL (ja lieto Windows 10/11).
- Klonē (vai lejupielādē) šo repozitoriju
- Ieej aplikācijas *root* direktorijā un izveido sistēmas konfigurācijas datni: `cp .env.example .env`
- `composer install`
- `npm install` 
- `npm run dev`
- `bash ./vendor/laravel/sail/bin/sail up -d`
- `bash ./vendor/laravel/sail/bin/sail artisan migrate`
- `bash ./vendor/laravel/sail/bin/sail artisan queue:work`

## Manuālā uzstādīšana produkcijā

- Klonē (vai lejupielādē) šo repozitoriju
- Ieej aplikācijas *root* direktorijā un izveido sistēmas konfigurācijas datni `cp .env.example .env`
-  `composer update`
-  `npm install`
-  `npm run build`
- Iestati šādus parametrus .env datnē:
```
...
debug = false
env = production
app_url
...
DB iestatījumi
...
OpenAI iestatījumi
```
-  `php artisan key:generate`
-  `php artisan migrate`
- Iestati fona darbu apstrādi ar [Cron vai Supervisor](https://laravel.com/docs/10.x/queues#supervisor-configuration)

Lieto atbildīgi!
