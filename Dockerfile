
FROM python:3.8 as base
WORKDIR /app

RUN pip install poetry==1.7.1 && \
    poetry config virtualenvs.create false


COPY ./poetry.lock /app
COPY ./pyproject.toml /app

RUN --mount=type=cache,target=/root/.cache/pypoetry/cache \
    --mount=type=cache,target=/root/.cache/pypoetry/artifacts \
    poetry install --without dev

COPY . /app


EXPOSE 8080
CMD ["bash"]

FROM base as dev


# for some reason I don't have time to look into,
# installing dev dependencies works on the second try
# so ignore the error on the first on
RUN --mount=type=cache,target=/root/.cache/pypoetry/cache \
    --mount=type=cache,target=/root/.cache/pypoetry/artifacts \
    poetry install  \
    || :

RUN --mount=type=cache,target=/root/.cache/pypoetry/cache \
    --mount=type=cache,target=/root/.cache/pypoetry/artifacts \
    poetry install
