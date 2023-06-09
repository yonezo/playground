import { useEffect, useRef, useState } from "react";
import {
  createUseGesture,
  moveAction,
  pinchAction,
  wheelAction,
} from "@use-gesture/react";
import { LAYERS } from "./layers";
import { Header } from "./Header";
import { Sidebar } from "./Sidebar";
import { Guide } from "./Guide";
import { getLayerWithinCursor } from "./util";

const useGesture = createUseGesture([pinchAction, moveAction, wheelAction]);

const WHEEL_SCALE_FACTOR = 1500;

const clamp = (min: number, max: number, value: number) =>
  Math.min(Math.max(value, min), max);

const MIN_ZOOM = 0.1;
const MAX_ZOOM = 10;

function App() {
  const ref = useRef<HTMLDivElement | null>(null);
  const [rawOffset, setRawOffset] = useState<[number, number]>([0, 0]);
  const [zoomFactor, setZoomFactor] = useState(1);
  const [canvasSize, setCanvasSize] = useState<{
    width: number;
    height: number;
  }>({ width: 0, height: 0 });
  const [cursor, setCursor] = useState<[number, number]>([0, 0]);
  const [selectingLayerIds, setSelectingLayerIds] = useState<string[]>([]);

  useEffect(() => {
    if (ref.current) {
      setCanvasSize({
        width: ref.current.clientWidth,
        height: ref.current.clientHeight,
      });
    }
  }, [ref]);

  const scaleZoomFactor = (scale: number) => {
    const prevZoomFactor = zoomFactor;
    const scaleZoom = zoomFactor * scale;
    const newZoomFactor = clamp(MIN_ZOOM, MAX_ZOOM, scaleZoom);
    setZoomFactor(newZoomFactor);
    return newZoomFactor / prevZoomFactor;
  };

  const scaleTo = (newZoomFactor: number, center: [number, number]) =>
    scale(newZoomFactor / zoomFactor, center);

  const scale = (scale: number, center: [number, number]) => {
    const newScale = scaleZoomFactor(scale);
    addOffset([
      (newScale - 1) * (center[0] + rawOffset[0]),
      (newScale - 1) * (center[1] + rawOffset[1]),
    ]);
  };

  const addOffset = (offset: [number, number]) => {
    setRawOffset(([x, y]) => [x + offset[0], y + offset[1]]);
  };

  useGesture(
    {
      onWheel: ({
        event: { deltaY, clientX, clientY },
        ctrlKey,
        metaKey,
        delta,
      }) => {
        if (ctrlKey || metaKey) {
          // pinch
          const scaleDelta = ctrlKey ? 15 : 1;
          const dScale = (metaKey ? -deltaY : deltaY) * scaleDelta;
          scaleTo(zoomFactor - dScale / WHEEL_SCALE_FACTOR, [clientX, clientY]);
        } else {
          addOffset([delta[0], delta[1]]);
        }
      },
      onClick: () => {
        const x = -rawOffset[0] / _scale;
        const y = -rawOffset[1] / _scale;
        const selectingLayerIds = getLayerWithinCursor(
          cursor,
          [x, y],
          zoomFactor,
          Object.values(LAYERS)
        );
        setSelectingLayerIds(selectingLayerIds);
      },
      onMove: (state) => {
        setCursor(state.xy);
      },
    },
    {
      target: ref,
      eventOptions: { passive: false, capture: false },
      wheel: { preventDefault: true },
    }
  );

  const _scale = 1 * zoomFactor;
  const x = -rawOffset[0] / _scale;
  const y = -rawOffset[1] / _scale;

  return (
    <div style={{ width: "100vw", height: "100vh", touchAction: "none" }}>
      <Header />
      <Sidebar />
      <div
        ref={ref}
        style={{
          position: "fixed",
          inset: 0,
          background: "transparent",
          overflow: "hidden",
          touchAction: "none",
        }}
      >
        {selectingLayerIds.map((id) => {
          const layer = LAYERS[id];
          return (
            <Guide
              key={id}
              minX={layer.x}
              minY={layer.y}
              maxX={layer.x + layer.width}
              maxY={layer.y + layer.height}
              offsetX={x}
              offsetY={y}
              scale={_scale}
              canvasWidth={canvasSize.width}
              canvasHeight={canvasSize.height}
            />
          );
        })}
      </div>
      <div style={{ pointerEvents: "none" }}>
        <div
          style={{
            position: "fixed",
            left: 0,
            top: 0,
            width: 0,
            height: 0,
            willChange: "transform",
            transform: `scale(${_scale}) translate(${x}px,${y}px)`,
            isolation: "isolate",
            zIndex: -1,
          }}
        >
          {Object.values(LAYERS).map((layer) => (
            <div
              key={layer.id}
              style={{
                position: "absolute",
                background: layer.backgroundColor,
                width: layer.width,
                height: layer.height,
                top: layer.y,
                left: layer.x,
              }}
            />
          ))}
        </div>
      </div>
    </div>
  );
}

export default App;
