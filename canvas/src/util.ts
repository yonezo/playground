import { Layer } from "./types";

export const getLayerWithinCursor = (
  cursor: [number, number],
  offset: [number, number],
  scale: number,
  layers: Layer[]
) => {
  const normalizedCursor = getNormalizedCursorPosition(cursor, offset, scale);
  return layers.reduce<string[]>((acc, layer) => {
    const rect = getScaledRect(layer, scale);
    if (isCursorWithinRect(normalizedCursor, rect)) {
      acc.push(layer.id);
    }
    return acc;
  }, []);
};

const getScaledRect = (
  rect: { x: number; y: number; width: number; height: number },
  scale: number
): {
  x: number;
  y: number;
  width: number;
  height: number;
} => {
  const { x, y, width, height } = rect;
  return {
    x: getScaledValue(x, scale),
    y: getScaledValue(y, scale),
    width: getScaledValue(width, scale),
    height: getScaledValue(height, scale),
  };
};

const getScaledValue = (value: number, scale: number) => {
  return Math.round(value * scale);
};

const isCursorWithinRect = (
  cursor: [number, number],
  rect: { x: number; y: number; width: number; height: number }
) => {
  const [x, y] = cursor;
  const { x: left, y: top, width, height } = rect;
  return left <= x && x <= left + width && top <= y && y <= top + height;
};

const getNormalizedCursorPosition = (
  cursor: [number, number],
  offset: [number, number],
  scale: number
): [number, number] => {
  const [x, y] = cursor;
  const [offsetX, offsetY] = offset;
  const _x = x - offsetX * scale;
  const _y = y - offsetY * scale;
  return [_x, _y];
};
