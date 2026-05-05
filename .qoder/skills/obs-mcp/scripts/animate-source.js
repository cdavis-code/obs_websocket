// animate-source.js
// Reusable corner-tour animation with `easeOutBounce` at each stop.
// Paste into the `execute` tool's `code` parameter and edit the CONFIG block.
//
// IMPORTANT:
//   - Timing is client-paced with setTimeout. Do NOT use obs_general_sleep — it sleeps
//     on the server and will not pace a JS loop on the client side.
//   - Positions move the TOP-LEFT of the source. To move the MID-POINT of the source
//     to a target (tx, ty), set target = (tx - width/2, ty - height/2).
//   - The original transform is captured up front and restored in `finally`.

// ---------- CONFIG ----------
const sourceName   = 'Follow Test';  // the scene item to animate
const totalMs      = 8000;           // total animation duration
const cornerOrder  = ['tr', 'br', 'bl', 'tl']; // top-right, bottom-right, bottom-left, top-left
// Optionally override the canvas size; otherwise read from OBS:
let canvasW = null;
let canvasH = null;
// ----------------------------

// Resolve current scene + item
const scenesInfo = await call_tool('obs_scenes_list', {});
const sceneName  = scenesInfo.currentProgramSceneName;
const { sceneItemId } = await call_tool('obs_scene_items_get_id', {
  sceneName, sourceName,
});

// Capture transform + canvas dimensions
const { sceneItemTransform: original } = await call_tool(
  'obs_scene_items_get_transform',
  { sceneName, sceneItemId },
);

if (canvasW == null || canvasH == null) {
  const video = await call_tool('obs_canvas_get_video_settings', {});
  canvasW = video.baseWidth  ?? 1920;
  canvasH = video.baseHeight ?? 1080;
}

const width  = original.width  ?? original.sourceWidth  ?? 0;
const height = original.height ?? original.sourceHeight ?? 0;

// Target mid-point coordinates for each corner → convert to top-left
const midPoint = {
  tl: { x: 0,        y: 0        },
  tr: { x: canvasW,  y: 0        },
  br: { x: canvasW,  y: canvasH  },
  bl: { x: 0,        y: canvasH  },
};
const toTopLeft = (m) => ({ x: m.x - width / 2, y: m.y - height / 2 });

// Build leg list: current → corners (in order) → current
const start = { x: original.positionX, y: original.positionY };
const legs  = [];
let from = start;
for (const c of cornerOrder) {
  const to = toTopLeft(midPoint[c]);
  legs.push({ from, to });
  from = to;
}
legs.push({ from, to: start }); // return home

const legMs  = Math.floor(totalMs / legs.length);
const fps    = 60;
const frameMs = Math.floor(1000 / fps);

// Easing: easeOutBounce (Robert Penner)
function easeOutBounce(t) {
  const n1 = 7.5625, d1 = 2.75;
  if (t < 1 / d1)          return n1 * t * t;
  if (t < 2 / d1)          return n1 * (t -= 1.5  / d1) * t + 0.75;
  if (t < 2.5 / d1)        return n1 * (t -= 2.25 / d1) * t + 0.9375;
  /* else */               return n1 * (t -= 2.625 / d1) * t + 0.984375;
}

async function setPos(x, y) {
  await call_tool('obs_scene_items_set_transform', {
    sceneName, sceneItemId,
    sceneItemTransform: { positionX: x, positionY: y },
  });
}

try {
  for (const leg of legs) {
    const legStart = Date.now();
    // eslint-disable-next-line no-constant-condition
    while (true) {
      const elapsed  = Date.now() - legStart;
      const progress = Math.min(elapsed / legMs, 1);
      const eased    = easeOutBounce(progress);
      const x = leg.from.x + (leg.to.x - leg.from.x) * eased;
      const y = leg.from.y + (leg.to.y - leg.from.y) * eased;
      await setPos(x, y);
      if (progress >= 1) break;
      await new Promise(r => setTimeout(r, frameMs));
    }
  }
} finally {
  // Always restore the original transform, even on error.
  await call_tool('obs_scene_items_set_transform', {
    sceneName, sceneItemId,
    sceneItemTransform: {
      positionX: original.positionX,
      positionY: original.positionY,
      rotation:  original.rotation,
      scaleX:    original.scaleX,
      scaleY:    original.scaleY,
    },
  });
}

return { sceneName, sceneItemId, durationMs: totalMs, corners: cornerOrder };
