"""Record animated slide MP4s using Playwright."""
import asyncio, sys, os, subprocess, shutil
from pathlib import Path
from playwright.async_api import async_playwright

URL = "file:///Users/ziyun/Desktop/llm_video/slides_vertical.html"
OUT = Path("/Users/ziyun/Desktop/llm_slides_v")
TMP = Path("/tmp/slide_records")
TMP.mkdir(exist_ok=True, parents=True)

# (key, total_record_seconds)
SHOTS = [
    ("06_paris",   3.4),
    ("09_attn",    4.0),
    ("13_resend",  4.2),
]

async def record_one(p, key, duration):
    workdir = TMP / key
    if workdir.exists(): shutil.rmtree(workdir)
    workdir.mkdir(parents=True)
    browser = await p.chromium.launch()
    context = await browser.new_context(
        viewport={"width":1080,"height":1080},
        device_scale_factor=1,
        record_video_dir=str(workdir),
        record_video_size={"width":1080,"height":1080},
    )
    page = await context.new_page()
    await page.goto(f"{URL}?export={key}&animate=1")
    # Let the page reach the "start" frame before recording becomes meaningful.
    await page.wait_for_timeout(int(duration * 1000))
    await context.close()
    await browser.close()
    # Find the recorded webm
    webms = list(workdir.glob("*.webm"))
    if not webms:
        print(f"  !! no webm for {key}")
        return None
    webm = webms[0]
    mp4_path = OUT / f"slide_{key}.mp4"
    # Convert webm → mp4 (h264, yuv420p so QuickTime/Descript/most players accept it)
    subprocess.run([
        "ffmpeg","-y","-loglevel","error","-i",str(webm),
        "-c:v","libx264","-pix_fmt","yuv420p","-crf","18","-preset","slow",
        "-movflags","+faststart",
        str(mp4_path)
    ], check=True)
    print(f"  ✓ {mp4_path.name}  ({mp4_path.stat().st_size//1024} KB)")
    return mp4_path

async def main():
    async with async_playwright() as p:
        for key, dur in SHOTS:
            print(f"\nrecording {key} for {dur}s …")
            await record_one(p, key, dur)
    print("\nall done")

asyncio.run(main())
