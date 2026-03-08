#!/usr/bin/env bash
# Deploy built site to GitHub Pages (gh-pages branch).
# For custom domain (e.g. int64.ru, int64.pro) run: CUSTOM_DOMAIN=1 ./deploy.sh
# For GitHub Pages at https://<user>.github.io/site/ run: ./deploy.sh (or GITHUB_PAGES=1)
set -e
cd "$(dirname "$0")"

if ! command -v node >/dev/null 2>&1; then
  echo "Node.js is required. Install from https://nodejs.org/"
  exit 1
fi

if [ ! -d "node_modules" ]; then
  echo "Installing dependencies..."
  npm install
fi

# Get repo URL and convert GitHub HTTPS to SSH for push
REPO=$(git config --get remote.origin.url 2>/dev/null || true)
if [[ -n "$REPO" && "$REPO" =~ ^https://github\.com/([^/]+)/([^/.]+)(\.git)?$ ]]; then
  REPO="git@github.com:${BASH_REMATCH[1]}/${BASH_REMATCH[2]}.git"
fi

# Custom domain (int64.ru etc.) = no pathPrefix. Otherwise repo "site" = pathPrefix /site for *.github.io/site/
if [[ -n "$CUSTOM_DOMAIN" ]]; then
  export GITHUB_PAGES=
  echo "Building for custom domain (no pathPrefix)"
elif [[ -n "$GITHUB_PAGES" ]]; then
  export GITHUB_PAGES=1
  echo "Building with pathPrefix /site/ for *.github.io/site/"
elif [[ -n "$REPO" && ("$REPO" =~ /site\.git$ || "$REPO" =~ /site$) ]]; then
  export GITHUB_PAGES=1
  echo "Building with pathPrefix /site/ for *.github.io/site/"
fi

# Clean output so removed pages (e.g. old projekte/) don't persist
rm -rf _site
npm run build

# GitHub Pages requires CNAME in the root of gh-pages for custom domain. Pushing only _site would remove it.
if [[ -n "$CUSTOM_DOMAIN" ]]; then
  echo "${CUSTOM_DOMAIN_NAME:-int64.ru}" > _site/CNAME
  echo "Added CNAME for custom domain."
fi

echo "Clearing gh-pages cache (avoids 'branch gh-pages already exists')..."
node -e "try { require('gh-pages').clean(); } catch (e) {}"
rm -rf node_modules/.cache/gh-pages 2>/dev/null || true

REPO_FLAG=""
if [[ -n "$REPO" ]]; then
  REPO_FLAG="-r $REPO"
fi

echo "Pushing _site to gh-pages branch..."
npx gh-pages -d _site -f $REPO_FLAG

echo "Done. Site will be live in a minute (GitHub Pages or your custom domain)."
