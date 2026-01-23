FROM rocker/r-ver:4.4.0

# System dependencies for R packages:
# - flex, bison: parser generation for this package
# - libcurl4-openssl-dev, libssl-dev, libxml2-dev: httr, curl, xml2
# - libgit2-dev: gert (for usethis/devtools)
# - libfontconfig1-dev, libfreetype6-dev, libharfbuzz-dev, libfribidi-dev: systemfonts, textshaping
# - libpng-dev, libtiff-dev, libjpeg-dev, libwebp-dev: ragg
# - zlib1g-dev, libicu-dev: various packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    flex bison git pandoc make \
    libcurl4-openssl-dev libssl-dev libxml2-dev \
    libgit2-dev zlib1g-dev libicu-dev \
    libfontconfig1-dev libfreetype6-dev libharfbuzz-dev libfribidi-dev \
    libpng-dev libtiff-dev libjpeg-dev libwebp-dev \
    && rm -rf /var/lib/apt/lists/*

RUN R -e "install.packages(c('Rcpp','R6','data.table','readstata13', \
    'testthat','covr','devtools','roxygen2','remotes'), \
    repos='https://cloud.r-project.org')"

WORKDIR /workspace
CMD ["R"]
