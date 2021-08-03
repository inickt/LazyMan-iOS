import requests

import json
from pathlib import Path
import plistlib

BASE_PATH = Path("build")


def nhl_team_data():

    LIGHT_SVG_URL = "https://www-league.nhlstatic.com/images/logos/teams-current-primary-light/{}.svg"
    DARK_SVG_URL = "https://www-league.nhlstatic.com/images/logos/teams-current-primary-dark/{}.svg"

    response = requests.get("https://statsapi.web.nhl.com/api/v1/teams")
    json_teams = response.json()["teams"]

    teams = []
    for team in json_teams:
        name = team["name"]
        team_name = team["teamName"]
        abbreviation = team["abbreviation"]
        id = team["id"]
        teams.append(
            {
                "name": name,
                "teamName": team_name,
                "abbreviation": abbreviation,
                "league": "NHL",
            }
        )

        filename_prefix = team_name.lower().replace(" ", "-")
        print(f"{name=}\n{team_name=}\n{abbreviation=}\n{filename_prefix=}")

        nhl_path = BASE_PATH / "NHL"
        imageset_path = nhl_path / (filename_prefix + ".imageset")
        imageset_path.mkdir(parents=True, exist_ok=True)
        for kind, url in [("light", LIGHT_SVG_URL), ("dark", DARK_SVG_URL)]:
            image_path = imageset_path / (filename_prefix + "-" + kind + ".svg")
            print(f"{image_path}")

            image = requests.get(url.format(id))
            with open(image_path, "wb") as file:
                file.write(image.content)
        contents_path = imageset_path / "Contents.json"
        with open(contents_path, "w") as file:
            json.dump(
                {
                    "images": [
                        {
                            "filename": filename_prefix + "-light.svg",
                            "idiom": "universal",
                        },
                        {
                            "appearances": [
                                {"appearance": "luminosity", "value": "dark"}
                            ],
                            "filename": filename_prefix + "-dark.svg",
                            "idiom": "universal",
                        },
                    ],
                    "info": {"author": "xcode", "version": 1},
                    "properties": {"preserves-vector-representation": True},
                },
                file,
                indent=2,
            )

        print()

    teams.sort(key=lambda t: t["name"])
    nhl_plist_path = BASE_PATH / "NHLTeams.plist"
    print(f"Writing NHL team data ({len(teams)}) to {nhl_plist_path}")
    with open(nhl_plist_path, "wb") as file:
        plistlib.dump(teams, file)


if __name__ == "__main__":
    nhl_team_data()
