"""Matte a single still image with RVM, save RGBA PNG."""
import sys, torch, cv2, numpy as np
from PIL import Image

SRC, OUT = sys.argv[1], sys.argv[2]
device = "mps" if torch.backends.mps.is_available() else "cpu"
print(f"device={device}", flush=True)

model = torch.hub.load("PeterL1n/RobustVideoMatting", "mobilenetv3").to(device).eval()
bgr = cv2.imread(SRC)
rgb = cv2.cvtColor(bgr, cv2.COLOR_BGR2RGB).astype(np.float32) / 255.0
ten = torch.from_numpy(rgb).permute(2,0,1).unsqueeze(0).to(device)
rec = [None]*4

with torch.no_grad():
    # Warm up the recurrent state with a few passes for stability
    for _ in range(2):
        fgr, pha, *rec = model(ten, *rec, 0.4)

fgr = fgr.clamp(0,1)[0].permute(1,2,0).cpu().numpy()
pha = pha.clamp(0,1)[0,0].cpu().numpy()
rgba = np.concatenate([fgr, pha[..., None]], axis=2)
rgba_u8 = (rgba * 255).astype(np.uint8)
Image.fromarray(rgba_u8, "RGBA").save(OUT)
print(f"saved {OUT}", flush=True)
