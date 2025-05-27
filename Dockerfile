FROM pandoc/extra

# Installs latest Chromium (100) package.
RUN apk add --no-cache \
    git \
    bash \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    nodejs \
    npm

RUN npm install --global mermaid-filter@latest pandoc-plantuml

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Puppeteer v13.5.0 works with Chromium 100.
RUN npm install puppeteer@13.5.0

# Instalacja szablonu Eisvogel
RUN mkdir -p /root/.pandoc/templates/ && \
    wget https://github.com/Wandmalfarbe/pandoc-latex-template/releases/latest/download/Eisvogel.tar.gz && \
    tar -xvzf Eisvogel.tar.gz && \
    mv eisvogel.tex /root/.pandoc/templates/ && \
    rm Eisvogel.tar.gz

# Add user so we don't need --no-sandbox.
RUN addgroup -S pptruser && adduser -S -G pptruser pptruser \
    && mkdir -p /home/pptruser/Downloads /app \
    && chown -R pptruser:pptruser /home/pptruser \
    && chown -R pptruser:pptruser /app

# Run everything after as non-privileged user.
USER pptruser
