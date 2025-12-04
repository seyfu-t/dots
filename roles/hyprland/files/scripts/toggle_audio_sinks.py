#!/usr/bin/env python3
import json
import subprocess
import sys

DEVICES = {
    "headset": {
        "match": "HyperX Virtual Surround Sound",
        "profile": "output:iec958-stereo+input:iec958-stereo",
    },
    "speaker": {
        "match": "Z Cinéma",
        "profile": "pro-audio",
    },
}


def run(cmd: list[str]) -> str:
    return subprocess.check_output(cmd, text=True)


def load_devices() -> list[dict]:
    data = run(["pw-dump"])
    objs = json.loads(data)
    devices: list[dict] = []
    for o in objs:
        if o.get("type") != "PipeWire:Interface:Device":
            continue
        props = o.get("info", {}).get("props", {}) or {}
        if props.get("media.class") == "Audio/Device":
            devices.append(o)
    return devices


def find_device(devices: list[dict], match: str) -> dict:
    for d in devices:
        props = d.get("info", {}).get("props", {}) or {}
        desc = props.get("device.description", "") or ""
        nick = props.get("device.nick", "") or ""
        if match in desc or match in nick:
            return d
    sys.exit(f"Device with description/nick containing {match!r} not found")


def get_active_profile_name(dev: dict) -> str | None:
    params = dev.get("info", {}).get("params", {}) or {}
    profiles = params.get("Profile") or []
    if not profiles:
        return None
    return profiles[0].get("name")


def find_profile_index(dev: dict, profile_name: str) -> int:
    params = dev.get("info", {}).get("params", {}) or {}
    enum = params.get("EnumProfile") or []
    for p in enum:
        if p.get("name") == profile_name:
            return p["index"]
    available = [p.get("name") for p in enum]
    sys.exit(
        f"Profile {profile_name!r} not found on device id={dev.get('id')} "
        f"(available: {available})"
    )


def set_profile(dev: dict, profile_name: str, save: bool = True) -> None:
    idx = find_profile_index(dev, profile_name)
    args = [
        "pw-cli",
        "s",
        str(dev["id"]),
        "Profile",
        f"{{ index: {idx}, save: {'true' if save else 'false'} }}",
    ]
    subprocess.run(args, check=True)


def main() -> None:
    devices = load_devices()

    headset = find_device(devices, DEVICES["headset"]["match"])
    speaker = find_device(devices, DEVICES["speaker"]["match"])

    headset_active = get_active_profile_name(headset)

    if headset_active == DEVICES["headset"]["profile"]:
        set_profile(headset, "off")
        set_profile(speaker, DEVICES["speaker"]["profile"])
    else:
        set_profile(speaker, "off")
        set_profile(headset, DEVICES["headset"]["profile"])


if __name__ == "__main__":
    main()
