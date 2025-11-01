#!/usr/bin/env python3

import os
import re

import requests

# GITHUB_TOKEN should be a classic token with repo scope
GITHUB_TOKEN = os.environ.get("GITHUB_TOKEN")
if GITHUB_TOKEN is None:
    print("GITHUB_TOKEN envvar is required")
    exit()

pattern = re.compile(r'<(.*)>; rel="next"')
url = "https://api.github.com/user/starred?per_page=100"
page = 1
repo_list: list[str] = []

while True:
    print(f"Downloading page {page}...")
    page = page + 1
    r = requests.get(
        url,
        headers={
            "Accept": "application/vnd.github+json",
            "Authorization": f"Bearer {GITHUB_TOKEN}",
            "X-GitHub-Api-Version": "2022-11-28",
        },
    )
    if not r.ok:
        print("Something went wrong")
        exit()

    repo_list.extend([obj["full_name"] for obj in r.json()])

    link_header: str | None = r.headers.get("Link")
    if link_header:
        next = pattern.search(link_header)
    else:
        next = None

    if not next:
        break
    else:
        url = next.group(1)

for repo in repo_list:
    r = requests.delete(
        f"https://api.github.com/user/starred/{repo}",
        headers={
            "Accept": "application/vnd.github+json",
            "Authorization": f"Bearer {GITHUB_TOKEN}",
            "X-GitHub-Api-Version": "2022-11-28",
        },
    )

    if r.ok:
        print(f"Unstarred {repo}")
    else:
        print("Something went wrong")
        exit()
