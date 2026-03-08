# Int64.pro — сайт-визитка

Минималистичный статический сайт на [Eleventy](https://www.11ty.dev/). Контент редактируется в Markdown и JSON.

## Требования

- [Node.js](https://nodejs.org/) (LTS достаточно)

## Локальный просмотр (localhost)

```bash
./serve.sh
```

Откройте в браузере: **http://localhost:8080**

При первом запуске скрипт установит зависимости (`npm install`) и запустит Eleventy в режиме разработки с автоперезагрузкой.

## Деплой на GitHub Pages

### Вариант A: сайт по адресу `https://<username>.github.io/site/`

```bash
GITHUB_PAGES=1 ./deploy.sh
```

Сайт будет доступен по ссылке вида `https://nedimonvam.github.io/site/`.

### Вариант B: кастомный домен (int64.ru, int64.pro и т.д.)

1. В настройках репозитория GitHub: **Settings → Pages → Custom domain** укажите домен (например `int64.ru`).
2. У регистратора домена настройте DNS: CNAME на `<username>.github.io` или A-записи на IP GitHub (см. [документацию GitHub Pages](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site)).
3. Деплой **обязательно** с флагом для корневых путей:

```bash
CUSTOM_DOMAIN=1 ./deploy.sh
```

Иначе ссылки и стили будут вести на `/site/...` и сломаются на кастомном домене.

4. **Источник сайта должен быть ветка `gh-pages`.** В **Settings → Pages → Build and deployment**: Source = **Deploy from a branch**, Branch = **gh-pages**, Folder = **/ (root)**. Если выбрана ветка `main` — будет 404, т.к. сборка пушится в `gh-pages`.

При первом запуске `deploy.sh` установит зависимости, соберёт сайт (`npm run build`) и отправит содержимое папки `_site` в ветку `gh-pages`. При `CUSTOM_DOMAIN=1` в корень публикации автоматически добавляется файл **CNAME** с доменом (по умолчанию `int64.ru`; другой домен: `CUSTOM_DOMAIN_NAME=example.com CUSTOM_DOMAIN=1 ./deploy.sh`), иначе GitHub Pages перестаёт отдавать сайт по кастомному домену. Обновление сайта занимает обычно 1–2 минуты.

**Если 404 на кастомном домене (int64.ru):**
- Откройте https://nedimonvam.github.io/site/ — если там сайт есть, контент задеплоен.
- В репозитории **Settings → Pages**: Source = **gh-pages** (не main), Custom domain = **int64.ru**.
- Проверьте DNS: для int64.ru должна быть CNAME на `nedimonvam.github.io` или A-записи на IP GitHub.

**Авторизация Git:** для пуша в GitHub нужен доступ к репозиторию. Если видите ошибку «could not read Username» при `./deploy.sh`, выполните деплой в терминале, где уже настроен доступ (например `gh auth login` или SSH-ключи), либо переключите remote на SSH: `git remote set-url origin git@github.com:USER/REPO.git`.

## Языки (DE / EN)

Сайт доступен на **немецком** (по умолчанию, корень `/`) и **английском** (префикс `/en/`). В футере каждой страницы есть переключатель **EN** / **DE**.

- Немецкий: `/`, `/impressum/`, `/datenschutz/`, `/eagle-security/`
- Английский: `/en/`, `/en/impressum/`, `/en/privacy/`, `/en/eagle-security/`

## Структура проекта

- **content/de/** и **content/en/** — страницы в Markdown по локалям (главная, Impressum, Datenschutz, Projekte/Projects).
- **_data/strings.json** — подписи навигации и переключателя языка для DE и EN.
- **_data/projects.json** — список проектов; для каждого можно задать `description_de`, `description_en`, `linkLabel_de`, `linkLabel_en`.
- **_includes/** — шаблоны (layout, главная, страница, проекты).
- **assets/css/style.css** — стили (моноширинный шрифт, зелёный по чёрному).
- **assets/logos/** — логотипы проектов. Для Eagle Security добавьте файл `eagle-security.png` (рекомендуемый размер 128×128 или 256×256 px).

## Редактирование контента

- Текст главной, Impressum, Datenschutz, проектов: файлы в **content/de/** и **content/en/** (по одному на страницу и язык).
- Подписи навигации: **_data/strings.json**
- Список проектов: **_data/projects.json** (поля: id, title, description_de, description_en, link, logo, linkLabel_de, linkLabel_en)

После правок локально проверьте через `./serve.sh`, затем закоммитьте и при необходимости снова запустите `./deploy.sh`.
