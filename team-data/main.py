import cairosvg
import requests

from enum import Enum, auto
import json
from pathlib import Path
import plistlib

BASE_PATH = Path("build")
LOGO_XCASSET_PATH = BASE_PATH / "Logos.xcassets"
ASSET_INFO = {"info": {"version": 1, "author": "xcode"}}


class League(Enum):
    NHL = auto()
    MLB = auto()

    @property
    def teams_url(self):
        return {
            League.NHL: "https://statsapi.web.nhl.com/api/v1/teams?fields=abbreviation,teams,teamName,id,name",
            League.MLB: "https://statsapi.mlb.com/api/v1/teams?fields=abbreviation,teams,teamName,id,name&sportIds=1",
        }[self]

    def logo_variants(self, id):
        # return [("light", self.light_logo_url(id)), ("dark", self.dark_logo_url(id))]
        return [("dark", self.dark_logo_url(id))]

    def light_logo_url(self, id):
        return {
            League.NHL: f"https://www-league.nhlstatic.com/images/logos/teams-current-primary-light/{id}.svg",
            League.MLB: f"https://www.mlbstatic.com/team-logos/team-cap-on-light/{id}.svg",
        }[self]

    def dark_logo_url(self, id):
        return {
            League.NHL: f"https://www-league.nhlstatic.com/images/logos/teams-current-primary-dark/{id}.svg",
            League.MLB: f"https://www.mlbstatic.com/team-logos/team-cap-on-dark/{id}.svg",
        }[self]


def team_data(league: League):
    print(f"Generating {league.name} team logos and name data")
    teams_response = requests.get(league.teams_url)
    teams = sorted(teams_response.json()["teams"], key=lambda t: t["name"])

    for team in teams:
        print(f" {team['name']} ({team['abbreviation']})")
        make_imageset(league, team)
        del team["id"]
        team["league"] = league.name

    write_asset_contents(
        LOGO_XCASSET_PATH / league.name,
        {
            **ASSET_INFO,
            "properties": {"provides-namespace": True},
        },
    )

    make_plist(league, teams)
    print(f"Finished generating {league.name} team logos and name data\n")


def make_imageset(league: League, team):
    team_name, id = team["teamName"], team["id"]
    filename_prefix = team_name.lower().replace(" ", "-")
    imageset_path = LOGO_XCASSET_PATH / league.name / (filename_prefix + ".imageset")
    imageset_path.mkdir(parents=True, exist_ok=True)

    images = []
    for kind, url in league.logo_variants(id):
        image_path = imageset_path / (filename_prefix + "-" + kind + ".pdf")
        print(f"  Writing {team_name} {kind} logo to {image_path}")
        with open(image_path, "wb") as file:
            cairosvg.svg2pdf(url=url, write_to=file)
        images.append(
            {
                "idiom": "universal",
                "filename": image_path.name,
                # "appearances": [{"appearance": "luminosity", "value": kind}],
            }
        )

    write_asset_contents(
        imageset_path,
        {
            "images": images,
            **ASSET_INFO,
            "properties": {"preserves-vector-representation": True},
        },
    )


def make_plist(league: League, teams):
    plist_path = BASE_PATH / (league.name + "Teams.plist")
    print(f"Writing {league.name} team data ({len(teams)}) to {plist_path}")
    with open(plist_path, "wb") as file:
        plistlib.dump(teams, file)


def write_asset_contents(path, attributes):
    with open(path / "Contents.json", "w") as file:
        json.dump(
            attributes,
            file,
            indent=2,
            separators=(",", " : "),
        )


if __name__ == "__main__":
    for league in League:
        team_data(league)

    write_asset_contents(LOGO_XCASSET_PATH, ASSET_INFO)
